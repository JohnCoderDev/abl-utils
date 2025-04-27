block-level on error undo, throw.
using classes.StringUtil.* from propath.

class classes.StringUtil.Matcher:
    method public static log startsWith(pSource as char, pStart as char):
        def var sourceStart as char no-undo.
        assign sourceStart = substring(pSource, 1, length(pStart)).
        return sourceStart = pStart.
    end method.
    
    method public static log endsWith(pSource as char, pEnd as char):
        def var sourceEnd as char no-undo.
        assign sourceEnd = substring(pSource, length(pSource) - length(pEnd)).
        return sourceEnd = pEnd.
    end method.
    
    method public static log startsWithOneOf(pSource as char, pStarts as char):
        def var i as int no-undo.
        def var startString as char no-undo.
        do i = 1 to num-entries(pStarts):
            assign startString = entry(i, pStarts).
            if startsWith(pSource, startString) then return true.
        end.
        return false.
    end method.
    
    method public static log endsWithOneOf(pSource as char, pEnds as char):
        def var i as int no-undo.
        def var endString as char no-undo.
        do i = 1 to num-entries(pEnds):
            assign endString = entry(i, pEnds).
            if endsWith(pSource, endString) then return true.
        end.
        return false.
    end method.
    
    method public static log contains(pSource as char, pMatch as char):
        return index(pSource, pMatch) > 0.
    end method.
    
    method public static log containsOneOf(pSource as char, pMatches as char):
        def var i as int no-undo.
        def var match as char no-undo.
        do i = 1 to num-entries(pMatches):
            assign match = entry(i, pMatches).
            if contains(pSource, match) then return true.
        end.
        return false.
    end method.
    
    method public static log containsAll(pSource as char, pMatches as char):
        def var i as int no-undo.
        def var match as char no-undo.
        do i = 1 to num-entries(pMatches):
            assign match = entry(i, pMatches).
            if not contains(pSource, match) then return false.
        end.
        return true.
    end method.
    
    method public static log hasNumbers(pSource as char):
        return hasOneOfChars(pSource, Alphabet:numbers).
    end method.
    
    method public static log hasAlpha(pSource as char):
        return hasOneOfChars(pSource, Alphabet:accentAlpha).
    end method.
    
    method public static log hasAlphaNum(pSource as char):
        return hasOneOfChars(pSource, Alphabet:accentAlphaNum).
    end method.
    
    method public static log hasPunctuation(pSource as char):
        return hasOneOfChars(pSource, Alphabet:special).
    end method.
    
    method public static char charAt(pSource as char, pPosition as int):
        return substring(pSource, pPosition, 1).
    end method.
    
    method public static log hasOneOfChars(pSource as char, pChars as char):
        def var i as int no-undo.
        def var c as char no-undo.
        
        do i = 1 to length(pChars):
            assign c = substring(pChars, i, 1).
            if contains(pSource, c) then return true.
        end.
        
        return false.
    end method.
    
    method public static log hasOnlyNumbers(pSource as char):
        return length(Sanitizer:numbers(pSource)) = length(pSource) and pSource <> ''.
    end method.
end class.
