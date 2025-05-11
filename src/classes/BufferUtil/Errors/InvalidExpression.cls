using classes.Exception.* from propath.
class classes.BufferUtil.Errors.InvalidExpression inherits Exception:
    constructor InvalidExpression(pExpression as char):
        super('unable to understand expression `' + pExpression + '`', 6307).
    end constructor.
end class.

