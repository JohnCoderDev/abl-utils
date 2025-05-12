block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Aggregators.Interfaces.* from propath.

class classes.BufferUtil.Aggregators.CountAggregator inherits Aggregator:
    method public override char createFields(pTable as Table, pName as char, pType as char):
        pTable:addField(pName, 'int64').
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
            pTargetBuffer:field(pTargetField):buffer-value + 1
        ).    
    end method.
end class.
