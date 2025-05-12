block-level on error undo, throw.
using classes.StringUtil.* from propath.

class classes.DateUtil.ISODate:
    method public static log isISODate(pSource as char):
         if pSource matches '....-..-..' then do:
            def var day as char no-undo.
            def var month as char no-undo.
            def var year as char no-undo.
            assign
                year = Splitter:textBetween(pSource, 1, 4)
                month = Splitter:textBetween(pSource, 6, 7)
                day = Splitter:textBetween(pSource, 9, 10).
            return
                Sanitizer:numbers(year) = year
                and Sanitizer:numbers(month) = month
                and Sanitizer:numbers(day) = day.    
        end.
        return false.
    end method.
    
    method public static log isISODatetime(pSource as char):
        if (
            pSource matches '....-..-..T..:..:..~~....'
            or pSource matches '....-..-..T..:..:..'
            or pSource matches '....-..-..T..:..:..Z'
            or pSource matches '....-..-..T..:..:..-..:..'
            or pSource matches '....-..-..T..:..:..+..:..'
            or pSource matches '....-..-..T..:..:..~~....Z'
            or pSource matches '....-..-..T..:..:..~~....-..:..'
            or pSource matches '....-..-..T..:..:..~~....+..:..'
        ) then do:
            def var day as char no-undo.
            def var month as char no-undo.
            def var year as char no-undo.
            def var hour as char no-undo.
            def var minute as char no-undo.
            def var second as char no-undo.
            assign
                year = Splitter:textBetween(pSource, 1, 4)
                month = Splitter:textBetween(pSource, 6, 7)
                day = Splitter:textBetween(pSource, 9, 10)
                hour = Splitter:textBetween(pSource, 12, 13)
                minute = Splitter:textBetween(pSource, 15, 16)
                second = Splitter:textBetween(pSource, 18, 19).
            return
                Sanitizer:numbers(year) = year
                and Sanitizer:numbers(month) = month
                and Sanitizer:numbers(day) = day
                and Sanitizer:numbers(hour) = hour
                and Sanitizer:numbers(minute) = minute
                and Sanitizer:numbers(second) = second.
        end.
        return false.
    end method.
    
    method public static date fromISODate(pSource as char):
        if isISODate(pSource) then do:
            def var day as char no-undo.
            def var month as char no-undo.
            def var year as char no-undo.
            def var sessionFormat as char no-undo.
            assign
                year = Splitter:textBetween(pSource, 1, 4)
                month = Splitter:textBetween(pSource, 6, 7)
                day = Splitter:textBetween(pSource, 9, 10)
                sessionFormat = session:date-format
                pSource = Matcher:charAt(sessionFormat, 1) + '/' 
                    + Matcher:charAt(sessionFormat, 2) + '/'
                    + Matcher:charAt(sessionFormat, 3)
                pSource = replace(pSource, 'd', day)
                pSource = replace(pSource, 'm', month)
                pSource = replace(pSource, 'y', year).
            return date(pSource).    
        end.
    end method.
    
    method public static datetime fromISODatetime(pSource as char):
        if isISODatetime(pSource) then do:
            def var day as char no-undo.
            def var month as char no-undo.
            def var year as char no-undo.
            def var hour as char no-undo.
            def var minute as char no-undo.
            def var second as char no-undo.
            def var sessionFormat as char no-undo.
            assign
                year = Splitter:textBetween(pSource, 1, 4)
                month = Splitter:textBetween(pSource, 6, 7)
                day = Splitter:textBetween(pSource, 9, 10)
                hour = Splitter:textBetween(pSource, 12, 13)
                minute = Splitter:textBetween(pSource, 15, 16)
                second = Splitter:textBetween(pSource, 18, 19)
                sessionFormat = session:date-format
                pSource = Matcher:charAt(sessionFormat, 1) + '/' 
                    + Matcher:charAt(sessionFormat, 2) + '/'
                    + Matcher:charAt(sessionFormat, 3) + ' '
                    + hour + ':' + minute + ':' + second
                pSource = replace(pSource, 'd', day)
                pSource = replace(pSource, 'm', month)
                pSource = replace(pSource, 'y', year).
            return datetime(pSource).    
        end.
    end method.
end class.
