block-level on error undo, throw.
using classes.BufferUtil.* from propath.    
using classes.BufferUtil.Operators.Errors.* from propath.
using classes.BufferUtil.Operators.Shared.* from propath.
using classes.BufferUtil.Operators.Interfaces.* from propath.

class classes.BufferUtil.Operators.ExponentialOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        OperatorAsserter:assertNumberOfArguments(this-object, pOperands, 2).
        
        def var base as dec no-undo.
        def var exponent as dec no-undo.
        
        assign 
            base = dec(getArgument(pOperands, 1))
            exponent = dec(getArgument(pOperands, 2)).
        
        return string(exp(base, exponent)).
    end method.
end class.
