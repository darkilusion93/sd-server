var FoccusedBank = null;

$(document).on('click', '.bank-app-account', function(e){
    var copyText = document.getElementById("iban-account");
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    document.execCommand("copy");

    QB.Phone.Notifications.Add("fas fa-university", "Banco", 'Conta', "IBAN copiado!", "#badc58", 1750);
});

var CurrentTab = "accounts";

$(document).on('click', '.bank-app-header-button', function(e){
    e.preventDefault();

    var PressedObject = this;
    var PressedTab = $(PressedObject).data('headertype');

    if (CurrentTab != PressedTab) {
        var PreviousObject = $(".bank-app-header").find('[data-headertype="'+CurrentTab+'"]');

        if (PressedTab == "invoices") {
            $(".bank-app-"+CurrentTab).css({"display":"none"});
            $(".bank-app-"+PressedTab).css({"display":"block"});
        } else if (PressedTab == "accounts") {
            $(".bank-app-"+CurrentTab).css({"display":"none"});
            $(".bank-app-"+PressedTab).css({"display":"block"});
        } else if (PressedTab == "historic") {
            $(".bank-app-"+CurrentTab).css({"display":"none"});
            $(".bank-app-"+PressedTab).css({"display":"block"});
        }

        $(PreviousObject).removeClass('bank-app-header-button-selected');
        $(PressedObject).addClass('bank-app-header-button-selected');
        CurrentTab = PressedTab;
    }
})

QB.Phone.Functions.DoBankOpen = function() {
    QB.Phone.Data.PlayerData.bank = numberWithSpaces(QB.Phone.Data.PlayerData.bank);
    $(".bank-app-account-number").val(QB.Phone.Data.PlayerData.iban);
    $(".bank-app-account-balance").html("&euro; "+QB.Phone.Data.PlayerData.bank);
    $(".bank-app-account-balance").data('balance', QB.Phone.Data.PlayerData.bank);

    $(".bank-app-loaded").css({"display":"none", "padding-left":"30vh"});
    $(".bank-app-accounts").css({"left":"30vh"});
    $(".qbank-logo").css({"left": "0vh"});
    $("#qbank-text").css({"opacity":"0.0", "left":"9vh"});
    $(".bank-app-loading").css({
        "display":"block",
        "left":"0vh",
    });
    setTimeout(function(){
        CurrentTab = "accounts";
        $(".qbank-logo").animate({
            left: -12+"vh"
        }, 500);
        setTimeout(function(){
            $("#qbank-text").animate({
                opacity: 1.0,
                left: 14+"vh"
            });
        }, 100);
        setTimeout(function(){
            $(".bank-app-loaded").css({"display":"block"}).animate({"padding-left":"0"}, 300);
            $(".bank-app-accounts").animate({left:0+"vh"}, 300);
            $(".bank-app-loading").animate({
                left: -30+"vh"
            },300, function(){
                $(".bank-app-loading").css({"display":"none"});
            });
        }, 1500)
    }, 500)
}

$(document).on('click', '.bank-app-account-actions', function(e){
    QB.Phone.Animations.TopSlideDown(".bank-app-transfer", 400, 0);
});

$(document).on('click', '#cancel-transfer', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideUp(".bank-app-transfer", 400, -100);
});

$(document).on('click', '#accept-transfer', function(e){
    e.preventDefault();

    var iban = $("#bank-transfer-iban").val();
    var amount = Math.floor($("#bank-transfer-amount").val());
    var amountData = $(".bank-app-account-balance").data('balance');

    if (iban != "" && amount != "") {
            $.post('http://cphone/CanTransferMoney', JSON.stringify({
                sendTo: iban,
                amountOf: amount,
            }), function(data){
                if (data.TransferedMoney) {
                    $("#bank-transfer-iban").val("");
                    $("#bank-transfer-amount").val("");

                    QB.Phone.Notifications.Add("fas fa-university", "Banco", 'Conta', "Transferiste &euro; "+amount+"!", "#badc58", 1500);
                } else {
                    QB.Phone.Notifications.Add("fas fa-university", "Banco", 'Conta', "Não foi possivel transferir o dinheiro!", "#badc58", 1500);
                }
                QB.Phone.Animations.TopSlideUp(".bank-app-transfer", 400, -100);
            });
    } else {
        QB.Phone.Notifications.Add("fas fa-university", "Banco", 'Conta', "Preenche todos os campos!", "#badc58", 1750);
    }
});

GetInvoiceLabel = function(type) {
    retval = null;
    if (type == "request") {
        retval = "Payment Request";
    }
    if (type == 'bill') {
        retval = 'Fatura';
    }

    return retval
}

GetTransLabel = function(type) {
    retval = null;
    if (type == "deposit") {
        retval = "Deposito";
    }
    if (type == 'withdraw') {
        retval = 'Levantamento';
    }
    if (type == 'transfer') {
        retval = 'Transferência';
    }
    if (type == 'bill') {
        retval = 'Fatura';
    }

    return retval
}

