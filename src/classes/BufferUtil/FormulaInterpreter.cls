block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.BufferUtil.* from propath.

class classes.BufferUtil.FormulaInterpreter:
    def public property formula as char no-undo get. protected set.
    def public property escapeChar as char no-undo init '\' get.
    def public property operationCount as int no-undo get. set.
    
    def temp-table operations
        field id as char
        field operator as char
        field operands as char
        field operationResult as char
        field operatorClass as char.
    
    def temp-table operators
        field precedence as int
        field symbol as char
        field operatorClass as char
        field middle as log
        index idxPrecedence precedence ascending.
    
    constructor FormulaInterpreter():
        assignDefaultOperators().
    end constructor.
    
    constructor FormulaInterpreter(pFormula as char):
        parseFormula(pFormula).
        assignDefaultOperators().
    end constructor.
    
    method public FormulaInterpreter parseFormula(pFormula as char):
        empty temp-table operations.
        assign operationCount = 0.
        def var expression as char no-undo.
        def var subExpression as char no-undo.
        def var resultExpression as char no-undo.
        def var rightMostParenthesis as int no-undo.
        
        assign 
            formula = Sanitizer:wipeSpaces(pFormula)
            expression = formula
            expression = parseLiterals(expression).
        
        do while expression <> '&R':
            assign 
                subExpression = Extractor:extract(expression, "(", ")")
                subExpression = if subExpression = '' then expression else subExpression
                resultExpression = parseExpression(subExpression).
            
        end.
    end method.
    
    method protected char parseExpression(pExpression as char):
    
    end method.
    
    method public char parseLiterals(pExpression as char):
        def var strStart as int no-undo.
        def var strEnd as int no-undo.
        def var stringAccumulator as char no-undo.
        def var currentChar as char no-undo.
        def var newExpression as char no-undo.
        def var expressionLen as int no-undo.
        def var isResetChar as log no-undo.
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
                isResetChar = Matcher:hasOneOfChars(currentChar, '(), ')
                isLastChar = i = expressionLen
                stringAccumulator = stringAccumulator + (if not isResetChar then currentChar else '').
            
            if isResetChar or isLastChar then do:
                if Matcher:isNumeric(stringAccumulator) then do:
                    addOperation('literal', '"' + stringAccumulator + '",date', '', '').
                    assign newExpression = newExpression + operations.id.
                end.
                else if Matcher:isDate(stringAccumulator) then do:
                    addOperation('literal', '"' + stringAccumulator + '", date', '', '').
                    assign newExpression = newExpression + operations.id.
                end.
                else if Matcher:isValidFieldName(stringAccumulator) and currentChar <> '(' then do:
                    addOperation('field', stringAccumulator, '', '').
                    assign newExpression = newExpression + operations.id. 
                end.
                else do:
                    assign newExpression = newExpression + stringAccumulator.    
                end.
                
                assign 
                    newExpression = newExpression + (if not isLastChar then currentChar else '')
                    stringAccumulator = ''.
            end.
        end.
        for each operations:
            disp operations.operands format 'x(60)' with scrollable.
        end.
        return newExpression.
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
            addOperation('literal', '', 'literal(' + substringExpression + ', character)', '').
            pExpression = replace(pExpression, substringExpression, operations.id).
        end.
        return pExpression.
    end method.
    
    method protected int findNextNonEscapedMatch(pExpression as char, pChar as char):
        def var previous as char no-undo.
        def var curr as char no-undo.
        def var i as int no-undo.
        do i = 1 to length(pExpression):
            assign
                curr = Matcher:charAt(pExpression, i)
                previous = Matcher:charAt(pExpression, i - 1).
            
            if curr = pChar and previous <> escapeChar then do:
                return i.
            end.
        end.
        return 0.
    end method.
    
    method protected void addOperation(
        pOperator as char,
        pOperands as char,
        pOperationResult as char,
        pOperationClass as char
    ):
        create operations.
        assign
            operationCount = operationCount + 1
            operations.id = '&' + string(operationCount)
            operations.operator = pOperator
            operations.operands = pOperands
            operations.operationResult = pOperationResult
            operations.operatorClass = pOperationClass.    
    end method.
        
    
    method public FormulaInterpreter assignDefaultOperators():
        addOperator('mod', 'classes.BufferUtil.Operators.ModOperator', 1, true).
        addOperator('^', 'classes.BufferUtil.Operators.ExponencialOperator', 1, true).
        addOperator('*', 'classes.BufferUtil.Operators.MultiplyOperator', 2, true).
        addOperator('/', 'classes.BufferUtil.Operators.DivisionOperator', 2, true).
        addOperator('+', 'classes.BufferUtil.Operators.SumOperator', 3, true).
        addOperator('-', 'classes.BufferUtil.Operators.SubtractOperator', 3, true).
    end method.
    
    method public void applyFormula(pBuffer as Buffer, pTarget as char):
        
    end method.
    
    method public log validateFormula(pBuffer as Buffer, pFormula as char):
    end method.
    
    method public log checkBalance(pFormula as char):
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
            if parenthesisBalance < 0 then return false.
        end.
        return parenthesisBalance = 0 
            and (quoteBalance mod 2 = 0) 
            and (doubleQuoteBalance mod 2 = 0).
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
            operators.operatorClass = pClass
            operators.middle = pMiddle.
        return this-object.    
    end method.
    
    method protected log findOperator(pSymbol as char):
        find first operators 
            where operators.symbol = pSymbol
            no-error.
        return avail operators.        
    end method.
end class.
