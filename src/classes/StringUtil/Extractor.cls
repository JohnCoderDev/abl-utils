block-level on error undo, throw.
using classes.StringUtil.* from propath.

class classes.StringUtil.Extractor:
    method public static char extract(pSource as char, pLeft as char, pRight as char):
        return extract(pSource, pLeft, pRight, false).
    end method.
    
    method public static char extract(pSource as char, pLeft as char, pRight as char, pDelimiters as log):
        def var li as int no-undo.
        def var ri as int no-undo.
        
        assign li = r-index(pSource, pLeft).
        
        if li = 0 then return ''.
        
        assign ri = index(pSource, pRight, li + 1).
        
        if ri = 0 then return ''.
        
        if ri <= li then do:
            return ''.
        end.
        
        return Splitter:textBetween(
            pSource, 
            li + (if not pDelimiters then length(pLeft) else 0), 
            ri - (if not pDelimiters then 1 else 0)
        ).
    end method.
end class.
