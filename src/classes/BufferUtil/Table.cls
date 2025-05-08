block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.BufferUtil.* from propath.
using classes.StringUtil.* from propath.

class classes.BufferUtil.Table:
    def public property count as int no-undo get. protected set.
    def public property handle as handle no-undo get. protected set.
    def public property buffer as Buffer no-undo get. protected set. 
        
    def public property prepared as log no-undo
        get:
            if not valid-handle(handle) then return false.
            return handle:prepared.
        end.
        
    def public property name as char no-undo init 'result' get.
        set(pName as char):
            if not prepared then return.
            assign name = Sanitizer:kebabCase(pName).
        end.
        
    def temp-table formulas
        field fieldTarget as char
        field formula as char
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
        assign name = pName.
        return this-object.
    end method.
    
    method public Table fieldCopy(pBuffer as handle, pField as char):
        buffer:fieldCopy(pBuffer, pField).
        return this-object.
    end method.
    
    method public Table fieldCopy(pBuffer as buffer, pField as char):
        buffer:fieldCopy(pBuffer, pField).
        return this-object.
    end method.
    
    method public Table fieldCopy(pTable as table, pField as char):
        return fieldCopy(pTable:buffer, pField).
    end method.
    
    method public Table bufferCopy(pBuffer as handle):
        return bufferCopy(pBuffer, false).
    end method.
    
    method public Table bufferCopy(pBuffer as handle, pNew as log):
        if not bufferAvailable() or pNew then createBuffer().
        buffer:copy(pBuffer).
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
    
    method public Table addFormula(pField as char, pFormula as char):
        if not findFormula(pField) then do:
            create formulas.
        end.
        
        assign
            formulas.fieldTarget = pField
            formulas.formula = pFormula.
            
        return this-object.    
    end method.
    
    method protected log findFormula(pField as char):
        find first formulas 
            where formulas.fieldTarget = pField
            no-error.
        return avail formulas.    
    end method.
    
    method protected void reset():
        if valid-handle(handle) then do:
            delete object buffer no-error.
            delete object handle no-error.
            assign name = ''.
        end.
    end method.
    
    method public JsonArray toJson():
        def var arr as JsonArray no-undo.
        assign arr = new JsonArray().
        handle:write-json('JsonArray', arr, false, ?, false, true).
        return arr.
    end method.
    
    destructor Table():
        reset().
    end destructor.
end class.
