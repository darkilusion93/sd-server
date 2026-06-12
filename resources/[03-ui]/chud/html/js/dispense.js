let dispenseItems = {};
let dispenseFilter = {};
let dispenseLimit = 0;

let dispenseFinal = [];

function addDispenseItem(itemData, count) {
    let found = false

    $.each(dispenseItems, function (index, item) {
        if ( item.name === itemData.name ) {
            dispenseItems[index].count += count;
            found = true;
        }
    });

    if (!found) {
        let newItem = JSON.parse(JSON.stringify(itemData));
        newItem.count = count;
        Array.prototype.push.call(dispenseItems, newItem)
    }
}

function addInventoryItem(itemData, count) {
    let found = false

    $.each(currentInventory, function (index, item) {
        if ( item.name === itemData.name ) {
            currentInventory[index].count += count;
            found = true;
        }
    });

    if (!found) {
        let newItem = JSON.parse(JSON.stringify(itemData));
        newItem.count = count;
        Array.prototype.push.call(currentInventory, newItem)
    }
}

function dropOnDispenseContainer(itemData, itemInventory){
    const count = (itemData.type === "weapon") ? 1 : parseInt($("#count").val());  
    let curCount = 0;

    Array.prototype.filter.call(dispenseItems, (it => curCount += (it.type === "weapon") ? 1 : it.count));

    if (itemInventory === "main") {
        if (dispenseLimit === -1) {
            $(".info-div").html(`${T("UI_STOCK")}<br>${curCount+count}`);
        } else {
            $(".info-div").html(`${T("UI_STOCK")}<br>${curCount+count}/${dispenseLimit}`);
        }

        if (dispenseLimit !== -1 && curCount+count > dispenseLimit) {
            return;
        }

        if (dispenseFilter.length > 0 && !dispenseFilter.includes(itemData.name)) {
            $(".dispense-container").addClass('dispense-container-invalid');
            setTimeout(function(){
                $(".dispense-container").removeClass('dispense-container-invalid');
            }, 250)
            return;
        }

        $.each(currentInventory, function (index, item) {
            if ( item.name === itemData.name) {
                if ( itemData.type === "item"  && item.count >= count ) {
                    if ( item.count === count ) {
                        currentInventory = currentInventory.filter(it => it.name !== itemData.name);
                    } else {
                        currentInventory[index].count -= count;
                    }
    
                    addDispenseItem(itemData, count);
                } else if ( itemData.type === "weapon" ) {
                    currentInventory = currentInventory.filter(it => it.name !== itemData.name);
                    
                    addDispenseItem(itemData, itemData.count);
                }
            }
        });
    } else {
        if (dispenseLimit === -1) {
            $(".info-div").html(`${T("UI_STOCK")}<br>${curCount-count}`);
        } else {
            $(".info-div").html(`${T("UI_STOCK")}<br>${curCount-count}/${dispenseLimit}`);
        }

        $.each(dispenseItems, function (index, item) {
            if ( item.name === itemData.name ) {
                if ( itemData.type === "item"  && item.count >= count ) {
                    if ( item.count === count ) {
                        dispenseItems = Array.prototype.filter.call(dispenseItems, (it => it.name !== itemData.name));
                    } else {
                        dispenseItems[index].count -= count;
                    }

                    addInventoryItem(itemData, count);
                } else if ( itemData.type === "weapon" ) {
                    dispenseItems = Array.prototype.filter.call(dispenseItems, (it => it.name !== itemData.name));
                    
                    addInventoryItem(itemData, itemData.count);
                }
            }
        });
    }

    $(".dispense-container").html("");
    dispenseFinal = [];

    $.each(dispenseItems, function (index, item) {
        const count = setCount(item, true);
        $(".dispense-container").append('<div class="slot-dispense" id="class-item-' + index + '""><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')" >' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "dispense");

        dispenseFinal.push({name:item.name, count:item.count});
    });

    inventorySetup({itemList: currentInventory, maxSlots: currentSlots});

    $("#drop").removeClass("disabled");
    $("#use").removeClass("disabled");
    $("#give").removeClass("disabled");
}

function dispenseInventorySetup(data) {
    $("#otherInventory").html("");

    dispenseItems = {};
    dispenseFilter = data.itemFilter;
    dispenseLimit = data.itemLimit;

    $("#otherInventory").append(/*html*/`
        <div class="dispense-container"></div>
        <div class="dispense-button">${data.buttonTitle}</div>
    `);

    $('.dispense-container').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (itemInventory === "main") {
                dropOnDispenseContainer(itemData, itemInventory);
                return;
            }
        }
    });

    $(".dispense-button").click(function(e) {
        //disableInventory(500);
        $.post("http://chud/dispenseAction", JSON.stringify({
            value: dispenseFinal,
        }));
    });
}