block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.BufferUtil.* from propath.
using classes.StringUtil.* from propath.

class classes.BufferUtil.Table:
    def public property count as int no-undo get. protected set.
    def public property handle as handle no-undo get. protected set.
        
    def public property prepared as log no-undo
        get:
            if valid-handle(handle) then do:
                return handle:prepared.
            end.
            return false.
        end.
        
    def public property buffer as handle no-undo
        get:
            if valid-handle(handle) then do:
                return handle:default-buffer-handle.
            end.
            return ?.
        end.
    
    def public property bufferObject as Buffer no-undo get. protected set.    
        
    def public property name as char no-undo
        get:
            if valid-handle(this-object:handle) and this-object:prepared then do:
                return handle:name.
            end.
            return name.
        end.
        protected set(pName as char):
            assign name = pName.
        end.
        
    constructor Table(pBuffer as buffer):
        createLike(pBuffer).
    end constructor.
    
    constructor Table(pTable as handle):
        assign handle = pTable.
    end constructor.
    
    constructor Table(pName as char):
        createTable(pName).
    end constructor.
    
    method public Table addLike(pExpression as char, pName as char):
        return addLike(new Buffer(pExpression), pName).
    end method.
    
    method public Table addLike(pBuffer as handle, pName as char):
        return addLike(pBuffer, pName).
    end method.
    
    method public Table addLike(pBuffer as Buffer, pName as char):
        if pBuffer:has(pName) then do:
            handle:add-like-field(pName, pBuffer:handle:buffer-field(pName)).
        end.
        return this-object.
    end method.
    
    method public Table addLikes(pExpression as char, pNames as char):
        def var i as int no-undo.
        assign pNames = Sanitizer:wipeSpaces(pNames).
        do i = 1 to num-entries(pNames, ' '):
            addLike(pExpression, entry(i, pNames, ' ')).
        end.
        return this-object.
    end method.
    
    method public Table addLikes(pBuffer as handle, pNames as char):
        def var i as int no-undo.
        assign pNames = Sanitizer:wipeSpaces(pNames).
        do i = 1 to num-entries(pNames, ' '):
            addLike(pBuffer, entry(i, pNames, ' ')).
        end.
        return this-object.
    end method.
    
    method public Table addLikes(pBuffer as buffer, pNames as char):
        def var i as int no-undo.
        assign pNames = Sanitizer:wipeSpaces(pNames).
        do i = 1 to num-entries(pNames, ' '):
            addLike(pBuffer, entry(i, pNames, ' ')).
        end.
        return this-object.
    end method.
    
    method public Table addField(pName as char, pType as char):
        handle:add-new-field(pName, pType).
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
    
    method public Table createLike(pBuffer as buffer):
        return createLike(pBuffer:handle).
    end method.
    
    method protected void createTempTable(pName as char):
        create temp-table handle.
        assign name = Sanitizer:kebabCase(pName).
    end method.
    
    method public Table copy(pTable as handle):
        return this-object:copy(new Table(pTable)).
    end method.
    
    method public Table copy(pTable as Table): 
        handle:copy-temp-table(pTable:handle).
        return this-object.
    end method.
    
    method public log clear():
        return this-object:handle:clear().
    end method.
    
    method public Table prepare():
        if not prepared then do:
            handle:temp-table-prepare(name).
            assign bufferObject = new Buffer(this-object:buffer).
        end.
        return this-object.
    end method.
    
    method public int numFields():
        if not valid-handle(buffer) then do:
            return 0.
        end.
        return buffer:num-fields.
    end method.
    
    method public Table createBuffer():
        prepare().
        assign count = count + 1.    
        this-object:buffer:buffer-create.
        return this-object.
    end method.
    
    method public Table deleteBuffer():
        if bufferAvailable() then do:
            buffer:buffer-delete.
            assign count = count - 1.
        end.
    end method.
    
    method public log bufferAvailable():
        if not prepared then do:
            return false.
        end.
        if valid-handle(this-object:buffer) then do:
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
        bufferObject:fieldCopy(pBuffer, pField).
        return this-object.
    end method.
    
    method public Table fieldCopy(pBuffer as buffer, pField as char):
        bufferObject:fieldCopy(pBuffer, pField).
        return this-object.
    end method.
    
    method public Table fieldCopy(pTable as table, pField as char):
        return fieldCopy(pTable:bufferObject, pField).
    end method.
    
    method public Table bufferCopy(pBuffer as handle):
        return bufferCopy(pBuffer, false).
    end method.
    
    method public Table bufferCopy(pBuffer as handle, pNew as log):
        if not bufferAvailable() or pNew then createBuffer().
        bufferObject:copy(pBuffer).
        return this-object.
    end method.
    
    method public Table bufferCopy(pBuffer as Buffer):
        return bufferCopy(pBuffer, false).
    end method.
    
    method public Table bufferCopy(pBuffer as Buffer, pNew as log):
        if not bufferAvailable() or pNew then createBuffer().
        bufferObject:copy(pBuffer).
        return this-object.
    end method.
    
    method protected void reset():
        if valid-handle(handle) then do:
            delete object bufferObject no-error.
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
