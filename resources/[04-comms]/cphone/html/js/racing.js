var OpenedRaceElement = null;
let racePositions = [];

function updateRacePositions(positions) {
    racePositions = positions;
    UpdateRacePositionsUI();
}

$(document).ready(function(){
    $('[data-toggle="racetooltip"]').tooltip();
});

$(document).on('click', '.racing-race', function(e){
    e.preventDefault();

    var OpenSize = "12vh";
    var DefaultSize = "9vh";
    var RaceData = $(this).data('RaceData');
    var IsRacer = IsInRace(QB.Phone.Data.PlayerData.source, RaceData.players);
    var Creator = IsCreator(QB.Phone.Data.PlayerData.identifier, RaceData);

    if (IsRacer) {
        UpdateRacePositionsUI();
    }

    if (!RaceData.started || IsRacer) {
        if (OpenedRaceElement === null) {
            // Calculate expanded height based on positions
            var positionsCount = $(this).find('.race-position-item').length;
            var expandedHeight = 13 + (positionsCount * 2);
            $(this).css({"height": expandedHeight+"vh"});
            $(this).find('.race-positions').css("display", "flex");
            setTimeout(() => {
                $(this).find('.race-buttons').css("display", "flex").fadeIn(100);
            }, 100);
            OpenedRaceElement = this;
        } else if (OpenedRaceElement == this) {
            $(this).find('.race-buttons').fadeOut(20);
            $(this).find('.race-positions').css("display", "none");
            $(this).css({"height":DefaultSize});
            OpenedRaceElement = null;
        } else {
            $(OpenedRaceElement).find('.race-buttons').hide();
            $(OpenedRaceElement).find('.race-positions').css("display", "none");
            $(OpenedRaceElement).css({"height":DefaultSize});
            var positionsCount = $(this).find('.race-position-item').length;
            var expandedHeight = 12 + (positionsCount * 2);
            $(this).css({"height": expandedHeight+"vh"});
            $(this).find('.race-positions').css("display", "flex");
            setTimeout(() => {
                $(this).find('.race-buttons').css("display", "flex").fadeIn(100);
            }, 100);
            OpenedRaceElement = this;
        }
    } else {
        if (RaceData.started && Creator){
            if (OpenedRaceElement === null) {
                var positionsCount = $(this).find('.race-position-item').length;
                var expandedHeight = 12 + (positionsCount * 2);
                $(this).css({"height": expandedHeight+"vh"});
                $(this).find('.race-positions').css("display", "flex");
                setTimeout(() => {
                    $(this).find('.race-buttons').css("display", "flex").fadeIn(100);
                }, 100);
                OpenedRaceElement = this;
            } else if (OpenedRaceElement == this) {
                $(this).find('.race-buttons').fadeOut(20);
                $(this).find('.race-positions').css("display", "none");
                $(this).css({"height":DefaultSize});
                OpenedRaceElement = null;
            } else {
                $(OpenedRaceElement).find('.race-buttons').hide();
                $(OpenedRaceElement).find('.race-positions').css("display", "none");
                $(OpenedRaceElement).css({"height":DefaultSize});
                var positionsCount = $(this).find('.race-position-item').length;
                var expandedHeight = 12 + (positionsCount * 2);
                $(this).css({"height": expandedHeight+"vh"});
                $(this).find('.race-positions').css("display", "flex");
                setTimeout(() => {
                    $(this).find('.race-buttons').css("display", "flex").fadeIn(100);
                }, 100);
                OpenedRaceElement = this;
            }
        } else {
            QB.Phone.Notifications.Add("fas fa-flag-checkered", "Racing", "The race already started..", "#1DA1F2");
        }
    }
});

function GetAmountOfRacers(Racers) {
    var retval = 0
    $.each(Racers, function(i, racer){
        retval = retval + 1
    });
    return retval
}

function IsInRace(CitizenId, Racers) {
    var retval = false;
    $.each(Racers, function(cid, racer){
        if (racer == CitizenId) {
            retval = true;
        }
    });
    return retval
}

function IsCreator(CitizenId, RaceData) {
    var retval = false;
    if (RaceData.owner == CitizenId) {
        retval = true;
    }
    return retval;
}

