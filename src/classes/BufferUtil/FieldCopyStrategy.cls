block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Errors.* from propath.


class classes.BufferUtil.FieldCopyStrategy:
    def public static property DEFAULT as char init 'force' no-undo get.
    
    def public static property STRATEGY_FORCE as char init 'force' no-undo get.
    def public static property STRATEGY_REPLACE as char init 'replace' no-undo get.
    def public static property STRATEGY_EMPTY as char init 'empty' no-undo get.
    
    constructor static FieldCopyStrategy():
        addStrategy('force', 'copyForce').
        addStrategy('replace', 'copyToAvailableOrReplace').
        addStrategy('empty', 'copyOnlyToAvailable').
    end constructor.
    
    def static private temp-table strategy
        field name as char
        field method as char
        index name as primary unique name.
    
    method public static log copy(pSource as Buffer, pTarget as Buffer, pField as char):
        return copy(pSource, pTarget, pField, FieldCopyStrategy:DEFAULT).
    end method.
    
    method public static log copy(pSource as Buffer, pTarget as buffer, pField as char, pStrategy as char):
        
    end method.
    
    method protected static log copyForce(pSource as Buffer, pTarget as Buffer, pField as char):
    end method.
    
    method protected static log copyToAvailableOrReplace(pSource as Buffer, pTarget as Buffer, pField as char):
    end method.
    
    method protected static log copyOnlyToAvailable(pSource as Buffer, pTarget as Buffer, pField as char):
    end method.
    
    method public static void addStrategy(pName as char, pMethod as char):
        if not findStrategy(pName) then do:
            create strategy.
        end.
        assign
            strategy.name = pName
            strategy.method = pMethod.
    end method.
    
    method protected static log findStrategy(pName as char):
        find strategy where name = pName.
        return avail strategy.
    end method.
    
    method protected static void assertStrategy(pName as char):
        if not findStrategy(pName) then do:
            return error new StrategyNotFound(pName).
        end.
    end method.
end class.
