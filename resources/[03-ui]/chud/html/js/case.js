let cases = {};

function caseOpening(caseItem) {
    $("#otherInventory").html(/*html*/`<div class="case-buy-button-container"><div class="case-buy-button">Voltar</div></div>`);

    $(".case-buy-button").click(function () {
        casesSetup();
    });

    /*    let items = caseItem.items;
    
    let itemHTML = "";
    for (let i = 0; i < 30; i++) {
        let randomItem = items[Math.floor(Math.random() * items.length)];
        itemHTML += `<div class="case-item"><img src="img/${randomItem.img}" /><p>${randomItem.name}</p></div>`;
    }

    $("#otherInventory").html(`
        <div class="case-opening-container">
            <div class="case-items-wrapper">
                <div class="case-items">${itemHTML}</div>
            </div>
            <div class="case-result-container"></div>
            <div class="case-buy-button-container">
                <div class="case-buy-button">Voltar</div>
            </div>
        </div>
    `);


    let winningItem = rollItem(items);
    let winningIndex = Math.floor(Math.random() * 10) + 10;

    let itemWidth = $(".case-item").outerWidth(true);
    let finalPosition = -(winningIndex * itemWidth) + ($(".case-items-wrapper").width() / 2 - itemWidth / 2);

    $(".case-items").css({ left: "0px" }).animate({ left: finalPosition }, 4000, "easeOutQuart", function () {
        $(".case-result-container").html(`<h3>🎉 You got: ${winningItem.name}!</h3><img src="img/${winningItem.img}" />`).fadeIn();
    });

    $(".case-buy-button").click(function () {
        casesSetup();
    });*/
}

function casesSetup() {
    $("#otherInventory").html(/*html*/`<div class="case-selector"></div>`);

    $.each(cases, function (index, caseItem) {
        $(".case-selector").append(/*html*/`
            <div class="case-item">
                <div class="case-image"><img src="img/${caseItem.img}" loading="lazy"></div>
                <div class="case-name">CASE - ${caseItem.name}</div>
                <div class="case-buy-button-container"><div class="case-buy-button" id="${index}">Abrir - ${caseItem.price} 💰</div></div>
            </div>
        `);
    });

    //add click event to case buy button
    $(".case-buy-button").click(function () {
        var caseIndex = $(this).attr("id");
        var caseItem = cases[caseIndex];

        caseOpening(caseItem);
    });
}

function caseInventorySetup(data) {
    cases = data.cases;
    casesSetup();
}