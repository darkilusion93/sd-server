var WhatsappSearchActive = false;
var OpenedChatPicture = null;

let SelectedGroupContacts = {};
let CreateGroupButton = false
let CreateType = 'none';

let allmessages = {};

$(document).ready(function(){
    $("#whatsapp-search-input").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".whatsapp-chats .whatsapp-chat").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
});

$(document).on('click', '#whatsapp-search-chats', function(e){
    e.preventDefault();

    if ($("#whatsapp-search-input").css('display') == "none") {
        $("#whatsapp-search-input").fadeIn(150);
        WhatsappSearchActive = true;
    } else {
        $("#whatsapp-search-input").fadeOut(150);
        WhatsappSearchActive = false;
    }
});

$(document).on('click', '#whatsapp-settings', function(e){
    e.preventDefault();

    $('.whatsapp-dropdown-menu').animate({width: '50%', height: '10vh', opacity: 1}, 600); 
});

$(document).on('click', function(e){
    e.preventDefault();

    if($(e.target).attr('class') != 'whatsapp-dropdown-menu' && $(e.target).attr('class') != 'whatsapp-dropdown-item' && $(e.target).attr('class') != 'fas fa-ellipsis-v'){
        $('.whatsapp-dropdown-menu').animate({width: '0', height: '0', opacity: 0}, 400);
    }
});

$(document).on('click', '#whatsapp-create-group', function(e){
    e.preventDefault();

    CreateType = 'group';

    QB.Phone.Notifications.Add("fa fa-phone-alt", "Telefone", 'Grupos',"Funcionalidade desativada.", "#1DA1F2");

    //$("#whatsapp-contacts-cgroup").html("Criar grupo");
    //$("#whatsapp-contacts-cgroup2").html("Adicionar participantes");

    //$('.whatsapp-dropdown-menu').animate({width: '0', height: '0', opacity: 0}, 400);

    //$(".whatsapp-contacts").css({"display":"block"});
    //$(".whatsapp-contacts").animate({
    //    bottom: 0+"vh"
    //},200);
});

$(document).on('click', '.gallery-share', function(e){
    e.preventDefault();

    CreateType = 'sendgallery';

    QB.Phone.Functions.HeaderTextColor("white", 400);
    QB.Phone.Animations.CloseApp('.phone-application-container', 400);
    setTimeout(function(){
        QB.Phone.Functions.ToggleApp("gallery", "none");
        QB.Phone.Functions.ToggleApp("whatsapp", "block");
        QB.Phone.Data.currentApplication = "whatsapp";
        QB.Phone.Animations.OpenApp('.phone-application-container', 300);
    }, 400)

    //QB.Phone.Notifications.Add("fa fa-phone-alt", "Telefone", 'Grupos',"Funcionalidade desativada.", "#1DA1F2");

    $("#whatsapp-contacts-cgroup").html("Enviar conteúdo");
    $("#whatsapp-contacts-cgroup2").html("Escolher contacto");

    $('.whatsapp-dropdown-menu').animate({width: '0', height: '0', opacity: 0}, 400);

    $(".whatsapp-contacts").css({"display":"block"});
    $(".whatsapp-contacts").animate({
        bottom: 0+"vh"
    },200);
});

$(document).on('click', '#whatsapp-create-message', function(e){
    e.preventDefault();

    CreateType = 'dm';

    $("#whatsapp-contacts-cgroup").html("Enviar mensagem");
    $("#whatsapp-contacts-cgroup2").html("Escolher contacto");

    $('.whatsapp-dropdown-menu').animate({width: '0', height: '0', opacity: 0}, 400);

    $(".whatsapp-contacts").css({"display":"block"});
    $(".whatsapp-contacts").animate({
        bottom: 0+"vh"
    },200);
});

$(document).on('click', '#whatsapp-contacts-back', function(e){
    e.preventDefault();

    $(".whatsapp-contacts").animate({
        bottom: -70+"vh"
    }, 200, function(){
        $(".whatsapp-contacts").css({"display":"none"});
    });
});

