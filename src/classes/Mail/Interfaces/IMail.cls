interface classes.Mail.Interfaces.IMail:
    define public property mailTitle as character no-undo get. set.
    define public property mailBody as longchar no-undo get. set.
    define public property path as integer no-undo get. set.
    define public property senderMail as character no-undo get. set.
    define public property senderPassword as character no-undo get. set.
    define public property mailServer as character no-undo get. set.
    define public property mailPort as integer no-undo get. set.
    define public property importance as integer no-undo get. set.
    define public property errorsTable as handle no-undo get. set.
    define public property receiversMails as character no-undo get. set.
    
    
    method public void send().
    method public void setErrorsTable(pTable as handle).
end interface.
