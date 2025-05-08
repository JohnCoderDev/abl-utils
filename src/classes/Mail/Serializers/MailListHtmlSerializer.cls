block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.Html.Serializers.* from propath.

class classes.Mail.Serializers.MailListHtmlSerializer implements classes.Mail.Interfaces.IMailObjectSerializer:
    define private property serializer as ListHtmlSerializer no-undo get. set.
    
    constructor MailListHtmlSerializer():
        assign serializer = new ListHtmlSerializer().
        
        serializer:leftSpan
            :addStyle('font-size', '11pt')
            :addStyle('font-weight', '800').
        
        serializer:rightSpan
            :addStyle('font-size', '11pt')
            :addStyle('font-weight', '300')
            :addStyle('color', '#4C4C4C').
    end constructor.
    
    method public longchar serialize(pObject as Progress.Lang.Object):
        return serializer:serialize(cast(pObject, JsonObject)).
    end method.
    
    method public longchar serialize(pBuffer as handle):        
        return serializer:serialize(pBuffer).
    end method.
end class.
