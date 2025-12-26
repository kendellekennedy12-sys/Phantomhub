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
local Games = {local Games = {
    [14259168147] = "Games/14259168147.lua", -- Basketball Legends
    [8204899140] = "Games/8204899140.lua", -- Football Fusion
    [18474291382] = "Games/18474291382.lua", -- Playground Basketball
    [90913221847091] = "Games/90913221847091.lua", -- Football Legends
    [91090484699204] = "Games/91090484699204.lua", -- Highschool Football
    [2338325648] = "Games/2338325648.lua", -- Universe Football
    [80681221431821] = "Games/80681221431821.lua", -- Practical Basketball
    [17698425045] = "Games/17698425045.lua", -- Fight in a School
    [99588440661442] = "Games/99588440661442.lua", -- Flag Football
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

