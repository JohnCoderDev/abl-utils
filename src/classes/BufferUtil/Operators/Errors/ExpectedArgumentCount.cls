using Progress.Lang.* from propath.
using classes.Exception.* from propath.

class classes.BufferUtil.Operators.Errors.ExpectedArgumentCount inherits Exception:
    constructor ExpectedArgumentCount(pObject as object, pCount as int):
        super('`' + pObject:getClass():typeName + '` must receive exactly ' + string(pCount) + ' arguments', -6310).
    end constructor.
end class.
