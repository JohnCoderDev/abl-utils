using Progress.Lang.* from propath.
using classes.Exception.* from propath.

class classes.BufferUtil.Operators.Errors.ExpectedMaximumArgumentCount inherits Exception:
    constructor ExpectedMaximumArgumentCount(pObject as object, pCount as int):
        super('`' + pObject:getClass():typeName + '` must receive a maximum of ' + string(pCount) + ' arguments', -6312).
    end constructor.
end class.
