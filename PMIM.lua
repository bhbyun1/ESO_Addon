PMIM = {}

NAME = "PMIM"
VERSION = 1

PMIM.name = "PMIM"
PMIM.version = "0.0.1"
PMIM.defaultSettings = {
    toSell = {
        sellEmptyGems = false,
        sellOrnateGear = false,
        sellLowRepairs = false,
        sellIntricateGear = false,
        sellGlyphs = false,
        sellLowMats = false,

    },
    toBank = {
        bankHighMats = true,
        bankHighRepairs = true,
        bankTempers = true,
        bankWrits = true,
    },
}

function PMIM.getName()
    return NAME
end

function PMIM.getVersion()
    return VERSION
end

function PMIM.filterToJunk(itemId, itemType, itemQuality, itemLevel, itemName, itemTrait, bagType, slotIndex)
    --Checks if the setting is on, then checks if the item ID is the soul gem (empty) item ID [33265]
    if PMIM.preferences.toSell.sellEmptyGems then
        if itemId == 33265 then
            SetItemIsJunk(bagType, slotIndex, true)
            return
        end
    end
    --Checks if the setting is on, then checks if the item type is any sort of glyph
    --Afterwards, checks if the item is magic (green) rarity or less
    if PMIM.preferences.toSell.sellGlyphs then
        if (itemType == ITEMTYPE_GLYPH_ARMOR or itemType == ITEMTYPE_GLYPH_JEWELRY or itemType == ITEMTYPE_GLYPH_WEAPON) then
            if (itemQuality <= ITEM_FUNCTIONAL_QUALITY_MAGIC) then
                SetItemIsJunk(bagType, slotIndex, true)
            end
            return
        end
    end
    --Checks if the setting is on, then checks if the item type is a tool, and if the item quality is magic (green)
    --Afterwards, checks if the item level is neither 50 nor nil, excluding max level repair kits
    if PMIM.preferences.toSell.sellLowRepairs then
        if (itemType == ITEMTYPE_TOOL and itemQuality == ITEM_FUNCTIONAL_QUALITY_MAGIC) then
            if (itemLevel ~= 50 and itemLevel ~= nil) then
                SetItemIsJunk(bagType, slotIndex, true)
            end
            return
        end
    end
    --Checks if the setting is on, then checks if item type is a refined crafting material
    --Afterwards, checks if the item names match any of the max level crafting materials
    if PMIM.preferences.toSell.sellLowMats then
        if (itemType == ITEMTYPE_BLACKSMITHING_MATERIAL or itemType == ITEMTYPE_CLOTHIER_MATERIAL or itemType == ITEMTYPE_WOODWORKING_MATERIAL or itemType == ITEMTYPE_JEWELRYCRAFTING_MATERIAL) then
            if (itemName == "Sanded Ruby Ash^ns" or itemName == "platinum ounce" or itemName == "Rubedite Ingot" or itemName == "Rubedo Leather^ns" or itemName == "Ancestor Silk^ns") then
                return
            else
                SetItemIsJunk(bagType, slotIndex, true)
            end
            return
        end
    end
    --Checks if the setting is on, then checks if the item trait is ornate
    if PMIM.preferences.toSell.sellOrnateGear then
        if (itemTrait == ITEM_TRAIT_TYPE_WEAPON_ORNATE or itemTrait == ITEM_TRAIT_TYPE_ARMOR_ORNATE or itemTrait == ITEM_TRAIT_TYPE_JEWELRY_ORNATE) then
            SetItemIsJunk(bagType, slotIndex, true)
            return
        end
    end
    --Checks if the setting is on, then checks if the item trait is intricate
    if PMIM.preferences.toSell.sellIntricateGear then
        if (itemTrait == ITEM_TRAIT_TYPE_WEAPON_INTRICATE or itemTrait == ITEM_TRAIT_TYPE_ARMOR_INTRICATE or itemTrait == ITEM_TRAIT_TYPE_JEWELRY_INTRICATE) then
            SetItemIsJunk(bagType, slotIndex, true)
            return
        end
    end
end

--Iterates through the backpack inventory (1), then running the filter command to mark certain items as junk
function PMIM.scanInventory(bagType)
    for slotIndex = 1, GetBagSize(1) do
        local itemId = GetItemId(bagType, slotIndex)
        local itemType = GetItemType(bagType, slotIndex)
        local itemQuality = GetItemFunctionalQuality(bagType, slotIndex)
        local itemLevel = GetItemLevel(bagType, slotIndex)
        local itemLink = GetItemLink(bagType, slotIndex)
        local itemName = GetItemLinkName(itemLink)
        local itemTrait = GetItemTrait(bagType, slotIndex)
        if itemId ~= 0 and CanItemBeMarkedAsJunk(bagType, slotIndex) then
            PMIM.filterToJunk(itemId, itemType, itemQuality, itemLevel, itemName, itemTrait, bagType, slotIndex)
        end
    end
end

--Creates the pscan and psell slash commands, used for scanning the inventory to mark certain items as junk
--as well as selling said junk when in the merchant scene
function PMIM:Initialize()
    self.preferences = ZO_SavedVars:NewAccountWide("PMIMSavedVariables", 1, nil, PMIM.defaultSettings)
    SLASH_COMMANDS["/pscan"] = function() PMIM.scanInventory(1) end
    SLASH_COMMANDS["/psell"] = function() PMIM.sellJunk(1) end
    PMIM.InitSettings()
end

function PMIM.sellJunk(bagType)
    for slotIndex = 1, GetBagSize(bagType) do
        if IsItemJunk(bagType, slotIndex) then
            local itemStack, _ = GetSlotStackSize(bagType, slotIndex)
            SellInventoryItem(bagType, slotIndex, itemStack)
        end
    end
end

function PMIM.OnAddonLoaded(event, addonName)
    if addonName == NAME then
        PMIM:Initialize()
    end
end

--Triggers when addon is loaded
EVENT_MANAGER:RegisterForEvent(PMIM.name, EVENT_ADD_ON_LOADED, PMIM.OnAddonLoaded)