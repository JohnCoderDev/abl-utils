block-level on error undo, throw.
using classes.Mail.* from propath.


class classes.Mail.MailSerializedObject:
    define public property serializedObject as longchar no-undo get. set.
    
    constructor MailSerializedObject(pObject as Progress.Lang.Object, pSerializer as character):
        assign serializedObject = MailObjectSerializer:serialize(pObject, pSerializer).
    end constructor.
    
    constructor MailSerializedObject(pHandle as Handle, pSerializer as character):
        assign serializedObject = MailObjectSerializer:serialize(pHandle, pSerializer).
    end constructor.
end class.
