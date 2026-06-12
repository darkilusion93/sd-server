let Adverts = {}

$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .advert-app {
            display: none;
            height: 100%;
            width: 100%;
            background: #f2f2f2;
            overflow: hidden;
        }

        .advert-header {
            position: relative;
            width: 100%;
            height: 10vh;
            top: 0;
        }

        #advert-header-text {
            position: absolute;
            top: 5vh;
            left: 2vh;
            font-family: 'Helvetica';
            font-size: 1.8vh;
            color: black;
        }

        #advert-header-name {
            position: absolute;
            top: 8vh;
            left: 2vh;
            font-family: 'Helvetica';
            font-size: 1.4vh;
            color: rgba(26, 26, 26, 0.842);
        }

        #new-advert-header-name {
            position: absolute;
            top: 8vh;
            left: 2vh;
            font-family: 'Helvetica';
            font-size: 1.4vh;
            color: rgba(26, 26, 26, 0.842);
        }

        .advert-list {
            position: relative;
            width: 100%;
            background-color: rgb(255 255 255);
            height: 44.5vh;
            margin-top: 1vh;
            overflow-x: hidden !important;
            overflow-y: scroll;
            border-bottom: 1px solid #0000001c;
            border-top: 1px solid #0000001c;
        }

        .advert-list::-webkit-scrollbar {
            display: none;
        }
        .advert {
            position: relative;
            background-color: #ff8f1a;
            color: white;
            height: auto;
            min-height: 3.5vh;
            width: 92%;
            transition: .05s ease-in-out, height 0.2s;
            margin: 0 auto;
            margin-top: 1vh;
            margin-bottom: 1vh;
            border-radius: 0.5vh;
            text-align: center;
        }

        .advert:hover {
            background-color: #ff8200;
        }

        .advert > p {
            margin: auto;
            margin-top: 1.5vh;
            padding-bottom: 1vh;
            font-family: 'Helvetica';
            max-width: 25vh;
        }

        .business-advert {
            position: relative;
            height: auto;
            min-height: 3.5vh;
            width: 92%;
            transition: .05s ease-in-out, height 0.2s;
            margin: 0 auto;
            margin-top: 1vh;
            margin-bottom: 1vh;
            border-radius: 0.5vh;
            text-align: center;
        }

        .business-advert > p {
            margin: auto;
            margin-top: 1.5vh;
            padding-bottom: 1vh;
            font-family: 'Helvetica';
            max-width: 25vh;
        }

        .advert-sender {
            position: relative;
            top: .8vh;
            font-family: 'Samsung Sans Bold';
            font-size: 1.3vh;
        }

        .new-advert {
            position: absolute;
            display: block;
            height: 100%;
            width: 100%;
            top: 0;
            background: #f2f2f2;
            overflow: hidden;
            left: -30vh;
        }

        .new-advert-footer {
            display: flex;
            justify-content: space-around;
            margin-top: 0.4vh;    
        }

        .new-advert-footer-item {
            position: relative;
            float: left;
            width: 50%;
            height: 100%;
            background-color: rgb(234, 234, 234);
            text-align: center;
            line-height: 5vh;
            font-size: 2.2vh;
            transition: .1s linear;
            color: rgb(48, 48, 48);
        }

        .new-advert-footer-item:hover {
            background-color: rgb(214, 214, 214);
            transition: .1s linear;
        }

        .new-advert-footer-item:hover .new-advert-icon {
            color: rgb(32, 32, 32);
            animation: Shake 1s infinite;
        }

        .new-advert-header {
            position: relative;
            width: 100%;
            height: 10vh;
            top: 0;
        }

        #new-advert-header-text {
            position: absolute;
            top: 5vh;
            left: 2vh;
            font-family: 'Helvetica';
            font-size: 1.8vh;
            color: black;
        }

        .new-advert-textarea {
            position: relative;
            height: 39.5vh;
            width: 100%;
            outline: none;
            border: none;
            resize: none;
            padding: 1.5vh;
            margin-top: 1vh;
            border-bottom: 1px solid #0000001c;
            border-top: 1px solid #0000001c;
        }

        .new-advert-image {
            width: 100%;
            height: 5vh;
            display: flex;
            justify-content: space-between;
            padding-left: 8%;
            padding-right: 8%;
        }

        .new-advert-image-add {
            height: 100%;
            width: 20%;
            background: #d7d7d79c;
            border-radius: 0.5vh;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: 0.2s;
        }

        .new-advert-image-add:hover {
            background: #c0c0c09c;
        }

        .new-advert-image-add:active {
            background: #f5f5f59c;
        }

        .new-advert-image-add-icon {
            width: 55%;
            height: 50%;
            fill: #343434;
        }

        .new-advert-image-preview {
            height: 100%;
            width: 78%;
            background: #d7d7d79c;
            border-radius: 0.5vh;
        }

        .new-advert-image-preview:hover img {
            opacity: 0.7;
        }

        .new-advert-image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 0.5vh;
            opacity: 1;
            transition: 0.2s;
        }

        .advert-home {
            position: relative;
            left: 0;
        }

        .advert-header-post {
            color: #323232;
            position: absolute;
            right: 1vh;
            top: 7.8vh;
            font-size: 1.3vh;
            background: #d7d7d79c;
            width: 4.5vh;
            text-align: center;
            height: 2.2vh;
            line-height: 2.3vh;
            border-radius: 0.5vh;
            transition: 0.2s;
        }

        .advert-header-post:hover {
            background: #afafaf9c;
        }

        .advert-header-post:active {
            background: #d7d7d79c;
        }

        .advert-footer {
            display: grid;
            grid-auto-flow: column;
            grid-auto-columns: 1fr;
            height: 3.1vh;
            width: 24.8vh;
            align-items: center;
            margin: auto;
            margin-top: 1vh;
            border-radius: 0.5vh;
            background: rgb(224 224 227);
        }

        .advert-footer-button {
            color: #484848;
            right: 1vh;
            top: 7.8vh;
            font-size: 1.3vh;
            background: #d7d7d700;
            width: 12vh;
            text-align: center;
            height: 2.6vh;
            line-height: 2.6vh;
            border-radius: 0.5vh;
            transition: 0.2s;
            z-index: 2;
            font-weight: normal;
        }

        .advert-footer-button:hover {
            color: #6a6969;
        }

        .advert-footer-button:active {
            color: #484848;
        }

        .new-advert-footer-button {
            color: #484848;
            right: 1vh;
            top: 7.8vh;
            font-size: 1.3vh;
            background: #d7d7d79c;
            width: 8vh;
            text-align: center;
            height: 2.6vh;
            line-height: 2.6vh;
            border-radius: 0.5vh;
            transition: 0.2s;
        }

        .new-advert-footer-button:hover {
            background: #afafaf9c;
        }

        .new-advert-footer-button:active {
            background: #d7d7d79c;
        }

        .advert-footer-personal {
            margin-left: 0.3vh;
            grid-column: 1;
            grid-row: 1;
        }

        /*.advert-footer-business {
            
        }*/

        .new-advert-footer-cancel {
            margin-left: 2vh;
        }

        .new-advert-footer-personal {
            margin-right: 2vh;
        }

        .advert-footer-selection {
            background: rgb(255 255 255);
            border: 0.5px solid rgba(0,0,0,0.04);
            box-shadow: 0 3px 8px 0 rgb(0 0 0 / 12%), 0 3px 1px 0 rgb(0 0 0 / 4%);
            border-radius: 7px;
            grid-column: 1;
            grid-row: 1;
            height: 2.6vh;
            width: 12vh;
            will-change: transform;
            margin-left: 0.3vh;
            transition: transform .2s ease;
        }

        .advert-bold-text {
            font-weight: bold;
            color: #484848;
        }

        .advert-bold-text:hover {
            color: #484848;
        }

        .advert-gallery {
            position: absolute;
            display: block;
            height: 100%;
            width: 100%;
            top: 0;
            background: #f2f2f2;
            overflow: hidden;
            left: -30vh;
        }

        .advert-gallery-back {
            color: #007eff;
            height: 11%;
            line-height: 11vh;
            text-indent: 0.8vh;
            font-size: 1.8vh;
            transition: 0.2s;
        }

        .advert-gallery-images {
            width: 100%;
            height: 86%;
            float: right;
            overflow-y: scroll;
            overflow-x: hidden;
            padding: 2%;
        }

        .advert-gallery-images::-webkit-scrollbar {
            display: none;
        }

        .advert-gallery-item {
            width: 6.6vh;
            height: 6.6vh;
            background: #000000;
            float: left;
            margin: 0.18vh;
        }

        .advert-gallery-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .advert-image {
            width: 100%;
            height: 14vh;
            padding: 2%;
        }

        .advert-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 0.3vh;
        }

    </style>
    <div class="advert-app">
        <div class="advert-home">
            <div class="advert-header">
                <span id="advert-header-text">Anúncios</span>
                <span id="advert-header-name"></span>
                <span class="advert-header-post"><i class="fa fa-plus" aria-hidden="true"></i></span>
            </div>

            <div class="advert-list">
                <!-- <div class="advert">
                    <span class="advert-sender">@JayNandes | 0612345678</span>
                    <p>Dit is een test advert Dit is een test advert Dit is een test advert Dit is een test advert Dit is een test advert</p>
                </div> -->
            </div>
            <div class="advert-footer">
                <span class="advert-footer-selection" style="transform: translateX(0px);"></span>
                <div class="advert-footer-personal advert-footer-button">Particular</div>
                <div class="advert-footer-business advert-footer-button">Empresas</div>
            </div>
        </div>

        <div class="new-advert">
            <div class="new-advert-header">
                <span id="new-advert-header-text">Publicar anúncio</span>
                <span id="new-advert-header-name">2.500€ Particular | 0€ Empresa</span>
            </div>

            <textarea class="new-advert-textarea" spellcheck="false" placeholder="Escreve aqui o anúncio..." required></textarea>

            <div class="new-advert-image">
                <div class="new-advert-image-preview">

                </div>
                <div class="new-advert-image-add">
                    <div class="new-advert-image-add-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.--><path d="M213.1 128.8L202.7 160L128 160C92.7 160 64 188.7 64 224L64 480C64 515.3 92.7 544 128 544L512 544C547.3 544 576 515.3 576 480L576 224C576 188.7 547.3 160 512 160L437.3 160L426.9 128.8C420.4 109.2 402.1 96 381.4 96L258.6 96C237.9 96 219.6 109.2 213.1 128.8zM320 256C373 256 416 299 416 352C416 405 373 448 320 448C267 448 224 405 224 352C224 299 267 256 320 256z"/></svg></div>
                </div>
            </div>

            <div class="new-advert-footer">
                <div class="new-advert-footer-cancel new-advert-footer-button">Cancelar</div>
                <div class="new-advert-footer-business new-advert-footer-button">Empresa</div>
                <div class="new-advert-footer-personal new-advert-footer-button">Particular</div>
            </div>
        </div>

        <div class="advert-gallery">
            <div class="advert-gallery-back"><i class="fa-solid fa-chevron-left" aria-hidden="true"></i></div>
            <div class="advert-gallery-images"></div>
        </div>
    </div>
