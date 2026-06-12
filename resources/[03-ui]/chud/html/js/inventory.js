let type = "normal";
let disabled = false;
let disabledFunction = null;
let disableGive = false;
let clothingUi = false;
let currentSkin = {};
let currentActions = {};
let isInventoryAlreadyOpen = false;
isPresssingControl = false;
let currency = "money";
let isDragging = false;
let reinitDragging = false;
let currentInventory = {};
let currentSlots = 0;
let isHoveringItem = false;
let metadataHover = [];
let extras = {};
let currentActivityLeaderboard = null;
let currentActivityLeaderboardFocus = "none";
let currentActivityLeaderboardPeriod = "monthly";
let currentVotingData = {parties: [], totalVotes: 0, selectedParty: null};
let currentVotingTab = "parties";
let currentVotingParty = null;

function buildActionsSlots() {
    $(`.action-choose`).html(/*html*/`
        <div class="action-option" id="quickCraft"><div class="action-img"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M78.6 5C69.1-2.4 55.6-1.5 47 7L7 47c-8.5 8.5-9.4 22-2.1 31.6l80 104c4.5 5.9 11.6 9.4 19 9.4h54.1l109 109c-14.7 29-10 65.4 14.3 89.6l112 112c12.5 12.5 32.8 12.5 45.3 0l64-64c12.5-12.5 12.5-32.8 0-45.3l-112-112c-24.2-24.2-60.6-29-89.6-14.3l-109-109V104c0-7.5-3.5-14.5-9.4-19L78.6 5zM19.9 396.1C7.2 408.8 0 426.1 0 444.1C0 481.6 30.4 512 67.9 512c18 0 35.3-7.2 48-19.9L233.7 374.3c-7.8-20.9-9-43.6-3.6-65.1l-61.7-61.7L19.9 396.1zM512 144c0-10.5-1.1-20.7-3.2-30.5c-2.4-11.2-16.1-14.1-24.2-6l-63.9 63.9c-3 3-7.1 4.7-11.3 4.7H352c-8.8 0-16-7.2-16-16V102.6c0-4.2 1.7-8.3 4.7-11.3l63.9-63.9c8.1-8.1 5.2-21.8-6-24.2C388.7 1.1 378.5 0 368 0C288.5 0 224 64.5 224 144l0 .8 85.3 85.3c36-9.1 75.8 .5 104 28.7L429 274.5c49-23 83-72.8 83-130.5zM56 432a24 24 0 1 1 48 0 24 24 0 1 1 -48 0z"/></svg></div></div>
        <div class="action-option" id="idCard"><div class="action-img"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.--><path d="M32 160C32 124.7 60.7 96 96 96L544 96C579.3 96 608 124.7 608 160L32 160zM32 208L608 208L608 480C608 515.3 579.3 544 544 544L96 544C60.7 544 32 515.3 32 480L32 208zM279.3 480C299.5 480 314.6 460.6 301.7 445C287 427.3 264.8 416 240 416L176 416C151.2 416 129 427.3 114.3 445C101.4 460.6 116.5 480 136.7 480L279.2 480zM208 376C238.9 376 264 350.9 264 320C264 289.1 238.9 264 208 264C177.1 264 152 289.1 152 320C152 350.9 177.1 376 208 376zM392 272C378.7 272 368 282.7 368 296C368 309.3 378.7 320 392 320L504 320C517.3 320 528 309.3 528 296C528 282.7 517.3 272 504 272L392 272zM392 368C378.7 368 368 378.7 368 392C368 405.3 378.7 416 392 416L504 416C517.3 416 528 405.3 528 392C528 378.7 517.3 368 504 368L392 368z"/></svg></div></div>
        <div class="action-option" id="fishingLeaderboard"><div class="action-img"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2v10a4 4 0 1 0 4 4h-2a2 2 0 1 1-2-2V6l3 3 1.41-1.41L12 2z"/></svg></div></div>
        <div class="action-option" id="huntingLeaderboard"><div class="action-img"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M11 2h2v3.06A7 7 0 0 1 18.94 11H22v2h-3.06A7 7 0 0 1 13 18.94V22h-2v-3.06A7 7 0 0 1 5.06 13H2v-2h3.06A7 7 0 0 1 11 5.06V2zm1 5a5 5 0 1 0 0 10 5 5 0 0 0 0-10zm0 3a2 2 0 1 1 0 4 2 2 0 0 1 0-4z"/></svg></div></div>
        <div class="action-option" id="fpsMenu"><div class="action-img"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--!Font Awesome Pro 6.7.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2025 Fonticons, Inc.--><path d="M0 256a256 256 0 1 1 512 0A256 256 0 1 1 0 256zM288 96a32 32 0 1 0 -64 0 32 32 0 1 0 64 0zM256 416c35.3 0 64-28.7 64-64c0-3.7-.3-7.3-.9-10.8l117.5-72.8c11.3-7 14.7-21.8 7.8-33s-21.8-14.8-33-7.8L293.8 300.4C283.2 292.6 270.1 288 256 288c-35.3 0-64 28.7-64 64s28.7 64 64 64zM176 144a32 32 0 1 0 -64 0 32 32 0 1 0 64 0zM96 288a32 32 0 1 0 0-64 32 32 0 1 0 0 64zM400 144a32 32 0 1 0 -64 0 32 32 0 1 0 64 0z"/></svg></div></div>
    `);
    $(`.action-chooser`).addClass(`action-chooser-show`);
}

function escapeHtml(input) {
    return String(input ?? "").replace(/[&<>"']/g, function (char) {
        switch (char) {
            case "&": return "&amp;";
            case "<": return "&lt;";
            case ">": return "&gt;";
            case "\"": return "&quot;";
            case "'": return "&#39;";
            default: return char;
        }
    });
}

