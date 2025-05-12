block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Operators.Errors.* from propath.

class classes.BufferUtil.Operators.Shared.OperatorAsserter:
    def public static property argumentSeparator as char
        get:
            return FormulaInterpreter:sArgumentSeparator.
        end.
        
    method protected static int argumentCount(pOperands as char):
        if pOperands = '' then return 0.
        return num-entries(pOperands, argumentSeparator).
    end method.
    
    method public static void assertNumberOfArguments(
        pOperator as object, 
        pOperands as char, 
        pNumberOfArguments as int
    ):
        if argumentCount(pOperands) <> pNumberOfArguments then
            return error new ExpectedArgumentCount(pOperator, pNumberOfArguments).
    end method.
    
    method public static void assertMinimumNumberOfArguments(
        pOperator as object,
        pOperands as char,
        pMinimum as int
    ):
        if argumentCount(pOperands) < pMinimum then
            return error new ExpectedMinimumArgumentCount(pOperator, pMinimum).
    end method.
    
    method public static void assertMaximumNumberOfArguments(
        pOperator as object,
        pOperands as char,
        pMaximum as int
    ):
        if argumentCount(pOperands) > pMaximum then
            return error new ExpectedMaximumArgumentCount(pOperator, pMaximum).
    end method.
end class.
