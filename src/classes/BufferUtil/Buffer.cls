block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.Shared.Interfaces.* from propath.
using Progress.Lang.* from propath.

class classes.BufferUtil.Buffer:
    define public property handle as handle no-undo get. set.
    
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
    
    method public character type(pField as character):
        if has(pField) then 
            return this-object:field(pField):data-type.
    end method.
    
    method public character name():
        return handle:name.
    end method.
    
    method public character value(pField as character):
        if has(pField) then return this-object:field(pField):string-value.
    end method.
    
    method public character value(pField as character, pExtent as integer):
        if has(pField) then return this-object:field(pField):string-value(pExtent).
    end method.
    
    destructor Buffer():
        reset().
    end destructor.
end class.
