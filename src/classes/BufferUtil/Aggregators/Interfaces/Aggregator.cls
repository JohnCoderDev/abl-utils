using classes.BufferUtil.* from propath.

class classes.BufferUtil.Aggregators.Interfaces.Aggregator abstract:
    method public abstract char createFields(pTable as Table, pName as char, pType as char).
    method public abstract void updateField(
        pBufferSource as Buffer, 
        pFieldSource as char, 
        pBufferTarget as Buffer, 
        pFieldTarget as char, 
        pSupportFields as char
    ).
end class.