function buildLeaderboardRows(entries) {
    console.log("Building leaderboard rows with entries:", entries);
    if (!Array.isArray(entries) || entries.length === 0) {
        return `<div class="activity-board-empty">Sem registos ainda.</div>`;
    }

    let rows = "";

    $.each(entries, function (index, entry) {
        console.log(JSON.stringify(entry));
        const amount = numberWithSpaces(parseInt(entry.amount || 0, 10));
        const playerName = escapeHtml(entry.player_name || "Desconhecido");

        rows += /*html*/`
            <div class="activity-board-row">
                <div class="activity-board-rank">#${index + 1}</div>
                <div class="activity-board-player">${playerName}</div>
                <div class="activity-board-amount">${amount}</div>
            </div>
        `;
    });

    return rows;
}

function isValidLeaderboardPeriod(period) {
    return period === "daily" || period === "weekly" || period === "monthly";
}

function getSelectedActivityLeaderboardData() {
    if (currentActivityLeaderboard === null) {
        return null;
    }

    if (currentActivityLeaderboard[currentActivityLeaderboardPeriod] !== undefined) {
        console.log("Invalid leaderboard period:", JSON.stringify(currentActivityLeaderboard[currentActivityLeaderboardPeriod]));
        return currentActivityLeaderboard[currentActivityLeaderboardPeriod];
    }
    console.log("Invalid leaderboard period:", JSON.stringify(currentActivityLeaderboardPeriod));
    return currentActivityLeaderboard;
}

function getLeaderboardPersonalStat(typeName, leaderboardData) {
    const fallback = { amount: 0, rank: 0 };

    if (leaderboardData === null || leaderboardData === undefined || leaderboardData.personal === undefined) {
        return fallback;
    }

    return leaderboardData.personal[typeName] || fallback;
}

function getLeaderboardPersonalItems(typeName, leaderboardData) {
    if (leaderboardData === null || leaderboardData === undefined || leaderboardData.personal_items === undefined) {
        return [];
    }

    return leaderboardData.personal_items[typeName] || [];
}
function buildPersonalItemRows(entries) {
    if (!Array.isArray(entries) || entries.length === 0) {
        return `<div class="activity-board-empty">Sem registos ainda.</div>`;
    }

    let rows = "";

    $.each(entries, function (index, entry) {
        const amount = numberWithSpaces(parseInt(entry.amount || 0, 10));
        const itemName = escapeHtml(entry.item_name || "unknown");

        rows += /*html*/`
            <div class="activity-board-row">
                <div class="activity-board-rank">#${index + 1}</div>
                <div class="activity-board-player">${itemName}</div>
                <div class="activity-board-amount">${amount}</div>
            </div>
        `;
    });

    return rows;
}

function renderActivityLeaderboard() {
    if (type !== "normal") {
        return;
    }

    const selectedLeaderboardData = getSelectedActivityLeaderboardData();

    if (currentActivityLeaderboardFocus === "none" || selectedLeaderboardData === null) {
        $("#otherInventory").html("<div id=\"noSecondInventoryMessage\"></div>");
        $("#noSecondInventoryMessage").html(T("UI_INVENTORY_SECOND_NOT_AVAILABLE"));
        return;
    }

    const selectedType = currentActivityLeaderboardFocus === "fishing" ? "fishing" : "hunting";
    const isFishing = selectedType === "fishing";
    const isDailyPeriod = currentActivityLeaderboardPeriod === "daily";
    const isWeeklyPeriod = currentActivityLeaderboardPeriod === "weekly";
    const isMonthlyPeriod = currentActivityLeaderboardPeriod === "monthly";
    console.log("Rendering leaderboard with data:", selectedType);
    const topRows = buildLeaderboardRows(selectedLeaderboardData[selectedType]);
    const personalStat = getLeaderboardPersonalStat(selectedType, selectedLeaderboardData);
    const personalItemsRows = buildPersonalItemRows(getLeaderboardPersonalItems(selectedType, selectedLeaderboardData));
    const personalRank = personalStat.rank > 0 ? `#${personalStat.rank}` : "-";
    const sectionLabel = isFishing ? "Pesca" : "Ca&ccedil;a";
    const personalLabel = isFishing ? "Minha Pesca" : "Minha Ca&ccedil;a";
    const titleLabel = "Leaderboard - " + sectionLabel;

    $("#otherInventory").html(/*html*/`
        <div class="activity-leaderboard">
            <div class="activity-board-title">
                <div class="activity-board-heading">${titleLabel}</div>
                <div class="activity-board-period-tabs">
                    <button type="button" class="activity-board-period-tab ${isDailyPeriod ? "is-active" : ""}" data-period="daily">Diário</button>
                    <button type="button" class="activity-board-period-tab ${isWeeklyPeriod ? "is-active" : ""}" data-period="weekly">Semanal</button>
                    <button type="button" class="activity-board-period-tab ${isMonthlyPeriod ? "is-active" : ""}" data-period="monthly">Mensal</button>
                </div>
            </div>

            <div class="activity-board-personal">
                <div class="activity-board-personal-card">
                    <div class="activity-board-personal-name">${personalLabel}</div>
                    <div class="activity-board-personal-amount">${numberWithSpaces(parseInt(personalStat.amount || 0, 10))}</div>
                    <div class="activity-board-personal-rank">${personalRank}</div>
                </div>
            </div>

            <div class="activity-board-section">
                <div class="activity-board-section-head">
                    <span>Top ${sectionLabel}</span>
                    <span>Qtd</span>
                </div>
                <div class="activity-board-list">
                    ${topRows}
                </div>
            </div>

            <div class="activity-board-section">
                <div class="activity-board-section-head">
                    <span>Meus Detalhes</span>
                    <span>Qtd</span>
                </div>
                <div class="activity-board-list">
                    ${personalItemsRows}
                </div>
            </div>
        </div>
    `);
}