function SetupRaces(Races) {
    $(".racing-races").html("");
    if (Races.length > 0) {
        Races = (Races).reverse();
        $.each(Races, function(i, race){
            var Locked = '<i class="fas fa-unlock"></i> Em espera';
            if (race.started) {
                Locked = '<i class="fas fa-lock"></i> A decorrer';
            }
            var LapLabel = "";
            if (race.laps == 0) {
                LapLabel = "SPRINT"
            } else {
                if (race.laps == 1) {
                    LapLabel = race.laps + " Volta";
                } else {
                    LapLabel = race.laps + " Voltas";
                }
            }
            var InRace = IsInRace(QB.Phone.Data.PlayerData.source, race.players);
            var Creator = IsCreator(QB.Phone.Data.PlayerData.identifier, race);
            var Buttons = '<div class="race-buttons"> <div class="race-button" id="join-race" data-toggle="racetooltip" data-placement="top" title="Juntar"><i class="fas fa-sign-in-alt"></i></div>';
            if (InRace) {
                if (!Creator) {
                    //console.log('not creator');
                    Buttons = '<div class="race-buttons"> <div class="race-button" id="quit-race" data-toggle="racetooltip" data-placement="top" title="Sair"><i class="fas fa-sign-out-alt"></i></div>';
                } else {
                    if (!race.started) {
                        //console.log('creator not started');
                        Buttons = '<div class="race-buttons"> <div class="race-button" id="start-race" data-toggle="racetooltip" data-placement="top" title="Começar"><i class="fas fa-flag-checkered"></i></div><div class="race-button" id="quit-race" data-toggle="racetooltip" data-placement="top" title="Sair"><i class="fas fa-sign-out-alt"></i></div> <div class="race-button" id="end-race" data-toggle="racetooltip" data-placement="top" title="Terminar"><i class="fas fa-trash"></i></div>';
                    } else {
                        //console.log('creator started');
                        Buttons = '<div class="race-buttons"> <div class="race-button" id="quit-race" data-toggle="racetooltip" data-placement="top" title="Sair"><i class="fas fa-sign-out-alt"></i></div> <div class="race-button" id="end-race" data-toggle="racetooltip" data-placement="top" title="Terminar"><i class="fas fa-trash"></i></div>';
                    }
                }
            } else {
                if (Creator){
                    if (!race.started) {
                        //console.log('creator not started');
                        Buttons = '<div class="race-buttons"> <div class="race-button" id="start-race" data-toggle="racetooltip" data-placement="top" title="Começar"><i class="fas fa-flag-checkered"></i></div><div class="race-button" id="join-race" data-toggle="racetooltip" data-placement="top" title="Juntar"><i class="fas fa-sign-in-alt"></i></div> <div class="race-button" id="end-race" data-toggle="racetooltip" data-placement="top" title="Terminar"><i class="fas fa-trash"></i></div>';
                    } else {
                        //console.log('creator started');
                        Buttons = '<div class="race-buttons"> <div class="race-button" id="end-race" data-toggle="racetooltip" data-placement="top" title="Terminar"><i class="fas fa-trash"></i></div>';
                    }
                }
            }
            var Racers = GetAmountOfRacers(race.players);
            var PositionsHtml = '<div class="race-positions"></div>';
            var element = '<div class="racing-race" id="raceid-'+i+'"> <span class="race-name"><i class="fas fa-flag-checkered"></i> '+race.raceName+'</span> <span class="race-track">'+Locked+'</span> <div class="race-infomation"> <div class="race-infomation-tab" id="race-information-laps">'+LapLabel+'</div> <div class="race-infomation-tab" id="race-information-player"><i class="fas fa-user"></i> '+Racers+'</div> </div> '+PositionsHtml+' '+Buttons+' </div> </div>';
            $(".racing-races").append(element);
            $("#raceid-"+i).data('RaceData', race);
            if (!race.started) {
                $("#raceid-"+i).css({"border-bottom-color":"rgb(212, 212, 212)"});
            } else {
                $("#raceid-"+i).css({"border-bottom-color":"rgb(212, 212, 212)"});
            }
            $('[data-toggle="racetooltip"]').tooltip();
        });
    }
}

