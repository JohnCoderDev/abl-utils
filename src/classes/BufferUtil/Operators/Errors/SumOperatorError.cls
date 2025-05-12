using classes.Exception.* from propath.

class classes.BufferUtil.Operators.Errors.SumOperatorError inherits Exception:
    constructor SumOperatorError(pType as character):
        super('trying to sum or concatenate string with type ' + pType, -6315).
    end constructor.
    
    constructor SumOperatorError():
        super('it was not possible to perform the sum operation', -6316).
    end constructor.    
end class.
