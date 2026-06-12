let searchString = '';
let sortType = 0;

function makeComparator(getter, ascending = true) {
    return function(a, b) {
        // Put inGarage true first
        const ai = a.inGarage ? 0 : 1;
        const bi = b.inGarage ? 0 : 1;
        if (ai !== bi) return ai - bi;

        // Fallback to the requested field (normalize to string)
        const av = String(getter(a) || '').toLowerCase();
        const bv = String(getter(b) || '').toLowerCase();

        // use localeCompare with numeric option for nicer numeric plate sorting
        const cmp = av.localeCompare(bv, undefined, { numeric: true, sensitivity: 'base' });
        return ascending ? cmp : -cmp;
    };
}

function populateGarage(data) {
    let takeout = T("UI_TAKEOUT");
    let addedFavorites = 0;
    let addedVehicles = 0;

    if (data.isPound) {
        takeout = T("UI_PAY");
    }

    $(".garage-items").html("");

    $.each(data.favoriteList, function (index, menuItem) {
        if (searchString === '' || menuItem.alias.toLowerCase().includes(searchString) || menuItem.label.toLowerCase().includes(searchString) || menuItem.value.plate.toLowerCase().includes(searchString)) {
            let fuel = menuItem.value.vehicle.fuelLevel

            if (typeof fuel == "number" && fuel > 0) {
                fuel = fuel.toFixed(1);
            } else {
                fuel = 0.0
            }
            
            $(".garage-items").append(/*html*/`
                <div class="garage-slot ${menuItem.inGarage ? "" : "garage-slot-disabled"}" id="garage-${menuItem.id}">
                    <div class="garage-plate" id="plate-${menuItem.id}">${menuItem.value.plate}</div>
                    <div class="garage-separator">-</div>
                    <div class="garage-caralias" id="alias-${menuItem.id}"></div>
                    <div class="garage-carname" id="name-${menuItem.id}"></div>
                    <input type="text" class="garage-editalias" id="edit-${menuItem.id}" maxlength="16">
                    <div class="garage-takeout" id="takeout-${menuItem.id}">${takeout}</div>
                    <div class="garage-favorite favorite-enable" id="favorite-${menuItem.id}">⭐</div>
                    <div class="garage-edit" id="editname-${menuItem.id}">✏️</div>
                    <div class="garage-info" id="info-${menuItem.id}">🧰&nbsp;${T("UI_GARAGE_BODYWORK")} : ${menuItem.value.vehicle.bodyHealth/10}% &nbsp;/&nbsp; ⚙️&nbsp;${T("UI_GARAGE_ENGINE")} : ${menuItem.value.vehicle.engineHealth/10}% &nbsp;/&nbsp; ⛽&nbsp;${T("UI_GARAGE_FUEL")} : ${fuel}%
                        <div class="garage-trunk" id="trunk-${menuItem.id}"></div>
                    </div>
                </div>
            `);

            $( `#alias-${menuItem.id}`).text(menuItem.alias);
            $( `#name-${menuItem.id}`).text(menuItem.label);

            $( `#plate-${menuItem.id}`).data("vehicle", menuItem.value.vehicle.model);

            addedFavorites++;
        }
    });

    if (addedFavorites > 0) {
        $(".garage-items").append(/*html*/`<div class="garage-favorite-separator"></div>`);
    }

    $.each(data.itemList, function (index, menuItem) {
        if (searchString === '' || menuItem.alias.toLowerCase().includes(searchString) || menuItem.label.toLowerCase().includes(searchString) || menuItem.value.plate.toLowerCase().includes(searchString)) {
            let fuel = menuItem.value.vehicle.fuel

            if (typeof fuel == "number" && fuel > 0) {
                fuel = fuel.toFixed(1);
            } else {
                fuel = 0.0
            }

            $(".garage-items").append(/*html*/`
                <div class="garage-slot ${menuItem.inGarage ? "" : "garage-slot-disabled"}" id="garage-${menuItem.id}">
                    <div class="garage-plate" id="plate-${menuItem.id}">${menuItem.value.plate}</div>
                    <div class="garage-separator">-</div>
                    <div class="garage-caralias" id="alias-${menuItem.id}"></div>
                    <div class="garage-carname" id="name-${menuItem.id}"></div>
                    <input type="text" class="garage-editalias" id="edit-${menuItem.id}" maxlength="16">
                    <div class="garage-takeout" id="takeout-${menuItem.id}">${takeout}</div>
                    <div class="garage-favorite" id="favorite-${menuItem.id}">⭐</div>
                    <div class="garage-edit" id="editname-${menuItem.id}">✏️</div>
                    <div class="garage-info" id="info-${menuItem.id}">🧰&nbsp;${T("UI_GARAGE_BODYWORK")} : ${menuItem.value.vehicle.bodyHealth/10}% &nbsp;/&nbsp; ⚙️&nbsp;${T("UI_GARAGE_ENGINE")} : ${menuItem.value.vehicle.engineHealth/10}% &nbsp;/&nbsp; ⛽&nbsp;${T("UI_GARAGE_FUEL")} : ${fuel}%
                        <div class="garage-trunk" id="trunk-${menuItem.id}"></div>
                    </div>
                </div>
            `);

            $( `#alias-${menuItem.id}`).text(menuItem.alias);
            $( `#name-${menuItem.id}`).text(menuItem.label);

            $( `#plate-${menuItem.id}`).data("vehicle", menuItem.value.vehicle.model);

            addedVehicles++;
        }
    });

    if (addedVehicles === 0) {
        $(".garage-favorite-separator").css('display', 'none');
    }

    $(".garage-slot").click(function(e) {
        if (e.target.id.includes("favorite") || e.target.id.includes("editname") || e.target.id.includes("takeout") || e.target.id.includes("edit")) { return false }

        let elem = $(`#info-${this.id.slice(7)}`);
        let elem2 = $(this);

        if (elem.css('display') === 'none') {
            elem.css('display', 'block');

            $.post("http://chud/showTrunkInv", JSON.stringify({
                plate: $(`#plate-${this.id.slice(7)}`).text(),
                model: $(`#plate-${this.id.slice(7)}`).data("vehicle"),
                id: this.id.slice(7)
            }));

            setTimeout(function() {
                elem.css('opacity', '1.0');
            }, 250);
        } else {
            elem.css('opacity', '0.0');

            setTimeout(function() {
                elem.css('display', 'none');
                elem2.css('height', '5vh'); 
            }, 250);
        }

    });

    $(".garage-takeout").click(function(e) {
        //disableInventory(500);
        $.post("http://chud/garageSelect", JSON.stringify({
            value: e.target.parentNode.id.slice(7),
        }));
    });

    $(".garage-favorite").click(function(e) {
        //disableInventory(500);
        if ($(`#alias-${e.target.parentNode.id.slice(7)}`).css('display') === 'block') {
            $.post("http://chud/toggleGarageFavorite", JSON.stringify({
                value: e.target.parentNode.id.slice(7),
            }));
        } else {
            $.post("http://chud/setVehicleAlias", JSON.stringify({
                value: e.target.parentNode.id.slice(7),
                alias: $(`#edit-${e.target.parentNode.id.slice(7)}`).val()
            }));
        }
    });

    $(".garage-edit").click(function(e) {
        //disableInventory(500);
        if ($(`#alias-${e.target.parentNode.id.slice(7)}`).css('display') === 'block') {
            $(`#alias-${e.target.parentNode.id.slice(7)}`).fadeOut(100);
            $(`#name-${e.target.parentNode.id.slice(7)}`).fadeOut(100, function() {
                $(`#edit-${e.target.parentNode.id.slice(7)}`).fadeIn(100);
                $(`#favorite-${e.target.parentNode.id.slice(7)}`).addClass('reset-favorite-color');
                $(`#favorite-${e.target.parentNode.id.slice(7)}`).text('✔️');
                $(`#editname-${e.target.parentNode.id.slice(7)}`).text('❌');
            });
        } else {
            $(`#edit-${e.target.parentNode.id.slice(7)}`).fadeOut(100, function() {
                $(`#name-${e.target.parentNode.id.slice(7)}`).fadeIn(100);
                $(`#alias-${e.target.parentNode.id.slice(7)}`).fadeIn(100);
                $(`#favorite-${e.target.parentNode.id.slice(7)}`).removeClass('reset-favorite-color');
                $(`#favorite-${e.target.parentNode.id.slice(7)}`).text('⭐');
                $(`#editname-${e.target.parentNode.id.slice(7)}`).text('✏️');
            });
        }
    });
}

