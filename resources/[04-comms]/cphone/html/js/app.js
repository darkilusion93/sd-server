myPhoneNumber = '';

QB = {}
QB.Phone = {}
QB.Screen = {}
QB.Tablet = {}
QB.Tablet.Functions = {}
QB.Phone.Functions = {}
QB.Phone.Animations = {}
QB.Phone.Notifications = {}
QB.Phone.ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

QB.Phone.Data = {
    currentApplication: null,
    PlayerData: {},
    Applications: {},
    IsOpen: false,
    CallActive: false,
    MetaData: {},
    PlayerJob: {},
    AnonymousCall: false,
    AirplaneMode: false,
}

QB.Tablet.Data = {
    IsOpen: false,
}

OpenedChatData = {
    number: null,
}

let showingNotif = false;
let showingClosedNotif = false;
let inCall = false;
let CanOpenApp = true;
let HasPhone = false;

function timeSinceShort(date) {
    var seconds = Math.floor((new Date() - date) / 1000);
  
    var interval = seconds / 31536000;
  
    if (interval > 1) {
      return Math.floor(interval) + " A";
    }
    interval = seconds / 2592000;
    if (interval > 1) {
      return Math.floor(interval) + " M";
    }
    interval = seconds / 86400;
    if (interval > 1) {
      return Math.floor(interval) + " d";
    }
    interval = seconds / 3600;
    if (interval > 1) {
      return Math.floor(interval) + " h";
    }
    interval = seconds / 60;
    if (interval > 1) {
      return Math.floor(interval) + " m";
    }
    return Math.floor(seconds) + " s";
}

//Fullscreen picture viewer
$('body').append(/*html*/`
    <style type="text/css">
        .picture-viewer {
            display: none;
            position: absolute;
            background: #00000080;
            width: 100%;
            height: 100%;
            z-index: 1001;
        }

        .picture-viewer-img {
            position: absolute;
            max-width: 130vh;
            max-height: 80vh;
            margin: auto;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
        }

        .picture-viewer-download {
            margin: auto;
            margin-top: 5vh;
            text-align: center;
            color: white;
            width: 4vh;
            height: 4vh;
            background: #00000091;
            line-height: 4vh;
            border-radius: 4vh;
            transition: 0.25s;
        }

        .picture-viewer-download:hover {
            background: #3a3a3a91;
        }

        .picture-viewer-download:active {
            background: #ffffff91;
        }
    </style>
    <div class="picture-viewer">
        <div class="picture-viewer-download"><i class="fa-solid fa-download"></i></div>
        <img class="picture-viewer-img">
    </div>
`);

$(document).on('click', '.picture-viewer', function(e){
    $('.picture-viewer').fadeOut(200);
});

$(document).on('click', '.picture-viewer-download', function(e){
    let src = $(".picture-viewer-img").attr("src");

    QB.Phone.Notifications.Add("fa-solid fa-camera-retro", "Fotos", 'Galeria', "Foto guardada!", "#FFFFFF");

    $.post('http://cphone/takePhoto', JSON.stringify({photo : src}));
});

function viewFullScreenImage(src) {
    $(".picture-viewer-img").attr("src", src);
    $('.picture-viewer').fadeIn(200);
}

let pressTimer;
let defaultActionPress = false;
let isEditingHomeScreen = false;

