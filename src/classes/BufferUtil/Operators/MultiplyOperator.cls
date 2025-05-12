block-level on error undo, throw.
using classes.BufferUtil.* from propath. 
using classes.BufferUtil.Operators.Interfaces.* from propath.

class classes.BufferUtil.Operators.MultiplyOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        def var operationResult as char no-undo.
        def var i as int no-undo.
        assign operationResult = getArgument(pOperands, 1).
        do i = 2 to argumentCount(pOperands):
            assign operationResult = string(dec(operationResult) + dec(getArgument(pOperands, i))).
        end.
        return operationResult.
    end method.
end class.
