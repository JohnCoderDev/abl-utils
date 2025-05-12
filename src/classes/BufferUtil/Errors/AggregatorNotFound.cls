using classes.Exception.* from propath.

class classes.BufferUtil.Errors.AggregatorNotFound inherits Exception:
    constructor AggregatorNotFound(pName as char):
        super('it was not possible to find aggregator with name ' + quoter(pName, '`'), -6320).
    end constructor.
end class.
