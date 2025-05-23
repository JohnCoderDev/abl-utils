block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Aggregators.Interfaces.* from propath.

class classes.BufferUtil.Aggregators.LastAggregator inherits Aggregator:
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
        pTargetBuffer:updateField(
            pTargetField,
            pSourceBuffer:field(pSourceField):buffer-value
        ).
    end method.
end class.
