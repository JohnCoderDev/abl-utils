block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.BufferUtil.* from propath.

class classes.BufferUtil.BufferComparer:
    def public static property defaultLeftName as char init 'left-buffer' no-undo get. 
        set(pName as char):
            assign defaultLeftName = Sanitizer:kebabCase(pName).
        end.
        
    def public static property defaultRightName as char init 'right-buffer' no-undo get. 
        set(pName as char):
            assign defaultRightName = Sanitizer:kebabCase(pName).
        end.
        
    method public static Table compareFields(
        pLeft as Buffer,
        pRight as Buffer,
        pStatusName as char,
        pLeftName as char,
        pRightName as char
    ):
        def var diffsTable as Table no-undo.
        def var i as int no-undo.
        
        assign diffsTable = new Table().
        diffsTable:setName('differences').
        
        do i = 1 to pLeft:numFields():
            
        end.
    end method.
    
    method public static Table getValuesDifferences(pLeft as Buffer, pRight as Buffer):
        return getValuesDifferences(pLeft, pRight, 'field-name', defaultLeftName, defaultRightName).
    end method.
    
    method public static Table getValuesDifferences(
        pLeft as Buffer, 
        pRight as Buffer,
        pFieldName as char,
        pLeftName as char,
        pRightName as char
    ):
        def var diffsTable as Table no-undo.
        def var currentField as char no-undo.
        def var currentLeftValue as char no-undo.
        def var currentRightValue as char no-undo.
        def var i as int no-undo.
        
        assign 
            diffsTable = new Table()
            pFieldName = Sanitizer:kebabCase(pFieldName)
            pLeftName = Sanitizer:kebabCase(pLeftName)
            pRightName = Sanitizer:kebabCase(pRightName).
        
        diffsTable:setName('differences').
        
        diffsTable
            :addField(pFieldName, 'character')
            :addField(pLeftName, 'character')
            :addField(pRightName, 'character').
        
        do i = 1 to pLeft:numFields():
            assign currentField = pLeft:fieldName(i).
            
            if not pRight:has(currentField) then next.
            
            assign
                currentLeftValue = pLeft:value(currentField)
                currentRightValue = pRight:value(currentField).
            
            if currentLeftValue = currentRightValue then next.
            
            diffsTable:createBuffer().
            diffsTable:buffer:updateField(pFieldName, currentField).
            diffsTable:buffer:updateField(pLeftName, currentLeftValue).
            diffsTable:buffer:updateField(pRightName, currentRightValue).
        end.
        
        return diffsTable.
    end method.
end class.
