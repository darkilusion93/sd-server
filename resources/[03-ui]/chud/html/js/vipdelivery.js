function vipDeliverySetup(data) {
    $("#otherInventory").html(/*html*/`
        <div class="vip-package-container"></div>
        <div class="vip-package-buttons">
            <div class="vip-package-button-separator"></div>
            <div class="vip-package-button-accept">
                <div class="vip-package-delivered-text">${T("UI_CLOSE_CONFIRM")}</div>
            </div>
        </div>
    `);

    $.each(data.itemList, function (index, vipLabel) {
        $(".vip-package-container").append(/*html*/`
            <div class="vip-package-delivered">
                <div class="vip-package-delivered-image" style="background-image: url('img/vips.png')">
                    <div class="item-name">${T("UI_VIP_PACK")}</div>
                </div>
                <div class="vip-package-delivered-header">
                    <div class="vip-package-delivered-text">${vipLabel}</div>
                </div>
                <div class="vip-package-delivered-count">
                    <div class="vip-package-delivered-text">x1</div>
                </div>
            </div>
        `);
    });

    $(".vip-package-button-accept").click(function(e) {
        //disableInventory(500);
        $.post("http://chud/checkVipItems", JSON.stringify({}));
    });
}