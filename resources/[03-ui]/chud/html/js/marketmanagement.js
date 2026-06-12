let selectedSaleItem = null;

function marketManagementSetup(data) {
    $("#otherInventory").html("");

    $("#otherInventory").append(/*html*/`
        <div class="market-management-items">
            <div class="market-management-items-container"></div>
        </div>
        <div class="market-management-controls">
                <input type="string" class="market-management-input" id="search" placeholder="${T("UI_VALUE_UNITY")}" value="">
                <div class="market-management-sell" id="sort">${T("UI_SELL")}</div>
        </div>
        <div class="market-management-onSale">
            <div class="market-management-onSale-container"></div>
        </div>
    `);


    $.each(data.items, function (index, item) {
        item.limit = -1;

        let count = setCount(item, true);
        let isSelected = '';
        let isOnsale = false;
        //if (item.isOwner) isSelected = 'item-name-owner';
        //check if item is on sale to prevent it from being selected
        $.each(data.onSale, function (index2, item2) {
            if (item2.item == item.name && item2.slot == item.slot) {
                isOnsale = true;
                return;
            }
        });
    
        if (isOnsale) {
            return;
        }
    
        $(".market-management-items-container").append('<div class="slot"><div id="itemOther-' + index + '" class="item-market" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name '+ isSelected +'">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "second");
    });

    $.each(data.onSale, function (index, item) {
        item.limit = -1;

        let count = formatMoney(item.price) + '€';
        let isSelected = '';
        //if (item.isOwner) isSelected = 'item-name-owner';
    
        $(".market-management-onSale-container").append('<div class="slot"><div id="itemOther2-' + index + '" class="item-market-listed" style = "background-image: url(\'img/items/' + item.item + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name '+ isSelected +'">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#itemOther2-' + index).data('item', item);
        $('#itemOther2-' + index).data('inventory', "second");
    });

    $(".item-market").click(function(e) {
        let item = $(this).data('item');

        selectedSaleItem = item;

        $(".item-name").removeClass("item-name-owner");
        $(this).find('.item-name').addClass('item-name-owner');
    });

    $(".item-market-listed").click(function(e) {
        let item = $(this).data('item');

        console.log(item);
    });

    $(".market-management-sell").click(function(e) {
        if (selectedSaleItem) {
            $.post("http://chud/PutOnMarketSale", JSON.stringify({
                item: selectedSaleItem,
                price: parseInt($(".market-management-input").val()),
            }));
        }
    });
}