function getVotingParties() {
    if (currentVotingData === null || !Array.isArray(currentVotingData.parties)) {
        return [];
    }

    return currentVotingData.parties;
}

function getSelectedVotingParty() {
    const parties = getVotingParties();

    if (parties.length === 0) {
        return null;
    }

    if (currentVotingParty !== null) {
        const selected = parties.find((party) => party.name === currentVotingParty);

        if (selected !== undefined) {
            return selected;
        }
    }

    return parties[0];
}

function renderVotingRows(parties, selectedParty, hasAlreadyVoted) {
    if (!Array.isArray(parties) || parties.length === 0) {
        return `<div class="activity-board-empty">${T("UI_VOTING_NO_PARTIES")}</div>`;
    }

    let rows = "";

    $.each(parties, function(index, party) {
        const isSelected = selectedParty !== null && selectedParty.name === party.name;
        const selectedClass = isSelected ? " is-active" : "";
        const isVotedParty = currentVotingData !== null && currentVotingData.selectedParty === party.name;
        const rowAction = hasAlreadyVoted ? (isVotedParty ? T("UI_VOTING_VOTED").toUpperCase() : "") : T("UI_VOTING_VOTE").toUpperCase();

        rows += /*html*/`
            <div class="voting-party-row${selectedClass}" data-party="${escapeHtml(party.name)}">
                <div class="voting-party-rank">#${index + 1}</div>
                <div class="voting-party-name">${escapeHtml(party.label)}</div>
                <div class="voting-party-action">${rowAction}</div>
            </div>
        `;

        if (isSelected) {
            const voteButton = hasAlreadyVoted ? "" : /*html*/`
                <button type="button" class="voting-vote-button" data-party="${escapeHtml(party.name)}">
                    ${T("UI_VOTING_VOTE")}
                </button>
            `;

            rows += /*html*/`
                <div class="voting-party-details-inline">
                    <div class="voting-party-details-title">${escapeHtml(party.label)}</div>
                    <div class="voting-party-details-text">${escapeHtml(party.description || "")}</div>
                    ${voteButton}
                </div>
            `;
        }
    });

    return rows;
}

function renderVotingResults(parties) {
    if (!Array.isArray(parties) || parties.length === 0) {
        return `<div class="activity-board-empty">${T("UI_VOTING_NO_RESULTS")}</div>`;
    }

    let rows = "";

    $.each(parties, function(_, party) {
        const percentage = Number(party.percentage || 0);

        rows += /*html*/`
            <div class="voting-result-row">
                <div class="voting-result-head">
                    <span>${escapeHtml(party.label)}</span>
                    <span>${percentage.toFixed(1)}%</span>
                </div>
                <div class="voting-result-bar">
                    <div class="voting-result-bar-fill" style="width: ${Math.max(0, Math.min(100, percentage))}%"></div>
                </div>
                <div class="voting-result-count">${numberWithSpaces(parseInt(party.votes || 0, 10))} ${T("UI_VOTING_VOTES")}</div>
            </div>
        `;
    });

    return rows;
}

function renderVoting() {
    if (type !== "voting") {
        return;
    }

    const parties = getVotingParties();
    const selectedParty = getSelectedVotingParty();
    const hasAlreadyVoted = currentVotingData !== null && currentVotingData.selectedParty !== null && currentVotingData.selectedParty !== undefined;
    const votingEnded = currentVotingData !== null && currentVotingData.ended === true;

    $("#otherInventory").html(/*html*/`
        <div class="voting-board">
            <div class="activity-board-title">
                <div class="activity-board-heading">${T("UI_VOTING_BOOTH")}</div>
                <div class="activity-board-period-tabs" style="${votingEnded ? "display: none;" : ""}">
                    <button type="button" class="activity-board-period-tab voting-tab ${currentVotingTab === "parties" ? "is-active" : ""}" data-tab="parties">${T("UI_VOTING_PARTIES")}</button>
                </div>
            </div>

            ${votingEnded || currentVotingTab === "results" ? /*html*/`
                <div class="activity-board-section">
                    <div class="activity-board-section-head">
                        <span>${T("UI_VOTING_RESULTS")}</span>
                        <span>${numberWithSpaces(parseInt(currentVotingData.totalVotes || 0, 10))} ${T("UI_VOTING_VOTES")}</span>
                    </div>
                    <div class="voting-results">
                        ${renderVotingResults(parties)}
                    </div>
                </div>
            ` : /*html*/`
                <div class="activity-board-section">
                    <div class="activity-board-section-head">
                        <span>${T("UI_VOTING_PARTIES")}</span>
                        <span>${hasAlreadyVoted ? "" : T("UI_VOTING_VOTE")}</span>
                    </div>
                    <div class="activity-board-list">
                        ${renderVotingRows(parties, selectedParty, hasAlreadyVoted)}
                    </div>
                </div>
            `}
        </div>
    `);
}


