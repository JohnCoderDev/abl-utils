block-level on error undo, throw.
using classes.Excel.* from propath.
using classes.BufferUtil.* from propath.
using classes.StringUtil.* from propath.

class classes.Excel.CSVWriter:
    def public property columnSeparator as char no-undo init ';' get. set.
    def public property content as longchar no-undo get. protected set.
    
    method public CSVWriter parseTable(pTable as Table):
        return parseTable(pTable, true).
    end method.
    
    method public CSVWriter parseTable(pTable as Table, pUseLabel as log):
        return parseBuffer(pTable:buffer, pUseLabel).
    end method.
    
    method public CSVWriter parseBuffer(pBuffer as Buffer):
        return parseBuffer(pBuffer, true).
    end method.
    
    method public CSVWriter parseBuffer(pBuffer as Buffer, pUseLabel as log):
        return parseBuffer(pBuffer, pUseLabel, ?).
    end method.
    
    method public CSVWriter parseBuffer(pBuffer as Buffer, pUseLabel as log, pFields as char):
        reset().
        def var queryObject as Query no-undo.
        def var fieldName as char no-undo.
        def var fieldNames as char no-undo.
        def var i as int no-undo.
        
        assign pFields = Sanitizer:wipeSpaces(pFields).
                
        if pFields = '' or pFields = ? then do:
            do i = 1 to pBuffer:numFields():
                assign
                    fieldName = if pUseLabel then pBuffer:label(i) else pBuffer:fieldName(i)
                    fieldNames = fieldNames + pBuffer:fieldName(i) + ' '.
                addContent(fieldName, false).
            end.
        end.
        else do:
            def var currentName as char no-undo.
            do i = 1 to num-entries(pFields, ' '):
                assign currentName = entry(i, pFields, ' ').
                if pBuffer:has(currentName) then do:
                    assign
                        fieldName = if pUseLabel then pBuffer:label(currentName) else currentName
                        fieldNames = fieldNames + currentName + ' '.
                    addContent(fieldName, false).    
                end.
            end.
        end.
        
        assign fieldNames = Sanitizer:wipeSpaces(fieldNames).
        
        addNewLine().
        
        assign queryObject = new Query(pBuffer:name + ' fields(' + fieldNames + ')').
        queryObject:setBuffer(pBuffer).
        queryObject:first().
        
        def var fieldValue as char no-undo.
        def var fieldType as char no-undo.
        
        do while not queryObject:offEnd():
            do i = 1 to num-entries(fieldNames, ' '):
                assign 
                    fieldName = entry(i, fieldNames, ' ')
                    fieldValue = queryObject:getValue(fieldName)
                    fieldType = pBuffer:type(fieldName).
                    
                if Matcher:containsOneOf(fieldType, 'integer,int64,decimal') then do:
                    assign fieldValue = if fieldValue = '' then '0' else fieldValue.
                    addContent(fieldValue, false).
                end.
                else do:
                    addContent(fieldValue, fieldType = 'character').
                end.
               
            end.
            addNewLine().
            queryObject:next().
        end.
        
        delete object queryObject no-error.
        return this-object.
    end method.
    
    method public CSVWriter writeFile(pPath as char):
        return writeFile(pPath, 'iso8859-1').
    end method.
    
    method public CSVWriter writeFile(pPath as char, pCodePage as char):
        if Matcher:contains(pPath, '.') then do:
            pPath = Splitter:textBefore(pPath, '.') + '.csv'.
        end.
        else do:
            pPath = pPath + '.csv'.
        end.
        copy-lob from content to file pPath convert target codepage pCodePage.
        return this-object.
    end method.
    
    method public CSVWriter addContent(pContent as char):
        return addContent(pContent, false).
    end method.
    
    method public CSVWriter addContent(pContent as char, pQuote as log):
        assign 
            pContent = replace(pContent, "~"", "~"~"")
            pContent = replace(pContent, columnSeparator, "~"" + columnSeparator).
        
        if pQuote then do:
            assign pContent = quoter(pContent, "'").
        end.
        
        assign content = content + pContent + columnSeparator.
        return this-object.
    end method.
    
    method public CSVWriter addNewLine():
        assign content = content + '~n'.
        return this-object.
    end method.
    
    method public void reset().
        assign content = ''.
    end.
    
    destructor CSVWriter():
        reset().
    end destructor.
end class.
