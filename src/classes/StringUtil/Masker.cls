block-level on error undo, throw.
using classes.StringUtil.* from propath.
class classes.StringUtil.Masker:
    def public static property defaultIndicator as char init '#' get.
    
    method public static char mask(pSource as char, pMask as char, pMaskIndicator as char):
        return mask(pSource, pMask, pMaskIndicator, '').
    end method.
    
    method public static char mask(pSource as char, pMask as char, pMaskIndicator as char, pFiller as char):
        def var masked as char no-undo.
        def var m as char no-undo.
        def var i as int no-undo.
        def var j as int no-undo.
        
        assign 
            j = length(pMask).
        
        do i = length(pSource) to 1 by -1:
            do while (not Matcher:equal(Matcher:charAt(pMask, j), pMaskIndicator) and j > 0):
                assign 
                    masked = Matcher:charAt(pMask, j) + masked
                    j = j - 1.
            end.
            if j < 1 then leave.
            assign 
                masked = Matcher:charAt(pSource, i) + masked
                j = j - 1.
        end.
        
        do while j > 0:
            assign
                m = Matcher:charAt(pMask, j)
                masked = (if m = pMaskIndicator then pFiller else m) + masked
                j = j - 1.
        end.
        
        return masked.
    end method.
end class.