$(document).on('click', '.whatsapp-contact', function(e){
    e.preventDefault();

    let contactId = $(e.target).attr('data-contactid');

    if (contactId == undefined) {
        contactId = $(this).data('contactid');
        if (contactId == undefined) {
            return;
        }
    }

    if (CreateType == 'dm'){
        var ContactData = $("[data-contactid='"+contactId+"']").data('contactData');

        if (ContactData.number !== myPhoneNumber) {
            refreshLatestMessages();
    
            QB.Phone.Functions.HeaderTextColor("white", 400);
            setTimeout(function(){
                refreshOpenedChatMessages(ContactData.number);

                $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 150);
                $(".whatsapp-openedchat").css({"display":"block"});
                $(".whatsapp-openedchat").css({left: 0+"vh"});
                $(".whatsapp-chats").animate({left: 30+"vh"},100, function(){
                    $(".whatsapp-chats").css({"display":"none"});
                });
                $(".whatsapp-contacts").animate({
                    bottom: -70+"vh"
                }, 200, function(){
                    $(".whatsapp-contacts").css({"display":"none"});
                });
            }, 400)
        } else {
            QB.Phone.Notifications.Add("fa fa-phone-alt", "Telefone", 'Mensagem',"Não podes enviar mensagens a ti próprio...", "#1DA1F2");
        }
        return;
    }

    if (CreateType == 'sendgallery'){
        var ContactData = $("[data-contactid='"+contactId+"']").data('contactData');

        if (ContactData.number !== myPhoneNumber) {
            $.post('http://cphone/SendMessage', JSON.stringify({
                ChatNumber: ContactData.number,
                ChatMessage: galleryImageUrl,
                ChatType: galleryImagetype,
            }));

            refreshLatestMessages();
    
            QB.Phone.Functions.HeaderTextColor("white", 400);
            setTimeout(function(){
                refreshOpenedChatMessages(ContactData.number);

                $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 150);
                $(".whatsapp-openedchat").css({"display":"block"});
                $(".whatsapp-openedchat").css({left: 0+"vh"});
                $(".whatsapp-chats").animate({left: 30+"vh"},100, function(){
                    $(".whatsapp-chats").css({"display":"none"});
                });
                $(".whatsapp-contacts").animate({
                    bottom: -70+"vh"
                }, 200, function(){
                    $(".whatsapp-contacts").css({"display":"none"});
                });
            }, 400)
        } else {
            QB.Phone.Notifications.Add("fa fa-phone-alt", "Telefone", 'Mensagem',"Não podes enviar mensagens a ti próprio...", "#1DA1F2");
        }
        return;
    }

    if (contactId != undefined && !SelectedGroupContacts[contactId]) {
        SelectedGroupContacts[contactId] = true;
        $(e.target).find('.contact-checked').css({"display":"block"});
        $(e.target).find('.contact-checked').animate({
            width: 2+"vh",
            height: 2+"vh"
        },100);
    } else if (contactId != undefined) {
        SelectedGroupContacts[contactId] = false;
        $(e.target).find('.contact-checked').animate({
            width: 0+"vh",
            height: 0+"vh"
        }, 100, function(){
            $(e.target).find('.contact-checked').css({"display":"none"});
        });
    }

    let j = 0;

    $.each(SelectedGroupContacts, function(i, contact){
        if (contact){
            j++;
        }
    });

    if (j >= 2 && !CreateGroupButton){
        CreateGroupButton = true;
        $('.whatsapp-create-button').css({"display":"block"});
        $('.whatsapp-create-button').animate({
            width: 4.8+"vh",
            height: 4.8+"vh"
        },100);
    } else if(j < 2 && CreateGroupButton){
        CreateGroupButton = false;
        $('.whatsapp-create-button').animate({
            width: 0+"vh",
            height: 0+"vh"
        }, 100, function(){
            $('.whatsapp-create-button').css({"display":"none"});
        });
    }
});

$(document).on('click', '.whatsapp-create-button', function(e){
    e.preventDefault();

    console.log('cria grupo')
});

$(document).on('click', '.whatsapp-chat', function(e){
    e.preventDefault();

    var ChatId = $(this).attr('id');
    var ChatData = $("#"+ChatId).data('chatdata');

    refreshOpenedChatMessages(ChatData.number);

    $.post('http://cphone/ClearAlerts', JSON.stringify({
        number: ChatData.number
    }));

    if (WhatsappSearchActive) {
        $("#whatsapp-search-input").fadeOut(150);
    }

    $(".whatsapp-openedchat").css({"display":"block"});
    $(".whatsapp-openedchat").animate({
        left: 0+"vh"
    },200);
    
    $(".whatsapp-chats").animate({
        left: 30+"vh"
    },200, function(){
        $(".whatsapp-chats").css({"display":"none"});
    });

    $('.whatsapp-openedchat-messages').animate({scrollTop: $('.whatsapp-openedchat-messages')[0].scrollHeight}, 150);

    if (OpenedChatPicture == null) {
        OpenedChatPicture = "./img/default.png";
        if (ChatData.picture != null || ChatData.picture != undefined || ChatData.picture != "default") {
            OpenedChatPicture = ChatData.picture
        }
        $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
    }
});

$(document).on('click', '#whatsapp-openedchat-back', function(e){
    e.preventDefault();
    refreshLatestMessages();
    OpenedChatData.number = null;
    $(".whatsapp-chats").css({"display":"block"});
    $(".whatsapp-chats").animate({
        left: 0+"vh"
    }, 200);
    $(".whatsapp-openedchat").animate({
        left: -30+"vh"
    }, 200, function(){
        $(".whatsapp-openedchat").css({"display":"none"});
    });
    OpenedChatPicture = null;
});

$(document).on('click', '.whatsapp-image-message', function(e){
    let src = $(this).attr('src')

    viewFullScreenImage(src);
});

function convertUnixToDate(unix) {
    let milliseconds = unix // 1575909015000
	let dateObject = new Date(milliseconds)

	return {
		day: dateObject.toLocaleString("pt-PT", {day: "numeric"}), // 9
		month: dateObject.toLocaleString("pt-PT", {month: "numeric"}), // 1
		year: dateObject.toLocaleString("pt-PT", {year: "numeric"}), // 2019
		hour: dateObject.toLocaleString("pt-PT", {hour: "numeric"}), // 10 AM
		minute: (dateObject.getMinutes()<10?'0':'') + dateObject.getMinutes(), // 30
		second: dateObject.toLocaleString("pt-PT", {second: "numeric"}), // 15
	}
}


