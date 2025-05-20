block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.BufferUtil.* from propath.
using classes.Excel.* from propath.

class classes.Excel.ExcelReportGenerator:
    def public property defaultDecimalFormat as char no-undo init "_-* #.##0,00_-;- #.##0,00_-;_-* ~"-~"??_-;_-@_-" get. set.
    def public property defaultIntFormat as char no-undo init "_-* #.##0_-;- #.##0_-;_-* ~"-~"??_-;_-@_-" get. set.
    def public property defaultDateFormat as char no-undo init "dd/mm/aaaa" get. set.
    def public property defaultDateTimeFormat as char no-undo init "dd/mm/aaaa hh:mm:ss" get. set.
    def public property boldHeader as log init true no-undo get. set.
    
    def private temp-table columnsFormats 
        field colIndex as int 
        field colFormat as char
        index idxCol as primary unique colIndex.
        
    method public ExcelReportGenerator addFormat(pColumn as int, pFormat as char):
        if not findColumnFormat(pColumn) then do:
            create columnsFormats.
        end.
        assign
            columnsFormats.colIndex = pColumn
            columnsFormats.colFormat = pFormat.
        return this-object.    
    end method.
    
    method public Excel parseQuery(pQuery as Query, pPath as char):
        return parseQuery(pQuery, pPath, true).
    end method.
    
    method public Excel parseQuery(pQuery as Query, pPath as char, pUseLabel as log):
        return parseQuery(pQuery, pPath, pUseLabel, 'merge').
    end method.
    
    method public Excel parseQuery(pQuery as Query, pPath as char, pUseLabel as log, pMode as char):
        return parseQuery(pQuery, pPath, pUseLabel, pMode, ?).
    end method.
    
    method public Excel parseQuery(pQuery as Query, pPath as char, pUseLabel as log, pMode as char, pFields as char):
        return parseTable(pQuery:toTable(pMode), pPath, pUseLabel, pFields).
    end method.
    
    method public Excel parseTable(pTable as Table, pPath as char):
        return parseTable(pTable, pPath, true).
    end method.
    
    method public Excel parseTable(pTable as Table, pPath as char, pFields as char):
        return parseTable(pTable, pPath, true, pFields).
    end method.
    
    method public Excel parseTable(pTable as Table, pPath as char, pUseLabel as log):
        return parseTable(pTable, pPath, pUseLabel, ?).
    end method.
    
    method public Excel parseTable(pTable as Table, pPath as char, pUseLabel as log, pFields as char):
        return parseBuffer(pTable:buffer, pPath, pUseLabel, pFields).
    end method.
    
    method public Excel parseBuffer(pBuffer as char, pPath as char):
        return parseBuffer(pBuffer, pPath, true).
    end method.
    
    method public Excel parseBuffer(pBuffer as char, pPath as char, pFields as char):
        return parseBuffer(pBuffer, pPath, true, pFields).
    end method.
    
    method public Excel parseBuffer(pBuffer as char, pPath as char, pUseLabel as log):
        return parseBuffer(pBuffer, pPath, true, ?).
    end method.
    
    method public Excel parseBuffer(pBuffer as char, pPath as char, pUseLabel as log, pFields as char):
        return parseBuffer(new Buffer(pBuffer), pPath, pUseLabel, pFields).
    end method.
    
    method public Excel parseBuffer(pBuffer as Buffer, pPath as char):
        return parseBuffer(pBuffer, pPath, true).
    end method.
    
    method public Excel parseBuffer(pBuffer as Buffer, pPath as char, pUseLabel as log):
        return parseBuffer(pBuffer, pPath, pUseLabel, ?).
    end method.
    
    method public Excel parseBuffer(pBuffer as Buffer, pPath as char, pFields as char):
        return parseBuffer(pBuffer, pPath, true, pFields).
    end method.
    
    method public Excel parseBuffer(pBuffer as Buffer, pPath as char, pUseLabel as log, pFields as char):
        def var xl as Excel no-undo.
        assign xl = new Excel().
        
        if Matcher:contains(pPath, '.') then do:
            assign pPath = Splitter:textBefore(pPath, '.') + '.xlsx'.
        end.
        else do:
            assign pPath = pPath + '.xlsx'.
        end.
        
        xl:createExcel().
        new CSVWriter():parseBuffer(pBuffer, pUseLabel, pFields):writeFile(pPath).
        
        xl:CSVToExcel(replace(pPath, '.xlsx', '.csv')).
        xl:openXML(pPath).
        
        applyFormats(xl, pBuffer).
        xl:autoFitCurrentRegion().
        xl:save().
        return xl.
    end method.
    
    method public Excel generateTableExample(pBuffer as char, pPath as char, pFields as char):
        def var tableCopy as Table no-undo.
        assign tableCopy = new Table().
        tableCopy:addLike(pBuffer, pFields):createBuffer().
        return parseTable(tableCopy, pPath, false).
    end method.
    
    method public Excel generateTableExample(pBuffer as char, pPath as char):
        def var tableCopy as Table no-undo.
        assign tableCopy = new Table(pBuffer).
        tableCopy:createBuffer().
        return parseTable(tableCopy, pPath, false).
    end method.
    
    method protected void applyFormats(pExcel as Excel, pBuffer as Buffer):
        if boldHeader then do:
            def var firstRow as com-handle no-undo.
            assign 
                firstRow = pExcel:row(1)
                firstRow:Font:Bold = true.
        end.
        
        def var currentColumn as com-handle no-undo.
        def var i as int no-undo.
        
        do i = 1 to pExcel:columnsCount():
            assign currentColumn = pExcel:column(i).
            if Matcher:containsOneOf(pBuffer:type(i), 'integer,int64') then do:
                assign currentColumn:NumberFormat = defaultIntFormat.
            end.
            else if Matcher:equal(pBuffer:type(i), 'decimal') then do:
                assign currentColumn:NumberFormat = defaultDecimalFormat.
            end.
            else if Matcher:containsOneOf(pBuffer:type(i), 'datetime,datetime-tz') then do:
                currentColumn:NumberFormat = defaultDateTimeFormat.
            end.
            else if Matcher:equal(pBuffer:type(i), 'date') then do:
                currentColumn:NumberFormat = defaultDateFormat.
            end.
        end.
        
        for each columnsFormats no-lock:
            assign 
                currentColumn = pExcel:column(columnsFormats.colIndex)
                currentColumn:NumberFormat = columnsFormats.colFormat.
        end.
    end method.
    
    method protected log findColumnFormat(pIndex as int):
        find first columnsFormats
            where colIndex = pIndex
            no-error.
        return avail columnsFormats.    
    end method.
end class.
