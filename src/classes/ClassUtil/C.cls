block-level on error undo, throw.
using Progress.Lang.* from propath.

class classes.ClassUtil.C:
    def public property className as char no-undo get. set.
    
    constructor C(pClassName as char):
        assign className = pClassName.
    end constructor.
    
    method public Object new():
        return class:getClass(className):new().
    end method.
    
    method public Progress.Lang.Class class():
        return class:getClass(className).
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
