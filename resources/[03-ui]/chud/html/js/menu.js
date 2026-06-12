function menuInventorySetup(data) {
    $("#otherInventory").html("");

    menuData = data

    $.each(data.itemList, function (index, menuItem) {
        $("#otherInventory").append('<div class="slot-option" id="'+ menuItem.value +'"><span class="slot-option-text-header" id="'+ menuItem.value +'">'+ menuItem.label +'</span></div>')
    });

    $(".slot-option").click(function(e) {
        //disableInventory(500);
        $.post("http://chud/menuSelect", JSON.stringify({
            value: e.target.id,
        }));
    });
}