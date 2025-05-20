block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.StringUtil.Errors.* from propath.

class classes.StringUtil.Sanitizer:
    method public static char numbers(pSource as char):
        return filterChars(pSource, Alphabet:numbers).
    end method.
    
    method public static char alpha(pSource as char):
        return filterChars(pSource, Alphabet:alpha).
    end method.
    
    method public static char alphaNum(pSource as char):
        return filterChars(pSource, Alphabet:AlphaNum).
    end method.
    
    method public static char removeSpecial(pSource as char):
        return filterChars(pSource, Alphabet:special, true).
    end method.
    
    method public static char removeNonPrintable(pSource as char):
        return filterChars(pSource, Alphabet:nonPrintable, true).
    end method.
    
    method public static char removeSpaces(pSource as char):
        return filterChars(pSource, Alphabet:blankchars, true).
    end method.
    
    method public static char filterChars(pSource as char, pFilter as char):
        return filterChars(pSource, pFilter, false).
    end method.
    
    method public static char replaceAccentChars(pSource as char):
        return replaceChars(pSource, Alphabet:accentChars, Alphabet:accentCharsReplacement).
    end method.
    
    method public static char escapeWild(pSource as char):  
        return Sanitizer:escapeChars(pSource, Alphabet:wild).
    end method.
    
    method public static char escapeChars(pSource as char, pEscape as char):
        def var i as int no-undo.
        def var c as char no-undo.
        def var r as char no-undo.
        assign r = pSource.
        
        do i = 1 to length(pEscape):
            assign
                c = Matcher:charAt(pEscape, i)
                r = replace(r, c, '~~' + c).
        end.
        
        return r.
    end method.
    
    method public static char wipeSpaces(pSource as char):
        def var wiped as char no-undo.
        def var currentChar as char no-undo.
        def var lastChar as char no-undo.
        def var i as int no-undo.
        def var j as int no-undo.
        
        assign 
            wiped = substring(pSource, 1, 1)
            j = 1.
            
        do i = 2 to length(pSource):
            assign 
                currentChar = substring(pSource, i, 1)
                lastChar = substring(wiped, j, 1).
            
            if currentChar = ' ' and lastChar = ' ' then next.
            assign
                wiped = wiped + currentChar
                j = j + 1.
        end.
        return trim(wiped).
    end method.
    
    method public static char capitalize(pSource as char):
        def var i as int no-undo.
        def var capitalized as char no-undo.
        def var currentWord as char no-undo.
        
        do i = 1 to num-entries(pSource, ' '):
            assign
                currentWord = entry(i, pSource, ' ')
                currentWord = upper(substring(currentWord, 1, 1)) + lower(substring(currentWord, 2))
                capitalized = capitalized + currentWord + ' '.
        end.
        
        assign capitalized = substring(capitalized, 1, length(capitalized) - 1).
        return capitalized.
    end method.
    
    method public static char normalAlphaNum(pSource as char):
        def var normal as char no-undo.
        assign    
            normal = removeSpecial(pSource)
            normal = replaceAccentChars(normal)
            normal = trim(normal).
        return normal.    
    end method.
    
    method public static char pascalCase(pSource as char):
        def var cased as char no-undo.
        assign
            cased = normalAlphaNum(pSource)
            cased = shiftLeftNumbers(pSource)
            cased = capitalize(cased)
            cased = removeSpaces(cased)
            cased = removeNonPrintable(cased).
        return cased.    
    end method.
    
    method public static char camelCase(pSource as char):
        def var cased as char no-undo.
        assign
            cased = pascalCase(pSource)
            cased = lower(Matcher:charAt(cased, 1)) + substring(cased, 2).
        return cased.
    end method.
    
    method public static char kebabCase(pSource as char):
        def var cased as char no-undo.
        assign
            cased = filterChars(pSource, Alphabet:nonKebabSpecial, true)
            cased = replaceAccentChars(cased)
            cased = wipeSpaces(cased)
            cased = shiftLeftNumbers(cased)
            cased = shiftLeft(cased, '-_')
            cased = removeNonPrintable(cased)
            cased = replaceChars(cased, ' ', '-').
        return cased.    
    end method.
    
    method public static char shiftLeftNumbers(pSource as char):
        return shiftLeft(pSource, Alphabet:numbers).
    end method.
    
    method public static char shiftLeft(pSource as char, pShift as char):
        def var shifted as char no-undo.
        def var i as int no-undo.
        def var c as char no-undo.
        
        do i = 1 to length(pSource):
            assign c = Matcher:charAt(pSource, i).
            if not Matcher:contains(pShift, c) then leave.
        end.
        
        return substring(pSource, i).
    end method.
    
    method public static char filterChars(pSource as char, pFilter as char, pReverse as logical):
        def var r as char no-undo.
        def var c as char no-undo.
        def var i as int no-undo.
        
        do i = 1 to length(pSource):
            assign c = substring(pSource, i, 1).
            if (index(pFilter, c) > 0 and not pReverse) or (index(pFilter, c) = 0 and pReverse) then do:
                assign r = r + c.
            end.    
        end.
        return r.
    end method.
    
    method public static char replaceChars(pString as char, pChars as char, pReplacement as char):
        if length(pChars) <> length(pReplacement) then do:
            return error new InvalidReplaceCharCall('the chars and the replacement must be the same size').
        end.
        
        def var replaced as char no-undo.
        def var oldChar as char no-undo.
        def var newChar as char no-undo.
        def var i as int no-undo.
        
        assign replaced = pString.
        do i = 1 to length(pChars):
            assign
                oldChar = substring(pChars, i, 1)
                newChar = substring(pReplacement, i, 1)
                replaced = replace(pString, oldChar, newChar).
        end.
        return replaced.
    end method.
end class.
