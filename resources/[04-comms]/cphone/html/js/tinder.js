QB.Phone.Functions.DoTinderOpen = function() {
    $(".tinder-app-loaded").css({"display":"none", "padding-left":"30vh"});
    $(".tinder-logo").css({"left": "0vh"});
    $("#tinder-text").css({"opacity":"0.0", "left":"9vh"});
    $(".tinder-app-loading").css({
        "display":"block",
        "left":"0vh",
    });
    setTimeout(function(){
        CurrentTab = "accounts";
        $(".tinder-logo").animate({
            left: -12+"vh"
        }, 500);
        setTimeout(function(){
            $("#tinder-text").animate({
                opacity: 1.0,
                left: 14+"vh"
            });
        }, 100);
        setTimeout(function(){
            $(".tinder-app-loaded").css({"display":"block"}).animate({"padding-left":"0"}, 300);
            //$(".tinder-app-accounts").animate({left:0+"vh"}, 300);
            $(".tinder-app-loading").animate({
                left: -30+"vh"
            },300, function(){
                $(".tinder-app-loading").css({"display":"none"});
            });
        }, 1500)
    }, 500)
}


$(document).on('click', '#tinder-create-post', function(e){
    e.preventDefault();

    //$(".tinder-app-create-post").css({"display":"block"});
    $(".tinder-app-create-post").animate({
        left: 0
    },300, function(){
        
    });
});

$(document).on('click', '#tinder-cancel-post', function(e){
    e.preventDefault();

    //$(".tinder-app-create-post").css({"display":"block"});
    $(".tinder-app-create-post").animate({
        left: -30+'vh'
    },300, function(){
        
    });
});

$(document).on('click', '.tinder-create-post-accept', function(e){
    e.preventDefault();

    let description = $(".new-tinder-textarea").val();
    let picture = $(".tinder-picture-input").val();

    if (description !== "" && picture !== "") {
        $.post('http://cphone/PostTinder', JSON.stringify({
            Description: description,
            Picture: picture
        }));
    
        //console.log('Publicar tinder');
        $(".tinder-app-create-post").animate({
            left: -30+'vh'
        },300, function(){
            
        });
    } else {
        QB.Phone.Notifications.Add("fas fa-fire", "Dates", "Não podes fazer um post em branco!", "#ff002b", 2000);
    }
});

let tinderPosts = {};
let tinderIndex = 0;
let tinderMaxIndex = 0;

QB.Phone.Functions.RefreshTinder = function(Tinder) {
    let i = 0;
    $.each(Tinder, function (index, posts) {
        tinderPosts[i++] = posts;
    });

    tinderMaxIndex = i;

    $(".tinder-app-box").html("");

    if (i == 0) {
        $(".tinder-app-box").append('<span id="tinder-text-profile">Estranhamente vazio.</span>');
    } else {
        let post = tinderPosts[tinderIndex];

        $(".tinder-app-box").append('<span class="tinder-picture-profile"><img src="'+ post.picture.replace(/</g, "&lt;").replace(/>/g, "&gt;") +'"></img></span>');
        $(".tinder-app-box").append('<span id="tinder-text-profile">'+ post.name.replace(/</g, "&lt;").replace(/>/g, "&gt;") +'</span>');
        $(".tinder-app-box").append('<span id="tinder-message-profile">'+ post.message.replace(/</g, "&lt;").replace(/>/g, "&gt;") +'</span>');
    }
}

$("#tinder-love").click(function() {
    if (tinderPosts == {} || tinderMaxIndex == 0) {
        return;
    }

    QB.Phone.Notifications.Add("fas fa-fire", "Dates", "Número do teu match copiado! Envia-lhe uma mensagem.", "#ff002b", 2000);

    copyStringToClipboard(tinderPosts[tinderIndex].number);
});

$("#tinder-pass").click(function() {
    if (tinderPosts == {} || tinderMaxIndex == 0) {
        return;
    }

    if (tinderIndex < tinderMaxIndex - 1) {
        tinderIndex++;
    } else {
        if (tinderIndex == tinderMaxIndex - 1) {
            tinderIndex = 0;
        }
    }

    //console.log('Tinder -> '+tinderIndex);

    $(".tinder-app-box").html("");

    if (tinderMaxIndex == 0) {
        $(".tinder-app-box").append('<span id="tinder-text-profile">Estranhamente vazio.</span>');
    } else {
        let post = tinderPosts[tinderIndex];

        $(".tinder-app-box").append('<span class="tinder-picture-profile"><img src="'+ post.picture.replace(/</g, "&lt;").replace(/>/g, "&gt;") +'"></img></span>');
        $(".tinder-app-box").append('<span id="tinder-text-profile">'+ post.name.replace(/</g, "&lt;").replace(/>/g, "&gt;") +'</span>');
        $(".tinder-app-box").append('<span id="tinder-message-profile">'+ post.message.replace(/</g, "&lt;").replace(/>/g, "&gt;") +'</span>');
    }
});