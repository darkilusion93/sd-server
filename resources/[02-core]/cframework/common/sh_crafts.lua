ESX.mobileCrafts = {
                                         --DROGAS--
    { name = 'blunt_hashish', count = 1, craft = true, time = 2000, anim = 'parquimetro', needs = {
        {name = 'cigarett', count = 1, consume = true},
        {name = 'hashish', count = 1, consume = true},
        {name = 'rolling_paper', count = 1, consume = true},
    }},

    { name = 'blunt_weed', count = 1, craft = true, time = 3000, anim = 'parquimetro', needs = {
        {name = 'weed', count = 1, consume = true},
        {name = 'rolling_paper', count = 1, consume = true},
    }},

                                           --RANDOM ITEMS--
    { name = 'kevlar', count = 1, craft = true, time = 3000, anim = 'parquimetro', needs = {
        {name = 'rubber', count = 3, consume = true},
        {name = 'fabric', count = 3, consume = true},
    }},

    { name = 'gunpowder', count = 1, craft = true, time = 2500, anim = 'parquimetro', needs = {  
        {name = 'knitrate', count = 1, consume = true},
        {name = 'sulfur', count = 1,   consume = true},
        {name = 'coal', count = 1,     consume = true},
    }},

     { name = 'thermal_charge', count = 1, craft = true, time = 2500, anim = 'parquimetro', needs = {  
        {name = 'gunpowder', count = 5, consume = true},
        {name = 'coal', count = 5,      consume = true},
    }},

    { name = 'electronic_waste', count = 1, craft = true, time = 1000, anim = 'parquimetro', needs = {
        {name = 'bradio', count = 1, consume = true},
        {name = 'btel', count = 1, consume = true},
    }},

    { name = 'copper_cable', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = {
        {name = 'copper', count = 5, consume = true},
        {name = 'rubber', count = 5, consume = true},
    }},

    { name = 'copper_coil', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = {
        {name = 'copper', count = 2, consume = true},

    }},

                                             -- PESCA--
    { name = 'turtle_meat', count = 1, craft = true, time = 2500, anim = 'parquimetro', needs = {
        {name = 'baby_turtle', count = 1, consume = true},
        {name = 'WEAPON_KNIFE', count = 1, consume = false},

    }},

    { name = 'turtle_meat', count = 2, craft = true, time = 2500, anim = 'parquimetro', needs = {
        {name = 'turtle', count = 1, consume = true},
        {name = 'WEAPON_KNIFE', count = 1, consume = false},

    }},

    { name = 'turtle_meat', count = 4, craft = true, time = 2500, anim = 'parquimetro', needs = {
        {name = 'rare_turtle', count = 1, consume = true},
        {name = 'WEAPON_KNIFE', count = 1, consume = false},

    }},

    { name = 'turtle_meat', count = 8, craft = true, time = 2500, anim = 'parquimetro', needs = {
        {name = 'legendary_turtle', count = 1, consume = true},
        {name = 'WEAPON_KNIFE', count = 1, consume = false},

    }},
}


   --{ name = 'ham_sandwich', count = 1, craft = true, time = 2000, anim = 'parquimetro', needs = {  
   --     {name = 'ham', count = 1, consume = true},
   --     {name = 'bread_slice', count = 2, consume = true},
  --  }}, 

 --  { name = 'cheese_sandwich', count = 1, craft = true, time = 2000, anim = 'parquimetro', needs = {  
 --       {name = 'cheese', count = 1, consume = true},
 --       {name = 'bread_slice', count = 2, consume = true},
 --   }},

 --  { name = 'mixed_sandwich', count = 1, craft = true, time = 2000, anim = 'parquimetro', needs = {  
 --       {name = 'ham', count = 1, consume = true},
 --       {name = 'cheese', count = 1, consume = true},
 --       {name = 'bread_slice', count = 2, consume = true},
 --   }},
--}




--, enableInfluence = true, influenceVariation = 10
--influenceCount = 5, influenceTime = 1000

