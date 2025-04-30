block-level on error undo, throw.
using Progress.Lang.* from propath.
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
        def var i as int no-undo.
        def var limit as int no-undo.
        if not pSource:has(pField) or not pTarget:has(pField) then return false.
        
        do on error undo, throw:        
            if pSource:extent(pField) = 0 and pTarget:extent(pField) = 0 then do:
                pTarget:updateField(pField, pSource:field(pField):buffer-value).
            end.
            else if pSource:extent(pField) = pTarget:extent(pField) then do:
                do i = 1 to pSource:extent(pField):
                    pTarget:updateField(pField, pSource:field(pField):buffer-value(i), i).
                end.
            end.
            else do:
                assign limit = minimum(pSource:extent(pField), pTarget:extent(pField)).
                do i = 1 to limit:
                    pTarget:updateField(pField, pSource:field(pField):buffer-value(i), i).
                end.
            end.
            
            return true.
            
            catch errorObject as Error:
                return false.
            end.
        end.    
    end method.
    
    method protected static log copyToAvailableOrReplace(pSource as Buffer, pTarget as Buffer, pField as char):
        def var i as int no-undo.
        def var sourceFill as int no-undo.
        def var targetAvailable as int no-undo.
        def var sourceInitialCount as int no-undo.
        def var targetInitialCount as int no-undo.
        def var targetInitial as char no-undo.
        
        if not pSource:has(pField) or not pTarget:has(pField) then return false.
        
        assign targetInitial = pTarget:initial(pField).
        
        do on error undo, throw:
            if pSource:extent(pField) = 0 and pTarget:extent(pField) = 0 then do:
                if pSource:value(pField) = targetInitial then return false.
                pTarget:updateField(pField, pSource:field(pField):buffer-value).
            end.
            else if pSource:extent(pField) = 0 then do:
                if pSource:field(pField):buffer-value = targetInitial then return false.
                assign targetInitialCount = pTarget:fieldCountInitial(pField).
                if targetInitialCount = 0 then do:
                    pTarget:updateField(pField, pSource:field(pField):buffer-value, 1).
                end.
                else do:
                    
                end.
            end.
            else do:
                assign
                    sourceInitialCount = pSource:fieldCountValueEqual(pField, targetInitial)
                    targetInitialCount = pTarget:fieldCountInitial(pField).
                
                if sourceInitialCount < targetInitialCount then do:
                    do i = 1 to sourceInitialCount:
                        assign 
                            sourceFill = pSource:nextExtentWithValueNotEqual(pField, targetInitial)
                            targetAvailable = pTarget:nextExtentWithInitial(pField).
                        
                        pTarget:updateField(pField, pSource:field(pField):buffer-value(sourceFill), targetAvailable).
                    end.
                end.
                else do:
                    copyForce(pSource, pTarget, pField).
                end.
            end.
            
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
    end method.
    
    method protected static log copyOnlyToAvailable(pSource as Buffer, pTarget as Buffer, pField as char):
        def var i as int no-undo.
        def var targetInitial as char no-undo.
        
        if not pSource:has(pField) or not pTarget:has(pField) then return false.
        assign targetInitial = pTarget:initial(pField).
        
        if pSource:extent(pField) = 0 and pTarget:extent(pField) = 0 then do:
            if pSource:value(pField) = targetInitial or pTarget:value(pField) <> targetInitial then return false.
            pTarget:updateField(pField, pSource:field(pField):buffer-value).
        end.
        else if pSource:extent(pField) = 0 then do:
            if pSource:value(pField) = targetInitial or pTarget:fieldCountInitial(pField) = 0 then return false.
            pTarget:updateField(pField, pSource:field(pField):buffer-value, pTarget:nextExtentWithInitial(pField)).
        end.
        else if pTarget:extent(pField) = 0 then do:
            if pSource:fieldCountValueNotEqual(pField, targetInitial) = 0 or not pTarget:fieldHasInitial(pField) then return false.
            
        end.
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
