block-level on error undo, throw.
using classes.BufferUtil.* from propath.    
using classes.BufferUtil.Operators.Interfaces.* from propath.
using classes.BufferUtil.Operators.Shared.* from propath.

class classes.BufferUtil.Operators.DivisionOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        OperatorAsserter:assertNumberOfArguments(this-object, pOperands, 2).
        def var divisor as dec no-undo.
        def var dividend as dec no-undo.
        assign
            dividend = dec(getArgument(pOperands, 1))
            divisor = dec(getArgument(pOperands, 2)).
        return string(dividend / divisor). 
    end method.
end class.
