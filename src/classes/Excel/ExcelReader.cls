block-level on error undo, throw.
using classes.StringUtil.* from propath.    
using classes.BufferUtil.* from propath.
using classes.Excel.* from propath.

class classes.Excel.ExcelReader:
    def public static property tempCSVName as char init 'dG1wLWNzdi1maWxl.csv' no-undo get. set.
    def public static property tempCSVPath as char no-undo
        get:
            return session:temp-directory + tempCSVName.
        end.
    
    method public static Table readExcel(pPath as char):
        return readExcel(pPath, '').
    end method.
    
    method public static Table readExcel(pExcel as Excel):
        return readExcel(pExcel, '').
    end method.
    
    method public static Table readExcel(pPath as char, pTypes as char):
        return readExcel(pPath, 1, pTypes).
    end method.
    
    method public static Table readExcel(pPath as char, pTable as Table):
        return readExcel(pPath, 1, pTable).
    end method.
    
    method public static Table readExcel(pExcel as Excel, pTypes as char):
        return readExcel(pExcel, 1, pTypes).
    end method.
    
    method public static Table readExcel(pExcel as Excel, pTable as Table):
        return readExcel(pExcel, 1, pTable).
    end method.
    
    method public static Table readExcel(pPath as char, pSheet as int):
        return readExcel(pPath, pSheet, '').
    end method.
    
    method public static Table readExcel(pExcel as Excel, pSheet as int):
        return readExcel(pExcel, pSheet, '').
    end method.
    
    method public static Table readExcel(pPath as char, pSheet as int, pTypes as char):
        def var xl as Excel no-undo.
        def var resultTable as Table no-undo.
        assign
            xl = openExcel(pPath)
            resultTable = readExcel(xl, pSheet, pTypes).
        xl:closeAllWorkbooks().
        os-delete value(tempCSVPath) no-error.
        return resultTable.
    end method.
    
    method public static Table readExcel(pPath as char, pSheet as int, pTable as Table):
        def var xl as Excel no-undo.
        def var resultTable as Table no-undo.
        assign 
            xl = openExcel(pPath)
            resultTable = readExcel(xl, pSheet, pTable).
        xl:closeAllWorkbooks().
        os-delete value(tempCSVPath) no-error.
        return resultTable.
    end method.
    
    method protected static Excel openExcel(pPath as char):
        def var xl as Excel no-undo.
        assign xl = new Excel().
        xl:createExcel().
        xl:openXML(pPath).
        return xl.
    end method.
    
    method public static Table readExcel(pExcel as Excel, pSheet as int, pTypes as char):
        if pExcel:workbookCount() = 0 then do:
            return ?.
        end.
        os-delete value(tempCSVPath) no-error.
        def var resultTable as Table no-undo.
        pExcel:getSheet(pSheet).
        pExcel:saveWorkbook(tempCSVPath, 6).
        assign resultTable = CSVReader:readCSV(tempCSVPath, ';', pTypes).
        return resultTable.
    end method.
    
    method public static Table readExcel(pExcel as Excel, pSheet as int, pTable as Table):
        if pExcel:workbookCount() = 0 then do:
            return ?.
        end.
        os-delete value(tempCSVPath) no-error.
        pExcel:getSheet(pSheet).
        pExcel:saveWorkbook(tempCSVPath, 6).
        assign pTable = CSVReader:readCSV(tempCSVPath, ';', pTable).
        return pTable.
    end method.
end class.