function SetupApplications() {
    for (let i = 1; i <= 28; i++) {
        let applicationSlot = $(".phone-applications").find(`[data-appslot="${i}"]`);

        applicationSlot.html("");
        $(applicationSlot).css({"background":'rgb(255 255 255 / 0%)'});
        applicationSlot.data('app', "");
    }

    $.each(PhoneApplications, function(i, app){
        var applicationSlot = $(".phone-applications").find(`[data-appslot="${app.slot}"]`);
        var icon = '';
        
        if (app.img !== undefined && app.img !== null) {
            icon = /*html*/`<img src="img/apps/${app.img}" style="width: 100%; height: 100%;"></img>`;
        } else {
            $(applicationSlot).css({"background":app.color});
            icon = /*html*/`<i class="ApplicationIcon ${app.icon}" style="'+app.style+'"></i>`;
        }

        let appAlerts = /*html*/`${icon}<div class="app-unread-alerts" style="display: none;">0</div><div class="app-title">${app.tooltipText}</div>`;

        if (app.slot <= 4) appAlerts = /*html*/`${icon}<div class="app-unread-alerts" style="display: none;">0</div>`;

        $(applicationSlot).html(appAlerts);
        $(applicationSlot).data('app', app.app);
    });

    $('.phone-application').draggable({ revert: true, zIndex: 9999 });

    if (!isEditingHomeScreen) {
        $('.phone-application').draggable("disable");
    }
}

QB.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');

        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