QB.Phone.Functions.ReloadWhatsappAlerts = function(chats) {
    $.each(chats, function(i, chat){
        if (chat.Unread > 0 && chat.Unread !== undefined && chat.Unread !== null) {
            $(".unread-chat-id-"+i).html(chat.Unread);
            $(".unread-chat-id-"+i).css({"display":"block"});
        } else {
            $(".unread-chat-id-"+i).css({"display":"none"});
        }
    });
}

GetCurrentDateKey = function() {
    var CurrentDate = new Date();
    var CurrentMonth = CurrentDate.getMonth();
    var CurrentDOM = CurrentDate.getDate();
    var CurrentYear = CurrentDate.getFullYear();
    var CurDate = ""+CurrentDOM+"-"+CurrentMonth+"-"+CurrentYear+"";

    return CurDate;
}

const monthNames = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];

FormatChatDate = function(date) {
    let NewDate = new Date(date)

    var CurrentMonth = monthNames[NewDate.getMonth()];
    var CurrentDOM = NewDate.getDate();
    var CurrentYear = NewDate.getFullYear();
    var CurDateee = CurrentDOM + "-" + NewDate.getMonth() + "-" + CurrentYear;
    var ChatDate = CurrentDOM + " " + CurrentMonth + " " + CurrentYear;
    var CurrentDate = GetCurrentDateKey();

    var ReturnedValue = ChatDate;
    if (CurrentDate == CurDateee) {
        ReturnedValue = "Hoje";
    }

    return ReturnedValue;
}

FormatMessageTime = function() {
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    if (NewHour < 10) {
        Hourssssss = "0" + NewHour;
    }
    var MessageTime = Hourssssss + ":" + Minutessss
    return MessageTime;
}

$(document).on('click', '#whatsapp-openedchat-send', function(e){
    e.preventDefault();

    var Message = $("#whatsapp-openedchat-message").val();

    if (Message !== null && Message !== undefined && Message !== "") {
        $.post('http://cphone/SendMessage', JSON.stringify({
            ChatNumber: OpenedChatData.number,
            ChatMessage: Message,
            ChatType: "message",
        }));
        $("#whatsapp-openedchat-message").val("");
    } else {
        QB.Phone.Notifications.Add("fa fa-whatsapp", "Mensagens", 'Mensagem',"Não podes enviar mensagens em branco!", "#25D366");
    }
});

$(document).on('keypress', function (e) {
    if (OpenedChatData.number !== null) {
        if(e.which === 13){
            var Message = $("#whatsapp-openedchat-message").val();
    
            if (Message !== null && Message !== undefined && Message !== "") {
                $.post('http://cphone/SendMessage', JSON.stringify({
                    ChatNumber: OpenedChatData.number,
                    ChatMessage: Message,
                    ChatType: "message",
                }));
                $("#whatsapp-openedchat-message").val("");
            } else {
                QB.Phone.Notifications.Add("fa fa-whatsapp", "Mensagens", 'Mensagem',"Não podes enviar mensagens em branco!", "#25D366");
            }
        }
    }
});

$(document).on('click', '#send-location', function(e){
    e.preventDefault();

    $.post('http://cphone/SendMessage', JSON.stringify({
        ChatNumber: OpenedChatData.number,
        ChatMessage: "Coordenadas GPS",
        ChatType: "location",
    }));
});



$(document).on('click', '#delete-messages', function(e){
    e.preventDefault();

    $(".whatsapp-openedchat-popup").fadeIn(250);
});

$(document).on('click', '.whatsapp-openedchat-popup-cancel', function(e){
    e.preventDefault();

    $(".whatsapp-openedchat-popup").fadeOut(250);
});

$(document).on('click', '.whatsapp-openedchat-popup-accept', function(e){
    e.preventDefault();

    $(".whatsapp-openedchat-popup").fadeOut(250);

    $.post('http://cphone/DeleteMessages', JSON.stringify({
        ChatNumber: OpenedChatData.number,
    }));

    setTimeout(function() {
        refreshLatestMessages();
        OpenedChatData.number = null;
        $(".whatsapp-chats").css({"display":"block"});
        $(".whatsapp-chats").animate({
            left: 0+"vh"
        }, 200);
        $(".whatsapp-openedchat").animate({
            left: -30+"vh"
        }, 200, function(){
            $(".whatsapp-openedchat").css({"display":"none"});
        });
        OpenedChatPicture = null;
    }, 750);
});

$(document).on('click', "#whatsapp-openedchat-callnumber", function(e){
    e.preventDefault();

    $('.phone-application-container').animate({
        top: -160+"%"
    });

    setTimeout(function(){
        QB.Phone.Functions.ToggleApp("whatsapp", "none");
        QB.Phone.Data.currentApplication = null;

        setupCall({number: OpenedChatData.number, name: isNumberInContacts(OpenedChatData.number) || OpenedChatData.number}, false);
    }, 400)
});

