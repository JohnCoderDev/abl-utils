block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Aggregators.Interfaces.* from propath.

class classes.BufferUtil.Aggregators.SquaredSumAggregator inherits Aggregator:
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
            pTargetBuffer:updateField(pTargetField, exp(pSourceBuffer:field(pSourceField):buffer-value, 2)).
        end.    
        else if pSourceBuffer:field(pSourceField):buffer-value <> ? then do:
            pTargetBuffer:updateField(
                pTargetField,
                pTargetBuffer:field(pTargetField):buffer-value 
                    + exp(pSourceBuffer:field(pSourceField):buffer-value, 2)
            ). 
        end.    
    end method.
end class.