function UpdateRacePositionsUI() {
    if (racePositions && racePositions.length > 0) {
        // Sort positions by lap (desc) then checkpoint (desc)
        var sortedPositions = racePositions.slice().sort(function(a, b) {
            if (a.lap !== b.lap) {
                return b.lap - a.lap; // Higher lap first
            }
            if (a.checkpoint !== b.checkpoint) {
                return b.checkpoint - a.checkpoint; // Higher checkpoint first
            }
            return a.time - b.time; // Earlier time first
        });
        
        // Find all expanded race elements and update their positions
        $('.racing-race').each(function() {
            var raceElement = $(this);
            var raceData = raceElement.data('RaceData');
            var InRace = IsInRace(QB.Phone.Data.PlayerData.source, raceData.players);

            if (!InRace) {
                return; // Skip if the player is not in this
            }
            
            // Only update if this race is started (active)
            if (raceData && raceData.started) {
                var positionsContainer = raceElement.find('.race-positions');
                positionsContainer.html('');
                
                $.each(sortedPositions, function(i, player) {
                    var lapInfo = player.lap > 0 ? ' (Volta ' + player.lap + ')' : '';
                    var positionElement = '<div class="race-position-item"><span class="position-number">'+(i+1)+'.</span> <span class="position-name">'+player.name+lapInfo+'</span></div>';
                    positionsContainer.append(positionElement);
                });
                
                // Update height if race is expanded
                if (raceElement.height() > 9) {
                    var positionsCount = sortedPositions.length;
                    var expandedHeight = 12 + (positionsCount * 2);
                    raceElement.css({"height": expandedHeight+"vh"});
                }
            }
        });
    }
}

$(document).ready(function(){
    $('[data-toggle="race-setup"]').tooltip();
});

$(document).on('click', '#join-race', function(e){
    e.preventDefault();

    var RaceId = $(this).parent().parent().attr('id');
    var Data = $("#"+RaceId).data('RaceData');

    //console.log(Data.id)

    $.post('http://cphone/IsInRace', JSON.stringify({id: Data.id}), function(IsInRace){  
        if (!IsInRace) {
            $.post('http://cphone/RaceDistanceCheckCanJoin', JSON.stringify({
                RaceId: Data.id,
                Joined: true,
            }), function(InDistance){
                if (InDistance) {
                    $.post('http://cphone/IsBusyCheck', JSON.stringify({
                        check: "editor"
                    }), function(IsBusy){
                        if (!IsBusy) {
                            $.post('http://cphone/JoinRace', JSON.stringify({
                                RaceId: Data.id,
                            }));
                            $.post('http://cphone/GetAvailableRaces', JSON.stringify({}), function(Races){
                                SetupRaces(Races);
                            });
                        } else {
                            QB.Phone.Notifications.Add("fas fa-flag-checkered", "Corridas", "Já estás no editor...", "#1DA1F2");
                        }
                    });
                }
            })
        } else {
            QB.Phone.Notifications.Add("fas fa-flag-checkered", "Corridas", "Já estás numa corrida...", "#1DA1F2");
        }
    });
});

$(document).on('click', '#quit-race', function(e){
    e.preventDefault();

    var RaceId = $(this).parent().parent().attr('id');
    var Data = $("#"+RaceId).data('RaceData');

    $.post('http://cphone/LeaveRace', JSON.stringify({
        RaceData: Data,
    }));

    $.post('http://cphone/GetAvailableRaces', JSON.stringify({}), function(Races){
        SetupRaces(Races);
    });
});

$(document).on('click', '#end-race', function(e){
    e.preventDefault();

    var RaceId = $(this).parent().parent().attr('id');
    var Data = $("#"+RaceId).data('RaceData');

    $.post('http://cphone/EndRace', JSON.stringify({
        RaceData: Data,
    }));

    $.post('http://cphone/GetAvailableRaces', JSON.stringify({}), function(Races){
        SetupRaces(Races);
    });
});

$(document).on('click', '#start-race', function(e){
    e.preventDefault();

    
    var RaceId = $(this).parent().parent().attr('id');
    var Data = $("#"+RaceId).data('RaceData');

    $.post('http://cphone/StartRace', JSON.stringify({
        RaceData: Data,
    }));

    $.post('http://cphone/GetAvailableRaces', JSON.stringify({}), function(Races){
        SetupRaces(Races);
    });
});

function secondsTimeSpanToHMS(s) {
    var h = Math.floor(s/3600); //Get whole hours
    s -= h*3600;
    var m = Math.floor(s/60); //Get remaining minutes
    s -= m*60;
    return h+":"+(m < 10 ? '0'+m : m)+":"+(s < 10 ? '0'+s : s); //zero padding on minutes and seconds
}


