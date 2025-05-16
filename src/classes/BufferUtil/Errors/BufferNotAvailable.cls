using classes.Exception.* from propath.

class classes.BufferUtil.Errors.BufferNotAvailable inherits Exception:
    constructor BufferNotAvailable():
        super('a query buffer is not available, you must call the `table` method before', -6330).
    end constructor.
end class.
