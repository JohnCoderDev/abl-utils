block-level on error undo, throw.
using classes.BufferUtil.* from propath.    
using classes.BufferUtil.Operators.Interfaces.* from propath.

class classes.BufferUtil.Operators.FieldOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        if not pBuffer:has(pOperands) then return ''.
        return pBuffer:value(pOperands).
    end method.
end class.
