block-level on error undo, throw.
using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.* from propath.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Errors.* from propath.
using classes.StringUtil.* from propath.

class classes.BufferUtil.Query:
    def public property handle as handle no-undo get. protected set.
    def public property builder as QueryBuilder no-undo get. set.
    def public property valid as log no-undo
        get:
            return valid-handle(handle).
        end.    
        
    def public property opened as log no-undo
        get:
            if not valid then return false.
            return handle:is-open.
        end.
    
    define temp-table buffers   
        field name as character
        field buffer as object
        field includedFields as char
        field excludedFields as char.
        
    def temp-table fieldNames
        field bufferName as char
        field realName as char
        field newName as char.
    
    def temp-table renames like fieldNames.
        
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
    
    method public Query setFieldName(pBuffer as char, pField as char, pNewName as char):
        create renames.
        assign
            renames.bufferName = pBuffer
            renames.realName = pField
            renames.newName = Sanitizer:kebabCase(pNewName)
            renames.newName = Splitter:crop(renames.newName, 32).
        return this-object.
    end method.
    
    method public Query calculateFieldNames():
        for each fieldNames:
            assign 
                fieldNames.newName = substitute("&1_&2", fieldNames.bufferName, fieldNames.realName)
                fieldNames.newName = Sanitizer:kebabCase(fieldNames.newName)
                fieldNames.newName = Splitter:crop(fieldNames.newName, 32).    
            
            for first renames 
                where renames.bufferName = fieldNames.bufferName 
                and renames.realName = fieldNames.realName:
                assign fieldNames.newName = renames.newName.
            end.
        end.
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
        if positionBuffer(pBuffer:name) then do:
            assign buffers.buffer = pBuffer.
            addBufferFields(pBuffer).
        end.    
        return this-object.
    end method.
    
    method protected void addBufferFields(pBuffer as Buffer):
        deleteBufferFields(pBuffer:name).
        
        def var i as int no-undo.
        do i = 1 to pBuffer:numFields():
            create fieldNames.
            assign
                fieldNames.bufferName = pBuffer:name
                fieldNames.realName = pBuffer:fieldName(i).
        end.
    end method.
    
    method protected void deleteBufferFields(pBuffer as char):
        for each fieldNames where bufferName = pBuffer:
            delete fieldNames.
        end.    
    end method.
    
    method public handle getField(pField as char):
        def var bufferObject as Buffer no-undo.
        assign bufferObject = getBufferOfField(pField).
        if bufferObject = ? then
            if bufferObject:has(pField) then
                return bufferObject:field(pField).
    end method.
    
    method public handle getField(pField as char, pBuffer as char):
        if positionBuffer(pBuffer) then do:
            def var bufferObject as Buffer no-undo.
            assign bufferObject = cast(buffers.buffer, Buffer).
            if bufferObject:has(pField) then 
                return bufferObject:field(pField).
        end.
    end method.
    
    method public Buffer getBufferOfField(pField as char):
        def var bufferObject as Buffer no-undo.
        for each buffers where buffers.buffer <> ?:
            assign bufferObject = cast(buffers.buffer, Buffer).
            if bufferObject:has(pField) then 
                return bufferObject.
        end.
    end method.
    
    method public char getValue(pField as char):
        def var bufferObject as Buffer no-undo.
        assign bufferObject = getBufferOfField(pField).
        if bufferObject <> ? then 
            return bufferObject:value(pField).
        return ''.
    end method.
    
    method public char getValue(pField as char, pBuffer as char):
        def var bufferObject as Buffer no-undo.
        assign bufferObject = getBuffer(pBuffer).
        if bufferObject <> ? then
            if bufferObject:has(pField) then
                return bufferObject:value(pField).
        return ''.
    end method.
    
    method public Buffer getBuffer():
        find first buffers no-error.
        if avail buffers then do:
            return cast(buffers.buffer, Buffer).
        end.
    end method.
    
    method public Buffer getBuffer(pBuffer as char):
        if positionBuffer(pBuffer) then do:
            return cast(buffers.buffer, Buffer).
        end.
    end method.
    
    method public Query prepare():
        if opened then return this-object.        
        
        def var databaseBuffer as Buffer no-undo.
        
        for each buffers:
            if buffers.buffer = ? then do:
                assign  
                    databaseBuffer = new Buffer(buffers.name)
                    buffers.buffer = databaseBuffer.
                addBufferFields(databaseBuffer).    
            end.
            else do:
                assign databaseBuffer = cast(buffers.buffer, Buffer).
            end.
            handle:add-buffer(databaseBuffer:handle).
        end.
        
        calculateFieldNames().
        handle:query-prepare(builder:toString()).
        handle:query-open.
        return this-object.
    end method.
    
    method public JsonObject toJson():
        return toJson(true).
    end method.
    
    method public JsonObject toJson(pUseOriginalName as log):
        def var resultJson as JsonObject no-undo.
        assign resultJson = new JsonObject().
        if not opened then return resultJson.
        
        def var fieldName as char no-undo.
        def var jsonName as char no-undo.
        def var bufferObject as Buffer no-undo.
        
        for each fieldNames no-lock:
            for first buffers where buffers.name = fieldNames.bufferName:
                assign 
                    bufferObject = cast(buffers.buffer, Buffer)
                    fieldName = fieldNames.realName
                    jsonName = fieldName.
                
                if not pUseOriginalName then do:
                    assign jsonName = fieldNames.newName.
                end.
                
                if resultJson:has(jsonName) then do:
                    resultJson:set(jsonName, bufferObject:field(fieldName):buffer-value).
                end.
                else do:
                    resultJson:add(jsonName, bufferObject:field(fieldName):buffer-value).
                end.
            end.
        end.
        
        return resultJson.
    end method.
    
    method public override object clone():
        def var newQuery as Query no-undo.
        def var bufferObject as Buffer no-undo.
        def var builderClone as QueryBuilder no-undo.
        
        assign 
            builderClone = cast(builder:clone(), QueryBuilder)
            newQuery = new Query(builderClone).
        
        for each buffers no-lock:
            assign 
                bufferObject = cast(buffers.buffer, Buffer)
                bufferObject = cast(bufferObject:clone(), Buffer).
            
            newQuery:setBuffer(bufferObject, buffers.name).
        end.
        
        for each renames no-lock:
            newQuery:setFieldName(
                renames.bufferName,
                renames.realName,
                renames.newName
            ).    
        end.
        
        return newQuery.
    end method.
    
    method public Table currentQueryToTable():
        return currentQueryToTable(true).
    end method.
    
    method public Table currentQueryToTable(pUseOriginalName as log):
        prepare().
        def var resultTable as Table no-undo.
        assign resultTable = new Table().
        
        def var bufferObject as Buffer no-undo.
        def var fieldName as char no-undo.
        def var tableName as char no-undo.
        def var fieldType as char no-undo.
        def var fieldExtent as int no-undo.
        def var bufferName as char no-undo.
        def var bufferNames as char no-undo.
        def var tableNames as char no-undo.
        def var i as int no-undo.
        
        for each fieldNames:
            for first buffers where buffers.name = fieldNames.bufferName:
                assign 
                    bufferObject = cast(buffers.buffer, Buffer)
                    bufferName = bufferObject:name
                    fieldName = fieldNames.realName
                    fieldExtent = bufferObject:extent(fieldName)
                    fieldType = bufferObject:type(fieldName)
                    tableName = fieldName.
                
                if not pUseOriginalName or currentFieldNameHasRename() then do:
                    assign tableName = fieldNames.newName.
                end.
                
                if (buffers.includedFields <> '' and lookup(fieldName, buffers.includedFields, ' ') > 0) 
                    or (buffers.includedFields = '' and lookup(fieldName, buffers.excludedFields, ' ') = 0) 
                    or (buffers.includedFields = '' and buffers.excludedFields = '') 
                then do:
                    assign bufferNames = substitute('&1&2:&3:&4,', bufferNames, bufferName, fieldName, tableName).
                    resultTable:addField(tableName, fieldType, fieldExtent).
                end.
            end.
        end.
        
        assign bufferNames = substring(bufferNames, 1, length(bufferNames) - 1).
        this-object:first().
        
        createFormulaFields(resultTable).
        resultTable:prepare().
        
        do while not offEnd():
            resultTable:createBuffer().
            do i = 1 to num-entries(bufferNames):
                assign
                    tableNames = entry(i, bufferNames)
                    bufferName = entry(1, tableNames, ':')
                    fieldName = entry(2, tableNames, ':')
                    tableName = entry(3, tableNames, ':')
                    bufferObject = getBuffer(bufferName).
                
                resultTable:buffer:updateField(
                    tableName, 
                    bufferObject:field(fieldName):buffer-value
                ).
                
                resultTable:calculateFormulas().
            end.
            this-object:next().
        end.
        return resultTable.
    end method.
    
    method protected log currentFieldNameHasRename():
        return can-find(
            first renames 
            where 
                fieldNames.bufferName = renames.bufferName 
                and fieldNames.realName = renames.realName
        ).
    end method.
    
    method public int numBuffers():
        if not valid then return 0.
        return handle:num-buffers.
    end method.
    
    method public Table toTable():
        return toTable(true).
    end method.
    
    method public Table toTable(pUseOriginalName as log):
        prepare().
        def var queryClone as Query no-undo.
        assign queryClone = cast(clone(), Query).
        return queryClone:currentQueryToTable(pUseOriginalName).
    end method.
    
    method protected void createFormulaFields(pTable as Table):
        for each formulas:
            pTable:addField(formulas.fieldName, formulas.fieldType).
            pTable:addFormula(formulas.fieldName, formulas.formula).
        end.
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
        
        if valid then do:
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
        def var summarizerObject as Summarizer no-undo.
        assign summarizerObject = new Summarizer(pKeys, pValues).
        return summarizerObject:summarize(this-object).
    end method.
    
    method protected logical positionBuffer(pName as character):
        find buffers where buffers.name = pName no-error.
        return available buffers.
    end method.
    
    destructor Query():
        reset().
        delete object handle no-error.
    end destructor.
end class.