$(document).on('click', "#whatsapp-openedchat-addcontact", function(e){
    e.preventDefault();

    //console.log(OpenedChatData.number);

    $('.phone-application-container').animate({
        top: -160+"%"
    });
    QB.Phone.Functions.HeaderTextColor("white", 400);
    setTimeout(function(){
        $('.phone-application-container').animate({
            top: 0+"%"
        });

        QB.Phone.Functions.ToggleApp("whatsapp", "none");
        QB.Phone.Functions.ToggleApp("phone", "block");
        QB.Phone.Data.currentApplication = "phone";

        if (!$(".phone-keypad-addcontact").hasClass("phone-keypad-hascontact")) {
            $(".phone-add-contact-number").val(OpenedChatData.number);
            $(".phone-add-contact").addClass("phone-add-contact-show");
        }

        OpenedChatData.number = null;
        $(".whatsapp-chats").css({"display":"block"});
        $(".whatsapp-chats").animate({
            left: 0+"vh"
        }, 200);
        $(".whatsapp-openedchat").animate({
            left: -30+"vh"
        }, 200, function(){
            $(".whatsapp-openedchat").css({"display":"none"});
        });
        OpenedChatPicture = null;

    }, 400)
});

QB.Phone.Functions.SetupChatMessages = function(cData, NewChatData) {
    if (cData) {
        OpenedChatData.number = cData.number;

        if (OpenedChatPicture == null) {
            $.post('http://cphone/GetProfilePicture', JSON.stringify({
                number: OpenedChatData.number,
            }), function(picture){
                OpenedChatPicture = "./img/default.png";
                if (picture != "default" && picture != null) {
                    OpenedChatPicture = picture
                }
                $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
            });
        } else {
            $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
        }

        if (cData.display === undefined) {
            cData.display = OpenedChatData.number;
        }

        //console.log('cData: ' + cData.name);
        $(".whatsapp-openedchat-name").html("<p>"+cData.display+"</p>");

        $.post('http://cphone/IsNumberInContacts', JSON.stringify({
            Number: OpenedChatData.number,
        }), function(IsNumberInContacts){
            //console.log(IsNumberInContacts);
            if (IsNumberInContacts) {
                $('#whatsapp-openedchat-addcontact').css({"display": "none"});
            } else {
                $('#whatsapp-openedchat-addcontact').css({"display": "block"});
            }
        });

        $(".whatsapp-openedchat-messages").html("");

        let i = 0
        let ChatDate = ''

        $.each(allmessages, function(j, message){
            if (message.transmitter == OpenedChatData.number || message.receiver == OpenedChatData.number) {
                let Sender = "other";
                let MessageElement
                let date = convertUnixToDate(message.time);
                let sepDate = FormatChatDate(message.time)

                if (ChatDate !== sepDate) {
                    ChatDate = sepDate;
                    let ChatDiv = '<div class="whatsapp-openedchat-messages-'+i+' unique-chat"><div class="whatsapp-openedchat-date">'+ChatDate+'</div></div>';
                    $(".whatsapp-openedchat-messages").append(ChatDiv);
                    i++;
                }

                if (message.owner) { Sender = "me"; }
                if (message.type === null) { message.type = "message"; }

                if (message.type == "message") {
                    MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+' whatsapp-shared-message"><span>'+message.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")+'</span><div class="whatsapp-openedchat-message-time">'+date.hour+':'+date.minute+'</div></div><div class="clearfix"></div>'
                } else if (message.type == "location") {
                    let coords = JSON.parse(message.message);
                    MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+' whatsapp-shared-location" data-x="'+coords.x+'" data-y="'+coords.y+'"><span style="font-size: 1.2vh;"><i class="fas fa-thumbtack" style="font-size: 1vh;"></i> Coordenadas GPS</span><div class="whatsapp-openedchat-message-time">'+date.hour+':'+date.minute+'</div></div><div class="clearfix"></div>'
                }  else if (message.type == "audio") {
                    MessageElement = /*html*/`
                        <div class="whatsapp-openedchat-message whatsapp-openedchat-message-${Sender}">
                            <audio controls class="whatsapp-audio-message" preload="auto" controlsList="nodownload noplaybackspeed">
                                <source src="${message.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")}" type="audio/wav">
                                Your browser does not support the audio tag.
                            </audio>
                            <div class="whatsapp-openedchat-message-time">${date.hour}:${date.minute}</div></div><div class="clearfix">
                        </div>`
                }  else if (message.type == "image") {
                    MessageElement = /*html*/`
                        <div class="whatsapp-openedchat-message whatsapp-openedchat-message-${Sender}">
                            <img src="${message.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")}" class="whatsapp-image-message">
                            <div class="whatsapp-openedchat-message-time">${date.hour}:${date.minute}</div></div><div class="clearfix">
                        </div>`
                }  else if (message.type == "video") {
                    MessageElement = /*html*/`
                        <div class="whatsapp-openedchat-message whatsapp-openedchat-message-${Sender}">
                            <video src="${message.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")}" class="whatsapp-video-message" controls controlsList="nodownload noplaybackspeed nofullscreen"></video>
                            <div class="whatsapp-openedchat-message-time">${date.hour}:${date.minute}</div></div><div class="clearfix">
                        </div>`
                }

                $(".whatsapp-openedchat-messages-"+(i-1)).append(MessageElement);
            }
        });

        $('.whatsapp-openedchat-messages').animate({scrollTop: $('.whatsapp-openedchat-messages')[0].scrollHeight}, 1);
    } else {
        OpenedChatData.number = NewChatData.number;
        if (OpenedChatPicture == null) {
            $.post('http://cphone/GetProfilePicture', JSON.stringify({
                number: OpenedChatData.number,
            }), function(picture){
                OpenedChatPicture = "./img/default.png";
                if (picture != "default" && picture != null) {
                    OpenedChatPicture = picture
                }
                $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
            });
        }

        //console.log('NewChatData: ' + NewChatData.name);

        $(".whatsapp-openedchat-name").html("<p>"+NewChatData.name+"</p>");
        $(".whatsapp-openedchat-messages").html("");
        var NewDate = new Date();
        var NewDateMonth = NewDate.getMonth();
        var NewDateDOM = NewDate.getDate();
        var NewDateYear = NewDate.getFullYear();
        var DateString = ""+NewDateDOM+"-"+(NewDateMonth+1)+"-"+NewDateYear;
        var ChatDiv = '<div class="whatsapp-openedchat-messages-'+DateString+' unique-chat"><div class="whatsapp-openedchat-date">TODAY</div></div>';

        $(".whatsapp-openedchat-messages").append(ChatDiv);
    }

    $('.whatsapp-openedchat-messages').animate({scrollTop: $('.whatsapp-openedchat-messages')[0].scrollHeight}, 1);
}

