//QB.Phone.Functions.SetupMails(event.data.Mails);

$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .mail-app {
            display: none;
            height: 100%;
            width: 100%;
            background: #ffffff;
            overflow: hidden;
            --mail-background: #F5F8FA;
            --mail-gray: #797979;
            --mail-dark-blue: #005aff;
            --mail-blue: #0099ff;
            --mail-light-blue: #3eb3fc;
            --mail-white: #FFFFFF;
            --mail-dirty-white: #EEEEEE;
            --mail-dark-gray: #2d2d2d;
            --mail-black: #000000;
            --mail-red: #e82616;
            --mail-light-red: #ea4335;
            --mail-gray-fix: #797979;
            --mail-white-fix: #FFFFFF;
            --mail-dirty-white-fix: #EEEEEE;
        }
    </style>
    <div class="mail-app"></div>
`);

//Home page
$('.mail-app').append(/*html*/`
    <style type="text/css">
        .mail-homepage {
            display: block;
            position: absolute;
            top: 0;
            right: 0;
            height: 100%;
            width: 100%;
            background: var(--mail-white);
            overflow: hidden;
            color: var(--mail-black);
            transition: right 0.2s, left 0.2s;
        }

        .mail-homepage-slide {
            right: 10%;
        }

        .mail-homepage-lslide {
            right: -10%;
        }

        .mail-homepage-header {
            position: relative;
            margin-top: 5vh;
        }

        .mail-homepage-header-buttons {
            display: flex;
            color: var(--mail-dark-blue);
            justify-content: space-between;
            width: 92%;
            margin: auto;
        }

        .mail-homepage-inbox {
            font-family: 'Samsung Sans Bold';
            font-size: 2.5vh;
            width: 91%;
            margin: auto;
            margin-right: 0;
            border-bottom: 1px solid rgb(0 0 0 / 11%);
        }

        .mail-homepage-list {
            position: relative;
            height: 45.5vh;
            overflow-x: hidden;
            overflow-y: scroll;
        }

        .mail-homepage-list::-webkit-scrollbar {
            display: none;
        }

        .mail-homepage-footer {
            position: relative;
            height: 4vh;
            width: 100%;
            border-top: 1px solid rgb(0 0 0 / 11%);
            backdrop-filter: blur(8px);
            display: flex;
            justify-content: space-around;
            align-items: center;
        }

        .mail-homepage-filter {
            width: 2vh;
            height: 2vh;
            fill: var(--mail-dark-blue);
            transition: 0.2s;
        }

        .mail-homepage-filter:hover {
            fill: var(--mail-blue);
        }

        .mail-homepage-mailcount {
            width: 13vh;
            text-align: center;
            font-size: 1.2vh;
        }

        .mail-homepage-newmail {
            font-size: 1.8vh;
            color: var(--mail-dark-blue);
            transition: 0.2s;
        }

        .mail-homepage-newmail:hover {
            color: var(--mail-blue);
        }

        .mail-homepage-account {
            transition: 0.2s;
        }

        .mail-homepage-account:hover {
            color: var(--mail-blue);
        }

        .mail-homepage-edit {
            transition: 0.2s;
        }

        .mail-homepage-edit:hover {
            color: var(--mail-blue);
        }

        .mail-homepage-mail {
            position: relative;
            width: 91%;
            margin: auto;
            margin-right: 0;
            border-bottom: 1px solid rgb(0 0 0 / 11%);
        }

        .mail-homepage-mail-header {
            display: flex;
            justify-content: space-between;
            margin-top: 0.4vh;
        }

        .mail-homepage-from {
            font-family: 'Samsung Sans Bold';
        }

        .mail-homepage-timeago {
            margin-right: 1vh;
            color: var(--mail-gray);
            font-size: 1.1vh;
        }

        .mail-homepage-subject {
            width: 94%;
            height: 1.7vh;
            font-size: 1.2vh;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .mail-homepage-content {
            width: 94%;
            height: 2.2vh;
            font-size: 1.2vh;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            color: var(--mail-gray);
        }

        .mail-homepage-unread {
            position: absolute;
            height: 0.9vh;
            width: 0.9vh;
            background: var(--mail-dark-blue);
            top: 0.43vh;
            left: -1.4vh;
            border-radius: 0.9vh;
        }
    </style>
    <div class="mail-homepage">
        <div class="mail-homepage-header">
            <div class="mail-homepage-header-buttons">
                <div class="mail-homepage-account"><i class="fa-solid fa-chevron-left"></i>&nbsp;&nbsp;Conta</div>
                <div class="mail-homepage-edit">Editar</div>
            </div>

            <div class="mail-homepage-inbox">Inbox</div>
        </div>

        <div class="mail-homepage-list">
            <div class="mail-homepage-mail">
                <div class="mail-homepage-mail-header">
                    <div class="mail-homepage-from">Abrigo do Pastor</div>
                    <div class="mail-homepage-timeago">5 minutos&nbsp;&nbsp;<i class="fa-solid fa-chevron-right"></i></div>
                </div>
                <div class="mail-homepage-subject">Licença de porte de arma</div>
                <div class="mail-homepage-content">Olá João, podes aparecer na loja</div>
                <div class="mail-homepage-unread"></div>
            </div>
        
        </div>

        <div class="mail-homepage-footer">
            <div class="mail-homepage-filter"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M224 256C224 238.3 238.3 224 256 224C273.7 224 288 238.3 288 256C288 273.7 273.7 288 256 288C238.3 288 224 273.7 224 256zM288 160C288 177.7 273.7 192 256 192C238.3 192 224 177.7 224 160C224 142.3 238.3 128 256 128C273.7 128 288 142.3 288 160zM224 352C224 334.3 238.3 320 256 320C273.7 320 288 334.3 288 352C288 369.7 273.7 384 256 384C238.3 384 224 369.7 224 352zM512 256C512 397.4 397.4 512 256 512C114.6 512 0 397.4 0 256C0 114.6 114.6 0 256 0C397.4 0 512 114.6 512 256zM256 48C141.1 48 48 141.1 48 256C48 370.9 141.1 464 256 464C370.9 464 464 370.9 464 256C464 141.1 370.9 48 256 48z"/></svg></div>
            <div class="mail-homepage-mailcount">213 Mails</div>
            <div class="mail-homepage-newmail"><i class="fa-regular fa-pen-to-square"></i></div>
        </div>
    </div>
`);

//conta mail
$('.mail-app').append(/*html*/`
    <style type="text/css">
        .mail-account {
            position: absolute;
            height: 100%;
            width: 100%;
            right: 100%;
            top: 0;
            background: var(--mail-dirty-white);
            transition: right 0.2s;
        }

        .mail-account-show {
            right: 0;
        }

        .mail-account-header {
            margin: auto;
            margin-top: 7vh;
            width: 90%;
            font-size: 2vh;
            font-weight: bold;
        }

        .mail-account-container {
            margin: auto;
            margin-top: 0.5vh;
            background: var(--mail-white);
            width: 90%;
            border-radius: 1vh;
        }

        .mail-account-item {
            height: 3.5vh;
            line-height: 3.5vh;
            text-indent: 1vh;
            border-bottom: 1px solid rgb(0 0 0 / 11%);
        }

        .mail-account-address {
            font-weight: bolder;
        }

        .mail-account-inbox {
            color: var(--mail-dark-blue);
            transition: 0.2s;
        }

        .mail-account-inbox:hover {
            background: var(--mail-background);
        }

        .mail-account-logout {
            border-bottom: none;
            color: var(--mail-red);
            transition: 0.2s;
            border-radius: 1vh;
        }

        .mail-account-logout:hover {
            background: var(--mail-background);
        }
    </style>
    <div class="mail-account">
        <div class="mail-account-header">Mailboxes</div>
        <div class="mail-account-container">
            <div class="mail-account-item mail-account-name"><i class="fa-solid fa-signature"></i>&nbsp;&nbsp;<text id="mail-name">Gonçalo Costa</text></div>
            <div class="mail-account-item mail-account-address"><i class="fa-solid fa-address-book"></i>&nbsp;&nbsp;<text id="mail-address">goncalobsccosta@Sem Destino.pt</text></div>
            <div class="mail-account-item mail-account-inbox"><i class="fa-solid fa-inbox"></i>&nbsp;&nbsp;Inbox</div>
            <div class="mail-account-item mail-account-logout"><i class="fa-solid fa-right-from-bracket"></i>&nbsp;&nbsp;Logout</div>
        </div>
    </div>
`);

//conteudo mail
$('.mail-app').append(/*html*/`
    <style type="text/css">
        .mail-mailinfo {
            position: absolute;
            height: 100%;
            width: 100%;
            left: 100%;
            top: 0;
            background: var(--mail-white);
            transition: left 0.2s;
        }

        .mail-mailinfo-show {
            left: 0%;
        }

        .mail-mailinfo-header {
            margin: auto;
            margin-top: 5.5vh;
            display: flex;
            width: 92%;
            justify-content: space-between;
            font-size: 1.4vh;
            color: var(--mail-dark-blue);
        }

        .mail-mailinfo-back {
            transition: 0.2s;
        }

        .mail-mailinfo-back:hover {
            color: var(--mail-blue);
        }

        .mail-mailinfo-reply {
            transition: 0.2s;
        }

        .mail-mailinfo-reply:hover {
            color: var(--mail-blue);
        }

        .mail-mailinfo-from {
            margin: auto;
            margin-right: 0;
            margin-top: 1vh;
            width: 95%;
            font-size: 1.4vh;
            font-weight: bolder;
        }

        .mail-mailinfo-address {
            margin: auto;
            margin-right: 0;
            width: 95%;
            font-size: 1.2vh;
            color: var(--mail-gray-fix);
            border-bottom: 1px solid #0000001c;
        }

        .mail-mailinfo-subject {
            margin: auto;
            margin-right: 0;
            margin-top: 0.4vh;
            width: 95%;
            font-size: 1.6vh;
            font-weight: bold;
        }

        .mail-mailinfo-message {
            margin: auto;
            margin-right: 0.6vh;
            margin-top: 0.4vh;
            width: 93%;
            height: 70%;
        }

        .mail-mailinfo-message-pre {
            height: 100%;
        }
    </style>
    <div class="mail-mailinfo">
        <div class="mail-mailinfo-header">
            <div class="mail-mailinfo-back"><i class="fa-solid fa-chevron-left"></i>&nbsp;&nbsp;Inbox</div>
            <div class="mail-mailinfo-reply"><i class="fa-solid fa-reply"></i></div>
        </div>

        <div class="mail-mailinfo-from">John Doe</div>
        <div class="mail-mailinfo-address">johndoe@Sem Destino.pt</div>

        <div class="mail-mailinfo-subject">Mail subject</div>
        <div class="mail-mailinfo-message"><pre class="mail-mailinfo-message-pre">Mail content, if you are seeing this something went wrong.</pre></div>
    </div>
`);

//novo mail
$('.mail-app').append(/*html*/`
    <style type="text/css">
        .mail-newmail {
            display: block;
            position: absolute;
            bottom: -100%;
            height: 100%;
            width: 100%;
            background: var(--mail-white);
            overflow: hidden;
            color: var(--mail-black);
            transition: bottom 0.4s;
        }

        .mail-newmail-show {
            bottom: 0%;
            transition: bottom 0.4s;
        }

        .mail-newmail-cancel {
            margin-top: 5vh;
            margin-left: 1.4vh;
            font-size: 1.3vh;
            color: var(--mail-dark-blue);
        }

        .mail-newmail-cancel:hover {
            color: var(--mail-blue);
        }

        .mail-newmail-header {
            display: flex;
            justify-content: space-between;
            width: 91%;
            margin: auto;
            margin-top: 0.5vh;
            font-size: 2.4vh;
        }

        .mail-newmail-header-title {
            font-weight: bold;
        }

        .mail-newmail-header-send {
            color: var(--mail-dark-blue);
            transition: 0.2s;
        }

        .mail-newmail-header-send:hover {
            color: var(--mail-blue);
        }

        .mail-newmail-to {
            width: 95.5%;
            height: 2.8vh;
            margin: auto;
            margin-right: 0;
            margin-top: 1vh;
            border-bottom: 1px solid #0000001c;
            color: var(--mail-gray);
            font-size: 1.2vh;
        }

        .mail-newmail-subject {
            width: 95.5%;
            height: 2.8vh;
            margin: auto;
            margin-right: 0;
            margin-top: 0.8vh;
            border-bottom: 1px solid #0000001c;
            color: var(--mail-gray);
            font-size: 1.2vh;
        }

        .mail-newmail-inputs {
            outline: none;
            border-width: 0;
            color: var(--mail-black);
            text-indent: 0.5vh;
            width: 22vh;
        }

        #newmail {
            width: 98%;
            height: 67%;
            outline: none;
            border: none;
            resize: none;
            padding: 1.5vh;
            padding-right: 0.5vh;
        }

        #newmail::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.0);
            border-radius: 1vh;
            background-color: #ffffff00;
        }

        #newmail::-webkit-scrollbar {
            width: 0.5vh;
            background-color: #F5F5F5;
        }

        #newmail::-webkit-scrollbar-thumb {
            border-radius: 1vh;
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
            background-color: #555;
        }
    </style>
    <div class="mail-newmail">
        <div class="mail-newmail-cancel">Cancelar</div>
        <div class="mail-newmail-header">
            <div class="mail-newmail-header-title">Novo Mail</div>
            <div class="mail-newmail-header-send"><i class="fa-solid fa-circle-arrow-up"></i></div>
        </div>

        <div class="mail-newmail-to">Para:<input class="mail-newmail-inputs mail-newmail-recipient" placeholder=""></div>
        <div class="mail-newmail-subject">Assunto:<input class="mail-newmail-inputs mail-newmail-subject-input" placeholder=""></div>

        <textarea name="newmail" id="newmail" cols="50" rows="50" placeholder=""></textarea>
    </div>
