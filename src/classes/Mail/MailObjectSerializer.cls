block-level on error undo, throw.
using classes.Mail.Interfaces.* from propath.
using classes.Mail.Serializers.* from propath.

class classes.Mail.MailObjectSerializer:
    define private static temp-table serializers
        field serializerName as character
        field serializerClass as character
        index idxName as primary unique serializerName.
    
    constructor static MailObjectSerializer():
        registerSerializer("table", "classes.Mail.Serializers.MailTableHtmlSerializer").
        registerSerializer("JsonArray", "classes.Mail.Serializers.MailTableHtmlSerializer").
        registerSerializer("list", "classes.Mail.Serializers.MailListHtmlSerializer").
        registerSerializer("JsonObject", "classes.Mail.Serializers.MailListHtmlSerializer").
    end constructor.
    
    method public static longchar serialize(pTable as handle, pName as character):
        return getSerializer(pName):serialize(pTable).
    end method.
    
    method public static longchar serialize(pObject as Progress.Lang.Object, pName as character):
        return getSerializer(pName):serialize(pObject).
    end method.
    
    method public static IMailObjectSerializer getSerializer(pName as character):
        find first serializers
            where serializers.serializerName = pName
            no-error.
        
        if not available serializers then do:
            return error new classes.Mail.Errors.SerializerNotFound(pName).
        end.
        
        return cast(Progress.Lang.Class:getClass(serializers.serializerClass):new(), IMailObjectSerializer).
    end method.
    
    method public static void registerSerializer(pName as character, pClass as character):
        find first serializers
            where serializers.serializerName = pName
            no-error.
        
        if not available serializers then do:
            create serializers.
        end.
        
        assign
            serializers.serializerName = pName
            serializers.serializerClass = pClass.
    end method.
end class.
