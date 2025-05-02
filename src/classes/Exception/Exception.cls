block-level on error undo, throw.
using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.* from propath.

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
    
    method public log hasErrors():
        return NumMessages > 0.
    end method.
    
    method public JsonArray toJson():
        def var resultArray as JsonArray no-undo.
        def var currentError as JsonObject no-undo.
        def var i as int no-undo.
        
        assign resultArray = new JsonArray().
        do i = 1 to NumMessages:
            assign currentError = new JsonObject().
            currentError:add('code', getMessageNum(i)).
            currentError:add('description', getMessage(i)).
            resultArray:add(currentError).
        end.
        
        return resultArray.
    end method.
end class.
