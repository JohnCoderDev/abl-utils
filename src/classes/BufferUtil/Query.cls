block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.BufferUtil.* from propath.
using classes.QueryUtil.* from propath.

class classes.BufferUtil.Query:
    define public property handle as handle no-undo get. protected set.
    define public property mainBuffer as character no-undo get. protected set.
    
    define temp-table buffers   
        field name as character
        field buffer as object.
        
    constructor Query(pQuery as character):
        define variable idx as integer no-undo.
        assign mainBuffer = entry(3, pQuery, ' ').
        
        do idx = 2 to num-entries(pQuery):
            
        end.
    end constructor.
    
    method public Query addBuffer(pBuffer as character):
        createBuffer(pBuffer).
        assign
            buffers.name = pBuffer
            buffers.buffer = new Buffer(pBuffer).
        return this-object.    
    end method.
    
    method public Query addBuffer(pBuffer as handle):
        return addBuffer(pBuffer, pBuffer:name).
    end method.
    
    method public Query addBuffer(pBuffer as handle, pName as character):
        createBuffer(pName).
        assign
            pBuffer:name = pName
            buffers.name = pBuffer:name
            buffers.buffer = new Buffer(pBuffer).
        return this-object.    
    end method.
    
    method public Query addBuffer(pBuffer as Buffer):
        return addBuffer(pBuffer, pBuffer:name()).
    end method.    
    
    method public Query addBuffer(pBuffer as Buffer, pName as character):
        createBuffer(pName).
        assign
            pBuffer:handle:name = pName
            buffers.name = pName
            buffers.buffer = pBuffer.
        return this-object.    
    end method.
    
    method public Buffer getBuffer(pBuffer as character):
        if findBuffer(pBuffer) then do:
            return cast(buffers.buffer, Buffer).
        end.
    end method.
    
    method public handle getField(pBuffer as character, pField as character):
        if findBuffer(pBuffer) then do:
            return cast(buffers.buffer, Buffer):field(pField).
        end.
    end method.
    
    
    method public Query reset():
        empty temp-table buffers.
    end method.
    
    method protected void createBuffer(pName as character):
        if not findBuffer(pName) then do:
            create buffers.
        end.
    end method.
    
    method protected logical findBuffer(pName as character):
        find buffers where buffers.name = pName no-error.
        return available buffers.
    end method.
end class.
