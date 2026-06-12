let controlsHidden = false;

$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .gallery-app {
            display: none;
            height: 100%;
            width: 100%;
            background: #000000;
            overflow: hidden;
        }
    </style>
    <div class="gallery-app"></div>
`);


$('.gallery-app').append(/*html*/`
    <style type="text/css">
        .gallery-header {
            position: absolute;
            width: fit-content;
            height: fit-content;
            color: white;
            font-size: 2vh;
            margin-top: 5vh;
            margin-left: 2vh;
        }

        .gallery-content {
            position: absolute;
            width: 96%;
            margin-left: 0.65vh;
            height: 89%;
            top: 0;
            float: right;
            overflow-y: scroll;
            overflow-x: hidden;
        }

        .gallery-content::-webkit-scrollbar {
            display: none;
        }

        .gallery-footer {
            position: absolute;
            bottom: 0;
            height: 6.8vh;
            width: 100%;
            background: #1717179e;
            backdrop-filter: blur(10px);
            color: white;
            font-size: 2.2vh;
            display: flex;
            justify-content: space-between;
        }

        .gallery-footer-item1 {
            margin-left: 4vh; 
            margin-top: 0.4vh;
            color: #0099ff;
        }

        .gallery-footer-item2 {
            margin-top: 0.4vh;
        }

        .gallery-footer-item3 {
            margin-right: 4vh;
            margin-top: 0.4vh;
        }

        .gallery-footer-desc {
            font-size: 0.9vh;
            line-height: 0.5vh;
            text-align: center;
        }

        .gallery-item {
            width: 6.6vh;
            height: 6.6vh;
            background: #000000;
            float: left;
            margin: 0.18vh;
        }

        .gallery-item-footer {
            width: 100%;
            height: 9vh;
            float: right;
        }

        .gallery-item-header {
            width: 100%;
            height: 8.8vh;
            float: right;
        }
        
        .gallery-item-photo {
            width: 100%;
            height: 100%;
            object-fit: cover; 
        }

        .gallery-item-video {
            width: 100%;
            height: 100%;
            object-fit: cover; 
        }
    </style>
    <div class="gallery-content"></div>
    <div class="gallery-header">Recentes</div>
    <div class="gallery-footer">
        <span class="gallery-footer-item1"><i class="fa-thin fa-photo-film"></i><div class="gallery-footer-desc">Galeria</div></span>
        <span class="gallery-footer-item2"><i class="fa-thin fa-cloud"></i><div class="gallery-footer-desc">Cloud</div></span>
        <span class="gallery-footer-item3"><i class="fa-thin fa-rectangle-history"></i><div class="gallery-footer-desc">Álbuns</div></span>
    </div>
