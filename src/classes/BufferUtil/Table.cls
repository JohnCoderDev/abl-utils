block-level on error undo, throw.
using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.* from propath.
using classes.BufferUtil.* from propath.
using classes.StringUtil.* from propath.

class classes.BufferUtil.Table:
    def public property count as int no-undo get. protected set.
    def public property handle as handle no-undo get. protected set.
    def public property buffer as Buffer no-undo get. protected set. 
        
    def public property valid as log no-undo
        get:
            return valid-handle(handle).
        end.
        
    def public property prepared as log no-undo
        get:
            if not valid then return false.
            return handle:prepared.
        end.
        
    def public property name as char no-undo init 'result' get.
        set(pName as char):
            if not prepared then do:
                assign name = Sanitizer:kebabCase(pName).
            end.
        end.
        
    def temp-table formulas
        field fieldTarget as char
        field formula as object
        index idxField as primary unique fieldTarget.
        
    constructor Table():
        create temp-table handle.
    end constructor.
    
    constructor Table(pBuffer as Buffer):
        createLike(pBuffer).
    end constructor.
    
    constructor Table(pTable as handle):
        assign 
            handle = pTable
            name = handle:name.
    end constructor.
    
    constructor Table(pLike as char):
        createLike(pLike).
    end constructor.
    
    method public Table addLike(pTable as Table, pName as char):
        return addLike(pTable:buffer, pName).
    end method.
    
    method public Table addLike(pExpression as char, pName as char):
        return addLike(new Buffer(pExpression), pName).
    end method.
    
    method public Table addLike(pBuffer as handle, pName as char):
        return addLike(pBuffer, pName).
    end method.
    
    method public Table addLike(pBuffer as Buffer, pName as char):
        def var i as int no-undo.
        def var currentName as char no-undo.
        
        assign pName = Sanitizer:wipeSpaces(pName).
        
        do i = 1 to num-entries(pName, ' '):
            assign currentName = entry(i, pName, ' ').
            if pBuffer:has(currentName) then do:
                handle:add-like-field(currentName, pBuffer:handle:buffer-field(currentName)).
            end.
        end.
        return this-object.
    end method.
    
    method public Table addField(pName as char, pType as char):
        return addField(pName, pType, ?).
    end method.
    
    method public Table addField(pName as char, pType as char, pExtent as int):
        return addField(pName, pType, pExtent, ?).
    end method.
    
    method public Table addField(pName as char, pType as char, pExtent as int, pInitial as char):
        return addField(pName, pType, pExtent, pInitial, ?).
    end method.
    
    method public Table addField(pName as char, pType as char, pExtent as int, pInitial as char, pLabel as char):
        handle:add-new-field(Sanitizer:kebabCase(pName), pType, pExtent, ?, pInitial, pLabel, pLabel).
        return this-object.
    end method.
    
    method public Table addIndexField(pIndexName as char, pField as char):
        return addIndexField(pIndexName, pField, true).
    end method.
    
    method public Table addIndexField(pIndexName as char, pField as char, pAscending as log):
        def var i as int no-undo.
        def var currentField as char no-undo.
        def var mode as char no-undo.
        assign mode = if pAscending then 'asc' else 'desc'.
        
        do i = 1 to num-entries(pField, ' '):
            assign currentField = entry(i, pField, ' ').
            handle:add-index-field(pIndexName, currentField, mode).
        end.
        
        return this-object.
    end method.
    
    method public Table addIndex(pIndexName as char):
        return addIndex(pIndexName, false).
    end method.
    
    method public Table addIndex(pIndexName as char, pUnique as log):
        return addIndex(pIndexName, pUnique, false).
    end method.
    
    method public Table addIndex(pIndexName as char, pUnique as log, pPrimary as log):
        return addIndex(pIndexName, pUnique, pPrimary, false).
    end method.
    
    method public Table addIndex(pIndexName as char, pUnique as log, pPrimary as log, pWord as log):
        handle:add-new-index(pIndexName, pUnique, pPrimary, pWord).
        return this-object.
    end method.
    
    method public Table addFrom(pBuffer as char):
        return addFrom(pBuffer, ?).
    end method.
    
    method public Table addFrom(pBuffer as char, pExcept as char):
        return addFrom(new Buffer(pBuffer), pExcept).
    end method.
    
    method public Table addFrom(pTable as Table):
        return addFrom(pTable, ?).
    end method.
    
    method public Table addFrom(pTable as Table, pExcept as char):
        return addFrom(pTable:handle, pExcept).
    end method.
    
    method public Table addFrom(pBuffer as Buffer):
        return addFrom(pBuffer, ?).
    end method.
    
    method public Table addFrom(pBuffer as Buffer, pExcept as char):
        return addFrom(pBuffer:handle, pExcept).
    end method.
    
    method public Table addFrom(pBuffer as handle):
        return addFrom(pBuffer, ?).
    end method.
    
    method public Table addFrom(pBuffer as handle, pExcept as char):
        if pExcept = ? or pExcept = '' then do:
            handle:add-fields-from(pBuffer).
        end.
        else do:
            handle:add-fields-from(pBuffer, pExcept).
        end.
        return this-object.
    end method.
    
    method public Table createTable(pName as char):
        reset().
        createTempTable(pName).
        return this-object.
    end method.
    
    method public Table createLike(pTable as char):
        reset().
        createTempTable(pTable).
        handle:create-like(pTable).
        return this-object.
    end method.
    
    method public Table createLike(pTable as char, pDB as char):
        reset().
        createTempTable(pTable).
        handle:create-like(pDB + "." + pTable).
        return this-object.
    end method.
    
    method public Table createLike(pBuffer as handle):
        reset().
        createTempTable(pBuffer:name).
        handle:create-like(pBuffer).
        return this-object.
    end method.
    
    method public Table createLike(pBuffer as Buffer):
        return createLike(pBuffer:handle).
    end method.
    
    method public Table createLike(pTable as Table):
        return createLike(pTable:buffer).
    end method.
    
    method protected void createTempTable(pName as char):
        create temp-table handle.
        assign name = pName.
    end method.
    
    method public Table copyData(pBuffer as char):
        return copyData(new Buffer(pBuffer)).
    end method.
    
    method public Table copyData(pTable as Table):
        return copyData(pTable:buffer).
    end method.
    
    method public Table copyData(pBuffer as Buffer):
        prepare().
        def var queryObject as Query no-undo.    
        assign queryObject = new Query(pBuffer).
        queryObject:setBuffer(pBuffer).
        
        queryObject:first().
        do while not queryObject:offEnd():
            this-object:createBuffer().
            this-object:buffer:handle:buffer-copy(pBuffer:handle).
            queryObject:next().
        end.
        
        delete object queryObject no-error.
        return this-object.
    end method.
    
    method public Table reduceTable(pFields as char):
        def var newTable as Table no-undo.
        assign newTable = new Table().
        newTable:addLike(this-object, pFields).
        newTable:copyData(this-object).
        return newTable.
    end method.
    
    method public Table copy(pTable as handle):
        return this-object:copy(new Table(pTable)).
    end method.
    
    method public Table copy(pTable as Table): 
        handle:copy-temp-table(pTable:handle).
        return this-object.
    end method.
    
    method public log clear():
        return handle:clear().
    end method.
    
    method public Table prepare():
        if not prepared then do:
            handle:temp-table-prepare(name).
            assign buffer = new Buffer(handle:default-buffer-handle).
        end.
        return this-object.
    end method.
    
    method public int numFields():
        if buffer = ? then return 0.
        return buffer:numFields().
    end method.
    
    method public Table createBuffer():
        prepare().
        assign count = count + 1.    
        buffer:create().
        return this-object.
    end method.
    
    method public Table deleteBuffer():
        if bufferAvailable() then do:
            buffer:delete().
            assign count = count - 1.
        end.
    end method.
    
    method public log bufferAvailable():
        if not prepared then do:
            return false.
        end.
        if buffer <> ? then do:
            return this-object:buffer:available.
        end.
        return false.
    end method.
    
    method public Table setName(pName as char):
        if not prepared then do:
            assign name = pName.
        end.
        return this-object.
    end method.
    
    method public Table fieldCopy(pBuffer as handle, pField as char):
        buffer:fieldCopy(pBuffer, pField).
        return this-object.
    end method.
    
    method public Table fieldCopy(pBuffer as handle, pField as char, pStrategy as char):
        buffer:fieldCopy(pBuffer, pField, pStrategy).
        return this-object.
    end method.
    
    method public Table fieldCopy(pBuffer as buffer, pField as char):
        buffer:fieldCopy(pBuffer, pField).
        return this-object.
    end method.
    
    method public Table fieldCopy(pBuffer as buffer, pField as char, pStrategy as char):
        buffer:fieldCopy(pBuffer, pField, pStrategy).
        return this-object.
    end method.
    
    method public Table fieldCopy(pTable as table, pField as char):
        return fieldCopy(pTable:buffer, pField).
    end method.
    
    method public Table fieldCopy(pTable as Table, pField as char, pStrategy as char):
        return fieldCopy(pTable:buffer, pField, pStrategy).
    end method.
    
    method public Table bufferCopy(pBuffer as handle):
        return bufferCopy(pBuffer, false).
    end method.
    
    method public Table bufferCopy(pBuffer as handle, pNew as log):
        if not bufferAvailable() or pNew then createBuffer().
        buffer:copy(pBuffer).
        return this-object.
    end method.
    
    method public Table bufferCopy(pBuffer as handle, pNew as log, pStrategy as char):
        if not bufferAvailable() or pNew then createBuffer().
        buffer:copy(pBuffer, pStrategy).
        return this-object.
    end method.
    
    method public Table bufferCopy(pBuffer as Buffer):
        return bufferCopy(pBuffer, false).
    end method.
    
    method public Table bufferCopy(pBuffer as Buffer, pNew as log):
        if not bufferAvailable() or pNew then createBuffer().
        buffer:copy(pBuffer).
        return this-object.
    end method.
    
    method public Table bufferCopy(pBuffer as Buffer, pNew as log, pStrategy as char):
        if not bufferAvailable() or pNew then createBuffer().
        buffer:copy(pBuffer, pStrategy).
        return this-object.
    end method.
    
    method public Table bufferCopy(pTable as Table):
        return bufferCopy(pTable:buffer, false).
    end method.
    
    method public Table bufferCopy(pTable as Table, pNew as log):
        return bufferCopy(pTable:buffer, pNew).
    end method.
    
    method public Table bufferCopy(pTable as Table, pNew as log, pStrategy as char):
        return bufferCopy(pTable:buffer, pNew, pStrategy).
    end method.
    
    method public Table addFormula(pField as char, pFormula as char):
        if not findFormula(pField) then do:
            create formulas.
        end.
        
        assign
            formulas.fieldTarget = pField
            formulas.formula = new FormulaInterpreter(pFormula).
            
        return this-object.    
    end method.
    
    method protected log findFormula(pField as char):
        find first formulas 
            where formulas.fieldTarget = pField
            no-error.
        return avail formulas.    
    end method.
    
    method public Table calculateFormulas():
        def var formula as FormulaInterpreter no-undo.
        for each formulas no-lock:
            if not this-object:buffer:has(formulas.fieldTarget) then next.
            assign formula = cast(formulas.formula, FormulaInterpreter).
            formula:applyFormula(this-object:buffer, formulas.fieldTarget).
        end.
        return this-object.
    end method.
    
    method protected void reset():
        if valid-handle(handle) then do:
            delete object buffer no-error.
            delete object handle no-error.
            assign name = 'result'.
            create temp-table handle.
        end.
    end method.
    
    method public Table summarize(pAggregations as char):
        return summarize('', pAggregations).
    end method.
    
    method public Table summarize(pKeys as char, pValues as char):
        def var summarizerObject as Summarizer no-undo.
        assign summarizerObject = new Summarizer(pKeys, pValues).
        return summarizerObject:summarize(this-object).
    end method.
    
    method public Table setLabel(pField as char, pNewLabel as char):
        if prepared then do:
            if this-object:buffer:has(pField) then do:
                assign
                    this-object:buffer:field(pField):label = pNewLabel
                    this-object:buffer:field(pField):column-label = pNewLabel.
            end.
        end.
        return this-object.
    end method.
    
    method public Table setLabel(pField as int, pNewLabel as char):
        if prepared then do:
            if this-object:buffer:has(pField) then do:
                assign
                    this-object:buffer:field(pField):label = pNewLabel
                    this-object:buffer:field(pField):column-label = pNewLabel.
            end.
        end.
        return this-object.
    end method.
    
    
    method public Table setFormat(pField as char, pFormat as char):
        if prepared then do:
            if this-object:buffer:has(pField) then do:
                assign this-object:buffer:field(pField):format = pFormat.
            end.
        end.
        return this-object.
    end method.
    
    method public Table setFormat(pField as int, pFormat as char):
        if prepared then do:
            if this-object:buffer:has(pField) then do:
                assign this-object:buffer:field(pField):format = pFormat.
            end.
        end.
        return this-object.
    end method.
    
    method public JsonArray toJson():
        def var array as JsonArray no-undo.
        assign array = new JsonArray().
        handle:write-json('JsonArray', array, false, ?, false, true).
        return array.
    end method.
    
    method public override object clone():
        return clone('').
    end method.
    
    method public object clone(pExcept as char):
        def var newTable as Table no-undo.
        def var formulaObject as FormulaInterpreter no-undo.
        def var formulaExpression as char no-undo.
        
        assign newTable = new Table().
        newTable:addFrom(this-object, pExcept).
        
        for each formulas no-lock:
            assign
                formulaObject = cast(formulas.formula, FormulaInterpreter)
                formulaExpression = formulaObject:formula.            
            newTable:addFormula(formulas.fieldTarget, formulaExpression).
        end.
        
        return newTable.
    end method.
    
    method public Table filter(pWhere as char):
        return new QueryBuilder()
            :table(name)
            :where(pWhere)
            :buildQuery()
            :setBuffer(this-object:buffer)
            :currentQueryToTable().
    end method.
    
    destructor Table():
        reset().
    end destructor.
end class.
