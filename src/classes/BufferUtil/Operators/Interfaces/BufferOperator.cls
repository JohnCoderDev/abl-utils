using classes.BufferUtil.* from propath.
class classes.BufferUtil.Operators.Interfaces.BufferOperator abstract:
    def public property argumentSeparator as char no-undo
        get:
            return FormulaInterpreter:sArgumentSeparator.
        end.
        
    def public property escapeChar as char no-undo
        get:
            return FormulaInterpreter:sEscapeChar.
        end.    
    
    method public int argumentCount(pArguments as char):
        if pArguments = '' then return 0.
        return num-entries(pArguments, argumentSeparator).
    end method.
    
    method public char getArgument(pArguments as char, pPosition as int):
        if pPosition < 1 or pPosition > argumentCount(pArguments) then return ''.
        return entry(pPosition, pArguments, argumentSeparator).
    end method.
    
    method public char replaceEscapedChars(pString as char):
        assign  
            pString = replace(pString, escapeChar + '"', '"')
            pString = replace(pString, escapeChar + '~'', '~'').
        return pString.    
    end method.
    
    method public abstract char evaluate(pBuffer as Buffer, pOperands as char).
end class.
