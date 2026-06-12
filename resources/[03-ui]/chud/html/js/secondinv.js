let secondSearchString = '';
let secondSearchArray = [];
let secondItems = {};
let inventorySortType = 0;

function populateSecondInventory(items) {
    const $secondItemsContainer = $(".second-items");
    let totalItems = 0;
    let newDom = '';

    $.each(items, function(index, item) {
        let shouldInclude = secondSearchArray.some(function(element) {
            let normalizedLabel = item.label.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
            let normalizedElement = element.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");

            return normalizedLabel.includes(normalizedElement);
        });
        
        let count = setCount(item, true);
        let label = getLabel(item);

        if (secondSearchString === '' || shouldInclude) {
            newDom += /*html*/`
                <div class="slot">
                    <div id="itemOther-${index}" class="item" style="background-image: url(\'img/items/${item.name}.png\')">
                        <div class="item-count">${count}</div>
                        <div class="item-name">${(type === "shop" && item.count ? formatMoney(item.count) + " " + label : label)}</div>
                    </div>
                </div>
            `;

            totalItems++;
        }
    });

    $secondItemsContainer.append(newDom);

    $.each(items, function(index, item) {
        let shouldInclude = secondSearchArray.some(function(element) {
            let normalizedLabel = item.label.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
            let normalizedElement = element.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");

            return normalizedLabel.includes(normalizedElement);
        });
        
        if (secondSearchString === '' || shouldInclude) {
            $('#itemOther-' + index).data('item', item);
            $('#itemOther-' + index).data('inventory', "second");
        }
    });

    if (inventorySortType === 0) {
        $(".second-sort").text(`${T("UI_SORT_RELEVANCE")} (${totalItems})`);
    }

    // Set draggable items only after updating (this could be throttled if needed)
    setDraggableItems();
}

function secondInventorySetup(items) {
    let sortString = '';

    const secondItemsInit = [...items];
    secondItems = items;

    switch (inventorySortType) {
        case 0:
            secondItems = [...secondItemsInit];
            sortString = T("UI_SORT_RELEVANCE");
            break;
        case 1:
            secondItems = secondItemsInit.sort((a, b) => {return a.count - b.count})
            sortString = T("UI_SORT_QUANTITY_ASC");
            break;
        case 2:
            secondItems = secondItemsInit.sort((a, b) => {return b.count - a.count})
            sortString = T("UI_SORT_QUANTITY_DESC");
            break;
    }

    $("#otherInventory").html(/*html*/`
        <div class="second-search">
            <input type="string" class="second-input" id="search" placeholder="${T("UI_SEARCH")}" value="${secondSearchString}">
            <div class="second-sort" id="sort">${sortString}</div>
        </div>
        <div class="second-items"></div>
    `);

    $(".second-sort").click(function() {
        inventorySortType ++;

        if (inventorySortType > 2) inventorySortType = 0;

        switch (inventorySortType) {
            case 0:
                secondItems = [...secondItemsInit];
                sortString = T("UI_SORT_RELEVANCE");
                break;
            case 1:
                secondItems = secondItems.sort((a, b) => {return a.count - b.count})
                sortString = T("UI_SORT_QUANTITY_ASC");
                break;
            case 2:
                secondItems = secondItems.sort((a, b) => {return b.count - a.count})
                sortString = T("UI_SORT_QUANTITY_DESC");
                break;
        }

        $(".second-sort").text(sortString);

        $(".second-items").html("");

        populateSecondInventory(secondItems);
    });

    $(".second-input").on("keyup", function() {
        var value = $(this).val().toLowerCase();
    
        secondSearchString = value;
        secondSearchArray = secondSearchString.split(";");

        $(".second-items").html("");

        populateSecondInventory(secondItems);
    });

    populateSecondInventory(secondItems);
}