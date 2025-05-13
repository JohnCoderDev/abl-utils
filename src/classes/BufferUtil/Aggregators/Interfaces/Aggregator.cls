using classes.BufferUtil.* from propath.

class classes.BufferUtil.Aggregators.Interfaces.Aggregator abstract:
    method public char getSupportFieldName(pSupports as char, pPosition as int):
        return entry(2, entry(pPosition, pSupports, ' ')).
    end method.
    
    method public abstract char createFields(
        pTargetTable as Table, 
        pTargetName as char, 
        pSourceBuffer as Buffer,
        pSourceName as char
    ).
    method public abstract void updateField(
        pBufferSource as Buffer, 
        pFieldSource as char, 
        pBufferTarget as Buffer, 
        pFieldTarget as char, 
        pSupportFields as char
    ).
end class.
