block-level on error undo, throw.
using classes.BufferUtil.* from propath.    
using classes.BufferUtil.Operators.Interfaces.* from propath.
using classes.BufferUtil.Operators.Shared.* from propath.
using classes.StringUtil.* from propath.

class classes.BufferUtil.Operators.ContainsOneOfOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        OperatorAsserter:assertNumberOfArguments(this-object, pOperands, 2).
        def var sourceString as char no-undo.
        def var matchesString as char no-undo.
        
        assign  
            sourceString = Wrapper:unwrap(getArgument(pOperands, 1))
            matchesString = Wrapper:unwrap(getArgument(pOperands, 2)).
            
        return string(Matcher:containsOneOf(sourceString, matchesString)).
    end method.
end class.
