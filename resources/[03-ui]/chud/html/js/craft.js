let currentCraftPage = 0;
let lastCraftStartedPage = -1;

function craftInventorySetup(craftData, isCraftingAndNotCanceled) {
    $("#otherInventory").html("");

    craftableItem(craftData, isCraftingAndNotCanceled);
}

function craftableItem(craftData, isCraftingAndNotCanceled) {
    let items = craftData.items;

    if (currentCraftPage > (items.length - 1)) {
        currentCraftPage = 0;
    }

    let item = items[currentCraftPage];
    let isAbleToCraft = true;
    let requiredLevel = 0;

    if (item.needXp || item.needOrgXp) {
        requiredLevel = item.level || 0;
        let currentLevel = item.currentLevel || 0;
        if (currentLevel < requiredLevel) {
            isAbleToCraft = false;
        }
    }

    $("#otherInventory").html("");

    $("#otherInventory").append(/*html*/`
        <div class="crafting-page">
            <div class="crafting-page-container">
                ${craftData.enableInfluence ? `<div>${T("UI_INFLUENCE")}: ${craftData.influencerLabel} - ${parseInt(craftData.influencerLevel/10)}%</div>` : ""}
                <div>${T("UI_PAGE")}: ${(currentCraftPage + 1)+"/"+(items.length)}</div>
                <div class="${craftData.isInfluencer && item.influenceTime ? "count-green" : ""}">⌛ ${craftData.isInfluencer && item.influenceTime ? parseInt(item.influenceTime/1000) : parseInt(item.time/1000)}s</div>
            </div>
        </div>
    `);

    $("#otherInventory").append('<div class="crafting-what"></div>');

    $(".crafting-what").append('<div id="prev"><i class="arrow left"></i></div>');

    $(".crafting-what").append(/*html*/`
        <div class="slot-craft">
            <div id="itemOther-${currentCraftPage}" class="item-selector" style ="background-image: url(\'img/items/${item.name || item.vehicle}.png\')">
                <div class="item-count ${craftData.isInfluencer && item.influenceCount ? "count-green" : ""}">${craftData.isInfluencer && item.influenceCount ? (item.influenceCount) : (item.count || 1)}</div>
                <div class="item-name">${item.label || item.vehicle}</div>
            </div>
        </div>`);

    $(".crafting-what").append('<div id="next"><i class="arrow right"></i></div>');

    if (item.craft) {
        const buttonLabel = isCraftingAndNotCanceled && lastCraftStartedPage === currentCraftPage ? T("GENERIC_CANCEL") : (!isAbleToCraft ? `[🔒] ${T("UI_CRAFT_LEVEL")} ${requiredLevel}` : T("GENERIC_CRAFT"));
        $("#otherInventory").append(/*html*/`<div class="slot-button" id="craft-buy"><button class="${!isAbleToCraft ? "button-craft-disabled" : "button-craft"}"><span>${buttonLabel} </span></button></div>`);
    } else {
        const buttonLabel = isCraftingAndNotCanceled && lastCraftStartedPage === currentCraftPage ? T("GENERIC_CANCEL") : (!isAbleToCraft ? `[🔒] ${T("UI_CRAFT_LEVEL")} ${requiredLevel}` : T("GENERIC_BUY"));
        $("#otherInventory").append(/*html*/`<div class="slot-button" id="craft-buy"><button class="${!isAbleToCraft ? "button-buy-disabled" : "button-buy"}"><span>${buttonLabel} </span></button></div>`);
    }

    $("#otherInventory").append('<div class="crafting-needs"></div>');

    $.each(item.needs, function (index, item) {
        $(".crafting-needs").append('<div class="slot"><div id="itemOther-' + currentCraftPage + 1 + '" class="item-selector" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            `<div class="item-count ${craftData.isInfluencer && item.influenceCount ? "count-green" : ""}">${craftData.isInfluencer && item.influenceCount ? (item.influenceCount) : (item.count || 1)}</div> <div class="item-name">${item.label}</div> </div ><div class="item-name-bg"></div></div>`);
    });

    $("#prev").click(function() {
        if (currentCraftPage > 0) {
            currentCraftPage -= 1;
            craftableItem(craftData, isCraftingAndNotCanceled);
        } 
    });

    $( "#next" ).click(function() {
        if (currentCraftPage < (items.length - 1)) {
            currentCraftPage += 1;
            craftableItem(craftData, isCraftingAndNotCanceled);
        }
    });

    $( "#craft-buy" ).click(function() {
        if (!isAbleToCraft) return;

        lastCraftStartedPage = currentCraftPage;

        disableInventory(500);
        $.post("http://chud/CraftItem", JSON.stringify({
            itemIndex: currentCraftPage + 1,
            number: parseInt($("#count").val())
        }));
    });
}