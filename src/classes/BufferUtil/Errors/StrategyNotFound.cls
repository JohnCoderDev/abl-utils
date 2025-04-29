class classes.BufferUtil.Errors.StrategyNotFound inherits classes.Exception.Exception:
    constructor StrategyNotFound(pName as char):
        super('it was not possible to find copy strategy `' + pName + '`', -6001).
    end constructor.
end class.
