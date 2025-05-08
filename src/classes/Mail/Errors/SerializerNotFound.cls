class classes.Mail.Errors.SerializerNotFound inherits Progress.Lang.AppError:
    constructor SerializerNotFound(pName as character):
        addMessage('it was not possible to find a mail serializer with name `' + pName  + '`', -5100).
    end constructor.
end class.
