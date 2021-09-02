PMIM = {}
--local PMIM = PMIM

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
        bankReagents = true,
    },
}

function PMIM.getName()
    return NAME
end

function PMIM.getVersion()
    return VERSION
end

function PMIM:Initialize()
    self.preferences = ZO_SavedVars:NewAccountWide("PMIMSavedVariables", 1, nil, PMIM.defaultSettings)
    SLASH_COMMANDS["/pscan"] = function() PMIM.scanInventory(1) end
    SLASH_COMMANDS["/psell"] = function() PMIM.sellJunk(1) end
    SLASH_COMMANDS["/pbank"] = function() PMIM.bankItems(1, BAG_BANK) end
    PMIM.InitSettings()
end

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

function PMIM.filterToJunk(itemId, itemType, itemQuality, itemLevel, itemName, itemTrait, bagType, slotIndex)
    if PMIM.preferences.toSell.sellEmptyGems then
        if itemId == 33265 then
            SetItemIsJunk(bagType, slotIndex, true)
            return
        end
    end
    if PMIM.preferences.toSell.sellGlyphs then
        if (itemType == ITEMTYPE_GLYPH_ARMOR or itemType == ITEMTYPE_GLYPH_JEWELRY or itemType == ITEMTYPE_GLYPH_WEAPON) then
            if (itemQuality <= ITEM_FUNCTIONAL_QUALITY_MAGIC) then
                SetItemIsJunk(bagType, slotIndex, true)
            end
            return
        end
    end
    if PMIM.preferences.toSell.sellLowRepairs then
        if (itemType == ITEMTYPE_TOOL and itemQuality == ITEM_FUNCTIONAL_QUALITY_MAGIC) then
            if (itemLevel ~= 50 and itemLevel ~= nil) then
                SetItemIsJunk(bagType, slotIndex, true)
            end
            return
        end
    end
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
    if PMIM.preferences.toSell.sellOrnateGear then
        if (itemTrait == ITEM_TRAIT_TYPE_WEAPON_ORNATE or itemTrait == ITEM_TRAIT_TYPE_ARMOR_ORNATE or itemTrait == ITEM_TRAIT_TYPE_JEWELRY_ORNATE) then
            SetItemIsJunk(bagType, slotIndex, true)
            return
        end
    end
    if PMIM.preferences.toSell.sellIntricateGear then
        if (itemTrait == ITEM_TRAIT_TYPE_WEAPON_INTRICATE or itemTrait == ITEM_TRAIT_TYPE_ARMOR_INTRICATE or itemTrait == ITEM_TRAIT_TYPE_JEWELRY_INTRICATE) then
            SetItemIsJunk(bagType, slotIndex, true)
            return
        end
    end
end

function PMIM.sellJunk(bagType)
    for slotIndex = 1, GetBagSize(bagType) do
        if IsItemJunk(bagType, slotIndex) then
            local itemStack, _ = GetSlotStackSize(bagType, slotIndex)
            SellInventoryItem(bagType, slotIndex, itemStack)
        end
    end
end

function PMIM.bankItems(sourceBag, targetBag)
    local emptyTargetSlotIndex = findEmptySlotInBag(targetBag, -1, GetBagSize(targetBag) - 1)
    for slotIndex = 0, GetBagSize(sourceBag) - 1 do
        local itemId = GetItemId(sourceBag, slotIndex)
        local itemType = GetItemType(sourceBag, slotIndex)
        local itemQuality = GetItemFunctionalQuality(sourceBag, slotIndex)
        local itemLevel = GetItemLevel(sourceBag, slotIndex)
        local itemLink = GetItemLink(sourceBag, slotIndex)
        local itemName = GetItemLinkName(itemLink)
        local itemTrait = GetItemTrait(sourceBag, slotIndex)
        local itemStack, _ = GetSlotStackSize(sourceBag, slotIndex)
        if itemId ~= 0 then
            emptyTargetSlotIndex = PMIM.filterToBank(itemId, itemType, itemQuality, itemLevel, itemName, itemTrait, itemStack, sourceBag, slotIndex, targetBag, emptyTargetSlotIndex)
        end
    end