QB.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(Config.HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

$('.phone-application').droppable({
    drop: function (event, ui) {
        let droppedSlot = $(this).data('appslot');
        let draggedApplication = ui.draggable.data("app");
        
        //console.log(draggedApplication)
        //console.log(droppedSlot)

        PhoneApplications[draggedApplication].slot = droppedSlot;

        SetupApplications();
    }
});

$(".phone-application").mouseup(function(){
    if (pressTimer !== undefined && pressTimer !== null) {
        clearTimeout(pressTimer);
    }
    // Clear timeout
    if (!defaultActionPress) {
        return false;
    }

    if (isEditingHomeScreen) return false;

    var PressedApplication = $(this).data('app');

    if (PressedApplication === undefined || PressedApplication === "") return false;

    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length !== 0) {
        if (CanOpenApp) {
            if (QB.Phone.Data.currentApplication == null) {
                QB.Phone.Animations.OpenApp('.phone-application-container', 300);
                QB.Phone.Functions.ToggleApp(PressedApplication, "block");

                $('.phone-home-button').css({"background-color":"rgba(255, 255, 255, 0.75)"});
                
                if (QB.Phone.Functions.IsAppHeaderAllowed(PressedApplication)) {
                    QB.Phone.Functions.HeaderTextColor("black", 300);
                    $('.phone-home-button').css({"background-color":"rgba(0, 0, 0, 0.75)"});
                }
    
                QB.Phone.Data.currentApplication = PressedApplication;
    
                if (PressedApplication == "settings") {
                    $("#myPhoneNumber").text(myPhoneNumber);
                } else if (PressedApplication == "twitter") {
                    OpenTwitter();
                } else if (PressedApplication == "flappybird") {
                    OpenFlappyGame();
                } else if (PressedApplication == "bank") {
                    QB.Phone.Functions.DoBankOpen();
                    $.post('http://cphone/GetBankContacts', JSON.stringify({}), function(contacts){
                        QB.Phone.Functions.LoadContactsWithNumber(contacts);
                    });
                    $.post('http://cphone/GetInvoices', JSON.stringify({}), function(invoices){
                        QB.Phone.Functions.LoadBankInvoices(invoices);
                    });
                    $.post('http://cphone/GetTransactions', JSON.stringify({}), function(transactions){
                        QB.Phone.Functions.LoadBankTransactions(transactions);
                    });
                } else if (PressedApplication == "tinder") {
                    $.post('http://cphone/LoadTinder', JSON.stringify({}))
                    QB.Phone.Functions.DoTinderOpen();
                } else if (PressedApplication == "whatsapp") {
                    OpenMessagesApp();
                } else if (PressedApplication == "phone") {
                    OpenPhoneApp();
                } else if (PressedApplication == "mail") {
                    OpenMail();
                } else if (PressedApplication == "advert") {
                    $.post('http://cphone/LoadAdverts', JSON.stringify({}), function(Adverts){
                        QB.Phone.Functions.RefreshAdverts(Adverts);
                    })
                } else if (PressedApplication == "darkweb") {
                    $.post('http://cphone/LoadDarkweb', JSON.stringify({}), function(Adverts){
                        QB.Phone.Functions.RefreshDarkweb(Adverts);
                    })  
                } else if (PressedApplication == "garage") {
                    $.post('http://cphone/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "crypto") {
                    $.post('http://cphone/GetCryptoData', JSON.stringify({
                        crypto: "qbit",
                    }), function(CryptoData){
                        SetupCryptoData(CryptoData);
                    })

                    $.post('http://cphone/GetCryptoTransactions', JSON.stringify({}), function(data){
                        RefreshCryptoTransactions(data);
                    })
                } else if (PressedApplication == "racing") {
                    $.post('http://cphone/GetRacesUpdates', JSON.stringify({
                        getUpdates: true,
                    }));
                    $.post('http://cphone/GetAvailableRaces', JSON.stringify({}), function(Races){
                        SetupRaces(Races);
                    });
                } else if (PressedApplication == "houses") {
                    $.post('http://cphone/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                    $.post('http://cphone/GetPlayerKeys', JSON.stringify({}), function(Keys){
                        $(".house-app-mykeys-container").html("");
                        if (Keys.length > 0) {
                            $.each(Keys, function(i, key){
                                var elem = '<div class="mykeys-key" id="keyid-'+i+'"> <span class="mykeys-key-label">' + key.HouseData.adress + '</span> <span class="mykeys-key-sub">Klik om GPS in te stellen</span> </div>';

                                $(".house-app-mykeys-container").append(elem);
                                $("#keyid-"+i).data('KeyData', key);
                            });
                        }
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                } else if (PressedApplication == "lawyers") {
                    $.post('http://cphone/GetCurrentLawyers', JSON.stringify({}), function(data){
                        SetupLawyers(data);
                    });
                } else if (PressedApplication == "store") {
                    $.post('http://cphone/SetupStoreApps', JSON.stringify({}), function(data){
                        SetupAppstore(data); 
                    });
                } else if (PressedApplication == "trucker") {
                    $.post('http://cphone/GetTruckerData', JSON.stringify({}), function(data){
                        SetupTruckerInfo(data);
                    });
                } else if (PressedApplication == "camera") {
                    OpenCamera();
                } else if (PressedApplication == "gallery") {
                    OpenGallery();
                } else if (PressedApplication == "notes") {
                    OpenNotes();
                } else if (PressedApplication == "boosting") {
                    OpenBoost();
                } else if (PressedApplication == "snake") {
                    initSnakeGame();
                }
            }
        }
    } else {
        QB.Phone.Notifications.Add("fas fa-exclamation-circle", "Sistema", 'Aplicações', PhoneApplications[PressedApplication].tooltipText+" não está disponivel!")
    }
    return false;
}).mousedown(function(){
    // Set timeout
    defaultActionPress = true;

    pressTimer = window.setTimeout(function() {
        if (!isEditingHomeScreen) {
            isEditingHomeScreen = true;
            $('.phone-application').draggable("enable");
            $('.phone-application').css({"animation":"shake .1s linear alternate infinite"});
            $('.phone-header-done').fadeIn(200);
            $('#phone-icons').fadeOut(200);
            return true;
        }

        defaultActionPress = false;
    },1000);
    return false; 
}).mouseout(function() {
    if (pressTimer !== undefined && pressTimer !== null) {
        clearTimeout(pressTimer);
    }
});

$(document).on('click', '.phone-header-done', function(e){
    e.preventDefault();

    if (isEditingHomeScreen) {
        isEditingHomeScreen = false;
        $('.phone-application').draggable("disable");
        $('.phone-application').css({"animation":""});
        $('.phone-header-done').fadeOut(200);
        $('#phone-icons').fadeIn(200);
    }
});

$(document).on('click', '.mykeys-key', function(e){
    e.preventDefault();

    var KeyData = $(this).data('KeyData');

    $.post('http://cphone/SetHouseLocation', JSON.stringify({
        HouseData: KeyData
    }))
});

function closeAppRoutine() {
    QB.Phone.Animations.CloseApp('.phone-application-container', 400, -160);
    QB.Phone.Animations.TopSlideUp('.'+QB.Phone.Data.currentApplication+"-app", 400, -160);
    CanOpenApp = false;
    setTimeout(function(){
        QB.Phone.Functions.ToggleApp(QB.Phone.Data.currentApplication, "none");
        CanOpenApp = true;
    }, 400)
    QB.Phone.Functions.HeaderTextColor("white", 300);
    $('.phone-home-button').css({"background-color":"rgba(255, 255, 255, 0.75)"});
}

$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (QB.Phone.Data.currentApplication === null) {
        QB.Phone.Functions.Close();
    } else {
        closeAppRoutine();

        if (QB.Phone.Data.currentApplication == "whatsapp") {
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatPicture = null;
                    OpenedChatData.number = null;
                }, 450);
            }
        } else if (QB.Phone.Data.currentApplication == "bank") {
            if (CurrentTab == "invoices") {
                setTimeout(function(){
                    $(".bank-app-invoices").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});
    
                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="invoices"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');
    
                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');
    
                    CurrentTab = "accounts";
                }, 400)
            }
            if (CurrentTab == "historic") {
                setTimeout(function(){
                    //$(".bank-app-historic").animate({"left": "30vh"});
                    $(".bank-app-historic").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});
    
                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="historic"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');
    
                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');
    
                    CurrentTab = "accounts";
                }, 400)
            }
        } else if (QB.Phone.Data.currentApplication == "settings") {
            if (CurrentTab == "ringtones") {
                setTimeout(function(){
                    QB.Phone.Animations.TopSlideUp(".settings-profilepicture-tab", 200, -100);
                    CurrentTab = "noringtones";
                }, 400)
            }
        } else if (QB.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"}); 
            }, 400)
        } else if (QB.Phone.Data.currentApplication == "camera") {
            CloseCamera();
        } else if (QB.Phone.Data.currentApplication == "racing") {
            $.post('http://cphone/GetRacesUpdates', JSON.stringify({
                getUpdates: false,
            }));
        } else if (QB.Phone.Data.currentApplication == "flappybird") {
            ExitFlappyGame();
        }

        QB.Phone.Data.currentApplication = null;
    }
});

