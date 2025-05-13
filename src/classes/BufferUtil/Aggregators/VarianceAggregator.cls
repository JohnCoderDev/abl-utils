block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Aggregators.Interfaces.* from propath.

class classes.BufferUtil.Aggregators.VarianceAggregator inherits Aggregator:
    method public override char createFields(
        pTargetTable as Table, 
        pTargetName as char, 
        pSourceBuffer as Buffer,
        pSourceName as char
    ):
        def var sumFieldName as char no-undo.
        def var countFieldName as char no-undo.
        def var avgFieldName as char no-undo.
        def var squaredSumFieldName as char no-undo.
        assign 
            avgFieldName = pTargetName + '-avg'
            squaredSumFieldName = pTargetName + '-sqrd'
            sumFieldName = avgFieldName + '-1'
            countFieldName = avgFieldName + '-2'.
            
        pTargetTable:addField(pTargetName, 'decimal', ?, '0').
        pTargetTable:addField(sumFieldName, 'decimal', ?, '0').
        pTargetTable:addField(squaredSumFieldName, 'decimal', ?, '0').
        pTargetTable:addField(countFieldName, 'int64', ?, '0').
        pTargetTable:addField(avgFieldName, 'int64', ?, '0').
        return 
            pSourceName + ',' + squaredSumFieldName + ',squaredSum,true ' 
            + pSourceName + ',' + sumFieldName + ',sum,true ' 
            + pSourceName + ',' + countFieldName + ',count,true '
            + pSourceName + ',' + avgFieldName + ',average,true'.
    end method.
    
    method public override void updateField(
        pSourceBuffer as Buffer,
        pSourceField as char,
        pTargetBuffer as Buffer,
        pTargetField as char,
        pSupportFields as char
    ):
        def var squaredSumFieldName as char.
        def var avgFieldName as char.
        def var countFieldName as char.
        def var totalSquaredSum as decimal.
        def var totalAverage as decimal.
        def var totalCount as int64.
        
        assign
            squaredSumFieldName = getSupportFieldName(pSupportFields, 1)
            countFieldName = getSupportFieldName(pSupportFields, 3)
            avgFieldName = getSupportFieldName(pSupportFields, 4)
            
            totalAverage = pTargetBuffer:field(avgFieldName):buffer-value
            totalCount = pTargetBuffer:field(countFieldName):buffer-value
            totalSquaredSum = pTargetBuffer:field(squaredSumFieldName):buffer-value.
        
        pTargetBuffer:updateField(pTargetField, totalSquaredSum / totalCount - exp(totalAverage, 2)).    
    end method.
end class.