window.addEventListener("message", function (event) {
    if (event.data.action == "display") {
        disabled = false;
        disableGive = false;

        if (type === "market") {
            //$("#price").show();
           // $("#search").show();
        } else {
            $("#price").hide();
            //$("#search").hide();
        }

        $(`.action-chooser`).removeClass(`action-chooser-show`);
        $(`.action-choose`).html("");

        if (type === "normal") {
            $(".info-div").hide();
            renderActivityLeaderboard();
            buildActionsSlots();
        } else if (type === "trunk") {
            $(".info-div").show();
            $(`.action-choose`).html(/*html*/`
                <div class="action-option" id="enterTrunk"><div class="action-img"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M208 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zM123.7 200.5c1-.4 1.9-.8 2.9-1.2l-16.9 63.5c-5.6 21.1-.1 43.6 14.7 59.7l70.7 77.1 22 88.1c4.3 17.1 21.7 27.6 38.8 23.3s27.6-21.7 23.3-38.8l-23-92.1c-1.9-7.8-5.8-14.9-11.2-20.8l-49.5-54 19.3-65.5 9.6 23c4.4 10.6 12.5 19.3 22.8 24.5l26.7 13.3c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9L281 232.7l-15.3-36.8C248.5 154.8 208.3 128 163.7 128c-22.8 0-45.3 4.8-66.1 14l-8 3.5c-32.9 14.6-58.1 42.4-69.4 76.5l-2.6 7.8c-5.6 16.8 3.5 34.9 20.2 40.5s34.9-3.5 40.5-20.2l2.6-7.8c5.7-17.1 18.3-30.9 34.7-38.2l8-3.5zm-30 135.1L68.7 398 9.4 457.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L116.3 441c4.6-4.6 8.2-10.1 10.6-16.1l14.5-36.2-40.7-44.4c-2.5-2.7-4.8-5.6-7-8.6zM550.6 153.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L530.7 224H384c-17.7 0-32 14.3-32 32s14.3 32 32 32H530.7l-25.4 25.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0l80-80c12.5-12.5 12.5-32.8 0-45.3l-80-80z"></path></svg></div></div>
                <div class="action-option" id="putTrunk"><div class="action-img"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M192 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zm-8 352V352h16v96H184zm-64 0H32c-17.7 0-32 14.3-32 32s14.3 32 32 32H152h80H608c17.7 0 32-14.3 32-32s-14.3-32-32-32H264V256.9l28.6 47.5c9.1 15.1 28.8 20 43.9 10.9s20-28.8 10.9-43.9l-58.3-97c-17.4-28.9-48.6-46.6-82.3-46.6H177.1c-33.7 0-64.9 17.7-82.3 46.6l-58.3 97c-9.1 15.1-4.2 34.8 10.9 43.9s34.8 4.2 43.9-10.9L120 256.9V448zM464 64V306.7l-25.4-25.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3l80 80c12.5 12.5 32.8 12.5 45.3 0l80-80c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L528 306.7V64c0-17.7-14.3-32-32-32s-32 14.3-32 32z"></path></svg></div></div>
                <div class="action-option" id="removeTrunk"><div class="action-img"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M192 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zm-8 352V352h16v96H184zm-64 0H32c-17.7 0-32 14.3-32 32s14.3 32 32 32H152h80H608c17.7 0 32-14.3 32-32s-14.3-32-32-32H264V256.9l28.6 47.5c9.1 15.1 28.8 20 43.9 10.9s20-28.8 10.9-43.9l-58.3-97c-17.4-28.9-48.6-46.6-82.3-46.6H177.1c-33.7 0-64.9 17.7-82.3 46.6l-58.3 97c-9.1 15.1-4.2 34.8 10.9 43.9s34.8 4.2 43.9-10.9L120 256.9V448zM598.6 121.4l-80-80c-12.5-12.5-32.8-12.5-45.3 0l-80 80c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L464 141.3 464 384c0 17.7 14.3 32 32 32s32-14.3 32-32V141.3l25.4 25.4c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3z"></path></svg></div></div>
            `);
            $(`.action-chooser`).addClass(`action-chooser-show`);
        } else if (type === "property") {
            $(".info-div").show();
        } else if (type === "org") {
            $(".info-div").fadeOut(250);
        } else if (type === "casa") {
            $(".info-div").show();
        } else if (type === "case") {
            $(".info-div").hide();
        } else if (type === "tempinv") {
            $(".info-div").hide();
        } else if (type === "idcard") {
            $(".info-div").hide();
            buildActionsSlots();
        } else if (type === "dispense") {
            $(".info-div").show();
        } else if (type === "menu") {
            $(".info-div").show();
        } else if (type === "listmenu") {
            $(".info-div").show();
        } else if (type === "textmenu") {
            $(".info-div").show();
        } else if (type === "vipdelivery") {
            $(".info-div").show();
        } else if (type === "garage") {
            $(".info-div").show();
        } else if (type === "fishing") {
            $(".info-div").show();
        } else if (type === "itemselector") {
            $(".info-div").show();
        } else if (type === "process") {
            $(".info-div").show();
        } else if (type === "craft") {
            $(".info-div").hide();
        } else if (type === "player") {
            disableGive = true;
            $(".info-div").show();
        } else if (type === "shop") {
            $(".info-div").show();
        } else if (type === "customshop") {
            $(".info-div").show();
        } else if (type === "market" || type === "marketmanagement") {
            $(".info-div").show();
        } else if (type === "clothing") {
            clothingUi = true;
            $(".clothing").fadeIn(250);
            return;
        }

        $(".action-option").click(function(e) {

            $.post("http://chud/chooseActionOption", JSON.stringify({
                id: $(this).attr('id'),
            }));
        });

        refreshClothing();
        refreshActions();

        $(".ui").fadeIn(250);
    } else if (event.data.action == "setType") {
        if ($(".ui").css('display') === "block" && type === "menu" && event.data.type !== "menu") {
            $("#back").show();
        } else if ($(".ui").css('display') === "block" && event.data.type === "menu") {
            $("#back").hide();
        } else if ($(".ui").css('display') === "none") {
            $("#back").hide();
        }

        type = event.data.type;

        if (type === "shop") {
            currency = event.data.currency;
        } else if (type === "normal") {
            renderActivityLeaderboard();
        }
    } else if (event.data.action == "setSkin") {
        currentSkin = event.data.skin;

        refreshClothing();
    } else if (event.data.action == "setAvailableWeaponAttachments") {
        extras = event.data.extras;
    } else if (event.data.action == "buildIdCardBlob") {
        idcardBlobSetup(event.data);
    } else if (event.data.action == "setActions") {
        currentActions = event.data.actions;

        refreshActions();
    } else if (event.data.action == "setActivityLeaderboard") {
        currentActivityLeaderboard = event.data.leaderboard || null;

        if (type === "normal") {
            renderActivityLeaderboard();
        }
        } else if (event.data.action == "setActivityLeaderboardFocus") {
        currentActivityLeaderboardFocus = event.data.focus || "none";

        if (type === "normal") {
            renderActivityLeaderboard();
        }
    } else if (event.data.action == "setVotingData") {
        currentVotingData = event.data.voting || {parties: [], totalVotes: 0, selectedParty: null};

        if (currentVotingData.ended === true) {
            currentVotingTab = "results";
            currentVotingParty = null;
        } else if (currentVotingData.selectedParty !== null && currentVotingData.selectedParty !== undefined) {
            currentVotingParty = currentVotingData.selectedParty;
        } else if (getVotingParties().length > 0 && currentVotingParty === null) {
            currentVotingParty = getVotingParties()[0].name;
        }

        if (type === "voting") {
            renderVoting();
        }
    } else if (event.data.action == "hide") {
        if (clothingUi) {
            clothingUi = false;
            $(".clothing").fadeOut(250);
            $.post("http://chud/closeClothing", JSON.stringify({
                success: false
            }));
        }

        $("#dialog").dialog("close");
        $(".ui").fadeOut(250);

        setTimeout(() => {
            isInventoryAlreadyOpen = false;
            currentActivityLeaderboardFocus = "none";
            currentActivityLeaderboardPeriod = "monthly";
            $(".item").remove();
            $("#otherInventory").html("<div id=\"noSecondInventoryMessage\"></div>");
            $("#noSecondInventoryMessage").html(T("UI_INVENTORY_SECOND_NOT_AVAILABLE"));
        }, 250);
    } else if (event.data.action == "setItems") {
        inventorySetup(event.data);
    } else if (event.data.action == "updateValuesClothing") {
        updateValuesClothing(event.data);
    } else if (event.data.action == "setGarageTrunkInv") {
        garageTrunkPreviewInventorySetup(event.data);
    } else if (event.data.action == "disableGarageTrunkPreview") {
        $(".garage-info").css("height", "4.5vh");
        $(".garage-trunk").hide();
        $(`#garage-${event.data.id}`).css('height', '10vh');
        $(`#info-${event.data.id}`).text("🗺️ Veículo no mapa");
    } else if (event.data.action == "setMobileActionsCrafts") {
        if (type === "mobilecraft") {
            mobilecraftInventorySetup(event.data);
        }
    } else if (event.data.action == "setSecondInventoryItems") {
        if (type === "craft") {
            craftInventorySetup(event.data.itemList, event.data.isCraftingAndNotCanceled);
        } else if (type === "menu") {
            menuInventorySetup(event.data);
        } else if (type === "process") {
            processInventorySetup(event.data.itemList, event.data.buttonText);
        } else if (type === "listmenu") {
            listMenuInventorySetup(event.data.itemList);
        } else if (type === "textmenu") {
            textmenuInventorySetup(event.data);
        } else if (type === "mobilecraft") {
            mobilecraftInventorySetup(event.data);
        } else if (type === "garage") {
            garageInventorySetup(event.data);
        } else if (type === "idcard") {
            idcardInventorySetup(event.data);
        } else if (type === "vipdelivery") {
            vipDeliverySetup(event.data);
        } else if (type === "fishing") {
            fishingInventorySetup(event.data);
        } else if (type === "itemselector") {
            menuSelectorSetup(event.data);
        } else if (type === "customshop") {
            customShopSetup(event.data);
        } else if (type === "case") {
            caseInventorySetup(event.data);
        } else if (type === "clothing") {
            clothingInventorySetup(event.data);
        } else if (type === "market") {
            marketInventorySetup(event.data.itemList);
        } else if (type === "marketmanagement") {
            marketManagementSetup(event.data)
        } else if (type === "dispense") {
            dispenseInventorySetup(event.data);
        } else {
            secondInventorySetup(event.data.itemList);
        } 
    } else if (event.data.action == "setInfoText") {
        $(".info-div").html(event.data.text);
    } else if (event.data.action == "toggleQuickSlots") {
        toggleQuickSlots(event.data);
    } else if (event.data.action == "nearPlayers") {
        $("#nearPlayers").html("");

        $.each(event.data.players, function (index, player) {
            $("#nearPlayers").append('<button class="nearbyPlayerButton" data-player="' + player.player + '">' + player.player + '</button>');
        });

        $("#dialog").dialog("open");

        $(".nearbyPlayerButton").click(function () {
            $("#dialog").dialog("close");
            player = $(this).data("player");
            $.post("http://chud/GiveItem", JSON.stringify({
                player: player,
                item: event.data.item,
                number: parseInt($("#count").val())
            }));
        });
    } else if (event.data.action == "hud") {
        let part = event.data.part;

        if (part === "bank") {
            $("#bank").html(' 💳 ' + numberWithSpaces(event.data.text) + ' ');
        } else if (part === "coins") {
            $("#coins").html('| 💰 ' + numberWithSpaces(event.data.text) + ' ');
        } else if (part === "job") {
            $("#job").html('| ' + event.data.text + ' ');
        } else if (part === "jobMoney") {
            $("#jobMoney").html('| 💼 ' + numberWithSpaces(event.data.text) + ' ');
        } else if (part === "isBoss") {
            if (event.data.text === 'boss'){
                $("#jobMoney").css('display', 'initial');
            } else{
                $("#jobMoney").css('display', 'none');
            }
        }
    }
});

