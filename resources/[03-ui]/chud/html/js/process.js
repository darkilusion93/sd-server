function processableItem(index, items, buttonText) {
    let item = items[index];

    $("#otherInventory").html(/*html*/`
        <div class="processing-what">
            <div id="prev"><i class="arrow left"></i></div>
            <div class="slot-processing">
                <div id="itemOther-${index}" class="item-selector" style = "background-image: url('img/items/${item.name}.png')"></div>
                <div class="item-name">${item.label}</div>
            </div>
            <div id="next"><i class="arrow right"></i></div>
        </div>
        <div class="process-button" id="process-start"><div class="button-process">${buttonText}</div></div>
        <div class="processing-output"></div>
        <div class="processing-separator"></div>
        <div class="processing-upgrades"></div>
    `);

    $.each(item.output, function (index, item) {
        $(".processing-output").append(/*html*/`
            <div class="slot-processing">
                <div id="itemOther-${index + 1}" class="item-selector" style = "background-image: url('img/items/${item.name}.png')">
                    <div class="item-count">${item.count}</div>
                    <div class="item-name">${item.label}</div>
                </div>
                <div class="item-name-bg"></div>
            </div>
        `);
    });

    $.each(item.upgrades, function (index, item) {
        $(".processing-upgrades").append(/*html*/`
            <div class="slot-upgrade" id="process-${index + 1}">
                <div id="itemOther-${index + 1}" class="item-selector" style = "background-image: url('img/items/${item.name}.png')">
                    <div class="item-count">${item.count}/${item.max}</div>
                    <div class="item-name">${item.label}</div>
                </div>
                <div class="item-name-bg"></div>
            </div>
        `);
    });

    $("#prev").click(function() {
        if (index > 0) {
            index = index - 1;
            processableItem(index, items, buttonText);
        } 
    });

    $("#next").click(function() {
        if (index < (items.length - 1)) {
            index = index + 1;
            processableItem(index, items, buttonText);
        }
    });

    $('.slot-upgrade').droppable({
        hoverClass: 'upgradeHover',
        drop: function (event, ui) {
            let itemData = ui.draggable.data("item");

            disableInventory(300);
            $.post("http://chud/upgradeProcess", JSON.stringify({
                item: itemData,
                id: $(this).attr('id'),
                number: parseInt($("#count").val())
            }));
        }
    });

    $("#process-start").click(function() {
        disableInventory(500);
        $.post("http://chud/startProcess", JSON.stringify({
            itemIndex: index + 1,
            value: item.name,
            number: parseInt($("#count").val())
        }));
    });
}

function processInventorySetup(items, buttonText) {
    $("#otherInventory").html("");
    let index = 0;  

    processableItem(index, items, buttonText);
}