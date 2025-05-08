class classes.Mail.Errors.MailClassNotFound inherits Progress.Lang.AppError:
    constructor MailClassNotFound(pName as character):
        addMessage('it was not possible to find a valid json class with name `' + pName + '` associated', -5010).
    end constructor.
end class.
