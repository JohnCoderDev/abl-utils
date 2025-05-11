using classes.Exception.* from propath.
class classes.BufferUtil.Errors.OperatorDoesNotExist inherits Exception:
    constructor OperatorDoesNotExist(pOperator as char):
        super('it was not possible to find an operator for `' + pOperator + '`', -6300).
    end constructor.
end class.
