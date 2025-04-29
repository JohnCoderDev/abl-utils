block-level on error undo, throw.

class classes.StringUtil.Extractor:
    method public static char extract(pSource as char, pLeft as char, pRight as char):
        def var li as int no-undo.
        def var ri as int no-undo.
        
        assign
            li = r-index(pSource, pLeft)
            ri = index(pSource, pRight).
        
        if ri <= li then do:
            return ''.
        end.
        
        return substring(pSource, li, ri - li).
    end method.
end class.
