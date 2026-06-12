function fishingInventorySetup(data) {
    $("#otherInventory").html("");
    
    $("#otherInventory").append(/*html*/`
        <div class="fishing-slots">
            <div id="fishing-slot-1" class="fishing-slot">
                <div class="fishing-slot-background" style="background-image: url('img/items/bait1.png')">
                    <div class="item-name">${T("UI_FISHING_BAIT")}</div>
                </div>
            </div>
            <div id="fishing-slot-2" class="fishing-slot">
                <div class="fishing-slot-background" style="background-image: url('img/items/hook1.png')">
                    <div class="item-name">${T("UI_FISHING_HOOK")}</div>
                </div>
            </div>
            <div id="fishing-slot-3" class="fishing-slot">
                <div class="fishing-slot-background" style="background-image: url('img/items/weaknylon.png')">
                    <div class="item-name">${T("UI_FISHING_NYLON")}</div>
                </div>
            </div>
            <div id="fishing-slot-4" class="fishing-slot">
                <div class="fishing-slot-background" style="background-image: url('img/items/weakreel.png')">
                    <div class="item-name">${T("UI_FISHING_REEL")}</div>
                </div>
            </div>
        </div>
        <div class="fishing-action">
            <div class="fishing-rod" style="background-image: url('img/items/${data.itemList.rod}.png');"></div>
            <div class="fishing-start">${T("UI_FISHING")}</div>
        </div>
    `);

    if (data.itemList.items['fishing-slot-1'] !== undefined) {
        $("#fishing-slot-1").html('');
        $("#fishing-slot-1").append('<div class="fishing-slot-background-normal" style = "background-image: url(\'img/items/' + data.itemList.items['fishing-slot-1'].name + '.png\')" >' +
        '<div class="item-count"></div> <div class="item-name">' + data.itemList.items['fishing-slot-1'].label + '</div> </div ><div class="item-name-bg"></div>');
    }

    if (data.itemList.items['fishing-slot-2'] !== undefined) {
        $("#fishing-slot-2").html('');
        $("#fishing-slot-2").append('<div class="fishing-slot-background-normal" style = "background-image: url(\'img/items/' + data.itemList.items['fishing-slot-2'].name + '.png\')" >' +
        '<div class="item-count"></div> <div class="item-name">' + data.itemList.items['fishing-slot-2'].label + '</div> </div ><div class="item-name-bg"></div>');
    }

    if (data.itemList.items['fishing-slot-3'] !== undefined) {
        $("#fishing-slot-3").html('');
        $("#fishing-slot-3").append('<div class="fishing-slot-background-normal" style = "background-image: url(\'img/items/' + data.itemList.items['fishing-slot-3'].name + '.png\')" >' +
        '<div class="item-count"></div> <div class="item-name">' + data.itemList.items['fishing-slot-3'].label + '</div> </div ><div class="item-name-bg"></div>');
    }

    if (data.itemList.items['fishing-slot-4'] !== undefined) {
        $("#fishing-slot-4").html('');
        $("#fishing-slot-4").append('<div class="fishing-slot-background-normal" style = "background-image: url(\'img/items/' + data.itemList.items['fishing-slot-4'].name + '.png\')" >' +
        '<div class="item-count"></div> <div class="item-name">' + data.itemList.items['fishing-slot-4'].label + '</div> </div ><div class="item-name-bg"></div>');
    }

    $('.fishing-slot').droppable({
        hoverClass: 'hoverFastControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            let id = $(this).attr('id');

            $.post("http://chud/updateFishing", JSON.stringify({
                slot: id,
                item: itemData.name,
                label: itemData.label
            }), function(success){
                if (success) {
                    $("#"+id).html('');
                    $("#"+id).append('<div class="fishing-slot-background-normal" style = "background-image: url(\'img/items/' + itemData.name + '.png\')" >' +
                    '<div class="item-count"></div> <div class="item-name">' + itemData.label + '</div> </div ><div class="item-name-bg"></div>');
                } else {
                    $(".fishing-slot").addClass('fishing-slot-error');
                    setTimeout(function(){
                        $(".fishing-slot").removeClass('fishing-slot-error');
                    }, 250)
                }
            });
        }
    });

    $(".fishing-start").click(function() {
        disableInventory(500);
        $.post("http://chud/startFishing", JSON.stringify({
            rod: data.itemList.rod,
        }));
    });
}