QB.Phone.Functions.Open = function(data) {
    QB.Phone.Animations.BottomSlideUp('.container', 300, 0);
    QB.Phone.Data.IsOpen = true;
}

QB.Tablet.Functions.Open = function() {
    $('.tablet').fadeIn(250);
    QB.Tablet.Data.IsOpen = true;
}

QB.Tablet.Functions.Close = function() {
    $('.tablet').fadeOut(250);
    QB.Tablet.Data.IsOpen = false;
    $.post('http://cphone/TabletClose');
}

$(document).on('click', '.tablet-header-button-red', function(event){
    event.preventDefault();

    QB.Tablet.Functions.Close();
});

$(document).on('click', '.tablet-header-button-green', function(event){
    event.preventDefault();

    $('.tabletContent').attr('src', 'http://94.60.137.218:8080/Sem Destinorp/tablet/');
});

QB.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

QB.Phone.Functions.Close = function() {

    if (QB.Phone.Data.currentApplication == "whatsapp") {
        setTimeout(function(){
            QB.Phone.Animations.CloseApp('.phone-application-container', 400, -160);
            QB.Phone.Animations.TopSlideUp('.'+QB.Phone.Data.currentApplication+"-app", 400, -160);
            $(".whatsapp-app").css({"display":"none"});
            QB.Phone.Functions.HeaderTextColor("white", 300);
    
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatData.number = null;
                }, 450);
            }
            OpenedChatPicture = null;
            QB.Phone.Data.currentApplication = null;
        }, 500)
    } else if (QB.Phone.Data.currentApplication == "meos") {
        $(".meos-alert-new").remove();
        $(".meos-recent-alert").removeClass("noodknop");
        $(".meos-recent-alert").css({"background-color":"#004682"});
    } else if (QB.Phone.Data.currentApplication == "camera") {
        closeAppRoutine();
        CloseCamera();
        QB.Phone.Data.currentApplication = null;
    }

   // if (!showingNotif && !showingClosedNotif) {
        QB.Phone.Animations.BottomSlideDown('.container', 300, -70);
   // } else {
    //    QB.Phone.Animations.BottomSlideUp('.container', 300, -55);
   // }
    
    $.post('http://cphone/Close');
    QB.Phone.Data.IsOpen = false;
}

