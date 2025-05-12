using classes.Exception.* from propath.

class classes.BufferUtil.Operators.Errors.UnknownLiteral inherits Exception:
    constructor UnknownLiteral(pLiteral as char, pType as char):
        super('unknown literal ' + quoter(pLiteral, '`') + ' of type ' + quoter(pType, '`'), -6320).
    end constructor.
end class.