local pecasItemsCraft = { --(10 = 1% de influence)
    {name = 'weapon_part', craft = true, time = 30000, influenceTime = 28000, anim = 'soldar', needXp = true, typer = 'org', level = 1, increment = 60, needs = {
        {name = 'rubber',           count = 8, influenceCount = 7}, 
        {name = 'copper',           count = 8, influenceCount = 7},
        {name = 'iron',             count = 8, influenceCount = 7},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 30000, influenceTime = 28000, anim = 'soldar', needXp = true, typer = 'org', level = 2, increment = 60, needs = {
        {name = 'rubber',           count = 7, influenceCount = 6},
        {name = 'copper',           count = 7, influenceCount = 6},
        {name = 'iron',             count = 7, influenceCount = 6},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 30000, influenceTime = 28000, anim = 'soldar', needXp = true, typer = 'org', level = 3, increment = 60, needs = {   
        {name = 'rubber',           count = 6, influenceCount = 5},
        {name = 'copper',           count = 6, influenceCount = 5},
        {name = 'iron',             count = 6, influenceCount = 5},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 30000, influenceTime = 28000, anim = 'soldar', needXp = true, typer = 'org', level = 4, increment = 55, needs = {
        {name = 'rubber',           count = 5},
        {name = 'copper',           count = 5},
        {name = 'iron',             count = 5, influenceCount = 4},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 30000, influenceTime = 28000, anim = 'soldar', needXp = true, typer = 'org', level = 5, increment = 55, needs = {
        {name = 'rubber',           count = 5},
        {name = 'copper',           count = 5, influenceCount = 4},
        {name = 'iron',             count = 4},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 25000, influenceTime = 24000, anim = 'soldar', needXp = true, typer = 'org', level = 6, increment = 55, needs = {
        {name = 'rubber',           count = 5, influenceCount = 4},
        {name = 'copper',           count = 4},
        {name = 'iron',             count = 4},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 25000, influenceTime = 24000, anim = 'soldar', needXp = true, typer = 'org', level = 7, increment = 50, needs = {
        {name = 'rubber',           count = 4},
        {name = 'copper',           count = 4},
        {name = 'iron',             count = 4, influenceCount = 3},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 25000, influenceTime = 24000, anim = 'soldar', needXp = true, typer = 'org', level = 8, increment = 50, needs = {
        {name = 'rubber',           count = 4},
        {name = 'copper',           count = 4, influenceCount = 3},
        {name = 'iron',             count = 3},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 25000, influenceTime = 24000, anim = 'soldar', needXp = true, typer = 'org', level = 9, increment = 50, needs = {
        {name = 'rubber',           count = 4, influenceCount = 3},
        {name = 'copper',           count = 3},
        {name = 'iron',             count = 3},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 25000, influenceTime = 24000, anim = 'soldar', needXp = true, typer = 'org', level = 10, increment = 35, needs = {
        {name = 'rubber',           count = 3},
        {name = 'copper',           count = 3},
        {name = 'iron',             count = 3},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3, influenceCount = 2},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 11, increment = 35, needs = {
        {name = 'rubber',           count = 3},
        {name = 'copper',           count = 3},
        {name = 'iron',             count = 3},
        {name = 'electronic_waste', count = 3},
        {name = 'scrap',            count = 3, influenceCount = 2},
        {name = 'recicled_plastic', count = 3},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 12, increment = 35, needs = {
        {name = 'rubber',           count = 3},
        {name = 'copper',           count = 3},
        {name = 'iron',             count = 3},
        {name = 'electronic_waste', count = 3, influenceCount = 2},
        {name = 'scrap',            count = 3, influenceCount = 2},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 13, increment = 30, needs = {
        {name = 'rubber',           count = 3},
        {name = 'copper',           count = 3},
        {name = 'iron',             count = 3},
        {name = 'electronic_waste', count = 3, influenceCount = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 14, increment = 30, needs = {
        {name = 'rubber',           count = 3},
        {name = 'copper',           count = 3},
        {name = 'iron',             count = 3},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 15, increment = 30, needs = {
        {name = 'rubber',           count = 3},
        {name = 'copper',           count = 3},
        {name = 'iron',             count = 2},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 16, increment = 25, needs = {
        {name = 'rubber',           count = 3},
        {name = 'copper',           count = 2},
        {name = 'iron',             count = 2},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 17, increment = 25, needs = {
        {name = 'rubber',           count = 2},
        {name = 'copper',           count = 2},
        {name = 'iron',             count = 2},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 18, increment = 25, needs = {
        {name = 'rubber',           count = 2},
        {name = 'copper',           count = 2, influenceCount = 1},
        {name = 'iron',             count = 1},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 19, increment = 20, needs = {
        {name = 'rubber',           count = 2, influenceCount = 1},
        {name = 'copper',           count = 1},
        {name = 'iron',             count = 1},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 20000, influenceTime = 18000, anim = 'soldar', needXp = true, typer = 'org', level = 20, increment = 20, needs = {
        {name = 'rubber',           count = 1},
        {name = 'copper',           count = 1},
        {name = 'iron',             count = 1},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 15000, influenceTime = 13000, anim = 'soldar', needXp = true, typer = 'org', level = 21, increment = 10, needs = {
        {name = 'copper',           count = 1},
        {name = 'iron',             count = 1},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 15000, influenceTime = 13000, anim = 'soldar', needXp = true, typer = 'org', level = 22, increment = 10, needs = {
        {name = 'iron',             count = 1},
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 15000, influenceTime = 13000, anim = 'soldar', needXp = true, typer = 'org', level = 23, increment = 10, needs = {
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 14000, influenceTime = 12000, anim = 'soldar', needXp = true, typer = 'org', level = 24, increment = 8, needs = {
        {name = 'electronic_waste', count = 2},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 13000, influenceTime = 11000, anim = 'soldar', needXp = true, typer = 'org', level = 25, increment = 8, needs = {
        {name = 'electronic_waste', count = 2, influenceCount = 1},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 12000, influenceTime = 10000, anim = 'soldar', needXp = true, typer = 'org', level = 26, increment = 5, needs = {
        {name = 'electronic_waste', count = 2, influenceCount = 1},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 11000, influenceTime = 10000, anim = 'soldar', needXp = true, typer = 'org', level = 27, increment = 5, needs = {
        {name = 'electronic_waste', count = 2, influenceCount = 1},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 10000, influenceTime = 9000, anim = 'soldar', needXp = true, typer = 'org', level = 28, increment = 5, needs = {
        {name = 'electronic_waste', count = 2, influenceCount = 1},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 10000, influenceTime = 9000, anim = 'soldar', needXp = true, typer = 'org', level = 29, increment = 1, needs = {
        {name = 'electronic_waste', count = 1},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2},
    }},
    {name = 'weapon_part', craft = true, time = 9000, anim = 'soldar', needXp = true, typer = 'org', level = 30, increment = 1, needs = {
        {name = 'electronic_waste', count = 1},
        {name = 'scrap',            count = 2, influenceCount = 1},
        {name = 'recicled_plastic', count = 2, influenceCount = 1},
    }},
    {name = 'weapon_part', craft = true, time = 8000, anim = 'soldar', needXp = true, typer = 'org', level = 31, increment = 1, needs = {
        {name = 'electronic_waste', count = 1},
        {name = 'scrap',            count = 1},
        {name = 'recicled_plastic', count = 2, influenceCount = 1},
    }},
    {name = 'weapon_part', craft = true, time = 7000, influenceCount = 2, anim = 'soldar', needXp = true, typer = 'org', level = 32, increment = 1, needs = {
        {name = 'electronic_waste', count = 1},
        {name = 'scrap',            count = 1},
        {name = 'recicled_plastic', count = 1},
    }},
    {name = 'weapon_part', craft = true, time = 5000, influenceCount = 2, anim = 'soldar', needXp = true, typer = 'org', level = 33, increment = 0, needs = {
        {name = 'electronic_waste', count = 1},
        {name = 'scrap',            count = 1},
        {name = 'recicled_plastic', count = 1},
    }},
}

local function deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepCopy(orig_key)] = deepCopy(orig_value)
        end
        setmetatable(copy, deepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

ESX.craftItems = {
    -- CRAFT PEÇAS PRONTO
    ["craft_pecas"] = { pos = {
        vector3(-297.76, -2599.56, 6.20),    -- Marine
    },  jobs = {'none'}, enableInfluence = true, influenceVariation = 5, items = deepCopy(pecasItemsCraft)},

    ["craft_pecas2"] = { pos = {
        vector3(-1090.18, 4940.61, 214.12),    -- CACADORES
    },  jobs = {'none'}, enableInfluence = true, influenceVariation = 5, items = deepCopy(pecasItemsCraft)},

    ["craft_pecas3"] = { pos = {
        vector3(57.88, 3699.61, 39.75),    --STAB
    },  jobs = {'none'}, enableInfluence = true, influenceVariation = 5, items = deepCopy(pecasItemsCraft)},


    -- CRAFT PEÇAS Estragadas
    ["craft_pecasestragadas"] = { pos = {
        vector3(5477.01, -5852.25, 20.68),     --ilha
    },  jobs = {}, enableInfluence = true, influenceVariation = 5, items = {
        {name = 'weapon_part', count = 1, craft = true, time = 30000, influenceTime = 28000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 1, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 11, influenceCount = 10},
            {name = 'scrap',                   count =  5},
        }},
        {name = 'weapon_part', count = 1, craft = true, time = 27000, influenceTime = 26000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 2, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 10, influenceCount = 9},
            {name = 'scrap',                   count = 4},
        }},
        {name = 'weapon_part', count = 1, craft = true, time = 24000, influenceTime = 23000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 3, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 9, influenceCount = 8},
            {name = 'scrap',                   count = 3},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 21000, influenceTime = 20000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 4, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 8, influenceCount = 7},
            {name = 'scrap',                   count = 2},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 18000, influenceTime = 17000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 5, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 7, influenceCount = 6},
            {name = 'scrap',                   count = 2},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 15000, influenceTime = 14000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 6, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 6, influenceCount = 5},
            {name = 'scrap',                   count = 2},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 12000, influenceTime = 11000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 7, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 5, influenceCount = 3},
            {name = 'scrap',                   count = 2, influenceCount = 1},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 9000, influenceTime = 8000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 8, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 4, influenceCount = 3},
            {name = 'scrap',                   count = 2, influenceCount = 1},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 7000, influenceCount = 3, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 9, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 3, influenceCount = 2},
            {name = 'scrap',                   count = 2, influenceCount = 1},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 5000, influenceCount = 3, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 10, increment = 0, needs = {
            {name = 'broken_weapon_part',      count = 3, influenceCount = 2},
            {name = 'scrap',                   count = 2, influenceCount = 1},
        }},
        
   }},

       -- CRAFT PEÇAS Estragadas2
    ["craft_pecasestragadas2"] = { pos = {
        vector3(942.64, -1516.15, 31.19),     --cidade
    },  jobs = {}, enableInfluence = true, influenceVariation = 5, items = {
        {name = 'weapon_part', count = 1, craft = true, time = 30000, influenceTime = 28000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 1, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 11, influenceCount = 10},
            {name = 'scrap',                   count =  5},
        }},
        {name = 'weapon_part', count = 1, craft = true, time = 27000, influenceTime = 26000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 2, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 10, influenceCount = 9},
            {name = 'scrap',                   count = 4},
        }},
        {name = 'weapon_part', count = 1, craft = true, time = 24000, influenceTime = 23000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 3, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 9, influenceCount = 8},
            {name = 'scrap',                   count = 3},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 21000, influenceTime = 20000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 4, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 8, influenceCount = 7},
            {name = 'scrap',                   count = 2},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 18000, influenceTime = 17000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 5, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 7, influenceCount = 6},
            {name = 'scrap',                   count = 2},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 15000, influenceTime = 14000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 6, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 6, influenceCount = 5},
            {name = 'scrap',                   count = 2},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 12000, influenceTime = 11000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 7, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 5, influenceCount = 3},
            {name = 'scrap',                   count = 2, influenceCount = 1},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 9000, influenceTime = 8000, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 8, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 4, influenceCount = 3},
            {name = 'scrap',                   count = 2, influenceCount = 1},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 7000, influenceCount = 3, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 9, increment = 5, needs = {
            {name = 'broken_weapon_part',      count = 3, influenceCount = 2},
            {name = 'scrap',                   count = 2, influenceCount = 1},
        }},
        {name = 'weapon_part', count = 2, craft = true, time = 5000, influenceCount = 3, anim = 'soldar', needOrgXp = true, typer = 'peçasestragadas', level = 10, increment = 0, needs = {
            {name = 'broken_weapon_part',      count = 3, influenceCount = 2},
            {name = 'scrap',                   count = 2, influenceCount = 1},
        }},
        
   }},

   ["reciclagem"] = {pos = {vector3(168.1019, 6392.7661, 30.4792)}, jobs = {'none'}, enableInfluence = false, influenceVariation = 0, items = {
        {name = 'componenteseletronicos', count = 1, craft = true, time = 5000, anim = 'soldar', needOrgXp = false, typer = 'reciclagem', level = 1, increment = 5, needs = {
            {name = 'bradio', count = 2},
            {name = 'btel', count = 2},
        }},
        {name = 'fibra', count = 1, craft = true, time = 5000, anim = 'soldar', needOrgXp = false, typer = 'reciclagem', level = 1, increment = 5, needs = {
            {name = 'leather', count = 5},
            {name = 'feather', count = 2},
        }},
        {name = 'jar', count = 1, craft = true, time = 5000, anim = 'soldar', needOrgXp = false, typer = 'reciclagem', level = 1, increment = 5, needs = {
            {name = 'recicled_plastic', count = 15},
        }},
        {name = 'kevlar', count = 1, craft = true, time = 5000, anim = 'soldar', needOrgXp = false, typer = 'reciclagem', level = 1, increment = 5, needs = {
            {name = 'fibra', count = 5},
        }},
        {name = 'oxido_nitroso', count = 1, craft = true, time = 5000, anim = 'soldar', needOrgXp = false, typer = 'reciclagem', level = 1, increment = 5, needs = {
            {name = 'aluminio', count = 100},
            {name = 'steel', count = 1},
            {name = 'copper', count = 100},
        }},
   }},



    -- Craft Carregadores ORG 1
    ["craft_carregadores_org"] = { pos = { vector3(467.19, -3220.47, 7.06) }, jobs =  {}, enableInfluence = true, influenceVariation = 3, items = {
        {name = 'micro_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 1, increment = 5, needs = {
            {name = 'gunpowder',    count = 3, influenceCount = 2},
            {name = 'copper',       count = 3},
        }},
        {name = 'tec9_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 2, increment = 5, needs = {
            {name = 'gunpowder',    count = 3, influenceCount = 2},
            {name = 'copper',       count = 3},
        }},
        {name = 'tecpistol_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 3, increment = 5, needs = {
            {name = 'gunpowder',    count = 3, influenceCount = 2},
            {name = 'copper',       count = 3},
        }},
        {name = 'appistol_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 4, increment = 5, needs = {
            {name = 'gunpowder',    count = 3, influenceCount = 2},
            {name = 'copper',       count = 3},
        }},
        {name = 'heavypistol_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 5, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'pistol50_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 6, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'compactrifle_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 7, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'assaultrifle_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 8, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'assaultsmg_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 9, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'pdw_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 10, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'bullpup_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 11, increment = 5, needs = {
            {name = 'gunpowder',    count = 5, influenceCount = 3},
            {name = 'copper',       count = 5},
        }},
        {name = 'specialcarbine_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 12, increment = 5, needs = {         
            {name = 'gunpowder',    count = 5, influenceCount = 3},
            {name = 'copper',       count = 5},
        }},
        {name = 'tactical_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 13, increment = 0, needs = {         
            {name = 'gunpowder',    count = 5, influenceCount = 3},
            {name = 'copper',       count = 5},
       }},
    }},

        -- Craft Carregadores ORG 2
    ["craft_carregadores_org2"] = { pos = { vector3(726.88, 4168.98, 40.71) }, jobs =  {}, enableInfluence = true, influenceVariation = 3, items = {
        {name = 'micro_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 1, increment = 5, needs = {
            {name = 'gunpowder',    count = 3, influenceCount = 2},
            {name = 'copper',       count = 3},
        }},
        {name = 'tec9_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 2, increment = 5, needs = {
            {name = 'gunpowder',    count = 3, influenceCount = 2},
            {name = 'copper',       count = 3},
        }},
        {name = 'tecpistol_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 3, increment = 5, needs = {
            {name = 'gunpowder',    count = 3, influenceCount = 2},
            {name = 'copper',       count = 3},
        }},
        {name = 'appistol_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 4, increment = 5, needs = {
            {name = 'gunpowder',    count = 3, influenceCount = 2},
            {name = 'copper',       count = 3},
        }},
        {name = 'heavypistol_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 5, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'pistol50_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 6, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'compactrifle_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 7, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'assaultrifle_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 8, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'assaultsmg_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 9, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'pdw_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 10, increment = 5, needs = {
            {name = 'gunpowder',    count = 4, influenceCount = 3},
            {name = 'copper',       count = 4},
        }},
        {name = 'bullpup_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 11, increment = 5, needs = {
            {name = 'gunpowder',    count = 5, influenceCount = 3},
            {name = 'copper',       count = 5},
        }},
        {name = 'specialcarbine_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 12, increment = 5, needs = {         
            {name = 'gunpowder',    count = 5, influenceCount = 3},
            {name = 'copper',       count = 5},
        }},
        {name = 'tactical_clip', craft = true, time = 10000, influenceTime = 7000, anim = 'soldar', needOrgXp = true, typer = 'orgclip', level = 13, increment = 0, needs = {         
            {name = 'gunpowder',    count = 5, influenceCount = 3},
            {name = 'copper',       count = 5},
       }},
    }},


     -- Carregadores para civis 
     ["craft_carregadores_civis"] = { pos = { vector3(859.17, 2877.37, 57.98) }, jobs =  {'none'}, items = {
        {name = 'micro_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 1, increment = 5, needs = {
            {name = 'gunpowder',    count = 5},
            {name = 'copper',       count = 5},
        }},
        {name = 'tec9_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 2, increment = 5, needs = {
            {name = 'gunpowder',    count = 5},
            {name = 'copper',       count = 5},
        }},
        {name = 'tecpistol_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 3, increment = 5, needs = {
            {name = 'gunpowder',    count = 5},
            {name = 'copper',       count = 5},
        }},
        {name = 'appistol_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 4, increment = 5, needs = {
            {name = 'gunpowder',    count = 5},
            {name = 'copper',       count = 5},
        }},
        {name = 'heavypistol_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 5, increment = 5, needs = {
            {name = 'gunpowder',    count = 7},
            {name = 'copper',       count = 7},
        }},
        {name = 'pistol50_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 6, increment = 5, needs = {
            {name = 'gunpowder',    count = 7},
            {name = 'copper',       count = 7},
        }},
        {name = 'compactrifle_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 7, increment = 5, needs = {
            {name = 'gunpowder',    count = 7},
            {name = 'copper',       count = 7},
        }},
        {name = 'assaultrifle_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 8, increment = 5, needs = {
            {name = 'gunpowder',    count = 7},
            {name = 'copper',       count = 7},
        }},
        {name = 'assaultsmg_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 9, increment = 5, needs = {
            {name = 'gunpowder',    count = 7},
            {name = 'copper',       count = 7},
        }},
        {name = 'pdw_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 10, increment = 5, needs = {
            {name = 'gunpowder',    count = 9},
            {name = 'copper',       count = 9},
        }},
        {name = 'bullpup_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 11, increment = 5, needs = {
            {name = 'gunpowder',    count = 9},
            {name = 'copper',       count = 9},
        }},
        {name = 'specialcarbine_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'civilclip', level = 12, increment = 5, needs = {
            {name = 'gunpowder',    count = 9},
            {name = 'copper',       count = 9},
        }},
         {name = 'tactical_clip', craft = true, time = 10000, anim = 'soldar', needOrgXp = false, typer = 'orgclip', level = 13, increment = 0, needs = {         
            {name = 'gunpowder',    count = 9},
            {name = 'copper',       count = 9},
        }},
    }},


      -- CRAFT ARMAS ilegalofc
    ["craft_armas_ilegalofc"] = { pos = { vector3(-3485.53, 8730.82, 38.51) }, jobs = {}, enableInfluence = true, influenceVariation = 5, minCops = 0, items = {
        {name = 'WEAPON_ASSAULTSHOTGUN', craft = true, time = 30000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmassquads', level = 1, increment = 1, needs = {
            {name = 'steel',               count =  2},
            {name = 'weapon_part',         count = 30, influenceCount = 25},
            {name = 'weapon_body2',        count =  1},
        }},
        {name = 'WEAPON_HEAVYSHOTGUN', craft = true, time = 30000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmassquads', level = 2, increment = 0, needs = {
            {name = 'steel',               count =  2},
            {name = 'weapon_part',         count = 40, influenceCount = 35},
            {name = 'weapon_body2',        count =  1},
        }},
    }},


    -- CRAFT ARMAS Squads
    ["craft_armas_squads"] = { pos = { vector3(1381.74, 2167.54, 97.86) }, jobs = {},  enableInfluence = true, influenceVariation = 5, minCops = 0, items = {
        {name = 'WEAPON_MINISMG', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmassquads', level = 1, increment = 10, needs = {
            {name = 'steel',               count =  2}, 
            {name = 'weapon_part',         count = 10, influenceCount = 8},
            {name = 'minismg_body',        count =  1}, 
            {name = 'weapon_body2',        count =  1},
        }},                                                                        -- Pistolxm3
        {name = 'WEAPON_PISTOLXM3', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmassquads', level = 2, increment = 10, needs = {
            {name = 'steel',               count =  2},
            {name = 'weapon_part',         count = 10, influenceCount = 8},
            {name = 'pistolxm3_body',      count =  1},
            {name = 'weapon_body2',        count =  1},
        }},                                                                          --  UZI
        {name = 'WEAPON_MICROSMG', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmassquads', level = 3, increment = 10, needs = {
            {name = 'steel',               count =  2},
            {name = 'weapon_part',         count = 15, influenceCount = 12},
            {name = 'microsmg_body',       count =  1},
            {name = 'weapon_body2',        count =  1},
        }},                                                                      -- MACHINEPISTOL 
        {name = 'WEAPON_MACHINEPISTOL', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmassquads', level = 4, increment = 10, needs = {
            {name = 'steel',               count =  2},
            {name = 'weapon_part',         count = 15, influenceCount = 12},
            {name = 'machinepistol_body',  count =  1},
            {name = 'weapon_body2',        count =  1},
        }},                                                                         -- TECPISTOL
        {name = 'WEAPON_TECPISTOL', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmassquads', level = 5, increment = 10, needs = {
            {name = 'steel',               count =  2},
            {name = 'weapon_part',         count = 20, influenceCount = 15},
            {name = 'tecpistol_body',      count =  1},
            {name = 'weapon_body2',        count =  1},
        }},                                                                          -- APPISTOL
        {name = 'WEAPON_APPISTOL', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmassquads', level = 6, increment = 0, needs = {
            {name = 'steel',               count =  2},
            {name = 'weapon_part',         count = 20, influenceCount = 15},
            {name = 'appistol_body',       count =  1},
            {name = 'weapon_body2',        count =  1},
        }},
    }},



     ["craft_tatical"] = { pos = { vector3(5586.43, -5223.21, 14.35) }, jobs = {'squad1', 'squad2', 'squad3', 'squad4', 'squad5', 'squad6', 'squad7', 'squad8', 'squad9', 'squad10', 'squad11', 'squad12', 'ilegal4','familia1', 'familia2', 'familia3', 'familia4', 'familia5', 'familia6','kiwi','cpx1', 'cpx2', 'cpx3', 'cpx4', 'cpx5', 'cpx6','ilegal1','ilegal2','ilegal3','ilegal4','ilegal5','ilegal6','random4','random2'}, minCops = 0, items = {                           
        {name = 'WEAPON_TACTICALRIFLE', craft = true, time = 30000, anim = 'soldar', needs = {
            {name = 'steel',              count = 10},
            {name = 'weapon_part',        count = 90},
            {name = 'weapon_body3',       count =  1},
        }},
    }},



    ["craft_modulos"] = { pos = { vector3(-533.19, 5292.13, 74.17) }, jobs = {'none'}, items = {
        {name = 'weapon_module', craft = true, time = 2500, anim = 'mecanico', needs = {
            {name = 'wood_dust',       count =   20},
            {name = 'wood_plank_pine', count =    5},
            {name = 'rubber',          count =    5},
        }},
    }},



    -- CRAFT ARMAS Squads / para os CPX
    ["craft_corpos_squads"] = { pos = { vector3(1664.64, -49.83, 168.31) }, jobs = {}, enableInfluence = true, influenceVariation = 5, minCops = 3, items = {
        {name = 'minismg_body', craft = true, time = 10000, influenceTime = 8000, anim = 'mecanico', needs = {
            {name = 'weapon_module',               count =  1}, 
            {name = 'scrap',                       count = 10, influenceCount = 8},
        }},
        {name = 'pistolxm3_body', craft = true, time = 10000, influenceTime = 8000, anim = 'mecanico', needs = {
            {name = 'weapon_module',               count =  1},
            {name = 'scrap',                       count = 10, influenceCount = 8},
        }},
        {name = 'microsmg_body', craft = true, time = 10000, influenceTime = 8000, anim = 'mecanico', needs = {
            {name = 'weapon_module',               count =  1}, 
            {name = 'scrap',                       count = 15, influenceCount = 13},
        }},
        {name = 'machinepistol_body', craft = true, time = 10000, influenceTime = 8000, anim = 'mecanico', needs = {
            {name = 'weapon_module',               count =  1}, 
            {name = 'scrap',                       count = 15, influenceCount = 13},
        }},
        {name = 'tecpistol_body', craft = true, time = 10000, influenceTime = 8000, anim = 'mecanico', needs = {
            {name = 'weapon_module',               count =  1}, 
            {name = 'scrap',                       count = 20, influenceCount = 18},
        }},
        {name = 'appistol_body', craft = true, time = 10000, influenceTime = 8000, anim = 'mecanico', needs = {
            {name = 'weapon_module',               count =  1}, 
            {name = 'scrap',                       count = 20, influenceCount = 18},
        }},
    }},


    -- CRAFT ARMAS empresas
    ["craft_armas_empresas"] = { pos = { vector3(1688.78, 3291.34, 41.15) }, jobs = {},  enableInfluence = true, influenceVariation = 5, minCops = 0, items = {
        {name = 'WEAPON_HEAVYPISTOL', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmas', level = 1, increment = 15, needs = {
            {name = 'steel',               count =  5},
            {name = 'weapon_part',         count = 25, influenceCount = 20},
            {name = 'weapon_body',         count =  1},
        }},
        {name = 'WEAPON_PISTOL50', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmas', level = 2, increment = 10, needs = {
            {name = 'steel',               count =  5},
            {name = 'weapon_part',         count = 40, influenceCount = 35},
            {name = 'weapon_body',         count =  1},
        }},
        {name = 'WEAPON_ASSAULTSMG', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmas', level = 3, increment = 10, needs = {
            {name = 'steel',               count =  5},
            {name = 'weapon_part',         count = 45, influenceCount = 35},
            {name = 'weapon_body',         count =  1},
        }},
        {name = 'WEAPON_COMBATPDW', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmas', level = 4, increment = 10, needs = {
            {name = 'steel',               count =  5},
            {name = 'weapon_part',         count = 45, influenceCount = 35},
            {name = 'weapon_body',         count =  1},
        }},
            {name = 'WEAPON_DOUBLEACTION', craft = true, time = 25000, influenceTime = 35000, anim = 'soldar', needOrgXp = true, typer = 'orgarmas', level = 5, increment = 10, needs = {
            {name = 'steel',              count = 5,  influenceCount =  2},
            {name = 'gold_ingot',         count = 5,  influenceCount =  2},
            {name = 'weapon_part',        count = 60, influenceCount = 45},
            {name = 'weapon_body4',       count = 1},
        }},
        {name = 'WEAPON_GADGETPISTOL', craft = true, time = 25000, influenceTime = 35000, anim = 'soldar', needOrgXp = true, typer = 'orgarmas', level = 6, increment = 5, needs = {
            {name = 'steel',              count = 5,  influenceCount =  2},
            {name = 'gold_ingot',         count = 5,  influenceCount =  2},
            {name = 'weapon_part',        count = 60, influenceCount = 45},
            {name = 'weapon_body4',       count = 1},
        }},
        {name = 'WEAPON_BULLPUPRIFLE', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmas', level = 7, increment = 5, needs = {
            {name = 'steel',               count =  8},
            {name = 'weapon_part',         count =  60, influenceCount = 55},
            {name = 'weapon_body3',        count =  1},
        }},
        {name = 'WEAPON_SPECIALCARBINE', craft = true, time = 28000, influenceTime = 25000, anim = 'soldar', needOrgXp = true, typer = 'orgarmas', level = 8, increment = 0, needs = {
            {name = 'steel',               count =  8},
            {name = 'weapon_part',         count =  65, influenceCount = 60},
            {name = 'weapon_body3',        count =  1},
        }},
    }},


    -- CRAFT ARMAS BRANCAS  
    ["craft_armas_brancas"] = { pos = { vector3(2168.42, 5113.68, 47.38 - 1.0001) }, jobs = {'none'}, items = { -- LOS SANTOS   
        {name = 'WEAPON_BAT', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'iron', count = 5},
            {name = 'scrap', count = 2},
        }},
        {name = 'WEAPON_POOLCUE', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'recicled_plastic', count = 2},
            {name = 'wood_plank_cherry', count = 5},
        }},
        {name = 'WEAPON_BOTTLE', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'coal', count = 2},
            {name = 'recicled_plastic',count = 5},
        }},
        {name = 'WEAPON_MACHETE', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'copper', count = 5},
            {name = 'wood_plank_oak', count = 2},
        }},
        {name = 'WEAPON_HAMMER', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'iron', count = 5},
            {name = 'wood_plank_pine', count = 2},
        }},
        {name = 'WEAPON_CROWBAR', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'iron', count = 5},
            {name = 'scrap', count = 5},
        }},
        {name = 'WEAPON_GOLFCLUB', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'iron', count = 5},
            {name = 'recicled_plastic', count = 2},
        }},
        {name = 'WEAPON_WRENCH', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'copper', count = 5},
            {name = 'iron', count = 5},
        }},
        {name = 'WEAPON_BATTLEAXE', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'iron', count = 2},
            {name = 'wood_plank_pine', count = 5},
        }},
        {name = 'WEAPON_SWITCHBLADE', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'iron', count = 10},
        }},
        {name = 'WEAPON_KNIFE', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'iron', count = 10},
        }},
        {name = 'WEAPON_DAGGER', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'copper', count = 10},
        }},
        {name = 'WEAPON_KNUCKLE', craft = true, time = 15000, anim = 'mecanico', needs = {
            {name = 'gold_ingot', count = 2},
            {name = 'scrap', count = 1},
        }},
    }},
    

    ["craft_coletes"] = { pos = { vector3(738.88, -2003.29, 45.80) }, jobs = {'none'}, items = {
        {name = 'armor', craft = true, time = 15000, anim = 'mecanico', needXp = true, typer = 'craftcolete', level = 1, increment = 5, needs = {
            {name = 'kevlar', count = 2},
            {name = 'leather', count = 1},
        }},
        {name = 'armor', craft = true, time = 13000, anim = 'mecanico', needXp = true, typer = 'craftcolete', level = 2, increment = 5, needs = {
            {name = 'kevlar', count = 1},
            {name = 'leather', count = 1},
        }},
        {name = 'armor2', craft = true, time = 11000, anim = 'mecanico', needXp = true, typer = 'craftcolete', level = 3, increment = 5, needs = {
            {name = 'kevlar', count = 4},
            {name = 'leather', count = 1},
        }},
        {name = 'armor2', craft = true, time = 9000, anim = 'mecanico', needXp = true, typer = 'craftcolete', level = 4, increment = 5, needs = {
            {name = 'kevlar', count = 3},
            {name = 'leather', count = 1},
        }},
        {name = 'armor3', craft = true, time = 7000, anim = 'mecanico', needXp = true, typer = 'craftcolete', level = 5, increment = 5, needs = {
            {name = 'kevlar', count = 6},
            {name = 'leather', count = 1},
        }},
        {name = 'armor3', craft = true, time = 7000, anim = 'mecanico', needXp = true, typer = 'craftcolete', level = 6, increment = 0, needs = {
            {name = 'kevlar', count = 5},
            {name = 'leather', count = 1},
        }},
    }},

   -- CRAFT AÇO PRONTO
    ["craft_aco"] = { pos = { vector3(-629.43, -1726.60, 24.06) }, jobs = {'none'}, items = {
        {name = 'steel', craft = true, time = 2500, anim = 'soldar', needXp = true, typer = 'acocraft', level = 1, increment = 5, needs = {
            {name = 'iron', count =   5},
            {name = 'scrap', count =  5},
            {name = 'coal', count =   1},
        }},
         {name = 'steel', craft = true, time = 2500, anim = 'soldar', needXp = true, typer = 'acocraft', level = 2, increment = 5, needs = {
            {name = 'iron', count =   4},
            {name = 'scrap', count =  5},
            {name = 'coal', count =   1},
        }},
         {name = 'steel', craft = true, time = 2500, anim = 'soldar', needXp = true, typer = 'acocraft', level = 3, increment = 5, needs = {
            {name = 'iron', count =   4},
            {name = 'scrap', count =  4},
            {name = 'coal', count =   1},
        }},
         {name = 'steel', craft = true, time = 2500, anim = 'soldar', needXp = true, typer = 'acocraft', level = 4, increment = 5, needs = {
            {name = 'iron', count =   3},
            {name = 'scrap', count =  4},
            {name = 'coal', count =   1},
        }},
         {name = 'steel', craft = true, time = 2500, anim = 'soldar', needXp = true, typer = 'acocraft', level = 5, increment = 5, needs = {
            {name = 'iron', count =   3},
            {name = 'scrap', count =  3},
            {name = 'coal', count =   1},
        }},
         {name = 'steel', craft = true, time = 2500, anim = 'soldar', needXp = true, typer = 'acocraft', level = 6, increment = 5, needs = {
            {name = 'iron', count =   2},
            {name = 'scrap', count =  3},
            {name = 'coal', count =   1},
        }},
         {name = 'steel', craft = true, time = 2500, anim = 'soldar', needXp = true, typer = 'acocraft', level = 7, increment = 0, needs = {
            {name = 'iron', count =   2},
            {name = 'scrap', count =  2},
            {name = 'coal', count =   1},
        }},
    }},

     --Lavagem de guita
    ["lavagem_dinheiro"] = { pos = { vector3(-106.49, -2234.73, 7.81) }, jobs = {},  minCops = 3, items = {
        {name = 'cash', count = 8000, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 1, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8100, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 2, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8200, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 3, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8300, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 4, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8400, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 5, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8500, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 6, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8600, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 7, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8700, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 8, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8800, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 9, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 8900, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 10, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 9000, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 11, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 9100, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 12, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 9200, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 13, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 9300, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 14, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 9400, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 15, increment = 50, needs = {
            {name = 'black_money',   count = 10000},
        }},
         {name = 'cash', count = 9500, craft = true, time = 2000, anim = 'mecanico', needOrgXp = true, typer = 'lavagemdinheiro', level = 16, increment = 0, needs = {
            {name = 'black_money',   count = 10000},
        }},
    }},

    -- Traficantes 
    ["traficante_hashish"] = { pos = { vector3(159.00, -1717.70, 29.29), vector3(160.07, -1719.32, 29.29) }, jobs = {'none'}, items = {    -- reformular
        {name = 'black_money', count = 425, craft = true, time = 1000, anim = 'mecanico', needs = {
            {name = 'blunt_hashish',  count = 1},
        }},
    }},

    -- WEED
    ["traficante_weed"] = { pos = { vector3(1975.70, 3823.98, 32.47), vector3(1974.95, 3825.56, 32.34) }, jobs = {'none'}, items = {   -- reformular 
        {name = 'black_money', count = 425, craft = true, time = 1000, anim = 'mecanico', needs = {
            {name = 'blunt_weed',  count = 1},
        }},
    }},

    -- ILHA ZÉ!!!
    ["craft_ze"] = { pos = { vector3(4162.19, -789.95, 7.69) }, jobs = {'none'}, items = {
        {name = 'black_money', count = 480, craft = true, time = 2500, anim = 'mecanico', needs = {
            {name = 'hashish_pooch',  count =  1},
        }}, 
        {name = 'WEAPON_SNSPISTOL_MK2', craft = true, time = 10000, anim = 'soldar', needs = {
            {name = 'chip_mk2_ruby',  count = 1},
            {name = 'WEAPON_SNSPISTOL', count = 1},
            {name = 'black_money',   count = 2500},
        }},
        {name = 'sns_extended', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 2000},
        }},
        {name = 'compensator2', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'flashlight5', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 300},
        }},
        {name = 'suppressor1', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'WEAPON_PISTOL_MK2', craft = true, time = 10000, anim = 'soldar', needs = {
            {name = 'chip_mk2_ruby',  count = 1},
            {name = 'WEAPON_PISTOL', count = 1},
            {name = 'black_money',   count = 5000},
        }},
        {name = 'pistol_extended', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 2000},
        }},
        {name = 'flashlight1', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 300},
        }},
        {name = 'suppressor1', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'WEAPON_ASSAULTRIFLE_MK2', craft = true, time = 20000, anim = 'soldar', needs = {
            {name = 'chip_mk2_ruby',  count = 1},
            {name = 'WEAPON_ASSAULTRIFLE', count = 1}, 
            {name = 'black_money',   count = 10000},
        }},
        {name = 'assaultrifle_extended', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 2000},
        }},
        {name = 'assaultrifle_mag', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 3000},
        }},
        {name = 'assaultrifle_barrel', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 1000},
        }},
        {name = 'compensator4', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator5', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator6', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator7', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator8', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator9', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator10', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'flashlight2', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 300},
        }},
        {name = 'scope1', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 300},
        }},
        {name = 'suppressor2', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'grip2', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'WEAPON_SPECIALCARBINE_MK2', craft = true, time = 20000, anim = 'soldar', needs = {
            {name = 'chip_mk2_ruby',  count = 1},
            {name = 'WEAPON_SPECIALCARBINE', count = 1}, 
            {name = 'black_money',   count = 20000},
        }},
        {name = 'specialcarbine_extended', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 2000},
        }},
        {name = 'specialcarbine_barrel', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 1000},
        }},
        {name = 'compensator4', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator5', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator6', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator7', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator8', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator9', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator10', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'flashlight3', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 300},
        }},
        {name = 'scope3', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 300},
        }},
        {name = 'suppressor2', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'grip2', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'WEAPON_BULLPUPRIFLE_MK2', craft = true, time = 20000, anim = 'soldar', needs = {
            {name = 'chip_mk2_ruby',  count = 1},
            {name = 'WEAPON_BULLPUPRIFLE', count = 1}, 
            {name = 'black_money',   count = 20000},
        }},
        {name = 'bullpup_extended', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 2000},
        }},
        {name = 'bullpuprifle_barrel', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 1000},
        }},
        {name = 'compensator4', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator5', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator6', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator7', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator8', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator9', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'compensator10', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'flashlight3', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 300},
        }},
        {name = 'scope2', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 300},
        }},
        {name = 'suppressor3', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},
        {name = 'grip2', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'black_money',  count = 500},
        }},

        --- CARREGADORES ZÉ---
        {name = 'sns_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip9',  count = 1},
        }},
        {name = 'pistol_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip9',  count = 1},
        }},
        {name = 'vintage_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip9',  count = 1},
        }},
        {name = 'combatpistol_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip9',  count = 1},
        }},
        {name = 'micro_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip45',  count = 1},
        }},
        {name = 'tec9_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip45',  count = 1},
        }},
        {name = 'tecpistol_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip45',  count = 1},
        }},
        {name = 'appistol_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip45',  count = 1},
        }},
        {name = 'pdw_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip45',  count = 1},
        }},
        {name = 'smg_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip45',  count = 1},
        }},
        {name = 'heavypistol_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip556',  count = 1},
        }},
        {name = 'pistol50_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip556',  count = 1},
        }},
        {name = 'gusenberg_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip556',  count = 1},
        }},
        {name = 'assaultsmg_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip762',  count = 1},
        }},
        {name = 'bullpup_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip762',  count = 1},
        }},
        {name = 'specialcarbine_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip762',  count = 1},
        }},
        {name = 'assaultrifle_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip762',  count = 1},
        }},
        {name = 'compactrifle_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip762',  count = 1},
        }},
        {name = 'carbinerifle_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip762',  count = 1},
        }},
        {name = 'heavyrifle_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip762',  count = 1},
        }},
        {name = 'tactical_clip', craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'clip762',  count = 1},
        }},
    }},


    ["crack_xp"] = { pos = { 
        vector3(1301.94, -2650.00, 49.07),
        vector3(-2926.94, 1489.35, 76.99),
        vector3(117.70, 1317.40, 278.85),
        vector3(2554.26, 2550.75, 42.94),
        vector3(1784.59, 6527.10, 71.30),
        vector3(3209.24, 5134.86, 21.97),
    }, jobs = {'ambulance','ammu','ammu2','anzol','costureiro','ctt','governo','lixeiro','lumberjack','miner','nautica','navy','nightclub','offambulance','offmechanic','reboque','rubber','tribunal','ubereats','vila','unemployed','weazelnews'}, items = { -- CRACK
        {name = 'crack', count = 1, craft = true, time = 15000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 1, increment = 30, needs = {
            {name = 'coke', count = 5},
            {name = 'sodiumbicarbonate', count = 5},
        }},
        {name = 'crack', count = 1, craft = true, time = 15000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 2, increment = 30, needs = {
            {name = 'coke', count = 4},
            {name = 'sodiumbicarbonate', count = 4},
        }},
        {name = 'crack', count = 1, craft = true, time = 12500, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 3, increment = 30, needs = {
            {name = 'coke', count = 3},
            {name = 'sodiumbicarbonate', count = 3},
        }},
        {name = 'crack', count = 2, craft = true, time = 12500, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 4, increment = 20, needs = {
            {name = 'coke', count = 3},
            {name = 'sodiumbicarbonate', count = 3},
        }},
        {name = 'crack', count = 2, craft = true, time = 10000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 5, increment = 20, needs = {
            {name = 'coke', count = 2},
            {name = 'sodiumbicarbonate', count = 3},
        }},
        {name = 'crack', count = 3, craft = true, time = 10000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 6, increment = 20, needs = {
            {name = 'coke', count = 2},
            {name = 'sodiumbicarbonate', count = 2},
        }},
        {name = 'crack', count = 3, craft = true, time = 8000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 7, increment = 15, needs = {
            {name = 'coke', count = 2},
            {name = 'sodiumbicarbonate', count = 2},
        }},
        {name = 'crack', count = 3, craft = true, time = 8000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 8, increment = 15, needs = {
            {name = 'coke', count = 2},
            {name = 'sodiumbicarbonate', count = 2},
        }},
        {name = 'crack', count = 3, craft = true, time = 6000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 9, increment = 15, needs = {
            {name = 'coke', count = 2},
            {name = 'sodiumbicarbonate', count = 1},
        }},
        {name = 'crack', count = 3, craft = true, time = 6000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 10, increment = 10, needs = {
            {name = 'coke', count = 2},
            {name = 'sodiumbicarbonate', count = 1},
        }},
        {name = 'crack', count = 3, craft = true, time = 6000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 11, increment = 10, needs = {
            {name = 'coke', count = 2},
            {name = 'sodiumbicarbonate', count = 1},
        }},
        {name = 'crack', count = 3, craft = true, time = 5000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 12, increment = 10, needs = {
            {name = 'coke', count = 1},
            {name = 'sodiumbicarbonate', count = 1},
        }},
        {name = 'crack', count = 4, craft = true, time = 5000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 13, increment = 5, needs = {
            {name = 'coke', count = 1},
            {name = 'sodiumbicarbonate', count = 1},
        }},
        {name = 'crack', count = 5, craft = true, time = 5000, anim = 'mecanico',needXp = true, typer = 'crackxp', level = 14, increment = 0, needs = {
            {name = 'coke', count = 1},
            {name = 'sodiumbicarbonate', count = 1},
        }},
    }},




    -- CHIP MK2 RUBY
    ["craft_chip_mk2"] = { pos = { vector3(5588.69, -5219.38, 14.35) }, jobs = {'none'}, items = {
        {name = 'chip_mk2_ruby', craft = true, time = 5000, anim = 'soldar', needs = {   
            {name = 'hacker_device', count = 1},
            {name = 'ruby', count = 2},
            {name = 'electronic_waste', count = 1},
            {name = 'steel', count = 1},
        }},
    }},

    -- venda de joias   
    ["venda_joias_xp"] = { pos = { vector3(5010.40, -5756.39, 28.90) }, jobs = {'none'}, items = {   -- Criar craft de barras de ouro para fazer diferentes tipos de joai. 
        {name = 'black_money', count = 500, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 1, increment = 50, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 600, craft = true, time = 9000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 2, increment = 50, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 700, craft = true, time = 8500, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 3, increment = 50, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 750, craft = true, time = 8000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 4, increment = 50, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 800, craft = true, time = 7500, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 5, increment = 50, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 900, craft = true, time = 7000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 6, increment = 50, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 1000, craft = true, time = 6500, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 7, increment = 50, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 1500, craft = true, time = 6000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 8, increment = 50, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 1600, craft = true, time = 5500, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 9, increment = 40, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 1700, craft = true, time = 5000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 10, increment = 30, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 1800, craft = true, time = 4500, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 11, increment = 20, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 1900, craft = true, time = 4000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 12, increment = 20, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 2000, craft = true, time = 3900, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 13, increment = 20, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 2100, craft = true, time = 3800, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 14, increment = 15, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 2200, craft = true, time = 3700, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 15, increment = 15, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 2300, craft = true, time = 3600, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 16, increment = 10, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 2400, craft = true, time = 3500, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 17, increment = 10, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 2500, craft = true, time = 3000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 18, increment = 5, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 2600, craft = true, time = 2500, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 19, increment = 5, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 2700, craft = true, time = 2250, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 20, increment = 5, needs = {   
            {name = 'jewels',     count = 1},
        }},
        {name = 'black_money', count = 3000, craft = true, time = 2000, anim = 'mecanico', needXp = true, typer = 'joiasxp', level = 21, increment = 0, needs = {   
            {name = 'jewels',     count = 1},
        }},
    }},

       -- venda de joias   
    ["venda_ruby_xp"] = { pos = { vector3(-111.79, -11.23, 70.52) }, jobs = {'none'}, items = {   
        {name = 'black_money', count = 20000, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 1, increment = 50, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 22000, craft = true, time = 9000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 2, increment = 50, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 24000, craft = true, time = 8500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 3, increment = 50, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 26000, craft = true, time = 8000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 4, increment = 50, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 28000, craft = true, time = 7500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 5, increment = 50, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 30000, craft = true, time = 7000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 6, increment = 50, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 32000, craft = true, time = 6500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 7, increment = 50, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 34000, craft = true, time = 6000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 8, increment = 50, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 36000, craft = true, time = 5500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 9, increment = 40, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 38000, craft = true, time = 5000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 10, increment = 30, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 40000, craft = true, time = 4500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 11, increment = 20, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 42000, craft = true, time = 4000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 12, increment = 20, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 44000, craft = true, time = 3900, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 13, increment = 20, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 46000, craft = true, time = 3800, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 14, increment = 15, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 48000, craft = true, time = 3700, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 15, increment = 15, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 50000, craft = true, time = 3600, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 16, increment = 10, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 52000, craft = true, time = 3500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 17, increment = 10, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 54000, craft = true, time = 3000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 18, increment = 5, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 56000, craft = true, time = 2500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 19, increment = 5, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 58000, craft = true, time = 2250, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 20, increment = 5, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 60000, craft = true, time = 2000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 21, increment = 0, needs = {   
            {name = 'ruby',     count = 1},
        }},
        {name = 'black_money', count = 5000, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 1, increment = 5, needs = {   
            {name = 'ruby_bag',     count = 1},
        }},
        {name = 'black_money', count = 10000, craft = true, time = 9000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 2, increment = 5, needs = {   
            {name = 'ruby_bag',     count = 1},
        }},
        {name = 'black_money', count = 15000, craft = true, time = 8500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 3, increment = 5, needs = {   
            {name = 'ruby_bag',     count = 1},
        }},
        {name = 'black_money', count = 20000, craft = true, time = 8000, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 4, increment = 5, needs = {   
            {name = 'ruby_bag',     count = 1},
        }},
        {name = 'black_money', count = 30000, craft = true, time = 7500, anim = 'mecanico', needXp = true, typer = 'rubyxp', level = 5, increment = 5, needs = {   
            {name = 'ruby_bag',     count = 1},
        }},
    }},

    -- venda de barras de ouro
    ["venda_ouro_xp"] = { pos = { vector3(4986.65, -5877.21, 20.54) }, jobs = {'none'}, items = {
        {name = 'black_money', count = 400, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 1, increment = 50, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 450, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 2, increment = 50, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 500, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 3, increment = 50, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 750, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 4, increment = 50, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 1000, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 5, increment = 50, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 1250, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 6, increment = 50, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 1500, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 7, increment = 50, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 1750, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 8, increment = 50, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 2000, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 9, increment = 40, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 2250, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 10, increment = 30, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 2500, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 11, increment = 20, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 2750, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 12, increment = 20, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 3000, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 13, increment = 20, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 3250, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 14, increment = 15, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 3500, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 15, increment = 15, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 3750, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 16, increment = 10, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 4000, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 17, increment = 10, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 4250, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 18, increment = 5, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 4500, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 19, increment = 5, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 4750, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 20, increment = 5, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},
        {name = 'black_money', count = 5000, craft = true, time = 10000, anim = 'mecanico', needXp = true, typer = 'ouroxp', level = 21, increment = 0, needs = {   
            {name = 'gold_ingot',     count = 1},
        }},

    }},

    --- OFICINAS ILEGAIS CRAFT CARROS --- 
    -- Classe X     50 / 50 Time  100000    
    -- Classe S     40 / 45 Time   90000    
    -- Classe A     30 / 40 Time   80000     
    -- Classe B     20 / 35 Time   70000     
    -- Classe C     15 / 30 Time   60000      
    -- Classe D     10 / 25 Time   50000  
    -- drift        50 / 45 Time  100000   

    ["craft_vehicles_oficinas"] = { pos = { vector3(1194.50, -2944.30, 5.90) }, jobs = {}, minCops = 0, items = {   
        {vehicle = 'elegy2', vehicleType = 'car', craft = true, time = 100000, anim = 'soldar', needs = {
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   50},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   50},
            {name = 'blowpipe', count =   1, consume = false}, 
        }},
       {vehicle = 'envisage', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = {
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   45},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   40},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'flashgt', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = {
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   45},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   40},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'blista3', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = {
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   40},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   30},
            {name = 'blowpipe', count =   1, consume = false},
        }},
       {vehicle = 'everon2', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = {
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   45},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   40},
            {name = 'blowpipe', count =   1, consume = false},
        }},  
       {vehicle = 'deviant', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = {  
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   45},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   40},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'driftyosemite', vehicleType = 'car', craft = true, time = 100000, anim = 'soldar', needs = { 
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   50},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   50},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'elegy', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   45},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   40},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'gauntlet4', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   45},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   40},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'gb200', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = {  
            {name = 'advanced_circuit', count =   1},
            {name = 'copper_cable', count =   45},
            {name = 'car_motor', count =   1},
            {name = 'car_pipe', count =   40},
            {name = 'blowpipe', count =   1, consume = false},
        }},
    }},





    ["craft_advanced_circuit"] = { pos = { vector3(2328.17, 2569.82, 46.68) }, jobs = {'none'}, items = {
        {name = 'advanced_circuit', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'battery', count =   1},
            {name = 'hacker_device', count =   1},
            {name = 'copper_cable', count =   1},
            {name = 'copper_coil', count =   1},
        }},
    }},

    ["craft_motor"] = { pos = { vector3(1733.07, 3691.20, 34.43) }, jobs = {'none'}, items = {
        {name = 'car_motor', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'steel', count =   20},
            {name = 'scrap', count =   10},
            {name = 'car_pipe', count =   5},
        }},
    }},

    ["craft_pecas_carro"] = { pos = { vector3(145.00, 7793.28, 6.95) }, jobs = {'none'}, items = {
        {name = 'car_pipe', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'steel', count =   15},
            {name = 'scrap', count =   15},
            {name = 'blowpipe', count =   1, consume = false},
        }},
    }},



