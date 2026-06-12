function textmenuInventorySetup(data) {
    $("#otherInventory").html(/*html*/`
        <div class="textmenu-container"><input type="text" id="textmenu" class="textmenu-input" placeholder="${data.itemList}"></div>
        <div class="textmenu-buttons">
            <div class="textmenu-button textmenu-accept">${T("UI_CONFIRM")}</div>
            <div class="textmenu-button textmenu-cancel">${T("UI_CANCEL")}</div>
        </div>
    `);

    $(".textmenu-accept").click(function(e) {
        //disableInventory(500);
        $.post("http://chud/textmenuSubmit", JSON.stringify({
            value: $("#textmenu").val(),
        }));
    });

    $(".textmenu-cancel").click(function(e) {
        //disableInventory(500);
        $.post("http://chud/textmenuSubmit", JSON.stringify({
            value: "",
        }));
    });
}