block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Aggregators.Interfaces.* from propath.

class classes.BufferUtil.Aggregators.SumAggregator inherits Aggregator:
    method public override char createFields(
        pTargetTable as Table, 
        pTargetName as char, 
        pSourceBuffer as Buffer,
        pSourceName as char
    ):
        pTargetTable:addField(pTargetName, pSourceBuffer:type(pSourceName)).
    end method.
    
    method public override void updateField(
        pSourceBuffer as Buffer,
        pSourceField as char,
        pTargetBuffer as Buffer,
        pTargetField as char,
        pSupportFields as char
    ):
        if pTargetBuffer:field(pTargetField):buffer-value = ? then do:
            pTargetBuffer:updateField(pTargetField, pSourceBuffer:field(pSourceField):buffer-value).
        end.    
        else if pSourceBuffer:field(pSourceField):buffer-value <> ? then do:
            pTargetBuffer:updateField(
                pTargetField,
                pTargetBuffer:field(pTargetField):buffer-value 
                    + pSourceBuffer:field(pSourceField):buffer-value
            ). 
        end.    
    end method.
end class.
