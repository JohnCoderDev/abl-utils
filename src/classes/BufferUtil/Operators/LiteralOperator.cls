block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.DateUtil.* from propath.
using classes.BufferUtil.* from propath.    
using classes.BufferUtil.Operators.Errors.* from propath.
using classes.BufferUtil.Operators.Shared.* from propath.
using classes.BufferUtil.Operators.Interfaces.* from propath.

class classes.BufferUtil.Operators.LiteralOperator inherits BufferOperator:
    method public override char evaluate(pBuffer as Buffer, pOperands as char):
        OperatorAsserter:assertNumberOfArguments(this-object, pOperands, 2).
        def var literal as char no-undo.
        def var literalType as char no-undo.
        
        assign 
            literal = getArgument(pOperands, 1)
            literalType = getArgument(pOperands, 2).
        
        case literalType:
            when 'character' then do:
                assign literal = replaceEscapedChars(literal).
                return literal.
            end.
            when 'number' then do:
                return Wrapper:unwrap(literal).
            end.    
            when 'date' then do:
                def var dateValue as date no-undo.
                assign literal = Wrapper:unwrap(literal).
                if ISODate:isISODate(literal) then do:
                    assign dateValue = ISODate:fromISODate(literal).
                end.
                else do:
                    assign dateValue = date(Wrapper:unwrap(literal)).
                end.    
                return string(dateValue).
            end.
            when 'datetime' then do:
                def var datetimeValue as datetime no-undo.
                assign literal = Wrapper:unwrap(literal).
                if ISODate:isISODatetime(literal) then do:
                    assign datetimeValue = ISODate:fromISODatetime(literal).
                end.
                else do:
                    assign datetimeValue = datetime(literal).
                end.
                return string(datetimeValue).
            end.
            otherwise do:
                return error new UnknownLiteral(literal, literalType).
            end.
        end case.
    end method.
end class.