function shiftClickItem(itemData, itemInventory) {
    switch (itemInventory) {
        case "second":
            onMainInventory(itemData, itemInventory, true);
            break;
        case "main":
            onOtherInventory(itemData, itemInventory, true);
            break;
        default:
    }
}

function refreshClothing() {
    $(".clothe-option").removeClass("clothe-option-active");

    $.each(currentSkin, function (key, _) {
        $(`#${key}`).addClass("clothe-option-active");
    });
}

function refreshActions() {
    $(".action-option").removeClass("action-option-active");

    $.each(currentActions, function (key, active) {
        if (!active) return;

        $(`#${key}`).addClass("action-option-active");
    });
}

function toggleQuickSlots(data) {
    if (data.show) {
        for (let i = 1; i <= 5; i++) {
            if (!$( `#qslot-${i}` ).length) {
                $(".quickslots").append(/*html*/`<div class="slot main-slot" id="qslot-${i}"></div>`);
                $( `#qslot-${i}` ).data('slot', i);
            }
    
            $( `#qslot-${i}` ).empty();
    
            if (i <= 5) {
                $( `#qslot-${i}` ).append(/*html*/`<div class="item-slot">${i}</div>`);
            }
        }

        $.each(data.items, function (index, item) {
            if ($( `#qslot-${item.slot}` ).length) {
                count = setCount(item, false);
                $( `#qslot-${item.slot}` ).append('<div id="item-' + index + '" class="item-fastlots" style = "background-image: url(\'img/items/' + item.name + '.png\')" >' +
                    '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div></div>');
            }
        });

        $(".quickslots-ui").fadeIn(250);
    } else {
        $(".quickslots-ui").fadeOut(250);
    }
}