QB.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}

QB.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout);
}

QB.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

QB.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout);
}

QB.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

QB.Phone.Animations.OpenApp = function(Object, Timeout) {
    $(Object).css({'top':'0%'}).fadeIn(80);
    $('.phone-application-container').addClass('phone-app-scaled');
    $('.phone-applications').addClass('phone-applications-scaled');
}

QB.Phone.Animations.CloseApp = function(Object, Timeout) {
    $(Object).css({'top':'0%'}).fadeOut(200);
    $('.phone-application-container').removeClass('phone-app-scaled');
    $('.phone-applications').removeClass('phone-applications-scaled');
}

QB.Phone.Notifications.Add = function(icon, title, pretext, text, color, timeout) {
    if (!HasPhone) return;
    if (QB.Phone.Data.AirplaneMode) return;
    if (timeout == null && timeout == undefined) timeout = 2500;

    if (QB.Phone.Notifications.Timeout == undefined || QB.Phone.Notifications.Timeout == null) {
        if (color != null || color != undefined) {
            $(".notification-icon").css({"color":color});
        } else if (color == "default" || color == null || color == undefined) {
            $(".notification-icon").css({"color":"#e74c3c"});
        }

        if (!QB.Phone.Data.IsOpen) QB.Phone.Animations.BottomSlideUp('.container', 300, -57);

        QB.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
        if (icon !== "politie") {
            $(".notification-icon").html('<i class="'+icon+'"></i>');
        } else {
            $(".notification-icon").html('<img src="./img/politie.png" class="police-icon-notify">');
        }
        $(".notification-title").text(title.toUpperCase());
        $(".notification-text").text(text);

        if (QB.Phone.Notifications.Timeout !== undefined || QB.Phone.Notifications.Timeout !== null) clearTimeout(QB.Phone.Notifications.Timeout);

        QB.Phone.Notifications.Timeout = setTimeout(function(){
            QB.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -6.5);
            QB.Phone.Notifications.Timeout = null;
            if (!QB.Phone.Data.IsOpen) QB.Phone.Animations.BottomSlideDown('.container', 300, -70);
        }, timeout);
    } else { //Mostrar notificação quando já está uma a ser mostrada
        if (color != null || color != undefined) {
            $(".notification-icon").css({"color":color});
        } else {
            $(".notification-icon").css({"color":"#e74c3c"});
        }

        $(".notification-icon").html('<i class="'+icon+'"></i>');
        $(".notification-title").text(title.toUpperCase());
        $(".notification-text").text(text);
        
        if (QB.Phone.Notifications.Timeout !== undefined || QB.Phone.Notifications.Timeout !== null) clearTimeout(QB.Phone.Notifications.Timeout);
        
        QB.Phone.Notifications.Timeout = setTimeout(function(){
            QB.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -6.5);
            QB.Phone.Notifications.Timeout = null;
            if (!QB.Phone.Data.IsOpen) QB.Phone.Animations.BottomSlideDown('.container', 300, -70);
        }, timeout);
    }
}

QB.Phone.Notifications.AddClosed = function(icon, title, text, color, timeout) {
    console.log('deprecated, use new method')
}

QB.Phone.Functions.LoadPhoneData = function(data) {
    QB.Phone.Data.PlayerData = data.PlayerData;

    myPhoneNumber = data.myPhone;

    QB.Phone.Data.PlayerJob = data.PlayerJob;
    QB.Phone.Data.MetaData = data.PhoneData.MetaData;
    QB.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    QB.Phone.Functions.LoadContacts(data.PhoneData.Contacts);

    updateBoostCoins(data.PhoneData.BoostCoins);

    console.log("Phone succesfully loaded!");
}

