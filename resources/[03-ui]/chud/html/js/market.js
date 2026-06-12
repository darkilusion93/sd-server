let marketSearchString = '';
let marketItems = {};
let marketSortType = 0;

function populateMarket(items) {
    $(".market-items").html('');

    $.each(items, function (index, item) {
        if (item.label.toLowerCase().includes(marketSearchString)) {
            let count = formatMoney(item.price) + '€';
            let isOwner = '';
            if (item.isOwner) isOwner = 'item-name-owner';
        
            $(".market-items").append('<div class="slot"><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
                '<div class="item-count">' + count + '</div> <div class="item-name '+ isOwner +'">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
            $('#itemOther-' + index).data('item', item);
            $('#itemOther-' + index).data('inventory', "second");
        }
    });

    setDraggableItems();
}

function marketInventorySetup(items) {
    let sortString = '';

    const marketItemsInit = [...items];
    marketItems = items;

    switch (marketSortType) {
        case 0:
            marketItems = [...marketItemsInit];
            sortString = T("UI_SORT_RELEVANCE");
            break;
        case 1:
            marketItems = marketItems.sort((a, b) => {return a.price - b.price})
            sortString = T("UI_SORT_PRICE_ASC");
            break;
        case 2:
            marketItems = marketItems.sort((a, b) => {return b.price - a.price})
            sortString = T("UI_SORT_PRICE_DESC");
            break;
    }

    $("#otherInventory").html('<div class="market-search"><input type="string" class="market-input" id="search" placeholder="'+T("UI_SEARCH")+'" value="'+marketSearchString+'"><div class="market-sort" id="sort">'+sortString+'</div></div><div class="market-items"></div>');
    $(".market-sort").click(function() {
        marketSortType ++;

        if (marketSortType > 2) marketSortType = 0;

        switch (marketSortType) {
            case 0:
                marketItems = [...marketItemsInit];
                sortString = T("UI_SORT_RELEVANCE");
                break;
            case 1:
                marketItems = marketItems.sort((a, b) => {return a.price - b.price})
                sortString = T("UI_SORT_PRICE_ASC");
                break;
            case 2:
                marketItems = marketItems.sort((a, b) => {return b.price - a.price})
                sortString = T("UI_SORT_PRICE_DESC");
                break;
        }

        $(".market-sort").text(sortString);

        populateMarket(marketItems);
    });

    $(".market-input").on("keyup", function() {
        var value = $(this).val().toLowerCase();
    
        marketSearchString = value;

        populateMarket(marketItems);
    });

    $.each(marketItems, function (index, item) {
        if (marketSearchString === '' || item.label.toLowerCase().includes(marketSearchString)) {
            let count = formatMoney(item.price) + '€';
            let isOwner = '';
            if (item.isOwner) isOwner = 'item-name-owner';
        
            $(".market-items").append('<div class="slot"><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
                '<div class="item-count">' + count + '</div> <div class="item-name '+ isOwner +'">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
            $('#itemOther-' + index).data('item', item);
            $('#itemOther-' + index).data('inventory', "second");
        }
    });
}