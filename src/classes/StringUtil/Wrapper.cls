block-level on error undo, throw.
using classes.StringUtil.* from propath.

class classes.StringUtil.Wrapper:
    method public static char wrap(pPhrase as char):
        return wrap(pPhrase, '"').
    end method.
    
    method public static char wrap(pPhrase as char, pWrapper as char):
        if pWrapper = '(' then return '(' + pPhrase + ')'.
        if pWrapper = '[' then return '[' + pPhrase + ']'.
        if pWrapper = '~{' then return '~{' + pPhrase + '~}'.
        return pWrapper + pPhrase + pWrapper.
    end method.
    
    method public static char unwrap(pPhrase as char):
        return unwrap(pPhrase, '"').
    end method.
    
    method public static char unwrap(pPhrase as char, pWrapper as char):
        def var firstChar as char no-undo.
        def var lastChar as char no-undo.
        def var phraseLen as int no-undo.
        
        assign
            phraseLen = length(pPhrase)
            firstChar = Matcher:charAt(pPhrase, 1)
            lastChar = Matcher:charAt(pPhrase, phraseLen).
        
        if wrapped(pPhrase, pWrapper) then 
            return Splitter:textBetween(pPhrase, 2, phraseLen - 1).
        return pPhrase.
    end method.
    
    method public static log wrapped(pPhrase as char):
        return wrapped(pPhrase, '"').
    end method.
    
    method public static log wrapped(pPhrase as char, pWrapper as char):    
        def var firstChar as char no-undo.
        def var lastChar as char no-undo.
        
        
        assign
            firstChar = Matcher:charAt(pPhrase, 1)
            lastChar = Matcher:charAt(pPhrase, length(pPhrase)).
        
        if firstChar = '' or lastChar = '' then return false.
        if pWrapper = '(' and firstChar = '(' and lastChar = ')' then return true.
        if pWrapper = '[' and firstChar = '[' and lastChar = ']' then return true.
        if pWrapper = '~{' and firstChar = '~{' and lastChar = '~}' then return true.
        return firstChar = pWrapper and lastChar = pWrapper.
    end method.
end class.
