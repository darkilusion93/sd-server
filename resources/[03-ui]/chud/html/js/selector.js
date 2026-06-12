function menuSelectorSetup(data) {
    $("#otherInventory").html("");

    let itemData = {};

    $("#otherInventory").html(/*html*/`
        <div class='selector-container'></div>
        <div class='selector-button'>${data.buttonText}</div>
    `);

    $(".selector-button").addClass('selector-button-invalid');

    $.each(data.itemList, function (index, menuItem) {
        $(".selector-container").append(/*html*/`
            <div class="slot-selector">
                <div id="itemOther-${index}" class="item-selector" style = "background-image: url(\'img/items/${menuItem.value}.png\')">
                    <div class="item-count"></div>
                    <div class="item-name">${menuItem.label}</div>
                </div>
            </div>`);
        $('#itemOther-' + index).data('item', menuItem);
    });

    if (data.extraItemList !== undefined && data.extraItemList.length > 0) {
        $("#otherInventory").append(/*html*/`
            <div class="selector-separator"></div>
            <div class="selector-extraitems"></div>
        `);
        $.each(data.extraItemList, function (index, item) {
            $(".selector-extraitems").append(/*html*/`
                <div class="slot-upgrade" id="process-${index + 1}">
                    <div id="itemOther-${index + 1}" class="item-selector" style = "background-image: url('img/items/${item.name}.png')">
                        <div class="item-count">${item.count}</div>
                        <div class="item-name">${item.label}</div>
                    </div>
                    <div class="item-name-bg"></div>
                </div>
            `);
        });
    }

    $(".slot-selector").click(function(e) {
        //disableInventory(500);
        $('.slot-selector').removeClass('slot-selected');
        $(this).addClass('slot-selected');

        itemData = $(this).children('.item-selector').data("item");

        $(".selector-button").removeClass('selector-button-invalid');
    });

    $(".selector-button").click(function(e) {
        //disableInventory(500);
        if (itemData.value === undefined || itemData.value === null) {
            return false;
        }

        $.post("http://chud/selectItem", JSON.stringify({
            value: itemData.value,
        }));
    });
}