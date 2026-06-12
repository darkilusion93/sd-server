// const exchangeItems = [
//     { 
//         category: 'resources', 
//         label: 'Sucata por Telemóveis/Rádios', 
//         name: "wood_to_iron", 
//         giveItems: [
//             { name: "rádio", label: "Rádio", image: "radio.png", quantity: 2 },
//             { name: "phone", label: "Telemóvel", image: "phone.png", quantity: 2 },
//         ],
//         receiveItems: [
//             { name: "iron", label: "Ferro", image: "ferro.png", quantity: 5 }
//         ],
//         description: 'Troque 2 rádios e 2 telemóveis por 5 de ferro.' 
//     },
// ];

let currentCategory = 'resources';

function createItemElement(item) {
    const giveItemsHtml = item.itemsrequeridos.map(give => `
        <div class="flex flex-col items-center mx-2 item-image-container">
            <img src="nui://chud/html/img/items/${give.image}" alt="${give.label}" class="item-image">
            <span class="text-sm mt-1 dark:text-gray-300">${give.quantity}x ${give.label}</span>
        </div>
    `).join('');
    
    const receiveItemsHtml = item.itemsrecebidos.map(receive => `
        <div class="flex flex-col items-center mx-2 item-image-container">
            <img src="nui://chud/html/img/items/${receive.image}" alt="${receive.label}" class="item-image">
            <span class="text-sm mt-1 dark:text-gray-300">${receive.quantity}x ${receive.label}</span>
        </div>
    `).join('');

    return $(`  
        <div class="item opacity-0 transform translate-y-4 transition-all duration-300 ease-out p-4 hover:bg-gray-50 dark:hover:bg-gray-700 rounded-lg border-b dark:border-gray-700 border-gray-100"  
             data-category="${item.categoria}">  
            <div class="flex-1 mb-3">  
                <h3 class="font-semibold text-blue-600 dark:text-blue-400 text-lg">${item.nome}</h3>  
                <p class="text-sm dark:text-gray-300 text-gray-500 mt-1">${item.descricao}</p>  
            </div>
            
            <div class="flex items-center justify-center mb-4">
                ${giveItemsHtml}
                <span class="exchange-arrow">→</span>
                ${receiveItemsHtml}
            </div>
            
            <div class="text-center">  
                <button class="exchange-btn w-full px-4 py-2 bg-blue-600 dark:bg-blue-700 text-white text-sm rounded-lg hover:bg-blue-700 dark:hover:bg-blue-600 transition-colors"  
                        data-name="${item.nome_sv}">  
                    TROCAR  
                </button>  
            </div>  
        </div>  
    `).delay(100).queue(function () {  
        $(this).css({ opacity: 1, transform: 'translateY(0)' }).dequeue();  
    });  
}

$(document).on('click', '.exchange-btn', function () {
    const exchangeName = $(this).data('name');
    $.post('https://sd-reciclagem/reciclar', JSON.stringify({ nomeconfig: exchangeName }));
});

document.addEventListener('keydown', function (event) {
    if (event.key === "Escape") {
        $.post('https://sd-reciclagem/close', JSON.stringify({}));
    }
});

function filterItems() {
    $('.item').each(function () {
        const $item = $(this);
        const categoryMatch = $item.data('category') === currentCategory;

        if (categoryMatch) {
            $item.stop(true, true).show().css({ opacity: 0, marginTop: -20 })
                .animate({ opacity: 1, marginTop: 0 }, 300);
        } else {
            $item.stop(true, true).animate({ opacity: 0, marginTop: -20 }, 300, function () {
                $(this).hide();
            });
        }
    });
}

window.addEventListener('message', function (event) {
    if (event.data.status) {
        $('body').removeClass('hidden');
        
        // Set dark mode if needed
        if (event.data.darkMode) {
            $('body').addClass('dark');
        } else {
            $('body').removeClass('dark');
        }
        
        const $catalog = $('#catalog');
        $catalog.empty();
        event.data.catalogo.forEach(item => $catalog.append(createItemElement(item)));
        
        $('.filter-btn').click(function () {
            $('.filter-btn').removeClass('active bg-blue-100 dark:bg-gray-700');
            $(this).addClass('active bg-blue-100 dark:bg-gray-700');
        
            currentCategory = $(this).data('filter');
            filterItems();
        });
        
        $('.filter-btn[data-filter="resources"]').click();
    } else {
        $('body').addClass('hidden');
    }
});