`);

let currentAdvertImage = null;

$(document).on('click', '.advert-header-post', function(e){
    e.preventDefault();

    $(".advert-home").animate({
        left: 30+"vh"
    }, 150);
    $(".new-advert").animate({
        left: 0+"vh"
    }, 150);
});

$(document).on('click', '.new-advert-footer-cancel', function(e){
    e.preventDefault();

    $(".advert-home").animate({
        left: 0+"vh"
    }, 150);
    $(".new-advert").animate({
        left: -30+"vh"
    }, 150);
});

$(document).on('click', '.new-advert-footer-personal', function(e){
    e.preventDefault();

    var Advert = $(".new-advert-textarea").val();

    $(".new-advert-textarea").val('');

    if (Advert !== "") {
        $(".advert-home").animate({
            left: 0+"vh"
        });
        $(".new-advert").animate({
            left: -30+"vh"
        });
        $.post('http://cphone/PostAdvert', JSON.stringify({
            message: Advert,
            image: currentAdvertImage,
            type: 'personal'
        }));

        currentAdvertImage = null;
        $(".new-advert-image-preview").html("");
    } else {
        QB.Phone.Notifications.Add("fas fa-ad", "Anúncios", "Erro", "Não podes fazer um post em branco!","#ff8f1a", 2000);
    }
});

$(document).on('click', '.new-advert-footer-business', function(e){
    e.preventDefault();

    var Advert = $(".new-advert-textarea").val();

    $(".new-advert-textarea").val('');

    if (Advert !== "") {
        $(".advert-home").animate({
            left: 0+"vh"
        });
        $(".new-advert").animate({
            left: -30+"vh"
        });
        $.post('http://cphone/PostAdvert', JSON.stringify({
            message: Advert,
            image: currentAdvertImage,
            type: 'business'
        }));

        currentAdvertImage = null;
        $(".new-advert-image-preview").html("");
    } else {
        QB.Phone.Notifications.Add("fas fa-ad", "Anúncios", "Erro", "Não podes fazer um post em branco!","#ff8f1a", 2000);
    }
});

QB.Phone.Functions.RefreshAdverts = function(AdvertsList) {
    Adverts = AdvertsList.reverse();
    $("#advert-header-name").html("@"+QB.Phone.Data.PlayerData.firstName+""+QB.Phone.Data.PlayerData.lastName+" | "+myPhoneNumber);

    let advertCount = 0;

    $(".advert-footer-selection").css('transform', 'translateX(0vh)');
    $(".advert-footer-business").removeClass("advert-bold-text");
    $(".advert-footer-personal").addClass("advert-bold-text");
    
    if (Adverts.length > 0 || Adverts.length == undefined) {
        $(".advert-list").html("");
        $.each(Adverts, function(i, advert){
            if (advert.type === 'personal') {
                var element = /*html*/`
                    <div class="advert" id="${advert.number}">
                        <span class="advert-sender">${advert.name.replace(/</g, "&lt;").replace(/>/g, "&gt;")} | ${advert.number}</span>
                        <p>${advert.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</p>
                        ${advert.image ? /*html*/`<div class="advert-image"><img src="${advert.image}" class="advert-image-img"></div>` : ''}
                    </div>`;

                $(".advert-list").append(element);
                advertCount++;
            }
        });

        if (advertCount === 0) {
            var element = '<div class="advert"><span class="advert-sender">Ninguém publicou anúncios!</span></div>';
            $(".advert-list").append(element);
        }
    } else {
        $(".advert-list").html("");
        var element = '<div class="advert"><span class="advert-sender">Ninguém publicou anúncios!</span></div>';
        $(".advert-list").append(element);
    }
}

$(document).on('click', '.advert', function(e){
    let copyText = this.id

    if (copyText === null || copyText === undefined || copyText === '') {return false;}

    copyStringToClipboard(copyText);

    QB.Phone.Notifications.Add("fas fa-ad", "Anúncios", "Informações de contacto", "Número copiado!", "#ff8f1a", 2000);
});

function setupAdvertGallery(data) {
    $('.advert-gallery-images').html('');

    $.each(data, function(i, element){
        if (element.type === 'photo') {
            $('.advert-gallery-images').append(/*html*/`<div class="advert-gallery-item">
                <img src="${element.link}?width=64&height=64" id="${element.link}" class="advert-gallery-image">
            </div>`);
        }

        //if (element.type === 'video') {
        //    $('.gallery-content').append(/*html*/`<div class="gallery-item">
        //        <div class="gallery-video-icon"><i class="fa-solid fa-video"></i></div>
        //        <video src="${element.link}" id="${element.link}" class="gallery-item-video"></video>
        //    </div>`);
        //}
    });
}

