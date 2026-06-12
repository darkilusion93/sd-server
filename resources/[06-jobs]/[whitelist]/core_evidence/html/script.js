function GenerateReport(evidence, numero) {

    $("#main_container").css({
        display: 'block',
        bottom: '-80%'
    }).animate({

        bottom: "2%",
    }, 3000, function() {
    
    });;

    html_header = "<div id=\"section_header\">";
    html_header += "<div id=\"header_title\">" + 'RELATÓRIO FORENSE' + "</div>";
    html_header += "<div id=\"header_seal\"></div>";
    html_header += "<div id=\"header_details\"><h2>" + 'Relatório #' + numero + ' do Laboratório de Polícia Científica' + "</h2>";


    $("#main_container").append(html_header);


    $("#main_container").append("<div id=\"section_input\"></div>");

    html_middle = '';

    var i;

    for (i = 0; i < Object.keys(evidence).length; i++) {


        html_middle += "<div id=\"section_footer_block\">" + 'AMOSTRA #' + (i + 1) + ' (' + evidence[i]["type"] + ')' + "</div>";

        for (const [key, value] of Object.entries(evidence[i]["evidence"])) {
            html_middle += "<div class=\"header_information_subblock\">";
            
			if (value != 'Desconhecido') {
				html_middle += "<h3>" + "Correspondência: Encontrada | ID: " + value + "</h3></div>";
			} else {
				html_middle += "<h3>" + "Correspondência: Não Encontrada | ID: " + value + "</h3></div>";
			}
        }

    }




    $("#main_container").append(html_middle);


}

function closeMenu() {
  $.post('https://core_evidence/close', JSON.stringify({}));
        
		$("#main_container").html("");
        $("#main_container").css({
            display: 'none'
        });

}

$(document).keyup(function (e) {
  if (e.keyCode === 27) {

    closeMenu();

  }
});


window.addEventListener('message', function(event) {

    var edata = event.data;

    if (edata.type == "showReport") {

        var evidence = JSON.parse(edata.evidence);
		var numero = edata.id


        GenerateReport(evidence, numero);

    } else if (edata.type == "close") {
        $("#main_container").html("");
        $("#main_container").css({
            display: 'none'
        });
    }



});