function garageInventorySetup(data) {
    $("#otherInventory").html("");

    let sortString = '';
    let comparator;
    switch (sortType) {
        case 0: // plate asc
            comparator = makeComparator(item => item.value.plate, true);
            sortString = T("UI_ORDER_PLATE_ASC");
            break;
        case 1: // plate desc
            comparator = makeComparator(item => item.value.plate, false);
            sortString = T("UI_ORDER_PLATE_DESC");
            break;
        case 2: // alias asc
            comparator = makeComparator(item => item.alias, true);
            sortString = T("UI_ORDER_NAME_ASC");
            break;
        case 3: // alias desc
            comparator = makeComparator(item => item.alias, false);
            sortString = T("UI_ORDER_NAME_DESC");
            break;
        default:
            comparator = makeComparator(item => item.value.plate, true);
            sortString = T("UI_ORDER_PLATE_ASC");
    }

    // apply to both lists
    data.favoriteList.sort(comparator);
    data.itemList.sort(comparator);

    $("#otherInventory").html(/*html*/`
        <div class="garage-search">
            <input type="string" class="garage-input" id="search" placeholder="${T("UI_SEARCH")}" value="${searchString}">
            <div class="garage-sort" id="sort">${sortString}</div>
            <div class="garage-items" id="garage-container"></div>
        </div>`);

    populateGarage(data);

    $(".garage-sort").click(function() {
        sortType ++;

        if (sortType > 3) sortType = 0;

        let comparator;
        switch (sortType) {
            case 0: // plate asc
                comparator = makeComparator(item => item.value.plate, true);
                sortString = T("UI_ORDER_PLATE_ASC");
                break;
            case 1: // plate desc
                comparator = makeComparator(item => item.value.plate, false);
                sortString = T("UI_ORDER_PLATE_DESC");
                break;
            case 2: // alias asc
                comparator = makeComparator(item => item.alias, true);
                sortString = T("UI_ORDER_NAME_ASC");
                break;
            case 3: // alias desc
                comparator = makeComparator(item => item.alias, false);
                sortString = T("UI_ORDER_NAME_DESC");
                break;
            default:
                comparator = makeComparator(item => item.value.plate, true);
                sortString = T("UI_ORDER_PLATE_ASC");
        }

        // apply to both lists
        data.favoriteList.sort(comparator);
        data.itemList.sort(comparator);

        $(".garage-sort").text(sortString);

        populateGarage(data);
    });

    $(".garage-input").on("keyup", function() {
        var value = $(this).val().toLowerCase();
    
        searchString = value;

        populateGarage(data);
    });
}

function garageTrunkPreviewInventorySetup(data) {
    $(`#trunk-${data.id}`).html("");

    $(".garage-info").css("height", "23.5vh");
    $(".garage-trunk").show();
    $(`#garage-${data.id}`).css('height', '29.2vh');

    $.each(data.items, function (index, item) {
        count = setCount(item, true);

        $(`#trunk-${data.id}`).append('<div class="slot-garage-preview"><div class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
    });
}