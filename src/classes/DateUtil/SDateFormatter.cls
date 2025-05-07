block-level on error undo, throw.
using classes.DateUtil.* from propath.

class classes.DateUtil.SDateFormatter:
    def protected static property formatter as DateFormatter no-undo get. set.
    
    method public static char nowFileName():
        return SDateFormatter:format(now, "%dd%-%mm%-%y%_%hh%-%nn%-%ss%").
    end method.
    
    method public static char format(pDate as datetime-tz, pFormat as char):
        return SDateFormatter:format(datetime(string(pDate)), pFormat).
    end method.
    
    method public static char format(pDate as char, pFormat as char):
        return SDateFormatter:format(datetime(pDate), pFormat).
    end method.
    
    method public static char format(pDate as date, pFormat as char):
        return SDateFormatter:format(datetime(pDate), pFormat).
    end method.
    
    method public static char format(pDate as datetime, pFormat as char):
        def var formattedDate as char no-undo.
        assign
            formatter = new DateFormatter(pDate)
            formattedDate = formatter:format(pFormat).
        delete object formatter.
        return formattedDate.
    end method.
end class.