$(document).on('click', '.pay-invoice', function(event){
    event.preventDefault();

    var InvoiceId = $(this).parent().parent().attr('id');
    var InvoiceData = $("#"+InvoiceId).data('invoicedata');

    $.post('http://cphone/PayInvoice', JSON.stringify({
        sender: InvoiceData.sender,
        amount: InvoiceData.amount,
        invoiceId: InvoiceData.id,
    }), function(CanPay){
        if (CanPay) {
            $("#"+InvoiceId).animate({
                left: 30+"vh",
            }, 300, function(){
                setTimeout(function(){
                    $("#"+InvoiceId).remove();
                }, 100);
            });
            QB.Phone.Notifications.Add("fas fa-university", "Banco", 'Conta', "Pagaste uma fatura de &euro;"+InvoiceData.amount+"!", "#badc58", 1500);
        } else {
            QB.Phone.Notifications.Add("fas fa-university", "Banco", 'Conta', "Não tens saldo suficiente!", "#badc58", 1500);
        }
    });
});

QB.Phone.Functions.LoadBankInvoices = function(invoices) {
    if (invoices !== null) {
        $(".bank-app-invoices-list").html("");

        $.each(invoices, function(i, invoice){
            // Create a new Date object using the timestamp
            const date = new Date(Number(invoice.time));

            // Get the day, month, year, hours, and minutes
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0'); // Month is zero-based, so we add 1
            const year = date.getFullYear();
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');

            // Create the formatted date string
            const formattedDate = `${day}/${month}/${year} ${hours}:${minutes}`;
            const invoiceLabel = invoice.label.replace(/</g, "&lt;").replace(/>/g, "&gt;");

            var Elem = /*html*/`
                <div class="bank-app-invoice" id="invoiceid-${i}">
                    <div class="bank-app-invoice-title">${GetInvoiceLabel(invoice.type)} <span style="font-size: 1vh; color: gray;">(De: ${invoiceLabel})</span></div>
                    <div class="bank-app-invoice-amount">&euro; ${invoice.amount}</div>
                    <div class="bank-app-invoice-date">${formattedDate}</div>
                    <div class="bank-app-invoice-buttons"><i class="fas fa-check-circle pay-invoice"></i></div>
                </div>`;

            $(".bank-app-invoices-list").append(Elem);
            $("#invoiceid-"+i).data('invoicedata', invoice);
        });
    }
}

QB.Phone.Functions.LoadBankTransactions = function(transactions) {
    if (transactions !== null) {
        $(".bank-app-historic-list").html("");

        $.each(transactions, function(i, transaction){
            var Elem = /*html*/`
                <div class="bank-app-register">
                    <div class="bank-app-register-title">
                        ${GetTransLabel(transaction.trans_type)}<span class="bank-app-register-target">(Para: ${transaction.receiver.replace(/</g, "&lt;").replace(/>/g, "&gt;")})</span>
                    </div>
                    <div class="bank-app-transaction-amount">&euro; ${Math.abs(transaction.amount)}</div>
                </div>`;

            $(".bank-app-historic-list").append(Elem);
        });
    }
}


QB.Phone.Functions.LoadContactsWithNumber = function(myContacts) {
    var ContactsObject = $(".bank-app-my-contacts-list");
    $(ContactsObject).html("");
    var TotalContacts = 0;

    $("#bank-app-my-contact-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".bank-app-my-contacts-list .bank-app-my-contact").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });

    if (myContacts !== null) {
        $.each(myContacts, function(i, contact){
            var RandomNumber = Math.floor(Math.random() * 6);
            var ContactColor = QB.Phone.ContactColors[RandomNumber];
            var ContactElement = '<div class="bank-app-my-contact" data-bankcontactid="'+i+'"> <div class="bank-app-my-contact-firstletter">'+((contact.name).charAt(0)).toUpperCase()+'</div> <div class="bank-app-my-contact-name">'+contact.name+'</div> </div>'
            TotalContacts = TotalContacts + 1
            $(ContactsObject).append(ContactElement);
            $("[data-bankcontactid='"+i+"']").data('contactData', contact);
        });
    }
};

$(document).on('click', '.bank-app-my-contacts-list-back', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideUp(".bank-app-my-contacts", 400, -100);
});

$(document).on('click', '.bank-transfer-mycontacts-icon', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideDown(".bank-app-my-contacts", 400, 0);
});

$(document).on('click', '.bank-app-my-contact', function(e){
    e.preventDefault();
    var PressedContactData = $(this).data('contactData');

    if (PressedContactData.iban !== "" && PressedContactData.iban !== undefined && PressedContactData.iban !== null) {
        $("#bank-transfer-iban").val(PressedContactData.iban);
    } else {
        QB.Phone.Notifications.Add("fas fa-university", "Banco", 'Conta', "Este número não tem um IBAN associado!", "#badc58", 2500);
    }
    QB.Phone.Animations.TopSlideUp(".bank-app-my-contacts", 400, -100);
});

function numberWithSpaces(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}