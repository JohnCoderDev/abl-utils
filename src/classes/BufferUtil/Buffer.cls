block-level on error undo, throw.
using Progress.Lang.* from propath.
using Progress.Json.ObjectModel.* from propath.
using classes.BufferUtil.* from propath.
using classes.StringUtil.* from propath.
using classes.Shared.Interfaces.* from propath.

class classes.BufferUtil.Buffer:
    def public property handle as handle no-undo get. set.
    def public property name as char no-undo
        get:
            if not valid-handle(handle) then return ''.
            return handle:name.
        end.
    
    def public property available as log no-undo
        get:
            if not valid-handle(handle) then return false.
            return handle:available.
        end.
        
    constructor Buffer():
    end constructor.
    
    constructor Buffer(pBuffer as char):
        changeBuffer(pBuffer).
    end constructor.
    
    constructor Buffer(pBuffer as char, pName as char):
        changeBuffer(pBuffer, pName).
    end constructor.
    
    constructor Buffer(pBuffer as handle):
        parseBuffer(pBuffer).
    end constructor.
    
    constructor Buffer(pBuffer as handle, pName as char):
        changeBuffer(pBuffer, pName).
    end constructor.
    
    method public Buffer changeBuffer(pBuffer as char):
        return changeBuffer(pBuffer, pBuffer).
    end method.
    
    method public Buffer changeBuffer(pBuffer as char, pName as char):
        create buffer handle for table pBuffer buffer-name pName.
        return this-object.
    end method.
    
    method public Buffer changeBuffer(pBuffer as handle):
        create buffer handle for table pBuffer.
        return this-object.
    end method.
    
    method public Buffer changeBuffer(pBuffer as handle, pName as char):
        create buffer handle for table pBuffer buffer-name pName.
        return this-object.
    end method.
    
    method public Buffer parseBuffer(pBuffer as handle):
        assign handle = pBuffer.
        return this-object.
    end method.
    
    method public override object clone():
        return new Buffer():changeBuffer(handle).
    end method.
    
    method public Buffer create():
        if not valid-handle(handle) then return this-object.
        handle:buffer-create.
        return this-object.
    end method.
    
    method public Buffer delete():
        if not valid-handle(handle) then return this-object.
        handle:buffer-delete.
        return this-object.
    end method.
    
    method public Buffer copy(pBuffer as handle):
        return this-object:copy(new Buffer(pBuffer)).
    end method.
    
    method public Buffer copy(pBuffer as Buffer):
        return this-object:copy(pBuffer, FieldCopyStrategy:DEFAULT).
    end method.
    
    method public Buffer copy(pBuffer as Buffer, pStrategy as char):
        def var i as int no-undo.
        do i = 1 to numFields():
            FieldCopyStrategy:copy(pBuffer, this-object, fieldName(i), pStrategy).
        end.
        return this-object.
    end method.
    
    method public Buffer copy(pBuffer as handle, pStrategy as char):
        return copy(new Buffer(pBuffer), pStrategy).
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
        handle:find-first(pPredicate, pLock, pWait) no-error.
        return this-object.
    end method.
    
    method public Buffer current():
        return this-object:current(no-lock).
    end method.
    
    method public Buffer current(pLock as int):
        return this-object:current(pLock, no-wait) .
    end method.
    
    method public Buffer current(pLock as int, pWait as int):
        if not valid-handle(handle) then return this-object.
        handle:find-current(pLock, pWait) no-error.
        return this-object.
    end method.
    
    method public Buffer last():
        return last('').
    end method.
    
    method public Buffer last(pWhere as char):
        return last(pWhere, no-lock).
    end method.
    
    method public Buffer last(pWhere as char, pLock as int):
        return last(pWhere, pLock, no-wait).
    end method.
    
    method public Buffer last(pWhere as char, pLock as int, pWait as int):
        if not valid-handle(handle) then return this-object.
        handle:find-last(pWhere, pLock, pWait) no-error.
        return this-object.
    end method.
    
    method public log setNull(pField as char):
        return setNull(pField, 0).
    end method.
    
    method public log setNull(pField as char, pExtent as int):
        if not has(pField) then return false.
        
        do on error undo, throw:
            if pExtent > 0 then do:
                assign this-object:field(pField):buffer-value(pExtent) = ?.
            end.
            else do:
                assign this-object:field(pField):buffer-value = ?.
            end.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
    end method.
    
    method public log setInitial(pField as char):
        return setInitial(pField, 0).
    end method.
    
    method public log setInitial(pField as char, pExtent as int):
        if not has(pField) then return false.
        return updateField(pField, initial(pField), pExtent).
    end method.
    
    method public Buffer setInitials(pField as char):
        def var i as int no-undo.
        do i = 1 to numFields():
            setInitial(fieldName(i)).
        end.
        return this-object.
    end method.
    
    method public log updateField(pField as char, pValue as char):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as int):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as int64):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as dec):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as date):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as datetime):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as datetime-tz):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as log):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as object):
        return updateField(pField, pValue, 0).
    end method.
    
    method public log updateField(pField as char, pValue as Object, pExtent as integer):
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
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
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
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public log updateField(pField as char, pValue as char, pExtent as integer):
        do on error undo:
            define variable fieldHandle as handle no-undo.
            assign fieldHandle = this-object:field(pField).
            if pExtent > 0 then do:    
                case fieldHandle:data-type:
                    when 'character' then fieldHandle:buffer-value(pExtent) = string(trim(pValue)).
                    when 'integer' then fieldHandle:buffer-value(pExtent) = integer(trim(pValue)).
                    when 'int64' then fieldHandle:buffer-value(pExtent) = int64(trim(pValue)).
                    when 'decimal' then fieldHandle:buffer-value(pExtent) = dec(trim(pValue)).
                    when 'date' then fieldHandle:buffer-value(pExtent) = date(trim(pValue)).
                    when 'datetime' then fieldHandle:buffer-value(pExtent) = datetime(trim(pValue)).
                    when 'datetime-tz' then fieldHandle:buffer-value(pExtent) = datetime-tz(trim(pValue)).
                    when 'logical' then fieldHandle:buffer-value(pExtent) = logical(trim(pValue)).
                end case.
            end.
            else do:
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
                end.
                else do:
                    case fieldHandle:data-type:
                        when 'character' then fieldHandle:buffer-value = string(trim(pValue)).
                        when 'integer' then fieldHandle:buffer-value = integer(trim(pValue)).
                        when 'int64' then fieldHandle:buffer-value = int64(trim(pValue)).
                        when 'decimal' then fieldHandle:buffer-value = dec(trim(pValue)).
                        when 'date' then fieldHandle:buffer-value = date(trim(pValue)).
                        when 'datetime' then fieldHandle:buffer-value = datetime(trim(pValue)).
                        when 'datetime-tz' then fieldHandle:buffer-value = datetime-tz(trim(pValue)).
                        when 'logical' then fieldHandle:buffer-value = logical(trim(pValue)).
                    end case.
                end.    
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public log updateField(pField as char, pValue as log, pExtent as integer):
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
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
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
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public log updateField(pField as char, pValue as date, pExtent as integer):
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
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
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
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public log updateField(pField as char, pValue as datetime-tz, pExtent as integer):
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
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
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
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public log updateField(pField as char, pValue as datetime, pExtent as integer):
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
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
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
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public log updateField(pField as char, pValue as decimal, pExtent as integer):
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
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
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
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public log updateField(pField as char, pValue as int64, pExtent as integer):
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
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
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
            end.
            return true.
            
            catch errorObject as Error:
                return false.
            end catch.
        end.
        return false.
    end method.
    
    method public log updateField(pField as char, pValue as integer, pExtent as integer):
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
                if extent(pField) > 0 then do:
                    define variable i as int no-undo.
                    do i = 1 to extent(pField):
                        updateField(pField, pValue, i).
                    end.
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
    
    method public handle field(pField as char):
        return this-object:handle:buffer-field(pField).
    end method.
    
    method public log has(pField as char):
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
    
    method public char type(pField as char):
        if has(pField) then 
            return this-object:field(pField):data-type.
    end method.
    
    method public char name():
        return handle:name.
    end method.
    
    method public int extent(pField as char):
        if has(pField) then return this-object:field(pField):extent.
    end method.
    
    method public char initial(pField as char):
        if has(pField) then do:
            if this-object:field(pField):default-string = ? then return ''.
            return this-object:field(pField):default-string.
        end.
    end method.
    
    method public log fieldHasInitial(pField as char):
        if has(pField) then return this-object:value(pField) = initial(pField).
    end method.
    
    method public log fieldHasInitial(pField as char, pExtent as int):
        if has(pField) then return this-object:value(pField, pExtent) = initial(pField).
    end method.
    
    method public int fieldCountInitial(pField as char):
        return fieldCountValueEqual(pField, initial(pField)).
    end method.
    
    method public int fieldCountValueEqual(pField as char, pValue as char):
        if not has(pField) then return 0.
        if extent(pField) = 0 and not this-object:value(pField) = pValue then return 0.
        if extent(pField) = 0 and this-object:value(pField) = pValue then return 1.
        
        def var c as int no-undo.
        def var i as int no-undo.
        do i = 1 to extent(pField):
            if this-object:value(pField, i) = pValue then do:
                assign c = c + 1.
            end.
        end.
        return c.
    end method.
    
    method public int fieldCountValueNotEqual(pField as char, pValue as char):
        return extent(pField) - fieldCountValueEqual(pField, pValue).
    end method.
    
    method public int nextPositionWithInitial(pField as char):
        return nextPositionWithValueEqual(pField, initial(pField)).
    end method.
    
    method public int nextPositionWithValueEqual(pField as char, pValue as char):
        if not has(pField) then return 0.
        if extent(pField) = 0 then return 0.
        
        def var i as int no-undo.
        do i = 1 to extent(pField):
            if this-object:value(pField, i) = pValue then return i.
        end.
    end method.
    
    method public int nextPositionWithNotInitial(pField as char):
        return nextPositionWithNotInitial(pField, 0).
    end method.
    
    method public int nextPositionWithNotInitial(pField as char, pLowerIgnored as int):
        return nextPositionWithValueNotEqual(pField, initial(pField), pLowerIgnored).
    end method.
    
    method public int nextPositionWithValueNotEqual(pField as char, pValue as char):
        return nextPositionWithValueNotEqual(pField, pValue, 0).
    end method.
    
    method public int nextPositionWithValueNotEqual(pField as char, pValue as char, pLowerIgnored as int):
        if not has(pField) then return 0.
        if extent(pField) = 0 then return 0.
        
        def var i as int no-undo.
        do i = 1 to extent(pField):
            if this-object:value(pField, i) <> pValue and i > pLowerIgnored then return i.
        end.
    end method.
    
    method public char value(pIndex as int):
        return this-object:value(fieldName(pIndex)).
    end method.
    
    method public char value(pIndex as int, pExtent as int):
        if has(pIndex) then return this-object:field(pIndex):string-value(pExtent).
    end method.
    
    method public char value(pField as char):
        if has(pField) then do:
            if extent(pField) = 0 then do:
                if this-object:field(pField):buffer-value = ? then return ''.
                return string(this-object:field(pField):buffer-value).
            end.
            return Joiner:join(this-object, pField).
        end.
    end method.
    
    method public char value(pField as char, pExtent as integer):
        if has(pField) then do:
            if this-object:field(pField):buffer-value(pExtent) = ? then return ''.
            return string(this-object:field(pField):buffer-value(pExtent)).
        end.    
    end method.
    
    method public Buffer fieldCopy(pBuffer as Buffer, pFields as char):
        return fieldCopy(pBuffer, pFields, FieldCopyStrategy:DEFAULT). 
    end method.
    
    method public Buffer fieldCopy(pBuffer as handle, pFields as char):
        return fieldCopy(new Buffer(pBuffer), pFields).
    end method.
    
    method public Buffer fieldCopy(pBuffer as handle, pFields as char, pStrategy as char):
        return fieldCopy(new Buffer(pBuffer), pFields, pStrategy).
    end method.
    
     method public Buffer fieldCopy(pBuffer as Buffer, pFields as char, pStrategy as char):
        def var i as int no-undo.
        def var currentName as char no-undo.
        assign pFields = Sanitizer:wipeSpaces(pFields).
        
        do i = 1 to num-entries(pFields, ' '):
            assign currentName = entry(i, pFields, ' ').
            FieldCopyStrategy:copy(pBuffer, this-object, currentName, pStrategy).
        end.
        
        return this-object.
    end method.
    
    method public log fieldEqual(pBuffer as Buffer, pField as char):
        return fieldEqual(pBuffer, pField, true).
    end method.
    
    method public log fieldEqual(pBuffer as Buffer, pField as char, pIgnoreTypes as log):
        if not pBuffer:has(pField) or not has(pField) then return false.
        if pBuffer:extent(pField) <> extent(pField) then return false.
        if not pIgnoreTypes and pBuffer:type(pField) <> type(pField) then return false.
        return this-object:value(pField) = pBuffer:value(pField).
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
        copyTable:buffer:handle:serialize-row('JSON', 'JsonObject', resultJson, false, ?, false, true).
        return resultJson.
    end method.
    
    method public JsonObject toJson(pFields as char):
        return toJson(pFields, false).
    end method.
    
    method public JsonObject toJson(pFields as char, pExclude as log):
        def var resultJson as JsonObject no-undo.
        def var auxArray as JsonArray no-undo.
        def var fieldHandle as handle no-undo.
        def var currentField as char no-undo.
        def var i as int no-undo.
        def var j as int no-undo.
        assign resultJson = new JsonObject().
        
        do i = 1 to numFields():
            assign fieldHandle = this-object:field(i).
            if pExclude and Matcher:contains(pFields, fieldHandle:name) then next.
            if not pExclude and not Matcher:contains(pFields, fieldHandle:name) then next.
            
            if fieldHandle:extent > 0 then do:
                assign auxArray = new JsonArray().
                do j = 1 to fieldHandle:extent:
                    auxArray:add(fieldHandle:buffer-value(j)).
                end.
                resultJson:add(fieldHandle:name, auxArray).
            end.
            else do:
                resultJson:add(fieldHandle:name, fieldHandle:buffer-value).
            end.
        end.
        
        return resultJson.
    end method.
    
    method public char label(pIndex as int):
        if has(pIndex) then do:
            return this-object:label(fieldName(pIndex)).
        end.
    end method.
    
    method public char label(pField as char):
        if has(pField) then do:
            def var availableLabel as char no-undo.
            assign 
                availableLabel = this-object:field(pField):label
                availableLabel = if availableLabel = ? then this-object:field(pField):column-label else availableLabel
                availableLabel = if availableLabel = ? then '' else availableLabel.
            return availableLabel.    
        end.
    end method.
    
    method public override char toString():
        def var i as int no-undo.
        def var resultString as char no-undo.
        do i = 1 to numFields():
            assign resultString = resultString + fieldName(i) + ' = ' + this-object:value(i) + '~n'.
        end.
        return resultString.
    end method.
    
    method public char toString(pFields as char):
        return toString(pFields, false).
    end method.
    
    method public char toString(pFields as char, pExclude as log):
        def var resultString as char no-undo.
        def var i as int no-undo.
        do i = 1 to numFields():
            if Matcher:contains(pFields, fieldName(i)) and pExclude then next.
            if not Matcher:contains(pFields, fieldName(i)) and not pExclude then next.
            assign resultString = resultString + fieldName(i) + ' = ' + this-object:value(i) + '~n'.
        end.
        return resultString.
    end.
    
    destructor Buffer():
        delete object handle no-error.
    end destructor.
end class.
