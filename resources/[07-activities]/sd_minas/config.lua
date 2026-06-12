Config = {}

-- Itens necessários para minerar
Config.ItemBritadeira = "drill"
Config.ItemBroca = "drillbit"

-- Configurações de Mineração
Config.MiningDelay = 5000 -- Tempo que demora cada perfuração (em ms)

-- Probabilidade de partir os itens (em %)
Config.Avaria = {
    Britadeira = 2, -- 2% de chance de partir
    Broca = 8      -- 10% de chance de partir
}

-- Minérios e probabilidades (chance em %)
Config.ItemMinerar = {
    { item = "iron", chance = 60, min = 1, max = 3 },
    { item = "copper", chance = 50, min = 1, max = 2 },
    { item = "aluminio", chance = 40, min = 1, max = 2 },
    { item = "diamond", chance = 5, min = 1, max = 1 },
    { item = "ruby", chance = 10, min = 1, max = 1 },
    { item = "emerald", chance = 10, min = 1, max = 1 }
}

-- Blips do mapa para as Minas
Config.BlipsMinerar = {
    { Coordenada = vector3(2948.993, 2817.89, 42.43056) },
    { Coordenada = vector3(2944.238, 2816.472, 42.64713) },
    { Coordenada = vector3(2951.146, 2770.701, 38.99) },
    { Coordenada = vector3(2934.948, 2784.931, 39.55) },
    { Coordenada = vector3(2922.827, 2798.708, 41.196) },
    { Coordenada = vector3(2937.274, 2812.215, 42.85) },
    { Coordenada = vector3(2957.973, 2819.992, 42.672) },
    { Coordenada = vector3(2938.123, 2775.371, 39.223) },
    { Coordenada = vector3(2970.358, 2776.561, 38.367) },
    { Coordenada = vector3(2977.479, 2790.77, 40.545) }
}

Config.BuyMenu = {
        {name = "drill",    label = "Britadeira",        price =    1000},
        {name = "drillbit",     label = "Broca",     price =     250}
}

-- NPC de funções da mina (Richard)
Config.NPC_Funcoes = {
    x = 2569.41, y = 2720.33, z = 41.95, h = 210.95
}

-- Local de venda dos minérios (caso utilizes neste script)
Config.Vendas = {
    x = 122.1, y = 6405.69, z = 30.36, h = 314.1
}

-- Uniformes para o trabalho na mina
Config.Uniformes = {
    Trabalhador = {
        male = {
            tshirt_1 = 59, tshirt_2 = 0,
            torso_1 = 273, torso_2 = 1,
            decals_1 = 0, decals_2 = 0,
            arms = 30,
            pants_1 = 97, pants_2 = 0,
            shoes_1 = 25, shoes_2 = 0,
            chain_1 = 0, chain_2 = 0,
            helmet_1 = 145, helmet_2 = 0
        },
        female = {
            tshirt_1 = 36, tshirt_2 = 0,
            torso_1 = 49, torso_2 = 1,
            decals_1 = 0, decals_2 = 0,
            arms = 31,
            pants_1 = 100, pants_2 = 0,
            shoes_1 = 24, shoes_2 = 0,
            chain_1 = 0, chain_2 = 0,
            helmet_1 = 144, helmet_2 = 0
        }
    }
}
