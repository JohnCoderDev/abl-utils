using Progress.Lang.* from propath.
using classes.Exception.* from propath.

class classes.BufferUtil.Operators.Errors.ExpectedMinimumArgumentCount inherits Exception:
    constructor ExpectedMinimumArgumentCount(pObject as object, pCount as int):
        super('`' + pObject:getClass():typeName + '` must receive at least' + string(pCount) + ' arguments', -6311).
    end constructor.
end class.
