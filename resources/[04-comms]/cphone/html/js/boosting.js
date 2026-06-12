$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .boosting-app {
            display: none;
            height: 100%;
            width: 100%;
            background: #0d1b2a;
            overflow: hidden;
        }

        .boosting-header {
            display: flex;
            color: white;
            margin-top: 12%;
            padding: 1.8vh;
            padding-bottom: 0.6vh;
            justify-content: space-between;
            align-items: center;
        }

        .boosting-header-title {
            font-size: 2.5vh;
        }

        .boosting-coins {
            background: #415A77;
            width: fit-content;
            padding: 0.5vh;
            height: 3vh;
            border-radius: 0.3vh;
            display: flex;
            justify-content: space-evenly;
            align-items: center;
            gap: 0.3vh;
        }

        .boosting-coins-svg {
            width: 2vh;
            height: 2vh;
            fill: white;
        }

        .boosting-lvl {
            background: #1B263B;
            width: fit-content;
            padding: 0.5vh;
            height: 3vh;
            border-radius: 0.3vh;
            display: flex;
            justify-content: space-evenly;
            align-items: center;
            gap: 0.3vh;
        }

        .boosting-active-boost {
            display: flex;
            color: white;
            margin: 1.8vh;
            margin-top: 0;
            margin-bottom: 0.9vh;
            justify-content: center;
            align-items: center;
            height: 25%;
            background: #1B263B;
            border-radius: 0.3vh;
            flex-direction: column;
        }

        .boosting-no-active-boost {
            width: 100%;
            text-align: center;
            font-size: 1.2vh;
        }
        
        .boosting-no-available-boost {
            width: 100%;
            text-align: center;
            font-size: 1.2vh;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }

        .boosting-available-boost {
            display: flex;
            color: white;
            margin: 1.8vh;
            margin-top: 0;
            justify-content: flex-start;
            align-items: center;
            height: 50%;
            background: #1B263B;
            border-radius: 0.3vh;
            padding: 0.3vh;
            flex-direction: column;
            gap: 1%;
            overflow-y: auto;
        }

        .boosting-available-boost::-webkit-scrollbar {
            display: none;
        }

        .boosting-active-boost-info {
            width: 100%;
            height: 100%;
            padding: 0.5vh;
        }

        .boosting-active-boost-img {
            width: 30%;
            height: 100%;
            background: #293d56;
            border-radius: 0.3vh;
            padding: 0.2vh;
        }

        .boosting-active-boost-img img{
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .boosting-active-boost-info-header {
            height: 50%;
            width: 100%;
            display: flex;
            justify-content: space-between;
        }

        .boosting-active-boost-info-mission {
            width: 68%;
        }

        .boosting-available-boost-info-mission {
            width: 100%;
        }

        .boosting-active-boost-title {
            font-size: 1.3vh;
            font-weight: 800;
        }

        .boosting-available-boost-title {
            font-size: 1.3vh;
            font-weight: 800;
            display: flex;
            justify-content: space-between;
        }

        .boosting-available-boost-title-count {
            font-size: 1.3vh;
            font-weight: 800;
            background: #415A77;
            width: 10%;
            text-align: center;
            border-radius: 0.3vh;
        }

        .boosting-active-boost-subtitle {
            font-size: 0.9vh;
            color: #9b9b9b;
        }

        .boosting-available-boost-subtitle {
            font-size: 0.9vh;
            color: #9b9b9b;
        }

        .boosting-active-boost-timeleft {
            background: #415A77;
            width: 50%;
            padding: 0.5vh;
            height: 3.5vh;
            border-radius: 0.3vh;
            display: flex;
            justify-content: space-evenly;
            align-items: center;
            gap: 0.3vh;
            margin-top: 3%;
        }

        .boosting-active-boost-timeleft-svg {
            width: 2vh;
            height: 2vh;
            fill: white;
        }

        .boosting-active-boost-rewards {
            font-size: 1.2vh;
            margin-top: 0.4vh;
        }

        .boosting-available-boost-rewards {
            font-size: 1.2vh;
            margin-top: 0.4vh;
        }

        .boosting-active-boost-members {
            font-size: 1vh;
            color: #9b9b9b;
        }

        .boosting-active-boost-members-list {
            display: flex;
            width: 100%;
            height: 26%;
            align-items: center;
            justify-content: space-between;
        }

        .boosting-active-boost-member {
            background: #293d56;
            display: flex;
            padding: 0.5vh;
            border-radius: 0.3vh;
            font-size: 1vh;
            width: 24%;
            height: 100%;
            text-align: center;
            align-items: center;
            justify-content: center;
        }

        .boosting-active-boost-members-list .member-empty {
            color: #858585;
            background: transparent;
            border: dotted;
            border-width: 0.2vh;
            border-color: #293d56;
        }

        .boosting-active-boost-members-list .member-pending {
            color: #f5f5f5;
            background: transparent;
            border: solid;
            border-width: 0.2vh;
            border-color: #293d56;
            position: relative;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .boosting-active-boost-members-list .member-party {
            color: white;
            position: relative;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .boosting-active-boost-members-list .member-actions {
            position: absolute;
            opacity: 0;
            display: flex;
            gap: 0.3vh;
            transition: opacity 0.15s ease-in-out;
            pointer-events: none; /* prevents hover issues */
        }

        .boosting-active-boost-members-list .member-actions button {
            background: #415A77;
            border: none;
            padding: 0.4vh 0.6vh;
            border-radius: 0.3vh;
            color: white;
            font-size: 1.2vh;
            cursor: pointer;
        }

        .boosting-active-boost-members-list .member-name {
            transition: opacity 0.15s ease-in-out;
        }

        .boosting-active-boost-members-list .member-pending:hover .member-actions {
            opacity: 1;
            pointer-events: auto;
        }

        .boosting-active-boost-members-list .member-pending:hover .member-name {
            opacity: 0;
        }

        .boosting-active-boost-members-list .member-party:hover .member-actions {
            opacity: 1;
            pointer-events: auto;
        }

        .boosting-active-boost-members-list .member-party:hover .member-name {
            opacity: 0;
        }

        .boosting-join-contract-btn {
            margin-top: 1vh;
            text-align: center;
            background: #415A77;
            padding: 0.5vh;
            border-radius: 0.3vh;
            color: white;
            font-size: 1.1vh;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .boosting-join-contract-btn:hover {
            background: #5c7ea5ff;
        }

        .boosting-buy-offers-btn {
            margin-top: 1vh;
            text-align: center;
            background: #415A77;
            padding: 0.5vh;
            border-radius: 0.3vh;
            color: white;
            font-size: 1.1vh;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .boosting-buy-offers-btn:hover {
            background: #5c7ea5ff;
        }

        .boosting-start-contract-btn {
            margin-top: 1vh;
            text-align: center;
            background: #415A77;
            padding: 0.5vh;
            border-radius: 0.3vh;
            color: white;
            font-size: 1.1vh;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .boosting-start-contract-btn:hover {
            background: #5c7ea5ff;
        }

        .boosting-join-contract-popup {
            display: none;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            backdrop-filter: blur(3px);
            background: rgba(0, 0, 0, 0.35);
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.25s ease;
            opacity: 0;
            transition: opacity 0.25s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        .boosting-join-contract-popup-inner {
            width: 80%;
            background: #1B263B;
            padding: 2vh;
            border-radius: 0.5vh;
            display: flex;
            flex-direction: column;
            gap: 1.2vh;
        }

        .boosting-join-contract-popup.popshow {
            opacity: 1;
        }

        .popup-title {
            color: white;
            font-size: 1.4vh;
            text-align: center;
        }

        .popup-input {
            width: 100%;
            padding: 1vh;
            background: #415A77;
            border: none;
            outline: none;
            border-radius: 0.3vh;
            color: white;
            font-size: 1.4vh;
        }

        .popup-input:active {
            outline: none;
            box-shadow: none;
        }

        .popup-input::placeholder {
            color: #dcdcdc;
        }

        .popup-buttons {
            display: flex;
            justify-content: space-between;
        }

        .popup-cancel,
        .popup-accept {
            width: 48%;
            padding: 0.8vh;
            text-align: center;
            border-radius: 0.3vh;
            cursor: pointer;
            color: white;
            font-size: 1.2vh;
            transition: background 0.2s ease;
        }

        .popup-cancel {
            background: #8b1e1e; 
        }

        .popup-accept {
            background: #2a7f2a;
        }

        .popup-cancel:hover {
            background: #b12929ff;
        }

        .popup-accept:hover {
            background: #2b9c2bff;
        }

        .popup-cancel:active {
            background: #e21919ff;
        }

        .popup-accept:active {
            background: #17db17ff;
        }

        .boosting-available-boost-info {
            width: 100%;
            padding: 0.5vh;
            background: #0D1B2A;
            border-radius: 0.3vh;
        }

        .boosting-tab-selecter {
            display: flex;
            color: white;
            margin: 1.8vh;
            margin-top: 0;
            margin-bottom: 0.3vh;
            gap: 1%;
        }

        .boosting-tab-selecter-button {
            text-align: center;
            background: #415A77;
            padding: 0.5vh;
            border-radius: 0.3vh;
            color: white;
            font-size: 1.1vh;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .boosting-tab-selecter-button:hover {
            background: #5c7ea5ff;
        }

        .boosting-tab-selecter-button:active {
            background: #7a99caff;
        }

        .boosting-tab-selecter-button-selected {
            background: #7a99caff;
        }
        .boosting-page-btn {
            width: 2vh;
            height: 2vh;
            background: #415A77;
            border-radius: 0.4vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.1vh;
            cursor: pointer;
            transition: 0.15s;
        }

        .boosting-page-btn:hover {
            background: #5c7ea5ff;
        }

        .boosting-page-btn:active {
            background: #7a99caff;
        }

        .leaderboard-boosting-table {
            width:92%;
            color:white;
            font-size:1.3vh;
        }

        .leaderboard-boosting-header-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5vh;
            margin-top: 0.5vh;
            width: 92%;
        }

        .boosting-header-info {
            display: flex;
            gap: 3%;
            width: 40%;
            justify-content: flex-end;
        }
    </style>
    <div class="boosting-app">
        <div class="boosting-header">
            <div class="boosting-header-title">Boosting</div>
            <div class="boosting-header-info">
                <div class="boosting-lvl">Lvl 2</div>
                <div class="boosting-coins">
                    <div class="boosting-coins-svg"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.--><path d="M192 160L192 144C192 99.8 278 64 384 64C490 64 576 99.8 576 144L576 160C576 190.6 534.7 217.2 474 230.7C471.6 227.9 469.1 225.2 466.6 222.7C451.1 207.4 431.1 195.8 410.2 187.2C368.3 169.7 313.7 160.1 256 160.1C234.1 160.1 212.7 161.5 192.2 164.2C192 162.9 192 161.5 192 160.1zM496 417L496 370.8C511.1 366.9 525.3 362.3 538.2 356.9C551.4 351.4 564.3 344.7 576 336.6L576 352C576 378.8 544.5 402.5 496 417zM496 321L496 288C496 283.5 495.6 279.2 495 275C510.5 271.1 525 266.4 538.2 260.8C551.4 255.2 564.3 248.6 576 240.5L576 255.9C576 282.7 544.5 306.4 496 320.9zM64 304L64 288C64 243.8 150 208 256 208C362 208 448 243.8 448 288L448 304C448 348.2 362 384 256 384C150 384 64 348.2 64 304zM448 400C448 444.2 362 480 256 480C150 480 64 444.2 64 400L64 384.6C75.6 392.7 88.5 399.3 101.8 404.9C143.7 422.4 198.3 432 256 432C313.7 432 368.3 422.3 410.2 404.9C423.4 399.4 436.3 392.7 448 384.6L448 400zM448 480.6L448 496C448 540.2 362 576 256 576C150 576 64 540.2 64 496L64 480.6C75.6 488.7 88.5 495.3 101.8 500.9C143.7 518.4 198.3 528 256 528C313.7 528 368.3 518.3 410.2 500.9C423.4 495.4 436.3 488.7 448 480.6z"/></svg></div>
                    <div class="boosting-coins-amount">0</div>
                </div>
            </div>
        </div>

        <div class="boosting-join-contract-popup">
            <div class="boosting-join-contract-popup-inner">
                <div class="popup-title">Inserir ID do contrato</div>
                <input type="text" class="popup-input" placeholder="ID do contrato...">

                <div class="popup-buttons">
                    <div class="popup-cancel">Cancelar</div>
                    <div class="popup-accept">Aceitar</div>
                </div>
            </div>
        </div>

        <div class="boosting-active-boost">
            <div class="boosting-no-active-boost">Sem contrato ativo</div>
            <div class="boosting-join-contract-btn">Juntar-se a um contrato</div>
        </div>
        <div class="boosting-tab-selecter">
            <div class="boosting-tab-selecter-button boosting-tab-selecter-button-selected" id="offers">Ofertas</div>
            <div class="boosting-tab-selecter-button" id="my-contracts">Meus Contratos</div>
            <div class="boosting-tab-selecter-button" id="leaderboard">Leaderboard</div>
        </div>
        <div class="boosting-available-boost">
            <div class="boosting-no-available-boost">Sem contratos disponíveis</div>
        </div>
    </div>
`);

// Generic popup function
function showBoostingPopup(title, placeholder, onAccept, showInput = true) {
    $(".popup-title").text(title);
    
    if (showInput) {
        $(".popup-input").show();
        $(".popup-input").attr("placeholder", placeholder || "");
    } else {
        $(".popup-input").hide();
    }
    
    // Store the callback and input mode
    $(".popup-accept").data("callback", onAccept);
    $(".popup-accept").data("showInput", showInput);
    
    $(".boosting-join-contract-popup").css("display", "flex");
    $(".boosting-join-contract-popup").addClass("popshow");
}

// Open popup for joining contract
$(document).on("click", ".boosting-join-contract-btn", function () {
    showBoostingPopup("Inserir ID do contrato", "ID do contrato...", function(contractId) {
        $.post("https://cphone/joinBoostingContract", JSON.stringify({ contractId: contractId }));
    }, true);
});

// Open popup for buying offers
$(document).on("click", ".boosting-buy-offers-btn", function () {
    showBoostingPopup("Deseja comprar mais ofertas? (10 Coins)", null, function() {
        $.post("https://cphone/buyBoostingOffers", JSON.stringify({}));
    }, false);
});

// Cancel
$(document).on("click", ".popup-cancel", function () {
    $(".boosting-join-contract-popup").removeClass("popshow");
    setTimeout(() => {
        $(".boosting-join-contract-popup").css("display", "none");
    }, 250);
    $(".popup-input").val("");
});

// Accept
$(document).on("click", ".popup-accept", function () {
    let showInput = $(this).data("showInput");
    let callback = $(this).data("callback");
    
    if (showInput) {
        let value = $(".popup-input").val().trim();
        if (value === "") return;
        
        if (callback && typeof callback === 'function') {
            callback(value);
        }
    } else {
        if (callback && typeof callback === 'function') {
            callback();
        }
    }

    $(".boosting-join-contract-popup").removeClass("popshow");
    setTimeout(() => {
        $(".boosting-join-contract-popup").css("display", "none");
        $(".popup-input").val("");
    }, 250);
});

// Update coins amount (example)
function updateBoostCoins(amount) {
    $(".boosting-coins-amount").text(amount);
}

let timerBoost = null;

function updateCurrentBoost(data) {
    clearInterval(timerBoost);

    if (data == null) {
        $(".boosting-active-boost").html(/*html*/`
            <div class="boosting-no-active-boost">Sem contrato ativo</div>
            <div class="boosting-join-contract-btn">Juntar-se a um contrato</div>
        `);
        return;
    }

    $(".boosting-active-boost").html(/*html*/`
        <div class="boosting-active-boost-info">
            <div class="boosting-active-boost-info-header">
                <div class="boosting-active-boost-info-mission">
                    <div class="boosting-active-boost-title">${data.missionLabel}</div>
                    <div class="boosting-active-boost-subtitle">${data.vehicleTypeLabel}</div>
                    <div class="boosting-active-boost-timeleft">
                        <div class="boosting-active-boost-timeleft-svg"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><path d="M64 96C64 78.3 78.3 64 96 64L416 64C433.7 64 448 78.3 448 96C448 113.7 433.7 128 416 128L416 139C416 181.4 399.1 222.1 369.1 252.1L301.2 320L319.1 337.9C304.7 354.4 293.1 373.5 285 394.3L256 365.3L188.1 433.2C170.1 451.2 160 475.6 160 501.1L160 512.1L278 512.1C284 535.4 294.3 557.1 308 576.1L96 576C78.3 576 64 561.7 64 544C64 526.3 78.3 512 96 512L96 501C96 458.6 112.9 417.9 142.9 387.9L210.8 320L142.9 252.1C112.9 222.1 96 181.4 96 139L96 128C78.3 128 64 113.7 64 96zM160 128L160 139C160 164.5 170.1 188.9 188.1 206.9L256 274.8L323.9 206.9C341.9 188.9 352 164.5 352 139L352 128L160 128zM320 464C320 384.5 384.5 320 464 320C543.5 320 608 384.5 608 464C608 543.5 543.5 608 464 608C384.5 608 320 543.5 320 464zM464 384C455.2 384 448 391.2 448 400L448 464C448 472.8 455.2 480 464 480L512 480C520.8 480 528 472.8 528 464C528 455.2 520.8 448 512 448L480 448L480 400C480 391.2 472.8 384 464 384z"/></svg></div>
                        <div class="boosting-active-boost-timeleft-amount">60m00s</div>
                    </div>
                </div>
                <div class="boosting-active-boost-img"><img src="./img/boosting/${data.missionType}.png"/></div>
            </div>
            <div class="boosting-active-boost-rewards">Recompensa: ${data.rewardsLabel}</div>
            <div class="boosting-active-boost-members">Membros - ID: ${data.boostId}</div>
            <div class="boosting-active-boost-members-list">
                <div class="boosting-active-boost-member">${data.memberName}</div>
                <!--<div class="boosting-active-boost-member member-pending">
                    <span class="member-name">Alex Teles</span>
                    <div class="member-actions">
                        <button class="btn-accept">✔</button>
                        <button class="btn-decline">✖</button>
                    </div>
                </div>
                <div class="boosting-active-boost-member member-party">
                    <span class="member-name">Mário Jardel</span>
                    <div class="member-actions">
                        <button class="btn-decline">✖</button>
                    </div>
                </div>-->
                <div class="boosting-active-boost-member member-empty">Vazio</div>
                <div class="boosting-active-boost-member member-empty">Vazio</div>
                <div class="boosting-active-boost-member member-empty">Vazio</div>
            </div>
        </div>
    `);

    let duration = data.timer;

    timerBoost = setInterval(function() {
        let minutes = Math.floor(duration / 60);
        let seconds = duration % 60;

        // format
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        $(".boosting-active-boost-timeleft-amount").text(minutes + "m" + seconds + "s");

        if (--duration < 0) {
            clearInterval(timerBoost);
        }
    }, 1000);
}

function updateCurrentBoostMembers(data) {
    // To be implemented: Update the members list dynamically
    let membersHtml = "";

    //add current members but member.status == owner should be the first element
    data.members.sort((a, b) => (b.status === "owner") - (a.status === "owner"));

    data.members.forEach(member => {
        if (member.status === "owner") {
            membersHtml += /*html*/`<div class="boosting-active-boost-member">${member.name}</div>`;
        } else if (member.status === "pending") {
            membersHtml += /*html*/`
                <div class="boosting-active-boost-member member-pending">
                    <span class="member-name">${member.name}</span>
                    <div class="member-actions">
                    ${data.isOwner ? `
                        <button class="btn-accept" data-member-id="${member.playerId}">✔</button>
                        <button class="btn-decline" data-member-id="${member.playerId}">✖</button>
                    ` : ""}
                    </div>
                </div>
            `;
        } else if (member.status === "party") {
            membersHtml += /*html*/`
                <div class="boosting-active-boost-member member-party">
                    <span class="member-name">${member.name}</span>
                    <div class="member-actions">
                    ${data.isOwner ? `
                        <button class="btn-decline" data-member-id="${member.playerId}">✖</button>
                    ` : ""}
                    </div>
                </div>
            `;
        }
    });

    // Fill empty slots if less than 4 members
    for (let i = data.members.length; i < 4; i++) {
        membersHtml += `<div class="boosting-active-boost-member member-empty">Vazio</div>`;
    }

    $(".boosting-active-boost-members-list").html(membersHtml);


    // Handle accept/decline button clicks
    $(".btn-accept").click(function() {
        let memberId = $(this).data("member-id");
        $.post("https://cphone/acceptBoostMember", JSON.stringify({ memberId: memberId }));
    });

    $(".btn-decline").click(function() {
        let memberId = $(this).data("member-id");
        $.post("https://cphone/declineBoostMember", JSON.stringify({ memberId: memberId }));
    });
}

let availableContracts = [];
let availableOffers = [];
let leaderboardData = [];
let leaderboardPages = [];
let currentLeaderboardPage = 0;


function updateAvailableContracts(data) {
    if (data.contracts.length === 0) {
        $(".boosting-available-boost").html(/*html*/`
            <div class="boosting-no-available-boost">Sem contratos disponíveis</div>
        `);
        return;
    }
    let contractsHtml = "";
    data.contracts.forEach(contract => {
        contractsHtml += /*html*/`
            <div class="boosting-available-boost-info">
                <div class="boosting-available-boost-info-mission">
                    <div class="boosting-available-boost-title"><div>${contract.missionLabel}</div><div class="boosting-available-boost-title-count">x${contract.ownedCount}</div></div>
                    <div class="boosting-available-boost-subtitle">${contract.info.vehicleTypeLabel} - Nível ${contract.info.level}</div>
                    <div class="boosting-available-boost-rewards">Recompensa: ${contract.rewardsLabel}</div>
                    <div class="boosting-available-boost-rewards">Requisitos: ${contract.requirementsLabel}</div>
                </div>
                <div class="boosting-start-contract-btn" data-contract-id="${contract.id}">Iniciar</div>
            </div>
        `;
    });

    $(".boosting-available-boost").html(contractsHtml);

    $(".boosting-start-contract-btn").click(function(e) {
        let contractId = $(this).data("contract-id");

        $.post("https://cphone/startBoostContract", JSON.stringify({ contractId: contractId }));
    });
}

function updateAvailableOffers(data) {
    if (data.contracts.length === 0) {
        $(".boosting-available-boost").html(/*html*/`
            <div class="boosting-no-available-boost">
                Sem contratos disponíveis <br/> (Renova a cada 30 minutos)
                <div class="boosting-buy-offers-btn">Obter novas ofertas</div>
            </div> 
        `);
        return;
    }
    let contractsHtml = "";
    data.contracts.forEach(contract => {
        contractsHtml += /*html*/`
            <div class="boosting-available-boost-info">
                <div class="boosting-available-boost-info-mission">
                    <div class="boosting-available-boost-title">${contract.missionLabel}</div>
                    <div class="boosting-available-boost-subtitle">${contract.info.vehicleTypeLabel} - Nível ${contract.info.level}</div>
                    <div class="boosting-available-boost-rewards">Recompensa: ${contract.rewardsLabel}</div>
                    <div class="boosting-available-boost-rewards">Requisitos: ${contract.requirementsLabel}</div>
                </div>
                <div class="boosting-start-contract-btn" data-contract-id="${contract.id}">Resgatar</div>
            </div>
        `;
    });

    $(".boosting-available-boost").html(contractsHtml);

    $(".boosting-start-contract-btn").click(function(e) {
        let contractId = $(this).data("contract-id");

        $.post("https://cphone/claimBoostContract", JSON.stringify({ contractId: contractId }));
    });
}

function generateLeaderboardTable(top10, playerRank) {
    let table = /*html*/`
    <table class="leaderboard-boosting-table">
        <tr style="color:#9b9b9b;">
            <th style="text-align:left;">#</th>
            <th style="text-align:left;">Jogador</th>
            <th style="text-align:right;">Pontos</th>
        </tr>
    `;

    // TOP 10 ENTRIES
    top10.forEach((row, index) => {
        table += /*html*/`
        <tr>
            <td>${index + 1}</td>
            <td>${row.player_name}</td>
            <td style="text-align:right;">${row.count || row.total_experience}</td>
        </tr>`;
    });

    // SHOW PLAYER ROW IF THEY’RE NOT IN TOP 10
    if (playerRank && playerRank.rank > 10) {
        table += /*html*/`
        <tr style="color:#7a99caff; font-weight:bold;">
            <td>${playerRank.rank}</td>
            <td>${playerRank.player_name}</td>
            <td style="text-align:right;">${playerRank.count || playerRank.total_experience}</td>
        </tr>`;
    }

    table += `</table>`;
    return table;
}

function renderLeaderboardPage() {
    if (leaderboardPages.length === 0) return;

    let page = leaderboardPages[currentLeaderboardPage];

    let html = /*html*/`
        <div class="leaderboard-boosting-header-buttons">
            <div class="boosting-page-btn" onclick="previousLeaderboardPage()">
                <i class="fa-solid fa-chevron-left"></i>
            </div>
            <div style="font-size:1.6vh; color:white; font-weight:600;">
                ${page.title}
            </div>
            <div class="boosting-page-btn" onclick="nextLeaderboardPage()">
                <i class="fa-solid fa-chevron-right"></i>
            </div>
        </div>

        ${page.table}
    `;

    $(".boosting-available-boost").html(html);
}

function nextLeaderboardPage() {
    if (currentLeaderboardPage < leaderboardPages.length - 1) {
        currentLeaderboardPage++;
        renderLeaderboardPage();
    }
}

function previousLeaderboardPage() {
    if (currentLeaderboardPage > 0) {
        currentLeaderboardPage--;
        renderLeaderboardPage();
    }
}

function updateLeaderboard(data) {
    leaderboardPages = []; // Reset pages

    // ---- PAGE 1: TOTAL LEADERBOARD ----
    leaderboardPages.push({
        title: "TOP 10 GERAL",
        table: generateLeaderboardTable(data.total.top10, data.total.playerRank)
    });

    // ---- PAGES FOR EACH LEVEL ----
    Object.keys(data.perLevel).forEach(level => {
        leaderboardPages.push({
            title: `Nível ${parseInt(level) + 1}`,
            table: generateLeaderboardTable(
                data.perLevel[level].top10,
                data.perLevel[level].playerRank
            )
        });
    });

    currentLeaderboardPage = 0;
    renderLeaderboardPage();
}



let selectedTab = "offers";

$(document).on("click", ".boosting-tab-selecter-button", function () {
    let tabId = $(this).attr("id");
    
    if (tabId === selectedTab) return;
    
    selectedTab = tabId;
    
    $(".boosting-tab-selecter-button").removeClass("boosting-tab-selecter-button-selected");
    $(this).addClass("boosting-tab-selecter-button-selected");
    
    if (selectedTab === "offers") {
        updateAvailableOffers(availableOffers);
    } else if (selectedTab === "my-contracts") {
        updateAvailableContracts(availableContracts);
    } else if (selectedTab === "leaderboard") {
        $.post('http://cphone/boosting_getleaderboard', JSON.stringify({}));
    }
});

function OpenBoost() {
    //fetch available contracts from lua
    $.post('http://cphone/boosting_getcontracts', JSON.stringify({}));
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "updateCurrentBoost":
                updateCurrentBoost(event.data);
                break;
            case "clearCurrentBoost":
                updateCurrentBoost(null);
                break;
            case "UpdateBoostCoins":
                updateBoostCoins(event.data.BoostCoins);
                break;
            case "updateCurrentBoostMembers":
                updateCurrentBoostMembers(event.data);
                break;
            case "updateAvailableContracts":
                availableContracts = event.data;
                if (selectedTab === "my-contracts") {
                    updateAvailableContracts(availableContracts);
                }
                break;
            case "updateAvailableOffers":
                availableOffers = event.data;
                if (selectedTab === "offers") {
                    updateAvailableOffers(availableOffers);
                }
                break;
            case "updateLeaderboard":
                leaderboardData = event.data.leaderboards;
                if (selectedTab === "leaderboard") {
                    updateLeaderboard(leaderboardData);
                }
                break;
            case "updateBoostLvl":
                $(".boosting-lvl").text("Lvl " + event.data.level);
                break;
        }
    })
});