$(document).on('click', '.whatsapp-shared-location', function(e){
    e.preventDefault();
    var messageCoords = {}
    messageCoords.x = $(this).data('x');
    messageCoords.y = $(this).data('y');

    $.post('http://cphone/SharedLocation', JSON.stringify({
        coords: messageCoords,
    }))
});

$(document).on('click', '.whatsapp-shared-message', function(e){
    e.preventDefault();
    let copyText = $(this).find("span").text();

    //whatsapp-unique-message

    copyStringToClipboard(copyText);

    QB.Phone.Notifications.Add("fa fa-whatsapp", "Mensagens", 'Mensagem',"Mensagem copiada!", "#25D366");
});

var ExtraButtonsOpen = false;

$(document).on('click', '#whatsapp-openedchat-message-extras', function(e){
    e.preventDefault();

    if (!ExtraButtonsOpen) {
        $(".whatsapp-extra-buttons").css({"display":"block"}).animate({
            left: 0+"vh"
        }, 250);
        ExtraButtonsOpen = true;
    } else {
        $(".whatsapp-extra-buttons").animate({
            left: -10+"vh"
        }, 250, function(){
            $(".whatsapp-extra-buttons").css({"display":"block"});
            ExtraButtonsOpen = false;
        });
    }
});


let isRecordingAudio = false;

$(document).on('click', '.whatsapp-openedchat-audio', function(e){
    e.preventDefault();

    if (!isRecordingAudio) {
        isRecordingAudio = true;
        $(".whatsapp-openedchat-audio").addClass("whatsapp-openedchat-audio-recording");
        $("#audio-trash").fadeIn(250);
        startAudioRecording();
    } else {
        isRecordingAudio = false;
        $(".whatsapp-openedchat-audio").removeClass("whatsapp-openedchat-audio-recording");
        $("#audio-trash").fadeOut(250);
        stopAudioRecording();
    }
});

$(document).on('click', '#audio-trash', function(e){
    e.preventDefault();

    isRecordingAudio = false;
    $(".whatsapp-openedchat-audio").removeClass("whatsapp-openedchat-audio-recording");
    $("#audio-trash").fadeOut(250);
    cancelAudioRecording();
});

function loadLatestMessages(messages) {
    let chats = messages.map(x => {
        let display = x.transmitter;
        let contact = isNumberInContacts(x.transmitter);

        let unknowContact = contact === undefined;
        if (!unknowContact) {
            display = contact;
        }

        let keyDesc = x.message;
        if (x.type === "location") keyDesc = "Localização";
        else if (x.type === "audio") keyDesc = "Áudio";
        else if (x.type === "image") keyDesc = "Imagem";
        else if (x.type === "video") keyDesc = "Vídeo";

        return {
            display,
            puce: x.isRead === 0 ? 1 : 0, // backend guarantees last message only
            number: x.transmitter,
            lastMessage: x.time,
            keyDesc,
            unknowContact
        };
    });

    chats.sort((a, b) => b.lastMessage - a.lastMessage);

    $(".whatsapp-chats").html("");

    $.each(chats, function (i, chat) {
        let profilepicture = "./img/default.png";
        let lastMessage = convertUnixToDate(chat.lastMessage);

        let ChatElement = /*html*/`
            <div class="whatsapp-chat" id="whatsapp-chat-${chat.number}">
                <div class="whatsapp-chat-picture" style="background-image: url(${profilepicture});"></div>
                <div class="whatsapp-chat-name"><p>${chat.display}</p></div>
                <div class="whatsapp-chat-lastmessage">
                    <p>${chat.keyDesc.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</p>
                </div>
                <div class="whatsapp-chat-lastmessagetime">
                    <p>${lastMessage.hour}:${lastMessage.minute}</p>
                </div>
                <div class="whatsapp-chat-unreadmessages unread-chat-id-${chat.number}"></div>
            </div>`;

        $(".whatsapp-chats").append(ChatElement);
        $( `#whatsapp-chat-${chat.number}`).data("chatdata", chat);

        if (chat.puce > 0) {
            $(".unread-chat-id-" + chat.number)
                .html(chat.puce)
                .css({ display: "block" });
        } else {
            $(".unread-chat-id-" + chat.number).css({ display: "none" });
        }
    });
}