--  {vehicle = 'asbo', vehicleType = 'aircraft', craft = true, time = 80000, anim = 'soldar', needs = { (craft para barcos e helis) boat (barcos)
    --- OFICINAS LEGAIS CRAFT CARROS ---            
    -- Classe X     30 / 50 Time  100000    
    -- Classe S     25 / 45 Time   90000    
    -- Classe A     20 / 40 Time   80000     
    -- Classe B     15 / 35 Time   70000     
    -- Classe C     10 / 30 Time   60000      
    -- Classe D      5 / 25 Time   50000  
    -- drift        30 / 50 time  100000   

   ["craft_vehicles_oficinas_legais"] = { pos = { vector3(-199.36, -1381.08, 31.26) }, spawnPoint = vector3(-195.45, -1385.57, 31.22), jobs = {}, minCops = 0, items = {   
        {vehicle = 'asbo', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'car_electrical_system', count =   1},
            {name = 'asbo_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =   20},
            {name = 'blowpipe', count =   1, consume = false },
        }},
       {vehicle = 'bifta', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'car_electrical_system', count =   1},
            {name = 'bifta_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =   20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'boor', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'car_electrical_system', count =   1},
            {name = 'boor_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =   20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'brioso', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'car_electrical_system', count =   1},
            {name = 'brioso_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =    1},
            {name = 'car_bodywork', count =   25},
           {name = 'blowpipe', count =   1, consume = false},
        }},
       {vehicle = 'clique2', vehicleType = 'car', craft = true, time = 70000, anim = 'soldar', needs = {
            {name = 'car_electrical_system', count =   1},
            {name = 'clique2_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =   15},
            {name = 'blowpipe', count =   1, consume = false},
        }},  
        {vehicle = 'deveste', vehicleType = 'car', craft = true, time = 100000, anim = 'soldar', needs = {  
            {name = 'car_electrical_system', count =   1},
            {name = 'deveste_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =    1},
            {name = 'car_bodywork', count =   30},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'drafter', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'car_electrical_system', count =   1},
            {name = 'drafter_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =    1},
            {name = 'car_bodywork', count =   25},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'draugur', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = { 
            {name = 'car_electrical_system', count =   1},
            {name = 'draugur_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =    20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'dune', vehicleType = 'car', craft = true, time = 70000, anim = 'soldar', needs = { 
            {name = 'car_electrical_system', count =   1},
            {name = 'dune_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =    1},
            {name = 'car_bodywork', count =    15},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'hellion', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = {  
            {name = 'car_electrical_system', count =   1},
            {name = 'hellion_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =    20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'hotknife', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = { 
            {name = 'car_electrical_system', count =   1},
            {name = 'hotknife_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =    20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'issi3', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = {  
            {name = 'car_electrical_system', count =   1},
            {name = 'issi3_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =    20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'issi7', vehicleType = 'car', craft = true, time = 90000, anim = 'soldar', needs = {  
            {name = 'car_electrical_system', count =   1},
            {name = 'issi7_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =    1},
            {name = 'car_bodywork', count =   25},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'issi8', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = { 
            {name = 'car_electrical_system', count =   1},
            {name = 'issi8_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =    20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'stalion2', vehicleType = 'car', craft = true, time = 100000, anim = 'soldar', needs = {  
            {name = 'car_electrical_system', count =   1},
            {name = 'stalion2_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =    1},
            {name = 'car_bodywork', count =   30},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'trophytruck2', vehicleType = 'car', craft = true, time = 80000, anim = 'soldar', needs = {  
            {name = 'car_electrical_system', count =   1},
            {name = 'trophytruck2_print', count =   1},
            {name = 'car_inside', count =    1},
            {name = 'car_chassis', count =   1},
            {name = 'car_motor2', count =    1},
            {name = 'car_transmission', count =   1},
            {name = 'car_bodywork', count =    20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
    }},

   -- CRAFT OFICINAS LEGAIS

    ["craft_car_system"] = { pos = { vector3(-153.73, -1346.36, 29.96) }, jobs = {'none'}, items = {
        {name = 'car_electrical_system', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'battery', count =   1},
            {name = 'electronic_waste', count =   1},
            {name = 'btel', count =   1},
            {name = 'bradio', count =   1},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {name = 'car_inside', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'fabric', count =   5},
            {name = 'leather', count =   5},
        }},
        {name = 'car_chassis', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'steel', count =   10},
            {name = 'scrap', count =    5},
            {name = 'iron', count =     5},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {name = 'car_motor2', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'rubber', count =   20},
            {name = 'copper', count =   20},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {name = 'car_transmission', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'electronic_waste', count =   5},
            {name = 'copper', count =   10},
            {name = 'blowpipe', count =   1, consume = false},
             }},
        {name = 'car_bodywork', count = 1, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'steel', count =   5},
            {name = 'copper', count =   5},
            {name = 'blowpipe', count =   1, consume = false},
        }},
    }},


-- BARCOS

    ["craft_boat_system"] = { pos = { vector3(1607.08, 3792.74, 34.78) }, spawnPoint = vector3(1615.40, 3807.61, 34.91), jobs = {}, minCops = 0, items = {   
        {vehicle = 'seashark3', vehicleType = 'boat', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'seashark3_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    10},
            {name = 'blowpipe', count =   1, consume = false},
        }},
       {vehicle = 'squalo', vehicleType = 'boat', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'squalo_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    15},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'tropic', vehicleType = 'boat', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'tropic_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    40},
            {name = 'blowpipe', count =   1, consume = false},
        }},
         {vehicle = 'tropic2', vehicleType = 'boat', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'tropic2_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    40},
            {name = 'blowpipe', count =   1, consume = false},
        }},
       {vehicle = 'suntrap', vehicleType = 'boat', craft = true, time = 70000, anim = 'soldar', needs = {
            {name = 'suntrap_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    20},
            {name = 'blowpipe', count =   1, consume = false},
        }},  
        {vehicle = 'marquis', vehicleType = 'boat', craft = true, time = 100000, anim = 'soldar', needs = {  
            {name = 'marquis_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'fabric', count =   50},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    30},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'dinghy4', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'dinghy4_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    25},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'jetmax', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'jetmax_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    25},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'toro2', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'toro2_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    30},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'speeder2', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'speeder2_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    35},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'longfin', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'longfin_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    60},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'seasparrow', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'seasparrow_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    60},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'avisa', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'avisa_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    65},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'sr510', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'sr510_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    80},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'sr650fly', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'sr650fly_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    80},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'yacht2', vehicleType = 'boat', craft = true, time = 90000, anim = 'soldar', needs = { 
            {name = 'yacht2_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    80},
            {name = 'blowpipe', count =   1, consume = false},
        }},
        {vehicle = 'dodo', vehicleType = 'boat', craft = true, time = 80000, anim = 'soldar', needs = { 
            {name = 'dodo_print', count =   1},
            {name = 'boat_electrical_system', count =   1},
            {name = 'boat_rudder', count =    1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_transmission', count =    1},
            {name = 'boat_bodywork', count =    90},
            {name = 'blowpipe', count =   1, consume = false},
        }},
    }},

    ["craft_boat_systemtug"] = { pos = { vector3(1351.33, 3714.14, 32.41) }, spawnPoint = vector3(1275.71, 3855.50, 29.50), jobs = {}, minCops = 0, items = {   
        {vehicle = 'tug', vehicleType = 'boat', craft = true, time = 80000, anim = 'soldar', needs = { 
            {name = 'tug_print', count =   1},
            {name = 'boat_engine', count =   1},
            {name = 'boat_bodywork', count =    20},
            {name = 'scrap', count =    10},
            {name = 'blowpipe', count =   1, consume = false},
        }},
    }},





    ["craft_boats"] = { pos = { vector3(1620.68, 3794.32, 34.81) }, jobs = {'none'}, minCops = 0, items = {   
        { name = 'boat_electrical_system', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'copper_cable', count = 1, consume = true},
            {name = 'copper_coil', count = 1, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},

        { name = 'boat_rudder', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'steel', count = 20, consume = true},
            {name = 'iron', count = 20, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},

        { name = 'boat_engine', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'steel', count = 10, consume = true},
            {name = 'iron', count = 10, consume = true},
            {name = 'rubber', count = 20, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},

        { name = 'boat_transmission', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'steel', count = 10, consume = true},
            {name = 'iron', count = 10, consume = true},
            {name = 'copper', count = 10, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},

        { name = 'boat_bodywork', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'wood_plank_cherry', count = 5, consume = true},
            {name = 'wood_plank_ebony', count = 5, consume = true},
            {name = 'rubber', count = 20, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},
    }},


--HELIS

    ["craft_aircraft_system"] = { pos = { vector3(2397.82, 3095.91, 48.27) }, spawnPoint = vector3(2398.76, 3111.38, 48.15), jobs = {}, minCops = 0, items = {   
        {vehicle = 'havok', vehicleType = 'aircraft', craft = true, time = 80000, anim = 'soldar', needs = { 
            {name = 'havok_print', count =   1},
            {name = 'heli_electrical_system', count =   1},
            {name = 'heli_engine', count =    1},
            {name = 'heli_rotor_main', count =   1},
            {name = 'heli_transmission', count =    1},
            {name = 'heli_bodywork', count =   40},
            {name = 'blowpipe', count =   1, consume = false },
        }},
        {vehicle = 'seasparrow2', vehicleType = 'aircraft', craft = true, time = 80000, anim = 'soldar', needs = {     
            {name = 'seasparrow2_print', count =   1},                
            {name = 'heli_electrical_system', count =   1},
            {name = 'heli_engine', count =    1},
            {name = 'heli_rotor_main', count =   1},
            {name = 'heli_transmission', count =    1},
            {name = 'heli_bodywork', count =  50},
            {name = 'blowpipe', count =   1, consume = false },
        }},
       {vehicle = 'maverick', vehicleType = 'aircraft', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'maverick_print', count =   1},
            {name = 'heli_electrical_system', count =   1},
            {name = 'heli_engine', count =    1},
            {name = 'heli_rotor_main', count =   1},
            {name = 'heli_transmission', count =    1},
            {name = 'heli_bodywork', count =   60},
            {name = 'blowpipe', count =   1, consume = false },
        }},
        {vehicle = 'frogger2', vehicleType = 'aircraft', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'frogger2_print', count =   1},
            {name = 'heli_electrical_system', count =   1},
            {name = 'heli_engine', count =    1},
            {name = 'heli_rotor_main', count =   1},
            {name = 'heli_transmission', count =    1},
            {name = 'heli_bodywork', count =   65},
            {name = 'blowpipe', count =   1, consume = false },
        }},
         {vehicle = 'supervolito', vehicleType = 'aircraft', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'supervolito_print', count =   1},
            {name = 'heli_electrical_system', count =   1},
            {name = 'heli_engine', count =    1},
            {name = 'heli_rotor_main', count =   1},
            {name = 'heli_transmission', count =    1},
            {name = 'heli_bodywork', count =   70},
            {name = 'blowpipe', count =   1, consume = false },
        }},
        {vehicle = 'volatus', vehicleType = 'aircraft', craft = true, time = 80000, anim = 'soldar', needs = {
            {name = 'volatus_print', count =   1},
            {name = 'heli_electrical_system', count =   1},
            {name = 'heli_engine', count =    1},
            {name = 'heli_rotor_main', count =   1},
            {name = 'heli_transmission', count =    1},
            {name = 'heli_bodywork', count =   75},
            {name = 'blowpipe', count =   1, consume = false },
        }},  
        {vehicle = 'swift2', vehicleType = 'aircraft', craft = true, time = 80000, anim = 'soldar', needs = {  
            {name = 'swift2_print', count =   1},
            {name = 'heli_electrical_system', count =   1},
            {name = 'heli_engine', count =    1},
            {name = 'heli_rotor_main', count =   1},
            {name = 'heli_transmission', count =    1},
            {name = 'heli_bodywork', count =   80},
            {name = 'blowpipe', count =   1, consume = false },
        }},
    }},



    ["craft_helis"] = { pos = { vector3(2358.74, 3136.17, 48.21) }, jobs = {'none'}, minCops = 0, items = {   
        { name = 'heli_electrical_system', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'copper_cable', count = 1, consume = true},
            {name = 'copper_coil', count = 1, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},

        { name = 'heli_engine', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'steel', count = 20, consume = true},
            {name = 'iron', count = 20, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},

        { name = 'heli_rotor_main', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'steel', count = 10, consume = true},
            {name = 'iron', count = 10, consume = true},
            {name = 'rubber', count = 20, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},

        { name = 'heli_transmission', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'steel', count = 10, consume = true},
            {name = 'iron', count = 10, consume = true},
            {name = 'copper', count = 10, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},

        { name = 'heli_bodywork', count = 1, craft = true, time = 5000, anim = 'parquimetro', needs = { 
            {name = 'steel', count = 5, consume = true},
            {name = 'iron', count = 5, consume = true},
            {name = 'copper', count = 5, consume = true},
            {name = 'blowpipe', count =   1, consume = false},
        }},
    }},

    --[[["vendalendaria"] = { pos = { vector3(781.35, 1296.60, 361.36) }, jobs = {'none'}, items = {    -- venda lendaria
        {name = 'black_money', count = 15000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'redfox', count =   1},
            {name = 'old_coin1', count =   1},
        }},
         {name = 'black_money', count = 15000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'redfox', count =   1},
            {name = 'old_coin2', count =   1},  
        }},
         {name = 'black_money', count = 15000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'redfox', count =   1},
            {name = 'old_coin3', count =   1},  
        }},
        {name = 'black_money', count = 17000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'articfox', count =   1},
            {name = 'old_coin1', count =   1},
       }},
       {name = 'black_money', count = 17000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'articfox', count =   1},
            {name = 'old_coin2', count =   1},
       }},
       {name = 'black_money', count = 17000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'articfox', count =   1},
            {name = 'old_coin3', count =   1},
       }},
       {name = 'black_money', count = 18000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'whale', count =   1},
            {name = 'old_coin1', count =   1},
       }},
       {name = 'black_money', count = 18000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'whale', count =   1},
            {name = 'old_coin2', count =   1},
       }},
       {name = 'black_money', count = 18000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'whale', count =   1},
            {name = 'old_coin3', count =   1},
       }},
    }},]]   -- para reformular e meter animais mensais 


    ["venda_de_peles"] = { pos = { vector3(60.82, -1587.29, 29.60) }, jobs = {'none'}, items = {    -- Feito 
        {name = 'cash', count = 1000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'rabbit_skin', count =   1},
        }},
        {name = 'cash', count = 100000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'rabbit_skin', count =   100},
        }},
        {name = 'cash', count = 2000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'deer_skin', count =   1},
        }},
        {name = 'cash', count = 200000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'deer_skin', count =   100},
        }},
        {name = 'cash', count = 3000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'boar_skin', count =   1},
        }},
        {name = 'cash', count = 300000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'boar_skin', count =   100},
        }},
    }},

    ["venda_peixedollar"] = { pos = { vector3(66.63, -1592.27, 29.60) }, jobs = {'none'}, items = {    -- VENDA DE PEIXE
        {name = 'cash', count = 200, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'sardine', count =   1},
        }},
        {name = 'cash', count = 20000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'sardine', count =   100},
        }},
        {name = 'cash', count = 250, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'carp', count =   1},
        }},
        {name = 'cash', count = 25000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'carp', count =   100},
        }},
        {name = 'cash', count = 250, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'trout', count =   1},
        }},
         {name = 'cash', count = 25000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'trout', count =   100},
        }},
        {name = 'cash', count = 300, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'loss', count =   1},
        }},
        {name = 'cash', count = 30000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'loss', count =   100},
        }},
        {name = 'cash', count = 300, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'barbel', count =   1},
        }},
        {name = 'cash', count = 30000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'barbel', count =   100},
        }},
        {name = 'cash', count = 350, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'tench', count =   1},
        }},
        {name = 'cash', count = 35000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'tench', count =   100},
        }},
        {name = 'cash', count = 400, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'eel', count =   1},
        }},
        {name = 'cash', count = 40000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'eel', count =   100},
        }},
        {name = 'cash', count = 400, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'common_seahorse', count =   1},
        }},
        {name = 'cash', count = 40000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'common_seahorse', count =   100},
        }},
        {name = 'cash', count = 400, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'mackerel', count =   1},
        }},
        {name = 'cash', count = 40000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'mackerel', count =   100},
        }},
        {name = 'cash', count = 450, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'seabass', count =   1},
        }},
        {name = 'cash', count = 45000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'seabass', count =   100},
        }},
        {name = 'cash', count = 500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'boga', count =   1},
        }},
         {name = 'cash', count = 50000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'boga', count =   100},
        }},
        {name = 'cash', count = 500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'salmon', count =   1},
        }},
        {name = 'cash', count = 50000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'salmon', count =   100},
        }},
        {name = 'cash', count = 550, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'gilt_head_bream', count =   1},
        }},
        {name = 'cash', count = 55000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'gilt_head_bream', count =   100},
        }},
        {name = 'cash', count = 550, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'tuna', count =   1},
        }},
        {name = 'cash', count = 55000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'tuna', count =   100},
        }},
        {name = 'cash', count = 600, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'lucio', count =   1},
        }},
        {name = 'cash', count = 60000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'lucio', count =   100},
        }},
    }},

    ["venda_de_recursos"] = { pos = { vector3(64.06, -1590.01, 29.60) }, jobs = {'none'}, items = {    -- Feito 
        {name = 'cash', count = 400, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'steel', count =   1},
        }},
        {name = 'cash', count = 40000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'steel', count =   100},
        }},
        {name = 'cash', count = 40, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'gunpowder', count =   1},
        }},
        {name = 'money', count = 4000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'gunpowder', count =   100},
        }},
        {name = 'cash', count = 15, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'recicled_plastic', count =   1},
        }},
        {name = 'cash', count = 1500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'recicled_plastic', count =   100},
        }},
        {name = 'cash', count = 10, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'bradio', count =   1},
        }},
        {name = 'cash', count = 1000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'bradio', count =   100},
        }},
        {name = 'cash', count = 10, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'btel', count =   1},
        }},
        {name = 'cash', count = 1000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'btel', count =   100},
        }},
        {name = 'cash', count = 25, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'electronic_waste', count =   1},
        }},
        {name = 'cash', count = 2500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'electronic_waste', count =   100},
        }},
        {name = 'cash', count = 15, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'scrap', count =   1},
        }},
        {name = 'cash', count = 1500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'scrap', count =   100},
        }},
        {name = 'cash', count = 30, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'iron', count =   1},
        }},
        {name = 'cash', count = 3000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'iron', count =   100},
        }},
        {name = 'cash', count = 30, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'copper', count =   1},
        }},
        {name = 'cash', count = 3000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'copper', count =   100},
        }},
        {name = 'cash', count = 15, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'coal', count =   1},
        }},
        {name = 'cash', count = 1500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'coal', count =   100},
        }},
        {name = 'cash', count = 15, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_dust', count =   1},
        }},
        {name = 'cash', count = 1500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_dust', count =   100},
        }},
        {name = 'cash', count = 15, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_plank_pine', count =   1},
        }},
        {name = 'cash', count = 1500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_plank_pine', count =   100},
        }},
        {name = 'cash', count = 20, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_plank_oak', count =   1},
        }},
        {name = 'cash', count = 2000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_plank_oak', count =   100},
        }},
        {name = 'cash', count = 25, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_plank_cherry', count =   1},
        }},
        {name = 'cash', count = 2500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_plank_cherry', count =   100},
        }},
        {name = 'cash', count = 80, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_plank_ebony', count =   1},
        }},
        {name = 'cash', count = 8000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'wood_plank_ebony', count =   100},
        }},
        {name = 'cash', count = 300, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'kevlar', count =   1},
        }},
        {name = 'cash', count = 30000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'kevlar', count =   100},
        }},
        {name = 'cash', count = 40, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'paper', count =   1},
        }},
        {name = 'cash', count = 4000, craft = true, time = 100, anim = 'parquimetro', needs = {     
            {name = 'paper', count =   100},
        }},
        {name = 'cash', count = 500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'leather', count =   1},
        }},
        {name = 'cash', count = 50000, craft = true, time = 100, anim = 'parquimetro', needs = {     
            {name = 'leather', count =   100},
        }},
    }},



                                                                            --|||||||||||||||||||||||||||||||||||||||||||||||||||||||||| CAÇA |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
                                                                          
  

    ["craft_couro"] = { pos = { vector3(711.37, -969.54, 30.40) }, jobs = {'none'}, items = {    -- feito 
        {name = 'leather', count = 1, craft = true, time = 1500, anim = 'mecanico', needs = {   
            {name = 'rabbit_skin', count =   1},
            {name = 'tannins',   count =   1},
        }},
        {name = 'leather', count = 3, craft = true, time = 2000, anim = 'mecanico', needs = {   
            {name = 'deer_skin', count =   1},
            {name = 'tannins',   count =   2},
        }},
        {name = 'leather', count = 5, craft = true, time = 2500, anim = 'mecanico', needs = {   
            {name = 'boar_skin', count =   1},
            {name = 'tannins',   count =   2},
        }},
    }},


    ["craft_couro_ilegal"] = { pos = { vector3(-5065.84, 8529.80, 58.78) }, jobs = {'none'}, items = {    -- feito
        {name = 'leather', count = 6, craft = true, time = 3000, anim = 'mecanico', needs = {    
            {name = 'coyote_skin', count =   1},
            {name = 'tannins',     count =   2},
        }},
        {name = 'leather', count = 7, craft = true, time = 3500, anim = 'mecanico', needs = {   
            {name = 'lioness_skin', count =   1},
            {name = 'tannins',     count =   2},
        }},
        {name = 'leather', count = 7, craft = true, time = 3500, anim = 'mecanico', needs = {   
            {name = 'lioness_skin_lowquality', count =   4},
            {name = 'tannins',     count =   2},
        }},
        {name = 'leather', count = 7, craft = true, time = 3500, anim = 'mecanico', needs = {   
            {name = 'tiger_skin', count =   1},
            {name = 'tannins',     count =   2},
        }},
        {name = 'leather', count = 7, craft = true, time = 3500, anim = 'mecanico', needs = {   
            {name = 'tiger_skin_lowquality', count =   4},
            {name = 'tannins',     count =   2},
        }},
        {name = 'leather', count = 8, craft = true, time = 4000, anim = 'mecanico', needs = {   
            {name = 'penguin_skin',  count =   1},
            {name = 'tannins',       count =   5},
        }},
        {name = 'leather', count = 8, craft = true, time = 4000, anim = 'mecanico', needs = {   
            {name = 'penguin_skin_lowquality',  count =   3},
            {name = 'tannins',       count =   5},
        }},
        {name = 'leather', count = 10, craft = true, time = 4500, anim = 'mecanico', needs = {   
            {name = 'antelope_skin', count =   1},
            {name = 'tannins',       count =   5},
        }},
        {name = 'leather', count = 10, craft = true, time = 4500, anim = 'mecanico', needs = {   
            {name = 'antelope_skin_lowquality', count =   4},
            {name = 'tannins',       count =   5},
        }},
        {name = 'leather', count = 15, craft = true, time = 5000, anim = 'mecanico', needs = {   
            {name = 'bear_skin', count =   1},
            {name = 'tannins',       count =   7},
        }},
        {name = 'leather', count = 15, craft = true, time = 5000, anim = 'mecanico', needs = {   
            {name = 'bear_skin_lowquality', count =   4},
            {name = 'tannins',       count =   7},  -- criar pele e items par redfox 
        }},
    }},

        ["venda_ilegalcaca"] = { pos = { vector3(1175.67, 2720.64, 38.17) }, jobs = {'none'}, items = {    -- feito
        {name = 'black_money', count = 5000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'deer_head', count =   1},
        }},
        {name = 'black_money', count = 5500, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'coyote_head', count =   1},
        }},
        {name = 'black_money', count = 6000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'lioness_head', count =   1},
        }},
        {name = 'black_money', count = 6500, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'tiger_head', count =   1},
        }},
        {name = 'black_money', count = 9000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'bear_head', count =   1},
        }},
        {name = 'black_money', count = 8000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'boar_tooth', count =   1},
        }},
        {name = 'black_money', count = 8500, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'tiger_tooth', count =   1},
        }},
        {name = 'black_money', count = 8500, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'lioness_paw', count =   1},
        }},
        {name = 'black_money', count = 12000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'bear_paw', count =   1},
        }},
        {name = 'black_money', count = 12000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'antelope_horns', count =   1},
        }},
        {name = 'black_money', count = 12000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'penguin_beak', count =   1},
        }},
    }},


    ["venda_ilegal_caca"] = { pos = { vector3(28.98, 7837.52, 6.40) }, jobs = {'none'}, items = {    -- FEITO
        {name = 'cash', count = 2000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'lioness_skin_lowquality', count =   1},
        }},
        {name = 'cash', count = 2000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'tiger_skin_lowquality', count =   1},
        }},
        {name = 'cash', count = 3000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'penguin_skin_lowquality', count =   1},
        }},
        {name = 'cash', count = 3500, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'antelope_skin_lowquality', count =   1},
        }},
        {name = 'cash', count = 5000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'bear_skin_lowquality', count =   1},
        }},
        {name = 'cash', count = 5000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'coyote_skin', count =   1},
        }},
        {name = 'cash', count = 6000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'lioness_skin', count =   1},
        }},
        {name = 'cash', count = 6500, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'tiger_skin', count =   1},
        }},
        {name = 'cash', count = 15000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'bear_skin', count =   1},
        }},
        {name = 'cash', count = 10000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'penguin_skin', count =   1},
        }},
        {name = 'cash', count = 10000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'antelope_skin', count =   1},
        }},
    }},


    ["craft_taninos"] = { pos = { vector3(-513.86, 5331.83, 80.26) }, jobs = {'none'}, items = {  
        {name = 'tannins', count = 3, craft = true, time = 2000, anim = 'mecanico', needs = {   
            {name = 'wood_plank_pine', count =   1},
        }},
         {name = 'tannins', count = 5, craft = true, time = 2000, anim = 'mecanico', needs = {   
            {name = 'wood_plank_oak', count =   1},
        }},
          {name = 'tannins', count = 7, craft = true, time = 2000, anim = 'mecanico', needs = {   
            {name = 'wood_plank_cherry', count =   1},
        }},
          {name = 'tannins', count = 9, craft = true, time = 2000, anim = 'mecanico', needs = {   
            {name = 'wood_plank_ebony', count =   1},
        }},

    }},


    ["embalamento"] = { pos = { vector3(985.73, -2122.09, 30.48) }, jobs = {'none'}, items = { 
        {name = 'rabbit_meat_packaged', count = 3, craft = true, time = 3000, anim = 'mecanico', needs = {  
            {name = 'rabbit_meat', count =   1},
            {name = 'packaging', count =   3},
        }},
        {name = 'deer_meat_packaged', count = 3, craft = true, time = 3000, anim = 'mecanico', needs = {
            {name = 'deer_meat', count =   1},
            {name = 'packaging', count =   3},
        }},
        {name = 'boar_meat_packaged', count = 3, craft = true, time = 3000, anim = 'mecanico', needs = {
            {name = 'boar_meat', count =   1},
            {name = 'packaging', count =   3},
        }},
    }},


     ["craft_embalagem"] = { pos = { vector3(949.52, -2123.79, 31.44) }, jobs = {'none'}, items = { 
        {name = 'packaging', count = 5, craft = true, time = 3000, anim = 'mecanico', needs = {
            {name = 'recicled_plastic', count =   1},
        }},
    }},

