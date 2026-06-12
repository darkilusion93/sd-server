--const ironFireSword = new ItemStack(MinecraftItemTypes.DiamondSword, 1);
--new ItemStack(itemType: ItemType | string, amount?: number)

function ItemStack(itemType, amount)
    local self = {}

    -- Number of the items in the stack. Valid values range between 1-255. The provided value will be clamped to the item's maximum stack size.
    self.amount = math.min(amount or 1, itemType.limit == -1 and 2147483647 or itemType.limit)
    self.maxAmount = itemType.limit

    -- Returns whether the item is stackable. An item is considered stackable if the item's maximum stack size is greater than 1 and the item does not contain any custom data or properties.
    self.isStackable = itemType.limit ~= 1

    -- Set other properties
    self.keepOnDeath = itemType.keepOnDeath
    self.lockMode = "none"
    self.nameTag = ""
    self.id = itemType.id  -- id of item
    self.components = itemType.components
    self.properties = {}

    --Clears all dynamic properties that have been set on this item stack.
    self.clearDynamicProperties = function()
        self.properties = {}
    end

    self.clone = function()
        return self
    end

    --Gets a component (that represents additional capabilities) for an item stack.
    self.getComponent = function(componentId)
        --https://learn.microsoft.com/en-us/minecraft/creator/scriptapi/minecraft/server/itemcomponent?view=minecraft-bedrock-stable
        for _, component in ipairs(self.components) do
            if component.id == componentId then
                return component
            end
        end
        return nil
    end

    --Returns all components that are both present on this item stack and supported by the API.
    self.getComponents = function()
        return self.components
    end

    self.getDynamicProperty = function(key)
        return self.properties[key]
    end

    self.getDynamicPropertyIds = function()
        local keys = {}
        for key, _ in pairs(self.properties) do
            table.insert(keys, key)
        end
        return keys
    end

    self.hasComponent = function(componentId)
        for _, component in ipairs(self.components) do
            if component.id == componentId then
                return true
            end
        end
        return false
    end

    --Returns whether this item stack can be stacked with the given itemStack. This is determined by comparing the item type and any custom data and properties associated with the item stacks. The amount of each item stack is not taken into consideration.
    self.isStackableWith = function(itemStack)
        if not self.isStackable or not itemStack.isStackable then
            return false
        end

        if self.id ~= itemStack.id then
            return false
        end

        return true
    end

    --Sets a specified property to a value. Note: This function only works with non-stackable items.
    self.setDynamicProperty = function(key, value)
        if not self.isStackable then
            self.properties[key] = value
        end
    end


    return self
end