/*Dropdown Menu*/
$('.dropdown').click(function () {
    $(this).attr('tabindex', 1).focus();
    $(this).toggleClass('active');
    $(this).find('.dropdown-menu').slideToggle(300);
});
$('.dropdown').focusout(function () {
    $(this).removeClass('active');
    $(this).find('.dropdown-menu').slideUp(300);
});
$(document).on('click', '.dropdown .dropdown-menu li', function(e) {
    //$.post('http://cphone/GetTrackData', JSON.stringify({
     //   RaceId: $(this).attr('id')
    //}), function(TrackData){
        //if ((TrackData.CreatorData.charinfo.lastname).length > 8) {
        //   TrackData.CreatorData.charinfo.lastname = TrackData.CreatorData.charinfo.lastname.substring(0, 8);
        //}
        //var CreatorTag = 'Gonçalo Costa'//TrackData.CreatorData.charinfo.firstname.charAt(0).toUpperCase() + ". " + TrackData.CreatorData.charinfo.lastname;

        //$(".racing-setup-information-distance").html('Distance: '+50/*TrackData.Distance*/+' m');
        //$(".racing-setup-information-creator").html('Creator: ' + CreatorTag);
        //if (TrackData.Records.Holder !== undefined) {
        //    if (TrackData.Records.Holder[1].length > 8) {
        //        TrackData.Records.Holder[1] = TrackData.Records.Holder[1].substring(0, 8) + "..";
        //    }
        //    var Holder = TrackData.Records.Holder[0].charAt(0).toUpperCase() + ". " + TrackData.Records.Holder[1];
        //    $(".racing-setup-information-wr").html('WR: ' + secondsTimeSpanToHMS(TrackData.Records.Time) + ' ('+Holder+')');
        //} else {
            //$(".racing-setup-information-wr").html('WR: N/A');
        //}
    //});

    $(this).parents('.dropdown').find('span').text($(this).text());
    $(this).parents('.dropdown').find('input').attr('value', $(this).attr('id'));
});
/*End Dropdown Menu*/

$(document).on('click', '#setup-race', function(e){
    e.preventDefault();

    $(".racing-overview").animate({
        left: 30+"vh"
    }, 300);
    $(".racing-setup").animate({
        left: 0+"vh"
    }, 300);

    $.post('http://cphone/GetRaces', JSON.stringify({}), function(Races){
        if (Races !== undefined && Races !== null) {
            $(".dropdown-menu").html("");
            $.each(Races, function(i, race){
                //if (!race.Started && !race.Waiting) {
                    var elem = '<li id="'+race.id+'">'+race.raceName+'</li>';
                    $(".dropdown-menu").append(elem);
                //}
            });
        }
    });
});

$(document).on('click', '#create-race', function(e){
    e.preventDefault();
    $.post('http://cphone/IsAuthorizedToCreateRaces', JSON.stringify({}), function(data){
        if (data.IsAuthorized) {
            if (!data.IsBusy) {
                $.post('http://cphone/IsBusyCheck', JSON.stringify({
                    check: "race"
                }), function(InRace){
                    if (!InRace) {
                        $(".racing-create").fadeIn(200);
                    } else {
                        QB.Phone.Notifications.Add("fas fa-flag-checkered", "Corridas", "Já estás numa corrida..", "#1DA1F2");
                    }
                });
            } else {
                $.post('http://cphone/EndTrackEditor', JSON.stringify({}));
                //QB.Phone.Notifications.Add("fas fa-flag-checkered", "Racing", "You're already setting up a track..", "#1DA1F2");
            }
        } else {
            QB.Phone.Notifications.Add("fas fa-flag-checkered", "Corridas", "Não tens permissão para criar corridas...", "#1DA1F2");
        }
    });
});

$(document).on('click', '#racing-create-accept', function(e){
    e.preventDefault();
    var TrackName = $(".racing-create-trackname").val();

    if (TrackName !== "" && TrackName !== undefined && TrackName !== null) {
        $.post('http://cphone/IsAuthorizedToCreateRaces', JSON.stringify({
            TrackName: TrackName
        }), function(data){
            if (data.IsAuthorized) {
                if (data.IsNameAvailable) {
                    $.post('http://cphone/StartTrackEditor', JSON.stringify({
                        TrackName: TrackName
                    }));
                    $(".racing-create").fadeOut(200, function(){
                        $(".racing-create-trackname").val("");
                    });
                } else {
                    QB.Phone.Notifications.Add("fas fa-flag-checkered", "Corridas", "This name is not available..", "#1DA1F2");
                }
            } else {
                QB.Phone.Notifications.Add("fas fa-flag-checkered", "Corridas", "You don't have any rights to create Race Tracks..", "#1DA1F2");
            }
        });
    } else {
        QB.Phone.Notifications.Add("fas fa-flag-checkered", "Corridas", "You have to enter a track name..", "#1DA1F2");
    }
});

$(document).on('click', '#racing-create-cancel', function(e){
    e.preventDefault();
    $(".racing-create").fadeOut(200, function(){
        $(".racing-create-trackname").val("");
    });
});