-----------||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

                                               -----------------------------PESCA-----------------------------------------
    
                                               
    ["venda_pesca"] = { pos = { vector3(1175.67, 2720.64, 38.17) }, jobs = {'none'}, items = {  
        {name = 'black_money', count = 12000, craft = true, time = 3000, anim = 'parquimetro', needs = {   
            {name = 'penguin_beak', count =   1},
        }},
    }},

    ["venda_peixeilha"] = { pos = { vector3(-2165.50, 5196.34, 16.88) }, jobs = {'none'}, items = {    -- VENDA DE PEIXE + 100 E venda Ilegal 
        {name = 'cash', count = 1000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'baby_turtle', count =   1},
        }},
        {name = 'cash', count = 1200, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'turtle', count =   1},
        }},
        {name = 'cash', count = 2500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'rare_turtle', count =   1},
        }},
        {name = 'cash', count = 5000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'legendary_turtle', count =   1},
        }},
        {name = 'cash', count = 2000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'sea_lion', count =   1},
        }},
        {name = 'cash', count = 2000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'raja', count =   1},
        }},
        {name = 'cash', count = 4500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'dolphin', count =   1},
        }},
        {name = 'cash', count = 6000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'blue_shark', count =   1},
        }},
        {name = 'cash', count = 6000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'hammerhead_shark', count =   1},
        }},
        {name = 'cash', count = 15000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'white_shark', count =   1},
        }},
        {name = 'cash', count = 16000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'whale', count =   1},
        }},
        {name = 'cash', count = 300, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'sardine', count =   1},
        }},
        {name = 'cash', count = 30000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'sardine', count =   100},
        }},
        {name = 'cash', count = 350, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'carp', count =   1},
        }},
        {name = 'cash', count = 35000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'carp', count =   100},
        }},
        {name = 'cash', count = 350, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'trout', count =   1},
        }},
         {name = 'cash', count = 35000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'trout', count =   100},
        }},
        {name = 'cash', count = 400, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'loss', count =   1},
        }},
        {name = 'cash', count = 40000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'loss', count =   100},
        }},
        {name = 'cash', count = 400, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'barbel', count =   1},
        }},
        {name = 'cash', count = 40000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'barbel', count =   100},
        }},
        {name = 'cash', count = 450, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'tench', count =   1},
        }},
        {name = 'cash', count = 45000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'tench', count =   100},
        }},
        {name = 'cash', count = 500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'eel', count =   1},
        }},
        {name = 'cash', count = 50000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'eel', count =   100},
        }},
        {name = 'cash', count = 500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'common_seahorse', count =   1},
        }},
        {name = 'cash', count = 50000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'common_seahorse', count =   100},
        }},
        {name = 'cash', count = 500, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'mackerel', count =   1},
        }},
        {name = 'cash', count = 50000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'mackerel', count =   100},
        }},
        {name = 'cash', count = 550, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'seabass', count =   1},
        }},
        {name = 'cash', count = 55000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'seabass', count =   100},
        }},
        {name = 'cash', count = 600, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'boga', count =   1},
        }},
         {name = 'cash', count = 60000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'boga', count =   100},
        }},
        {name = 'cash', count = 600, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'salmon', count =   1},
        }},
        {name = 'cash', count = 60000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'salmon', count =   100},
        }},
        {name = 'cash', count = 650, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'gilt_head_bream', count =   1},
        }},
        {name = 'cash', count = 65000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'gilt_head_bream', count =   100},
        }},
        {name = 'cash', count = 650, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'tuna', count =   1},
        }},
        {name = 'cash', count = 65000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'tuna', count =   100},
        }},
        {name = 'cash', count = 700, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'lucio', count =   1},
        }},
        {name = 'cash', count = 70000, craft = true, time = 100, anim = 'parquimetro', needs = {   
            {name = 'lucio', count =   100},
        }},
    }},

    -- CRAFT SUCATA DO MAR
    ["craft_recursosdomar"] = { pos = { vector3(-564.90, 6844.00, 26.23) }, jobs = {'none'}, items = { 
        {name = 'scrap', count = 2, craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'rusty_scrap', count =   1},
        }},
        {name = 'recicled_plastic', count = 2, craft = true, time = 2000, anim = 'mecanico', needs = {
            {name = 'sea_plastic', count =   1},
        }},
    }},

    ["craft_pescamoeadas"] = { pos = { vector3(-5358.37, 8470.60, 63.25) }, jobs = {'none'}, items = {    -- craft de armas da pesca
        {name = 'WEAPON_SNSPISTOL', count = 1, craft = true, time = 5000, anim = 'mecanico', needs = {
            {name = 'brokensns', count =   1},
            {name = 'old_coin1', count =   50},
        }},
         {name = 'WEAPON_SNSPISTOL', count = 1, craft = true, time = 5000, anim = 'mecanico', needs = {
            {name = 'brokensns', count =   1},
            {name = 'old_coin2', count =   50},
        }},
         {name = 'WEAPON_SNSPISTOL', count = 1, craft = true, time = 5000, anim = 'mecanico', needs = {
            {name = 'brokensns', count =   1},
            {name = 'old_coin3', count =   50},
        }},
        {name = 'WEAPON_VINTAGEPISTOL', count = 1, craft = true, time = 5000, anim = 'mecanico', needs = {
            {name = 'brokenvintage', count =   1},
            {name = 'old_coin1', count =   50},
        }},
        {name = 'WEAPON_VINTAGEPISTOL', count = 1, craft = true, time = 5000, anim = 'mecanico', needs = {
            {name = 'brokenvintage', count =   1},
            {name = 'old_coin2', count =   50},
        }},
        {name = 'WEAPON_VINTAGEPISTOL', count = 1, craft = true, time = 5000, anim = 'mecanico', needs = {
            {name = 'brokenvintage', count =   1},
            {name = 'old_coin3', count =   50},
        }},
        {name = 'WEAPON_MARKSMANPISTOL', count = 1, craft = true, time = 5000, anim = 'mecanico', needs = {
            {name = 'old_coin1', count =   20},
            {name = 'old_coin2', count =   20},
            {name = 'old_coin3', count =   20},
        }},
    }},

     ["craft_soldarmoedas"] = { pos = { vector3(1364.09, -2101.93, 52.00) }, jobs = {'none'}, items = { 
        {name = 'gold_ingot', count = 2, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'old_coin1', count =   5},
        }},
        {name = 'gold_ingot', count = 2, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'old_coin2', count =   5},
        }},
        {name = 'gold_ingot', count = 2, craft = true, time = 5000, anim = 'soldar', needs = {
            {name = 'old_coin3', count =   5},
        }},
    }},

                            

    -- CRAFT PAPEL
    ["craft_papel"] = { pos = { vector3(-581.18, 5337.28, 70.21) }, jobs = {'none'}, items = { 
        {name = 'paper', craft = true, time = 2500, anim = 'mecanico', needs = {
            {name = 'wood_plank_cherry', count =   1},
        }},
    }},

    -- CRAFT BLUEPRINT COMUNIDADES
    ["craft_blueprints_motoclubs"] = { pos = { 
        vector3(3475.06, 3695.55, 33.72), --hUMAN
    }, jobs = {}, enableInfluence = true, influenceVariation = 3, minCops = 0, items = {
        {name = 'weapon_body2', craft = true, time = 10000, influenceTime = 8000, anim = 'mecanico', needs = {
            {name = 'black_money',   count =   5000, influenceCount = 4500},
            {name = 'paper',         count =      1},
        }},
        {name = 'weapon_body', craft = true, time = 12000, influenceTime = 10000, anim = 'mecanico', needs = {
            {name = 'black_money',   count =  25000, influenceCount = 22500},
            {name = 'paper',         count =      1},
        }},
        {name = 'weapon_body3', craft = true, time = 15000, influenceTime = 12000, anim = 'mecanico', needs = {
            {name = 'black_money',   count =  40000, influenceCount = 35000},
            {name = 'paper',         count =      1},
        }},
        {name = 'weapon_body4', craft = true, time = 20000, influenceTime = 15000, anim = 'mecanico', needs = {
            {name = 'black_money',   count =  60000, influenceCount = 50000},
            {name = 'paper',         count =      1},
        }},
    }},


    -- SISTEMA DE CRAFT DE SUCATA
    ["craft_sucata"] = { pos = { vector3(-1703.50, 6547.06, 16.94) }, jobs = {'none'}, items = {
        {name = 'scrap', craft = true, time = 500, anim = 'mecanico', needs = {
            {name = 'iron', count = 1},
            {name = 'btel', count = 2},
        }},
        {name = 'scrap', craft = true, time = 500, anim = 'mecanico', needs = {
            {name = 'bradio', count = 2},
            {name = 'iron', count = 1},
        }},
    }},


    -- CRAFT ARMAS FAVELAS  CP229
    ["craft_armas_favelas"] = { pos = { vector3(852.90, -958.52, 26.28) }, jobs = {}, enableInfluence = true, influenceVariation = 5, minCops = 0, items = {
        {name = 'WEAPON_COMPACTRIFLE', craft = true, time = 25000, influenceTime = 20000, anim = 'soldar', needOrgXp = true, typer = 'favelaarmas', level = 1, increment = 5, needs = {   
            {name = 'steel',              count =  5},
            {name = 'wood_plank_ebony',   count = 10},
            {name = 'weapon_part',        count = 20, influenceCount = 18},
            {name = 'weapon_body',        count =  1},
        }},
        {name = 'WEAPON_COMPACTRIFLE', craft = true, time = 25000, influenceTime = 20000, anim = 'soldar', needOrgXp = true, typer = 'favelaarmas', level = 2, increment = 5, needs = {   
            {name = 'steel',              count =  5},  
            {name = 'wood_plank_ebony',   count =  5}, 
            {name = 'weapon_part',        count = 20, influenceCount = 18},
            {name = 'weapon_body',        count =  1},
        }},
        {name = 'WEAPON_ASSAULTRIFLE', craft = true, time = 25000, influenceTime = 20000, anim = 'soldar', needOrgXp = true, typer = 'favelaarmas', level = 3, increment = 5, needs = {
            {name = 'steel',               count =  5},  
            {name = 'wood_plank_ebony',    count = 10}, 
            {name = 'weapon_part',         count = 30, influenceCount = 25}, 
            {name = 'weapon_body3',        count =  1},
        }},
        {name = 'WEAPON_ASSAULTRIFLE', craft = true, time = 25000, influenceTime = 20000, anim = 'soldar', needOrgXp = true, typer = 'favelaarmas', level = 4, increment = 0, needs = {
            {name = 'steel',               count =  5},  
            {name = 'wood_plank_ebony',    count =  5}, 
            {name = 'weapon_part',         count = 30, influenceCount = 25},
            {name = 'weapon_body3',        count =  1},
        }},

    }},
}


Citizen.CreateThread(function()
    for job, station in pairs(Config.Stations) do
        if station.AuthorizedCrafts then
            for _, craft in ipairs(station.AuthorizedCrafts) do
                if ESX.craftItems[craft] == nil then
                    print(('^1crafting: the craft station "%s" for job "%s" is trying to register a non existent craft station!'):format(craft, job))
                else
                    table.insert(ESX.craftItems[craft].jobs, job)
                end
            end
        end
    end
end)


if IsDuplicityVersion() then -- Server
    return
end

function PlayCraftAnim(item)
    if item.anim == 'mecanico' then -- bar5 
        RequestAnimDict("mini@repair")
        while not HasAnimDictLoaded("mini@repair") do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 1, 0, false, false, false)
    end

    if item.anim == 'soldar' then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, false)
    end

    if item.anim == 'impaciente' then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_IMPATIENT", 0, false)
    end

    if item.anim == 'parquimetro' then
        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 0, false)
    end
end

