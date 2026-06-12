ESX.Items = {
    -- Misc

    ["ice"] =           {label = T("ITEMS_ICE"),             type = "item", limit = 80,  canRemove = true},
	["ice_bag"] =       {label = T("ITEMS_ICE_BAG"),         type = "item", limit = 4,   canRemove = true, box = {item = "ice", count = 80}},
    ["colis"] =         {label = T("ITEMS_COLIS"),           type = "item", limit = 60,  canRemove = true},
	["letter"] =        {label = T("ITEMS_LETTER"),          type = "item", limit = 100, canRemove = true},
    ["bag"] =           {label = T("ITEMS_BAG"),             type = "item", limit = 100, canRemove = true},
	["jar"] =           {label = T("ITEMS_JAR"),             type = "item", limit = 100, canRemove = true},
	["weapon_part"] =   {label = T("ITEMS_WEAPON_PART"),     type = "item", limit = 100, canRemove = true},
    ["misscrocodile"] = {label = T("ITEMS_MISSCROCODILE"),   type = "item", limit = -1,  canRemove = true},
    ["document"] =      {label = T("ITEMS_DOCUMENT"),        type = "item", limit = -1,  canRemove = true},

    -- Protective Gear

    ["armor"] =             {label = T("ITEMS_ARMOR"),              type = "item", limit = 10, canRemove = true},
    ["armor2"] =            {label = T("ITEMS_ARMOR2"),             type = "item", limit = 10, canRemove = true},
    ["armor3"] =            {label = T("ITEMS_ARMOR3"),             type = "item", limit = 10, canRemove = true},
    ["synthetic_armor"] =   {label = T("ITEMS_SYNTHETIC_ARMOR"),    type = "item", limit = 10, canRemove = true},
    ["mask"] =              {label = T("ITEMS_MASK"),               type = "item", limit = 10, canRemove = true},




	["trophy12025"] =              {label = T("ITEMS_TROPHY12025"),               type = "item", limit = 1, canRemove = true},
	["trophy22025"] =              {label = T("ITEMS_TROPHY22025"),               type = "item", limit = 1, canRemove = true},
	["trophy32025"] =              {label = T("ITEMS_TROPHY32025"),               type = "item", limit = 1, canRemove = true},
	["trophy42025"] =              {label = T("ITEMS_TROPHY42025"),               type = "item", limit = 1, canRemove = true},
	["trophy52025"] =              {label = T("ITEMS_TROPHY52025"),               type = "item", limit = 1, canRemove = true},

    -- Materials

    ["cotton"] =    {label = T("ITEMS_COTTON"),     type = "item", limit = 100, canRemove = true},
    ["rubber"] =    {label = T("ITEMS_RUBBER"),     type = "item", limit = 100, canRemove = true},
    ["kevlar"] =    {label = T("ITEMS_KEVLAR"),     type = "item", limit = 100, canRemove = true},
	["leather"] =   {label = T("ITEMS_LEATHER"),    type = "item", limit = 100,  canRemove = true},
	["fabric"] =    {label = T("ITEMS_FABRIC"),     type = "item", limit = 100, canRemove = true},
	["chalk"] =     {label = T("ITEMS_CHALK"),      type = "item", limit = -1,  canRemove = true},
	["paper"] =     {label = T("ITEMS_PAPER"),      type = "item", limit = 100, canRemove = true},

	-- CAÇA 


	["deerbait"]        = {label = T("ITEMS_DEERBAIT"),        type = "item", limit = 100,  canRemove = true},
	["boarbait"]        = {label = T("ITEMS_BOARBAIT"),        type = "item", limit = 100,  canRemove = true},
	["rabbitbait"]      = {label = T("ITEMS_RABBITBAIT"),      type = "item", limit = 100,  canRemove = true},
	["penguinbait"]     = {label = T("ITEMS_PENGUINBAIT"),     type = "item", limit = 100,  canRemove = true},
	["antelopebait"]    = {label = T("ITEMS_ANTELOPEBAIT"),    type = "item", limit = 100,  canRemove = true},

	["deer_skin"]       = {label = T("ITEMS_DEER_SKIN"),       type = "item", limit = 100,  canRemove = true},
	["deer_meat"]       = {label = T("ITEMS_DEER_MEAT"),       type = "item", limit = 100,  canRemove = true},
	["deer_carcass"]    = {label = T("ITEMS_DEER_CARCASS"),    type = "item", limit =  10,  canRemove = true},
	["deer_head"]       = {label = T("ITEMS_DEER_HEAD"),       type = "item", limit =  10,  canRemove = true},

	["boar_skin"]       = {label = T("ITEMS_BOAR_SKIN"),       type = "item", limit = 100,  canRemove = true},
	["boar_meat"]       = {label = T("ITEMS_BOAR_MEAT"),       type = "item", limit = 100,  canRemove = true},
	["boar_carcass"]    = {label = T("ITEMS_BOAR_CARCASS"),    type = "item", limit =  10,  canRemove = true},
	["boar_tooth"]      = {label = T("ITEMS_BOAR_TOOTH"),      type = "item", limit =  10,  canRemove = true},
	["boar_head"]       = {label = T("ITEMS_BOAR_HEAD"),       type = "item", limit =  10,  canRemove = true},

	["rabbit_skin"]     = {label = T("ITEMS_RABBIT_SKIN"),     type = "item", limit = 100,  canRemove = true},
	["rabbit_meat"]     = {label = T("ITEMS_RABBIT_MEAT"),     type = "item", limit = 100,  canRemove = true},
	["rabbit_carcass"]  = {label = T("ITEMS_RABBIT_CARCASS"),  type = "item", limit =  10,  canRemove = true},

	["coyote_skin"]     = {label = T("ITEMS_COYOTE_SKIN"),     type = "item", limit = 100,  canRemove = true},
	["coyote_head"]     = {label = T("ITEMS_COYOTE_HEAD"),     type = "item", limit =  10,  canRemove = true},
	["coyote_carcass"]  = {label = T("ITEMS_COYOTE_CARCASS"),  type = "item", limit =  10,  canRemove = true},

	["lioness_skin"]    = {label = T("ITEMS_LIONESS_SKIN"),    type = "item", limit =  10,  canRemove = true},
	["lioness_skin_lowquality"]    = {label = T("ITEMS_LIONESS_SKIN_LOWQUALITY"),    type = "item", limit =  10,  canRemove = true},
	["lioness_paw"]     = {label = T("ITEMS_LIONESS_PAW"),     type = "item", limit =  10,  canRemove = true},
	["lioness_head"]    = {label = T("ITEMS_LIONESS_HEAD"),    type = "item", limit =  10,  canRemove = true},

	["tiger_skin"]      = {label = T("ITEMS_TIGER_SKIN"),      type = "item", limit =  10,  canRemove = true},
	["tiger_skin_lowquality"]      = {label = T("ITEMS_TIGER_SKIN_LOWQUALITY"),      type = "item", limit =  10,  canRemove = true},
	["tiger_tooth"]     = {label = T("ITEMS_TIGER_TOOTH"),     type = "item", limit =  10,  canRemove = true},
	["tiger_head"]      = {label = T("ITEMS_TIGER_HEAD"),      type = "item", limit =  10,  canRemove = true},

	["penguin_skin"]    = {label = T("ITEMS_PENGUIN_SKIN"),    type = "item", limit =  10,  canRemove = true},
	["penguin_skin_lowquality"]    = {label = T("ITEMS_PENGUIN_SKIN_LOWQUALITY"),    type = "item", limit =  10,  canRemove = true},
	["penguin_beak"]    = {label = T("ITEMS_PENGUIN_BEAK"),    type = "item", limit =  10,  canRemove = true},

	["antelope_skin"]   = {label = T("ITEMS_ANTELOPE_SKIN"),   type = "item", limit =  10,  canRemove = true},
	["antelope_skin_lowquality"]   = {label = T("ITEMS_ANTELOPE_SKIN_LOWQUALITY"),   type = "item", limit =  10,  canRemove = true},
	["antelope_horns"]  = {label = T("ITEMS_ANTELOPE_HORNS"),  type = "item", limit =  10,  canRemove = true},

	["bear_skin"]   = {label = T("ITEMS_BEAR_SKIN"),   type = "item", limit =  10,  canRemove = true},
	["bear_skin_lowquality"]   = {label = T("ITEMS_BEAR_SKIN_LOWQUALITY"),   type = "item", limit =  10,  canRemove = true},
	["bear_head"]  = {label = T("ITEMS_BEAR_HEAD"),  type = "item", limit =  10,  canRemove = true},
	["bear_paw"]  = {label = T("ITEMS_BEAR_PAW"),  type = "item", limit =  10,  canRemove = true},

	["packaging"]       = {label = T("ITEMS_PACKAGING"),       type = "item", limit =  100,  canRemove = true},

	["deer_meat_packaged"]       = {label = T("ITEMS_DEER_MEAT_PACKAGED"),       type = "item", limit =  100,  canRemove = true},
	["boar_meat_packaged"]       = {label = T("ITEMS_BOAR_MEAT_PACKAGED"),       type = "item", limit =  100,  canRemove = true},
	["rabbit_meat_packaged"]     = {label = T("ITEMS_RABBIT_MEAT_PACKAGED"),     type = "item", limit =  100,  canRemove = true},

	["tannins"]     = {label = T("ITEMS_TANNINS"),     type = "item", limit =  100,  canRemove = true},


    -- Smoking

    ['blunt'] =          {label = T("ITEMS_BLUNT"),              limit = 500, canRemove = true},
	['blunt_weed'] =     {label = T("ITEMS_BLUNT_WEED"),         limit = 500, canRemove = true},
	['blunt_hashish'] =  {label = T("ITEMS_BLUNT_HASHISH"),      limit = 500, canRemove = true},
    ['cigar'] =          {label = T("ITEMS_CIGAR"),              limit = 6,   canRemove = true},
	['cigarett'] =       {label = T("ITEMS_CIGARETT"),           limit = 20,  canRemove = true},
    ['rolling_paper'] =  {label = T("ITEMS_ROLLING_PAPER"),      limit = 10,  canRemove = true},
	['cigarette_pack'] = {label = T("ITEMS_CIGARETTE_PACK"),     limit = 5,   canRemove = true, box = {item = 'cigarett', count = 20}},
    ['lighter'] =        {label = T("ITEMS_LIGHTER"),            limit = 5,   canRemove = true},

    -- Chemicals

    ["acetone"] =           {label = T("ITEMS_ACETONE"),            type = "item", limit = 10,  canRemove = true, box = {item = "acetone_bottle", count = 10}},
	["acetone_bottle"] =    {label = T("ITEMS_ACETONE_BOTTLE"),     type = "item", limit = 100, canRemove = true},
    ["fertilizer"] =        {label = T("ITEMS_FERTILIZER"),         type = "item", limit = 100, canRemove = true},
    ["gunpowder"] =         {label = T("ITEMS_GUNPOWDER"),          type = "item", limit = 100, canRemove = true},
    ["latex"] =             {label = T("ITEMS_LATEX"),              type = "item", limit = 100, canRemove = true},
    ["knitrate"] =          {label = T("ITEMS_KNITRATE"),           type = "item", limit = 100, canRemove = true},
    ["sodiumbicarbonate"] = {label = T("ITEMS_SODIUMBICARBONATE"),  type = "item", limit = 100, canRemove = true},
    ["sulfur"] =            {label = T("ITEMS_SULFUR"),             type = "item", limit = 100, canRemove = true},
	["sulfuricacid"] =      {label = T("ITEMS_SULFURICACID"),       type = "item", limit = 100, canRemove = true},
    ["synthetic_leather"] = {label = T("ITEMS_SYNTHETIC_LEATHER"),  type = "item", limit = 100, canRemove = true},

    -- Jewelry

    ["dia_box"] =       {label = T("ITEMS_DIA_BOX"),        type = "item", limit = 50,  canRemove = true},
    ["goldNecklace"] =  {label = T("ITEMS_GOLDNECKLACE"),   type = "item", limit = -1,  canRemove = true},
    ["jewels"] =        {label = T("ITEMS_JEWELS"),         type = "item", limit = 100, canRemove = true},
    ["ring"] =          {label = T("ITEMS_RING"),           type = "item", limit = -1,  canRemove = true},
	["rolex"] =         {label = T("ITEMS_ROLEX"),          type = "item", limit = -1,  canRemove = true},
	["coinenigma"] =    {label = T("ITEMS_COINENIGMA"),     type = "item", limit = -1,  canRemove = true},

    -- Trash

	["old_plastic"] =        {label = T("ITEMS_OLD_PLASTIC"),        type = "item", limit = 100, canRemove = true},
    ["recicled_plastic"] =   {label = T("ITEMS_RECICLED_PLASTIC"),   type = "item", limit = 100, canRemove = true},
    ["scrap"] =              {label = T("ITEMS_SCRAP"),              type = "item", limit = 100, canRemove = true},
    ["electronic_waste"] =   {label = T("ITEMS_ELECTRONIC_WASTE"),   type = "item", limit = 100, canRemove = true},
    ["bradio"] =             {label = T("ITEMS_BRADIO"),             type = "item", limit = 100, canRemove = true},
	["broken_weapon_part"] = {label = T("ITEMS_BROKEN_WEAPON_PART"), type = "item", limit = 100, canRemove = true},
	["btel"] =               {label = T("ITEMS_BTEL"),               type = "item", limit = 100, canRemove = true},
	["componenteseletronicos"] =               {label = T("ITEMS_COMPONENTESELETRONICOS"),               type = "item", limit = 100, canRemove = true},

    -- Food

	["brownie"] =       {label = T("ITEMS_BROWNIE"),    type = "item", limit = 5,  canRemove = true, box = {item = "brownie_slice", count = 12}},
    ["donut_box"] =     {label = T("ITEMS_DONUT_BOX"),  type = "item", limit = 2,  canRemove = true, box = {item = "donut",         count = 6}},
    ["pizza"] =         {label = T("ITEMS_PIZZA"),      type = "item", limit = 5,  canRemove = true, box = {item = "pizza_slice",   count = 8}},

    ["bread"] =         {label = T("ITEMS_BREAD"),          type = "item", limit = 5,  canRemove = true, food = {hunger = 250000, thirst = 0,  effect =  "sandwich"}},  -- 4 para full
    ["chocolate"] =     {label = T("ITEMS_CHOCOLATE"),      type = "item", limit = 5,  canRemove = true, food = {hunger =  50000, thirst = 0,  effect = "chocolate"}},  -- 8 para full / Dar stamina
	["brownie_slice"] = {label = T("ITEMS_BROWNIE_SLICE"),  type = "item", limit = 5,  canRemove = true, food = {hunger = 100000, thirst = 0,  effect =   "brownie"}},  -- 10 para full
	["chips"] =         {label = T("ITEMS_CHIPS"),          type = "item", limit = 25, canRemove = true, food = {hunger = 200000, thirst = 0,  effect =     "chips"}},  -- 5 para full
    ["donut"] =         {label = T("ITEMS_DONUT"),          type = "item", limit = 6,  canRemove = true, food = {hunger =  50000, thirst = 0,  effect =     "donut"}},  -- 5 para full
	["pizza_slice"] =   {label = T("ITEMS_PIZZA_SLICE"),    type = "item", limit = 8,  canRemove = true, food = {hunger = 500000, thirst = 0,  effect = "sandwich"}},   -- 2 para full
	["sandwich"] =      {label = T("ITEMS_SANDWICH"),       type = "item", limit = 5,  canRemove = true, food = {hunger = 250000, thirst = 0,  effect = "sandwich"}},   -- 4 para full
	["saucisson"] =     {label = T("ITEMS_SAUCISSON"),      type = "item", limit = 5,  canRemove = true, food = {hunger = 300000, thirst = 0,  customEffect = "esx_basicneeds:onEat"}},
    ["grapperaisin"] =  {label = T("ITEMS_GRAPPERAISIN"),   type = "item", limit = 5,  canRemove = true, food = {hunger = 300000, thirst = 0,  customEffect = "esx_basicneeds:onEat"}},
    ["cupcake"] =       {label = T("ITEMS_CUPCAKE"),        type = "item", limit = 5,  canRemove = true, food = {hunger =  50000, thirst = 0,  customEffect = "esx_basicneeds:onEatCupCake"}}, -- 8 para full

-- enigma 

    ["pack_sliced_bread"] =   {label = T("ITEMS_PACK_SLICED_BREAD"),       type = "item", limit = 1,   canRemove = true, box =  {item = "bread_slice",          count = 20}},
	["pack_cheese"] =         {label = T("ITEMS_PACK_CHEESE"),             type = "item", limit = 1,   canRemove = true, box =  {item = "cheese",               count = 10}},
	["pack_ham"] =            {label = T("ITEMS_PACK_HAM"),                type = "item", limit = 1,   canRemove = true, box =  {item = "ham",                  count = 10}},
    --["pack_prosciutto"] =     {label = T("ITEMS_PROSCIUTTO"),              type = "item", limit = 1,   canRemove = true, box =  {item = "prosciutto",           count = 10}},
	["pack_burger_bun"] =     {label = T("ITEMS_PACK_BURGER_BUN"),         type = "item", limit = 1,   canRemove = true, box =  {item = "burger_bun",           count = 8}},  
	["pack_bacon"] =          {label = T("ITEMS_PACK_BACON"),              type = "item", limit = 1,   canRemove = true, box =  {item = "bacon",                count = 10}},
	["pack_frozen_burger"] =  {label = T("ITEMS_PACK_FROZEN_BURGER"),      type = "item", limit = 1,   canRemove = true, box =  {item = "frozen_burger",        count =  6}},

    ["bread_slice"] =         {label = T("ITEMS_BREAD_SLICE"),             type = "item", limit = 20,  canRemove = true, food = {hunger =  20000,               customEffect = "esx_basicneeds:onEat"}},
	["cheese"] =              {label = T("ITEMS_CHEESE"),                  type = "item", limit = 10,  canRemove = true, food = {hunger =  10000,               customEffect = "esx_basicneeds:onEat"}},
	["ham"] =                 {label = T("ITEMS_HAM"),                     type = "item", limit = 10,  canRemove = true, food = {hunger =  10000,               customEffect = "esx_basicneeds:onEat"}},
	--["prosciutto"] =          {label = T("ITEMS_PROSCIUTTO"),              type = "item", limit = 10,  canRemove = true, food = {hunger =  10000,               customEffect = "esx_basicneeds:onEat"}},
	["burger_bun"] =          {label = T("ITEMS_BURGER_BUN"),              type = "item", limit =  8,  canRemove = true, food = {hunger =  30000,               customEffect = "esx_basicneeds:onEat"}}, 
	["lettuce"] =             {label = T("ITEMS_LETTUCE"),                 type = "item", limit = 10,  canRemove = true, food = {hunger =  10000,               customEffect = "esx_basicneeds:onEat"}}, 
	["tomato"] =              {label = T("ITEMS_TOMATO"),                  type = "item", limit = 10,  canRemove = true, food = {hunger =  10000,               customEffect = "esx_basicneeds:onEat"}}, 
	["bacon"] =               {label = T("ITEMS_BACON"),                   type = "item", limit = 10,  canRemove = true, food = {hunger =  10000,               customEffect = "esx_basicneeds:onEat"}}, 
	["french_fries"] =        {label = T("ITEMS_FRENCH_FRIS"),             type = "item", limit =  1,  canRemove = true}, 
	["oil"] =                 {label = T("ITEMS_OIL"),                     type = "item", limit =  1,  canRemove = true}, 
	["ketchup"] =             {label = T("ITEMS_KETCHUP"),                 type = "item", limit =  1,  canRemove = true}, 
	["frozen_burger"] =       {label = T("ITEMS_FROZEN_BURGER"),           type = "item", limit =  6,  canRemove = true}, 
	["blicas_fritas"] =       {label = T("ITEMS_BLICAS_FRITAS"),           type = "item", limit = 10,  canRemove = true, food = {hunger = 280000,               customEffect = "esx_basicneeds:onEat"}}, 

	["ham_sandwich"] =        {label = T("ITEMS_HAM_SANDWICH"),            type = "item", limit =  5,  canRemove = true, food = {hunger = 100000,               customEffect = "esx_basicneeds:onEat"}},
	["cheese_sandwich"] =     {label = T("ITEMS_CHEESE_SANDWICH"),         type = "item", limit =  5,  canRemove = true, food = {hunger = 100000,               customEffect = "esx_basicneeds:onEat"}},
	--["prosciutto_sandwich"] = {label = T("ITEMS_PROSCIUTTO_SANDWICH"),     type = "item", limit =  5,  canRemove = true, food = {hunger = 100000,               customEffect = "esx_basicneeds:onEat"}},
	["mixed_sandwich"] =      {label = T("ITEMS_MIXED_SANDWICH"),          type = "item", limit =  5,  canRemove = true, food = {hunger = 100000,               customEffect = "esx_basicneeds:onEat"}},
	["hamburger"] =           {label = T("ITEMS_HAMBURGER"),               type = "item", limit = 10,   canRemove = true, food = {hunger = 250000,                                effect = "hamburger"}},  -- 4 para full   
	["cheese_hamburger"] =    {label = T("ITEMS_CHEESE_HAMBURGER"),        type = "item", limit = 10,   canRemove = true, food = {hunger = 300000,                                effect = "hamburger"}},  -- 4 para full   
	["bacon_hamburger"] =     {label = T("ITEMS_BACON_HAMBURGER"),         type = "item", limit = 10,   canRemove = true, food = {hunger = 350000,                                effect = "hamburger"}},  -- 4 para full   

    --Sushi

    ["salmon_nigiri"] =       {label = T("ITEMS_SALMON_NIGIRI"),            type = "item", limit = 10, canRemove = true},
    ["tuna_nigiri"] =         {label = T("ITEMS_TUNA_NIGIRI"),              type = "item", limit = 10, canRemove = true},
    ["salmon_roe"] =          {label = T("ITEMS_SALMON_ROE"),               type = "item", limit = 10, canRemove = true},
    ["salmon_california"] =   {label = T("ITEMS_SALMON_CALIFORNIA"),        type = "item", limit = 10, canRemove = true},
    ["salmon_roe_gunkan"] =   {label = T("ITEMS_SALMON_ROE_GUNKAN"),        type = "item", limit = 10, canRemove = true},
    ["salmon_temaki"] =       {label = T("ITEMS_SALMON_TEMAKI"),            type = "item", limit = 10, canRemove = true},
    ["salmon_sashimi"] =      {label = T("ITEMS_SALMON_SASHIMI"),           type = "item", limit = 10, canRemove = true},
    ["tuna_sashimi"] =        {label = T("ITEMS_TUNA_SASHIMI"),             type = "item", limit = 10, canRemove = true},
    ["bream_sashimi"] =       {label = T("ITEMS_BREAM_SASHIMI"),            type = "item", limit = 10, canRemove = true},
    ["salmon_gunkan"] =       {label = T("ITEMS_SALMON_GUNKAN"),            type = "item", limit = 10, canRemove = true},
    ["salmon_maki"] =         {label = T("ITEMS_SALMON_MAKI"),              type = "item", limit = 10, canRemove = true},
    ["nori_seaweed"] =        {label = T("ITEMS_NORI_SEAWEED"),             type = "item", limit = 10, canRemove = true},


    -- Drinks

    ["water"] =     {label = T("ITEMS_WATER"),      type = "item", limit = 5,  canRemove = true, food = {thirst = 500000,                      effect = "water"}}, -- 2 para full
    ["cocacola"] =  {label = T("ITEMS_COCACOLA"),   type = "item", limit = 35, canRemove = true, food = {thirst = 250000,                      effect = "cola"}},  -- 4 para full
    ["limonade"] =  {label = T("ITEMS_LIMONADE"),   type = "item", limit = 5,  canRemove = true, food = {thirst = 300000,                      customEffect = "esx_basicneeds:onDrink"}},
    ["coffe"] =     {label = T("ITEMS_COFFE"),      type = "item", limit = 5,  canRemove = true, food = {thirst = 250000,                      customEffect = "esx_basicneeds:onDrinkCoffe"}}, -- 4 para full / dar stamina
    ["jusfruit"] =  {label = T("ITEMS_JUSFRUIT"),   type = "item", limit = 5,  canRemove = true, food = {thirst = 250000,                      customEffect = "esx_basicneeds:onDrink"}},      -- 4 para full
    ["energy"] =    {label = T("ITEMS_ENERGY"),     type = "item", limit = 5,  canRemove = true, food = {thirst = 400000,                      customEffect = "esx_basicneeds:onDrink"}},
    ["icetea"] =    {label = T("ITEMS_ICETEA"),     type = "item", limit = 5,  canRemove = true, food = {thirst = 250000,                      customEffect = "esx_basicneeds:onDrink"}}, 
    ["absinthe"] =  {label = T("ITEMS_ABSINTHE"),   type = "item", limit = 5,  canRemove = true, food = {drunk =  350000,                      customEffect = "esx_optionalneeds:onDrink"}},
    ["beer"] =      {label = T("ITEMS_BEER"),       type = "item", limit = 5,  canRemove = true, food = {drunk =  15000,                       customEffect = "esx_basicneeds:onDrinkBeer"}},
    ["gintonic"] =  {label = T("ITEMS_GINTONIC"),   type = "item", limit = 5,  canRemove = true, food = {drunk =  150000,                      customEffect = "esx_basicneeds:onDrinkGin"}},
    ["jager"] =     {label = T("ITEMS_JAGER"),      type = "item", limit = 5,  canRemove = true, food = {drunk =  320000,                      customEffect = "esx_optionalneeds:onDrink"}},
    ["martini"] =   {label = T("ITEMS_MARTINI"),    type = "item", limit = 5,  canRemove = true, food = {drunk =  220000,                      customEffect = "esx_optionalneeds:onDrink"}},
    ["milk"] =      {label = T("ITEMS_MILK"),       type = "item", limit = 5,  canRemove = true, food = {drunk =  -1000000, thirst = 70000,    customEffect = "esx_basicneeds:onDrinkMilk"}},
	["mojito"] =    {label = T("ITEMS_MOJITO"),     type = "item", limit = 5,  canRemove = true, food = {drunk =  240000,                      customEffect = "esx_optionalneeds:onDrink"}},
    ["rhum"] =      {label = T("ITEMS_RHUM"),       type = "item", limit = 5,  canRemove = true, food = {drunk =  240000,                      customEffect = "esx_optionalneeds:onDrink"}},
	["tribunal"] =  {label = T("ITEMS_TEQUILA"),    type = "item", limit = 5,  canRemove = true, food = {drunk =  220000,                      customEffect = "esx_optionalneeds:onDrink"}},
	["vodka"] =     {label = T("ITEMS_VODKA"),      type = "item", limit = 5,  canRemove = true, food = {drunk  = 300000,                      customEffect = "esx_optionalneeds:onDrink"}},
	["whisky"] =    {label = T("ITEMS_WHISKY"),     type = "item", limit = 5,  canRemove = true, food = {drunk =  350000,                      customEffect = "esx_optionalneeds:onDrink"}},

    -- Vehicles

	["pipes"] =         {label = T("ITEMS_PIPES"),          type = "item", limit = -1,  canRemove = true},
	["suede"] =         {label = T("ITEMS_SUEDE"),          type = "item", limit = 6,   canRemove = true},
	["carotool"] =      {label = T("ITEMS_CAROTOOL"),       type = "item", limit = 4,   canRemove = true},
    ["car_body"] =      {label = T("ITEMS_CAR_BODY"),       type = "item", limit = -1,  canRemove = true},
    ["fixkit"] =        {label = T("ITEMS_FIXKIT"),         type = "item", limit = 25,  canRemove = true},
	["fixkith"] =       {label = T("ITEMS_FIXKITH"),        type = "item", limit = 10,  canRemove = true},
    ["fixkitb"] =       {label = T("ITEMS_FIXKITB"),        type = "item", limit = 15,  canRemove = true},
	["fixtool"] =       {label = T("ITEMS_FIXTOOL"),        type = "item", limit = 6,   canRemove = true},
	["gazbottle"] =     {label = T("ITEMS_GAZBOTTLE"),      type = "item", limit = 11,  canRemove = true},
    ["vehicleplate"] =  {label = T("ITEMS_VEHICLEPLATE"),   type = "item", limit = 1,   canRemove = true},

-- Oficinas Ilegais 
    ["motor_part"] =    {label = T("ITEMS_MOTOR_PART"),     type = "item", limit = -1,  canRemove = true},
    ["nitro"] =         {label = T("ITEMS_NITRO"),          type = "item", limit = 4,   canRemove = true},
    ["copper_cable"] =  {label = T("ITEMS_COPPER_CABLE"),   type = "item", limit = 100, canRemove = true},
	["car_motor"] =     {label = T("ITEMS_CAR_MOTOR"),      type = "item", limit = 100, canRemove = true},
	["car_pipe"] =      {label = T("ITEMS_CAR_PIPE"),       type = "item", limit = 100, canRemove = true},

-- Oficinas Legais
    ["car_electrical_system"] =      {label = T("ITEMS_CAR_ELECTRICAL_SYSTEM"),       type = "item", limit = 100, canRemove = true},
	["car_inside"] =                 {label = T("ITEMS_CAR_INSIDE"),                  type = "item", limit = 100, canRemove = true},
	["car_chassis"] =                {label = T("ITEMS_CAR_CHASSIS"),                 type = "item", limit = 100, canRemove = true},
	["car_motor2"] =                 {label = T("ITEMS_CAR_MOTOR2"),                  type = "item", limit = 100, canRemove = true},
	["car_transmission"] =           {label = T("ITEMS_CAR_TRANSMISSION"),            type = "item", limit = 100, canRemove = true},
	["car_bodywork"] =               {label = T("ITEMS_CAR_BODYWORK"),                type = "item", limit = 100, canRemove = true},

--helis
	["heli_electrical_system"] =      {label = T("ITEMS_HELI_ELECTRICAL_SYSTEM"),       type = "item", limit = 100, canRemove = true},
	["heli_engine"] =                 {label = T("ITEMS_HELI_ENGINE"),                  type = "item", limit = 100, canRemove = true},
	["heli_rotor_main"] =             {label = T("ITEMS_HELI_ROTOR_MAIN"),              type = "item", limit = 100, canRemove = true},
	["heli_transmission"] =           {label = T("ITEMS_HELI_TRANSMISSION"),            type = "item", limit = 100, canRemove = true},
	["heli_bodywork"] =               {label = T("ITEMS_HELI_BODYWORK"),                type = "item", limit = 100, canRemove = true},

-- Boats
	["boat_electrical_system"] =      {label = T("ITEMS_BOAT_ELECTRICAL_SYSTEM"),       type = "item", limit = 100, canRemove = true},
	["boat_rudder"] =                 {label = T("ITEMS_BOAT_RUDDER"),                  type = "item", limit = 100, canRemove = true},
	["boat_engine"] =                 {label = T("ITEMS_BOAT_ENGINE"),                  type = "item", limit = 100, canRemove = true},
	["boat_transmission"] =           {label = T("ITEMS_BOAT_TRANSMISSION"),            type = "item", limit = 100, canRemove = true},
	["boat_bodywork"] =               {label = T("ITEMS_BOAT_BODYWORK"),                type = "item", limit = 100, canRemove = true},



-- Prints Oficinas Legais
    ["asbo_print"] =         {label = T("ITEMS_ASBO_PRINT"),          type = "item", limit = 100, canRemove = true},
	["bifta_print"] =        {label = T("ITEMS_BIFTA_PRINT"),         type = "item", limit = 100, canRemove = true},
	["boor_print"] =         {label = T("ITEMS_BOOR_PRINT"),          type = "item", limit = 100, canRemove = true},
	["brioso_print"] =       {label = T("ITEMS_BRIOSO_PRINT"),        type = "item", limit = 100, canRemove = true},
	["clique2_print"] =      {label = T("ITEMS_CLIQUE2_PRINT"),       type = "item", limit = 100, canRemove = true},
	["deveste_print"] =      {label = T("ITEMS_DEVESTE_PRINT"),       type = "item", limit = 100, canRemove = true},
	["draugur_print"] =      {label = T("ITEMS_DRAUGUR_PRINT"),       type = "item", limit = 100, canRemove = true},
	["dune_print"] =         {label = T("ITEMS_DUNE_PRINT"),          type = "item", limit = 100, canRemove = true},
	["hellion_print"] =      {label = T("ITEMS_HELLION_PRINT"),       type = "item", limit = 100, canRemove = true},
	["hotknife_print"] =     {label = T("ITEMS_HOTKNIFE_PRINT"),      type = "item", limit = 100, canRemove = true},
	["issi3_print"] =        {label = T("ITEMS_ISSI3_PRINT"),         type = "item", limit = 100, canRemove = true},
	["issi7_print"] =        {label = T("ITEMS_ISSI7_PRINT"),         type = "item", limit = 100, canRemove = true},
	["issi8_print"] =        {label = T("ITEMS_ISSI8_PRINT"),         type = "item", limit = 100, canRemove = true},
	["stalion2_print"] =     {label = T("ITEMS_STALION2_PRINT"),      type = "item", limit = 100, canRemove = true},
	["trophytruck2_print"] = {label = T("ITEMS_TROPHYTRUCK2_PRINT"),  type = "item", limit = 100, canRemove = true},
	["drafter_print"] =      {label = T("ITEMS_DRAFTER_PRINT"),       type = "item", limit = 100, canRemove = true},

-- Heli
	["seasparrow2_print"] =      {label = T("ITEMS_SEASPARROW2_PRINT"),       type = "item", limit = 100, canRemove = true},
	["maverick_print"] =         {label = T("ITEMS_MAVERICK_PRINT"),          type = "item", limit = 100, canRemove = true},
	["frogger2_print"] =         {label = T("ITEMS_FROGGER2_PRINT"),          type = "item", limit = 100, canRemove = true},
	["supervolito_print"] =      {label = T("ITEMS_SUPERVOLITO_PRINT"),       type = "item", limit = 100, canRemove = true},
	["volatus_print"] =          {label = T("ITEMS_VOLATUS_PRINT"),           type = "item", limit = 100, canRemove = true},
	["swift2_print"] =           {label = T("ITEMS_SWIFT2_PRINT"),            type = "item", limit = 100, canRemove = true},
	["havok_print"] =            {label = T("ITEMS_HAVOK_PRINT"),             type = "item", limit = 100, canRemove = true},

-- boat
	["seashark3_print"] =      {label = T("ITEMS_SEASHARK3_PRINT"),         type = "item", limit = 100, canRemove = true},
	["squalo_print"] =         {label = T("ITEMS_SQUALO_PRINT"),            type = "item", limit = 100, canRemove = true},
	["tropic_print"] =         {label = T("ITEMS_TROPIC_PRINT"),            type = "item", limit = 100, canRemove = true},
	["tropic2_print"] =        {label = T("ITEMS_TROPIC2_PRINT"),           type = "item", limit = 100, canRemove = true},
	["suntrap_print"] =        {label = T("ITEMS_SUNTRAP_PRINT"),           type = "item", limit = 100, canRemove = true},
	["marquis_print"] =        {label = T("ITEMS_MARQUIS_PRINT"),           type = "item", limit = 100, canRemove = true},
	["dinghy4_print"] =        {label = T("ITEMS_DINGHY4_PRINT"),           type = "item", limit = 100, canRemove = true},
	["jetmax_print"] =         {label = T("ITEMS_JETMAX_PRINT"),            type = "item", limit = 100, canRemove = true},
	["toro2_print"] =          {label = T("ITEMS_TORO2_PRINT"),             type = "item", limit = 100, canRemove = true},
	["speeder2_print"] =       {label = T("ITEMS_SPEEDER2_PRINT"),          type = "item", limit = 100, canRemove = true},
	["longfin_print"] =        {label = T("ITEMS_LONGFIN_PRINT"),           type = "item", limit = 100, canRemove = true},
	["seasparrow_print"] =     {label = T("ITEMS_SEASPARROW_PRINT"),        type = "item", limit = 100, canRemove = true},
	["sr510_print"] =          {label = T("ITEMS_SR510_PRINT"),             type = "item", limit = 100, canRemove = true},
	["sr650fly_print"] =       {label = T("ITEMS_SR650FLY_PRINT"),          type = "item", limit = 100, canRemove = true},
	["yacht2_print"] =         {label = T("ITEMS_YACHT2_PRINT"),            type = "item", limit = 100, canRemove = true},
	["avisa_print"] =          {label = T("ITEMS_AVISA_PRINT"),             type = "item", limit = 100, canRemove = true},
	["dodo_print"] =           {label = T("ITEMS_DODO_PRINT"),              type = "item", limit = 100, canRemove = true},
	["tug_print"] =            {label = T("ITEMS_TUG_PRINT"),               type = "item", limit = 100, canRemove = true},



    -- Robbery

	["thermal_charge"] =    {label = T("ITEMS_THERMAL_CHARGE"), type = "item", limit = 5,   canRemove = true,  trade = {min = 1, max = 1, item = "gunpowder"}},
    ["secure_card"] =       {label = T("ITEMS_SECURE_CARD"),    type = "item", limit = 3,   canRemove = true,  trade = {min = 1, max = 1, item = "electronic_waste"}},
    ["id_card"] =           {label = T("ITEMS_ID_CARD"),        type = "item", limit = 1,   canRemove = true,  trade = {min = 1, max = 1, item = "electronic_waste"}},
	["id_card_f"] =         {label = T("ITEMS_ID_CARD_F"),      type = "item", limit = 3,   canRemove = true,  trade = {min = 1, max = 1, item = "electronic_waste"}},
    ["hacker_device"] =     {label = T("ITEMS_HACKER_DEVICE"),  type = "item", limit = 100, canRemove = true,  trade = {min = 1, max = 1, item = "electronic_waste"}},
	["chip_mk2_ruby"] =     {label = T("ITEMS_CHIP_MK2_RUBY"),  type = "item", limit = 100, canRemove = true},
    ["laptop"] =            {label = T("ITEMS_LAPTOP"),         type = "item", limit = -1,  canRemove = true},
	["laptop_h"] =          {label = T("ITEMS_LAPTOP_H"),       type = "item", limit = 1,   canRemove = true},
    ["lockpick"] =          {label = T("ITEMS_LOCKPICK"),       type = "item", limit = 100, canRemove = true},
    ["ziptie"] =            {label = T("ITEMS_ZIPTIE"),         type = "item", limit = 10,  canRemove = true},

    -- Medical

    ["medikit"] =           {label = T("ITEMS_MEDIKIT"),            type = "item", limit = 20,   canRemove = true},
    ["bandage"] =           {label = T("ITEMS_BANDAGE"),            type = "item", limit = 20,   canRemove = true},
    ["tranquilizer"] =      {label = T("ITEMS_TRANQUILIZER"),       type = "item", limit = 10,   canRemove = true},
    ["adrenaline_shot"] =   {label = T("ITEMS_ADRENALINE_SHOT"),    type = "item", limit = 5,    canRemove = true},
    ["condom"] =            {label = T("ITEMS_CONDOM"),             type = "item", limit = 1,    canRemove = true},
	["condom_bag"] =        {label = T("ITEMS_CONDOM_BAG"),         type = "item", limit = 10,   canRemove = true, box = {item = "condom", count = 1}},
	["condom_pack"] =       {label = T("ITEMS_CONDOM_PACK"),        type = "item", limit = 4,    canRemove = true, box = {item = "condom_bag", count = 10}},
	["efedrina"] =          {label = T("ITEMS_EFEDRINA"),           type = "item", limit = 100,  canRemove = true},

    -- Tech

	["tel"] =       {label = T("ITEMS_TEL"),        type = "item", limit = 2,  canRemove = true, trade = {min = 1, max = 1, item = "btel"}},
	["radio"] =     {label = T("ITEMS_RADIO"),      type = "item", limit = 2,  canRemove = true, trade = {min = 1, max = 1, item = "bradio"}},
    ["tablet"] =    {label = T("ITEMS_TABLET"),     type = "item", limit = 4,  canRemove = true},
    ["simcard"] =   {label = T("ITEMS_SIMCARD"),    type = "item", limit = -1, canRemove = true},
    ["mic"] =       {label = T("ITEMS_MIC"),        type = "item", limit = -1, canRemove = true},
    ["battery"] =   {label = T("ITEMS_BATTERY"),    type = "item", limit = 10, canRemove = true},
    ["bmic"] =      {label = T("ITEMS_BMIC"),       type = "item", limit = -1, canRemove = true},
	["hifi"] =      {label = T("ITEMS_HIFI"),       type = "item", limit = 20, canRemove = true},
    ["cam"] =       {label = T("ITEMS_CAM"),        type = "item", limit = -1, canRemove = true},
	["camera"] =    {label = T("ITEMS_CAMERA"),     type = "item", limit = -1, canRemove = true},

    -- Bags

    ["small_bag"] =     {label = T("ITEMS_SMALL_BAG"),      type = "item", limit = -1, canRemove = true, bag = {slots = 5}},
    ["medium_bag"] =    {label = T("ITEMS_MEDIUM_BAG"),     type = "item", limit = -1, canRemove = true, bag = {slots = 10}},
    ["large_bag"] =     {label = T("ITEMS_LARGE_BAG"),      type = "item", limit = -1, canRemove = true, bag = {slots = 15}},
    ["destino_bag"] =  {label = T("ITEMS_DESTINO_BAG"),   type = "item", limit = -1, canRemove = true, bag = {slots = 20}},

    -- Contracts

    ["house_ownership_transfer"] =          {label = T("ITEMS_HOUSE_OWNERSHIP_TRANSFER"),           type = "item", limit = -1, canRemove = true},
	["car_ownership_transfer"] =            {label = T("ITEMS_CAR_OWNERSHIP_TRANSFER"),             type = "item", limit = -1, canRemove = true},
	["business_car_ownership_transfer"] =   {label = T("ITEMS_BUSINESS_CAR_OWNERSHIP_TRANSFER"),    type = "item", limit = -1, canRemove = true},
	["identitychange"] =                    {label = T("ITEMS_IDENTITYCHANGE"),                     type = "item", limit = 5,  canRemove = true},
    ["house_deed"] =                        {label = T("ITEMS_HOUSE_DEED"),                         type = "item", limit = -1, canRemove = true},
    ["adminhouse"] =                        {label = T("ITEMS_ADMINHOUSE"),                         type = "item", limit = -1, canRemove = true},

    ["vipcard"] =                   {label = T("ITEMS_VIPCARD"),        type = "item", limit = -1, canRemove = true},
	["freedrinks"] =                {label = T("ITEMS_FREEDRINKS"),     type = "item", limit = -1, canRemove = true},
	["bahamasinvite"] =             {label = T("ITEMS_BAHAMASINVITE"),  type = "item", limit = -1, canRemove = true},
    ["f1teampass"] =                {label = T("ITEMS_F1TEAMPASS"),     type = "item", limit = 5,  canRemove = true},
	["f1vippass"] =                 {label = T("ITEMS_F1VIPPASS"),      type = "item", limit = 5,  canRemove = true},

    -- Fish

	["raja"] =              {label = T("ITEMS_RAJA"),           type = "item", limit = 100, canRemove = true},
	["turtlebait"] =        {label = T("ITEMS_TURTLEBAIT"),     type = "item", limit = 25,  canRemove = true},
    ["canned_sardine"] =    {label = T("ITEMS_CANNED_SARDINE"), type = "item", limit = 100, canRemove = true},
	["canned_tuna"] =       {label = T("ITEMS_CANNED_TUNA"),    type = "item", limit = 100, canRemove = true},

	-- caça lendaria
	["whale"] =            {label = T("ITEMS_WHALE"),          type = "item", limit = 100, canRemove = true},
	["rabbit_leg"] =       {label = T("ITEMS_RABBIT_LEG"),     type = "item", limit = 100, canRemove = true},
	["redfox"] =           {label = T("ITEMS_REDFOX"),         type = "item", limit =  10, canRemove = true},
	["articfox"] =         {label = T("ITEMS_ARTICFOX"),       type = "item", limit =  10, canRemove = true},

	-- peixes legais
	["carp"] =             {label = T("ITEMS_CARP"),      		    type = "item", limit = 100, canRemove = true},
	["loss"] =             {label = T("ITEMS_LOSS"),      		    type = "item", limit = 100, canRemove = true},
	["tench"] =            {label = T("ITEMS_TENCH"),      		    type = "item", limit = 100, canRemove = true},
	["lucio"] =            {label = T("ITEMS_LUCIO"),     		    type = "item", limit = 100, canRemove = true},
	["tuna"] =             {label = T("ITEMS_TUNA"),      		    type = "item", limit = 100, canRemove = true},
	["trout"] =            {label = T("ITEMS_TROUT"),     		    type = "item", limit = 100, canRemove = true},
	["barbel"] =           {label = T("ITEMS_BARBEL"),   		    type = "item", limit = 100, canRemove = true},
	["eel"] =              {label = T("ITEMS_EEL"),       		    type = "item", limit = 100, canRemove = true},
	["boga"] =             {label = T("ITEMS_BOGA"),    		    type = "item", limit = 100, canRemove = true},
	["salmon"] =           {label = T("ITEMS_SALMON"),    		    type = "item", limit = 100, canRemove = true},
	["sardine"] =          {label = T("ITEMS_SARDINE"),   		    type = "item", limit = 100, canRemove = true},
	["seabass"] =          {label = T("ITEMS_SEABASS"),             type = "item", limit = 100, canRemove = true},
	["mackerel"] =         {label = T("ITEMS_MACKEREL"),            type = "item", limit = 100, canRemove = true},
	["gilt_head_bream"] =  {label = T("ITEMS_GILT_HEAD_BREAM"),     type = "item", limit = 100, canRemove = true},

	-- peixes ilegais
	["turtle"] =           {label = T("ITEMS_TURTLE"),              type = "item", limit = 100, canRemove = true},
	["baby_turtle"] =      {label = T("ITEMS_BABY_TURTLE"),         type = "item", limit = 100, canRemove = true},
	["rare_turtle"] =      {label = T("ITEMS_RARE_TURTLE"),         type = "item", limit = 100, canRemove = true},
	["legendary_turtle"] = {label = T("ITEMS_LEGENDARY_TURTLE"),    type = "item", limit = 100, canRemove = true},
	["common_seahorse"] =  {label = T("ITEMS_COMMON_SEAHORSE"),     type = "item", limit = 100, canRemove = true},
	["blue_shark"] =       {label = T("ITEMS_BLUE_SHARK"),          type = "item", limit = 100, canRemove = true}, 
	["hammerhead_shark"] = {label = T("ITEMS_HAMMERHEAD_SHARK"),    type = "item", limit = 100, canRemove = true}, 
	["white_shark"] =      {label = T("ITEMS_WHITE_SHARK"),         type = "item", limit = 100, canRemove = true},   
	["basking_shark"] =    {label = T("ITEMS_BASKING_SHARK"),       type = "item", limit = 100, canRemove = true},
	["dolphin"] =          {label = T("ITEMS_DOLPHIN"),             type = "item", limit = 100, canRemove = true},
	["sea_lion"] =         {label = T("ITEMS_SEA_LION"),            type = "item", limit = 100, canRemove = true},

    ["shark"] =             {label = T("ITEMS_SHARK"),          type = "item", limit = 5,   canRemove = true},
	---------------------------------------------------------------------------------------------------------
    ["codfish"] =           {label = T("ITEMS_CODFISH"),        type = "item", limit = 100,  canRemove = true},
    ["fish"] =              {label = T("ITEMS_FISH"),           type = "item", limit = 500,  canRemove = true},
    ["fishbait"] =          {label = T("ITEMS_FISHBAIT"),       type = "item", limit = 50,   canRemove = true},
    ["bait1"] =             {label = T("ITEMS_BAIT1"),          type = "item", limit = 100,  canRemove = true},
	["bait2"] =             {label = T("ITEMS_BAIT2"),          type = "item", limit = 100,  canRemove = true},
	["bait3"] =             {label = T("ITEMS_BAIT3"),          type = "item", limit = 100,  canRemove = true},
	["bait4"] =             {label = T("ITEMS_BAIT4"),          type = "item", limit = 100,  canRemove = true},
	["turtle_meat"] =       {label = T("ITEMS_TURTLE_MEAT"),    type = "item", limit = 100,  canRemove = true},

	-- ITEMS DO MAR
	["rusty_scrap"] =          {label = T("ITEMS_RUSTY_SCRAP"),         type = "item", limit = 100,  canRemove = true},
	["sea_plastic"] =          {label = T("ITEMS_SEA_PLASTIC"),         type = "item", limit = 100,  canRemove = true},
	["old_coin1"] =            {label = T("ITEMS_OLD_COIN1"),   	    type = "item", limit = 100,  canRemove = true},
	["old_coin2"] =       	   {label = T("ITEMS_OLD_COIN2"),           type = "item", limit = 100,  canRemove = true},
	["old_coin3"] =      	   {label = T("ITEMS_OLD_COIN3"),   	    type = "item", limit = 100,  canRemove = true},
	["brokensns"] =      	   {label = T("ITEMS_BROKENSNS"),   	    type = "item", limit = 100,  canRemove = true},
	["brokenvintage"] =        {label = T("ITEMS_BROKENVINTAGE"),   	type = "item", limit = 100,  canRemove = true},
	["packaged_drug"] =        {label = T("ITEMS_PACKAGED_DRUG"),       type = "item", limit =  10,  canRemove = true, box =  {item = "coke",                 count =  50}},
	["packaged_drug2"] =       {label = T("ITEMS_PACKAGED_DRUG2"),      type = "item", limit =  10,  canRemove = true, box =  {item = "weed",                 count =  50}},
	["rusty_weapons_crate"] =  {label = T("ITEMS_RUSTY_WEAPONS_CRATE"), type = "item", limit =  10,  canRemove = true, box =  {item = "weapon_part",          count =  20}},

    ["mysterious_box"] =       {label = T("ITEMS_MYSTERIOUS_BOX"),      type = "item", limit =  10,  canRemove = true, lootbox = {
        {item = "raw_ruby",      count =   1, chance =  1},
        {item = "raw_diamond",   count =   1, chance =  1},
        {item = "raw_emerald",   count =   1, chance =  1},
        {item = "brokensns",     count =   1, chance =  5},
        {item = "iron",          count =  10, chance = 20},
        {item = "brokenvintage", count =   1, chance =  5},
        {item = "jewels",        count =  15, chance =  5},
        {item = "old_plastic",   count =  30, chance = 20},
        {item = "beer",          count =   1, chance = 37},
		{item = "scrap",         count =  10, chance =  5},
    }},


    -- Drugs

	["weed"] =              {label = T("ITEMS_WEED"),               type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "weed_pooch_new", count = 5}},
	["weed_pooch"] =        {label = T("ITEMS_WEED_POOCH"),         type = "item", limit = 100, canRemove = true},
	["weed_pooch_new"] =    {label = T("ITEMS_WEED_POOCH_NEW"),     type = "item", limit = 100, canRemove = true},
	["weed_seed"] =         {label = T("ITEMS_WEED_SEED"),          type = "item", limit = 500, canRemove = true},
	["weed_untrimmed"] =    {label = T("ITEMS_WEED_UNTRIMMED"),     type = "item", limit = 100, canRemove = true},
    ["meth"] =              {label = T("ITEMS_METH"),               type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "meth_pooch", count = 5}},
	["meth_pooch"] =        {label = T("ITEMS_METH_POOCH"),         type = "item", limit = 100, canRemove = true},
    ["lisergicacid"] =      {label = T("ITEMS_LISERGICACID"),       type = "item", limit = 100, canRemove = true},
	["lsd"] =               {label = T("ITEMS_LSD"),                type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "lsd_pooch", count = 5}},
	["lsd_pooch"] =         {label = T("ITEMS_LSD_POOCH"),          type = "item", limit = 100, canRemove = true},
    ["hashish"] =           {label = T("ITEMS_HASHISH"),            type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "hashish_pooch", count = 5}},
	["hashish_pooch"] =     {label = T("ITEMS_HASHISH_POOCH"),      type = "item", limit = 100, canRemove = true},
	["hashish_seed"] =      {label = T("ITEMS_HASHISH_SEED"),       type = "item", limit = 500, canRemove = true},
	["hashish_untrimmed"] = {label = T("ITEMS_HASHISH_UNTRIMMED"),  type = "item", limit = 100, canRemove = true},
    ["opium"] =             {label = T("ITEMS_OPIUM"),              type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "opium_bag", count = 5}},
	["opium_bag"] =         {label = T("ITEMS_OPIUM_BAG"),          type = "item", limit = 100, canRemove = true},
	["poppy_seed"] =        {label = T("ITEMS_POPPY_SEED"),         type = "item", limit = 500, canRemove = true},
	["poppy_head"] =        {label = T("ITEMS_POPPY_HEAD"),         type = "item", limit = 100, canRemove = true},
    ["coke"] =              {label = T("ITEMS_COKE"),               type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "coke_pooch_new", count = 5}},
	["coke_pooch"] =        {label = T("ITEMS_COKE_POOCH"),         type = "item", limit = 100, canRemove = true},
	["coke_pooch_new"] =    {label = T("ITEMS_COKE_POOCH_NEW"),     type = "item", limit = 100, canRemove = true},
	["coke_seed"] =         {label = T("ITEMS_COKE_SEED"),          type = "item", limit = 500, canRemove = true},
	["coke_uncut"] =        {label = T("ITEMS_COKE_UNCUT"),         type = "item", limit = 100, canRemove = true},
    ["crack"] =             {label = T("ITEMS_CRACK"),              type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "crack_pooch", count = 5}},
	["crack_pooch"] =       {label = T("ITEMS_CRACK_POOCH"),        type = "item", limit = 100, canRemove = true},

    -- Tools

    ["scissors"] =              {label = T("ITEMS_SCISSORS"),               type = "item", limit = 10, canRemove = true},
    ["axe"] =                   {label = T("ITEMS_AXE"),                    type = "item", limit = 1,  canRemove = true},
    ["chainsaw"] =              {label = T("ITEMS_CHAINSAW"),               type = "item", limit = 1,  canRemove = true},
    ["binoculars"] =            {label = T("ITEMS_BINOCULARS"),             type = "item", limit = 5,  canRemove = true},
    ["pickaxe"] =               {label = T("ITEMS_PICKAXE"),                type = "item", limit = 1,  canRemove = true},
    ["drill"] =                 {label = T("ITEMS_DRILL"),                  type = "item", limit = -1, canRemove = true},
	["drillbit"] =              {label = T("ITEMS_DRILLBIT"),               type = "item", limit = 15, canRemove = true},
	["drillwithbit"] =          {label = T("ITEMS_DRILLWITHBIT"),           type = "item", limit = -1, canRemove = true},
    ["anchor"] =                {label = T("ITEMS_ANCHOR"),                 type = "item", limit = 1,  canRemove = true},
    ["barrier"] =               {label = T("ITEMS_BARRIER"),                type = "item", limit = 10, canRemove = true},
    ["copper_coil"] =           {label = T("ITEMS_COPPER_COIL"),            type = "item", limit = 10, canRemove = true},
	["advanced_circuit"] =      {label = T("ITEMS_ADVANCED_CIRCUIT"),       type = "item", limit = 10, canRemove = true},
    ["electronic_bracelet"] =   {label = T("ITEMS_ELECTRONIC_BRACELET"),    type = "item", limit = 1,  canRemove = false},
	["fishingrod"] =            {label = T("ITEMS_FISHINGROD"),             type = "item", limit = 10, canRemove = true},
    ["elementalrod"] =          {label = T("ITEMS_ELEMENTALROD"),           type = "item", limit = -1, canRemove = true},
    ["magnumxlrod"] =           {label = T("ITEMS_MAGNUMXLROD"),            type = "item", limit = -1, canRemove = true},
    ["weaknylon"] =             {label = T("ITEMS_WEAKNYLON"),              type = "item", limit = -1, canRemove = true},
	["weakreel"] =              {label = T("ITEMS_WEAKREEL"),               type = "item", limit = -1, canRemove = true},
    ["strongnylon"] =           {label = T("ITEMS_STRONGNYLON"),            type = "item", limit = -1, canRemove = true},
	["strongreel"] =            {label = T("ITEMS_STRONGREEL"),             type = "item", limit = -1, canRemove = true},
    ["mediumnylon"] =           {label = T("ITEMS_MEDIUMNYLON"),            type = "item", limit = -1, canRemove = true},
	["mediumreel"] =            {label = T("ITEMS_MEDIUMREEL"),             type = "item", limit = -1, canRemove = true},
    ["hook1"] =                 {label = T("ITEMS_HOOK1"),                  type = "item", limit = -1, canRemove = true},
	["hook2"] =                 {label = T("ITEMS_HOOK2"),                  type = "item", limit = -1, canRemove = true},
	["hook3"] =                 {label = T("ITEMS_HOOK3"),                  type = "item", limit = -1, canRemove = true},
	["hook4"] =                 {label = T("ITEMS_HOOK4"),                  type = "item", limit = -1, canRemove = true},
	["hook5"] =                 {label = T("ITEMS_HOOK5"),                  type = "item", limit = -1, canRemove = true},
    ["tuning_laptop"] =         {label = T("ITEMS_TUNING_LAPTOP"),          type = "item", limit = 1,  canRemove = true},
    ["thermal_goggles"] =       {label = T("ITEMS_THERMAL_GOGGLES"),        type = "item", limit = 2,  canRemove = true},
    ["nightvision_goggles"] =   {label = T("ITEMS_NIGHTVISION_GOGGLES"),    type = "item", limit = 2,  canRemove = true},
    ["blowpipe"] =              {label = T("ITEMS_BLOWPIPE"),               type = "item", limit = 10, canRemove = true},
    ["keys"] =                  {label = T("ITEMS_KEYS"),                   type = "item", limit = 10, canRemove = true},

    -- Halloween 2023

    ["candy"] =                     {label = T("ITEMS_CANDY"),                      type = "item", limit = -1, canRemove = true, food = {hunger = 100000, thirst = 40000, effect = "brownie", customEffect = "cframework:candyEffect"}},
	["gums"] =                      {label = T("ITEMS_GUMS"),                       type = "item", limit = -1, canRemove = true, food = {hunger = 100000, thirst = 40000, effect = "brownie", customEffect = "cframework:gumsEffect"}},
	["halloween2023crystalball"] =  {label = T("ITEMS_HALLOWEEN2023CRYSTALBALL"),   type = "item", limit = -1, canRemove = true},
	["salamandereye"] =             {label = T("ITEMS_SALAMANDEREYE"),              type = "item", limit = -1, canRemove = true},
	["batwings"] =                  {label = T("ITEMS_BATWINGS"),                   type = "item", limit = -1, canRemove = true},
	["mandragoraplant"] =           {label = T("ITEMS_MANDRAGORAPLANT"),            type = "item", limit = -1, canRemove = true},
	["vampireteeth"] =              {label = T("ITEMS_VAMPIRETEETH"),               type = "item", limit = -1, canRemove = true},
	["ravenfeather"] =              {label = T("ITEMS_RAVENFEATHER"),               type = "item", limit = -1, canRemove = true},
	["feather"] =              {label = T("ITEMS_FEATHER"),               type = "item", limit = -1, canRemove = true},
	["blackcatfoot"] =              {label = T("ITEMS_BLACKCATFOOT"),               type = "item", limit = -1, canRemove = true},
	["phantomtears"] =              {label = T("ITEMS_PHANTOMTEARS"),               type = "item", limit = -1, canRemove = true},
	["blackdiamond"] =              {label = T("ITEMS_BLACKDIAMOND"),               type = "item", limit = -1, canRemove = true},
	["bottledblood"] =              {label = T("ITEMS_BOTTLEDBLOOD"),               type = "item", limit = -1, canRemove = true},
	["inertcrystalball"] =          {label = T("ITEMS_INERTCRYSTALBALL"),           type = "item", limit = -1, canRemove = true},

    -- Halloween 2024

    ["halloween2024pumpkin"] =  {label = T("ITEMS_HALLOWEEN2024PUMPKIN"),   type = "item", limit = -1,  canRemove = true},
    ["pumpkin_seed"] =          {label = T("ITEMS_PUMPKIN_SEED"),           type = "item", limit = 100, canRemove = true},
    ["pumpkin"] =               {label = T("ITEMS_PUMPKIN"),                type = "item", limit = 100, canRemove = true},
    ["carved_pumpkin"] =        {label = T("ITEMS_CARVED_PUMPKIN"),         type = "item", limit = 100, canRemove = true},
    ["carved_light_pumpkin"] =  {label = T("ITEMS_CARVED_LIGHT_PUMPKIN"),   type = "item", limit = 100, canRemove = true},
    ["candle"] =                {label = T("ITEMS_CANDLE"),                 type = "item", limit = 100, canRemove = true},

    -- Halloween 2025

    ["halloween2025skull"] =     {label = T("ITEMS_HALLOWEEN2025SKULL"),      type = "item", limit = -1,  canRemove = true},


    -- OReality

    ['enigma1'] =              {label = T("ITEMS_ENIGMA1"),               type = "item", limit = 1, canRemove = true},
    ['enigma2'] =              {label = T("ITEMS_ENIGMA2"),               type = "item", limit = 1, canRemove = true},
    ['enigma3'] =              {label = T("ITEMS_ENIGMA3"),               type = "item", limit = 1, canRemove = true},
    ['enigma4'] =              {label = T("ITEMS_ENIGMA4"),               type = "item", limit = 1, canRemove = true},
    ['enigma5'] =              {label = T("ITEMS_ENIGMA5"),               type = "item", limit = 1, canRemove = true},
    ['enigma6'] =              {label = T("ITEMS_ENIGMA6"),               type = "item", limit = 1, canRemove = true},
    ['enigma7'] =              {label = T("ITEMS_ENIGMA7"),               type = "item", limit = 1, canRemove = true},
    ['enigma8'] =              {label = T("ITEMS_ENIGMA8"),               type = "item", limit = 1, canRemove = true},
    ['enigma9'] =              {label = T("ITEMS_ENIGMA9"),               type = "item", limit = 1, canRemove = true},
    ['enigma10'] =             {label = T("ITEMS_ENIGMA10"),              type = "item", limit = 1, canRemove = true},
    ['enigma11'] =             {label = T("ITEMS_ENIGMA11"),              type = "item", limit = 1, canRemove = true},
    ['enigma12'] =             {label = T("ITEMS_ENIGMA12"),              type = "item", limit = 1, canRemove = true},
    ['enigma13'] =             {label = T("ITEMS_ENIGMA13"),              type = "item", limit = 1, canRemove = true},
    ['enigma14'] =             {label = T("ITEMS_ENIGMA14"),              type = "item", limit = 1, canRemove = true},
    ['enigma15'] =             {label = T("ITEMS_ENIGMA15"),              type = "item", limit = 1, canRemove = true},
    ['enigma16'] =             {label = T("ITEMS_ENIGMA16"),              type = "item", limit = 1, canRemove = true},
    ['secret_clue1'] =         {label = T("ITEMS_SECRET_CLUE1"),          type = "item", limit = 1, canRemove = true},


    --Madeiras

    ["wood_log_cherry"] =           {label = T("ITEMS_WOOD_LOG_CHERRY"),            type = "item", limit =  100, canRemove = true},
	["wet_wood_plank_cherry"] =     {label = T("ITEMS_WET_WOOD_PLANK_CHERRY"),      type = "item", limit =  100, canRemove = true},
	["wood_plank_cherry"] =         {label = T("ITEMS_WOOD_PLANK_CHERRY"),          type = "item", limit =  100, canRemove = true},
	["wood_log_oak"] =              {label = T("ITEMS_WOOD_LOG_OAK"),               type = "item", limit =  100, canRemove = true},
	["wet_wood_plank_oak"] =        {label = T("ITEMS_WET_WOOD_PLANK_OAK"),         type = "item", limit =  100, canRemove = true},
	["wood_plank_oak"] =            {label = T("ITEMS_WOOD_PLANK_OAK"),             type = "item", limit =  100, canRemove = true},
	["wood_log_pine"] =             {label = T("ITEMS_WOOD_LOG_PINE"),              type = "item", limit =  100, canRemove = true},
	["wet_wood_plank_pine"] =       {label = T("ITEMS_WET_WOOD_PLANK_PINE"),        type = "item", limit =  100, canRemove = true},
	["wood_plank_pine"] =           {label = T("ITEMS_WOOD_PLANK_PINE"),            type = "item", limit =  100, canRemove = true},
	["wood_log_ebony"] =            {label = T("ITEMS_WOOD_LOG_EBONY"),             type = "item", limit =  100, canRemove = true},
	["wet_wood_plank_ebony"] =      {label = T("ITEMS_WET_WOOD_PLANK_EBONY"),       type = "item", limit =  100, canRemove = true},
	["wood_plank_ebony"] =          {label = T("ITEMS_WOOD_PLANK_EBONY"),           type = "item", limit =  100, canRemove = true},
    ["wood_dust"] =                 {label = T("ITEMS_WOOD_DUST"),                  type = "item", limit = 1000, canRemove = true},

    -- Corpos de arma

    ["advancedrifle_body"] =     {label = T("ITEMS_ADVANCEDRIFLE_BODY"),        type = "item", limit = 10, canRemove = true},
	["appistol_body"] =          {label = T("ITEMS_APPISTOL_BODY"),             type = "item", limit = 10, canRemove = true},
    ["assaultrifle_body"] =      {label = T("ITEMS_ASSAULTRIFLE_BODY"),         type = "item", limit = 10, canRemove = true},
	["assaultsmg_body"] =        {label = T("ITEMS_ASSAULTSMG_BODY"),           type = "item", limit = 10, canRemove = true},
	["bullpuprifle_body"] =      {label = T("ITEMS_BULLPUPRIFLE_BODY"),         type = "item", limit = 10, canRemove = true},
	["combatpdw_body"] =         {label = T("ITEMS_COMBATPDW_BODY"),            type = "item", limit = 10, canRemove = true},
	["compactrifle_body"] =      {label = T("ITEMS_COMPACTRIFLE_BODY"),         type = "item", limit = 10, canRemove = true},
	["doubleaction_body"] =      {label = T("ITEMS_DOUBLEACTION_BODY"),         type = "item", limit = 10, canRemove = true},
	["gusenberg_body"] =         {label = T("ITEMS_GUSENBERG_BODY"),            type = "item", limit = 10, canRemove = true},
	["heavypistol_body"] =       {label = T("ITEMS_HEAVYPISTOL_BODY"),          type = "item", limit = 10, canRemove = true},
	["machinepistol_body"] =     {label = T("ITEMS_MACHINEPISTOL_BODY"),        type = "item", limit = 10, canRemove = true},
	["microsmg_body"] =          {label = T("ITEMS_MICROSMG_BODY"),             type = "item", limit = 10, canRemove = true},
    ["pistolxm3_body"] =         {label = T("ITEMS_PISTOLXM3_BODY"),            type = "item", limit = 10, canRemove = true},
	["tecpistol_body"] =         {label = T("ITEMS_TECPISTOL_BODY"),            type = "item", limit = 10, canRemove = true},
	["minismg_body"] =           {label = T("ITEMS_MINISMG_BODY"),              type = "item", limit = 10, canRemove = true},
	["pistol50_body"] =          {label = T("ITEMS_PISTOL50_BODY"),             type = "item", limit = 10, canRemove = true},
	["pistol_mk2_body"] =        {label = T("ITEMS_PISTOL_MK2_BODY"),           type = "item", limit = 10, canRemove = true},
	["snspistol_mk2_body"] =     {label = T("ITEMS_SNSPISTOL_MK2_BODY"),        type = "item", limit = 10, canRemove = true},
	["vintagepistol_body"] =     {label = T("ITEMS_VINTAGEPISTOL_BODY"),        type = "item", limit = 10, canRemove = true},
	["heavyrifle_body"] =        {label = T("ITEMS_HEAVYRIFLE_BODY"),           type = "item", limit = 10, canRemove = true},
	["militaryrifle_body"] =     {label = T("ITEMS_MILITARYRIFLE_BODY"),        type = "item", limit = 10, canRemove = true},
	["specialcarbine_body"] =    {label = T("ITEMS_SPECIALCARBINE_BODY"),       type = "item", limit = 10, canRemove = true},
	["bullpupriflemk2_body"] =   {label = T("ITEMS_BULLPUPRIFLEMK2_BODY"),      type = "item", limit = 10, canRemove = true},
	["sawnoffshotgun_body"] =    {label = T("ITEMS_SAWNOFFSHOTGUN_BODY"),       type = "item", limit = 10, canRemove = true},
	["specialcarbinemk2_body"] = {label = T("ITEMS_SPECIALCARBINEMK2_BODY"),    type = "item", limit = 10, canRemove = true},
    ["weapon_module"] =          {label = T("ITEMS_WEAPON_MODULE"),             type = "item", limit = 10, canRemove = true},

	-- Prints

	["weapon_body"] =  {label = T("ITEMS_WEAPON_BODY"),     type = "item", limit = 10, canRemove = true},
	["weapon_body2"] = {label = T("ITEMS_WEAPON_BODY2"),    type = "item", limit = 10, canRemove = true},
	["weapon_body3"] = {label = T("ITEMS_WEAPON_BODY3"),    type = "item", limit = 10, canRemove = true},
	["weapon_body4"] = {label = T("ITEMS_WEAPON_BODY4"),    type = "item", limit = 10, canRemove = true},

    -- Carregadores

	["micro_clip"] =              {label = T("ITEMS_MICRO_CLIP"),           type = "item", limit = 30, canRemove = true}, 
	["tec9_clip"] =               {label = T("ITEMS_TEC9_CLIP"),            type = "item", limit = 30, canRemove = true},
	["tecpistol_clip"] =          {label = T("ITEMS_TECPISTOL_CLIP"),       type = "item", limit = 30, canRemove = true},
	["appistol_clip"] =           {label = T("ITEMS_APPISTOL_CLIP"),        type = "item", limit = 30, canRemove = true},
	["heavypistol_clip"] =        {label = T("ITEMS_HEAVYPISTOL_CLIP"),     type = "item", limit = 30, canRemove = true},
	["pistol50_clip"] =           {label = T("ITEMS_PISTOL50_CLIP"),        type = "item", limit = 30, canRemove = true},
	["gusenberg_clip"] =          {label = T("ITEMS_GUSENBERG_CLIP"),       type = "item", limit = 30, canRemove = true},
	["assaultsmg_clip"] =         {label = T("ITEMS_ASSAULTSMG_CLIP"),      type = "item", limit = 30, canRemove = true},
	["pdw_clip"] =                {label = T("ITEMS_PDW_CLIP"),             type = "item", limit = 30, canRemove = true},
	["bullpup_clip"] =            {label = T("ITEMS_BULLPUP_CLIP"),         type = "item", limit = 30, canRemove = true},
	["specialcarbine_clip"] =     {label = T("ITEMS_SPECIALCARBINE_CLIP"),  type = "item", limit = 30, canRemove = true},
	["assaultrifle_clip"] =       {label = T("ITEMS_ASSAULTRIFLE_CLIP"),    type = "item", limit = 30, canRemove = true},
	["compactrifle_clip"] =       {label = T("ITEMS_COMPACTRIFLE_CLIP"),    type = "item", limit = 30, canRemove = true},
    ["carbinerifle_clip"] =       {label = T("ITEMS_CARBINERIFLE_CLIP"),    type = "item", limit = 30, canRemove = true},
    ["combatpistol_clip"] =       {label = T("ITEMS_COMBATPISTOL_CLIP"),    type = "item", limit = 30, canRemove = true},
    ["heavyrifle_clip"] =         {label = T("ITEMS_HEAVYRIFLE_CLIP"),      type = "item", limit = 30, canRemove = true},
    ["pistol_clip"] =             {label = T("ITEMS_PISTOL_CLIP"),          type = "item", limit = 30, canRemove = true}, 
    ["smg_clip"] =                {label = T("ITEMS_SMG_CLIP"),             type = "item", limit = 30, canRemove = true},
    ["sns_clip"] =                {label = T("ITEMS_SNS_CLIP"),             type = "item", limit = 30, canRemove = true}, 
    ["tactical_clip"] =           {label = T("ITEMS_TACTICAL_CLIP"),        type = "item", limit = 30, canRemove = true},
    ["vintage_clip"] =            {label = T("ITEMS_VINTAGE_CLIP"),         type = "item", limit = 30, canRemove = true},

    ["clip"] =                    {label = T("ITEMS_CLIP"),         type = "item", limit = 25, canRemove = true},
	["clip12"] =                  {label = T("ITEMS_CLIP12"),       type = "item", limit = 25, canRemove = true},
	["clip45"] =                  {label = T("ITEMS_CLIP45"),       type = "item", limit = 25, canRemove = true},
	["clip556"] =                 {label = T("ITEMS_CLIP556"),      type = "item", limit = 25, canRemove = true},
	["clip762"] =                 {label = T("ITEMS_CLIP762"),      type = "item", limit = 25, canRemove = true},
	["clip9"] =                   {label = T("ITEMS_CLIP9"),        type = "item", limit = 25, canRemove = true},
    ["clip_rubber"] =             {label = T("ITEMS_CLIP_RUBBER"),  type = "item", limit = 25, canRemove = true},
    ["mec12"] =                   {label = T("ITEMS_MEC12"),        type = "item", limit = -1, canRemove = true},

    -- Carregadores extensivos

	["micro_extended"] =          {label = T("ITEMS_MICRO_EXTENDED"),           type = "item", limit = 30, canRemove = true, attachment = "micro_extended"},
	["tec9_extended"] =           {label = T("ITEMS_TEC9_EXTENDED"),            type = "item", limit = 30, canRemove = true, attachment = "tec9_extended"},
	["appistol_extended"] =       {label = T("ITEMS_APPISTOL_EXTENDED"),        type = "item", limit = 30, canRemove = true, attachment = "appistol_extended"},
	["heavypistol_extended"] =    {label = T("ITEMS_HEAVYPISTOL_EXTENDED"),     type = "item", limit = 30, canRemove = true, attachment = "heavypistol_extended"},
	["pistol50_extended"] =       {label = T("ITEMS_PISTOL50_EXTENDED"),        type = "item", limit = 30, canRemove = true, attachment = "pistol50_extended"},
	["gusenberg_extended"] =      {label = T("ITEMS_GUSENBERG_EXTENDED"),       type = "item", limit = 30, canRemove = true, attachment = "gusenberg_extended"},
	["pdw_extended"] =            {label = T("ITEMS_PDW_EXTENDED"),             type = "item", limit = 30, canRemove = true, attachment = "pdw_extended"},
	["assaultsmg_extended"] =     {label = T("ITEMS_ASSAULTSMG_EXTENDED"),      type = "item", limit = 30, canRemove = true, attachment = "assaultsmg_extended"},
	["bullpup_extended"] =        {label = T("ITEMS_BULLPUP_EXTENDED"),         type = "item", limit = 30, canRemove = true, attachment = "bullpup_extended"},
	["specialcarbine_extended"] = {label = T("ITEMS_SPECIALCARBINE_EXTENDED"),  type = "item", limit = 30, canRemove = true, attachment = "specialcarbine_extended"},
	["assaultrifle_extended"] =   {label = T("ITEMS_ASSAULTRIFLE_EXTENDED"),    type = "item", limit = 30, canRemove = true, attachment = "assaultrifle_extended"},
	["compactrifle_extended"] =   {label = T("ITEMS_COMPACTRIFLE_EXTENDED"),    type = "item", limit = 30, canRemove = true, attachment = "compactrifle_extended"},
    ["carbinerifle_extended"] =   {label = T("ITEMS_CARBINERIFLE_EXTENDED"),    type = "item", limit = 30, canRemove = true, attachment = "carbinerifle_extended"},
    ["combatpistol_extended"] =   {label = T("ITEMS_COMBATPISTOL_EXTENDED"),    type = "item", limit = 30, canRemove = true, attachment = "combatpistol_extended"},
    ["heavyrifle_extended"] =     {label = T("ITEMS_HEAVYRIFLE_EXTENDED"),      type = "item", limit = 30, canRemove = true, attachment = "heavyrifle_extended"},
    ["pistol_extended"] =         {label = T("ITEMS_PISTOL_EXTENDED"),          type = "item", limit = 30, canRemove = true, attachment = "pistol_extended"},
    ["smg_extended"] =            {label = T("ITEMS_SMG_EXTENDED"),             type = "item", limit = 30, canRemove = true, attachment = "smg_extended"},
    ["sns_extended"] =            {label = T("ITEMS_SNS_EXTENDED"),             type = "item", limit = 30, canRemove = true, attachment = "sns_extended"},
    ["tactical_extended"] =       {label = T("ITEMS_TACTICAL_EXTENDED"),        type = "item", limit = 30, canRemove = true, attachment = "tactical_extended"},
    ["vintage_extended"] =        {label = T("ITEMS_VINTAGE_EXTENDED"),         type = "item", limit = 30, canRemove = true, attachment = "vintage_extended"},

    -- Magazines

	["tec9_mag"] =                {label = T("ITEMS_TEC9_MAG"),             type = "item", limit = 30, canRemove = true,  attachment = "tec9_mag"},
	["pdw_mag"] =                 {label = T("ITEMS_PDW_MAG"),              type = "item", limit = 30, canRemove = true,  attachment = "pdw_mag"},
	["compatrifle_mag"] =         {label = T("ITEMS_COMPACTRIFLE_MAG"),      type = "item", limit = 30, canRemove = true, attachment = "compatrifle_mag"},
	["assaultrifle_mag"] =        {label = T("ITEMS_ASSAULTRIFLE_MAG"),     type = "item", limit = 30, canRemove = true,  attachment = "assaultrifle_mag"},
	["specialcarbine_mag"] =      {label = T("ITEMS_SPECIALCARBINE_MAG"),   type = "item", limit = 30, canRemove = true,  attachment = "specialcarbine_mag"},
    ["carbinerifle_mag"] =        {label = T("ITEMS_CARBINERIFLE_MAG"),     type = "item", limit = 30, canRemove = true,  attachment = "carbinerifle_mag"},
    ["smg_mag"] =                 {label = T("ITEMS_SMG_MAG"),              type = "item", limit = 30, canRemove = true,  attachment = "smg_mag"},

    -- Barrel

    ["carbinerifle_barrel"] =     {label = T("ITEMS_CARBINERIFLE_BARREL"),              type = "item", limit = 30, canRemove = true, attachment = "carbinerifle_barrel"},
    ["assaultrifle_barrel"] =     {label = T("ITEMS_ASSAULTRIFLE_BARREL"),              type = "item", limit = 30, canRemove = true, attachment = "assaultrifle_barrel"},
    ["bullpuprifle_barrel"] =     {label = T("ITEMS_BULLPUPRIFLE_BARREL"),              type = "item", limit = 30, canRemove = true, attachment = "bullpuprifle_barrel"},
    ["specialcarbine_barrel"] =   {label = T("ITEMS_SPECIALCARBINE_BARREL"),            type = "item", limit = 30, canRemove = true, attachment = "specialcarbine_barrel"},

    -- Compensators

    ["compensator1"] =      {label = T("ITEMS_COMPENSATOR1"),      type = "item", limit = 30, canRemove = true, attachment = "compensator1"},
    ["compensator2"] =      {label = T("ITEMS_COMPENSATOR2"),      type = "item", limit = 30, canRemove = true, attachment = "compensator2"},
    ["compensator4"] =      {label = T("ITEMS_COMPENSATOR4"),      type = "item", limit = 30, canRemove = true, attachment = "compensator4"},
    ["compensator5"] =      {label = T("ITEMS_COMPENSATOR5"),      type = "item", limit = 30, canRemove = true, attachment = "compensator5"},
    ["compensator6"] =      {label = T("ITEMS_COMPENSATOR6"),      type = "item", limit = 30, canRemove = true, attachment = "compensator6"},
    ["compensator7"] =      {label = T("ITEMS_COMPENSATOR7"),      type = "item", limit = 30, canRemove = true, attachment = "compensator7"},
    ["compensator8"] =      {label = T("ITEMS_COMPENSATOR8"),      type = "item", limit = 30, canRemove = true, attachment = "compensator8"},
    ["compensator9"] =      {label = T("ITEMS_COMPENSATOR9"),      type = "item", limit = 30, canRemove = true, attachment = "compensator9"},
    ["compensator10"] =     {label = T("ITEMS_COMPENSATOR10"),     type = "item", limit = 30, canRemove = true, attachment = "compensator10"},

    -- Suppressor

    ["suppressor1"] =     {label = T("ITEMS_SUPPRESSOR1"),     type = "item", limit = 30, canRemove = true, attachment = "suppressor1"},
    ["suppressor2"] =     {label = T("ITEMS_SUPPRESSOR2"),     type = "item", limit = 30, canRemove = true, attachment = "suppressor2"},
    ["suppressor3"] =     {label = T("ITEMS_SUPPRESSOR3"),     type = "item", limit = 30, canRemove = true, attachment = "suppressor3"},
    ["suppressor4"] =     {label = T("ITEMS_SUPPRESSOR4"),     type = "item", limit = 30, canRemove = true, attachment = "suppressor4"},
    ["suppressor6"] =     {label = T("ITEMS_SUPPRESSOR6"),     type = "item", limit = 30, canRemove = true, attachment = "suppressor6"},

    -- Flashlight

    ["flashlight1"] =     {label = T("ITEMS_FLASHLIGHT1"),     type = "item", limit = 30, canRemove = true, attachment = "flashlight1"},
    ["flashlight2"] =     {label = T("ITEMS_FLASHLIGHT2"),     type = "item", limit = 30, canRemove = true, attachment = "flashlight2"},
    ["flashlight3"] =     {label = T("ITEMS_FLASHLIGHT3"),     type = "item", limit = 30, canRemove = true, attachment = "flashlight3"},
    ["flashlight4"] =     {label = T("ITEMS_FLASHLIGHT4"),     type = "item", limit = 30, canRemove = true, attachment = "flashlight4"},
    ["flashlight5"] =     {label = T("ITEMS_FLASHLIGHT5"),     type = "item", limit = 30, canRemove = true, attachment = "flashlight5"},

    -- Scope

    ["scope1"] =     {label = T("ITEMS_SCOPE1"),     type = "item", limit = 30, canRemove = true, attachment = "scope1"},
    ["scope2"] =     {label = T("ITEMS_SCOPE2"),     type = "item", limit = 30, canRemove = true, attachment = "scope2"},
    ["scope3"] =     {label = T("ITEMS_SCOPE3"),     type = "item", limit = 30, canRemove = true, attachment = "scope3"},
    ["scope4"] =     {label = T("ITEMS_SCOPE4"),     type = "item", limit = 30, canRemove = true, attachment = "scope4"},
    ["scope6"] =     {label = T("ITEMS_SCOPE6"),     type = "item", limit = 30, canRemove = true, attachment = "scope6"},
    ["scope7"] =     {label = T("ITEMS_SCOPE7"),     type = "item", limit = 30, canRemove = true, attachment = "scope7"},
    ["scope8"] =     {label = T("ITEMS_SCOPE8"),     type = "item", limit = 30, canRemove = true, attachment = "scope8"},
    ["scope9"] =     {label = T("ITEMS_SCOPE9"),     type = "item", limit = 30, canRemove = true, attachment = "scope9"},
    ["scope10"] =    {label = T("ITEMS_SCOPE10"),    type = "item", limit = 30, canRemove = true, attachment = "scope10"},
    ["scope11"] =    {label = T("ITEMS_SCOPE11"),    type = "item", limit = 30, canRemove = true, attachment = "scope11"},

    -- Grip

    ["grip1"] =    {label = T("ITEMS_GRIP1"),    type = "item", limit = 30, canRemove = true, attachment = "grip1"},
    ["grip2"] =    {label = T("ITEMS_GRIP2"),    type = "item", limit = 30, canRemove = true, attachment = "grip2"},

    -- Silencers

    ["suppressor"] =              {label = T("ITEMS_SUPPRESSOR"),       type = "item", limit = 10, canRemove = true, attachment = "suppressor"},
    ["grip"] =                    {label = T("ITEMS_GRIP"),             type = "item", limit = 10, canRemove = true, attachment = "grip"},
	["flashlight"] =              {label = T("ITEMS_FLASHLIGHT"),       type = "item", limit = 5,  canRemove = true, attachment = "flashlight"},

    -- Ores

    ["steel"] =                         {label = T("ITEMS_STEEL"),                          type = "item", limit = 100, canRemove = true},
	["coal_ore"] =                      {label = T("ITEMS_COAL_ORE"),                       type = "item", limit = 100, canRemove = true}, --(C240H90O4NS)
	["coal_dust"] =                     {label = T("ITEMS_COAL_DUST"),                      type = "item", limit = 100, canRemove = true},
	["coal_coke"] =                     {label = T("ITEMS_COAL_COKE"),                      type = "item", limit = 100, canRemove = true},
	["coal"] =                          {label = T("ITEMS_COAL"),                           type = "item", limit = 100, canRemove = true},
	["iron_ore"] =                      {label = T("ITEMS_IRON_ORE"),                       type = "item", limit = 100, canRemove = true}, --(Fe2O3)
	["crushed_iron_ore"] =              {label = T("ITEMS_CRUSHED_IRON_ORE"),               type = "item", limit = 100, canRemove = true}, --Obtained through maceration
	["purified_crushed_iron_ore"] =     {label = T("ITEMS_PURIFIED_CRUSHED_IRON_ORE"),      type = "item", limit = 100, canRemove = true}, --Obtained through washing
	["iron_dust"] =                     {label = T("ITEMS_IRON_DUST"),                      type = "item", limit = 100, canRemove = true}, --Thermal centrifuge
	["iron_nugget"] =                   {label = T("ITEMS_IRON_NUGGET"),                    type = "item", limit = 100, canRemove = true}, -- 5 pepitas = 1 dust
	["iron"] =                          {label = T("ITEMS_IRON"),                           type = "item", limit = 100, canRemove = true}, --Smelting
	["copper_ore"] =                    {label = T("ITEMS_COPPER_ORE"),                     type = "item", limit = 100, canRemove = true}, --(CuFeS2)
	["crushed_copper_ore"] =            {label = T("ITEMS_CRUSHED_COPPER_ORE"),             type = "item", limit = 100, canRemove = true}, --Obtained through maceration
	["purified_crushed_copper_ore"] =   {label = T("ITEMS_PURIFIED_CRUSHED_COPPER_ORE"),    type = "item", limit = 100, canRemove = true}, --Obtained through washing
	["copper_dust"] =                   {label = T("ITEMS_COPPER_DUST"),                    type = "item", limit = 100, canRemove = true}, --Thermal centrifuge
	["copper_nugget"] =                 {label = T("ITEMS_COPPER_NUGGET"),                  type = "item", limit = 100, canRemove = true}, -- 5 pepitas = 1 dust
	["copper"] =                        {label = T("ITEMS_COPPER"),                         type = "item", limit = 100, canRemove = true}, --Smelting
	["tin_ore"] =                       {label = T("ITEMS_TIN_ORE"),                        type = "item", limit = 100, canRemove = true}, --(SnO2)
	["crushed_tin_ore"] =               {label = T("ITEMS_CRUSHED_TIN_ORE"),                type = "item", limit = 100, canRemove = true}, --Obtained through maceration
	["purified_crushed_tin_ore"] =      {label = T("ITEMS_PURIFIED_CRUSHED_TIN_ORE"),       type = "item", limit = 100, canRemove = true}, --Obtained through washing
	["tin_dust"] =                      {label = T("ITEMS_TIN_DUST"),                       type = "item", limit = 100, canRemove = true}, --Thermal centrifuge
	["tin_nugget"] =                    {label = T("ITEMS_TIN_NUGGET"),                     type = "item", limit = 100, canRemove = true}, -- 5 pepitas = 1 dust
	["tin_ingot"] =                     {label = T("ITEMS_TIN_INGOT"),                      type = "item", limit = 100, canRemove = true}, --Smelting
	["gold_ore"] =                      {label = T("ITEMS_GOLD_ORE"),                       type = "item", limit = 100, canRemove = true}, --(Au)
	["crushed_gold_ore"] =              {label = T("ITEMS_CRUSHED_GOLD_ORE"),               type = "item", limit = 100, canRemove = true}, --Obtained through maceration
	["purified_crushed_gold_ore"] =     {label = T("ITEMS_PURIFIED_CRUSHED_GOLD_ORE"),      type = "item", limit = 100, canRemove = true}, --Obtained through washing
	["gold_dust"] =                     {label = T("ITEMS_GOLD_DUST"),                      type = "item", limit = 100, canRemove = true}, --Thermal centrifuge
	["gold_nugget"] =                   {label = T("ITEMS_GOLD_NUGGET"),                    type = "item", limit = 100, canRemove = true}, -- 5 pepitas = 1 dust
	["gold_ingot"] =                    {label = T("ITEMS_GOLD_INGOT"),                     type = "item", limit = 100, canRemove = true}, --Smelting
	["rhodium_ore"] =                   {label = T("ITEMS_RHODIUM_ORE"),                    type = "item", limit = 100, canRemove = true}, --(RhCl3)
	["crushed_rhodium_ore"] =           {label = T("ITEMS_CRUSHED_RHODIUM_ORE"),            type = "item", limit = 100, canRemove = true}, --Obtained through maceration
	["purified_crushed_rhodium_ore"] =  {label = T("ITEMS_PURIFIED_CRUSHED_RHODIUM_ORE"),   type = "item", limit = 100, canRemove = true}, --Obtained through washing
	["rhodium_dust"] =                  {label = T("ITEMS_RHODIUM_DUST"),                   type = "item", limit = 100, canRemove = true}, --Thermal centrifuge
	["rhodium_nugget"] =                {label = T("ITEMS_RHODIUM_NUGGET"),                 type = "item", limit = 100, canRemove = true}, -- 5 pepitas = 1 dust
	["rhodium_ingot"] =                 {label = T("ITEMS_RHODIUM_INGOT"),                  type = "item", limit = 100, canRemove = true}, --Smelting
	["platinum_ore"] =                  {label = T("ITEMS_PLATINUM_ORE"),                   type = "item", limit = 100, canRemove = true}, --(PtBiTe)
	["crushed_platinum_ore"] =          {label = T("ITEMS_CRUSHED_PLATINUM_ORE"),           type = "item", limit = 100, canRemove = true}, --Obtained through maceration
	["purified_crushed_platinum_ore"] = {label = T("ITEMS_PURIFIED_CRUSHED_PLATINUM_ORE"),  type = "item", limit = 100, canRemove = true}, --Obtained through washing
	["platinum_dust"] =                 {label = T("ITEMS_PLATINUM_DUST"),                  type = "item", limit = 100, canRemove = true}, --Thermal centrifuge
	["platinum_nugget"] =               {label = T("ITEMS_PLATINUM_NUGGET"),                type = "item", limit = 100, canRemove = true}, -- 5 pepitas = 1 dust
	["platinum_ingot"] =                {label = T("ITEMS_PLATINUM_INGOT"),                 type = "item", limit = 100, canRemove = true}, --Smelting
	["lithium_ore"] =                   {label = T("ITEMS_LITHIUM_ORE"),                    type = "item", limit = 100, canRemove = true}, --(LiAlSi4O10)
	["crushed_lithium_ore"] =           {label = T("ITEMS_CRUSHED_LITHIUM_ORE"),            type = "item", limit = 100, canRemove = true}, --Obtained through maceration
	["purified_crushed_lithium_ore"] =  {label = T("ITEMS_PURIFIED_CRUSHED_LITHIUM_ORE"),   type = "item", limit = 100, canRemove = true}, --Obtained through washing
	["lithium_dust"] =                  {label = T("ITEMS_LITHIUM_DUST"),                   type = "item", limit = 100, canRemove = true}, --Thermal centrifuge
	["lithium_nugget"] =                {label = T("ITEMS_LITHIUM_NUGGET"),                 type = "item", limit = 100, canRemove = true}, -- 5 pepitas = 1 dust
	["lithium_ingot"] =                 {label = T("ITEMS_LITHIUM_INGOT"),                  type = "item", limit = 100, canRemove = true}, --Smelting
	["bronze_dust"] =                   {label = T("ITEMS_BRONZE_DUST"),                    type = "item", limit = 100, canRemove = true}, --(SnCu3)
	["bronze_nugget"] =                 {label = T("ITEMS_BRONZE_NUGGET"),                  type = "item", limit = 100, canRemove = true}, -- 5 pepitas = 1 dust
	["bronze_ingot"] =                  {label = T("ITEMS_BRONZE_INGOT"),                   type = "item", limit = 100, canRemove = true}, --Smelting
	["raw_ruby"] =                      {label = T("ITEMS_RAW_RUBY"),                       type = "item", limit = 100, canRemove = true}, --(CrAl2O3)
	["ruby"] =                          {label = T("ITEMS_RUBY"),                           type = "item", limit = 100, canRemove = true},
    ["ruby_pile"] =                     {label = T("ITEMS_RUBY_PILE"),                      type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "ruby_bag", count = 5}},
	["ruby_bag"] =                      {label = T("ITEMS_RUBY_BAG"),                       type = "item", limit = 100, canRemove = true},
	["raw_emerald"] =                   {label = T("ITEMS_RAW_EMERALD"),                    type = "item", limit = 100, canRemove = true}, --(Be3Al2Si6O18)
	["emerald"] =                       {label = T("ITEMS_EMERALD"),                        type = "item", limit = 100, canRemove = true},
	["emerald_pile"] =                  {label = T("ITEMS_EMERALD_PILE"),                   type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "emerald_bag", count = 5}},
	["emerald_bag"] =                   {label = T("ITEMS_EMERALD_BAG"),                    type = "item", limit = 100, canRemove = true},
	["raw_diamond"] =                   {label = T("ITEMS_RAW_DIAMOND"),                    type = "item", limit = 100, canRemove = true}, --(C)
	["diamond"] =                       {label = T("ITEMS_DIAMOND"),                        type = "item", limit = 100, canRemove = true},
	["diamond_pile"] =                  {label = T("ITEMS_DIAMOND_PILE"),                   type = "item", limit = 100, canRemove = true, packable = {bag = "bag", item = "diamond_bag", count = 5}},
	["diamond_bag"] =                   {label = T("ITEMS_DIAMOND_BAG"),                    type = "item", limit = 100, canRemove = true},
	["boulder"] =                       {label = T("ITEMS_BOULDER"),                        type = "item", limit = 100, canRemove = true},
	["boulder_dust"] =                  {label = T("ITEMS_BOULDER_DUST"),                   type = "item", limit = 100, canRemove = true},

    ["cash"] =                  {label = T("CURRENCY_CASH"),                   type = "money", limit = -1, canRemove = true},
    ["black_money"] =           {label = T("CURRENCY_BLACK_MONEY"),            type = "money", limit = -1, canRemove = true},
    ["chipss"] =                {label = T("ITEMS_CHIPSS"),                    type = "money", limit = -1, canRemove = true},
    ["atlantis_chips"] =        {label = T("ITEMS_ATLANTIS_CHIPS"),            type = "money", limit = -1, canRemove = true},
    ["tuning_chip_1"] =        {label = "Chip Nivel 1",            type = "item", limit = -1, canRemove = true},
    ["tuning_chip_2"] =        {label = "Chip Nivel 2",            type = "item", limit = -1, canRemove = true},
    ["tuning_chip_3"] =        {label = "Chip Nivel 3",            type = "item", limit = -1, canRemove = true},
    ["tuning_chip_4"] =        {label = "Chip Nivel 4",            type = "item", limit = -1, canRemove = true},
    ["tuning_chip_5"] =        {label = "Chip Nivel 5",            type = "item", limit = -1, canRemove = true},
    ["fibra"] =        {label = "Fibra",            type = "item", limit = 100, canRemove = true},
    ["aluminio"] =        {label = "Aluminio",            type = "item", limit = 100, canRemove = true},
    ["oxido_nitroso"] =        {label = "Botija de óxido nitroso",            type = "item", limit = 100, canRemove = true},
    ["sacolixo"] =        {label = "Saco de lixo",            type = "item", limit = 100, canRemove = true},
    ["vidro"] =        {label = "Vidro",            type = "item", limit = 100, canRemove = true},
}
