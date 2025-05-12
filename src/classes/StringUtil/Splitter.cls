block-level on error undo, throw.
using classes.StringUtil.* from propath.

class classes.StringUtil.Splitter:
    method public static char textAfter(pText as char, pDelim as char):
        return textAfter(pText, pDelim, 1).
    end method.
    
    method public static char textAfter(pText as char, pDelim as char, pOcurrence as int):
        if pOcurrence < 1 then return ''.
        def var c as int no-undo.
        def var i as int no-undo.
        
        do c = 1 to pOcurrence:
            assign i = index(pText, pDelim).
            if i < 1 then return ''.
            assign pText = substring(pText, i + length(pDelim)).
        end.
        
        return pText.
    end method.
    
    method public static char textBefore(pText as char, pDelim as char):
        return textBefore(pText, pDelim, 1).
    end method.
    
    method public static char textAfter(pText as char, pStart as int):
        if pStart <= 0 then do:
            return ''.
        end.
        return substring(pText, pStart + 1).
    end method.
    
    method public static char textBefore(pText as char, pEnd as int):
        if pEnd <= 1 then do:
            return ''.
        end.
        return substring(pText, 1, pEnd - 1).
    end method.
    
    method public static char textBefore(pText as char, pDelim as char, pOcurrence as int):
        if pOcurrence < 1 then return ''.
        def var c as int no-undo.
        def var i as int no-undo.
        
        do c = 1 to pOcurrence:
            assign i = r-index(pText, pDelim).
            if i < 1 then return ''.
            assign pText = substring(pText, 1, i - length(pDelim)).
        end.
        
        return pText.
    end method.
    
    method public static char textBetween(pText as char, pStart as int, pEnd as int):
        if pStart < 1 then assign pStart = 1.
        if pEnd < pStart then return ''.
        return substring(pText, pStart, pEnd - pStart + 1).
    end method.
    
    method public static char crop(pText as char, pNumChars as int):
        return substring(pText, 1, pNumChars).
    end method.
end class.
