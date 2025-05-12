block-level on error undo, throw.
using classes.StringUtil.* from propath.    
using classes.BufferUtil.* from propath.    
using classes.BufferUtil.Operators.Interfaces.* from propath.
using classes.BufferUtil.Operators.Errors.* from propath.

class classes.BufferUtil.Operators.SubtractOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        def var operationResult as char no-undo.
        def var firstArgument as char no-undo.
        def var currentArgument as char no-undo.
        def var currentArgumentType as char no-undo.
        def var operationResultType as char no-undo.
        def var currentArgumentIsNumeric as log no-undo.
        def var operationResultIsNumeric as log no-undo.
        def var i as int no-undo.
        
        assign firstArgument = getArgument(pOperands, 1).
        if firstArgument = '' then return ''.
        
        if TypeInterpreter:guessType(firstArgument) = 'character' then do:
            return error new SubtractOperatorError().
        end.
        
        assign operationResult = firstArgument.
        
        do i = 2 to argumentCount(pOperands):
            assign
                currentArgument = getArgument(pOperands, i)
                currentArgumentType = TypeInterpreter:guessType(currentArgument)
                operationResultType = TypeInterpreter:guessType(operationResult)
                currentArgumentIsNumeric = TypeInterpreter:isNumeric(currentArgument)
                operationResultIsNumeric = TypeInterpreter:isNumeric(operationResult).
            
            if currentArgumentType = 'character' then do:
                return error new SubtractOperatorError().
            end.
            else if currentArgumentIsNumeric then do:
                if operationResultIsNumeric then do:
                    assign operationResult = string(dec(operationResult) - dec(currentArgument)).
                end.
                else if operationResultType = 'date' then do:
                    assign operationResult = string(date(operationResult) - dec(currentArgument)).
                end.
                else if operationResultType = 'datetime' then do:
                    assign operationResult = string(datetime(operationResult) - int(currentArgument)).
                end.
                else if operationResultType = 'logical' then do:
                    assign operationResult = string(int(logical(operationResult)) - dec(currentArgument)).
                end.
                else do:
                    return error new SumOperatorError().
                end.
            end.
            else if currentArgumentType = 'date' or currentArgumentType = 'datetime' then do:
                if operationResultIsNumeric or operationResultType = 'logical' then do:
                    return error new SubtractOperatorError('negative').
                end.
                else if operationResultType = 'date' or operationResultType = 'datetime' then do:
                    return error new InvalidSumBetweenDates().
                end.
                else do:
                    return error new SubtractOperatorError().
                end.
            end.
            else if currentArgumentType = 'logical' then do:
                if operationResultIsNumeric then do:
                    assign operationResult = string(dec(operationResult) - int(logical(currentArgumentType))).
                end.
                else if operationResultType = 'logical' then do:
                    return error new SubtractOperatorError('logical').
                end.
                else if operationResultType = 'date' or operationResultType = 'datetime' then do:
                    return error new SubtractOperatorError('negative').
                end.
                else do:
                    return error new SubtractOperatorError().
                end.
            end.
        end.
        return operationResult.
    end method.
end class.