$(document).on('click', '.new-advert-image-add', function(e){
    $(".advert-gallery").animate({
        left: "0vh"
    }, 150);

    let currentGalleryPage = 1;

    $.post('http://cphone/getGalleryPage', JSON.stringify({page: currentGalleryPage}), function(data){
        setupAdvertGallery(data);
    });
});

$(document).on('click', '.advert-gallery-back', function(e){
    $(".advert-gallery").animate({
        left: "-30vh"
    }, 150);
});

$(document).on('click', '.advert-gallery-image', function(e){
    let imageSrc = this.id;
    currentAdvertImage = imageSrc;
    $(".new-advert-image-preview").html('<img src="'+imageSrc+'">');
        $(".advert-gallery").animate({
        left: "-30vh"
    }, 150);
});

$(document).on('click', '.new-advert-image-preview', function(e){
    $(".new-advert-image-preview").html('');
    currentAdvertImage = null;
});

$(document).on('click', '.advert-footer-personal', function(e){
    let advertCount = 0;
    $(".advert-list").html("");

    $(".advert-footer-selection").css('transform', 'translateX(0vh)');
    $(".advert-footer-business").removeClass("advert-bold-text");
    $(".advert-footer-personal").addClass("advert-bold-text");

    $.each(Adverts, function(i, advert){
        if (advert.type === 'personal') {
            var element = /*html*/`
                <div class="advert" id="${advert.number}">
                    <span class="advert-sender">${advert.name.replace(/</g, "&lt;").replace(/>/g, "&gt;")} | ${advert.number}</span>
                    <p>${advert.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</p>
                    ${advert.image ? /*html*/`<div class="advert-image"><img src="${advert.image}" class="advert-image-img"></div>` : ''}
                </div>`;

            $(".advert-list").append(element);
            advertCount++;
        }
    });

    if (advertCount === 0) {
        var element = '<div class="advert"><span class="advert-sender">Ninguém publicou anúncios!</span></div>';
        $(".advert-list").append(element);
    }
});

