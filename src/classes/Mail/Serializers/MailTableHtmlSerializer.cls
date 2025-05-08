block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.Html.Serializers.* from propath.

class classes.Mail.Serializers.MailTableHtmlSerializer implements classes.Mail.Interfaces.IMailObjectSerializer:
    define private property serializer as TableHtmlSerializer no-undo get. set.
    
    constructor MailTableHtmlSerializer():
        assign serializer = new TableHtmlSerializer().
        serializer:getTableTag()
            :addStyle('border-collapse', 'collapse')
            :addStyle('font-size', '11pt')
            :addStyle('border', '1px solid #C9CBC8').
        
        serializer:getThHeaderTag()
            :addStyle('border', '1px solid #C9CBC8')
            :addStyle('background-color', '#0C60AB')
            :addStyle('color','#FCFEFB')
            :addStyle('font-weight', '500')
            :addStyle('padding', '6px').
        
        serializer:getTdBodyTag()
            :addStyle('border', '1px solid #C9CBC8')
            :addStyle('font-weight', '300')
            :addStyle('padding', '6px').
    end constructor.
    
    method public longchar serialize(pObject as Progress.Lang.Object):
        return serializer:serialize(cast(pObject, JsonArray)).
    end method.
    
    method public longchar serialize(pTable as handle):        
        return serializer:serialize(pTable).
    end method.
end class.
