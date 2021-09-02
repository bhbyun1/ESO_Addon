local LAM = LibAddonMenu2

local panelData = {
    type = "panel",
    name = "PMIM",
    displayName = "PMIM",
    author = "XJ69",
    version = "0.0.1",
    registerForRefresh = true,
}

--Settings here for easy reference
--[[
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
]]

local optionsTable = {
    {
        type = "header",
        name = "Treat the following as junk:",
    },
    {
        type = "checkbox",
        name = "Empty Soul Gems",
        getFunc = function() return PMIM.preferences.toSell.sellEmptyGems end,
        setFunc = function(value) PMIM.preferences.toSell.sellEmptyGems = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "Glyphs",
        getFunc = function() return PMIM.preferences.toSell.sellGlyphs end,
        setFunc = function(value) PMIM.preferences.toSell.sellGlyphs = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "Low Repair Kits",
        getFunc = function() return PMIM.preferences.toSell.sellLowRepairs end,
        setFunc = function(value) PMIM.preferences.toSell.sellLowRepairs = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "Low Refined Mats",
        getFunc = function() return PMIM.preferences.toSell.sellLowMats end,
        setFunc = function(value) PMIM.preferences.toSell.sellLowMats = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "Ornate Gear",
        getFunc = function() return PMIM.preferences.toSell.sellOrnateGear end,
        setFunc = function(value) PMIM.preferences.toSell.sellOrnateGear = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "Intricate Gear",
        getFunc = function() return PMIM.preferences.toSell.sellIntricateGear end,
        setFunc = function(value) PMIM.preferences.toSell.sellIntricateGear = value end,
        width = "half",
    },

}

function PMIM:InitSettings()
    name = PMIM.getName() .. "Menu"
    LAM:RegisterAddonPanel(name, panelData)
    LAM:RegisterOptionControls(name, optionsTable)
end