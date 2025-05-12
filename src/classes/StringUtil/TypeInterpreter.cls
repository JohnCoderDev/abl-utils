block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.DateUtil.* from propath.
using classes.StringUtil.* from propath.

class classes.StringUtil.TypeInterpreter:
    method public static char guessType(pSource as char):
        if isInteger(pSource) then return 'integer'.
        else if isInt64(pSource) then return 'int64'.
        else if isDecimal(pSource) then return 'decimal'.
        else if isDate(pSource) then return 'date'.
        else if isDatetime(pSource) then return 'datetime'.
        else if isLogical(pSource) then return 'logical'.
        else return 'character'.
    end method.
    
    method public static log isDecimal(pSource as char):
        return isNumeric(pSource) and not isInt64(pSource).
    end method.
    
    method public static log isInteger(pSource as char):
        do on error undo, throw:
            if not isNumeric(pSource) then return false.
            return int(pSource) = dec(pSource).
            
            catch errorObject as Error:
                return false.
            end catch.
        end.    
    end method.
    
    method public static log isInt64(pSource as char):
        do on error undo, throw:
            if not isNumeric(pSource) then return false.
            return int64(pSource) = dec(pSource).
            
            catch errorObject as Error:
                return false.
            end catch.    
        end.
    end method.
    
    method public static log isNumeric(pSource as char):
        do on error undo, throw:
            assign pSource = Sanitizer:wipeSpaces(pSource).
            if pSource = '' or pSource = '+' or pSource = '-' or Matcher:contains(pSource, '*') then do:
                return false.
            end.
            dec(pSource).
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
    end method.
    
    method public static log isDate(pSource as char):
        do on error undo, throw:
            assign pSource = Sanitizer:wipeSpaces(pSource).
            if ISODate:isISODate(pSource) then return true.
            if Matcher:contains(pSource, ':') then return false.
            
            def var d as date no-undo.
            assign d = date(pSource).
            return d <> ?.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
    end method.
    
    method public static log isDatetime(pSource as char):
        do on error undo, throw:
            assign pSource = Sanitizer:wipeSpaces(pSource).            
            if ISODate:isISODatetime(pSource) then return true.
            if isDate(pSource) then return false.
            
            def var d as datetime no-undo.
            assign d = datetime(pSource).
            return d <> ?.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
    end method.
    
    method public static log isLogical(pSource as char):
        assign pSource = sanitizer:wipeSpaces(pSource).
        return pSource = 'true' or pSource = 'false' or pSource = 'yes' or pSource = 'no'.
    end method.
end class.
