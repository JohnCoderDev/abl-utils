block-level on error undo, throw.
using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.* from propath.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Errors.* from propath.
using classes.StringUtil.* from propath.

class classes.BufferUtil.Query:
    def public property handle as handle no-undo get. protected set.
    def public property builder as QueryBuilder no-undo get. set.
    def public property opened as log no-undo
        get:
            if not valid-handle(handle) then return false.
            return handle:is-open.
        end.    
    
    define temp-table buffers   
        field name as character
        field buffer as object
        field includedFields as char
        field excludedFields as char.
        
    def temp-table fieldNames
        field fieldName as char
        field bufferName as char
        field originalName as char.
        
    def temp-table renames
        field fieldName as char
        field newName as char.
        
    def temp-table formulas
        field fieldName as char
        field fieldType as char
        field formula as char.
        
    constructor Query(pQuery as char):
        create query handle.
        parseQuery(pQuery).
    end constructor.
    
    constructor Query(pBuilder as QueryBuilder):
        create query handle.
        parseQuery(pBuilder).
    end constructor.
    
    constructor Query(pTable as Table):
        create query handle.
        parseQuery(pTable:name).
        setBuffer(pTable:buffer).
    end constructor.
    
    constructor Query(pBuffer as Buffer):
        create query handle.
        parseQuery(pBuffer:name).
        setBuffer(pBuffer).
    end constructor.
    
    method public Query parseQuery(pQueryBuilder as QueryBuilder):
        empty temp-table buffers.
        builder = pQueryBuilder.
        builder:copyBuffersToQuery(buffer buffers:handle).
        return this-object.
    end method.
    
    method public Query parseQuery(pQuery as char):
        empty temp-table buffers.
        assign builder = new QueryBuilder().
        builder:parseQuery(pQuery).
        builder:copyBuffersToQuery(buffer buffers:handle).
        return this-object.
    end method.
    
    method public Query setBuffer(pBuffer as handle):
        return setBuffer(new Buffer(pBuffer)).
    end method.
    
    method public Query setBuffer(pBuffer as handle, pName as char):
        return setBuffer(new Buffer(pBuffer, pName)).
    end method.
    
    method public Query setBuffer(pBuffer as char):
        return setBuffer(new Buffer(pBuffer)).
    end method.
    
    method public Query setBuffer(pBuffer as char, pName as char):
        return setBuffer(new Buffer(pBuffer, pName)).
    end method.
    
    method public Query setBuffer(pBuffer as Buffer, pName as char):
        return setBuffer(new Buffer(pBuffer:handle, pName)).
    end method.
    
    method public Query setBuffer(pBuffer as Buffer):
        if not findBuffer(pBuffer:name) then return this-object. 
        assign buffers.buffer = pBuffer.
        return this-object.
    end method.
    
    method public handle getField(pField as char):
        def var b as Buffer no-undo.
        assign b = getBufferOfField(pField).
        if b = ? then
            if b:has(pField) then
                return b:field(pField).
    end method.
    
    method public handle getField(pField as char, pBuffer as char):
        if findBuffer(pBuffer) then do:
            def var b as Buffer no-undo.
            assign b = cast(buffers.buffer, Buffer).
            if b:has(pField) then return b:field(pField).
        end.
    end method.
    
    method public Buffer getBufferOfField(pField as char):
        def var b as Buffer no-undo.
        for each buffers where buffers.buffer <> ?:
            assign b = cast(buffers.buffer, Buffer).
            if b:has(pField) then return b.
        end.
    end method.
    
    method public char getValue(pField as char):
        def var b as Buffer no-undo.
        assign b = getBufferOfField(pField).
        if b <> ? then return b:value(pField).
        return ''.
    end method.
    
    method public char getValue(pField as char, pBuffer as char):
        def var b as Buffer no-undo.
        assign b = getBuffer(pBuffer).
        if b <> ? then
            if b:has(pField) then
                return b:value(pField).
        return ''.
    end method.
    
    
    method public Buffer getBuffer():
        find first buffers no-error.
        if avail buffers then do:
            return cast(buffers.buffer, Buffer).
        end.
    end method.
    
    method public Buffer getBuffer(pBuffer as char):
        if findBuffer(pBuffer) then do:
            return cast(buffers.buffer, Buffer).
        end.
    end method.
    
    method public Query prepare():
        if opened then return this-object.        
        
        for each buffers:
            if buffers.buffer = ? then buffers.buffer = new Buffer(buffers.name).
            handle:add-buffer(cast(buffers.buffer, Buffer):handle).
        end.
        
        handle:query-prepare(string(builder)).
        handle:query-open.
        return this-object.
    end method.
    
    method public JsonObject toJson():
        return toJson('separate').
    end method.
    
    method public JsonObject toJson(pStrategy as char):
        return toJson(pStrategy, false).
    end method.
    
    method public JsonObject toJson(pStrategy as char, pPrefix as log):
        if not opened then return new JsonObject().
        def var json as JsonObject no-undo.
        def var b as Buffer no-undo.
        
        assign json = new JsonObject().
        
        case pStrategy:
            when 'separate' then do:
                for each buffers no-lock:
                    assign b = cast(buffers.buffer, Buffer).
                    if buffers.includedFields <> '' then do:
                        json:add(b:name, b:toJson(buffers.includedFields, false)).
                    end.
                    else if buffers.excludedFields <> '' then do:
                        json:add(b:name, b:toJson(buffers.excludedFields, true)).
                    end.
                    else do:
                        json:add(b:name, b:toJson()).
                    end.
                end.
            end.
            when 'merge' then do:
                calculateFieldNames(true, pPrefix).
                for each fieldNames no-lock:
                    json:add(
                        fieldNames.fieldName, 
                        getField(
                            fieldNames.originalName,
                            fieldNames.bufferName
                        ):buffer-value
                    ).
                end.
            end.
            when 'join' then do:
                calculateFieldNames(false, pPrefix).
                for each fieldNames no-lock:
                    json:add(
                        fieldNames.fieldName, 
                        getField(
                            fieldNames.originalName,
                            fieldNames.bufferName
                        ):buffer-value
                    ).
                end.
            end.
            otherwise do:
                return error new JsonStrategyNotFound(pStrategy).
            end.
        end.
        
        return json.
    end method.
    
    method public JsonArray toJsonArray():
        return toJsonArray('separate').
    end method.
    
    method public JsonArray toJsonArray(pStrategy as char):
        return toJsonArray(pStrategy, false).
    end method.
    
    method public JsonArray toJsonArray(pStrategy as char, pPrefix as log):
        prepare().
        def var queryClone as Query no-undo.
        def var resultArray as JsonArray no-undo.
        
        assign 
            queryClone = cast(clone(), Query)
            resultArray = new JsonArray().
        
        queryClone:first().
        
        do while not queryClone:offEnd():
            resultArray:add(queryClone:toJson(pStrategy, pPrefix)).
            queryClone:next().
        end.
        
        delete object queryClone no-error.
        return resultArray.
    end method.
    
    method public override object clone():
        def var queryClone as Query no-undo.
        assign queryClone = new Query(cast(builder:clone(), QueryBuilder)).
        for each buffers no-lock:
            queryClone:setBuffer(cast(buffers.buffer:clone(), Buffer)).
        end.
        return queryClone.
    end method.
    
    method public Table toTable():
        return toTable('join').
    end method.
    
    method public Table toTable(pStrategy as char):
        prepare().
        def var queryClone as Query no-undo.
        def var resultTable as Table no-undo.
        
        assign 
            queryClone = cast(clone(), Query)
            resultTable = new Table().
        
        case pStrategy:
            when 'merge' then queryClone:calculateFieldNames(true).
            when 'join' then queryClone:calculateFieldNames(false).
        end.
        
        def var names as char no-undo.
        def var fieldHandle as handle no-undo.
        def var fieldName as char no-undo.
        def var bufferName as char no-undo.
        def var originalName as char no-undo.
        def var nameRelations as char no-undo.
        
        assign names = queryClone:firstFieldName().
        
        repeat:
            if names = '' then leave.
            assign 
                nameRelations = nameRelations + names + ';'
                fieldName = entry(1, names)
                bufferName = entry(2, names)
                originalName = entry(3, names)
                fieldHandle = queryClone:getField(originalName, bufferName).
            
            
            if fieldHandle:extent > 0 then do:
                resultTable:addField(fieldName, fieldHandle:data-type, fieldHandle:extent).
            end.
            else do:
                resultTable:addField(fieldName, fieldHandle:data-type).
            end.
            names = queryClone:nextFieldName().
        end.
        
        assign nameRelations = substring(nameRelations, 1, length(nameRelations) - 1).
        
        def var i as int no-undo.
        def var j as int no-undo.
        
        createFormulaFields(resultTable).
        resultTable:prepare().
        queryClone:first().
        
        do while not queryClone:offEnd():
            resultTable:createBuffer().
            
            do i = 1 to num-entries(nameRelations, ';'):
                assign
                    names = entry(i, nameRelations, ';')
                    fieldName = entry(1, names)
                    bufferName = entry(2, names)
                    originalName = entry(3, names)
                    fieldHandle = queryClone:getField(originalName, bufferName).
                
                if fieldHandle:extent > 0 then do:
                    do j = 1 to fieldHandle:extent:
                        resultTable:buffer:updateField(fieldName, fieldHandle:buffer-value(j), j).
                    end.
                end.
                else do:
                    resultTable:buffer:updateField(fieldName, fieldHandle:buffer-value).
                end.
            end.
            
            resultTable:calculateFormulas().
            queryClone:next().
        end.
        
        delete object queryClone no-error.
        return resultTable.
    end method.
    
    method protected void createFormulaFields(pTable as Table):
        for each formulas:
            pTable:addField(formulas.fieldName, formulas.fieldType).
            pTable:addFormula(formulas.fieldName, formulas.formula).
        end.
    end method.
    
    method public char firstFieldName():
        find first fieldNames no-error.
        if not avail fieldNames then return ''.
        return fieldNames.fieldName + "," + fieldNames.bufferName + "," + fieldNames.originalName.
    end method.
    
    method public char nextFieldName():
        if not avail fieldNames then return firstFieldName().
        find next fieldNames no-error.
        if not avail fieldNames then return ''.
        return fieldNames.fieldName + "," + fieldNames.bufferName + "," + fieldNames.originalName.
    end.
    
    method public Query calculateFieldNames():
        return calculateFieldNames(false).
    end method.
    
    method public Query calculateFieldNames(pMerge as log):
        return calculateFieldNames(pMerge, false).
    end method.
    
    method public Query calculateFieldNames(pMerge as log, pPrefix as log):
        empty temp-table fieldNames.
        def var i as int no-undo.
        def var j as int no-undo.
        def var b as Buffer no-undo.
        def var availableName as char no-undo.
        def var prefix as char no-undo.
        def var currentFieldName as char no-undo.
        
        for each buffers no-lock where buffers.buffer <> ?:
            assign 
                b = cast(buffers.buffer, Buffer)
                prefix = (if pPrefix then b:name + '-' else '').
            
            do i = 1 to b:numFields():
                if Matcher:contains(buffers.excludedFields, b:fieldName(i)) 
                    or (not Matcher:contains(buffers.includedFields, b:fieldName(i)) and buffers.includedFields <> '')
                    then next.
                
                assign currentFieldName = Splitter:crop(prefix + b:fieldName(i), 32).
                
                find first fieldNames 
                    where fieldNames.fieldName = currentFieldName
                    no-error.
                
                if not avail fieldNames then do:
                    create fieldNames.
                    assign
                        fieldNames.fieldName = currentFieldName
                        fieldNames.bufferName = b:name
                        fieldNames.originalName = b:fieldName(i).
                end.
                else if avail fieldNames and not pMerge then do:
                    assign
                        availableName = ''
                        j = 2.
                    
                    do while avail fieldNames:
                        assign 
                            availableName = currentFieldName + '-' + string(j)
                            j = j + 1.
                        
                        find first fieldNames 
                            where fieldNames.fieldName = availableName
                            no-error.
                    end.
                    
                    create fieldNames.
                    assign
                        fieldNames.fieldName = availableName
                        fieldNames.bufferName = b:name
                        fieldNames.originalName = b:fieldName(i).
                end.
                else do:
                    assign
                        fieldNames.bufferName = b:name.
                end.
            end.
        end.
        
        return this-object.
    end method.
    
    method public log firstOf(pGroup as int):
        prepare().
        return handle:first-of(pGroup).
    end method.
    
    method public log lastOf(pGroup as int):
        prepare().
        return handle:last-of(pGroup).
    end method.
    
    method public Query first():
        prepare().
        handle:get-first.
        return this-object.
    end method.
    
    method public Query next():
        prepare().
        if offEnd() then return this-object.
        handle:get-next.
        return this-object.
    end method.
    
    method public Query last():
        prepare().
        handle:get-last.
        return this-object.
    end method.
    
    method public Query previous():
        prepare().
        if offEnd() then return this-object.
        handle:get-prev.
        return this-object.
    end method.
    
    method public log offEnd():
        if not opened then return false.
        return handle:query-off-end.
    end method.
    
    method public Query reset():
        empty temp-table buffers.
        empty temp-table fieldNames.
        if valid-handle(handle) then do:
            handle:query-close.
            delete object handle no-error.
        end.
        create query handle.
    end method.
    
    method public Table addFormula(pFieldName as char, pFieldType as char, pFormula as char):
        create formulas.
        assign
            formulas.fieldName = pFieldname
            formulas.fieldType = pFieldType
            formulas.formula = pFormula.
        this-object.    
    end method.
    
    method public Table summarize(pAggregations as char):
        return summarize('', pAggregations).
    end method.
    
    method public Table summarize(pKeys as char, pValues as char):
        def var s as Summarizer no-undo.
        assign s = new Summarizer(pKeys, pValues).
        return s:summarize(this-object).
    end method.
    
    method protected logical findBuffer(pName as character):
        find buffers where buffers.name = pName no-error.
        return available buffers.
    end method.
    
    destructor Query():
        reset().
        delete object handle no-error.
    end destructor.
end class.
