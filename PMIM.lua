PMIM = {}
--local PMIM = PMIM

NAME = "PMIM"
VERSION = 1

PMIM.name = "PMIM"
PMIM.version = "0.0.1"
PMIM.defaultSettings = {
    toSell = {
        sellGlyphs = false,
        sellLowMats = false,
        sellEmptyGems = false,
        sellLowRepairs = false,
        sellOrnateGear = false,
        sellIntricateGear = false,
    },
    toBank = {
        bankTempers = true,
        bankHighMats = true,
        bankHighRepairs = true,
        bankWrits = true,
    },
}

function PMIM.getName()
    return NAME
end

function PMIM.getVersion()
    return VERSION
end

function PMIM:Initialize()
    self.preferences = ZO_SavedVars:NewCharacterIdSettings("PMIMSavedVariables", 1, nil, {})
    SLASH_COMMANDS["/foobar"] = PMIM.test1
    PMIM.InitSettings()
    --SLASH_COMMANDS["/scanjunk"] = PMIM.test1
    --SLASH_COMMANDS["/selljunk"] = PMIM.sellJunk

    --d("Testing123")
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
    --EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)
    --self.preferences = ZO_SavedVars:NewCharacterIdSettings("PMIMSavedVariables", 1, nil, {})
    --PMIM.InitSettings()
    --SLASH_COMMANDS["/scanjunk"] = PMIM.test1
    --SLASH_COMMANDS["/selljunk"] = PMIM.sellJunk

end

EVENT_MANAGER:RegisterForEvent(PMIM.name, EVENT_ADD_ON_LOADED, PMIM.OnAddonLoaded)