end

function findEmptySlotInBag(bagType, prevIndex, lastIndex)
    local slotIndex = prevIndex
    while slotIndex < lastIndex do
        slotIndex = slotIndex + 1
        if GetItemType(bagType, slotIndex) == ITEMTYPE_NONE then
            return slotIndex
        end
    end
    return nil
end

local function MoveItem(sourceBag, slotIndex, targetBag, emptyTargetSlotIndex, itemStack)
	if IsProtectedFunction("RequestMoveItem") then
		CallSecureProtected("RequestMoveItem", sourceBag, slotIndex, targetBag, emptyTargetSlotIndex, itemStack)
	else
		RequestMoveItem(sourceBag, slotIndex, targetBag, emptyTargetSlotIndex, itemStack)
	end
    emptyTargetSlotIndex = findEmptySlotInBag(targetBag, emptyTargetSlotIndex + 1, GetBagSize(targetBag) - 1)
    return emptyTargetSlotIndex
end

function PMIM.filterToBank(itemId, itemType, itemQuality, itemLevel, itemName, itemTrait, itemStack, sourceBag, slotIndex, targetBag, emptyTargetSlotIndex)
    if PMIM.preferences.toBank.bankHighRepairs then
        if (itemType == ITEMTYPE_TOOL and itemQuality == ITEM_FUNCTIONAL_QUALITY_MAGIC) then
            if (itemLevel == 50) then
                emptyTargetSlotIndex = MoveItem(sourceBag, slotIndex, targetBag, emptyTargetSlotIndex, itemStack)
                return emptyTargetSlotIndex
            end
            return emptyTargetSlotIndex
        end
    end
    if PMIM.preferences.toBank.bankTempers then
        if (itemType == ITEMTYPE_CLOTHIER_BOOSTER or itemType == ITEMTYPE_BLACKSMITHING_BOOSTER or itemType == ITEMTYPE_WOODWORKING_BOOSTER or itemType == ITEMTYPE_JEWELRYCRAFTING_RAW_BOOSTER or itemType == 52) then
            emptyTargetSlotIndex = MoveItem(sourceBag, slotIndex, targetBag, emptyTargetSlotIndex, itemStack)
            return emptyTargetSlotIndex
        end
    end
    if PMIM.preferences.toBank.bankHighMats then
        if (itemName == "Sanded Ruby Ash^ns" or itemName == "platinum ounce" or itemName == "Rubedite Ingot" or itemName == "Rubedo Leather^ns" or itemName == "Ancestor Silk^ns" or itemName == "Alkahest" or itemName == "Lorkhan's Tears") then
            emptyTargetSlotIndex = MoveItem(sourceBag, slotIndex, targetBag, emptyTargetSlotIndex, itemStack)
            return emptyTargetSlotIndex
        end
    end
    if PMIM.preferences.toBank.bankWrits then
        if (itemType == ITEMTYPE_MASTER_WRIT) then
            emptyTargetSlotIndex = MoveItem(sourceBag, slotIndex, targetBag, emptyTargetSlotIndex, itemStack)
            return emptyTargetSlotIndex
        end
    end
    if PMIM.preferences.toBank.bankReagents then
        if (itemType == ITEMTYPE_REAGENT) then
            emptyTargetSlotIndex = MoveItem(sourceBag, slotIndex, targetBag, emptyTargetSlotIndex, itemStack)
            return emptyTargetSlotIndex
        end
    end
    return emptyTargetSlotIndex
end

function PMIM.OnAddonLoaded(event, addonName)
    if addonName == NAME then
        PMIM:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(PMIM.name, EVENT_ADD_ON_LOADED, PMIM.OnAddonLoaded)