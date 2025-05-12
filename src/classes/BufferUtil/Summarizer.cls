block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.StringUtil.* from propath.
using classes.BufferUtil.* from propath.
using classes.BufferUtil.Errors.* from propath.
using classes.BufferUtil.Aggregators.Interfaces.* from propath.

class classes.BufferUtil.Summarizer:
    def public property argumentSeparator as char init ',' no-undo get.
    
    def temp-table aggregator
        field name as char
        field className as char
        field aggregator as object
        index idxClass as primary unique className.
    
    def temp-table aggregationKeys
        field fieldName as char
        field fieldType as char.
    
    def temp-table aggregationValues
        field aggregator as char
        field fieldName as char
        field fieldSource as char
        field temporary as log
        field supportFields as char.
    
    constructor Summarizer():
        assignDefaultAggregators().
    end constructor.
    
    constructor Summarizer(pKeys as char, pAggregations as char):
        assignDefaultAggregators().
        addKey(pKeys).
        addAggregation(pAggregations).
    end constructor.
    
    method public Summarizer assignDefaultAggregators():
        addAggregator('sum', 'classes.BufferUtil.Aggregators.SumAggregator').
        addAggregator('average', 'classes.BufferUtil.Aggregators.AverageAggregator').
        addAggregator('min', 'classes.BufferUtil.Aggregators.MinAggregator').
        addAggregator('max', 'classes.BufferUtil.Aggregators.MaxAggregator').
        addAggregator('count', 'classes.BufferUtil.Aggregators.CountAggregator').
    end method.
    
    method public Summarizer addAggregator(pName as char, pClass as char):
        if not findAggregator(pName) then do:
            create aggregator.
        end.
        
        assign 
            aggregator.name = pName
            aggregator.className = pClass.
            
        return this-object.    
    end method.
    
    method protected log findAggregator(pName as char):
        find first aggregator where aggregator.name = pName no-error.
        return avail aggregator.
    end method.
    
    method public Table summarize(pBuffer as char):
        return summarize(new Buffer(pBuffer)).
    end method.
    
    method public Table summarize(pBuffer as Buffer):
        return summarize(new Query(pBuffer):prepare()).
    end method.
    
    method public Table summarize(pQuery as Query):
        return summarize(pQuery:toTable()).
    end method.
    
    method public Table summarize(pTable as Table):
        createSummaryObjects().
        def var queryObject as Query no-undo.
        def var resultTable as Table no-undo.
        def var queryBuffer as Buffer no-undo.
        def var keyFields as char no-undo.
        def var currentAggregator as Aggregator no-undo.
        message 'here before' view-as alert-box.
        assign 
            resultTable = prepareSummaryTable(pTable)
            queryObject = new Query(pTable)
            queryBuffer = queryObject:getBuffer()
            keyFields = keyFields().
            
        message 'here after' view-as alert-box.    
        
        for each aggregationKeys:
            assign aggregationKeys.fieldType = queryBuffer:type(aggregationKeys.fieldName).
        end.
        
        resultTable:addIndex('idx-primary', true, true).
        resultTable:addIndexField('idx-primary', keyFields).
        
        
        resultTable:prepare().        
        queryObject:first().
        
        do while not queryObject:offEnd():
            resultTable:buffer:first(wherePhrase(queryBuffer), exclusive-lock).
            
            if not resultTable:buffer:available then do:
                resultTable:createBuffer().
                resultTable:fieldCopy(queryBuffer, keyFields).
            end.
            
            for each aggregationValues, 
            first aggregator where aggregator.name = aggregationValues.aggregator:
                assign currentAggregator = cast(aggregator.aggregator, Aggregator).
                currentAggregator:updateField(
                    queryBuffer,
                    aggregationValues.fieldSource,
                    resultTable:buffer, 
                    aggregationValues.fieldName, 
                    aggregationValues.supportFields
                ).
            end.
            
            queryObject:next().
        end.
        
        assign resultTable = removeTemporaryFields(resultTable).
        return resultTable.
    end method.
    
    method protected void createSummaryObjects():
        for each aggregator:
            assign
                aggregator.aggregator = new classes.ClassUtil.Class(aggregator.className):new().
        end.
    end method.
    
    method protected char keyFields():
        def var r as char no-undo.
        for each aggregationKeys:
            assign r = r + aggregationKeys.FieldName + ' '.
        end.
        return Splitter:textBetween(r, 1, length(r) - 1).
    end method.
    
    method protected char wherePhrase(pBuffer as Buffer):
        def var phrase as char no-undo.
        for each aggregationKeys:
            assign phrase = phrase + aggregationKeys.fieldName + ' = ' 
                + (if aggregationKeys.fieldType = 'character' 
                    then quoter(pBuffer:value(aggregationKeys.fieldName))
                    else pBuffer:value(aggregationKeys.fieldName)
                ) + ' and '.
        end.
        assign phrase = Splitter:textBetween(phrase, 1, length(phrase) - 5).
        return 'where ' + phrase.
    end method.
    
    method protected Table prepareSummaryTable(pTable as Table):
        def var resultTable as Table no-undo.
        def var aggregatorObject as Aggregator no-undo.
        def var supportFields as char no-undo.
        
        assign resultTable = new Table().
        
        for each aggregationKeys:
            resultTable:addLike(pTable, aggregationKeys.fieldName).
        end.
        
        
        for each aggregationValues where not aggregationValues.temporary, 
        first aggregator where aggregator.name = aggregationValues.aggregator:
            assign 
                aggregatorObject = cast(aggregator.aggregator, Aggregator)
                supportFields = aggregatorObject:createFields(
                    resultTable, 
                    aggregationValues.fieldName,
                    pTable:buffer:type(aggregationValues.fieldSource)
                ).    
            addAggregation(supportFields).
        end.
        
        return resultTable.
    end method.
    
    method protected Table removeTemporaryFields(pTable as Table):
        def var resultTable as Table no-undo.
        def var i as int no-undo.
        assign resultTable = new Table().
        
        do i = 1 to pTable:buffer:numFields():
            if not isTemporaryField(pTable:buffer:fieldName(i)) then do:
                resultTable:addField(
                    pTable:buffer:fieldName(i),
                    pTable:buffer:type(i)
                ).    
            end.
        end.
        
        resultTable:prepare():copyData(pTable).
        return resultTable.
    end method.
    
    method protected log isTemporaryField(pField as char):
        return can-find(
            first aggregationValues 
            where aggregationValues.fieldName = pField and aggregationValues.temporary
        ).
    end method.
    
    method public Summarizer addKey(pKeys as char):
        def var i as int no-undo.
        def var currentKey as char no-undo.
        
        assign pKeys = Sanitizer:wipeSpaces(pKeys).
        
        if pKeys = '' then do:
            return this-object.
        end.
        
        do i = 1 to num-entries(pKeys, ' '):
            assign currentKey = entry(i, pKeys, ' ').
            if not findKey(currentKey) then do:
                create aggregationKeys.
                assign aggregationKeys.fieldName = currentKey.
            end.
        end.
        
        return this-object.
    end method.
    
    method public Summarizer addAggregation(pArguments as char):
        def var i as int no-undo.
        def var currentArgument as char.
        assign pArguments = Sanitizer:wipeSpaces(pArguments).
        
        if pArguments = '' or pArguments = ? then return this-object.
        
        do i = 1 to num-entries(pArguments, ' '):
            assign currentArgument = entry(i, pArguments, ' ').
            
            case num-entries(currentArgument, argumentSeparator):
                when 2 then do:
                    addAggregation(
                        entry(1, currentArgument, argumentSeparator),
                        entry(2, currentArgument, argumentSeparator)
                    ).    
                end.
                when 3 then do:
                    addAggregation(
                        entry(1, currentArgument, argumentSeparator),
                        entry(2, currentArgument, argumentSeparator),
                        entry(3, currentArgument, argumentSeparator)
                    ).    
                end.
                when 4 then do:
                    addAggregation(
                        entry(1, currentArgument, argumentSeparator),
                        entry(2, currentArgument, argumentSeparator),
                        entry(3, currentArgument, argumentSeparator),
                        logical(entry(4, currentArgument, argumentSeparator))
                    ).
                end.
            end case.
        end.
        
        return this-object.
    end method.
    
    method public Summarizer addAggregation(
        pFieldName as char,
        pAggregator as char
    ):
        return addAggregation(pFieldName, pFieldName, pAggregator).
    end method.
    
    method public Summarizer addAggregation(
        pFieldName as char,
        pfieldSource as char,
        pAggregator as char
    ):
        return addAggregation(pFieldName, pfieldSource, pAggregator, false).
    end method.
    
    method public Summarizer addAggregation(
        pFieldName as char,
        pfieldSource as char,
        pAggregator as char,
        pTemporary as log
    ):
        assertAggregatorExist(pAggregator).
        if not findAggregation(pfieldSource, pAggregator) then do:
            create aggregationValues.
        end.
        assign 
            aggregationValues.fieldName = pFieldName
            aggregationValues.fieldSource = pfieldSource
            aggregationValues.aggregator = pAggregator
            aggregationValues.temporary =  pTemporary.
        return this-object.
    end method.
    
    method public log findAggregation(pTarget as char, pAggregator as char):
        find first aggregationValues
            where
                aggregationValues.fieldSource = pTarget
                and aggregationValues.aggregator = pAggregator
            no-error.
        return avail aggregationValues.    
    end method.
    
    method protected void assertAggregatorExist(pName as char):
        if not findAggregator(pName) then do:
            return error new AggregatorNotFound(pName).
        end.
    end method.
    
    method protected log findKey(pKey as char):
        find first aggregationKeys 
            where aggregationKeys.fieldName = pKey
            no-error.
        return avail aggregationKeys.    
    end method.
end class.
