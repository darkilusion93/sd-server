function clothingInventorySetup(data) {
    $(".clothing-container").html("");

    isClotheShop = false;

    if (data.type === 'cloakroom') {
        let list = data.itemList;
        buildCloakroom(list);
    } else {
        isClotheShop = true;

        let itemClass = "clothing-shop clothing-shop-selected";

        $.each(data.itemList, function (index, menuItem) {
            $(".clothing-container").append(/*html*/`
                <div class="${itemClass}">
                    ${menuItem.label}
                    <input type="number" id="${menuItem.name}" class="clothing-input" value="${menuItem.value}"></input>
                </div>`);

            $(`#${menuItem.name}`).data('menuItem', menuItem);
            itemClass = "clothing-shop";
        });

        $('.clothing-input').on('input',function(e){
            let menuItem = $(`#${e.target.id}`).data('menuItem');
            let inputObject = $("#"+e.target.id);

            if (inputObject.val() > menuItem.max) inputObject.val(menuItem.max);
            if (inputObject.val() < menuItem.min) inputObject.val(menuItem.min);

            $.post("http://chud/clothingShopUpdate", JSON.stringify({
                name: e.target.id,
                value: inputObject.val()
            }));
        });

        $(".clothing-shop").click(function(e) {
            $('.clothing-shop').removeClass('clothing-shop-selected');
            $(this).addClass('clothing-shop-selected');
        });

        $(".clothing-button-final").click(function(e) {
            if (e.target.id === 'confirm') {
                $(".clothing-menu-buttons").fadeOut(250);
                $(".clothing-menu").css('filter', 'blur(0px)');

                if (clothingUi) {
                    clothingUi = false;
                    $(".clothing").fadeOut(250);
                    $.post("http://chud/closeClothing", JSON.stringify({
                        success: true
                    }));
                }
            }

            if (e.target.id === 'cancel') {
                $(".clothing-menu-buttons").fadeOut(250);
                $(".clothing-menu").css('filter', 'blur(0px)');
            }
        });
    }
}
