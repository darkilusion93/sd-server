function onMainInventory(itemData, itemInventory, overrideInput, toSlot) {
    let amount = (parseInt($("#count").val()) > itemData.count) || overrideInput ? itemData.count : parseInt($("#count").val());

    $("#dialog").dialog("close");

    if (itemInventory !== "second") return false;

    switch (type) {
        case "trunk":
            $.post("http://chud/TakeFromTrunk", JSON.stringify({item: itemData, number: amount, slot: toSlot}));
            break;
        case "property":
            $.post("http://chud/TakeFromProperty", JSON.stringify({item: itemData, number: amount, slot: toSlot}));
            break;
        case "tempinv":
            $.post("http://chud/TakeFromTempInv", JSON.stringify({item: itemData, number: amount, slot: toSlot}));
            break;
        case "market":
            $.post("http://chud/TakeFromMarket", JSON.stringify({item: itemData, number: amount, slot: toSlot}));
            break;
        case "org":
            $.post("http://chud/TakeFromOrg", JSON.stringify({item: itemData, number: amount, slot: toSlot}));
            break;
        case "shop":
            $.post("http://chud/BuyItem", JSON.stringify({item: itemData, number: parseInt($("#count").val()), slot: toSlot}));
            break;
        case "casa":
            $.post("http://chud/TakeFromCasa", JSON.stringify({item: itemData, number: amount, slot: toSlot}));
            break;
        case "player":
            $.post("http://chud/TakeFromPlayer", JSON.stringify({item: itemData, number: amount, slot: toSlot}));
            break;
        default:
    }

    disableInventory(500);
}

function inventorySetup(data) {
    let items = data.itemList;
    let slots = data.maxSlots;

    //$("#playerInventory").html("");

    currentInventory = items;
    currentSlots = slots;

    for (let i = 1; i <= slots; i++) {
        if (!$( `#slot-${i}` ).length) {
            $("#playerInventory").append(/*html*/`<div class="slot main-slot" id="slot-${i}"></div>`);
            $( `#slot-${i}` ).data('slot', i);
        }

        $( `#slot-${i}` ).empty();

        if (i <= 5) {
            $( `#slot-${i}` ).append(/*html*/`<div class="item-slot">${i}</div>`);
        }
    }

    $.each(items, function (index, item) {
        count = setCount(item, false);
        let label = getLabel(item);

        if (!$( `#slot-${item.slot}` ).length) {
            $("#playerInventory").append(/*html*/`<div class="slot main-slot" id="slot-${item.slot}"></div>`);
            $('#slot-' + item.slot).data('slot', item.slot);
        }

        $( `#slot-${item.slot}` ).append('<div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')" >' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + label + '</div></div>');
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
    });

    // Remove empty slots that are not in the item table
    $(`.slot`).each(function () {
        const slot = $(this).data('slot');

        // If the slot is not referenced and is beyond the allowed range, remove it
        if (slot > slots && !items.some(item => item.slot === slot)) {
            $(this).remove();
        }
    });

    setDraggableItems();

    // Make the slots droppable
    $('.main-slot').droppable({
        drop: function(event, ui) {
            const itemData = ui.helper.data("item");
            const itemInventory = ui.helper.data("inventory");

            if (itemInventory === "main" && !isPresssingControl) {
                $.post("http://chud/changeSlot", JSON.stringify({
                    fromSlot: itemData.slot,
                    toSlot: $(this).data("slot")
                }));
                return;
            }

            if (itemInventory === "main" && isPresssingControl) {
                $.post("http://chud/splitSlot", JSON.stringify({
                    fromSlot: itemData.slot,
                    toSlot: $(this).data("slot")
                }));
                return;
            }

            if (itemInventory === "dispense") {
                dropOnDispenseContainer(itemData, itemInventory);
                return;
            }

            onMainInventory(itemData, itemInventory, false, $(this).data("slot"));
        },
        over: function (event, ui) {
            $(this).addClass("slot-hover"); // Temporarily add class to simulate hover
        },
        out: function (event, ui) {
            $(this).removeClass("slot-hover"); // Remove temporary class
        },
    });
}