function loadMessagesFromPhoneNumber(number, messages) {
    OpenedChatData.number = number;

    messages = messages.reverse();

    // Load profile picture
    if (OpenedChatPicture == null) {
        $.post('http://cphone/GetProfilePicture', JSON.stringify({ number }), function (picture) {
            OpenedChatPicture = "./img/default.png";
            if (picture && picture !== "default") {
                OpenedChatPicture = picture;
            }
            $(".whatsapp-openedchat-picture")
                .css({ "background-image": `url(${OpenedChatPicture})` });
        });
    } else {
        $(".whatsapp-openedchat-picture")
            .css({ "background-image": `url(${OpenedChatPicture})` });
    }

    // Chat name
    let display = number;
    let contact = isNumberInContacts(number);
    if (contact !== undefined) display = contact;

    $(".whatsapp-openedchat-name").html(`<p>${display}</p>`);

    // Add contact button
    $.post('http://cphone/IsNumberInContacts', JSON.stringify({ Number: number }), function (exists) {
        $('#whatsapp-openedchat-addcontact')
            .css({ display: exists ? "none" : "block" });
    });

    // Clear messages
    $(".whatsapp-openedchat-messages").html("");

    let ChatDate = "";
    let groupIndex = 0;

    // Messages should already be ordered ASC by time
    messages.forEach(message => {
        let Sender = message.owner ? "me" : "other";
        let date = convertUnixToDate(message.time);
        let sepDate = FormatChatDate(message.time);

        // Date separator
        if (ChatDate !== sepDate) {
            ChatDate = sepDate;
            let ChatDiv = `
                <div class="whatsapp-openedchat-messages-${groupIndex} unique-chat">
                    <div class="whatsapp-openedchat-date">${ChatDate}</div>
                </div>`;
            $(".whatsapp-openedchat-messages").append(ChatDiv);
            groupIndex++;
        }

        let safeMessage = message.message
            ? message.message.replace(/</g, "&lt;").replace(/>/g, "&gt;")
            : "";

        let MessageElement = "";

        switch (message.type || "message") {
            case "message":
                MessageElement = `
                    <div class="whatsapp-openedchat-message whatsapp-openedchat-message-${Sender}">
                        <span>${safeMessage}</span>
                        <div class="whatsapp-openedchat-message-time">${date.hour}:${date.minute}</div>
                    </div><div class="clearfix"></div>`;
                break;

            case "location":
                let coords = JSON.parse(message.message);
                MessageElement = `
                    <div class="whatsapp-openedchat-message whatsapp-openedchat-message-${Sender} whatsapp-shared-location"
                         data-x="${coords.x}" data-y="${coords.y}">
                        <span><i class="fas fa-thumbtack"></i> Coordenadas GPS</span>
                        <div class="whatsapp-openedchat-message-time">${date.hour}:${date.minute}</div>
                    </div><div class="clearfix"></div>`;
                break;

            case "audio":
                MessageElement = `
                    <div class="whatsapp-openedchat-message whatsapp-openedchat-message-${Sender}">
                        <audio controls class="whatsapp-audio-message" preload="auto" controlsList="nodownload noplaybackspeed">
                            <source src="${safeMessage}" type="audio/wav">
                        </audio>
                        <div class="whatsapp-openedchat-message-time">${date.hour}:${date.minute}</div>
                    </div><div class="clearfix"></div>`;
                break;

            case "image":
                MessageElement = `
                    <div class="whatsapp-openedchat-message whatsapp-openedchat-message-${Sender}">
                        <img src="${safeMessage}" class="whatsapp-image-message">
                        <div class="whatsapp-openedchat-message-time">${date.hour}:${date.minute}</div>
                    </div><div class="clearfix"></div>`;
                break;

            case "video":
                MessageElement = `
                    <div class="whatsapp-openedchat-message whatsapp-openedchat-message-${Sender}">
                        <video src="${safeMessage}" class="whatsapp-video-message" controls controlsList="nodownload noplaybackspeed nofullscreen"></video>
                        <div class="whatsapp-openedchat-message-time">${date.hour}:${date.minute}</div>
                    </div><div class="clearfix"></div>`;
                break;
        }

        $( `.whatsapp-openedchat-messages-${groupIndex - 1}`).append(MessageElement);
    });

    // Scroll to bottom
    $('.whatsapp-openedchat-messages')
        .animate({ scrollTop: $('.whatsapp-openedchat-messages')[0].scrollHeight }, 1);
}


function refreshLatestMessages() {
    $.post('http://cphone/getLatestMessages', JSON.stringify({}));
}

function refreshOpenedChatMessages(number) {
    $.post('http://cphone/getMessagesFromPhoneNumber', JSON.stringify({
        number: number,
    }));
}

