Config = {}

-- Configurações do sistema de reciclagem
Config.CooldownLixo = 10 * 60000 -- 10 minutos

-- Coordenadas
Config.Reciclagem = {
    x = 146.0779,
    y = 6368.899,
    z = 31.52955
}

Config.LojaCoordenadas = {
    x = 168.1596,
    y = 6393.2705,
    z = 30.5423,
    h = 157.9596
}

Config.ChicoCoordenadas = {
    x = 175.0109,
    y = 6382.8418,
    z = 30.4792,
    h = 119.9
}

Config.ReciclagemCoordenadas = {
    x = 176.8081,
    y = 6383.747,
    z = 31.48328
}

-- Objetos para vasculhar
Config.Objects = { 
    'prop_dumpster_01a',
    'prop_dumpster_02a',
    'prop_dumpster_02b',
    'prop_dumpster_3a',
    'prop_dumpster_4a',
    'prop_dumpster_4b'
}

-- Posições para colocar lixo
Config.PosicoesLixo = {
    vector3(164.7498, 6387.325, 31.6889),
    vector3(160.6495, 6384.95, 31.47918),
    vector3(156.1046, 6382.607, 31.47914),
    vector3(151.7456, 6380.475, 31.47913),
    vector3(143.5424, 6376.567, 31.69096),
    vector3(154.4158, 6375.414, 31.68889),
    vector3(158.83, 6377.606, 31.6889),
    vector3(162.9727, 6379.963, 31.68889),
    vector3(167.2106, 6382.49, 31.6889),
    vector3(169.9113, 6377.187, 31.47921),
    vector3(165.6598, 6374.912, 31.68889),
    vector3(161.4262, 6372.62, 31.68889),
    vector3(157.0375, 6370.444, 31.68889),
    vector3(150.9171, 6363.682, 31.60661),
    vector3(159.7384, 6365.292, 31.47922),
    vector3(164.1606, 6368.007, 31.47922),
    vector3(168.1936, 6369.734, 31.47921),
    vector3(172.7027, 6372.326, 31.47921)
}

-- Uniformes
Config.Uniformes = {
    Trabalhador = {
        male = {
            ['tshirt_1'] = 59, ['tshirt_2'] = 0,
            ['torso_1'] = 273, ['torso_2'] = 1,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 30,
            ['pants_1'] = 97, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0
        },
        female = {
            ['tshirt_1'] = 36, ['tshirt_2'] = 0,
            ['torso_1'] = 49, ['torso_2'] = 1,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 31,
            ['pants_1'] = 100, ['pants_2'] = 0,
            ['shoes_1'] = 24, ['shoes_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0,
            ['helmet_1'] = -1, ['helmet_2'] = 0
        }
    }
}

-- Items da loja de reciclagem
Config.LojaItems = {
    {
        categoria = 'resources',
        nome = 'Componentes Eletrónicos',
        nome_sv = 'componenteseletronicos',
        itemsrequeridos = {
            { name = "bradio", label = "Rádio Estragado", image = "bradio.png", quantity = 2 },
            { name = "btel", label = "Telemovel Estragado", image = "btel.png", quantity = 2 },
        },
        itemsrecebidos = {
            { name = "componenteseletronicos", label = "Componentes Eletrónicos", image = "componenteseletronicos.png", quantity = 1 },
        },
        descricao = 'Troque 2 rádios estragados e 2 telemóveis estragados por 1 componente eletrónico.'
    },
    {
        categoria = 'resources',
        nome = 'Fibra',
        nome_sv = 'fibra',
        itemsrequeridos = {
            { name = "leather", label = "Couro", image = "leather.png", quantity = 5 },
            { name = "feather", label = "Penas", image = "feather.png", quantity = 2 },
        },
        itemsrecebidos = {
            { name = "fibra", label = "Fibra", image = "fibra.png", quantity = 1 },
        },
        descricao = 'Troque 5 couro e 2 penas por 1 de fibra.'
    },
    {
        categoria = 'resources',
        nome = 'Frasco Vazio',
        nome_sv = 'jar',
        itemsrequeridos = {
            { name = "recicled_plastic", label = "Plástico Reciclado", image = "recicled_plastic.png", quantity = 15 },
        },
        itemsrecebidos = {
            { name = "jar", label = "Frasco Vazio", image = "jar.png", quantity = 1 },
        },
        descricao = 'Troque 15 plásticos por 1 frasco vazio.'
    },
    {
        categoria = 'resources',
        nome = 'Kevlar',
        nome_sv = 'kevlar',
        itemsrequeridos = {
            { name = "fibra", label = "Fibra", image = "fibra.png", quantity = 5 },
        },
        itemsrecebidos = {
            { name = "kevlar", label = "Kevlar", image = "kevlar.png", quantity = 1 },
        },
        descricao = 'Troque 5 fibras por 1 de kevlar.'
    },
    {
        categoria = 'resources',
        nome = 'Botija de óxido nitroso',
        nome_sv = 'oxido_nitroso',
        itemsrequeridos = {
            { name = "aluminio", label = "Aluminio", image = "aluminio.png", quantity = 100 },
            { name = "steel", label = "Aço", image = "steel.png", quantity = 1 },
            { name = "copper", label = "Cobre", image = "copper.png", quantity = 100 },
        },
        itemsrecebidos = {
            { name = "oxido_nitroso", label = "Botija de óxido nitroso", image = "oxido_nitroso.png", quantity = 1 },
        },
        descricao = 'Troque 100 Alumínio + 1 Aço + 100 Cobre por Botija de óxido nitroso.'
    },
    {
        categoria = 'resources',
        nome = 'Rede de pesca',
        nome_sv = 'rede_pesca',
        itemsrequeridos = {
            { name = "cordas", label = "Cordas", image = "cordas.png", quantity = 2 },
        },
        itemsrecebidos = {
            { name = "redepesca", label = "Rede de Pesca", image = "redepesca.png", quantity = 1 },
        },
        descricao = 'Troque 2 cordas por 1 rede de pesca.'
    },
}

-- NPC Models
Config.NPCModels = {
    Chico = "ig_joeminuteman",
    Loja = "mp_m_weapwork_01"
}

