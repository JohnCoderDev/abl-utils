block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Aggregators.Interfaces.* from propath.

class classes.BufferUtil.Aggregators.AverageAggregator inherits Aggregator:
    method public override char createFields(
        pTargetTable as Table, 
        pTargetName as char, 
        pSourceBuffer as Buffer,
        pSourceName as char
    ):
        def var sumFieldName as char no-undo.
        def var countFieldName as char no-undo.
        assign 
            sumFieldName = pTargetName + '-1'
            countFieldName = pTargetName + '-2'.
            
        pTargetTable:addField(pTargetName, 'decimal', ?, '0').
        pTargetTable:addField(sumFieldName, 'decimal', ?, '0').
        pTargetTable:addField(countFieldName, 'int64', ?, '0').
        return pSourceName + ',' + sumFieldName + ',sum,true ' + pSourceName + ',' + countFieldName + ',count,true'.
    end method.
    
    method public override void updateField(
        pSourceBuffer as Buffer,
        pSourceField as char,
        pTargetBuffer as Buffer,
        pTargetField as char,
        pSupportFields as char
    ):
        def var sumFieldName as char.
        def var countFieldName as char.
        def var totalSum as decimal.
        def var totalCount as int64.
        
        assign
            sumFieldName = getSupportFieldName(pSupportFields, 1)
            countFieldName = getSupportFieldName(pSupportFields, 2)
            totalSum = pTargetBuffer:field(sumFieldName):buffer-value
            totalCount = pTargetBuffer:field(countFieldName):buffer-value.
        
        pTargetBuffer:updateField(pTargetField, totalSum / totalCount).    
    end method.
end class.
