using classes.Exception.* from propath.
class classes.BufferUtil.Errors.UnbalancedExpression inherits Exception:
    constructor UnbalancedExpression(pClose as char, pPosition as int):
        super('there is one more `' + pClose + '` at position ' + string(pPosition) + ' than necessary', -6305).
    end constructor.
    
    constructor UnbalancedExpression(pMissing as char):
        super('missing closing for `' + pMissing + '`', -6306).
    end method.
end class.

