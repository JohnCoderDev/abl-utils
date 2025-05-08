block-level on error undo, throw.
using classes.Html.* from propath.
using Progress.Json.ObjectModel.* from propath.

class classes.Html.Serializers.ListHtmlSerializer:
    define public property leftSpan as TagBuilder no-undo get. protected set.
    define public property rightSpan as TagBuilder no-undo get. protected set.
    define public property listItem as TagBuilder no-undo get. protected set.
    define public property unorderedList as TagBuilder no-undo get. protected set.
    define public property separator as character no-undo initial '=' get. set.
    
    constructor ListHtmlSerializer():
        assign
            leftSpan = new TagBuilder('span')
            rightSpan = new TagBuilder('span')
            unorderedList = new TagBuilder('ul')
            listItem = new TagBuilder('li').
    end constructor.
    
    method public longchar serialize(pJson as JsonObject):
        define variable idx as integer no-undo.
        define variable idy as integer no-undo.
        define variable jsonKeys as character extent no-undo.
        define variable currentKey as character no-undo.
        define variable currentArray as JsonArray no-undo.
        define variable serialized as longchar no-undo.
        
        assign
            serialized = unorderedList:getOpenTag().
            jsonKeys = pJson:getNames().
            
        do idx = 1 to extent(jsonKeys):
            assign
                currentKey = jsonKeys[idx]
                serialized = serialized 
                    + listItem:getOpenTag() 
                    + leftSpan:getOpenTag()
                    + currentKey
                    + (if separator <> '' and separator <> ? then ' ' + separator else '') + ' '
                    + leftSpan:getCloseTag()
                    + rightSpan:getOpenTag().
            
            case pJson:getType(currentKey):
                when JsonDataType:string then do:
                    assign serialized = serialized + pJson:getCharacter(currentKey).
                end.
                when JsonDataType:boolean then do:
                    assign serialized  = serialized + string(pJson:getLogical(currentKey)).
                end.
                when JsonDataType:number then do:
                    assign serialized = serialized + string(pJson:getDecimal(currentKey)).
                end.
                when JsonDataType:array then do:
                    assign 
                        serialized = serialized + '['
                        currentArray = pJson:getJsonArray(currentKey).
                    
                    do idy = 1 to currentArray:length:
                        case currentArray:getType(idy):
                            when JsonDataType:string then do:
                                assign serialized = serialized + currentArray:getCharacter(idy) + ', '.
                            end.
                            when JsonDataType:number then do:
                                assign serialized = serialized + string(currentArray:getDecimal(idy)) + ', '.
                            end.
                            when JsonDataType:boolean then do:
                                assign serialized = serialized + string(currentArray:getLogical(idy)) + ', '.
                            end.
                        end case.
                    end.
                    
                    assign
                        serialized = substring(serialized, 1, length(serialized) - 2)
                        serialized = serialized + ']' + rightSpan:getCloseTag().
                end.
            end case.
            serialized = serialized + listItem:getCloseTag().
        end.
            
        assign serialized = serialized + unorderedList:getCloseTag().
        return serialized.
    end method.
    
    method public longchar serialize(pBuffer as handle):
        if not pBuffer:available then do:
            return ''.
        end.
        define variable idx as integer no-undo.
        define variable idy as integer no-undo.
        define variable serialized as longchar no-undo.
        define variable currentField as handle no-undo.
        
        assign serialized = unorderedList:getOpenTag().
        
        do idx = 1 to pBuffer:num-fields:
            assign
                currentField = pBuffer:buffer-field(idx)
                serialized = serialized
                    + listItem:getOpenTag() 
                    + leftSpan:getOpenTag()
                    + currentField:name
                    + (if separator <> '' and separator <> ? then ' ' + separator else '') + ' '
                    + leftSpan:getCloseTag()
                    + rightSpan:getOpenTag().
                
                if currentField:extent > 0 then do:
                    assign serialized = serialized + '['.
                    do idy = 1 to currentField:extent:
                        assign serialized = serialized + string(currentField:buffer-value) + ', '.
                    end.
                    
                    assign 
                        serialized = substring(serialized, 1, length(serialized) - 2)
                        serialized = serialized + ']' + rightSpan:getCloseTag().
                end.
                else do:
                    assign serialized = serialized + string(currentField:buffer-value) + rightSpan:getCloseTag().
                end.
        end.
        
        assign serialized = serialized + unorderedList:getCloseTag().
        return serialized.
    end method.
end class.
