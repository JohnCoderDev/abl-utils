block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.BufferUtil.* from propath.

class classes.Excel.CSVReader:
    def public static property defaultSeparator as char init ';' no-undo get. set.
    def public static property defaultCodePage as char init 'iso8859-1' no-undo get. set.
    
    method public static Table readCSV(pPath as char):
        return readCSV(pPath, defaultSeparator).
    end method.
    
    method public static Table readCSV(pContent as longchar):
        return readCSV(pContent, defaultSeparator).
    end method.
    
    method public static Table readCSV(pPath as char, pSeparator as char):
        return readCSV(pPath, pSeparator, '').
    end method.
    
    method public static Table readCSV(pContent as longchar, pSeparator as char):
        return readCSV(pContent, pSeparator, '').
    end method.
    
    method public static Table readCSV(pPath as char, pSeparator as char, pTypes as char):
        def var content as longchar no-undo.
        copy-lob from file pPath to content convert source codepage defaultCodePage.
        return readCSV(content, pSeparator, pTypes).
    end method.
    
    method public static Table readCSV(pPath as char, pSeparator as char, pTable as Table):
        def var content as longchar no-undo.
        copy-lob from file pPath to content convert source codepage defaultCodePage.
        return readCSV(content, pSeparator, pTable).
    end method.
    
    method public static Table readCSV(pContent as longchar, pSeparator as char, pTypes as char):
        def var resultTable as Table no-undo.
        def var i as int no-undo.
        def var limit as int no-undo.
        def var headerName as char no-undo.
        def var headerType as char no-undo.
        def var headers as char no-undo.
        assign 
            headers = normalizeHeaders(string(entry(1, pContent, '~n')), pSeparator)
            resultTable = new Table().
        
        do i = 1 to num-entries(headers, pSeparator):
            if i < num-entries(pTypes, ' ') then do:
                assign headerType = entry(i, pTypes, ' ').
            end.
            else do:
                assign headerType = 'character'.
            end.
            assign headerName =  entry(i, headers, pSeparator).
            resultTable:addField(headerName, headerType).
        end.
        
        return readCSV(pContent, pSeparator, resultTable).
    end method.
    
    method public static Table readCSV(pContent as longchar, pSeparator as char, pTable as Table):
        def var headers as char no-undo.
        def var headerName as char no-undo.
        def var currentRow as char no-undo.
        def var currentValue as char no-undo.
        def var i as int no-undo.
        def var j as int no-undo.
        def var colCount as int no-undo.
        def var rowCount as int no-undo.
        
        assign 
            headers = entry(1, pContent, '~n')
            colCount = num-entries(headers, pSeparator)
            rowCount = num-entries(pContent, '~n').
            
        if rowCount < 2 or colCount = 0 then do:
            return ?.
        end.
        
        assign 
            headers = normalizeHeaders(string(entry(1, pContent, '~n')), pSeparator).
        do i = 2 to rowCount:
            assign currentRow = entry(i, pContent, '~n').
            if currentRow = '' then next.
            pTable:createBuffer().
            do j = 1 to colCount:
                assign 
                    headerName = entry(j, headers, pSeparator)
                    currentValue = entry(j, currentRow, pSeparator).
                    
                if Matcher:startsWith(currentValue, '"') and Matcher:endsWith(currentValue, '"') then do:
                    assign currentValue = substring(currentValue, 2, length(currentValue) - 2).
                end.
                
                assign 
                    currentValue = replace(currentValue, '""', '"')
                    currentValue = replace(currentValue, '"' + pSeparator, pSeparator).
                pTable:buffer:updateField(headerName, currentValue).
            end.
        end.
        return pTable.
    end method.
    
    method protected static char normalizeHeaders(pHeader as char, pSeparator as char):
        def var i as int no-undo.
        def var headerName as char no-undo.
        do i = 1 to num-entries(pHeader, pSeparator):
            assign 
                headerName = entry(i, pHeader, pSeparator)
                headerName = Sanitizer:kebabCase(headerName)
                entry(i, pHeader, pSeparator) = headerName.
        end.
        return pHeader.
    end method.
end class.