function OpenMessagesApp() {
    refreshLatestMessages();
}


$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "UpdateChat":
                if (QB.Phone.Data.currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                        console.log('Chat reloaded')
                        refreshLatestMessages();
                        refreshOpenedChatMessages(OpenedChatData.number);

                        $.post('http://cphone/ClearAlerts', JSON.stringify({
                            number: event.data.chatNumber
                        }));
                    } else {
                        console.log('Chats reloaded')
                        refreshLatestMessages();
                    }
                }
                break;
            case "RefreshWhatsappAlerts":
                //QB.Phone.Functions.ReloadWhatsappAlerts();
                break;
            case "loadLatestMessages":
                loadLatestMessages(event.data.messages);
                break;
            case "loadMessagesFromPhoneNumber":
                loadMessagesFromPhoneNumber(event.data.number, event.data.messages);
                break;
        }
    })
});

//Controller

/** Stores the actual start time when an audio recording begins to take place to ensure elapsed time start time is accurate*/
var audioRecordStartTime;

/** Stores the maximum recording time in hours to stop recording once maximum recording hour has been reached */
var maximumRecordingTimeInHours = 1;

/** Stores the reference of the setInterval function that controls the timer in audio recording*/
var elapsedTimeTimer;

/** Starts the audio recording*/
function startAudioRecording() {

    //console.log("Recording Audio...");

    //start recording using the audio recording API
    audioRecorder.start()
        .then(() => { //on success

            //store the recording start time to display the elapsed time according to it
            audioRecordStartTime = new Date();

            //display control buttons to offer the functionality of stop and cancel
            //handleDisplayingRecordingControlButtons();
        })
        .catch(error => { //on error
            //No Browser Support Error
            if (error.message.includes("mediaDevices API or getUserMedia method is not supported in this browser.")) {
                console.log("To record audio, use browsers like Chrome and Firefox.");
                //displayBrowserNotSupportedOverlay();
            }

            //Error handling structure
            switch (error.name) {
                case 'AbortError': //error from navigator.mediaDevices.getUserMedia
                    console.log("An AbortError has occured.");
                    break;
                case 'NotAllowedError': //error from navigator.mediaDevices.getUserMedia
                    console.log("A NotAllowedError has occured. User might have denied permission.");
                    break;
                case 'NotFoundError': //error from navigator.mediaDevices.getUserMedia
                    console.log("A NotFoundError has occured.");
                    break;
                case 'NotReadableError': //error from navigator.mediaDevices.getUserMedia
                    console.log("A NotReadableError has occured.");
                    break;
                case 'SecurityError': //error from navigator.mediaDevices.getUserMedia or from the MediaRecorder.start
                    console.log("A SecurityError has occured.");
                    break;
                case 'TypeError': //error from navigator.mediaDevices.getUserMedia
                    console.log("A TypeError has occured.");
                    break;
                case 'InvalidStateError': //error from the MediaRecorder.start
                    console.log("An InvalidStateError has occured.");
                    break;
                case 'UnknownError': //error from the MediaRecorder.start
                    console.log("An UnknownError has occured.");
                    break;
                default:
                    console.log("An error occured with the error name " + error.name);
            };
        });
}

/** Cancel the currently started audio recording */
function cancelAudioRecording() {
    //console.log("Canceling audio...");

    //cancel the recording using the audio recording API
    audioRecorder.cancel();

    //hide recording control button & return record icon
    //handleHidingRecordingControlButtons();
}

/** Stop the currently started audio recording & sends it
 */
function stopAudioRecording() {

    //console.log("Stopping Audio Recording...");

    //stop the recording using the audio recording API
    audioRecorder.stop()
        .then(audioAsblob => {
            //Play recorder audio
            //playAudio(audioAsblob);

            const formData = new FormData(); 
            formData.append("file",audioAsblob,"audio.wav");
    
            fetch("https://cdn.Sem Destinorp.net/files/upload", {
                method: 'POST',
                mode: 'cors',
                body: formData
            }).then(response => response.text())
            .then(text => {
                let textparse = JSON.parse(text);
                
                $.post('http://cphone/SendMessage', JSON.stringify({
                    ChatNumber: OpenedChatData.number,
                    ChatMessage: textparse.url,
                    ChatType: "audio",
                }));
            });

            //hide recording control button & return record icon
           // handleHidingRecordingControlButtons();
        })
        .catch(error => {
            //Error handling structure
            switch (error.name) {
                case 'InvalidStateError': //error from the MediaRecorder.stop
                    console.log("An InvalidStateError has occured.");
                    break;
                default:
                    console.log("An error occured with the error name " + error.name);
            };
        });
}

/** Computes the elapsedTime since the moment the function is called in the format mm:ss or hh:mm:ss
 * @param {String} startTime - start time to compute the elapsed time since
 * @returns {String} elapsed time in mm:ss format or hh:mm:ss format, if elapsed hours are 0.
 */
