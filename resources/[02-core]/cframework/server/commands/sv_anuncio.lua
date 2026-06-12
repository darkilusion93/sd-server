


TriggerEvent('es:addGroupCommand', 'anuncio', "superadmin", function(source, args, user)
	TriggerClientEvent("cframework:announce", -1, "~r~Anúncio", table.concat(args, " "), 10)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Sem permissão")
end, {help = "Anuncie uma mensagem para o servidor", params = {{name = "anuncio", help = "mensagem a anunciar"}}})