function extrasBuild() {
    if (metadataHover === undefined || metadataHover.length === 0) return;

    $(".extras-container").html("");

    $.each(metadataHover, function (index, item) {
        if (extras[item] === undefined) return;

        $(".extras-container").append('<div class="slot-extra"><div class="item" style = "background-image: url(\'img/items/' + extras[item].name + '.png\')" >' +
            '<div class="item-count">1</div> <div class="item-name">' + extras[item].label + '</div> </div ><div class="item-name-bg"></div></div>');
    });

    $(".extras-display").fadeIn(100);
}


let startX, startY;

function setDraggableItems() {
    if (isDragging) {
        reinitDragging = true;
        return;
    }

    $('.item').draggable({
        helper: function(event) {
            var customHelper = $(/*html*/
                `<div class="item-clone"></div>`
            );

            customHelper.css({
                'background-image': $(this).css('background-image'),
            });

            // Set data for the helper (copying data from the original item)
            customHelper.data('item', $(this).data('item'));  // Copy item data
            customHelper.data('inventory', $(this).data('inventory'));  // Copy inventory data
    
            // Append the helper to the body (or any container)
            $('body').append(customHelper);
    
            return customHelper;  // Return the custom helper to be used as the draggable element
        },
        appendTo: 'body',
        zIndex: 99999,
        containment: 'document',
        revert: 'invalid',
        start: function (event, ui) {
            if (disabled) {
                return false;
            }

            startX = event.pageX;
            startY = event.pageY;

            itemData = $(this).data("item");
            itemInventory = $(this).data("inventory");

            isDragging = true;

            $(this).css('opacity', '0.3');

            if (itemInventory == "second" || !itemData.canRemove) {
                $("#drop").addClass("disabled");
                $("#give").addClass("disabled");
            }

            if (itemInventory == "second" || !itemData.usable) {
                $("#use").addClass("disabled");
            }
        },
        stop: function (event, ui) {
            isDragging = false;

            let moveX = Math.abs(event.pageX - startX);
            let moveY = Math.abs(event.pageY - startY);

            itemData = $(this).data("item");
            itemInventory = $(this).data("inventory");

            if (event.shiftKey && moveX < 25 && moveY < 25) {
                shiftClickItem(itemData, itemInventory);
            }

            if (itemData !== undefined && itemData.name !== undefined) {
                $(this).css('opacity', '1.0');
                $("#drop").removeClass("disabled");
                $("#use").removeClass("disabled");
                $("#give").removeClass("disabled");
            }

            if (reinitDragging) {
                setDraggableItems();
                reinitDragging = false;
            }

            $(".slot").removeClass("slot-hover");
        }
    });

    $(".slot").on("mouseenter", function(e) {
        if ($(this).find(".item").data("item") === undefined) return;

        metadataHover = $(this).find(".item").data("item").metadata?.components;

        isHoveringItem = true;

        if (!isPresssingControl) return;

        extrasBuild();
    }).on("mouseleave", function(e) {
        isHoveringItem = false;
        $(".extras-display").fadeOut(100);
    });
}

function closeInventory() {
    isDragging = false;
    reinitDragging = false;

    $('.item-clone').remove();

    $.post("http://chud/NUIFocusOff", JSON.stringify({}));
}


/*function secondInventorySetup(items) {
    $("#otherInventory").html("");
    $.each(items, function (index, item) {
        count = setCount(item, true);

        $("#otherInventory").append('<div class="slot"><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "second");
    });
}*/

let menuData = {};

$("#back").click(function(e) {
    type = "menu";
    
    $("#back").hide();
    $.post("http://chud/backButtonPressed");
    menuInventorySetup(menuData);
});

function extractNameAndId(inputString) {
    const regex = /\{\{([^|]+)\|([^}]+)\}\}/g;
    const matches = [];
    let match;

    while ((match = regex.exec(inputString))) {
        const name = match[1].trim();
        const id = match[2].trim();
        matches.push({ name, id });
    }

    return matches;
}

function updateValuesClothing(data) {
    $.each(data.itemList, function (index, menuItem) {
        $(`#${menuItem.name}`).data('menuItem', menuItem);
        $(`#${menuItem.name}`).val(menuItem.value);
    });
}

let isClotheShop = false;

