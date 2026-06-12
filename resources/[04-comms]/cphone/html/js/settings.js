QB.Phone.Settings = {};
QB.Phone.Settings.Background = "default-qbus";
QB.Phone.Settings.OpenedTab = null;
QB.Phone.Settings.Backgrounds = {
    'default-qbus': {
        label: "Standard Qbus"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

/*
$('.settings-app').append(html`
    <div class="settings-app-header"><p>Definições</p></div>
                            
    <div class="settings-app-tab-appereance">
        <div class="settings-app-tab-header"><p>Aparência</p></div>
        <div class="settings-app-tab" data-settingstab="background">
            <div class="settings-tab-icon"><i class="fas fa-palette" style="color: #9b59b6;"></i></div>
            <div class="settings-tab-title"><p>Papel de parede</p></div>
            <div class="settings-tab-description"><p>Definir um papel de parede</p></div>
        </div>
        <div class="settings-app-tab" data-settingstab="profilepicture">
            <div class="settings-tab-icon"><i class="fab fa-itunes-note" style="color: #5984b6;"></i></div>
            <div class="settings-tab-title"><p>Toque</p></div>
            <div class="settings-tab-description"><p>Escolher um toque</p></div>
        </div>
    </div>


    <div class="settings-app-tab-information">
        <div class="settings-app-tab-header"><p>Infomação</p></div>
        <div class="settings-app-tab secondTab" data-settingstab="myPhone">
            <div class="settings-tab-icon"><i class="fas fa-phone-alt" style="color: #e67e22;"></i></div>
            <div class="settings-tab-title"><p>O meu número</p></div>
            <div class="settings-tab-description" id="myPhoneNumber"><p>Sem Número</p></div>
        </div>
        <div class="settings-app-tab secondTab" data-settingstab="numberrecognition">
            <!-- Rounded switch -->
            <label class="switch">
                <input class="numberrec-box" type="checkbox">
                <span class="slider round"></span>
            </label>

            <div class="settings-tab-icon"><i class="fas fa-user-slash" style="color: #e67e22;"></i></div>
            <div class="settings-tab-title"><p>Ligar em anónimo</p></div>
            <div class="settings-tab-description" id="numberrecognition"><p>Off</p></div>
        </div>
    </div>

    <div class="settings-background-tab">
        <div class="settings-app-header"><p>Papel de parede</p></div>

        <div class="background-options">
            <div class="background-option" data-background="default-qbus">
                <div class="background-option-icon"> <i class="fas fa-paint-brush"></i> </div>
                <div class="background-option-title"> Default </div>
                <div class="background-option-description">Este é o papel de parede default</div>
                <div class="background-option-current"><i class="fas fa-check-circle"></i></div>
            </div>
            <div class="background-option" data-background="custom-background">
                <div class="background-option-icon"><i class="fas fa-paint-brush"></i></div>
                <div class="background-option-title">Personalizado</div>
                <div class="background-option-description">Mete aqui o URL do teu papel de parede</div>
            </div>
        </div>

        <div class="background-buttons">
            <div class="background-button" id="accept-background">
                <p>Confirmar</p>
            </div>
            <div class="background-button" id="cancel-background">
                <p>Cancelar</p>
            </div>
        </div>

        <div class="background-custom">
            <div class="background-custom-title">Papel de parede personalizado</div>
            <input type="text" class="custom-background-input" placeholder="URL (.jpg/.png/.gif)" spellcheck="false">

            <div class="background-custom-buttons">
                <div class="custom-background-button" id="accept-custom-background"><p>Confirmar</p></div>
                <div class="custom-background-button" id="cancel-custom-background"><p>Cancelar</p></div>
            </div>
        </div>
    </div>

    <div class="settings-profilepicture-tab">
        <div class="settings-app-header"><p>Toque</p></div>

        <div class="profilepicture-options">
            <div class="profilepicture-option" data-profilepicture="tusa">
                <div class="profilepicture-option-icon"><i class="fas fa-volume-up"></i></div>
                <div class="profilepicture-option-title"> Tusa </div>
                <div class="profilepicture-option-description">Toque</div>
                <div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>
            </div>
            <div class="profilepicture-option" data-profilepicture="bella_ciao">
                <div class="profilepicture-option-icon"> <i class="fas fa-volume-up"></i> </div>
                <div class="profilepicture-option-title"> Bella Ciao </div>
                <div class="profilepicture-option-description">Toque</div>
                <div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>
            </div>
            <div class="profilepicture-option" data-profilepicture="iphone">
                <div class="profilepicture-option-icon"> <i class="fas fa-volume-up"></i> </div>
                <div class="profilepicture-option-title"> Marimba Iphone </div>
                <div class="profilepicture-option-description">Toque</div>
                <div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>
            </div>
            <div class="profilepicture-option" data-profilepicture="xtentacion">
                <div class="profilepicture-option-icon"> <i class="fas fa-volume-up"></i> </div>
                <div class="profilepicture-option-title"> XXXTentacion </div>
                <div class="profilepicture-option-description">Toque</div>
                <div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>
            </div>
            <div class="profilepicture-option" data-profilepicture="freaky">
                <div class="profilepicture-option-icon"> <i class="fas fa-volume-up"></i> </div>
                <div class="profilepicture-option-title"> Freaky </div>
                <div class="profilepicture-option-description">Toque</div>
                <div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>
            </div>
        </div>

    </div>
`);*/

$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .settings-app {
            display: none;
            height: 100%;
            width: 100%;
            background: rgb(225, 225, 225);
            color: black;
            overflow: hidden;
        }
    </style>
    <div class="settings-app"></div>
`);


$('.settings-app').append(/*html*/`
    <style type="text/css">
        .settings-header {
            width: 100%;
            height: fit-content;
            margin-top: 6vh;
            text-indent: 1.8vh;
            font-size: 2.5vh;
            font-weight: bold;
        }

        .settings-search {
            background: #d0d0d0;
            width: 87%;
            margin: auto;
            margin-top: 0.8vh;
            height: 2.8vh;
            line-height: 2.8vh;
            border-radius: 0.5vh;
            text-indent: 1.2vh;
            color: #797979;
        }

        .settings-blocks {
            background: #f7f7f7;
            width: 87%;
            margin: auto;
            margin-top: 1vh;
            margin-bottom: 1vh;
            height: fit-content;
            border-radius: 0.5vh;
        }

        .settings-profilepicture {
            height: 7vh;
            width: fit-content;
            margin-left: 1vh;
            line-height: 7vh;
        }

        .settings-profilepicture-img {
            height: 5vh;
            width: 5vh;
            object-fit: cover;
            border-radius: 10vh;
        }

        .settings-name {
            position: absolute;
            top: 15.6vh;
            margin-left: 7.2vh;
            font-size: 1.8vh;
        }

        .settings-name-details {
            position: absolute;
            top: 18vh;
            margin-left: 7.2vh;
            color: #353535;
            font-size: 1.1vh;
        }

        .settings-profilearrow {
            position: absolute;
            top: 17vh;
            right: 0;
            margin-right: 3.2vh;
            color: #b1b1b1;
            font-size: 1.1vh;
        }

        .settings-setting {
            display: flex;
            align-items: center;
            height: 3.5vh;
            border-bottom: rgb(225, 225, 225);
            border-bottom-style: solid;
            border-bottom-width: 0.1vh;
        }

        .setting-icon {
            align-items: center;
            display: flex;
            margin-left: 1vh;
        }

        .setting-text {
            margin-left: 1vh;
            font-size: 1.2vh;
        }

        .setting-last {
            margin-left: auto;
            color: #b1b1b1;
            font-size: 1.1vh;
            display: flex;
            align-items: center;
        }

        .setting-arrow {
            margin-right: 1.2vh;
            color: #b1b1b1;
        }

        .setting-info {
            margin-right: 1.2vh;
            color: #4e4e4e;
        }

        .setting-toggle {
            margin: auto;
            margin-right: 1.8vh;
            display: block;
            height: 2vh;
            position: relative;
            width: 2.3vh;
        }

        .setting-toggle input[type="checkbox"] {
            opacity: 0; 
        }
        
        .setting-toggle input[type="checkbox"] + span {
            position: absolute;
            left: 0;
            top: 0;
            -webkit-appearance: none;
            -moz-appearance: none;
            border-radius: 16px;
            display: inline-block;
            background: white;
            border: 1px solid #999;
            width: 3vh;
            height: 2vh;
            box-shadow: -11px 0 #999 inset;
            transition: box-shadow .20s;
        }
        
        .setting-toggle input[type="checkbox"] + span:focus {
            outline: none;
        }
        
        .setting-toggle input[type="checkbox"] + span:focus + span {
            border-color: blue;
        }
        
        .setting-toggle input[type="checkbox"]:checked + span {
            box-shadow: 11px 0 #4CD463 inset;
            border-color: #4CD463;
        }
        
        .setting-toggle input[type="checkbox"]:checked + span:focus + span {
            border-color: blue;
        }

        .setting-icon-sub {
            width: 2.2vh;
            height: 2.2vh;
            margin-left: 0.5vh;
            border-radius: 0.4vh;
            color: white;
            line-height: 2.39vh;
            text-align: center;
        }

        .settings-ringtone {
            position: absolute;
            display: none;
            top: 0;
            height: 100%;
            width: 100%;
            background: rgb(225, 225, 225);
        }

        .settings-wallpaper {
            position: absolute;
            display: none;
            top: 0;
            height: 100%;
            width: 100%;
            background: rgb(225, 225, 225);
        }
    </style>
    <div class="settings-header">Definições</div>
    <div class="settings-search">Procurar</div>
    <div class="settings-blocks">
        <div class="settings-profilepicture"><img src="./img/default.png" class="settings-profilepicture-img"></div>
        <div class="settings-name">John Smith</div>
        <div class="settings-name-details">Detalhes da conta</div>
        <div class="settings-profilearrow"><i class="fa-solid fa-angle-right"></i></div>
    </div>

    <div class="settings-blocks">
        <div class="settings-setting" id="setting-disabled1">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: linear-gradient(0deg, rgba(38,182,38,1) 0%, rgba(49,255,49,1) 100%);"><i class="fa-solid fa-phone"></i></div>
            </div>
            <div class="setting-text">Número</div>
            <div class="setting-last">
                <div class="setting-info">Sem Número</div>
            </div>
        </div>
        <div class="settings-setting" id="setting-phoneinfo">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #939393;"><i class="fa-solid fa-gear"></i></div>
            </div>
            <div class="setting-text">Informações do telemóvel</div>
            <div class="setting-last">
                <div class="setting-arrow"><i class="fa-solid fa-angle-right"></i></div>
            </div>
        </div>
    </div>

    <div class="settings-blocks">
        <div class="settings-setting" id="setting-disabled2">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-volume-high"></i></div>
            </div>
            <div class="setting-text">Sons</div>
            <div class="setting-last">
                <label class="setting-toggle" id="setting-sound"><input type="checkbox" checked="checked"><span /></label>
            </div>
        </div>
        <div class="settings-setting" id="setting-ringtone">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #2466ff;"><i class="fa-solid fa-volume-high"></i></div>
            </div>
            <div class="setting-text">Toque</div>
            <div class="setting-last">
                <div class="setting-arrow"><i class="fa-solid fa-angle-right"></i></div>
            </div>
        </div>
        <div class="settings-setting" id="setting-disabled3">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #fd8229;"><i class="fa-solid fa-plane"></i></div>
            </div>
            <div class="setting-text">Modo Avião</div>
            <div class="setting-last">
                <label class="setting-toggle" id="setting-airplane"><input type="checkbox"><span /></label>
            </div>
        </div>
        <div class="settings-setting" id="setting-disabled4">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #939393;"><i class="fa-solid fa-user-large-slash"></i></div>
            </div>
            <div class="setting-text">Modo Anónimo</div>
            <div class="setting-last">
                <label class="setting-toggle" id="setting-anonym"><input type="checkbox"><span /></label>
            </div>
        </div>
    </div>

    <div class="settings-blocks">
        <div class="settings-setting" id="setting-notifications">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-thin fa-bell"></i></div>
            </div>
            <div class="setting-text">Notificações</div>
            <div class="setting-last">
                <div class="setting-arrow"><i class="fa-solid fa-angle-right"></i></div>
            </div>
        </div>
        <div class="settings-setting" id="setting-wallpaper">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #63cbff;"><i class="fa-thin fa-spider-web"></i></div>
            </div>
            <div class="setting-text">Papel de Parede</div>
            <div class="setting-last">
                <div class="setting-arrow"><i class="fa-solid fa-angle-right"></i></div>
            </div>
        </div>
        <div class="settings-setting" id="setting-disabled5">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #51f577;"><i class="fa-thin fa-lock"></i></div>
            </div>
            <div class="setting-text">Ecrã de Bloqueio</div>
            <div class="setting-last">
                <label class="setting-toggle" id="setting-lockscreen"><input type="checkbox"><span /></label>
            </div>
        </div>
        <div class="settings-setting" id="setting-widgets">
            <div class="setting-icon">
                <div class="setting-icon-sub" style="background: #2466ff;"><i class="fa-solid fa-cubes"></i></div>
            </div>
            <div class="setting-text">Widgets</div>
            <div class="setting-last">
                <div class="setting-arrow"><i class="fa-solid fa-angle-right"></i></div>
            </div>
        </div>
    </div>

    <div class="settings-ringtone">
        <div class="settings-header">Definições</div>
        <div class="settings-blocks">
            <div class="settings-setting" id="setting-setringtone" data-ringtone="tusa">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-volume-high"></i></div>
                </div>
                <div class="setting-text">Tusa</div>
                <div class="setting-last"></div>
            </div>
            <div class="settings-setting" id="setting-setringtone" data-ringtone="bella_ciao">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-volume-high"></i></div>
                </div>
                <div class="setting-text">Bella Ciao</div>
                <div class="setting-last"></div>
            </div>
                <div class="settings-setting" id="setting-setringtone" data-ringtone="iphone">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-volume-high"></i></div>
                </div>
                <div class="setting-text">Marimba Iphone</div>
                <div class="setting-last"></div>
            </div>
            <div class="settings-setting" id="setting-setringtone" data-ringtone="xtentacion">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-volume-high"></i></div>
                </div>
                <div class="setting-text">XXXTentacion</div>
                <div class="setting-last"></div>
            </div>
            <div class="settings-setting" id="setting-setringtone" data-ringtone="freaky">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-volume-high"></i></div>
                </div>
                <div class="setting-text">Freaky</div>
                <div class="setting-last"></div>
            </div>
            <div class="settings-setting" id="setting-cancel">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-ban"></i></div>
                </div>
                <div class="setting-text">Cancelar</div>
                <div class="setting-last"></div>
            </div>
        </div>
    </div>

    <div class="settings-wallpaper">
        <div class="settings-header">Definições</div>
        <div class="settings-blocks">
            <div class="settings-setting" id="setting-setwallpaper" data-wallpaper="default-qbus">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-paint-roller"></i></div>
                </div>
                <div class="setting-text">Padrão</div>
                <div class="setting-last"></div>
            </div>
            <div class="settings-setting" id="setting-setwallpaper" data-wallpaper="custom">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-paint-roller"></i></div>
                </div>
                <div class="setting-text">URL</div>
                <div class="setting-last"><input type="text" class="wallpaper-url" placeholder="Coloca aqui o url" required="" spellcheck="false"></div>
            </div>
            <div class="settings-setting" id="setting-setwallpaper" data-wallpaper="accept">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-paint-roller"></i></div>
                </div>
                <div class="setting-text">Aceitar URL</div>
                <div class="setting-last"></div>
            </div>
            <div class="settings-setting" id="setting-cancel">
                <div class="setting-icon">
                    <div class="setting-icon-sub" style="background: #ff243a;"><i class="fa-solid fa-ban"></i></div>
                </div>
                <div class="setting-text">Cancelar</div>
                <div class="setting-last"></div>
            </div>
        </div>
    </div>

`);


$(document).on('click', '.setting-toggle', function(e){
    e.preventDefault();
    let checked = $(this).children().prop("checked");

    $(this).children().prop("checked", !checked);
    
    let setting = $(this).attr('id');
    let active = !checked;

    if (setting === "setting-anonym") {
        QB.Phone.Data.AnonymousCall = active;
    }
    if (setting === "setting-airplane") {
        QB.Phone.Data.AirplaneMode = active;

        $.post('http://cphone/SetAirplaneMode', JSON.stringify({
            airplaneMode: active
        }))

        if (active) {
            $("#phone-icons").html(/*html*/`
                <i class="fas fa-plane" id="phone-airplane" data-toggle="tooltip" data-placement="bottom" title="Modo Avião"></i>
                <i class="fa-solid fa-battery-three-quarters" id="phone-battery"></i>
            `);
        } else {
            $("#phone-icons").html(/*html*/`
                <i class="fas fa-signal" id="phone-signal" data-toggle="tooltip" data-placement="bottom" title="Sem Destino 5G"></i>
                <i class="fa-solid fa-battery-three-quarters" id="phone-battery"></i>
            `);
        }

        $('[data-toggle="tooltip"]').tooltip();
    }
});

$(document).on('click', '.settings-setting', function(e){
    e.preventDefault();
    
    let setting = $(this).attr('id');

    switch (setting) {
        case 'setting-phoneinfo':
            QB.Phone.Notifications.Add("fa-solid fa-gear", "Definições", 'Informações do Telemóvel', "ATL-P-A2025V3.0", "#7a7a7a");
            break;
        case 'setting-notifications':
            QB.Phone.Notifications.Add("fa-solid fa-gear", "Definições", 'Notificações', "Funcionalidade desativada", "#7a7a7a");
            break;
        case 'setting-widgets':
            QB.Phone.Notifications.Add("fa-solid fa-gear", "Definições", 'Widgets', "Funcionalidade desativada", "#7a7a7a");
            break;
        case 'setting-disabled2':
        case 'setting-disabled5':
            QB.Phone.Notifications.Add("fa-solid fa-gear", "Definições", 'Ecrã de bloqueio', "Funcionalidade desativada", "#7a7a7a");
            break;
        case 'setting-ringtone':
            $(".settings-ringtone").fadeIn(250);
            break;
        case 'setting-wallpaper':
            $(".settings-wallpaper").fadeIn(250);
            break;
        case 'setting-setringtone':
            let rt = $(this).data('ringtone');

            $.post('http://cphone/UpdateRingTone', JSON.stringify({
                ringtone: rt,
            }));

            QB.Phone.Notifications.Add("fa-solid fa-gear", "Definições", 'Toque', "Toque definido", "#7a7a7a");

            $(".settings-ringtone").fadeOut(250);
            break;
        case 'setting-setwallpaper':
            let wp = $(this).data('wallpaper');

            if (wp === "default-qbus") {
                localStorage.setItem('background', wp);

                QB.Phone.Functions.LoadMetaData();
            
                $(".settings-wallpaper").fadeOut(250);
            } else if (wp === "accept") {
                let url = $(".wallpaper-url").val();

                localStorage.setItem('background', url);

                QB.Phone.Functions.LoadMetaData();
            
                $(".settings-wallpaper").fadeOut(250);
            }
            break;
        case 'setting-cancel':
            $(".settings-ringtone").fadeOut(250);
            $(".settings-wallpaper").fadeOut(250);
            break;
        default:
            //console.log(`Sorry, we are out of ${setting}.`);
    }

});



QB.Phone.Functions.LoadMetaData = function() {
    if (localStorage.getItem('background') !== null) {
        QB.Phone.Settings.Background = localStorage.getItem('background');
    } else {
        QB.Phone.Settings.Background = "default-qbus";
    }

    var hasCustomBackground = QB.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+QB.Phone.Settings.Background+".png')"});
        $(".phone-call-background").css({"background-image":"url('/html/img/backgrounds/"+QB.Phone.Settings.Background+".png')"});
    } else {
        $(".phone-background").css({"background-image":"url('"+QB.Phone.Settings.Background+"')"});
        $(".phone-call-background").css({"background-image":"url('"+QB.Phone.Settings.Background+"')"}); 
    }

    $(".settings-name").text(QB.Phone.Data.PlayerData.firstName+" "+QB.Phone.Data.PlayerData.lastName);
    $(".setting-info").text(myPhoneNumber);
}

QB.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(QB.Phone.Settings.Backgrounds, function(i, background){
        if (QB.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

