block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.DateUtil.* from propath.

class classes.DateUtil.DateFormatter:
    def public property date as datetime no-undo get. protected set.
    def public property totalSeconds as int no-undo get. protected set.
    def public property day as int no-undo get. protected set.
    def public property month as int no-undo get. protected set.
    def public property year as int no-undo get. protected set.
    def public property hour as int no-undo get. protected set.
    def public property minute as int no-undo get. protected set.
    def public property second as int no-undo get. protected set.
    
    constructor DateFormatter(pDate as datetime):
        parseDate(pDate).
    end constructor.
    
    constructor DateFormatter(pDate as date):
        parseDate(datetime(pDate)).
    end constructor.
    
    constructor DateFormatter(pDate as char):
        parseDate(datetime(pDate)).
    end constructor.
    
    
    constructor DateFormatter(pDate as datetime-tz):
        parseDate(datetime(string(pDate))).
    end constructor.
    
    method public DateFormatter parseDate(pDate as datetime):
        assign
            date = pDate
            day = day(date)
            month = month(date)
            year = year(date)
            totalSeconds = int(truncate(mtime(date) / 1000, 0))
            hour = int(truncate(totalSeconds / (60 * 60), 0))
            minute = int(truncate((totalSeconds - hour * 60 * 60) / 60, 0))
            second = totalSeconds - hour * 60 * 60 - minute * 60.
        return this-object.    
    end method.
    
    method public char format(pFormat as char):
        def var formattedDate as char no-undo.
        assign
            formattedDate = replace(pFormat, '%d%', string(day))
            formattedDate = replace(formattedDate, '%m%', string(month))
            formattedDate = replace(formattedDate, '%y%', string(year))
            formattedDate = replace(formattedDate, '%h%', string(hour))
            formattedDate = replace(formattedDate, '%n%', string(minute))
            formattedDate = replace(formattedDate, '%s%', string(minute))
            formattedDate = replace(formattedDate, '%dd%', StringFiller:fillMaxLeft(string(day), '0', 2))
            formattedDate = replace(formattedDate, '%mm%', StringFiller:fillMaxLeft(string(month), '0', 2))
            formattedDate = replace(formattedDate, '%hh%', StringFiller:fillMaxLeft(string(hour), '0', 2))
            formattedDate = replace(formattedDate, '%nn%', StringFiller:fillMaxLeft(string(minute), '0', 2))
            formattedDate = replace(formattedDate, '%ss%', StringFiller:fillMaxLeft(string(second), '0', 2)).
        return formattedDate.
    end method.
end class.