`);

//Página login, deixar em ultimo
$('.mail-app').append(/*html*/`
    <style type="text/css">
        .mail-login {
            display: block;
            position: absolute;
            top: 0;
            height: 100%;
            width: 100%;
            background: var(--mail-background);
            overflow: hidden;
            z-index: 105;
            color: var(--mail-dark-gray);
        }

        .mail-login-info {
            position: relative;
            text-align: center;
            font-size: 2vh;
            margin-top: 20vh;
            margin-bottom: 3vh;
        }

        .mail-login-input0 {
            display: none;
            position: relative;
            width: 70%;
            margin: auto;
            height: 3.5vh;
            margin-top: 1.5vh;
        }

        .mail-login-input {
            position: relative;
            width: 70%;
            margin: auto;
            height: 3.5vh;
            margin-top: 1.5vh;
        }

        .mail-login-input2 {
            position: relative;
            width: 70%;
            margin: auto;
            height: 3.5vh;
            margin-top: 0.2vh;
        }

        .mail-login-button {
            position: relative;
            width: 70%;
            color: var(--mail-white-fix);
            height: 3.5vh;
            line-height: 3.5vh;
            text-align: center;
            font-size: 1.2vh;
            margin: 0.5vh auto auto;
            background: var(--mail-blue);
            border-radius: 0.5vh;
            margin-top: 2.5vh;
            transition: 0.25s;
        }

        .mail-login-button:hover {
            background: var(--mail-light-blue);
        }

        .mail-login-register {
            position: relative;
            text-align: center;
            margin-top: 4vh;
            font-size: 1.1vh;
            transition: 0.25s;
            color: var(--mail-dark-gray);
        }

        .mail-login-register:hover {
            color: var(--mail-gray);
        }

        .mail-login-inputs {
            outline: none;
            border-width: 0;
            position: relative;
            width: 100%;
            margin: auto;
            background: var(--mail-white-fix);
            color: var(--mail-black);
            border-radius: 0.5vh;
            height: 100%;
            line-height: 3.5vh;
            text-align: left;
            text-indent: 1vh;
            font-size: 1.2vh;
            border: 1px solid #0000001c;
        }

        .mail-login-password {
            margin-top: 0.5vh;
        }
    </style>
    <div class="mail-login">
        <div class="mail-login-info">Login</div>
        <div class="mail-login-input0"><input class="mail-login-inputs mail-login-realname" placeholder="Nome"></div>
        <div class="mail-login-input"><input class="mail-login-inputs mail-login-name" placeholder="Email"></div>
        <div class="mail-login-input2"><input class="mail-login-inputs mail-login-password" type="password" placeholder="Password"></div>
        <div class="mail-login-button">Entrar</div>

        <div class="mail-login-register">Ainda não tens conta? <b>Registar</b></div>
    </div>
