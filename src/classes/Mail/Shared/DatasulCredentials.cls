block-level on error undo, throw.
using classes.ParamFetcher.SParamFetcher from propath.

class classes.Mail.Shared.DatasulCredentials serializable:
    define public property userName as character get. protected set.
    define public property password as character get. protected set.
    
    constructor DatasulCredentials(pUser as character, pPassword as character):
        assign
            userName = pUser
            password = pPassword.
    end constructor.
    
    constructor DatasulCredentials(pGroup as integer):
        assign
            userName = SParamFetcher:getParameterValue('username', pGroup)
            password = SParamFetcher:getParameterValue('password', pGroup).
    end constructor.
end class.
