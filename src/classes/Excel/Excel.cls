block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.Excel.* from propath.
using classes.StringUtil.* from propath.

class classes.Excel.Excel:
    define public property excelHandle as com-handle no-undo get. set.
    define public property currentWorkbook as com-handle no-undo 
        get:
            if valid-handle(excelHandle) then do:
                def var h as com-handle no-undo.
                assign h = excelHandle:ActiveWorkbook.
                return h.
            end.
        end.
        
    define public property currentSheet as com-handle no-undo 
        get:
            if currentWorkbook <> ? then do:
                def var h as com-handle no-undo.
                assign h = excelHandle:ActiveSheet.
                return h.
            end.
        end.
    
    constructor Excel():
    end constructor.
    
    method public Excel createExcel():
        create 'Excel.Application' excelHandle.
        assertExcelValidHandle().
        return this-object.
    end method.
    
    method public Excel addWorkbook():
        assertExcelValidHandle().
        excelHandle:Workbooks:Add.
        return this-object.
    end method.
    
    method public log CSVToExcel(pPath as char):
        return CSVToExcel(pPath, true).
    end method.
    
    method public log CSVToExcel(pPath as char, pDeleteCSV as log):   
        do on error undo, throw:
            if Matcher:endsWith(pPath, '.csv') then do:
                openXML(pPath).
                
                def var xlsxPath as char no-undo.
                def var currentCell as com-handle no-undo.
                def var cellValue as char no-undo.
                def var i as int no-undo.
                assign xlsxPath = replace(pPath, '.csv', '.xlsx').
                
                do i = 1 to columnsCount():
                    assign 
                        currentCell = cell(2, i)
                        cellValue = string(currentCell:Value).    
                            
                    if Matcher:startsWith(cellValue, "'") then do:
                        removeColumnSingleQuotes(i).
                    end.
                end.
                
                saveWorkbook(xlsxPath).
                
                if pDeleteCSV then do:
                    os-delete value(pPath).
                end.
                return true.
            end.
            return false.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
    end method.
    
    method public Excel removeColumnSingleQuotes(pColumn as int):
        if not hasSheetValidHandle() then do:
            return this-object.
        end.
        def var xlColumn as com-handle no-undo.
        def var fieldInfo as int extent 2 no-undo.
        assign 
            xlColumn = this-object:column(pColumn)
            fieldInfo[1] = 1
            fieldInfo[2] = 2.
        
        xlColumn:TextToColumns(
            cell(1, pColumn), 1, 2, false, false, false, false, 
            false, false, ?, fieldInfo, ?, ?, true
        ).
        
        return this-object.
    end method.
    
    method public Excel autoFitCurrentRegion():
        if hasSheetValidHandle() then do:
            def var region as com-handle no-undo.
            assign region = currentRegion().
            region:Columns:AutoFit().
        end.
        return this-object.
    end method.
    
    method public com-handle column(pColumn as int):
        if hasSheetValidHandle() then do:
            def var c as com-handle no-undo.
            assign c = currentSheet:Columns(pColumn).
            return c.
        end.
    end method.
    
    method public com-handle row(pRow as int):
        if hasSheetValidHandle() then do:
            def var r as com-handle no-undo.
            assign r = currentSheet:Rows(pRow).
            return r.
        end.
    end method.
    
    method public com-handle cell(pRow as int, pColumn as int):
        if hasSheetValidHandle() then do:
            def var c as com-handle no-undo.
            assign c = currentSheet:Cells(pRow, pColumn).
            return c.
        end.
    end method.
    
    method public int columnsCount():
        if hasSheetValidHandle() then do:
            def var region as com-handle no-undo.
            assign region = currentRegion().
            return region:Columns:Count.
        end.
    end method.
    
    method public int rowsCount():
        if hasSheetValidHandle() then do:
            def var region as com-handle no-undo.
            assign region = currentRegion().
            return region:Rows:Count.
        end.
    end method.
    
    method public com-handle currentRegion():
        if hasSheetValidHandle() then do:
            def var firstCell as com-handle no-undo.
            def var region as com-handle no-undo.
            assign 
                firstCell = cell(1, 1)
                region = firstCell:CurrentRegion.
            return region.
        end.
    end method.
    
    method public char cellValue(pRow as int, pColumn as int):
        if hasSheetValidHandle() then do:
            def var cell as com-handle no-undo.
            def var val as char no-undo.
            assign 
                cell = cell(pRow, pColumn)
                val = cell:Value
                val = if val = ? then '' else val.
            return val.    
        end.
    end method.
    
    method public Excel openXML(pPath as char):
        assertExcelValidHandle().
        excelHandle:Workbooks:OpenXML(pPath).
        return this-object.
    end method.
    
    method public Excel addSheet():
        assertWorkbookValidHandle().
        currentWorkbook:Worksheets:Add.
        return this-object.
    end method.
    
    method protected void assertExcelValidHandle():
        if not hasExcelValidHandle() then do:
            return error new classes.Excel.Errors.ExcelInvalidHandle().
        end.
    end method.
    
    method protected void assertWorkbookValidHandle():
        assertExcelValidHandle().
        if not hasWorkbookValidHandle() then do:
            return error new classes.Excel.Errors.WorkbookInvalidHandle().
        end.
    end method.
    
    method public logical hasExcelValidHandle():
        return valid-handle(excelHandle).
    end method.
    
    method public logical hasWorkbookValidHandle():
        return valid-handle(currentWorkbook).
    end method.
    
    method public logical hasSheetValidHandle():
        return valid-handle(currentSheet).
    end method.
    
    method public Excel releaseExcel():
        release object excelHandle no-error.
        return this-object.
    end method.
    
    method public Excel turnVisible():
        if hasExcelValidHandle() then do:
            excelHandle:Visible = true.
        end.
        return this-object.
    end method.
    
    method public Excel turnInvisible():
        if hasExcelValidHandle() then do:
            assign excelHandle:Visible = false.
        end.
        return this-object.
    end method.
    
    method public int workbookCount():
        if hasWorkbookValidHandle() then do:
            return excelHandle:Workbooks:Count.
        end.
    end method.
    
    method public int sheetCount():
        if hasExcelValidHandle() then do:
            return excelHandle:Worksheets:Count.
        end.
    end method.
    
    method public Excel closeAllWorkbooks():
        if hasWorkbookValidHandle() then do:
            def var i as int no-undo.
            do i = 1 to workbookCount():
                excelHandle:Workbooks:Item(i):Close.
            end.
        end.
    end method.
  
    method public Excel save():
        if hasWorkbookValidHandle() then do:
            currentWorkbook:Save().
        end.
        return this-object.
    end method.
  
    method public Excel saveWorkbook(pPath as character):
        saveWorkbook(pPath, 51).
        return this-object.
    end method.

    method public Excel saveWorkbook(pPath as character, pFileFormat as integer):
        assertWorkbookValidHandle().
        currentWorkbook:SaveAs(pPath, pFileFormat, ?, ?, ?, ?, ?).
        return this-object.
    end method.
    
    method public Excel getWorkbook(pIndex as integer):
        assertExcelValidHandle().
        assertWorkbookIndexInsideRange(pIndex).
        excelHandle:Workbooks:Item(pIndex):Activate.
        return this-object.
    end method.
    
    method public Excel getSheet(pIndex as int):
        assertExcelValidHandle().
        assertSheetIndexInsideRange(pIndex).
        excelHandle:Worksheets:Item(pIndex):Activate.
        return this-object.
    end method.
    
    method public Excel saveAllWorkbooks():
        assertExcelValidHandle().
        
        define variable idx as integer no-undo.
        do idx = 1 to workbookCount():
            excelHandle:Workbooks:Item(idx):Save.
        end.
        
        return this-object.
    end method.
    
    method public char path():
        if hasWorkbookValidHandle() then do:
            def var workbookPath as char no-undo.
            assign 
                workbookPath = currentWorkbook:Path
                workbookPath = if workbookPath = ? then '' else workbookPath.
            return workbookPath.    
        end.
    end method.
    
    method protected void assertWorkbookIndexInsideRange(pIndex as integer):
        assertExcelValidHandle().
        if pIndex > workbookCount() or pIndex < 1 then do:
            return error new classes.Excel.Errors.WorkbookIndexOutsideRange(pIndex, workbookCount()).
        end.
    end method.
    
    method protected void assertSheetIndexInsideRange(pIndex as integer):
        assertWorkbookValidHandle().
        if pIndex > sheetCount() or pIndex < 1 then do:
            return error new classes.Excel.Errors.SheetIndexOutsideRange(pIndex, sheetCount()).
        end.
    end method.
    
    destructor Excel():
        releaseExcel().
    end destructor.
end class.
