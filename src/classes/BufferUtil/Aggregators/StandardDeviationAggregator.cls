block-level on error undo, throw.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Aggregators.Interfaces.* from propath.

class classes.BufferUtil.Aggregators.StandardDeviationAggregator inherits Aggregator:
    method public override char createFields(
        pTargetTable as Table, 
        pTargetName as char, 
        pSourceBuffer as Buffer,
        pSourceName as char
    ):
        def var sumFieldName as char no-undo.
        def var countFieldName as char no-undo.
        def var avgFieldName as char no-undo.
        def var varianceFieldName as char no-undo.
        def var squaredSumFieldName as char no-undo.
        assign 
            varianceFieldName = pTargetName + '-v'
            avgFieldName =  varianceFieldName + '-avg'
            squaredSumFieldName = varianceFieldName + '-sqrd'
            sumFieldName = avgFieldName + '-1'
            countFieldName = avgFieldName + '-2'.
            
        pTargetTable:addField(pTargetName, 'decimal', ?, '0').
        pTargetTable:addField(sumFieldName, 'decimal', ?, '0').
        pTargetTable:addField(varianceFieldName, 'decimal', ?, '0').
        pTargetTable:addField(squaredSumFieldName, 'decimal', ?, '0').
        pTargetTable:addField(countFieldName, 'int64', ?, '0').
        pTargetTable:addField(avgFieldName, 'int64', ?, '0').
        
        return 
            pSourceName + ',' + squaredSumFieldName + ',squaredSum,true ' 
            + pSourceName + ',' + sumFieldName + ',sum,true ' 
            + pSourceName + ',' + countFieldName + ',count,true '
            + pSourceName + ',' + avgFieldName + ',average,true '
            + pSourceName + ',' + varianceFieldName + ',variance,true'.
    end method.
    
    method public override void updateField(
        pSourceBuffer as Buffer,
        pSourceField as char,
        pTargetBuffer as Buffer,
        pTargetField as char,
        pSupportFields as char
    ):
        def var varianceFieldName as char no-undo.
        def var variance as decimal.
        
        assign
            varianceFieldName = getSupportFieldName(pSupportFields, 5)
            variance = pTargetBuffer:field(varianceFieldName):buffer-value.
        
        pTargetBuffer:updateField(pTargetField, sqrt(variance)).    
    end method.
end class.
