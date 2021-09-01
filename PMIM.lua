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
    },
}

function PMIM.getName()
    return NAME
end

function PMIM.getVersion()
    return VERSION
end

function PMIM.markJunkType(counter, itemId)
    if counter == 2 then
        if itemId == 33265 then --33265 = Soul Gem (Empty)
            SetItemIsJunk(itemId)
        end
    end
end

function PMIM.filterToJunk(itemId, bagType, slotIndex)
    d("Step 1")
    if PMIM.preferences.toSell.sellEmptyGems then
        d("Step 2")
        if itemId == 33265 then
            d("Step 3")
            SetItemIsJunk(bagType, slotIndex, true)
        end
    end
end

function PMIM.scanInventory(bagType)
    for slotIndex = 1, GetBagSize(1) do
        local itemId = GetItemId(bagType, slotIndex)
        d(slotIndex .. ": " .. itemId)
        if itemId ~= 0 and CanItemBeMarkedAsJunk(bagType, slotIndex) then
            if itemId == 33265 then
                d("Empty Soul Gems found! Filtering...")
            end
            PMIM.filterToJunk(itemId, bagType, slotIndex)
        end
    end
end


function PMIM:Initialize()
    self.preferences = ZO_SavedVars:NewAccountWide("PMIMSavedVariables", 1, nil, PMIM.defaultSettings)
    SLASH_COMMANDS["/foobar"] = PMIM.test1
    SLASH_COMMANDS["/foobar2"] = PMIM.sizeGetter
    SLASH_COMMANDS["/foobar3"] = function() PMIM.scanInventory(1) end
    SLASH_COMMANDS["/foobar4"] = PMIM.test2
    SLASH_COMMANDS["/foobar4"] = PMIM.tableBools
    PMIM.InitSettings()
    --SLASH_COMMANDS["/scanjunk"] = PMIM.test1
    --SLASH_COMMANDS["/selljunk"] = PMIM.sellJunk

    --d("Testing123")
end

function PMIM.tableBools()
    for sellType, bool in pairs(PMIM.preferences.toSell) do
        local testVar = 0
        if bool then
            testVar = 1
        end
        d(sellType .. ": " .. testVar)
    end
end

function PMIM.test2()
    local itemId = GetItemId(1, 30)
    d("Empty Soul Gem is: " .. itemId)
end

function PMIM.sizeGetter()
    d("Getting size...")
    local bagSize = GetBagSize(1)
    d("Your bag size is: " .. bagSize)
end

function PMIM.test1()
    d("Hello World!")
end

function PMIM.sellJunk()
    sellAllJunk()
end

function PMIM.OnAddonLoaded(event, addonName)
    if addonName == NAME then
        PMIM:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(PMIM.name, EVENT_ADD_ON_LOADED, PMIM.OnAddonLoaded)