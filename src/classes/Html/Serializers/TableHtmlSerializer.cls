block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.Html.* from propath.

class classes.Html.Serializers.TableHtmlSerializer:
    define protected property tableTag as TagBuilder no-undo get. set.
    define protected property trHeaderTag as TagBuilder no-undo get. set.
    define protected property thHeaderTag as TagBuilder no-undo get. set.
    define protected property trBodyTag as TagBuilder no-undo get. set.
    define protected property tdBodyTag as TagBuilder no-undo get. set.
    
    constructor TableHtmlSerializer():
        assign
            tableTag = new TagBuilder('table')
            trHeaderTag = new TagBuilder('tr')
            thHeaderTag = new TagBuilder('th')
            trBodyTag = new TagBuilder('tr')
            tdBodyTag = new TagBuilder('td').
    end constructor.
    
    method public longchar serialize(pJson as JsonArray):
        define variable serializedTable as longchar no-undo.
        define variable currentJson as JsonObject no-undo.
        define variable currentKey as character no-undo.
        define variable jsonKeys as character extent no-undo.
        define variable idx as integer no-undo.
        define variable idy as integer no-undo.
        
        assign serializedTable = tableTag:getOpenTag().
        
        if pJson:length > 0 then do:
            assign 
                jsonKeys = pJson:getJsonObject(1):getNames()
                serializedTable = serializedTable + trHeaderTag:getOpenTag().
            
            do idx = 1 to extent(jsonKeys):
                assign serializedTable = serializedTable 
                    + thHeaderTag:getOpenTag() 
                    + jsonKeys[idx] 
                    + thHeaderTag:getCloseTag().
            end.
            
            assign serializedTable = serializedTable + trHeaderTag:getCloseTag().
            
            do idx = 1 to pJson:length:
                assign 
                    currentJson = pJson:getJsonObject(idx)
                    serializedTable = serializedTable + trBodyTag:getOpenTag().
                
                do idy = 1 to extent(jsonKeys):
                    assign 
                        currentKey = jsonKeys[idy]
                        serializedTable = serializedTable + tdBodyTag:getOpenTag().
                        
                    case currentJson:getType(currentKey):
                        when JsonDataType:string then do:
                            assign serializedTable = serializedTable + currentJson:getCharacter(currentKey).
                        end.
                        when JsonDataType:number then do:
                            assign serializedTable = serializedTable + string(currentJson:getDecimal(currentKey)).
                        end.
                        when JsonDataType:boolean then do:
                            assign serializedTable = serializedTable + string(currentJson:getLogical(currentKey)).
                        end.
                        when JsonDataType:array then do:
                            assign serializedTable = serializedTable + string(currentJson:getJsonArray(currentKey):getJsonText()).
                        end.
                        when JsonDataType:object then do:
                            assign serializedTable = serializedTable + string(currentJson:getJsonObject(currentKey):getJsonText()).
                        end.
                        when JsonDataType:null then do:
                            assign serializedTable = serializedTable + "null".
                        end.
                    end case.
                    
                    assign serializedTable = serializedTable + tdBodyTag:getCloseTag().
                end.
                
                assign serializedTable = serializedTable + trBodyTag:getCloseTag().
            end.    
        end.
        assign serializedTable = serializedTable + tableTag:getCloseTag().
        return serializedTable.
    end method.
    
    method public longchar serialize(pTable as handle):
        return serialize(pTable, 'label').
    end method.
    
    method public longchar serialize(pTable as handle, pHeader as character):
        define variable tableQuery as handle no-undo.
        define variable defaultBuffer as handle no-undo.
        define variable bufferField as handle no-undo.
        define variable idx as integer no-undo.
        define variable tableResult as longchar no-undo.
        
        assign 
            defaultBuffer = pTable:default-buffer-handle
            tableResult = tableTag:getOpenTag() + trHeaderTag:getOpenTag().
            
        do idx = 1 to defaultBuffer:num-fields:
            assign
                bufferField = defaultBuffer:buffer-field(idx).
            
            if pHeader = 'label' then do:
                if bufferField:column-label <> '' and bufferField:column-label <> ? then do:
                    assign tableResult = tableResult + thHeaderTag:getOpenTag() 
                        +  bufferField:column-label + thHeaderTag:getCloseTag().
                end.
                else if bufferField:label <> '' and bufferField:label <> ? then do:
                    assign tableResult = tableResult + thHeaderTag:getOpenTag() 
                        +  bufferField:label + thHeaderTag:getCloseTag().
                end.
                else do:
                    assign tableResult = tableResult + thHeaderTag:getOpenTag() 
                        +  bufferField:name + thHeaderTag:getCloseTag().
                end.
            end.
            else do:
                assign tableResult = tableResult + thHeaderTag:getOpenTag() 
                    +  bufferField:name + thHeaderTag:getCloseTag().
            end.
        end.
        
        assign tableResult = tableResult + trHeaderTag:getCloseTag().
        
        create query tableQuery.
        tableQuery:set-buffers(defaultBuffer).
        tableQuery:query-prepare('for each ' + pTable:name).
        tableQuery:query-open.
        tableQuery:get-first.
        
        do while not tableQuery:query-off-end:
            assign tableResult = tableResult + trBodyTag:getOpenTag().
            
            do idx = 1 to defaultBuffer:num-fields:
                assign
                    bufferField = defaultBuffer:buffer-field(idx)
                    tableResult = tableResult + tdBodyTag:getOpenTag() 
                        + (
                            if bufferField:format = ? or bufferField:format = '' then 
                                string(bufferField:buffer-value)
                            else
                                string(bufferField:buffer-value, bufferField:format)
                        ) + tdBodyTag:getCloseTag().
            end.
            
            assign tableResult = tableResult + trBodyTag:getCloseTag().
            tableQuery:get-next.
        end.
        
        assign tableResult = tableResult + tableTag:getCloseTag().
        
        tableQuery:query-close.
        delete object tableQuery.
        return tableResult.
    end method.
    
    method public TagBuilder getTableTag():
        return tableTag.
    end method.
    
    method public TagBuilder getTrHeaderTag():
        return trHeaderTag.
    end method.
    
    method public TagBuilder getThHeaderTag():
        return thHeaderTag.
    end method.
    
    method public TagBuilder getTrBodyTag():
        return trBodyTag.
    end method.
    
    method public TagBuilder getTdBodyTag():
        return tdBodyTag.
    end method.
end class.
