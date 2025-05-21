block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.StringUtil.* from propath.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Errors.* from propath.

class classes.BufferUtil.QueryBuilder:
    def protected property queryModes as char init "each,first,last" get.
    def protected property lockModes as char init "no-lock,exclusive-lock,shared-lock" get.
    def protected property orderModes as char no-undo init "ascending,descending" get.
    
    def protected property idChar as char no-undo
        get:
            return chr(31).
        end.
    
    def protected property stringLiteralsCount as int no-undo get. set.
    
    def public property escapeChar as char no-undo init "\" get. set.
    
    def temp-table stringLiterals 
        field id as char
        field stringValue as char.
    
    def public property queryDelimiter as char no-undo 
        get:
            if queryDelimiter = '' or queryDelimiter = ? then do:
                return chr(29).
            end.
            else return queryDelimiter.
        end.
        set.
        
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
    
    method public void copyBuffersToQuery(pBuffer as handle):
        def var bufferObject as Buffer no-undo.
        assign bufferObject = new Buffer(pBuffer).
        for each buffers no-lock:
            bufferObject:create().
            bufferObject:copy(buffer buffers:handle).
        end.
    end method.
    
    method protected Buffer findBufferByName(pName as char):
        def var resultBuffer as Buffer no-undo.
        assign resultBuffer = getBufferCopy().
        resultBuffer:first(substitute("where name = &1", quoter(pName))).
        return resultBuffer.
    end method.
    
    method protected Buffer getBufferCopy():
        def var resultBuffer as Buffer no-undo.
        assign resultBuffer = new Buffer().
        resultBuffer:changeBuffer(buffer buffers:handle).
        return resultBuffer.
    end method.
    
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
    
    method public QueryBuilder queryMode(pQueryMode as char):
        assertBuffer().
        assign buffers.queryMode = pQueryMode.
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
        return joinMode(pJoinMode).
    end method.
    
    method public QueryBuilder of(pTableName as char):
        return this-object:of(?, pTableName).
    end method.
    
    method public QueryBuilder of(pJoinMode as char, pTableName as char):
        assertBuffer().
        assign buffers.ofTable = pTableName.
        return joinMode(pJoinMode).
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
    
    method public override object clone():
        def var newBuilder as QueryBuilder no-undo.
        assign newBuilder = new QueryBuilder().
        newBuilder:parseQuery(this-object:toString(false)).
        return newBuilder.
    end method.
    
    method public override char toString():
        return toString(true).
    end method.
    
    method public char toString(pUseComma as log):
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
                    + (if pUseComma then ',' else queryDelimiter).
        end.
        assign
            resultQuery = substring(resultQuery, 1, length(resultQuery) - 1)
            resultQuery = substitute('for &1',resultQuery)
            resultQuery = Sanitizer:wipeSpaces(resultQuery).
        return resultQuery.
    end method.
    
    method public QueryBuilder parseQuery(pQuery as char):
        empty temp-table stringLiterals.
        assign 
            stringLiteralsCount = 0
            pQuery = parseStringLiterals(pQuery).
        
        def var currentSlice as char no-undo.
        def var i as int no-undo.
        
        do i = 1 to num-entries(pQuery, queryDelimiter):
            assign currentSlice = entry(i, pQuery, queryDelimiter).
            parseQuerySlice(currentSlice).
        end.
        replaceStringLiterals().
        return this-object.
    end method.
    
    method protected void replaceStringLiterals():
        for each stringLiterals no-lock:
            for each buffers no-lock:
                assign buffers.wherePhrase = replace(buffers.wherePhrase, stringLiterals.id, stringLiterals.stringValue).
            end.
        end.
    end method.
    
    method protected void parseQuerySlice(pSlice as char):
        def var tableName as char no-undo.
        def var queryMode as char no-undo.
        def var currentWord as char no-undo.
        def var fieldsPhrase as char no-undo.
        def var exceptPhrase as char no-undo.
        def var byFieldName as char no-undo.
        def var byOrder as char no-undo.
        def var sliceWordCount as int no-undo.
        def var i as int init 1 no-undo.
        def var j as int no-undo.
        
        assign 
            fieldsPhrase = Extractor:extract(pSlice, 'fields(', ')')
            exceptPhrase = Extractor:extract(pSlice, 'except(', ')')
            pSlice = replace(pSlice, substitute('fields(&1)', fieldsPhrase, ''), '')
            pSlice = replace(pSlice, substitute('except(&1)', exceptPhrase, ''), '')
            pSlice = Sanitizer:wipeSpaces(pSlice)
            queryMode = entry(i, pSlice, ' ').
        
        if queryMode = 'for' then do:
            assign
                i = i + 1
                queryMode = entry(i, pSlice, ' ').
        end.
        
        if lookup(queryMode, queryModes) > 0 then do:
            assign 
                tableName = entry(i + 1, pSlice, ' ')
                i = i + 2.
            this-object:table(queryMode, tableName).
        end.
        else do:
            assign 
                tableName = entry(i, pSlice, ' ')
                i = i + 1.
            this-object:table('each', tableName).
        end.
        
        this-object:fields(fieldsPhrase).
        this-object:except(exceptPhrase).
        
        assign sliceWordCount = num-entries(pSlice, ' ').
        
        do j = i to sliceWordCount:
            assign currentWord = entry(j, pSlice, ' ').
            
            if currentWord = 'of' then do:
                this-object:of(entry(j + 1, pSlice, ' ')).
                assign j = j + 1.
                next.
            end.
            
            if currentWord = 'left' then do:
                if j + 1 <= sliceWordCount then do:
                    if entry(j + 1, pSlice, ' ') = 'outer-join' then do:
                        assign j = j + 1.
                    end.
                end.
                joinMode('left outer-join').
                next.
            end.
            
            if currentWord = 'outer-join' then do:
                joinMode(currentWord).
                next.
            end.
            
            if currentWord = 'break' then do:
                buffers.breakBy = true.
                next.
            end.
            
            if lookup(currentWord, lockModes) > 0 then do:
                lock(currentWord).
                next.
            end.
            
            if currentWord = 'by' then do:
                assign 
                    byFieldName = entry(j + 1, pSlice, ' ')
                    j = j + 1.
                
                if j + 1 <= sliceWordCount then do:
                    assign 
                        byOrder = entry(j + 1, pSlice, ' ')
                        j = j + (if lookup(byOrder, orderModes) > 0 then 1 else 0)
                        byOrder = (if lookup(byOrder, orderModes) = 0 then 'ascending' else byOrder).
                end.
                else do:
                    assign byOrder = 'ascending'.
                end.
                this-object:by(byFieldName, byOrder).
                next.
            end.
            
            if currentWord = 'use-index' then do:
                useIndex(entry(j + 1, pSlice, ' ')).
                assign j = j + 1.
                next.
            end.
            
            if currentWord = 'where' then do:
                assign  
                    j = j + 1
                    currentWord = entry(j, pSlice, ' ').
            end.
            
            this-object:where(buffers.wherePhrase + ' ' + currentWord).
        end.
    end method.
    
    method protected char parseStringLiterals(pQuery as char):
        assign
            pQuery = parseStringLiterals(pQuery, '"')
            pQuery = parseStringLiterals(pQuery, "'").
        return pQuery.    
    end method.
    
    method protected char parseStringLiterals(pQuery as char, pDelimiter as char):
        def var leftStart as int no-undo.
        def var rightEnd as int no-undo.
        def var previousChar as char no-undo.
        
        do while index(pQuery, pDelimiter) > 0:
            assign 
                leftStart = index(pQuery, pDelimiter)
                rightEnd = index(pQuery, pDelimiter, leftStart + 1).
            
            if rightEnd = 0 then 
                return error new UnbalancedExpression(pDelimiter).
            
            assign previousChar = substring(pQuery, 1, rightEnd - 1).
            do while previousChar = escapeChar:
                assign rightEnd = index(pQuery, pDelimiter, rightEnd + 1).
                if rightEnd = 0 then return error new UnbalancedExpression(pDelimiter).
                assign previousChar = substring(pQuery, 1, rightEnd - 1).
            end.
            
            create stringLiterals.
            assign
                stringLiterals.id = substitute("&1&2", idChar, stringLiteralsCount)
                stringLiterals.stringValue = substring(pQuery, leftStart, rightEnd - leftStart + 1)
                pQuery = replace(pQuery, stringLiterals.stringValue, stringLiterals.id)
                stringLiteralsCount = stringLiteralsCount + 1.
        end.
        return pQuery.
    end method.
    
    method public Query buildQuery():
        return new Query(this-object).
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
