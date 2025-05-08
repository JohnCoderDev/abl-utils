block-level on error undo, throw.
using classes.Mail.* from propath.
using Progress.Json.ObjectModel.* from propath.

class classes.Mail.MailDeserializer:
    define protected static temp-table objects
        field objectName as character
        field className as character
        index idxObject as primary unique objectName.
    
    constructor static MailDeserializer():
        registerObject('default', 'classes.Mail.CaspMail').
    end constructor.
    
    method public static Mail deserialize(pJson as JsonObject):
        return deserialize(pJson, 'default').
    end method.
    
    method public static Mail deserialize(pJson as JsonObject, pObjectName as character):
        define variable mailObject as Mail no-undo.
        
        find first objects no-lock
            where objects.objectName = pObjectName 
            no-error.
        
        if not available objects then do:
            return error new classes.Mail.Errors.MailClassNotFound(pObjectName).
        end.
        
        assign mailObject = cast(Progress.Lang.Class:getClass(objects.className):new(), Mail).
        
        define variable idx as integer no-undo.
        
        if pJson:has('senderMail') then do:
            mailObject:setSenderMail(pJson:getCharacter('senderMail')).
        end.
        
        if pJson:has('senderPassword') then do:
            mailObject:setSenderPassword(pJson:getCharacter('senderPassword')).
        end.
        
        if pJson:has('importance') then do:
            mailObject:setImportance(pJson:getInteger('importance')).
        end.
        
        if pJson:has('port') then do:
            mailObject:setMailPort(pJson:getInteger('port')).
        end.
        
        if pJson:has('path') then do:
            mailObject:setPath(pJson:getInteger('path')).
        end.
        
        if pJson:has('server') then do:
            mailObject:setMailServer(pJson:getCharacter('server')).
        end.
        
        if pJson:has('title') then do:
            mailObject:setTitle(pJson:getCharacter('title')).
        end.
        
        if pJson:has('receivers') then do:
            define variable receivers as JsonArray no-undo.
            assign receivers = pJson:getJsonArray('receivers').
            
            do idx = 1 to receivers:length:
                mailObject:addReceiver(receivers:getCharacter(idx)).
            end.
        end.
        
        if pJson:has('body') then do:
            case pJson:getType('body'):
                when JsonDataType:Array then do:
                    define variable body as JsonArray no-undo.
                    assign body = pJson:getJsonArray('body').
                    
                    do idx = 1 to body:length:
                        mailObject:appendBody(body:getCharacter(idx)).
                    end.
                end.
                when JsonDataType:String then do:
                    mailObject:setBody(pJson:getCharacter('body')).
                end.
            end case.
        end.
        
        if pJson:has('variables') then do:
            define variable variables as JsonArray no-undo.
            define variable currentVariable as JsonObject no-undo.
            define variable currentFormat as character no-undo.
            assign variables = pJson:getJsonArray('variables').
            
            do idx = 1 to variables:length:
                assign 
                    currentVariable = variables:getJsonObject(idx)
                    currentFormat = if currentVariable:has('format') then currentVariable:getCharacter('format') else ?.
                
                case currentVariable:getCharacter('type'):
                    when 'number' then do:
                        mailObject:addVariable(
                            currentVariable:getCharacter('name'), 
                            currentVariable:getDecimal('value'),
                            currentFormat
                        ).    
                    end.
                    when 'date' then do:
                        mailObject:addVariable(
                            currentVariable:getCharacter('name'), 
                            currentVariable:getDate('value'),
                            currentFormat
                        ). 
                    end.
                    when 'datetime' then do:
                        mailObject:addVariable(
                            currentVariable:getCharacter('name'), 
                            currentVariable:getDatetime('value'),
                            currentFormat
                        ). 
                    end.
                    when 'string' then do:
                        mailObject:addVariable(
                            currentVariable:getCharacter('name'), 
                            currentVariable:getCharacter('value'),
                            currentFormat
                        ).
                    end.
                    when 'boolean' then do:
                        mailObject:addVariable(
                            currentVariable:getCharacter('name'), 
                            currentVariable:getLogical('value'),
                            currentFormat
                        ).
                    end.
                end case.
            end.
        end.
        
        if pJson:has('serialize') then do:
            define variable objectsToSerialize as JsonArray no-undo.
            define variable currentObject as JsonObject no-undo.
            
            assign
                objectsToSerialize = pJson:getJsonArray('serialize').
            
            do idx = 1 to objectsToSerialize:length:
                assign currentObject = objectsToSerialize:getJsonObject(idx).
                
                case currentObject:getType('object'):
                    when JsonDataType:Array then do:
                        mailObject:addSerializedObject(
                            currentObject:getCharacter('id'),
                            currentObject:getJsonArray('object'),
                            currentObject:getCharacter('serializer')
                        ).    
                    end.
                    when JsonDataType:Object then do:
                        mailObject:addSerializedObject(
                            currentObject:getCharacter('id'),
                            currentObject:getJsonObject('object'),
                            currentObject:getCharacter('serializer')
                        ).    
                    end.
                end case.
            end.
        end.
        
        return mailObject.
    end method.
    
    method protected static void registerObject(pName as character, pClass as character):
        find first objects
            where objects.objectName = pName
            no-error.
        
        if not available objects then do:
            create objects.            
        end.
        
        assign
            objects.objectName = pName
            objects.className = pClass.
    end method.
end class.
