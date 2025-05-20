block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Errors.* from propath.

class classes.BufferUtil.QueryBuilder:
    define temp-table buffers   
        field name as character
        field lock as char 
        field queryMode as char 
        field wherePhrase as char
        field includedFields as char
        field excludedFields as char
        field orderBy as char
        field breakBy as log
        field ofTable as char
        field joinMode as char
        field useIndex as char.
    
    method public QueryBuilder table(pTable as char):
        return this-object:table('each', pTable).
    end method.
    
    method public QueryBuilder table(pQueryMode as char, pTable as char):
        return this-object:table(pQueryMode, pTable, 'no-lock').
    end method.
    
    method public QueryBuilder table(pQueryMode as char, pTable as char, pLock as char):
        if not findBuffer(pTable) then create buffers.    
        assign 
            buffers.name = pTable
            buffers.lock = pLock
            buffers.queryMode = pQueryMode.
        return this-object.    
    end method.
    
    method public QueryBuilder fields(pFields as char):
        assertBuffer().
        assign buffers.includedFields = buffers.includedFields + ' ' + pFields.
        return this-object.
    end method.
    
    method public QueryBuilder resetFields():
        assertBuffer().
        assign buffers.includedFields = ''.
        return this-object.
    end method.
    
    method public QueryBuilder except(pFields as char):
        assertBuffer().
        assign buffers.excludedFields = buffers.excludedFields + ' ' + pFields.
        return this-object.
    end method.
    
    method public QueryBuilder resetExcept():
        assertBuffer().
        assign buffers.excludedFields = ''.
        return this-object.
    end method.
    
    method public QueryBuilder lock(pLockMode as char):
        assertBuffer().
        assign buffers.lock = pLockMode.
        return this-object.
    end method.
    
    method public QueryBuilder break(pBy as char):
        return this-object:break(pBy, ?).
    end method.
    
    method public QueryBuilder break(pBy as char, pOrder as char):
        assertBuffer().
        assign buffers.breakBy = true.
        return this-object:by(pBy, pOrder).
    end method.
    
    method public QueryBuilder notBreak():
        assertBuffer().
        assign buffers.breakBy = false.
        return this-object.
    end method.
    
    method public QueryBuilder by(pBy as char):
        return this-object:by(pBy, ?).
    end method.
    
    method public QueryBuilder clearBy():
        assertBuffer().
        assign buffers.orderBy = ''.
        return this-object.
    end method.
    
    method public QueryBuilder by(pBy as char, pOrder as char):
        assertBuffer().
        assign pOrder = if pOrder = ? or pOrder = '' then 'ascending' else pOrder.
        
        if pBy <> '' and pBy <> ? then do:
            assign buffers.orderBy = buffers.orderBy + ' by ' + pBy + ' ' + pOrder.
        end.
        
        return this-object.
    end method.
    
    method public QueryBuilder useIndex(pIndex as char):
        assertBuffer().
        assign buffers.useIndex = pIndex.
        return this-object.    
    end method.
    
    method public QueryBuilder where(pWhere as char):
        return this-object:where(?, pWhere).
    end method.
    
    method public QueryBuilder where(pJoinMode as char, pWhere as char):
        assertBuffer().
        assign buffers.wherePhrase = pWhere.
        return joinmode(pJoinMode).
    end method.
    
    method public QueryBuilder of(pTableName as char):
        return this-object:of(?, pTableName).
    end method.
    
    method public QueryBuilder of(pJoinMode as char, pTableName as char):
        assertBuffer().
        assign buffers.ofTable = pTableName.
        return joinmode(pJoinMode).
    end method.
    
    method public QueryBuilder joinMode(pJoinMode as char):
        assertBuffer().
        if pJoinMode <> ? and pJoinMode <> '' then do:
            assign buffers.joinMode = pJoinMode.
        end. 
        return this-object.
    end method.
    
    method public QueryBuilder clearJoinMode():
        assertBuffer().
        assign buffers.joinMode = ''.
        return this-object.
    end method.
    
    method public override char toString():
        def var resultQuery as char no-undo.
        for each buffers no-lock:
            assign
                resultQuery = resultQuery 
                    + buffers.queryMode + ' ' + buffers.name + ' ' 
                    + (if buffers.includedFields <> '' then substitute(' fields(&1) ', trim(buffers.includedFields)) else '')
                    + (if buffers.excludedFields <> '' then substitute(' except(&1) ', trim(buffers.excludedFields)) else '')
                    + (if buffers.useIndex <> '' then substitute(' use-index &1 ', buffers.useIndex) else '')
                    + (if buffers.joinMode <> '' then substitute(' &1 ', buffers.joinMode) else '')
                    + (if buffers.ofTable <> '' then substitute(' of &1 ', buffers.ofTable) else '')
                    + substitute(' &1 ', buffers.lock)
                    + (if buffers.wherePhrase <> '' then substitute(' where &1 ', buffers.wherePhrase) else '')
                    + (if buffers.breakBy then ' break ' else '')
                    + (if buffers.orderBy <> '' then substitute(' &1 ', buffers.orderBy) else '') 
                    + ','.
        end.
        assign
            resultQuery = substring(resultQuery, 1, length(resultQuery) - 1)
            resultQuery = substitute('for &1',resultQuery)
            resultQuery = Sanitizer:wipeSpaces(resultQuery).
        return resultQuery.
    end method.
    
    method protected void assertBuffer():
        if not avail buffers then do:
            return error new BufferNotAvailable().
        end.
    end method.
    
    method protected log findBuffer(pName as char):
        find buffers where buffers.name = pName no-error.
        return avail buffers.
    end method.
end class.
