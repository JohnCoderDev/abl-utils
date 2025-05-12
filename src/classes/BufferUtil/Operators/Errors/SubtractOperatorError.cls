using classes.Exception.* from propath.

class classes.BufferUtil.Operators.Errors.SubtractOperatorError inherits Exception:
    constructor SubtractOperatorError():
        super('trying to subtract strings', -6318).
    end constructor.
    
    constructor SubtractOperatorError(pType as char):
        super(
            if pType = 'negative'
                then 'trying to sum number with negative date'
            else if pType = 'logical'
                then 'trying to subtract logical with logical'
            else 
                'error when subtracting variable with type ' + quoter(pType, '`'), 
            
            if pType = 'negative'
                then -6320
            else if pType = 'logical'
                then -6321
            else 
                -6319
        ).
    end constructor.
end class.
