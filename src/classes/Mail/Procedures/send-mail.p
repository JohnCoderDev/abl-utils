block-level on error undo, throw.
using classes.Mail.* from propath.

&scoped-define chunkSize 16000

define input-output parameter mailSender as Mail no-undo.

{utp/utapi019.i2}

empty temp-table tt-mensagem.
empty temp-table tt-paramEmail2.
empty temp-table tt-envio2.
empty temp-table ttAttachment.
empty temp-table tt-erros.

create tt-paramEmail2.
assign
    tt-paramEmail2.caminhoEmail = mailSender:path
    tt-paramEmail2.mailUser = mailSender:senderMail
    tt-paramEmail2.mailPass = mailSender:senderPassword
    tt-paramEmail2.TLS = yes
    tt-paramEmail2.SSL = no
    tt-paramEmail2.DEBUG = yes
    tt-paramEmail2.ativaRemetPadrao = no.
    
create tt-envio2.
assign 
    tt-envio2.versao-integracao = 1
    tt-envio2.servidor = mailSender:mailServer
    tt-envio2.porta = mailSender:mailPort
    tt-envio2.remetente = tt-paramEmail2.mailUser
    tt-envio2.formato = "HTML"
    tt-envio2.importancia = mailSender:importance
    tt-envio2.destino = mailSender:receiversMails
    tt-envio2.assunto = mailSender:mailTitle.
        
define variable subMessage as character no-undo.
define variable messageStart as integer no-undo.
define variable idx as integer initial 1 no-undo.


do messageStart = 1 to length(mailSender:mailBody) by {&chunkSize}:
    create tt-mensagem.
    assign
        tt-mensagem.seq-mensagem = idx
        tt-mensagem.mensagem = substring(mailSender:mailBody, messageStart, {&chunkSize})
        idx = idx + 1.
end.

run utp/utapi019.p persistent set h-utapi019.

run pi-execute4 in h-utapi019(
    input  table tt-envio2,
    input  table tt-mensagem,
    input  table tt-paramEmail2,
    input  table ttAttachment,
    output table tt-erros
).

mailSender:setErrorsTable(temp-table tt-erros:handle).

delete procedure h-utapi019.
