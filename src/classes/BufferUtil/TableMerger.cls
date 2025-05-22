block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.BufferUtil.* from propath.

class classes.BufferUtil.TableMerger:
    def temp-table tables
        field bufferObject as object
        field name as char 
        field wherePhrase as char
        field ofTable as char
        field joinMode as char init 'inner'
        field queryMode as char init 'each'.
    
    def temp-table formulas
        field fieldName as char
        field fieldType as char
        field formula as char.
    
    method public TableMerger addTable(pBuffer as char):
        return addTable('', pBuffer, pBuffer).
    end method.
    
    method public TableMerger addTable(pBuffer as Buffer):
        return addTable('', pBuffer, pBuffer:name).
    end method.
    
    method public TableMerger addTable(pTable as Table):
        return addTable('', pTable, pTable:name).
    end method.
    
    method public TableMerger addTable(
        pBuffer as char, 
        pName as char
    ):
        return addTable('', pBuffer, pName).
    end method.
        
    method public TableMerger addTable(
        pQueryMode as char, 
        pBuffer as char, 
        pName as char
    ):
        return addTable(pQueryMode, pBuffer, pName, '').
    end method.            
        
    method public TableMerger addTable(
        pQueryMode as char, 
        pBuffer as char, 
        pName as char, 
        pWhere as char
    ):
        return addTable(pQueryMode, pBuffer, pName, pWhere, '').
    end method.        
        
    method public TableMerger addTable(
        pQueryMode as char, 
        pBuffer as char, 
        pName as char, 
        pWhere as char, 
        pOf as char
    ):
        return addTable(pQueryMode, pBuffer, pName, pWhere, pOf, '').
    end method.
    
    method public TableMerger addTable(
        pQueryMode as char, 
        pBuffer as char, 
        pName as char, 
        pWhere as char, 
        pOf as char, 
        pJoinMode as char
    ):
        return addTable(pQueryMode, new Buffer(pBuffer, pName), pName, pWhere, pOf, pJoinMode).
    end method.
    
    method public TableMerger addTable(
        pTable as Table, 
        pName as char
    ):
        return addTable('', pTable, pName).
    end method.
        
    method public TableMerger addTable(
        pQueryMode as char, 
        pTable as Table, 
        pName as char
    ):
        return addTable(pQueryMode, pTable, pName, '').
    end method.            
        
    method public TableMerger addTable(
        pQueryMode as char, 
        pTable as Table, 
        pName as char, 
        pWhere as char
    ):
        return addTable(pQueryMode, pTable, pName, pWhere, '').
    end method.        
        
    method public TableMerger addTable(
        pQueryMode as char, 
        pTable as Table, 
        pName as char, 
        pWhere as char, 
        pOf as char
    ):
        return addTable(pQueryMode, pTable, pName, pWhere, pOf, '').
    end method.
    
    method public TableMerger addTable(
        pQueryMode as char, 
        pTable as Table, 
        pName as char, 
        pWhere as char, 
        pOf as char, 
        pJoinMode as char
    ):
        return addTable(pQueryMode, pTable:buffer, pName, pWhere, pOf, pJoinMode).
    end method.
    
    method public TableMerger addTable(pBuffer as Buffer, pName as char):
        return addTable('', pBuffer, pName).
    end method.
    
    method public TableMerger addTable(
        pQueryMode as char, 
        pBuffer as Buffer, 
        pName as char
    ):
        return addTable(pQueryMode, pBuffer, '').
    end method.
    
    method public TableMerger addTable(
        pQueryMode as char, 
        pBuffer as Buffer, 
        pName as char, 
        pWhere as char
    ):
        return addTable(pQueryMode, pBuffer, pName, pWhere, '').
    end method.
    
    method public TableMerger addTable(
        pQueryMode as char, 
        pBuffer as Buffer, 
        pName as char, 
        pWhere as char, 
        pOf as char
    ):
        return addTable(pQueryMode, pBuffer, pName, pWhere, pOf, '').
    end method.
    
    method public TableMerger addTable(
        pQueryMode as char, 
        pBuffer as Buffer, 
        pName as char, 
        pWhere as char, 
        pOf as char, 
        pJoinMode as char
    ):
        create tables.
        assign
            tables.bufferObject = pBuffer
            tables.wherePhrase = pWhere
            tables.name = pName
            tables.ofTable = pOf
            tables.queryMode = if lookup(pQueryMode, 'each,first,last') > 0 then pQueryMode else tables.queryMode
            tables.joinMode = if lookup(pJoinMode, 'outer-join,left outer-join,inner') > 0 then pJoinMode else tables.joinMode. 
        return this-object.    
    end method.
    
    method public TableMerger addFormula(pName as char, pType as char, pExpression as char):
        create formulas.
        assign  
            formulas.fieldName = pName
            formulas.fieldType = pType
            formulas.formula = pExpression.
        return this-object.    
    end method.
    
    method public Table merge():
        return merge(true).
    end method.
    
    method public Table merge(pUseOriginalName as log):
        return merge(pUseOriginalName, true).
    end method.
    
    method public Table merge(pUseOriginalName as log, pSetNullAsInitial as log):
        def var builder as QueryBuilder no-undo.
        def var queryObject as Query no-undo.
        def var currentBuffer as Buffer no-undo.
        
        assign builder = new QueryBuilder().
        
        for each tables no-lock:
            builder
                :table(tables.queryMode, tables.name)
                :of(tables.ofTable)
                :where(tables.wherePhrase).
            
            if tables.joinMode <> 'inner' then do:
                builder:joinMode(tables.joinMode).
            end.
        end.
        
        assign queryObject = builder:buildQuery().
        
        for each formulas no-lock:
            queryObject:addFormula(
                formulas.fieldName,
                formulas.fieldType,
                formulas.formula
            ).    
        end.
        
        for each tables no-lock:
            assign currentBuffer = cast(tables.bufferObject, Buffer).
            queryObject:setBuffer(currentBuffer, tables.name).
        end.
        
        return queryObject:currentQueryToTable(pUseOriginalName, pSetNullAsInitial).
    end method.
end class.
