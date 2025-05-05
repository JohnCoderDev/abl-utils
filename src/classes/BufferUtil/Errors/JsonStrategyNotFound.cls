class classes.BufferUtil.Errors.JsonStrategyNotFound inherits classes.Exception.Exception:
    constructor JsonStrategyNotFound(pStrategy as char):
        super('json strategy `' + pStrategy + '` not found, it must be `join`, `merge` or `separete`', -6200).
    end method.
end class.