`);


$('.gallery-app').append(/*html*/`
    <style type="text/css">
        .gallery-viewer {
            display: none;
            position: absolute;
            height: 100%;
            width: 100%;
            background: #000000;
            overflow: hidden; 
        }

        .gallery-viewer-header {
            width: 100%;
            height: 7vh;
            background: #131313;
            backdrop-filter: blur(10px);
            position: absolute;
        }

        .gallery-back {
            color: #007eff;
            height: 100%;
            line-height: 11vh;
            text-indent: 0.8vh;
            font-size: 1.8vh;
            transition: 0.2s;
        }

        .gallery-back:hover {
            color: #77baff;
        }

        .gallery-viewer-content {
            width: 100%;
            height: 100%;
            position: absolute;
        }
        
        .gallery-viewer-footer {
            display: flex;
            justify-content: space-between;
            font-size: 2vh;
            color: #007eff;
            height: 6vh;
            width: 100%;
            background: #131313;
            position: absolute;
            bottom: 0;
        }

        .gallery-share {
            margin-left: 2vh;
            margin-top: 0.5vh;
            transition: 0.2s;
        }

        .gallery-share:hover {
            color: #77baff;
        }

        .gallery-delete {
            margin-right: 2vh;
            margin-top: 0.5vh;
            transition: 0.2s;
        }

        .gallery-delete:hover {
            color: #77baff;
        }

        .gallery-viewer-content > img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .gallery-viewer-content > video {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .gallery-video-icon {
            position: absolute;
            color: white;
            margin-left: 0.3vh;
            font-size: 1vh;
        }

        .gallery-viewer-delete {
            display: block;
            position: absolute;
            top: 65vh;
            width: 100%;
            height: fit-content;
            transition: top 0.3s;
        }

        .gallery-viewer-delete-display {
            top: 50vh;
        }

        .gallery-viewer-delete-accept {
            margin: auto;
            width: 94%;
            height: 4vh;
            border-radius: 1vh;
            background: #36363694;
            color: #f33626;
            line-height: 4vh;
            text-align: center;
            font-size: 1.4vh;
            backdrop-filter: blur(12px);
            transition: background 0.3s;
        }

        .gallery-viewer-delete-accept:hover {
            background: #58585894;
        }

        .gallery-viewer-delete-accept:active {
            background: #a5a4a494;
        }

        .gallery-viewer-delete-cancel {
            margin: auto;
            margin-top: 1vh;
            width: 94%;
            height: 4vh;
            border-radius: 1vh;
            background: #36363694;
            color: #007eff;
            line-height: 4vh;
            text-align: center;
            font-weight: bold;
            font-size: 1.4vh;
            backdrop-filter: blur(12px);
            transition: background 0.3s;
        }

        .gallery-viewer-delete-cancel:hover {
            background: #58585894;
        }

        .gallery-viewer-delete-cancel:active {
            background: #a5a4a494;
        }
    </style>
    <div class="gallery-viewer">
        <div class="gallery-viewer-content"></div>
        <div class="gallery-viewer-header">
            <div class="gallery-back"><i class="fa-solid fa-chevron-left"></i></div>
        </div>
        <div class="gallery-viewer-footer">
            <span class="gallery-share"><i class="fa-light fa-arrow-up-from-square"></i></span>
            <span class="gallery-delete"><i class="fa-light fa-trash-can"></i></span>
        </div>

        <div class="gallery-viewer-delete">
            <div class="gallery-viewer-delete-accept">Eliminar</div>
            <div class="gallery-viewer-delete-cancel">Cancelar</div>
        </div>
    </div>
`);

let currentGalleryPage = 1;
let currentLoadHeight = 0;

function setupGallery(data) {
    $('.gallery-content').html('');
    $('.gallery-content').append(/*html*/`<div class="gallery-item-footer"></div>`);

    $.each(data, function(i, element){
        if (element.type === 'photo') {
            $('.gallery-content').append(/*html*/`<div class="gallery-item">
                <img src="${element.link}?width=64&height=64" id="${element.link}" class="gallery-item-photo">
            </div>`);
        }

        if (element.type === 'video') {
            $('.gallery-content').append(/*html*/`<div class="gallery-item">
                <div class="gallery-video-icon"><i class="fa-solid fa-video"></i></div>
                <video src="${element.link}" id="${element.link}" class="gallery-item-video"></video>
            </div>`);
        }
    });

    currentGalleryPage = 2;
    currentLoadHeight = 0;
}

$('.gallery-content').scroll(function () {
    // End of the document reached?

    if (parseInt($('.gallery-content').prop("scrollHeight")) == parseInt($(this).scrollTop()+$(this).height()) && currentLoadHeight != $('.gallery-content').prop("scrollHeight")) {
        currentLoadHeight = parseInt($('.gallery-content').prop("scrollHeight"));

        $.post('http://cphone/getGalleryPage', JSON.stringify({page: currentGalleryPage}), function(data){
            $.each(data, function(i, element){
                if (element.type === 'photo') {
                    $('.gallery-content').append(/*html*/`<div class="gallery-item">
                        <img src="${element.link}?width=64&height=64" id="${element.link}" class="gallery-item-photo">
                    </div>`);
                }
        
                if (element.type === 'video') {
                    $('.gallery-content').append(/*html*/`<div class="gallery-item">
                        <div class="gallery-video-icon"><i class="fa-solid fa-video"></i></div>
                        <video src="${element.link}" id="${element.link}" class="gallery-item-video"></video>
                    </div>`);
                }
            });

            if (data.length > 0) {
                currentGalleryPage++;
            }
        });
    }
});

function OpenGallery() {
    currentGalleryPage = 1;
    currentLoadHeight = 0;

    $.post('http://cphone/getGalleryPage', JSON.stringify({page: currentGalleryPage}), function(data){
        setupGallery(data);
    });
}

$(document).on('click', '.gallery-delete', function(e){
    if ($(".gallery-viewer-delete").hasClass("gallery-viewer-delete-display")) {
        $(".gallery-viewer-delete").removeClass("gallery-viewer-delete-display");
    } else {
        $(".gallery-viewer-delete").addClass("gallery-viewer-delete-display");
    }
});

$(document).on('click', '.gallery-viewer-delete-accept', function(e){
    $(".gallery-viewer-delete").removeClass("gallery-viewer-delete-display");
    $('.gallery-viewer').fadeOut(200);

    $.post('http://cphone/deleteGalleryElement', JSON.stringify({link: src}));

    OpenGallery();
});

$(document).on('click', '.gallery-viewer-delete-cancel', function(e){
    $(".gallery-viewer-delete").removeClass("gallery-viewer-delete-display");
});

$(document).on('click', '.gallery-viewer-content', function(e){
    if (!controlsHidden) {
        controlsHidden = true;
        $('.gallery-viewer-header').fadeOut(200);
        $('.gallery-viewer-footer').fadeOut(200);
    } else {
        controlsHidden = false;
        $('.gallery-viewer-header').fadeIn(200);
        $('.gallery-viewer-footer').fadeIn(200);
    }
});

$(document).on('click', '.gallery-back', function(e){
    $('.gallery-viewer').fadeOut(200);
});

let src = "";

galleryImagetype = "";
galleryImageUrl = "";

$(document).on('click', '.gallery-item-photo', function(e){
    src = $(this).attr('id')

    $('.gallery-viewer-content').html(/*html*/`<img src="${src}">`);

    galleryImageUrl = `${src}`;
    galleryImagetype = "image";

    $('.gallery-viewer').fadeIn(200);
});

$(document).on('click', '.gallery-item-video', function(e){
    src = $(this).attr('id')

    $('.gallery-viewer-content').html(/*html*/`<video src="${src}" controls></video>`);

    galleryImageUrl = `${src}`;
    galleryImagetype = "video";

    $('.gallery-viewer').fadeIn(200);
});