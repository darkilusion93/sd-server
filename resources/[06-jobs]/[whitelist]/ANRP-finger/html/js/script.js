Scanner = {}
Computer = {}

$(document).ready(function(){
    $('.scanner').hide();
    $('.computer').hide();
    window.addEventListener('message', function(event){
        var eventData = event.data;

        if(eventData.action == "scanner") {
            if (eventData.toggle) {
                Scanner.Open()
            }
        }

        if(eventData.action =="computer") {
            $('.scanner').hide();
			//console.log(eventData.data.)
            Computer.Open(eventData.details)
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Scanner.Close()
            Computer.Close()
            break;
        case 9: // ESC
            Scanner.Close()
            Computer.Close()
            break;
    }
});

Scanner.Open = function() {
    $('.scanner').fadeIn(250);
    document.getElementById('s-content').style.display = "none";
}

Scanner.Close = function() {
    $('.scanner').fadeOut(250);
    $.post('http://ANRP-finger/scanner-exit');
}

var tId = 0;

$('#finger-input').mousedown(function() {
    console.log('SCAN EM PROGRESSO, AGUARDE 5 SEGUNDOS');
    tId = setTimeout(Fetch , 5000 );
    return false;
});

$('#finger-input').mouseup(function() {
    clearTimeout(tId);
})

Fetch = function() {
    $.post('http://ANRP-finger/details', JSON.stringify({}), function(data){
        document.getElementById('s-content').style.display = "block";
        Scanner.details(data);
    });
}

Scanner.details = function(data) {
    var firstname = document.getElementById("firstname-s");
    var lastname = document.getElementById("lastname-s");
    var dob = document.getElementById("dob-s");
    var account = document.getElementById("account-s");
    var phone = document.getElementById("phone-s");

    firstname.innerHTML = data.firstname;
    lastname.innerHTML = data.lastname;
    dob.innerHTML = data.dob;
    account.innerHTML = data.account;
    phone.innerHTML = data.phone;
}

Scanner.details2 = function(data) {
    var firstname = document.getElementById("firstname-s");
    var lastname = document.getElementById("lastname-s");
    var dob = document.getElementById("dob-s");
    var account = document.getElementById("account-s");
    var phone = document.getElementById("phone-s");

    firstname.innerHTML = data.firstname;
    lastname.innerHTML = data.lastname;
    dob.innerHTML = data.dob;
    account.innerHTML = data.account;
    phone.innerHTML = data.phone;
}

///////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

Computer.Open = function(data) {
    document.getElementById('c-content').style.display = "none";

    Computer.details(data);
    $('.computer').fadeIn(250);
    document.getElementById('c-content').style.display = "block";
}

Computer.details = function(data) {
    var firstname = document.getElementById("firstname-c");
    var lastname = document.getElementById("lastname-c");
    var dob = document.getElementById("dob-c");
    var account = document.getElementById("account-c");
    var phone = document.getElementById("phone-c");


    firstname.innerHTML = data.firstname;
    lastname.innerHTML = data.lastname;
    dob.innerHTML = data.dob;
    account.innerHTML = data.account;
    phone.innerHTML = data.phone;
}

Computer.Close = function() {
    $('.computer').fadeOut(250);
    $.post('http://ANRP-finger/computer-exit');
}