function buildCloakroom(list) {
    $(".clothing-container").html("");

    $.each(list, function (index, menuItem) {
        $(".clothing-container").append(/*html*/`<div class="clothing-option" id="${index+1}"></div>`)

        $(`#${index+1}`).text(menuItem.label);
        $(`#${index+1}`).append(/*html*/`
            <div class="clothing-option-select" id="${index+1}"></div>
            <div class="clothing-option-delete" id="${index+1}">X</div>
        `);
    });

    $(".clothing-option-select").click(function(e) {
        $.post("http://chud/clothingSelect", JSON.stringify({
            action: 'select',
            value: e.target.id,
        }));
    });

    $(".clothing-option-delete").click(function(e) {
        list.splice(parseInt(e.target.id)-1, 1);

        buildCloakroom(list);

        $.post("http://chud/clothingSelect", JSON.stringify({
            action: 'delete',
            value: e.target.id,
        }));
    });
}

$(".clothe-option").click(function(e) {

    $.post("http://chud/chooseClothingOption", JSON.stringify({
        id: $(this).attr('id'),
    }));
});

function Interval(time) {
    var timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function disableInventory(ms) {
    //disabled = true;

   // if (disabledFunction === null) {
    //    disabledFunction = new Interval(ms);
    //    disabledFunction.start();
    //} else {
    //    if (disabledFunction.isRunning()) {
    //        disabledFunction.stop();
    //    }

     //   disabledFunction.start();
    //}
}

function setCount(item, second) {
    if (second && type === "shop") {
        if (currency === "cash" || currency === "black_money") {
            return formatMoney(item.price) + '€';
        } else if (currency === "coins") {
            return formatMoney(item.price) + '💰';
        }
    }

    count = item.count

    if (item.limit > 0) {
        count = item.count + " / " + item.limit
    }

    if (item.type === "weapon") {
        if (item.metadata.ammo == 0 || item.metadata.ammo == undefined) {
            count = "";
        } else {
            count = '<img src="img/bullet.png" class="ammoIcon"> ' + item.metadata.ammo;
        }
    }

    if (item.type === "money") {
        count = formatMoney(item.count);
    }

    return count;
}

function getLabel(item) {
    let label = item.label;

    if (item.metadata !== undefined && item.metadata.label !== undefined) {
        label = item.metadata.label;
    }

    if (item.metadata !== undefined && item.metadata.customlabel !== undefined) {
        label = `<i>${item.metadata.customlabel}</i>`;
    }

    return label;
}

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};

function numberWithSpaces(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}

$(document).on("click", ".activity-board-period-tab", function () {
    const nextPeriod = String($(this).data("period") || "").toLowerCase();

    if (!isValidLeaderboardPeriod(nextPeriod) || nextPeriod === currentActivityLeaderboardPeriod) {
        return;
    }

    currentActivityLeaderboardPeriod = nextPeriod;
    renderActivityLeaderboard();
});

$(document).on("click", ".voting-tab", function () {
    const nextTab = String($(this).data("tab") || "").toLowerCase();

    if (nextTab !== "parties" && nextTab !== "results") {
        return;
    }

    currentVotingTab = nextTab;
    renderVoting();
});

$(document).on("click", ".voting-party-row", function () {
    currentVotingParty = String($(this).data("party") || "");
    renderVoting();
});

$(document).on("click", ".voting-vote-button", function () {
    if ($(this).prop("disabled") || $(this).hasClass("is-disabled")) {
        return;
    }

    const partyName = String($(this).data("party") || "");

    if (partyName === "") {
        return;
    }

    $.post("http://chud/VoteParty", JSON.stringify({party: partyName}));
});