`);

let isRegisteringMail = false;
let loggedInMail = false;
let mailAccountName = '';

$(document).on('click', '.mail-homepage-account', function(e){
    $(".mail-account").addClass("mail-account-show");
    $(".mail-homepage").addClass("mail-homepage-lslide");

    $("#mail-name").text(mailAccountName);
    $("#mail-address").text(localStorage.mail_username);
});

$(document).on('click', '.mail-account-inbox', function(e){
    $(".mail-account").removeClass("mail-account-show");
    $(".mail-homepage").removeClass("mail-homepage-lslide");
});

$(document).on('click', '.mail-account-logout', function(e){
    $(".mail-account").removeClass("mail-account-show");
    $(".mail-homepage").removeClass("mail-homepage-lslide");

    $.post('http://cphone/mail_logout', JSON.stringify({
        username: localStorage.mail_username,
        password: localStorage.mail_password,
    }));

    $(".mail-login").fadeIn(250);
    localStorage.mail_username = "";
    localStorage.mail_password = "";
});

$(document).on("click", ".mail-newmail-header-send", function(e) {
    e.preventDefault();

    let recipient = $('.mail-newmail-recipient').val();
    let subject = $('.mail-newmail-subject-input').val();
    let message = $('#newmail').val();

    $.post('http://cphone/mail_send', JSON.stringify({
        sender: localStorage.mail_username,
        password: localStorage.mail_password,
        to: recipient,
        subject: subject,
        message: message
    }), function(data){
        let mailSent = data.success;

        if (mailSent) {
            $.post('http://cphone/mail_getmails', JSON.stringify({
                username: localStorage.mail_username,
                password: localStorage.mail_password,
            }), function(data){
                populateMails(data.mails);
            });
            $(".mail-newmail").removeClass("mail-newmail-show");
            $('.mail-newmail-recipient').val("");
            $('.mail-newmail-subject-input').val("");
            $('#newmail').val("");
            QB.Phone.Notifications.Add("fa-solid fa-envelope", "Mail", 'Novo Mail',"Mail enviado", "#1DA1F2");
        } else {
            QB.Phone.Notifications.Add("fa-solid fa-envelope", "Mail", 'Novo Mail',"Erro ao enviar mail", "#1DA1F2");
        }
    });
});

$(document).on('click', '.mail-mailinfo-reply', function(e){
    $(".mail-newmail").addClass("mail-newmail-show");

    $('.mail-newmail-recipient').val($(".mail-mailinfo-address").text());
    $('.mail-newmail-subject-input').val($(".mail-mailinfo-subject").text());
});

$(document).on('click', '.mail-homepage-newmail', function(e){
    $(".mail-newmail").addClass("mail-newmail-show");

    $('.mail-newmail-recipient').val("");
    $('.mail-newmail-subject-input').val("");
});

$(document).on('click', '.mail-newmail-cancel', function(e){
    $(".mail-newmail").removeClass("mail-newmail-show");
});

$(document).on('click', '.mail-homepage-mail', function(e){
    let id = $(this).attr("id");
    let mail = $(`#${id}`).data("mail");

    $.post('http://cphone/mail_read', JSON.stringify({
        username: localStorage.mail_username,
        password: localStorage.mail_password,
        id: mail.id
    }));

    $(".mail-mailinfo").addClass("mail-mailinfo-show");
    $(".mail-homepage").addClass("mail-homepage-slide");

    $(".mail-mailinfo-from").text(mail.sender_name.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
    $(".mail-mailinfo-address").text(mail.email.replace(/</g, "&lt;").replace(/>/g, "&gt;"));

    $(".mail-mailinfo-subject").text(mail.subject.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
    $(".mail-mailinfo-message-pre").text(mail.message.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
});

$(document).on('click', '.mail-mailinfo-back', function(e){
    $(".mail-mailinfo").removeClass("mail-mailinfo-show");
    $(".mail-homepage").removeClass("mail-homepage-slide");

    $.post('http://cphone/mail_getmails', JSON.stringify({
        username: localStorage.mail_username,
        password: localStorage.mail_password,
    }), function(data){
        populateMails(data.mails);
    });
});

$(document).on('click', '.mail-login-register', function(e){
    e.preventDefault();

    $('.mail-login-name').val('');
    $('.mail-login-password').val('');
    $('.mail-login-realname').val('');

    if (!isRegisteringMail) {
        isRegisteringMail = true;

        $(".mail-login-info").fadeOut(function() {
            $(this).text("Criar conta")
        }).fadeIn();
    
        $(".mail-login-button").text("Registar");

        $(".mail-login-name").attr("placeholder", "Email (@Sem Destino.pt)");
    
        $(".mail-login-register").fadeOut(function() {
            $(this).html("Já tens conta? <b>Login</b>")
        }).fadeIn();

        $(".mail-login-input0").fadeIn()
    } else {
        isRegisteringMail = false;
        
        $(".mail-login-info").fadeOut(function() {
            $(this).text("Login")
        }).fadeIn();
    
        $(".mail-login-button").text("Entrar");

        $(".mail-login-name").attr("placeholder", "Email");
    
        $(".mail-login-register").fadeOut(function() {
            $(this).html("Ainda não tens conta? <b>Registar</b>")
        }).fadeIn(); 

        $(".mail-login-input0").fadeOut()
    }
});

$(document).on('click', '.mail-login-button', function(e){
    e.preventDefault();

    let username = $('.mail-login-name').val();
    let password = $('.mail-login-password').val();

    if (!isRegisteringMail) {
        $.post('http://cphone/mail_login', JSON.stringify({
            username: username,
            password: password
        }), function(data){
            loggedInMail = data.success;
            mailAccountName = data.name;

            if (loggedInMail) {
                populateMails(data.mails);
                $(".mail-login").fadeOut(200);

                localStorage.mail_username = username;
                localStorage.mail_password = password;
            } else {
                QB.Phone.Notifications.Add("fa-solid fa-envelope", "Mail", 'Conta',"Login inválido!", "#1DA1F2");
            }   
        })
    } else {
        let name = $('.mail-login-realname').val();

        if (username.length < 4) {
            QB.Phone.Notifications.Add("fa-solid fa-envelope", "Mail", 'Conta',"Mínimo 4 caracteres para o nome de utilizador!", "#1DA1F2");
            return false;
        }

        if (name.length < 4) {
            QB.Phone.Notifications.Add("fa-solid fa-envelope", "Mail", 'Conta',"Mínimo 4 caracteres para o nome!", "#1DA1F2");
            return false;
        }

        if (password.length < 6) {
            QB.Phone.Notifications.Add("fa-solid fa-envelope", "Mail", 'Conta',"Mínimo 6 caracteres para a password!", "#1DA1F2");
            return false;
        }

        $.post('http://cphone/mail_register', JSON.stringify({
            username: username,
            password: password,
            name: name
        }), function(data){
            let accountCreated = data.success;

            if (accountCreated) {
                isRegisteringMail = false;
        
                $(".mail-login-info").fadeOut(function() {
                    $(this).text("Login")
                }).fadeIn();
            
                $(".mail-login-button").text("Entrar");
            
                $(".mail-login-register").fadeOut(function() {
                    $(this).html("Ainda não tens conta? <b>Registar</b>")
                }).fadeIn();
        
                $(".mail-login-input0").fadeOut();

                QB.Phone.Notifications.Add("fa-solid fa-envelope", "Mail", 'Conta',"Conta criada, podes agora fazer login!", "#1DA1F2");
            } else {
                QB.Phone.Notifications.Add("fa-solid fa-envelope", "Mail", 'Conta',"Erro ao criar conta!", "#1DA1F2");
            }   
        })
    }
});


function OpenMail() {
    $('.phone-home-button').css({"background-color":"rgba(0, 0, 0, 0.75)"});

    let username = localStorage.mail_username;
    let password = localStorage.mail_password;

    $(".mail-login").show();

    if (username !== undefined && password !== undefined) {
        $.post('http://cphone/mail_login', JSON.stringify({
            username: username,
            password: password
        }), function(data){
            loggedInMail = data.success;
            mailAccountName = data.name;

            if (loggedInMail) {
                populateMails(data.mails);
                $(".mail-login").hide();
            }      
        })    
    }
}


function populateMails(mails) {
    $(".mail-homepage-list").html("");
    $(".mail-homepage-mailcount").text(`${mails.length} Mails`);

    mails.reverse();
        
    $.each(mails, function (index, mail) {
        $(".mail-homepage-list").append(/*html*/`
            <div class="mail-homepage-mail" id="mail-${index}">
                <div class="mail-homepage-mail-header">
                    <div class="mail-homepage-from">${mail.sender_name.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>
                    <div class="mail-homepage-timeago">${timeSince(mail.time)}&nbsp;&nbsp;<i class="fa-solid fa-chevron-right"></i></div>
                </div>
                <div class="mail-homepage-subject">${mail.subject.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>
                <div class="mail-homepage-content">${(mail.message.length > 70) ? mail.message.slice(0, 70-1).replace(/</g, "&lt;").replace(/>/g, "&gt;") : mail.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>
            </div>
        `);

        $(`#mail-${index}`).data('mail', mail);

        if (mail.unread) {
            $(`#mail-${index}`).append(/*html*/`<div class="mail-homepage-unread"></div>`);
        }
    });
}


$(document).ready(function(){
    let username = localStorage.mail_username;
    let password = localStorage.mail_password;

    if (username !== undefined && password !== undefined) {
        $.post('http://cphone/mail_login', JSON.stringify({
            username: username,
            password: password
        }));
    }
});