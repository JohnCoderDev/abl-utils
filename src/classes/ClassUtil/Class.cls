block-level on error undo, throw.
using Progress.Lang.* from propath.

class classes.ClassUtil.Class:
    def public property name as char no-undo get. set.
    
    constructor Class(pClassName as char):
        assign 
            name = pClassName.
    end constructor.
    
    method public Object new():
        return Progress.Lang.Class:getClass(name):new().
    end method.
    
    method public Progress.Lang.Class classObject():
        return Progress.Lang.Class:getClass(name).
    end method.
    
    method public log exists():
        do on error undo:
            delete object this-object:new().
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.    
    end method.
end class.
