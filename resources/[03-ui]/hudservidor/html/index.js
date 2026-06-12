let ranks = {};

function CloseShop() {
	$(".container").hide();
    $.post('https://hudservidor/CloseMenu', JSON.stringify({}));
}

$(document).keyup(function(e) {
     if (e.key === "Escape") {
        CloseShop()
    }
});

$(function () {
    window.addEventListener('message', function(event) {
        var data = event.data;
        $(".ranksmenu").html("");

        if (data.show === "kills") {
            $(".rankstitle").text("🔫 Kills Ranking");
            $(".container").show();
            for (var i = 0; i < data.ranks.length; i++) {
                if (data.ranks[i].top == 1) { 
                    $(".ranksmenu").append(/*html*/`
                        <div class="car">
                            <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                            <div class="car-name">Nome: ${data.ranks[i].name}</div>
                            <div class="car-info">Kills: ${data.ranks[i].kills}</div>
                            <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                            <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                            <div class="car-info4">TOP:🥇</div>
                        </div>
                    `);
                } else if (data.ranks[i].top == 2) {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Kills: ${data.ranks[i].kills}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP:🥈</div>
                    </div>
                `);
                } else if (data.ranks[i].top == 3) {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Kills: ${data.ranks[i].kills}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP:🥉</div>
                    </div>
                `);
                } else {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Kills: ${data.ranks[i].kills}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP: ${data.ranks[i].top}</div>
                    </div>
                `);
                }
            }
        }

        if (data.show === "mortes") {
            $(".rankstitle").text("🪦 Mortes Ranking");
            $(".container").show();
            for (var i = 0; i < data.ranks.length; i++) {
                if (data.ranks[i].top == 1) { 
                    $(".ranksmenu").append(/*html*/`
                        <div class="car">
                            <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                            <div class="car-name">Nome: ${data.ranks[i].name}</div>
                            <div class="car-info">Mortes: ${data.ranks[i].mortes}</div>
                            <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                            <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                            <div class="car-info4">TOP:🥇</div>
                        </div>
                    `);
                } else if (data.ranks[i].top == 2) {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Mortes: ${data.ranks[i].mortes}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP:🥈</div>
                    </div>
                `);
                } else if (data.ranks[i].top == 3) {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Mortes: ${data.ranks[i].mortes}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP:🥉</div>
                    </div>
                `);
                } else {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Mortes: ${data.ranks[i].mortes}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP: ${data.ranks[i].top}</div>
                    </div>
                `);
                }
            }
        }

        if (data.show === "farm") {
            $(".rankstitle").text("🌾 Farm Ranking");
            $(".container").show();
            for (var i = 0; i < data.ranks.length; i++) {
                if (data.ranks[i].top == 1) { 
                    $(".ranksmenu").append(/*html*/`
                        <div class="car">
                            <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                            <div class="car-name">Nome: ${data.ranks[i].name}</div>
                            <div class="car-info">Tempo: ${data.ranks[i].time}</div>
                            <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                            <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                            <div class="car-info4">TOP:🥇</div>
                        </div>
                    `);
                } else if (data.ranks[i].top == 2) {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Tempo: ${data.ranks[i].time}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP:🥈</div>
                    </div>
                `);
                } else if (data.ranks[i].top == 3) {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Tempo: ${data.ranks[i].time}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP:🥉</div>
                    </div>
                `);
                } else {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Tempo: ${data.ranks[i].time}</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP: ${data.ranks[i].top}</div>
                    </div>
                `);
                }
            }
        }

        if (data.show === "banco") {
            $(".rankstitle").text("€ Banco Ranking");
            $(".container").show();
            for (var i = 0; i < data.ranks.length; i++) {
                if (data.ranks[i].top == 1) { 
                    $(".ranksmenu").append(/*html*/`
                        <div class="car">
                            <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                            <div class="car-name">Nome: ${data.ranks[i].name}</div>
                            <div class="car-info">Banco: ${data.ranks[i].bank.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")}€</div>
                            <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                            <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                            <div class="car-info4">TOP:🥇</div>
                        </div>
                    `);
                } else if (data.ranks[i].top == 2) {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Banco: ${data.ranks[i].bank.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")}€</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP:🥈</div>
                    </div>
                `);
                } else if (data.ranks[i].top == 3) {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Banco: ${data.ranks[i].bank.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")}€</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP:🥉</div>
                    </div>
                `);
                } else {
                    $(".ranksmenu").append(/*html*/`
                    <div class="car">
                        <div class="car-image"><img src="${data.ranks[i].image}" loading="lazy"></div>
                        <div class="car-name">Nome: ${data.ranks[i].name}</div>
                        <div class="car-info">Banco: ${data.ranks[i].bank.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")}€</div>
                        <div class="car-info2">Steam: ${data.ranks[i].steamname}</div>
                        <div class="car-info3">Atividade: ${data.ranks[i].lastlogin}</div>
                        <div class="car-info4">TOP: ${data.ranks[i].top}</div>
                    </div>
                `);
                }
            }
        }

        if (event.data.disp != undefined) {
            let status = event.data.disp
            if (status) {
                $("body").show()
            } else {
                $("body").hide()
            }
        }
        if (event.data.id != undefined) {
            document.getElementById('id').innerHTML = event.data.id;
        }
        if (event.data.cash != undefined) {
            document.getElementById('mao').innerHTML = numberWithSpaces(event.data.cash);
        }
        if (event.data.black_money != undefined) {
            document.getElementById('sujo').innerHTML = numberWithSpaces(event.data.black_money);
        }
        if (event.data.bank != undefined) {
            document.getElementById('banco').innerHTML = numberWithSpaces(event.data.bank);
        }
        if (event.data.job != undefined) {
            document.getElementById('job').innerHTML = event.data.job;
        }
        if (event.data.society != undefined) {
            document.getElementById('society').innerHTML = numberWithSpaces(event.data.society);
        }
        if (event.data.soci != undefined) {
                HideShow(event.data.soci)
        }
    })
})

function HideShow(vari) {
    if(vari == true){
        document.getElementById("soci").style.display= "initial";
    }   
    else{ 
        document.getElementById("soci").style.display = "none";
    }
}
function HideShowGang(vari) {
    if(vari == true){
        document.getElementById("socigang").style.display= "initial";
    }   
    else{ 
        document.getElementById("socigang").style.display = "none";
    }
}

function numberWithSpaces(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}