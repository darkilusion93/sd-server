function customShopSetup(data) {
    $("#otherInventory").html(/*html*/`
        <div class='customshop-container'></div>
        <div class='customshop-button'>${data.buttonText}</div>
    `);

    $(".customshop-button").addClass('customshop-button-invalid');

    $.each(data.itemSelector, function (index, menuItem) {
        $(".customshop-container").append('<div class="slot-shop-selector"><div id="itemSelector-' + index + '" class="item-selector" style = "background-image: url(\'img/items/' + menuItem.value + '.png\')">' +
        '</div> <div class="item-name">' + menuItem.label + '</div></div></div>');
        $('#itemSelector-' + index).data('item', menuItem);
    });

    $("#otherInventory").append(/*html*/`
        <div class="customshop-separator"></div>
        <div class="customshop-items"></div>
    `);

    $.each(data.itemList, function (index, item) {
        let count = formatMoney(item.price) + '€';

        $(".customshop-items").append(/*html*/`
            <div class="slot-shop" id="itemOther-${index}">
                <div class="item-shop" style = "background-image: url(img/items/${item.name}.png)">
                    <div class="item-count">${count}</div>
                    <div class="item-name">${item.label}</div>
                </div>
                <div class="item-name-bg"></div>
            </div>
        `);
        $(`#itemOther-${index}`).data("item", item);
    });

    let selectedItems = [];
    let itemData = undefined;

    $(".slot-shop").click(function(e) {
        //disableInventory(500);
        if ($(this).hasClass("slot-shop-selected")) {
            $(this).removeClass("slot-shop-selected");
            selectedItems = selectedItems.filter(element => element !== $(this).data("item").name);
        } else {
            $(this).addClass("slot-shop-selected");
            selectedItems.push($(this).data("item").name);
        }
    });

    $(".slot-shop-selector").click(function(e) {
        //disableInventory(500);
        $('.slot-shop-selector').removeClass('slot-selected');
        $(this).addClass('slot-selected');

        itemData = $(this).children('.item-selector').data("item");

        $(".customshop-button").removeClass('customshop-button-invalid');
    });

    $(".customshop-button").click(function(e) {
        //disableInventory(500);
        if (itemData.value === undefined || itemData.value === null) {
            return false;
        }

        $.post("http://chud/buyCustomShopItem", JSON.stringify({
            items: selectedItems,
            selectedOption: itemData.value,
            amount: parseInt($("#count").val())
        }));
    });
}