$(document).on('click', '.advert-footer-business', function(e){
    let advertCount = 0;
    $(".advert-list").html("");

    $(".advert-footer-selection").css('transform', 'translateX(12.3vh)');
    $(".advert-footer-business").addClass("advert-bold-text");
    $(".advert-footer-personal").removeClass("advert-bold-text");

    $.each(Adverts, function(i, advert){
        if (advert.type === 'business') {
            var element = /*html*/`
                <div class="business-advert" style="background:${advert.color};color: ${advert.textcolor};" id="${advert.number}">
                    <span class="advert-sender">${advert.name.replace(/</g, "&lt;").replace(/>/g, "&gt;")} | ${advert.number}</span>
                    <p>${advert.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</p>
                    ${advert.image ? /*html*/`<div class="advert-image"><img src="${advert.image}" class="advert-image-img"></div>` : ''}
                </div>`;

            $(".advert-list").append(element);
            advertCount++;
        }
    });

    if (advertCount === 0) {
        var element = '<div class="advert"><span class="advert-sender">Nenhuma empresa publicou anúncios!</span></div>';
        $(".advert-list").append(element);
    }
});

$(document).on('click', '.advert-image-img', function(e){
    let src = $(this).attr('src')

    viewFullScreenImage(src);
});

function copyStringToClipboard (str) {
    // Create new element
    var el = document.createElement('textarea');
    // Set value (string to be copied)
    el.value = str;
    // Set non-editable to avoid focus and move outside of view
    el.setAttribute('readonly', '');
    el.style = {position: 'absolute', left: '-9999px'};
    document.body.appendChild(el);
    // Select text inside element
    el.select();
    // Copy text to clipboard
    document.execCommand('copy');
    // Remove temporary element
    document.body.removeChild(el);
}