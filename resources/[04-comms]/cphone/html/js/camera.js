let cameraType = 'photo';
let isRecording = false;
let recording = undefined;

$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .camera-app {
            display: none;
            height: 100%;
            width: 100%;
            background: #000000;
            overflow: hidden;
        }
    </style>
    <div class="camera-app"></div>
`);


$('.camera-app').append(/*html*/`
    <style type="text/css">
        .content-area {
            width: 29vh;
            height: 51.56vh;
            margin-top: 3vh;
            transition: filter 0.2s;
        }
        
        .content-rotated {
            transform: rotate(90deg);
            width: 52.56vh;
            height: 28vh;
            position: absolute;
            top: 11vh;
            right: -12vh;
        }

        .camera-overlay{
            position: absolute;
            width: 100%;
            height: 9.5vh;
            background: black;
            top: 51vh;
        }

        .camera-button-ring {
            position: absolute;
            margin: auto;
            left: 0;
            right: 0;
            width: 6vh;
            height: 6vh;
            background: white;
            border-radius: 6vh;
            top: 2vh;
        }

        .camera-button-black {
            position: absolute;
            margin: auto;
            left: 0;
            right: 0;
            top: 2.25vh;
            background: black;
            width: 5.5vh;
            height: 5.5vh;
            border-radius: 6vh; 
        }

        .camera-button {
            position: absolute;
            margin: auto;
            left: 0;
            right: 0;
            top: 2.5vh;
            background: white;
            width: 5vh;
            height: 5vh;
            border-radius: 6vh;
            transition: 0.25s;
        }
        
        .camera-button:hover {
            background: #c3c3c3;;
        }

        .camera-button:active {
            background: #000000;;
        }

        .camera-gallery {
            position: absolute;
            height: 4vh;
            width: 4vh;
            background: #212121;
            top: 3vh;
            left: 2vh;
            border-radius: 0.5vh;
        }

        .camera-rotate {
            position: absolute;
            height: 4vh;
            width: 4vh;
            background: #212121;
            top: 3vh;
            right: 2vh;
            border-radius: 3vh;
            line-height: 4.3vh;
            text-align: center;
            font-size: 2.5vh;
            color: white;
        }

        .camera-button-type {
            color: white;
            margin-left: 6.5vh;
            margin-top: 0.1vh;
            transition: 0.2s;
        }

        .camera-button-type-video {
            margin-right: 2vh;
            color: white;
            transition: 0.2s;
        }

        .camera-button-type-photo {
            color: #ffe000;
            transition: 0.2s;
        }

        .camera-header {
            background: black;
            position: absolute;
            top: 0;
            height: 6vh;
            width: 100%;
        }
    </style>
    <canvas id="self-render" class="content-area"></canvas>

    <div class="camera-header"></div>
    <div class="camera-overlay">
        <div class="camera-button-type">
            <span class="camera-button-type-video">VIDEO</span>
            <span class="camera-button-type-photo">FOTO</span>
        </div>

        <div class="camera-button-ring"></div>
        <div class="camera-button-black"></div>
        <div class="camera-button"></div>

        <div class="camera-gallery"><img src="" class="camera-gallery-image"></div>
        <div class="camera-rotate"><i class="fa-thin fa-rotate"></i></div>
    </div>
