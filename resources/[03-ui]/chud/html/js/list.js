let listSearchString = '';

function buildListMenuInventory(data) {
    $.each(data.rows, function (index, rowItem) {
        let addElement = false;

        $.each(rowItem.cols, function (index1, colItem) {
            const extractedData = extractNameAndId(colItem);

            if (extractedData.length === 0){
                if (listSearchString === '' || colItem.toLowerCase().includes(listSearchString)) {
                    addElement = true;
                }
            }
        }); 

        if (addElement) {
            $(".list-items").append(/*html*/`<div class="listmenu-item" id="listmenu-item-${index}"></div>`);
            
            $.each(rowItem.cols, function (index1, colItem) {
                const extractedData = extractNameAndId(colItem);

                if (extractedData.length === 0){
                    $(`#listmenu-item-${index}`).append(/*html*/`<div class="listmenu-formating">${colItem}</div>`);
                } else {
                    $(`#listmenu-item-${index}`).append(/*html*/`<div class="listmenu-formating" id="listmenu-button-${index}"></div>`);

                    $.each(extractedData, function (index2, buttonItem) {
                        $(`#listmenu-button-${index}`).append(/*html*/`<div class="listmenu-formating listmenu-button" id="${buttonItem.id}">${buttonItem.name}</div>`);
                    });
                }
            }); 

            $(`#listmenu-item-${index}`).data('employee', rowItem.data);
        }
    });

    $(".listmenu-button").click(function(e) {
        //disableInventory(500);
        $.post("http://chud/listMenuChoose", JSON.stringify({
            value: e.target.id,
            data: $(this).parent().parent().data('employee')
        }));
    });
};

function listMenuInventorySetup(data) {
    $("#otherInventory").html(/*html*/`<div class="listmenu-header"></div>`);

    $.each(data.head, function (index, headerItem) {
        $(".listmenu-header").append(/*html*/`<div class="listmenu-formating">${headerItem}</div>`);
    });

    $("#otherInventory").append(/*html*/`
        <div class="second-search">
            <input type="string" class="second-input" id="search" placeholder="${T("UI_SEARCH")}" value="${listSearchString}">
            <div class="second-sort" id="sort">${T("UI_SORT_RELEVANCE")}</div>
        </div>
        <div class="list-items"></div>
    `);

    buildListMenuInventory(data);

    $(".second-input").on("keyup", function() {
        var value = $(this).val().toLowerCase();
    
        listSearchString = value;

        $(".list-items").html("");

        buildListMenuInventory(data);
    });
}
