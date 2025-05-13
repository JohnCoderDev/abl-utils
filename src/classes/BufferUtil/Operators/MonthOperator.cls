block-level on error undo, throw.
using classes.BufferUtil.* from propath. 
using classes.BufferUtil.Operators.Shared.* from propath.
using classes.BufferUtil.Operators.Interfaces.* from propath.

class classes.BufferUtil.Operators.MonthOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        OperatorAsserter:assertNumberOfArguments(this-object, pOperands, 1).
        def var operationResult as char no-undo.
        assign operationResult = string(month(date(getArgument(pOperands, 1)))).
        return operationResult.
    end method.
end class.