`);


function OpenCamera() {
    $.post('http://cphone/CreateCamera', JSON.stringify({}));
    //QB.Phone.Functions.Close();
    // QB.Phone.Animations.CloseApp('.phone-application-container', 400, -160);
    //QB.Phone.Animations.TopSlideUp('.'+QB.Phone.Data.currentApplication+"-app", 400, -160);
    //QB.Phone.Functions.ToggleApp(QB.Phone.Data.currentApplication, "none");
    // QB.Phone.Data.currentApplication = null;
    
    //viewFullScreenImage(src);

    let canvas = $("#self-render")[0];
    canvas.style.display = "block";

    MainRender.renderToTarget(canvas);
}

function CloseCamera() {
    if (isPhoneRotated) {
        rotatePhone();
    }

    if (isRecording) {
        cameraHandleTrigger();
        MainRender.stop();
        return false;
    }
    MainRender.stop();
}

let isPhoneRotated = false;

function rotatePhone() {
    if (!isPhoneRotated) {
        isPhoneRotated = true;

        $('.container').css('transform', 'rotate(-90deg)');
        $('.container').css('bottom', '-16%');
        $('.container').css('right', '-30%');

        $('.content-area').addClass('content-rotated');
    } else {
        isPhoneRotated = false;

        $('.container').css('transform', 'rotate(0deg)');
        $('.container').css('bottom', '0%');
        $('.container').css('right', '5vh');

        $('.content-area').removeClass('content-rotated');
    }

    MainRender.changeAspectRatio(!isPhoneRotated);
}

function activateVideoMode() {
    if (cameraType === 'video' || isRecording) return false;

    cameraType = 'video';

    $('.camera-button-type').css('margin-left', '12.5vh');
    
    $('.camera-button-type-video').css('color', '#ffe000');
    $('.camera-button-type-photo').css('color', 'white');

    $('.camera-button').css('background', 'red');


    $('.content-area').css('filter', 'blur(10px)');

    setTimeout(() => {
        $('.content-area').css('filter', 'blur(0px)');
    }, 500);
}

function activatePhotoMode() {
    if (cameraType === 'photo' || isRecording) return false;

    cameraType = 'photo';

    $('.camera-button-type').css('margin-left', '6.5vh');

    $('.camera-button-type-video').css('color', 'white');
    $('.camera-button-type-photo').css('color', '#ffe000');

    $('.camera-button').css('background', 'white');

    $('.content-area').css('filter', 'blur(10px)');

    setTimeout(() => {
        $('.content-area').css('filter', 'blur(0px)');
    }, 500);
}


function getTracks(stream, kind) {
    if (!stream || !stream.getTracks) {
        return [];
    }

    return stream.getTracks().filter(function(t) {
        return t.kind === (kind || 'audio');
    });
}

function record(canvas, cb) {
    var recordedChunks = [];
    var canvasStream = canvas.captureStream(60 /*fps*/);
    var finalStream = new MediaStream();

    navigator.mediaDevices.getUserMedia({audio: true}).then(function(audioStream) {
        getTracks(audioStream, 'audio').forEach(function(track) {
            finalStream.addTrack(track);
        });

        getTracks(canvasStream, 'video').forEach(function(track) {
            finalStream.addTrack(track);
        });
    
        cb(new Promise(function (res, rej) {
    
            mediaRecorder = new MediaRecorder(finalStream, {
                mimeType: "video/webm"
            });
            
            //ondataavailable will fire in interval of `time || 4000 ms`
            mediaRecorder.start();
    
            mediaRecorder.ondataavailable = function (event) {
                recordedChunks.push(event.data);
                 // after stop `dataavilable` event run one more time
                if (mediaRecorder.state === 'recording') {
                    mediaRecorder.stop();
                }
    
            }
    
            mediaRecorder.onstop = function (event) {
                var blob = new Blob(recordedChunks, {type: "video/webm" });
                //var url = URL.createObjectURL(blob);
                res(blob);
            }
        }));
    })
}

function cameraHandleTrigger() {
    if (cameraType === 'photo') {
        $(".camera-button").css('background-color', 'rgb(0, 0, 0)')
        setTimeout(() => {$(".camera-button").css('background-color', 'rgb(255, 255, 255)')}, 200);

        MainRender.requestScreenshot(
            "https://cdn.Sem Destinorp.net/files/upload", 
            "file"
        ).then((resp) => {
            let image = JSON.parse(resp);

            $.post('http://cphone/takePhoto', JSON.stringify({photo : image.url}));
        })
    } else if (cameraType === 'video') {
        if (!isRecording) {
            isRecording = true;

            let canvas = $("#self-render")[0];
            record(canvas, function(rec) {
                recording = rec;
            });

            $('.camera-button').css('top', '3.5vh');
            $('.camera-button').css('width', '3vh');
            $('.camera-button').css('height', '3vh');
            $('.camera-button').css('border-radius', '0.5vh');
        } else {
            isRecording = false;

            mediaRecorder.stop();

            $('.camera-button').css('top', '2.5vh');
            $('.camera-button').css('width', '5vh');
            $('.camera-button').css('height', '5vh');
            $('.camera-button').css('border-radius', '6vh');

            recording.then(url => {
                const formData = new FormData(); 
                formData.append("file",url,"video.webm");
        
                fetch("https://cdn.Sem Destinorp.net/files/upload", {
                    method: 'POST',
                    mode: 'cors',
                    body: formData
                }).then(response => response.text())
                .then(text => {
                    let textparse = JSON.parse(text);
                    
                    $.post('http://cphone/recordVideo', JSON.stringify({video : textparse.url}));
                });
            })
        }
    }
}
