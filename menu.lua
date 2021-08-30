local LAM = LibAddonMenu2
local PMIM = PoorMansInventoryManagement

local panelData = {
    type = "panel",
    name = "Poor Man's Inventory Management",
    displayName = "Poor Man's Inventory Management",
    author = "XJ69",
    version = PMIM.getVersion(),
    registerForRefresh = true,	--boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
}

local optionsTable = {
    {
        type = "header",
        name = "Treat the following as junk:",
    },
    {
        type = "checkbox",
        name = "Glyphs"
        tooltip = "Toggle to mark glyphs, when retrieved, as junk",
        func = PMIM.GlyphJunk(),
        width = "half",
    },
        
}

function PMIM.GlyphJunk():
    PMIM.defaultSettings.sellGlyphs = not PMIM.defaultSettings.sellGlyphs
end