$(document).on('click', '#setup-race-accept', function(e){
    e.preventDefault();

    var track = $('.dropdown').find('input').attr('value');
    var laps = $(".racing-setup-laps").val();

    if (laps <= 0){
        laps = 1;
    }

    $.post('http://cphone/HasCreatedRace', JSON.stringify({}), function(CanCreate){
        if (CanCreate) {
            $.post('http://cphone/RaceDistanceCheck', JSON.stringify({
                RaceId: track,
                Joined: false,
                AmountOfLaps: laps,
                enableNitro: document.getElementById('enableNitro').checked,
            }), function(InDistance){
                if (InDistance) {
                    $.post('http://cphone/GetAvailableRaces', JSON.stringify({}), function(Races){
                        SetupRaces(Races);
                    });
                    
                    $(".racing-overview").animate({
                        left: 0+"vh"
                    }, 300)
                    $(".racing-setup").animate({
                        left: -30+"vh"
                    }, 300, function(){
                        $(".racing-setup-laps").val("");
                        $('.dropdown').find('input').removeAttr('value');
                        $('.dropdown').find('span').text("Selecionar um percurso");
                    });
                }
            })
        } else {
            QB.Phone.Notifications.Add("fas fa-flag-checkered", "Corridas", "Já criaste uma corrida...", "#1DA1F2");
        }
    });
});

$(document).on('click', '#setup-race-cancel', function(e){
    e.preventDefault();

    $(".racing-overview").animate({
        left: 0+"vh"
    }, 300);
    $(".racing-setup").animate({
        left: -30+"vh"
    }, 300, function(){
        $(".racing-setup-information-distance").html('Selecionar um percurso');
        $(".racing-setup-information-creator").html('Selecionar um percurso');
        $(".racing-setup-information-wr").html('Selecionar um percurso');
        $(".racing-setup-laps").val("");
        $('.dropdown').find('input').removeAttr('value');
        $('.dropdown').find('span').text("Selecionar um percurso");
    });
});

$(document).on('click', '.racing-leaderboard-item', function(e){
    e.preventDefault();

    var Data = $(this).data('LeaderboardData');

    $(".racing-leaderboard-details-block-trackname").html('<i class="fas fa-flag-checkered"></i> '+Data.RaceName);
    $(".racing-leaderboard-details-block-list").html("");
    $.each(Data.LastLeaderboard, function(i, leaderboard){
        var lastname = leaderboard.Holder[1]
        var bestroundtime = "N/A";
        var place = i + 1;
        if (lastname.length > 10) {
            lastname = lastname.substring(0, 10) + "..."
        }
        if (leaderboard.BestLap !== "DNF") {
            bestroundtime = secondsTimeSpanToHMS(leaderboard.BestLap);
        } else {
            place = "DNF"
        }
        var elem = '<div class="row"> <div class="name">' + ((leaderboard.Holder[0]).charAt(0)).toUpperCase() + '. ' + lastname + '</div><div class="time">'+bestroundtime+'</div><div class="score">'+ place +'</div> </div>';
        $(".racing-leaderboard-details-block-list").append(elem);
    });
    $(".racing-leaderboard-details").fadeIn(200);
});

$(document).on('click', '.racing-leaderboard-details-back', function(e){
    e.preventDefault();

    $(".racing-leaderboard-details").fadeOut(200);
});

$(document).on('click', '.racing-leaderboards-button', function(e){
    e.preventDefault();

    $(".racing-leaderboard").animate({
        left: -30+"vh"
    }, 300)
    $(".racing-overview").animate({
        left: 0+"vh"
    }, 300)
});

$(document).on('click', '#leaderboards-race', function(e){
    e.preventDefault();

    $.post('http://cphone/GetRacingLeaderboards', JSON.stringify({}), function(Races){
        if (Races !== null) {
            $(".racing-leaderboards").html("");
            $.each(Races, function(i, race){
                if (race.LastLeaderboard.length > 0) {
                    var elem = '<div class="racing-leaderboard-item" id="leaderboard-item-'+i+'"> <span class="racing-leaderboard-item-name"><i class="fas fa-flag-checkered"></i> '+race.RaceName+'</span> <span class="racing-leaderboard-item-info">Click for more details</span> </div>'
                    $(".racing-leaderboards").append(elem);
                    $("#leaderboard-item-"+i).data('LeaderboardData', race);
                }
            });
        }
    });

    $(".racing-overview").animate({
        left: 30+"vh"
    }, 300)
    $(".racing-leaderboard").animate({
        left: 0+"vh"
    }, 300)
});
