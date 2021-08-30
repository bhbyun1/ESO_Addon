PoorMansInventoryManagement = {}
local PMIM = PoorMansInventoryManagement
PMIM.name = "PoorMansInventoryManagement"
PMIM.version = '0.0.1'
PMIM.defaultSettings = {
    sellGlyphs = false,
    sellLowMats = false,
    sellEmptyGems = false,
    sellLowRepairs = false,
    sellOrnateGear = false,
    sellIntricateGear = false,
}

function PMIM.getVersion()
    return PMIM.version
end

function PMIM.Initialize()
    PMIM.preferences = ZO_SavedVars:NewCharacterIdSettings("PMIMSavedVariables", 1, nil, {})
end

function PMIM.OnAddonLoaded(event, addonName)
    if addonName == PMIM.name then
        PMIM.Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(PMIM.name, EVENT_ADD_ON_LOADED, PMIM.OnAddOnLoaded)