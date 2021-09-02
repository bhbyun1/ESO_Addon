local LAM = LibAddonMenu2

local panelData = {
    type = "panel",
    name = "PMIM",
    displayName = "PMIM",
    author = "XJ69",
    version = "0.0.1",
    registerForRefresh = true,
}

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
    {
        type = "header",
        name = "Have the following be banked:",
    },
    {
        type = "checkbox",
        name = "High Refined Mats",
        getFunc = function() return PMIM.preferences.toBank.bankHighMats end,
        setFunc = function(value) PMIM.preferences.toBank.bankHighMats = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "High Repair Kits",
        getFunc = function() return PMIM.preferences.toBank.bankHighRepairs end,
        setFunc = function(value) PMIM.preferences.toBank.bankHighRepairs = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "Tempers",
        getFunc = function() return PMIM.preferences.toBank.bankTempers end,
        setFunc = function(value) PMIM.preferences.toBank.bankTempers = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "Sealed Writs",
        getFunc = function() return PMIM.preferences.toBank.bankWrits end,
        setFunc = function(value) PMIM.preferences.toBank.bankWrits = value end,
        width = "half",
    },
    {
        type = "checkbox",
        name = "Alchemy Reagents",
        getFunc = function() return PMIM.preferences.toBank.bankReagents end,
        setFunc = function(value) PMIM.preferences.toBank.bankReagents = value end,
        width = "half",
    },
}

function PMIM:InitSettings()
    name = PMIM.getName() .. "Menu"
    LAM:RegisterAddonPanel(name, panelData)
    LAM:RegisterOptionControls(name, optionsTable)
end