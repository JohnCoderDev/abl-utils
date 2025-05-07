block-level on error undo, throw.

class classes.StringUtil.StringFiller:
    method public static char fillLeft(pString as char, pFiller as char, pCount as int):
        def var i as int no-undo.
        do i = 1 to pCount:
            assign pString = pFiller + pString.
        end.
        return pString.
    end method.
    
    method public static char fillRight(pString as char, pFiller as char, pCount as int):
        def var i as int no-undo.
        do i = 1 to pCount:
            assign pString = pString + pFiller.
        end.
        return pString.
    end method.
    
    method public static char fillMaxLeft(pString as char, pFiller as char, pMax as int):
        def var i as int no-undo.
        def var len as int no-undo.
        assign len = length(pString).
        do i = len + 1 to pMax:
            assign pString = pFiller + pString.
        end.
        return pString.
    end method.
    
    method public static char fillMaxRight(pString as char, pFiller as char, pMax as int):
        def var i as int no-undo.
        def var len as int no-undo.
        assign len = length(pString).
        do i = len + 1 to pMax:
            assign pString = pString + pFiller.
        end.
        return pString.
    end method.
end class.
