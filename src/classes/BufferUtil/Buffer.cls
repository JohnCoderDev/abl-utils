block-level on error undo, throw.
using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.* from propath.
using classes.BufferUtil.* from propath.
using classes.Shared.Interfaces.* from propath.

class classes.BufferUtil.Buffer:
    def public property handle as handle no-undo get. set.
    def public property name as char no-undo
        get:
            if valid-handle(handle) then do:
                return handle:name.
            end.
            return ''.
        end.
    
    constructor Buffer():
    end constructor.
    
    constructor Buffer(pBuffer as character):
        changeBuffer(pBuffer).
    end constructor.
    
    constructor Buffer(pBuffer as handle, pIsTT as logical):
        changeBuffer(pBuffer, pIsTT).
    end constructor.
    
    constructor Buffer(pBuffer as handle):
        changeBuffer(pBuffer).
    end constructor.
    
    method public Buffer changeBuffer(pBuffer as character):
        create buffer handle for table pBuffer.
        return this-object.
    end method.
    
    method public Buffer changeBuffer(pBuffer as handle):
        return changeBuffer(pBuffer, false).
    end method.
    
    method public Buffer changeBuffer(pBuffer as handle, pIsTT as logical):
        if pIsTT then do:
            assign handle = pBuffer:default-buffer-handle.
        end.
        else do:
            assign handle = pBuffer.
        end.
        return this-object.
    end method.
    
    method public Buffer reset():
        if handle:available then do:
            handle:buffer-release.
        end.
        delete object handle no-error.
        return this-object.
    end method.
    
    method public Buffer copy(pBuffer as handle):
        handle:buffer-copy(pBuffer).
        return this-object.
    end method.
    
    method public Buffer copy(pBuffer as Buffer):
        return this-object:copy(pBuffer:handle).
    end method.
    
    method public Buffer first():
        return first('').
    end method.
    
    method public Buffer first(pPredicate as char):
        return first(pPredicate, no-lock).
    end method.
    
    method public Buffer first(pPredicate as char, pLock as int):
        return first(pPredicate, pLock, no-wait).
    end method.
    
    method public Buffer first(pPredicate as char, pLock as int, pWait as int):
        if not valid-handle(handle) then return this-object.
        handle:find-first(pPredicate, pLock, pWait).
        return this-object.
    end method.
    
    method public Buffer current():
        return this-object:current(no-lock).
    end method.
    
    method public Buffer current(pLock as int):
        return this-object:current(pLock, no-wait).
    end method.
    
    method public Buffer current(pLock as int, pWait as int):
        if not valid-handle(handle) then return this-object.
        handle:find-current(pLock, pWait).
        return this-object.
    end method.
    
    method public logical updateField(pField as character, pValue as character):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as int):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as int64):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as dec):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as date):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as datetime):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as datetime-tz):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as logical):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as object):
        return updateField(pField, pValue, 0).
    end method.
    
    method public logical updateField(pField as character, pValue as Object, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = cast(pValue, StringInterface):toString().
                    when 'integer' then fieldHandle:buffer-value(pExtent) = cast(pValue, IntInterface):toInt().
                    when 'int64' then fieldHandle:buffer-value(pExtent) = cast(pValue, Int64Interface):toInt64().
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = cast(pValue, DecInterface):toDec().
                    when 'date' then fieldHandle:buffer-value(pExtent) = cast(pValue, DateInterface):toDate().
                    when 'datetime' then fieldHandle:buffer-value(pExtent) = cast(pValue, DateTimeInterface):toDateTime().
                    when 'datetime-tz' then fieldHandle:buffer-value(pExtent) = cast(pValue, DateTimeTZInterface):toDateTimeTZ().
                    when 'logical' then fieldHandle:buffer-value(pExtent) = cast(pValue, LogInterface):toLog().
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = cast(pValue, StringInterface):toString().
                    when 'integer' then fieldHandle:buffer-value = cast(pValue, IntInterface):toInt().
                    when 'int64' then fieldHandle:buffer-value = cast(pValue, Int64Interface):toInt64().
                    when 'decimal' then fieldHandle:buffer-value = cast(pValue, DecInterface):toDec().
                    when 'date' then fieldHandle:buffer-value = cast(pValue, DateInterface):toDate().
                    when 'datetime' then fieldHandle:buffer-value = cast(pValue, DateTimeInterface):toDateTime().
                    when 'datetime-tz' then fieldHandle:buffer-value = cast(pValue, DateTimeTZInterface):toDateTimeTZ().
                    when 'logical' then fieldHandle:buffer-value = cast(pValue, LogInterface):toLog().
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public logical updateField(pField as character, pValue as character, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(pValue).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(pValue).
                    when 'date' then fieldHandle:buffer-value(pExtent) = date(pValue).
                    when 'datetime' then fieldHandle:buffer-value(pExtent) = datetime(pValue).
                    when 'datetime-tz' then fieldHandle:buffer-value(pExtent) = datetime-tz(pValue).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(pValue).
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = string(pValue).
                    when 'integer' then fieldHandle:buffer-value = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value = dec(pValue).
                    when 'date' then fieldHandle:buffer-value = date(pValue).
                    when 'datetime' then fieldHandle:buffer-value = datetime(pValue).
                    when 'datetime-tz' then fieldHandle:buffer-value = datetime-tz(pValue).
                    when 'logical' then fieldHandle:buffer-value = logical(pValue).
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public logical updateField(pField as character, pValue as logical, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(pValue).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(pValue).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(pValue).
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = string(pValue).
                    when 'integer' then fieldHandle:buffer-value = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value = dec(pValue).
                    when 'logical' then fieldHandle:buffer-value = logical(pValue).
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public logical updateField(pField as character, pValue as date, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(pValue).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(pValue).
                    when 'date' then fieldHandle:buffer-value(pExtent) = date(pValue).
                    when 'datetime' then fieldHandle:buffer-value(pExtent) = datetime(pValue).
                    when 'datetime-tz' then fieldHandle:buffer-value(pExtent) = datetime-tz(pValue).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(pValue).
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = string(pValue).
                    when 'integer' then fieldHandle:buffer-value = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value = dec(pValue).
                    when 'date' then fieldHandle:buffer-value = date(pValue).
                    when 'datetime' then fieldHandle:buffer-value = datetime(pValue).
                    when 'datetime-tz' then fieldHandle:buffer-value = datetime-tz(pValue).
                    when 'logical' then fieldHandle:buffer-value = logical(pValue).
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public logical updateField(pField as character, pValue as datetime-tz, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(pValue).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(pValue).
                    when 'date' then fieldHandle:buffer-value(pExtent) = date(pValue).
                    when 'datetime-tz' then fieldHandle:buffer-value(pExtent) = datetime-tz(pValue).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(pValue).
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = string(pValue).
                    when 'integer' then fieldHandle:buffer-value = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value = dec(pValue).
                    when 'date' then fieldHandle:buffer-value = date(pValue).
                    when 'datetime-tz' then fieldHandle:buffer-value = datetime-tz(pValue).
                    when 'logical' then fieldHandle:buffer-value = logical(pValue).
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public logical updateField(pField as character, pValue as datetime, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(pValue).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(pValue).
                    when 'date' then fieldHandle:buffer-value(pExtent) = date(pValue).
                    when 'datetime' then fieldHandle:buffer-value(pExtent) = datetime(pValue).
                    when 'datetime-tz' then fieldHandle:buffer-value(pExtent) = datetime-tz(pValue).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(pValue).
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = string(pValue).
                    when 'integer' then fieldHandle:buffer-value = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value = dec(pValue).
                    when 'date' then fieldHandle:buffer-value = date(pValue).
                    when 'datetime' then fieldHandle:buffer-value = datetime(pValue).
                    when 'datetime-tz' then fieldHandle:buffer-value = datetime-tz(pValue).
                    when 'logical' then fieldHandle:buffer-value = logical(pValue).
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public logical updateField(pField as character, pValue as decimal, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(pValue).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(pValue).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(pValue).
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = string(pValue).
                    when 'integer' then fieldHandle:buffer-value = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value = dec(pValue).
                    when 'logical' then fieldHandle:buffer-value = logical(pValue).
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public logical updateField(pField as character, pValue as int64, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(pValue).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(pValue).
                    when 'date' then fieldHandle:buffer-value(pExtent) = date(pValue).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(pValue).
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = string(pValue).
                    when 'integer' then fieldHandle:buffer-value = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value = dec(pValue).
                    when 'date' then fieldHandle:buffer-value = date(pValue).
                    when 'logical' then fieldHandle:buffer-value = logical(pValue).
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public logical updateField(pField as character, pValue as integer, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(pValue).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(pValue).
                    when 'date' then fieldHandle:buffer-value(pExtent) = date(pValue).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(pValue).
                end case.
            end.
            else do:
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value = string(pValue).
                    when 'integer' then fieldHandle:buffer-value = integer(pValue).
                    when 'int64' then fieldHandle:buffer-value = int64(pValue).
                    when 'decimal' then fieldHandle:buffer-value = dec(pValue).
                    when 'date' then fieldHandle:buffer-value = date(pValue).
                    when 'logical' then fieldHandle:buffer-value = logical(pValue).
                end case.
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    
    method public handle field(pIndex as int):
        return handle:buffer-field(pIndex).
    end method.
    
    method public handle field(pField as character):
        return this-object:handle:buffer-field(pField).
    end method.
    
    method public logical has(pField as character):
        do on error undo:
            this-object:field(pField).
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.    
        end.    
    end method.
    
    method public log has(pIndex as int):
        do on error undo:
            this-object:field(pIndex).
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
    end method.
    
    method public char type(pIndex as int):
        if has(pIndex) then do:
            return this-object:field(pIndex):data-type.
        end.
    end method.
    
    method public char fieldName(pIndex as int):
        if has(pIndex) then do:
            return this-object:field(pIndex):name.
        end.
    end method.
    
    method public character type(pField as character):
        if has(pField) then 
            return this-object:field(pField):data-type.
    end method.
    
    method public character name():
        return handle:name.
    end method.
    
    method public int extent(pField as char):
        if has(pField) then return this-object:field(pField):extent.
    end method.
    
    method public char initial(pField as char):
        if has(pField) then return this-object:field(pField):initial.
    end method.
    
    method public log fieldHasInitial(pField as char):
        if has(pField) then return this-object:value(pField) = initial(pField).
    end method.
    
    method public log fieldHasInitial(pField as char, pExtent as int):
        if has(pField) then return this-object:value(pField, pExtent) = initial(pField).
    end method.
    
    method public character value(pField as character):
        if has(pField) then return this-object:field(pField):string-value.
    end method.
    
    method public character value(pField as character, pExtent as integer):
        if has(pField) then return this-object:field(pField):string-value(pExtent).
    end method.
    
    method public Buffer fieldCopy(pBuffer as Buffer, pField as char):
        if pBuffer:has(pField) and has(pField) then do:
            handle:buffer-field(pField):buffer-value = pBuffer:handle:buffer-field(pField):buffer-value.
        end.
        return this-object.
    end method.
    
    method public Buffer fieldCopy(pBuffer as handle, pField as char):
        return fieldCopy(new Buffer(pBuffer), pField).
    end method.
    
    method public int numFields():
        return handle:num-fields.
    end method.
    
    method public JsonObject toJson():
        def var copyTable as Table no-undo.
        def var resultJson as JsonObject no-undo.
        assign 
            copyTable = new Table(this-object)
            resultJson = new JsonObject().
        copyTable:bufferCopy(this-object).
        copyTable:buffer:serialize-row('JSON', 'JsonObject', resultJson, false, ?, false, true).
        return resultJson.
    end method.
    
    destructor Buffer():
        reset().
    end destructor.
end class.
