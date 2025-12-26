repeat task.wait() until game:IsLoaded()

local PlaceId = game.PlaceId
local base = "https://raw.githubusercontent.com/kendellekennedy12-sys/PhantomHub/main/"

-- Load UI
local UI = loadstring(game:HttpGet(base .. "UI/MainUI.lua"))()
UI.SetStatus("UI Loaded")

-- Load universal scripts
local function safeLoad(path)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(base .. path))()
    end)
    return ok, err
end

UI.SetStatus("Loading universal features...")
safeLoad("Universal/Universal.lua")

-- Game map
local Games = {
    -- Example:
    -- [123456789] = "Games/123456789.lua",
}

UI.SetStatus("Checking game support...")

if Games[PlaceId] then
    UI.SetStatus("Loading game script...")
    safeLoad(Games[PlaceId])
    UI.Window:Notify({
        Title = "Game Loaded",
        Desc = "Game script loaded successfully",
        Time = 4
    })
else
    UI.Window:Notify({
        Title = "Universal Mode",
        Desc = "No game script found",
        Time = 4
    })
end

UI.SetStatus("Ready")

