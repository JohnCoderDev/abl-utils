using Progress.Lang.* from propath.
class classes.Exception.Exception inherits AppError:
    constructor Exception(pError as Error):
        def var i as int no-undo.
        do i = 1 to pError:NumMessages:
            addMessage(pError:getMessage(i), pError:getMessageNum(i)).
        end.
    end constructor.
    
    constructor Exception(pMessage as char, pCode as int):
        addMessage(pMessage, pCode).
    end constructor.
    
    method public logical hasErrors():
        return NumMessages > 0.
    end.    
end class.
