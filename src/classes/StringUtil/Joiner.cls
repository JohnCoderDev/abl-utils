block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.BufferUtil.* from propath.

class classes.StringUtil.Joiner:
    def public static property defaultSeparator as char init ',' no-undo get. set.
    def public static property defaultQuote as char init '"' no-undo get. set.
    
    method public static char join(pBuffer as Buffer, pField as char):
        return Joiner:join(pBuffer, pField, defaultSeparator).
    end method.
    
    method public static char join(pBuffer as Buffer, pField as char, pSep as char):
        return Joiner:join(pBuffer, pField, pSep, defaultQuote).
    end method.
    
    method public static char join(pBuffer as Buffer, pField as char, pSep as char, pQuote as char):
        if pBuffer:extent(pField) = 0 then do:
            if pQuote = '' or pQuote = ? then return pBuffer:value(pField).
            return quoter(pBuffer:value(pField), pQuote).    
        end.
        
        def var joined as char no-undo.
        def var i as int no-undo.
        do i = 1 to pBuffer:extent(pField):
            assign joined = joined + 
                (if pQuote = '' or pQuote = ? 
                    then pBuffer:value(pField, i) 
                    else quoter(pBuffer:value(pField, i), pQuote)
                ) + pSep.
        end.
        
        return substring(joined, 1, length(joined) - length(pSep)).
    end method.
end class.
