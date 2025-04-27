using classes.Exception.* from propath.

class classes.StringUtil.Errors.InvalidReplaceCharCall inherits Exception:
    constructor InvalidReplaceCharCall(pMessage as char):
        addMessage(pMessage, -6000).
    end constructor.    
end class.
