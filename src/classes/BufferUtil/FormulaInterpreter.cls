block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.StringUtil.* from propath.
using classes.ClassUtil.* from propath.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Errors.* from propath.
using classes.BufferUtil.Operators.* from propath.

class classes.BufferUtil.FormulaInterpreter:
    def public property formula as char no-undo get. protected set.
    def public property tokenDelimiters as char no-undo init ' (),' get. protected set.
    def public property escapeChar as char no-undo init '\' get. set.
    def public property operationCount as int no-undo get. protected set.
    def public property idIndicator as char init '&' no-undo get.
    
    def temp-table operations
        field id as char format 'x(4)'
        field operands as char format 'x(60)'
        field operationResult as char 
        field operatorClass as char format 'x(60)'
        index idxPrecedence operatorClass.
    
    def temp-table operators
        field precedence as int
        field symbol as char
        field operatorClass as char
        field operatorObject as object
        field middle as log
        index idxPrecedence precedence operatorClass.
    
    constructor FormulaInterpreter():
        assignDefaultOperators().
    end constructor.
    
    constructor FormulaInterpreter(pFormula as char):
        assignDefaultOperators().
        parseFormula(pFormula).
    end constructor.
    
    method public FormulaInterpreter showOperations():
        for each operations no-lock:
            disp
                operations.id
                operations.operands
                operations.operatorClass
                with scrollable.    
        end.
        return this-object.
    end method.
    
    method public FormulaInterpreter assignDefaultOperators():
        addOperator('literal', 'classes.BufferUtil.Operators.LiteralOperator', 1, false).
        addOperator('field', 'classes.BufferUtil.Operators.FieldOperator', 1, false).
        addOperator('%', 'classes.BufferUtil.Operators.ModOperator', 2, true).
        addOperator('^', 'classes.BufferUtil.Operators.ExponentialOperator', 2, true).
        addOperator('*', 'classes.BufferUtil.Operators.MultiplyOperator', 3, true).
        addOperator('/', 'classes.BufferUtil.Operators.DivisionOperator', 3, true).
        addOperator('+', 'classes.BufferUtil.Operators.SumOperator', 4, true).
        addOperator('-', 'classes.BufferUtil.Operators.SubtractOperator', 4, true).
        addOperator('sum', 'classes.BufferUtil.Operators.SumOperator').
        addOperator('exp', 'classes.BufferUtil.Operators.ExponentialOperator').
        addOperator('product', 'classes.BufferUtil.Operators.MultiplyOperator').
    end method.
    
    method public void applyFormula(pBuffer as Buffer, pTarget as char):
        def var bufferOperator as IBufferOperator no-undo.
        def var evaluationResult as char no-undo.
        def var actualArguments as char no-undo.
        
        for each operations,
        first operators 
        where 
            operators.operatorClass = operations.operatorClass
            and operators.symbol <> 'literal':
            
            assign 
                bufferOperator = cast(operators.operatorObject, IBufferOperator)
                actualArguments = replaceArguments(operations.operands)
                evaluationResult = bufferOperator:evaluate(pBuffer, actualArguments)
                operations.operationResult = evaluationResult.
        end.
        
        for last operations:
            pBuffer:updateField(pTarget, operations.operationResult).
        end.
    end method.
    
    method protected char replaceArguments(pCurrentArguments as char):
        def var actualArguments as char no-undo.
        def var currentArgument as char no-undo.
        def var i as int no-undo.
        
        assign actualArguments = pCurrentArguments.
        
        do i = 1 to num-entries(pCurrentArguments):
            assign currentArgument = entry(i, pCurrentArguments).
            if Matcher:charAt(currentArgument, 1) = idIndicator then do:
                find first operations where operations.id = currentArgument.
                actualArguments = replace(actualArguments, currentArgument, operations.operationResult).
            end.
        end.
        
        return actualArguments.
    end method.
    
    method public FormulaInterpreter parseFormula(pFormula as char):
        checkBalance(pFormula).
        empty temp-table operations.
        assign operationCount = 0.
        def var expression as char no-undo.
        def var subExpression as char no-undo.
        def var previousExpression as char no-undo.
        def var newSubExpression as char no-undo.
        def var functionName as char no-undo.
        def var resultExpression as char no-undo.
        def var isLastExpression as log no-undo.
        def var subExpressionPosition as int no-undo.
        def var i as int no-undo.
        
        assign 
            formula = trim(pFormula)
            expression = adjustOperatorsSpacing(formula)
            expression = Sanitizer:wipeSpaces(expression)
            expression = parseLiterals(expression).
        
        do while expression <> '&R':
            assign 
                subExpression = Extractor:extract(expression, "(", ")")
                isLastExpression = subExpression = ''
                subExpression = if isLastExpression then expression else subExpression
                newSubExpression = subExpression
                subExpressionPosition = index(expression, subExpression).
            
            do i = 1 to num-entries(subExpression):
                assign
                    previousExpression = entry(i, subExpression)
                    resultExpression = parseExpression(previousExpression)
                    newSubExpression = replace(newSubExpression, previousExpression, resultExpression).
            end.
            
            if not isLastExpression then do:
                assign functionName = extractToken(expression, subExpressionPosition - 1, - 1).
                
                if functionName <> '' then do:
                    addOperation(functionName, Sanitizer:removeSpaces(newSubExpression)).
                end.
                
                assign expression = replace(expression, functionName + "(" + subExpression + ")", operations.id).
            end.
            else do:   
                assign expression = '&R'.
            end.
        end.
        
        
        
        //createOperators().
        //evaluateLiterals().
        return this-object.
    end method.
    
    method protected void createOperators():
        for each operators:
            assign operators.operatorObject = new classes.ClassUtil.Class(operators.operatorClass):new().
        end.
    end method.
    
    method protected void evaluateLiterals():
        def var bufferOperator as IBufferOperator.
        def var evaluationResult as char no-undo.
        for first operators where operators.symbol = 'literal':
            assign bufferOperator = cast(operators.operatorObject, IBufferOperator).
        end.
        
        for first operators where operators.symbol = 'literal',
            each operations where operations.operatorClass = operators.operatorClass:
            assign 
                evaluationResult = bufferOperator:evaluate(?, operations.operands)
                operations.operationResult = evaluationResult.
        end.    
    end method.
    
    method protected char parseExpression(pExpression as char):
        def var lhs as char no-undo.
        def var rhs as char no-undo.
        def var operatorStart as int no-undo.
        def var operatorEnd as int no-undo.
        def var operationPhrase as char no-undo.
        
        for each operators where operators.middle:
            do while Matcher:contains(pExpression, operators.symbol):
                assign
                    operatorStart = index(pExpression, operators.symbol)
                    operatorEnd = operatorStart + length(operators.symbol)
                    lhs = extractToken(pExpression, operatorStart - 1, -1)
                    rhs = extractToken(pExpression, operatorEnd, 1)
                    operationPhrase = Splitter:textBetween(pExpression, operatorStart - length(lhs) - 1, operatorEnd + length(rhs)).
                    
                addOperation(operators.symbol, lhs + ',' + rhs).
                assign
                    pExpression = replace(pExpression, operationPhrase, operations.id).
            end.
        end.
        return pExpression.
    end method.
    
    method protected char extractToken(pExpression as char, pStart as int, pIncrement as int):
        def var token as char no-undo.
        def var currentChar as char no-undo.
        def var currentPosition as int no-undo.
        
        if pIncrement = 0 then return ''.
        
        assign 
            currentPosition = pStart
            currentChar = Matcher:charAt(pExpression, currentPosition).
        
        if Matcher:hasOneOfChars(currentChar, tokenDelimiters) then do:
            assign 
                currentPosition = currentPosition + pIncrement
                currentChar = Matcher:charAt(pExpression, currentPosition).
        end.
        
        if currentChar = '' then return ''.
        
        do while not Matcher:hasOneOfChars(currentChar, tokenDelimiters) and currentChar <> '':
            if pIncrement < 0 then do:
                assign token = currentChar + token.
            end.
            else do:
                assign token = token + currentChar.
            end.
            assign
                currentPosition = currentPosition + pIncrement
                currentChar = Matcher:charAt(pExpression, currentPosition).
        end.
        
        return token.
    end method.
    
    method protected char adjustOperatorsSpacing(pExpression as char):
        def var operatorPosition as int no-undo.
        def var previousChar as char no-undo.
        def var nextChar as char no-undo.
        def var i as int no-undo.
        
        for each operators where operators.middle:
            do i = 1 to Matcher:countOf(pExpression, operators.symbol):
                assign
                    operatorPosition = Matcher:positionOf(pExpression, operators.symbol, i)
                    previousChar = Matcher:charAt(pExpression, operatorPosition - 1)
                    nextChar = Matcher:charAt(pExpression, operatorPosition + 1).
                
                if asc(previousChar) = -1 then do:
                    assign 
                        pExpression = '0 ' + operators.symbol + ' ' + Splitter:textAfter(pExpression, operatorPosition)
                        operatorPosition = Matcher:positionOf(pExpression, operators.symbol, i)
                        previousChar = Matcher:charAt(pExpression, operatorPosition - 1)
                        nextChar = Matcher:charAt(pExpression, operatorPosition + 1).
                end.
                
                if asc(nextChar) = -1 then do:
                    assign 
                        pExpression = Splitter:textBefore(pExpression, operatorPosition) + ' ' + operators.symbol + ' 0'
                        operatorPosition = Matcher:positionOf(pExpression, operators.symbol, i)
                        previousChar = Matcher:charAt(pExpression, operatorPosition - 1)
                        nextChar = Matcher:charAt(pExpression, operatorPosition + 1).
                end.
                
                if operators.symbol <> '-' then do:
                    assign pExpression = Splitter:textBefore(pExpression, operatorPosition) + ' ' 
                        + operators.symbol + ' ' + Splitter:textAfter(pExpression, operatorPosition).
                end.
                
                if (
                    operators.symbol = '-'
                    and (
                        Matcher:hasOneOfChars(previousChar, tokenDelimiters)
                        or Matcher:hasOneOfChars(nextChar, tokenDelimiters)
                        or Matcher:isNumeric(nextChar)
                    )
                ) then do:
                    message pExpression skip operatorPosition view-as alert-box.
                    assign pExpression = Splitter:textBefore(pExpression, operatorPosition) + ' ' 
                        + operators.symbol + ' ' + Splitter:textAfter(pExpression, operatorPosition).
                    message pExpression view-as alert-box.    
                end.
            end.
        end.
        
        return pExpression.
    end method.
    
    method protected char parseLiterals(pExpression as char):
        def var strStart as int no-undo.
        def var strEnd as int no-undo.
        def var stringAccumulator as char no-undo.
        def var currentChar as char no-undo.
        def var newExpression as char no-undo.
        def var expressionLen as int no-undo.
        def var isTokenDelimiter as log no-undo.
        def var isLastChar as log no-undo.
        def var i as int no-undo.
                
        do while Matcher:containsOneOf(pExpression, '",~''):
            assign
                pExpression = replaceStringLiteral(pExpression, '"')
                pExpression = replaceStringLiteral(pExpression, "'").       
        end.
        
        assign expressionLen = length(pExpression).
        
        do i = 1 to expressionLen:
            assign 
                currentChar = Matcher:charAt(pExpression, i)
                isTokenDelimiter = Matcher:hasOneOfChars(currentChar, tokenDelimiters)
                isLastChar = i = expressionLen
                stringAccumulator = stringAccumulator + (if not isTokenDelimiter then currentChar else '').
            
            if isTokenDelimiter or isLastChar then do:
                if Matcher:isInteger(stringAccumulator) then do:
                    addOperation('literal', quoter(stringAccumulator, '"') + ',integer').
                    assign newExpression = newExpression + operations.id.
                end.
                else if Matcher:isInt64(stringAccumulator) then do:
                    addOperation('literal', quoter(stringAccumulator, '"') + ',int64').
                    assign newExpression = newExpression + operations.id.
                end.
                else if Matcher:isNumeric(stringAccumulator) then do:
                    addOperation('literal', quoter(stringAccumulator, '"') + ',decimal').
                    assign newExpression = newExpression + operations.id.
                end.
                else if Matcher:isDate(stringAccumulator) then do:
                    addOperation('literal', quoter(stringAccumulator, '"') + ',date').
                    assign newExpression = newExpression + operations.id.
                end.
                else if (
                    Matcher:isValidFieldName(stringAccumulator) 
                    and currentChar <> '(' 
                    and not isReserved(stringAccumulator) 
                ) then do:
                    addOperation('field', stringAccumulator).
                    assign newExpression = newExpression + operations.id. 
                end.
                else do:
                    assign newExpression = newExpression + stringAccumulator.    
                end.
                
                assign 
                    newExpression = newExpression + (if isLastChar and isTokenDelimiter or not isLastChar then currentChar else '')
                    stringAccumulator = ''.
            end.
        end.
        return newExpression.
    end method.
    
    method public log isReserved(pString as char):
        return can-find(
            first operators no-lock
            where 
                operators.symbol = pString
                and operators.middle
        ).    
    end method.
    
    method protected char replaceStringLiteral(pExpression as char, pQuote as char):
        def var strStart as int no-undo.
        def var strEnd as int no-undo.
        def var substringExpression as char no-undo.
        
        assign strStart = findNextNonEscapedMatch(pExpression, pQuote).
        if strStart > 0 then do:
            assign 
                strEnd = findNextNonEscapedMatch(Splitter:textAfter(pExpression, strStart), pQuote)
                substringExpression = Splitter:textBetween(pExpression, strStart, strStart + strEnd).     
            addOperation('literal', substringExpression + ',character').
            pExpression = replace(pExpression, substringExpression, operations.id).
        end.
        return pExpression.
    end method.
    
    method protected int findNextNonEscapedMatch(pExpression as char, pChar as char):
        def var previousChar as char no-undo.
        def var currentChar as char no-undo.
        def var i as int no-undo.
        do i = 1 to length(pExpression):
            assign
                currentChar = Matcher:charAt(pExpression, i)
                previousChar = Matcher:charAt(pExpression, i - 1).
            
            if currentChar = pChar and previousChar <> escapeChar then do:
                return i.
            end.
        end.
        return 0.
    end method.
    
    method protected void addOperation(pSymbol as char, pOperands as char):
        assertOperatorExist(pSymbol).
        create operations.
        assign
            operationCount = operationCount + 1
            operations.id = idIndicator + string(operationCount)
            operations.operands = pOperands
            operations.operatorClass = getOperatorClass(pSymbol).    
    end method.
        
    method public char getOperatorClass(pSymbol as char):
        assertOperatorExist(pSymbol).
        return operators.operatorClass.
    end method.    
    
    method protected void assertOperatorExist(pSymbol as char):
        if not findOperator(pSymbol) then do:
            return error new OperatorDoesNotExist(pSymbol).
        end.
    end method.
    
    method protected log findOperator(pSymbol as char):
        find first operators 
            where operators.symbol = pSymbol
            no-error.    
        return avail operators.        
    end method.
    
    method protected void checkBalance(pFormula as char):
        def var i as int no-undo.
        def var currentChar as char no-undo.
        def var previousChar as char no-undo.
        def var parenthesisBalance as int no-undo.
        def var quoteBalance as int no-undo.
        def var doubleQuoteBalance as int no-undo.
        
        do i = 1 to length(pFormula):
            assign 
                currentChar = Matcher:charAt(pFormula, i)
                previousChar = Matcher:charAt(pFormula, i - 1)
                quoteBalance = quoteBalance + (if currentChar = "'" and previousChar <> escapeChar then 1 else 0)
                doubleQuoteBalance = doubleQuoteBalance + (if currentChar = '"' and previousChar <> escapeChar then 1 else 0)
                parenthesisBalance = parenthesisBalance + (if currentChar = "(" then 1 else if currentChar = ")" then -1 else 0).
            if parenthesisBalance < 0 then do:
                return error new UnbalancedExpression(')', i).
            end.
        end.
        
        if parenthesisBalance > 0 then do:
            return error new UnbalancedExpression('(').
        end.
        if quoteBalance mod 2 = 1 then do:
            return error new UnbalancedExpression("'").
        end.
        if doubleQuoteBalance mod 2 = 1 then do:
            return error new UnbalancedExpression('"').
        end.
    end method.
    
    method public FormulaInterpreter addOperator(pSymbol as char, pClass as char):
        return addOperator(pSymbol, pClass, 999).
    end method.
    
    method public FormulaInterpreter addOperator(pSymbol as char, pClass as char, pPrecedence as int):
        return addOperator(pSymbol, pClass, pPrecedence, false).
    end method.
    
    method public FormulaInterpreter addOperator(pSymbol as char, pClass as char, pPrecedence as int, pMiddle as log):
        if not findOperator(pSymbol) then do:
            create operators.
        end.
        assign
            operators.symbol = pSymbol
            operators.precedence = pPrecedence
            operators.operatorClass = pClass
            operators.middle = pMiddle.
        return this-object.    
    end method.
end class.
