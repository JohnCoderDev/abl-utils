block-level on error undo, throw.
using classes.BufferUtil.* from propath.

class classes.BufferUtil.B inherits Buffer:
    constructor B():
    end constructor.
    
    constructor B(pBuffer as character):
        changeBuffer(pBuffer).
    end constructor.
    
    constructor B(pBuffer as handle, pIsTT as logical):
        changeBuffer(pBuffer, pIsTT).
    end constructor.
    
    constructor B(pBuffer as handle):
        changeBuffer(pBuffer).
    end constructor.
end class.