$(document).ready(function () {
    $("#count").focus(function () {
        $(this).val("")
    }).blur(function () {
        if ($(this).val() == "") {
            $(this).val("1")
        }
    });

    $("body").on("keydown", function (key) {
        if (Config.closeKeys.includes(key.which)) {
            closeInventory();
        }

        if (key.which === 88 && clothingUi) {
            $.post("http://chud/clothingHandsup", JSON.stringify({}));
        }

        if (key.which === 13 && clothingUi && isClotheShop) { //enter
            $(".clothing-menu-buttons").fadeIn(250);
            $(".clothing-menu").css('filter', 'blur(2px)');
        }

        if (key.which === 65 && clothingUi) { //a
            $.post("http://chud/startSpin", JSON.stringify({
                direction: 'left'
            }));
        }

        if (key.which === 68 && clothingUi) { //d
            $.post("http://chud/startSpin", JSON.stringify({
                direction: 'right'
            }));
        }
        
        if (key.which === 37 && clothingUi) { //esquerda
            let currentVal = $('.clothing-shop-selected').children('.clothing-input').val();

            $('.clothing-shop-selected').children('.clothing-input').val(parseInt(currentVal)-1).trigger('input');
        } 

        if (key.which === 39 && clothingUi) { //direita
            let currentVal = $('.clothing-shop-selected').children('.clothing-input').val();

            $('.clothing-shop-selected').children('.clothing-input').val(parseInt(currentVal)+1).trigger('input');
        }

        if (key.which === 38 && clothingUi) { //up
            if ($('.clothing-shop-selected').prev().length > 0) {
                $('.clothing-shop-selected').removeClass('clothing-shop-selected').prev().addClass('clothing-shop-selected');

                var container = $('.clothing-container');
                var scrollTo = $(".clothing-shop-selected");
                var position = scrollTo.offset().top - container.offset().top*2  + container.scrollTop();
                container.animate({
                        scrollTop: position
                }, 100);
            }
        } 

        if (key.which === 40 && clothingUi) { //down
            if ($('.clothing-shop-selected').next().length > 0) {
                $('.clothing-shop-selected').removeClass('clothing-shop-selected').next().addClass('clothing-shop-selected');

                var container = $('.clothing-container');
                var scrollTo = $(".clothing-shop-selected");
                var position = scrollTo.offset().top - container.offset().top*2  + container.scrollTop();
                container.animate({
                        scrollTop: position
                }, 100);
            }
        } 


        if (key.which === 17) {
            if (isPresssingControl) return;

            isPresssingControl = true;

            if (!isHoveringItem) return;

            extrasBuild();
        }
    });

    $("body").on("keyup", function (key) {
        if ((key.which === 65 || key.which === 68) && clothingUi) {
            $.post("http://chud/stopSpin", JSON.stringify({}));
        }

        if (key.which === 17) {
            if (!isPresssingControl) return;

            isPresssingControl = false;
            $(".extras-display").fadeOut(100);
        }
    });


    $('#use').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.helper.data("item");

            if (itemData == undefined || itemData.usable == undefined) {
                return;
            }

            itemInventory = ui.helper.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            if (itemData.usable) {
                disableInventory(300);
                $.post("http://chud/UseItem", JSON.stringify({
                    item: itemData
                }));
            }
        }
    });

    $('#give').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.helper.data("item");

            if (itemData == undefined || itemData.canRemove == undefined) {
                return;
            }

            if (disableGive) {
                return;
            }

            itemInventory = ui.helper.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            if (itemData.canRemove) {
                disableInventory(300);
                $.post("http://chud/GetNearPlayers", JSON.stringify({
                    item: itemData
                }));
            }
        }
    });

    $('#drop').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.helper.data("item");

            if (itemData == undefined || itemData.canRemove == undefined) {
                return;
            }

            itemInventory = ui.helper.data("inventory");

            if (itemInventory == undefined || itemInventory == "second") {
                return;
            }

            if (itemData.canRemove) {
                disableInventory(60000);
                $.post("http://chud/DropItem", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });

    $('#otherInventory').droppable({
        drop: function (event, ui) {
            itemData = ui.helper.data("item");
            itemInventory = ui.helper.data("inventory");

            onOtherInventory(itemData, itemInventory, false);
        }
    });

    $("#count").on("keypress keyup blur", function (event) {
        $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });

    $(".clothing-button").click(function(e) {
        $.post("http://chud/chooseClothingCam", JSON.stringify({
            value: e.target.id,
        }));
    });

    $(document).on("click", ".item", function(e) {
        if (e.shiftKey) {
            itemData = $(this).data("item");
            itemInventory = $(this).data("inventory");

            shiftClickItem(itemData, itemInventory);
        }
    });

    $.post("http://chud/chudReady", JSON.stringify({}));
});

window.addEventListener('translationsReady', () => {
    $("#use").html(T("UI_INVENTORY_USE_ITEM"));
    $("#give").html(T("UI_INVENTORY_GIVE_ITEM"));
    $("#drop").html(T("UI_INVENTORY_DROP_ITEM"));
    $("#noSecondInventoryMessage").html(T("UI_INVENTORY_SECOND_NOT_AVAILABLE"));

    $('.clothing-button[id="fullBody"]').html(T("UI_CLOTHING_BODY"));
    $('.clothing-button[id="head"]').html(T("UI_CLOTHING_HEAD"));
    $('.clothing-button[id="body"]').html(T("UI_CLOTHING_TORSO"));
    $('.clothing-button[id="pants"]').html(T("UI_CLOTHING_PANTS"));
    $('.clothing-button[id="shoes"]').html(T("UI_CLOTHING_SHOES"));

    $('.clothing-button-final[id="confirm"]').html(T("UI_CONFIRM"));
    $('.clothing-button-final[id="cancel"]').html(T("UI_CANCEL"));

    $("#hud-lprofile").html(T("UI_WEAPON_EXTRAS"));
    $('.control[id="back"]').html(T("UI_BACK"));
});

function onOtherInventory(itemData, itemInventory, overrideInput) {
    let amount = (parseInt($("#count").val()) > itemData.count) || overrideInput ? itemData.count : parseInt($("#count").val());

    $("#dialog").dialog("close");

    if (itemInventory !== "main") return false;

    switch (type) {
        case "trunk":
            $.post("http://chud/PutIntoTrunk", JSON.stringify({item: itemData, number: amount}));
            break;
        case "property":
            $.post("http://chud/PutIntoProperty", JSON.stringify({item: itemData, number: amount}));
            break;
        case "tempinv":
            $.post("http://chud/PutIntoTempInv", JSON.stringify({item: itemData, number: amount}));
            break;
        case "org":
            $.post("http://chud/PutIntoOrg", JSON.stringify({item: itemData, number: amount}));
            break;
        case "market":
            $.post("http://chud/PutIntoMarket", JSON.stringify({item: itemData, number: amount, price: parseInt($("#price").val())}));
            break;
        case "casa":
            $.post("http://chud/PutIntoCasa", JSON.stringify({item: itemData, number: amount}));
            break;
        case "player":
            $.post("http://chud/PutIntoPlayer", JSON.stringify({item: itemData, number: amount}));
            break;
        default:
    }

    disableInventory(500);
}

$.widget('ui.dialog', $.ui.dialog, {
    options: {
        // Determine if clicking outside the dialog shall close it
        clickOutside: false,
        // Element (id or class) that triggers the dialog opening 
        clickOutsideTrigger: ''
    },
    open: function () {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger),
            that = this;
        if (this.options.clickOutside) {
            // Add document wide click handler for the current dialog namespace
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function (event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 &&
                    $target.closest($(that.uiDialog)).length === 0) {
                    that.close();
                }
            });
        }

        $(".controls-div").addClass("controls-div-hidden");

        // Invoke parent open method
        this._super();
    },
    close: function () {
        // Remove document wide click handler for the current dialog
        $(document).off('click.ui.dialogClickOutside' + this.eventNamespace);

        $(".controls-div").removeClass("controls-div-hidden");
        // Invoke parent close method 
        this._super();
    },
});