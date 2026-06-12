$(document).ready(function(){
    
	
	$("#assinar").click(function () {
		$.post('http://AutoContra/assinado', JSON.stringify({}));
		$('#assinar').hide();
		$('#assinatura').text($('#nome1').text());
        return
    })

	$("#assinar2").click(function () {
		$.post('http://AutoContra/assinadoAV', JSON.stringify({}));
		$('#assinar2').hide();
		$('#assinaturaNOTF').show();
		$('#nome2NOTF').show();
        return
    })
	
	
    // Close ui when ESC is pressed
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $('#lasergun').hide();
			$('#notificacao').hide();
			$.post('http://AutoContra/close', JSON.stringify({}));
            return
        }
    };
	
	window.addEventListener('message', function(event) {

        if (event.data.action == 'open') {
            $('#lasergun').show();
            $('#incidente').text("");
			$('#nome1').text("");
            $('#nascimento').text("");
			$('#nif1').text("");
            $('#nif2').text("");
			$('#matricula').text("");
			$('#pais').text("Portugália");
			$('#nif3').text("");
			$('#nome2').text("");
			$('#data1').text("");
			$('#local').text("");
			$('#descricao').text("");
			$('#crimes').text("");
			$('#coima').text("");
			$('#pontos').text("");
			$('#data2').text("");
			$('#agente').text("");
			$('#assinatura').text("");
			
        } else if (event.data.action == 'close') {
            $('#lasergun').hide();

		} else if (event.data.action == 'close2') {
			$('#notificacao').hide();
		
		
		} else if (event.data.action == 'criar_noti') {	
			$('#notificacao').show();		
			$('#notificacao').css('transform','scale(' + event.data.correct + ')');		
			$('#incidenteNOTF').text(event.data.dados.codeAV);

			
			document.getElementById("dataNOTF").value = "";
            document.getElementById("localNOTF").value = "";
			document.getElementById("nome1NOTF").value = "";
            document.getElementById("residenciaNOTF").value = "";
			document.getElementById("nifNOTF").value = "";
			document.getElementById("contactoNOTF").value = "";
			document.getElementById("condutorNOTF").value = "";
			document.getElementById("matriculaNOTF").value = "";
			document.getElementById("declaracaoNOTF").value = "";
			document.getElementById("portugaliaNOTF").value = "";
			document.getElementById("diaNOTF").value = "";
			document.getElementById("mesNOTF").value = "";
			document.getElementById("anoNOTF").value = "";

			document.getElementById("dataNOTF").disabled = false;
            document.getElementById("localNOTF").disabled = false;
			document.getElementById("nome1NOTF").disabled = false;
            document.getElementById("residenciaNOTF").disabled = false;
			document.getElementById("nifNOTF").disabled = false;
			document.getElementById("contactoNOTF").disabled = false;
			document.getElementById("condutorNOTF").disabled = false;
			document.getElementById("matriculaNOTF").disabled = false;
			document.getElementById("declaracaoNOTF").disabled = false;
			document.getElementById("portugaliaNOTF").disabled = false;
			document.getElementById("diaNOTF").disabled = false;
			document.getElementById("mesNOTF").disabled = false;
			document.getElementById("anoNOTF").disabled = false;
		
			$('#assinaturaNOTF').text("");
			$('#nome2NOTF').text("");				
			$('#assinatura2NOTF').text(event.data.dados.agente);
			$('#agenteNOTF').text(event.data.dados.agente);	

			if (event.data.botao == true) {
				$('#assinar2').show();
			} else  {
				$('#assinar2').hide();
			};

		} else if (event.data.action == 'AV_show') {	
			$('#notificacao').show();	
			$('#notificacao').css('transform','scale(' + event.data.correct + ')');			
			$('#incidenteNOTF').text(event.data.dados.ID);

			
			document.getElementById("dataNOTF").value = event.data.dados.data;
            document.getElementById("localNOTF").value = event.data.dados.local;
			document.getElementById("nome1NOTF").value = event.data.dados.nome1;
            document.getElementById("residenciaNOTF").value = event.data.dados.residencia;
			document.getElementById("nifNOTF").value = event.data.dados.nif;
			document.getElementById("contactoNOTF").value = event.data.dados.contacto;
			document.getElementById("condutorNOTF").value = event.data.dados.condutor;
			document.getElementById("matriculaNOTF").value = event.data.dados.matricula;
			document.getElementById("declaracaoNOTF").value = event.data.dados.declaracao;
			document.getElementById("portugaliaNOTF").value = event.data.dados.portugalia;
			document.getElementById("diaNOTF").value = event.data.dados.dia;
			document.getElementById("mesNOTF").value = event.data.dados.mes;
			document.getElementById("anoNOTF").value = event.data.dados.ano;

			document.getElementById("dataNOTF").disabled = true;
            document.getElementById("localNOTF").disabled = true;
			document.getElementById("nome1NOTF").disabled = true;
            document.getElementById("residenciaNOTF").disabled = true;
			document.getElementById("nifNOTF").disabled = true;
			document.getElementById("contactoNOTF").disabled = true;
			document.getElementById("condutorNOTF").disabled = true;
			document.getElementById("matriculaNOTF").disabled = true;
			document.getElementById("declaracaoNOTF").disabled = true;
			document.getElementById("portugaliaNOTF").disabled = true;
			document.getElementById("diaNOTF").disabled = true;
			document.getElementById("mesNOTF").disabled = true;
			document.getElementById("anoNOTF").disabled = true;
		
			$('#assinaturaNOTF').text(event.data.dados.nomecondutor);
			$('#nome2NOTF').text(event.data.dados.nomecondutor);				
			$('#assinatura2NOTF').text(event.data.dados.agente);
			$('#agenteNOTF').text(event.data.dados.agente);	

			if (event.data.botao == true) {
				$('#assinar2').show();
				$('#assinaturaNOTF').hide();
				$('#nome2NOTF').hide();
			} else  {
				$('#assinar2').hide();
				$('#assinaturaNOTF').show();
				$('#nome2NOTF').show();
			};
			
		} else if (event.data.action == 'get_noti') {	
			var isValid = true;
			$('input').each(function() {
				if ($(this).val() != '') {

				}else{
					console.log('campo vazio');
					isValid = false;			
				}
			});	

			if (isValid == true) {
				
				$.post('http://AutoContra/dados_form', JSON.stringify({
					data: document.getElementById("dataNOTF").value,
					local: document.getElementById("localNOTF").value,
					nome1: document.getElementById("nome1NOTF").value,
					residencia:  document.getElementById("residenciaNOTF").value,
					nif: document.getElementById("nifNOTF").value,
					contacto: document.getElementById("contactoNOTF").value,
					condutor: document.getElementById("condutorNOTF").value,
					matricula: document.getElementById("matriculaNOTF").value,
					declaracao: document.getElementById("declaracaoNOTF").value,
					portugalia: document.getElementById("portugaliaNOTF").value,
					dia: document.getElementById("diaNOTF").value,
					mes: document.getElementById("mesNOTF").value,
					ano: document.getElementById("anoNOTF").value,			
				}));
			} else {				
				$.post('http://AutoContra/error', JSON.stringify({}));			
			}
	
		
		} else if (event.data.action == 'open2') {			
			$('#notificacao').show();
			$('#notificacao').css('transform','scale(' + event.data.correct + ')');

			if (event.data.botao == true) {
				$('#assinar2').show();
			} else  {
				$('#assinar2').hide();
			};
			
        } else if (event.data.action == 'auto') {	
			$('#lasergun').css('transform','scale(' + event.data.correct + ')');
			$('#lasergun').show();
            $('#incidente').text(event.data.dados.incidente);
			$('#nome1').text(event.data.dados.nome);
            $('#nascimento').text(event.data.dados.nascimento);
			$('#nif1').text(event.data.dados.nif);
            $('#nif2').text(event.data.dados.nif);
			$('#matricula').text(event.data.dados.matricula);
			$('#pais').text("Portugália");
			$('#nif3').text(event.data.dados.nif);
			$('#nome2').text(event.data.dados.nome);
			$('#data1').text(event.data.dados.data);
			$('#local').text(event.data.dados.rua);
			$('#descricao').text(event.data.dados.descricao);
			$('#crimes').text(event.data.dados.crimes);
			$('#coima').text(event.data.dados.coima);
			$('#pontos').text(event.data.dados.pontos);
			$('#data2').text(event.data.dados.data);
			$('#agente').text(event.data.dados.agente);
			$('#assinatura').text(event.data.assinatura);
			
			if (event.data.botao == true) {
				$('#assinar').show();
			} else  {
				$('#assinar').hide();
			};
		}
    });
});

