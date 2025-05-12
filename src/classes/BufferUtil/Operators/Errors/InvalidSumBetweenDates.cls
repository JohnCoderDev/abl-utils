using classes.Exception.* from propath.

class classes.BufferUtil.Operators.Errors.InvalidSumBetweenDates inherits Exception:
    constructor InvalidSumBetweenDates():
        super('attempt to sum date or datetimes with dates or datetimes', -6317).
    end constructor.
end class.