QB.Phone.Functions.UpdateTime = function(data) {    
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    var MessageTime = Hourssssss + ":" + Minutessss

    $("#phone-time").html(data.InGameTime.hour + ":" + data.InGameTime.minute);
}

var NotificationTimeout = null;

QB.Screen.Notification = function(title, content, icon, timeout, color) {
    if (HasPhone) {
        if (color != null && color != undefined) {
            $(".screen-notifications-container").css({"background-color":color});
        }
        $(".screen-notification-icon").html('<i class="'+icon+'"></i>');
        $(".screen-notification-title").text(title);
        $(".screen-notification-content").text(content);
        $(".screen-notifications-container").css({'display':'block'}).animate({
            right: 5+"vh",
        }, 200);
    
        if (NotificationTimeout != null) {
            clearTimeout(NotificationTimeout);
        }
    
        NotificationTimeout = setTimeout(function(){
            $(".screen-notifications-container").animate({
                right: -35+"vh",
            }, 200, function(){
                $(".screen-notifications-container").css({'display':'none'});
            });
            NotificationTimeout = null;
        }, timeout);
    }
}

$(document).ready(function(){
    SetupApplications();

    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                QB.Phone.Functions.Open(event.data);
                QB.Phone.Functions.SetupAppWarnings(event.data.AppData);
                QB.Phone.Functions.SetupCurrentCall(event.data.CallData);
                QB.Phone.Data.IsOpen = true;
                QB.Phone.Data.PlayerData = event.data.PlayerData;
                break;
            case "openTablet":
                QB.Tablet.Functions.Open();
                break;
            case "LoadPhoneData":
                QB.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                QB.Phone.Functions.UpdateTime(event.data);
                break;
            case "UpdateInvoices":
                QB.Phone.Functions.LoadBankInvoices(event.data.Invoices);
                break;
            case "UpdateTransactions":
                QB.Phone.Functions.LoadBankTransactions(event.data.TransactionData);
                break;
            case "Notification":
                QB.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                QB.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, 'Publicação', event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                QB.Phone.Functions.SetupAppWarnings(event.data.AppData);                
                break;
            case "SetPhoneHas":
                if (event.data.HasPhone) {
                    HasPhone = true; 
                } else {
                    HasPhone = false; 
                }     
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&euro; "+numberWithSpaces(event.data.NewBalance));
                $(".bank-app-account-balance").data('balance', numberWithSpaces(event.data.NewBalance));
                break;
            case "UpdateSocietyBank":
                $(".bank-app-society-account-balance").html("&euro; "+numberWithSpaces(event.data.NewBalance));
                $(".bank-app-society-account-balance").data('balance', numberWithSpaces(event.data.NewBalance));
                break;
            case "UpdateSocietyBankDisplay":
                if (event.data.ShowSociety) {
                    $(".bank-app-society-account").css({"display":"block"});
                } else {
                    $(".bank-app-society-account").css({"display":"none"});
                }

                $(".bank-app-society-account-number").html(event.data.AccountName);
                break;
            case "CancelOutgoingCall":
                if (HasPhone) {
                    showingNotif = false;
                    CancelOutgoingCall();
                }                
                break;
            case "EndFacetimeCall":
                console.log("end call")
                endCurrentVideoCall();
                break;
            case "AnswerFacetimeCall":
                console.log("accept call")
                answerCurrentVideoCall();
                break;
            case "SetupHomeCall":
                QB.Phone.Functions.SetupCurrentCall(event.data.CallData);
                break;
            case "CloseCameraApp":
                closeAppRoutine();
                CloseCamera();
                QB.Phone.Data.currentApplication = null;
                break;
            case "CameraTrigger":
                cameraHandleTrigger();
                break;
            case "ActivatePhoto":
                activatePhotoMode();
                break;
            case "ActivateVideo":
                activateVideoMode();
                break;
            case "RotatePhone":
                rotatePhone();
                break;
            case "AnswerCall":
                showingNotif = true;
                QB.Phone.Functions.AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);

                

                if (!QB.Phone.Data.IsOpen) {
                    QB.Phone.Animations.CloseApp('.phone-application-container', 400, -160);
                    QB.Phone.Animations.BottomSlideUp('.container', 300, -55);
                    
                } else {
                    //showingNotif = false;
                    
                }

                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("Em chamada ("+timeString+")");
                break;
            case "CancelOngoingCall":
                if (showingNotif && !QB.Phone.Data.IsOpen && !showingClosedNotif) {
                    QB.Phone.Animations.BottomSlideDown('.container', 300, -70);
                }
                
                QB.Phone.Animations.CloseApp('.phone-application-container', 400, -160);
                setTimeout(function(){
                    QB.Phone.Functions.ToggleApp("phone-call", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                QB.Phone.Functions.HeaderTextColor("white", 300);
    
                QB.Phone.Data.CallActive = false;
                QB.Phone.Data.currentApplication = null;
                showingNotif = false;
                break;
            case "RefreshContacts":
                QB.Phone.Functions.LoadContacts(event.data.Contacts);
                break;
            case "UpdateMails":
                QB.Phone.Functions.SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (QB.Phone.Data.currentApplication == "advert") {
                    QB.Phone.Functions.RefreshAdverts(event.data.Adverts);
                }
                break;
            case "RefreshDarkweb":
                if (QB.Phone.Data.currentApplication == "darkweb") {
                    QB.Phone.Functions.RefreshDarkweb(event.data.Adverts);
                }
                break;
            case "RefreshTinder":
                if (QB.Phone.Data.currentApplication == "tinder") {
                    QB.Phone.Functions.RefreshTinder(event.data.Tinder);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
            case "UpdateApplications":
                QB.Phone.Data.PlayerJob = event.data.JobData;
                break;
            case "UpdateTransactions":
                RefreshCryptoTransactions(event.data);
                break;
            case "UpdateRacingApp":
                $.post('http://cphone/GetAvailableRaces', JSON.stringify({}), function(Races){
                    SetupRaces(Races);
                });
                break;
            case "UpdateRacingPosition":
                updateRacePositions(event.data.positions);
            case "RefreshAlerts":
                QB.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
            case "ClosePhone":
                QB.Phone.Functions.Close();
                break;
        }
    })

    $('[data-toggle="tooltip"]').tooltip();

    $.post("http://cphone/cphoneReady", JSON.stringify({}));
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
            if (QB.Phone.Data.IsOpen) { QB.Phone.Functions.Close(); }
            if (QB.Tablet.Data.IsOpen) { QB.Tablet.Functions.Close(); }
            break;
        case 112: // F1
            if (QB.Phone.Data.IsOpen) { QB.Phone.Functions.Close(); }
            if (QB.Tablet.Data.IsOpen) { QB.Tablet.Functions.Close(); }
            break;
        case 118: //F7
            if (QB.Phone.Data.IsOpen) { QB.Phone.Functions.Close(); }
            if (QB.Tablet.Data.IsOpen) { QB.Tablet.Functions.Close(); }
            break;
    }
});


// Async function to upload an image and get the response
async function uploadImage(link) {
    if (link !== '') {
        try {
            // Fetch the image from the link
            const response = await fetch(link);
            
            // Convert the response to a Blob
            const blob = await response.blob();
            
            // Create a FormData object to send the image to your server
            let formData = new FormData();
            formData.append("file", blob, "profile-image.jpeg");

            // Send the image to the server using fetch
            const uploadResponse = await fetch('https://cdn.Sem Destinorp.net/files/upload', {
                method: 'POST',
                body: formData // Attach the form data with the image
            });

            // Parse the response to get the uploaded image URL
            const data = await uploadResponse.json();
            if (data.url) {
                // If the upload is successful, return the uploaded image URL
                return data.url;
            }
        } catch (error) {
            console.error('Error uploading image:', error);
        }
    }
    return null; // Return null if no link is provided or if an error occurs
}