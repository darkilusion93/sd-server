ESX.Status = {
    {name = 'hunger', label = 'Fome',   val = 1000000, max = 1000000, tick = 10000},
    {name = 'thirst', label = 'Sede',   val = 1000000, max = 1000000, tick = 10000},
    {name = 'drunk',  label = 'Alcool', val = 0,       max = 1000000, tick = 10000}
}


-- Quantidade de fome e sede que o jogador perde a cada 10 segundos (maximo 1.000.000)
ESX.HungerTick = 1389 -- 2H até ficar com fome.
ESX.ThirstTick = 1389 
ESX.DrunkTick  = 20000