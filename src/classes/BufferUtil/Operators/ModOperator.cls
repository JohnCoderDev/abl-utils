block-level on error undo, throw.
using classes.BufferUtil.* from propath.    
using classes.BufferUtil.Operators.Shared.* from propath.
using classes.BufferUtil.Operators.Interfaces.* from propath.

class classes.BufferUtil.Operators.ModOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        OperatorAsserter:assertNumberOfArguments(this-object, pOperands, 2).
        def var dividend as int no-undo.
        def var divisor as int no-undo.
        assign
            dividend = int(getArgument(pOperands, 1))
            divisor = int(getArgument(pOperands, 2)).
        return string(dividend mod divisor).    
    end method.
end class.