function computeElapsedTime(startTime) {
    //record end time
    let endTime = new Date();

    //time difference in ms
    let timeDiff = endTime - startTime;

    //convert time difference from ms to seconds
    timeDiff = timeDiff / 1000;

    //extract integer seconds that dont form a minute using %
    let seconds = Math.floor(timeDiff % 60); //ignoring uncomplete seconds (floor)

    //pad seconds with a zero if neccessary
    seconds = seconds < 10 ? "0" + seconds : seconds;

    //convert time difference from seconds to minutes using %
    timeDiff = Math.floor(timeDiff / 60);

    //extract integer minutes that don't form an hour using %
    let minutes = timeDiff % 60; //no need to floor possible incomplete minutes, becase they've been handled as seconds
    minutes = minutes < 10 ? "0" + minutes : minutes;

    //convert time difference from minutes to hours
    timeDiff = Math.floor(timeDiff / 60);

    //extract integer hours that don't form a day using %
    let hours = timeDiff % 24; //no need to floor possible incomplete hours, becase they've been handled as seconds

    //convert time difference from hours to days
    timeDiff = Math.floor(timeDiff / 24);

    // the rest of timeDiff is number of days
    let days = timeDiff; //add days to hours

    let totalHours = hours + (days * 24);
    totalHours = totalHours < 10 ? "0" + totalHours : totalHours;

    if (totalHours === "00") {
        return minutes + ":" + seconds;
    } else {
        return totalHours + ":" + minutes + ":" + seconds;
    }
}

// audio-recording.js ---------------
//API to handle audio recording 

var audioRecorder = {
    /** Stores the recorded audio as Blob objects of audio data as the recording continues*/
    audioBlobs: [],/*of type Blob[]*/
    /** Stores the reference of the MediaRecorder instance that handles the MediaStream when recording starts*/
    mediaRecorder: null, /*of type MediaRecorder*/
    /** Stores the reference to the stream currently capturing the audio*/
    streamBeingCaptured: null, /*of type MediaStream*/
    /** Start recording the audio 
     * @returns {Promise} - returns a promise that resolves if audio recording successfully started
     */
    start: function () {
        //Feature Detection
        if (!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia)) {
            //Feature is not supported in browser
            //return a custom error
            return Promise.reject(new Error('mediaDevices API or getUserMedia method is not supported in this browser.'));
        }

        else {
            //Feature is supported in browser

            //create an audio stream
            return navigator.mediaDevices.getUserMedia({ audio: true }/*of type MediaStreamConstraints*/)
                //returns a promise that resolves to the audio stream
                .then(stream /*of type MediaStream*/ => {

                    //save the reference of the stream to be able to stop it when necessary
                    audioRecorder.streamBeingCaptured = stream;

                    //create a media recorder instance by passing that stream into the MediaRecorder constructor
                    audioRecorder.mediaRecorder = new MediaRecorder(stream); /*the MediaRecorder interface of the MediaStream Recording
                    API provides functionality to easily record media*/

                    //clear previously saved audio Blobs, if any
                    audioRecorder.audioBlobs = [];

                    //add a dataavailable event listener in order to store the audio data Blobs when recording
                    audioRecorder.mediaRecorder.addEventListener("dataavailable", event => {
                        //store audio Blob object
                        audioRecorder.audioBlobs.push(event.data);
                    });

                    //start the recording by calling the start method on the media recorder
                    audioRecorder.mediaRecorder.start();
                });

            /* errors are not handled in the API because if its handled and the promise is chained, the .then after the catch will be executed*/
        }
    },
    /** Stop the started audio recording
     * @returns {Promise} - returns a promise that resolves to the audio as a blob file
     */
    stop: function () {
        //return a promise that would return the blob or URL of the recording
        return new Promise(resolve => {
            //save audio type to pass to set the Blob type
            let mimeType = audioRecorder.mediaRecorder.mimeType;

            //listen to the stop event in order to create & return a single Blob object
            audioRecorder.mediaRecorder.addEventListener("stop", () => {
                //create a single blob object, as we might have gathered a few Blob objects that needs to be joined as one
                let audioBlob = new Blob(audioRecorder.audioBlobs, { type: "audio/wav" });
                
                //resolve promise with the single audio blob representing the recorded audio
                resolve(audioBlob);
            });
            audioRecorder.cancel();
        });
    },
    /** Cancel audio recording*/
    cancel: function () {
        //stop the recording feature
        audioRecorder.mediaRecorder.stop();

        //stop all the tracks on the active stream in order to stop the stream
        audioRecorder.stopStream();

        //reset API properties for next recording
        audioRecorder.resetRecordingProperties();
    },
    /** Stop all the tracks on the active stream in order to stop the stream and remove
     * the red flashing dot showing in the tab
     */
    stopStream: function () {
        //stopping the capturing request by stopping all the tracks on the active stream
        audioRecorder.streamBeingCaptured.getTracks() //get all tracks from the stream
            .forEach(track /*of type MediaStreamTrack*/ => track.stop()); //stop each one
    },
    /** Reset all the recording properties including the media recorder and stream being captured*/
    resetRecordingProperties: function () {
        audioRecorder.mediaRecorder = null;
        audioRecorder.streamBeingCaptured = null;

        /*No need to remove event listeners attached to mediaRecorder as
        If a DOM element which is removed is reference-free (no references pointing to it), the element itself is picked
        up by the garbage collector as well as any event handlers/listeners associated with it.
        getEventListeners(audioRecorder.mediaRecorder) will return an empty array of events.*/
    }
}
