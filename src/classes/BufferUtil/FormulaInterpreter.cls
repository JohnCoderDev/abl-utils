block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.StringUtil.* from propath.
using classes.ClassUtil.* from propath.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Errors.* from propath.
using classes.BufferUtil.Operators.Interfaces.* from propath.

class classes.BufferUtil.FormulaInterpreter:
    def public property formula as char no-undo get. protected set.
    def public property escapeChar as char no-undo init '\' get. protected set.
    def public static property sEscapeChar as char no-undo 
        get:
            return new FormulaInterpreter():escapeChar.
        end.
        
    def public property argumentSeparator as char no-undo 
        get:
            return chr(29).
        end.
        
    def public static property sArgumentSeparator as char no-undo
        get:
            return new FormulaInterpreter():argumentSeparator.
        end.
        
    def public property tokenDelimiters as char no-undo 
        get:
            return ' (),' + argumentSeparator.
        end.    
    def public property operationCount as int no-undo get. protected set.
    def public property idIndicator as char no-undo 
        get:
            return chr(31).
        end.
        
    def temp-table operations
        field id as char format 'x(4)'
        field operands as char format 'x(60)'
        field operationResult as char format 'x(60)'
        field operatorClass as char format 'x(60)'.
    
    def temp-table operators
        field precedence as int
        field symbol as char
        field operatorClass as char
        field operatorObject as object
        field middle as log
        index idxPrecedence precedence.
    
    def temp-table precedences
        field precedence as int 
        index idxPrecedence precedence ascending.
    
    def temp-table operatorPosition
        field position as int
        field symbol as char
        field length as int.
    
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
                operations.operatorClass
                operations.operands
                operations.operationResult
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
        addOperator('month', 'classes.BufferUtil.Operators.MonthOperator').
        addOperator('year', 'classes.BufferUtil.Operators.YearOperator').
    end method.
    
    method public void applyFormula(pBuffer as Buffer, pTarget as char):
        def var bufferOperator as BufferOperator no-undo.
        def var evaluationResult as char no-undo.
        def var actualArguments as char no-undo.
        
        for each operations,
        first operators 
            where 
                operators.operatorClass = operations.operatorClass              
                and operators.symbol <> 'literal':
            
            assign 
                bufferOperator = cast(operators.operatorObject, BufferOperator)
                actualArguments = replaceArguments(operations.operands)
                evaluationResult = bufferOperator:evaluate(pBuffer, actualArguments)
                operations.operationResult = evaluationResult.
        end.
        
        for last operations:
            pBuffer:updateField(pTarget, Wrapper:unwrap(operations.operationResult)).
        end.
    end method.
    
    method protected char replaceArguments(pCurrentArguments as char):
        def var actualArguments as char no-undo.
        def var currentArgument as char no-undo.
        def var i as int no-undo.
        def buffer bOperations for operations.
        
        assign actualArguments = pCurrentArguments.
        
        do i = 1 to num-entries(pCurrentArguments, argumentSeparator):
            assign currentArgument = entry(i, pCurrentArguments, argumentSeparator).    
            if Matcher:charAt(currentArgument, 1) = idIndicator then do:
                find first bOperations where id = currentArgument.
                actualArguments = replace(actualArguments, currentArgument, bOperations.operationResult).
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
                    addOperation(
                        functionName, 
                        Sanitizer:removeSpaces(
                            replace(newSubExpression, ',', argumentSeparator)
                        )
                    ).
                end.
                
                assign expression = replace(expression, functionName + "(" + subExpression + ")", operations.id).
            end.
            else do:   
                assign expression = '&R'.
            end.
        end.
        
        createOperators().
        evaluateLiterals().
        return this-object.
    end method.
    
    method protected void createOperators():
        for each operators:
            assign operators.operatorObject = new classes.ClassUtil.Class(operators.operatorClass):new().
        end.
    end method.
    
    method protected void evaluateLiterals():
        def var bufferOperator as BufferOperator.
        def var evaluationResult as char no-undo.
        for first operators where operators.symbol = 'literal':
            assign bufferOperator = cast(operators.operatorObject, BufferOperator).
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
        def var symbol as char no-undo.
        
        for each precedences:
            assign operatorStart = findNextOperatorIndex(pExpression).
            
            do while operatorStart <> 0:
                assign
                    operatorEnd = operatorStart + operatorPosition.length
                    lhs = extractToken(pExpression, operatorStart - 1, -1)
                    rhs = extractToken(pExpression, operatorEnd, 1)
                    operationPhrase = Splitter:textBetween(pExpression, operatorStart - length(lhs) - 1, operatorEnd + length(rhs)).
                
                addOperation(operatorPosition.symbol, lhs + argumentSeparator + rhs).
                
                assign
                    pExpression = replace(pExpression, operationPhrase, operations.id)
                    operatorStart = findNextOperatorIndex(pExpression).    
            end.
        end.
        
        return pExpression.
    end method.
    
    method protected int findNextOperatorIndex(pExpression as char):
        def var i as int no-undo.
        def var p as int no-undo.
        
        empty temp-table operatorPosition.
        
        for each operators 
            where 
                operators.precedence = precedences.precedence
                and operators.middle:
            
            assign i = index(pExpression, operators.symbol).
            
            if (i > 0 and i < p) or p = 0 then do:
                empty temp-table operatorPosition.
                create operatorPosition.
                assign
                    operatorPosition.symbol = operators.symbol
                    operatorPosition.position = i
                    operatorPosition.length = length(operatorPosition.symbol)
                    p = i.
            end.
        end.
        
        return p.
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
        
        if asc(currentChar) = -1 then return ''.
        
        do while not Matcher:hasOneOfChars(currentChar, tokenDelimiters) and asc(currentChar) <> -1:
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
                    nextChar = Matcher:charAt(pExpression, operatorPosition + length(operators.symbol)).
                
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
                
                if operators.symbol <> '-' and length(operators.symbol) = 1 then do:
                    assign pExpression = Splitter:textBefore(pExpression, operatorPosition) + ' ' 
                        + operators.symbol + ' ' + Splitter:textAfter(pExpression, operatorPosition).
                end.
                else if operators.symbol <> '-' and asc(nextChar) = 32 and asc(previousChar) = 32 then do:
                    assign pExpression = Splitter:textBefore(pExpression, operatorPosition) + ' ' 
                        + operators.symbol + ' ' + Splitter:textAfter(pExpression, operatorPosition).
                end.
                else if (
                    operators.symbol = '-'
                    and Matcher:hasOneOfChars(previousChar, tokenDelimiters)
                    and Matcher:hasOneOfChars(nextChar, tokenDelimiters)
                ) then do:
                    assign pExpression = Splitter:textBefore(pExpression, operatorPosition) + ' ' 
                        + operators.symbol + ' ' + Splitter:textAfter(pExpression, operatorPosition).
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
        def var guessedType as char no-undo.
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
                if TypeInterpreter:isNumeric(stringAccumulator) then do:
                    addOperation('literal', quoter(stringAccumulator, '"') + argumentSeparator + 'number').
                    assign newExpression = newExpression + operations.id.
                end.
                else if TypeInterpreter:isDatetime(stringAccumulator) then do:
                    addOperation('literal', quoter(stringAccumulator, '"') + argumentSeparator + 'datetime').
                    assign newExpression = newExpression + operations.id.
                end.
                else if TypeInterpreter:isDate(stringAccumulator) then do:
                    addOperation('literal', quoter(stringAccumulator, '"') + argumentSeparator + 'date').
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
        def var realSubstringExpression as char no-undo.
        
        assign strStart = findNextNonEscapedMatch(pExpression, pQuote).
        if strStart > 0 then do:
            assign 
                strEnd = findNextNonEscapedMatch(Splitter:textAfter(pExpression, strStart), pQuote)
                substringExpression = Splitter:textBetween(pExpression, strStart, strStart + strEnd)
                realSubstringExpression = substringExpression.
            
            if Wrapper:wrapped(substringExpression, "'") then do:
                assign
                    substringExpression = Wrapper:unwrap(substringExpression, "'")
                    substringExpression = Wrapper:wrap(substringExpression, '"').
            end.
            
            addOperation('literal', substringExpression + argumentSeparator + 'character').
            pExpression = replace(pExpression, realSubstringExpression, operations.id).
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
        addPrecedence(pPrecedence).
        assign
            operators.symbol = pSymbol
            operators.precedence = pPrecedence
            operators.operatorClass = pClass
            operators.middle = pMiddle.
        return this-object.    
    end method. 
    
    method protected void addPrecedence(pPrecedence as int):
        find precedences where precedences.precedence = pPrecedence no-error.
        if not avail precedences then do:
            create precedences.
            assign precedences.precedence = pPrecedence.
        end.
    end method.
end class.
