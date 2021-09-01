local LAM = LibAddonMenu2
--local PMIM = PoorMansInventoryManagement

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
        name = "Glyphs",
        tooltip = "Toggle to mark glyphs, when retrieved, as junk",
        getFunc = function() return PMIM.defaultSettings.toSell.sellGlyphs end,
        setFunc = function(value) PMIM.defaultSettings.toSell.sellGlyphs = value end,
        width = "half",
    },

}


function PMIM.GlyphJunk()
    PMIM.defaultSettings.toSell.sellGlyphs = not PMIM.defaultSettings.toSell.sellGlyphs
end

function PMIM:InitSettings()
    name = PMIM.getName() .. "Menu"
    LAM:RegisterAddonPanel(name, panelData)
    LAM:RegisterOptionControls(name, optionsTable)
end