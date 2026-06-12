

local inventories, sharedInventories = {}, {}

function GetSharedInventory(name)
	if sharedInventories[name] == nil then
		sharedInventories[name] = CreateInventory("storage", name, -1)
	end

	return sharedInventories[name]
end

function GetInventory(name, owner, weight)
    if inventories[name] == nil then
        inventories[name] = {}
    end

    if weight == nil then
        weight = -1
    end

	if inventories[name][owner] == nil then
		inventories[name][owner] = CreateInventory("storage", string.format("%s_%s", name, owner), weight)
	end

	return inventories[name][owner]
end