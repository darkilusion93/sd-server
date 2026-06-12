let cData = {}

SetupLawyers = function(data) {
    $(".lawyers-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, lawyer){
            var element = '<div class="lawyer-list" id="lawyerid-'+i+'"> <div class="lawyer-list-firstletter">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="lawyer-list-fullname">' + lawyer.name + '</div> <div class="lawyer-list-call"><i class="fas fa-bell"></i></div> </div>'
            $(".lawyers-list").append(element);
            $("#lawyerid-"+i).data('LawyerData', lawyer);
        });
    } else {
        var element = '<div class="lawyer-list"><div class="no-lawyers">Não há serviços disponiveis.</div></div>'
        $(".lawyers-list").append(element);
    }
}

let disableSend = false;

$(document).on('click', '.lawyer-list-call', function(e){
    e.preventDefault();

    $(".new-lawyers-contentarea").html("");
    disableSend = false;

    var LawyerData = $(this).parent().data('LawyerData');
    
    cData = {
        number: LawyerData.phone,
        name: LawyerData.name
    }

    if (LawyerData.numbers) {
        disableSend = true;

        for (let i = 0; i < LawyerData.numbers.length; i++) {
            let number = LawyerData.numbers[i];

            $(".new-lawyers-contentarea").append(/*html*/`
                <div class="new-lawyers-number" data-number="${number}">
                <div class="lawyer-list-firstletter">${i}</div>${number}</div>`);
        }

        $(".new-lawyers").animate({
            left: 0+"vh"
        });
        return;
    }

    $(".new-lawyers-contentarea").html(/*html*/`<textarea class="new-lawyers-textarea" spellcheck="false" required></textarea>`);

    $(".new-lawyers").animate({
        left: 0+"vh"
    });
});

$(document).on('click', '#new-lawyers-back', function(e){
    e.preventDefault();

    $(".new-lawyers").animate({
        left: -30+"vh"
    });
});

$(document).on('click', '.new-lawyers-number', function(e){
    e.preventDefault();

    let number = $(this).data("number");

    copyStringToClipboard(number);
    QB.Phone.Notifications.Add("fas fa-user-tie", "Serviços", 'Número', "Número copiado", "#3d87ff", 1750);
});


$(document).on('click', '#new-lawyers-submit', function(e){
    e.preventDefault();

    if (disableSend) {
        QB.Phone.Notifications.Add("fas fa-user-tie", "Serviços", 'Pedidos', "Copia um número e envia mensagem!", "#3d87ff", 1750);
        return;
    }

    let message = $(".new-lawyers-textarea").val();
    
    let fData = {
        number: cData.number,
        name: cData.name,
        message: message
    }


    $.post('http://cphone/SendHelpMessage', JSON.stringify({
        ContactData: fData,
    }), function(success){
        if (success) {
            $(".new-lawyers").animate({
                left: -30+"vh"
            });
        }
    });
});