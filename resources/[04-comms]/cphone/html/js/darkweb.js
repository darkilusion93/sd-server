// DarkWeb JS

$(document).on('click', '.test-slet-darkweb', function(e){
    e.preventDefault();

    $(".darkweb-home").animate({
        left: 30+"vh"
    });
    $(".new-darkweb").animate({
        left: 0+"vh"
    });
});

$(document).on('click', '#new-darkweb-back', function(e){
    e.preventDefault();

    $(".darkweb-home").animate({
        left: 0+"vh"
    });
    $(".new-darkweb").animate({
        left: -30+"vh"
    });
});

$(document).on('click', '#new-darkweb-submit', function(e){
    e.preventDefault();

    var Advert = $(".new-darkweb-textarea").val();

    if (Advert !== "") {
        $(".darkweb-home").animate({
            left: 0+"vh"
        });
        $(".new-darkweb").animate({
            left: -30+"vh"
        });
        $.post('http://cphone/PostDarkweb', JSON.stringify({
            message: Advert,
        }));
    } else {
        QB.Phone.Notifications.Add("fas fa-skull-crossbones", "Dark-web", 'Publicação', "Não podes fazer um post em branco!", "#010101", 2000);
    }
});

QB.Phone.Functions.RefreshDarkweb = function(DarkwebList) {
    let Adverts = DarkwebList.reverse();
    $("#darkweb-header-name").html("@Anónimo");
    if (Adverts.length > 0 || Adverts.length == undefined) {
        $(".darkweb-list").html("");
        $.each(Adverts, function(i, advert){
            var element = '<div class="darkweb" id="'+advert.number+'"><span class="darkweb-sender">@Anónimo</span><p>'+advert.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")+'</p></div>';
            $(".darkweb-list").append(element);
        });
    } else {
        $(".darkweb-list").html("");
        var element = '<div class="darkweb"><span class="darkweb-sender">Ninguém publicou anúncios!</span></div>';
        $(".darkweb-list").append(element);
    }
}