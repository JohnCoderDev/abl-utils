block-level on error undo, throw.
using classes.Mail.* from propath.
using classes.Mail.Interfaces.* from propath.
using classes.Mail.Shared.* from propath.

class classes.Mail.Mail serializable implements classes.Mail.Interfaces.IMail:
    define public serializable property mailTitle as character no-undo get. set.
    define public serializable property unreplacedMailTitle as character no-undo get. set.
    define public serializable property mailBody as longchar no-undo get. set.
    define public serializable property unreplacedMailBody as longchar no-undo get. set.
    define public serializable property path as integer no-undo get. set.
    define public serializable property senderMail as character no-undo get. set.
    define public serializable property senderPassword as character no-undo get. set.
    define public serializable property mailServer as character no-undo get. set.
    define public serializable property mailPort as integer no-undo get. set.
    define public serializable property importance as integer no-undo get. set.
    define public serializable property errorsTable as handle no-undo get. set.
    
    define public property receiversMails as character no-undo get. set.
    define public property dtsCredentials as DatasulCredentials no-undo get. set.
    
    define public serializable property variableDelimiter as character initial "#" no-undo get. set.
    define public serializable property serializableObjectDelimiter as character initial "$" no-undo get. set.
    define public serializable property destinyMailSeparator as character initial "," no-undo get. set.
    
    define protected serializable temp-table variables
        field variableName as character
        field variableValue as character
        index idxName as primary unique variableName.
        
    define protected temp-table serializedObjects
        field id as character
        field serializedObject as Progress.Lang.Object.
    
    define protected serializable temp-table receivers
        field receiverMail as character
        index idxMail as primary unique receiverMail.
        
    define private temp-table serializers
        field serializerName as character
        field serializerClass as character
        index idxClass as primary unique serializerClass.
    
    method public Mail setPath(pPath as integer):
        assign path = pPath.
        return this-object.
    end method.
    
    method public Mail setSenderMail(pMail as character):
        assign senderMail = pMail.
        return this-object.
    end method.
    
    method public Mail setSenderPassword(pPassword as character):
        assign senderPassword = pPassword.
        return this-object.
    end method.
    
    method public Mail setMailServer(pServer as character):
        assign mailServer = pServer.
        return this-object.
    end method.
    
    method public Mail setImportance(pImportance as integer):
        assign importance = pImportance.
        return this-object.
    end method.
    
    method public Mail setMailPort(pPort as integer):
        assign mailPort = pPort.
        return this-object.
    end method.
    
    method public Mail setDatasulCredentials(pUser as character, pPassword as character):
        assign dtsCredentials = new DatasulCredentials(pUser, pPassword).
        return this-object.
    end method.
    
    method public Mail setDatasulCredentials(pGroup as integer):
        assign dtsCredentials = new DatasulCredentials(pGroup).
        return this-object.
    end method.
    
    method public Mail addVariable(pName as character, pValue as character):
        assign pName = quoter(pName, variableDelimiter).
        find first variables 
            where variables.variableName = pName
            no-error.
            
        if not available variables then do: 
            create variables.
        end.
        
        assign
            variables.variableName = pName
            variables.variableValue = pValue.
            
        return this-object.    
    end method.
    
    method public Mail addVariable(pName as character, pValue as int64):
        return addVariable(pName, string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as decimal):
        return addVariable(pName, string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as date):
        return addVariable(pName, string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as datetime):
        return addVariable(pName, string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as datetime-tz):
        return addVariable(pName, string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as logical):
        return addVariable(pName, string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as character, pFormat as character):
        return addVariable(pName, if pFormat <> ? and pFormat <> '' then string(pValue, pFormat) else string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as int64, pFormat as character):
        return addVariable(pName, if pFormat <> ? and pFormat <> '' then string(pValue, pFormat) else string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as decimal, pFormat as character):
        return addVariable(pName, if pFormat <> ? and pFormat <> '' then string(pValue, pFormat) else string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as date, pFormat as character):
        return addVariable(pName, if pFormat <> ? and pFormat <> '' then string(pValue, pFormat) else string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as datetime, pFormat as character):
        return addVariable(pName, if pFormat <> ? and pFormat <> '' then string(pValue, pFormat) else string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as datetime-tz, pFormat as character):
        return addVariable(pName, if pFormat <> ? and pFormat <> '' then string(pValue, pFormat) else string(pValue)).
    end method.
    
    method public Mail addVariable(pName as character, pValue as logical, pFormat as character):
        return addVariable(pName, if pFormat <> ? and pFormat <> '' then string(pValue, pFormat) else string(pValue)).
    end method.
    
    method public Mail addReceiver(pMail as character):
        if not can-find(first receivers where receivers.receiverMail = pMail) then do:
            create receivers.
            assign receivers.receiverMail = pMail.
        end.
        return this-object.
    end method.
    
    method public Mail removeReceiver(pMail as character):
        find first receivers
            where receivers.receiverMail = pMail
            no-error.
        
        if available receivers then do:
            delete receivers.
        end.
        
        return this-object.
    end method.
    
    method public Mail clearBody():
        assign mailBody = "".
        return this-object.
    end method.
    
    method public Mail clearTitle():
        assign mailTitle = "".
        return this-object.
    end method.
    
    method public Mail clearReceivers():
        empty temp-table receivers.
        return this-object.
    end method.
    
    method public Mail clearSerializedObjects():
        empty temp-table serializedObjects.
        return this-object.
    end method.
    
    method public Mail clearVariables():
        empty temp-table variables.
        return this-object.
    end method.
    
    method public Mail clearAll():
        clearBody().
        clearTitle().
        clearReceivers().
        clearVariables().
        clearSerializedObjects().
        return this-object.
    end method.
    
    method public Mail setBody(pBody as longchar):
        assign unreplacedMailBody = "<p>" + pBody + "</p>".
        return this-object.
    end method.
    
    method public Mail appendBody(pBody as longchar):
        assign unreplacedMailBody = unreplacedMailBody + "<p>" + pBody + "</p>".
        return this-object.
    end method.
    
    method public Mail addSerializedObject(pId as character, pObject as Progress.Lang.Object, pSerializer as character):
        assign pId = normalizedSerializedObjectId(pId).
        find first serializedObjects 
            where serializedObjects.id = pId
            no-error.
        
        if not available serializedObjects then do:
            create serializedObjects.
        end.
        
        assign
            serializedObjects.id = pId
            serializedObjects.serializedObject = new MailSerializedObject(pObject, pSerializer).
        
        return this-object.
    end method.
    
    method public Mail addSerializedObject(pId as character, pHandle as handle, pSerializer as character):
        assign pId = normalizedSerializedObjectId(pId).
        find first serializedObjects 
            where serializedObjects.id = pId
            no-error.
        
        if not available serializedObjects then do:
            create serializedObjects.
        end.
        
        assign
            serializedObjects.id = pId
            serializedObjects.serializedObject = new MailSerializedObject(pHandle, pSerializer).
        
        return this-object.
    end method.
    
    method private character normalizedSerializedObjectId(pId as character):
        return quoter(pId, serializableObjectDelimiter).
    end method.
    
    method public Mail setTitle(pTitle as character):
        assign unreplacedMailTitle = pTitle.
        return this-object.
    end method.
    
    method public void send():
        if not temp-table receivers:has-records then return.
        prepare().
        define variable mail as Mail no-undo.
        assign mail = this-object.
        run classes/Mail/Procedures/send-mail.p(input-output mail).
    end method.
    
    method public void sendOneByOne():
        define variable mail as Mail no-undo.
        assign mail = this-object.
        
        for each receivers:
            assign receiversMails = receivers.receiverMail.
            addVariable("email", receiversMails).
            replaceObjects().
            run classes/Mail/Procedures/send-mail.p(input-output mail).
        end.
    end method.
    
    method protected void prepare():
        assign receiversMails = "".
        
        for each receivers:
            assign receiversMails = receiversMails + receivers.receiverMail + destinyMailSeparator.
        end.
        
        assign receiversMails = substring(receiversMails, 1, length(receiversMails) - 1).
        
        addVariable("email", receiversMails).
        addVariable("currentUser", user('emsfnd')).        
        replaceObjects().
    end method.
    
    method protected void replaceObjects():
        define variable serializedObjectText as longchar no-undo.
        
        assign 
            mailBody = unreplacedMailBody
            mailTitle = unreplacedMailTitle.
        
        for each variables:
            assign
                mailTitle = replace(mailTitle, variables.variableName, variables.variableValue)
                mailBody = replace(mailBody, variables.variableName, variables.variableValue).    
        end.
        
        for each serializedObjects:
            assign
                serializedObjectText = cast(serializedObjects.serializedObject, MailSerializedObject):serializedObject
                mailBody = replace(mailBody, serializedObjects.id, serializedObjectText).
        end.
    end method.
    
    method public handle getErrorsTable():
        return errorsTable.
    end method. 
    
    method public void setErrorsTable(pErrosTable as handle):
        assign errorsTable = pErrosTable.
    end method.
end class.
