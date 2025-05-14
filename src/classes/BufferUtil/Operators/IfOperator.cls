block-level on error undo, throw.
using classes.BufferUtil.* from propath.    
using classes.BufferUtil.Operators.Interfaces.* from propath.
using classes.BufferUtil.Operators.Shared.* from propath.
using classes.StringUtil.* from propath.

class classes.BufferUtil.Operators.IfOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        OperatorAsserter:assertNumberOfArguments(this-object, pOperands, 3).
        def var validation as log no-undo.
        def var ifTrue as char no-undo.
        def var ifFalse as char no-undo.
        
        assign  
            validation = logical(getArgument(pOperands, 1))
            ifTrue = getArgument(pOperands, 2)
            ifFalse = getArgument(pOperands, 3).
        
        return (if validation then ifTrue else ifFalse).
    end method.
end class.
