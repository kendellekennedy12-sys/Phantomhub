-- Loader.lua
-- This script loads Phantom Hub GUI and the game-specific scripts

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Replace this with your raw GitHub URLs
local GUI_URL = "https://raw.githubusercontent.com/kendellekennedy12-sys/PhantomHub/main/GUI/PhantomHub.lua"
local BBL_URL = "https://raw.githubusercontent.com/kendellekennedy12-sys/PhantomHub/main/Games/BasketballLegends.lua"

-- Load GUI
local success, GUI = pcall(function()
    return loadstring(game:HttpGet(GUI_URL))()
end)

if not success then
    warn("Failed to load GUI:", GUI)
else
    print("Phantom Hub GUI loaded!")
end

-- Game Script Loader
local PlaceId = game.PlaceId

-- Basketball Legends PlaceIds (adjust if needed)
local BBPlaces = {
    14259168147,
    18474291382,
    80681221431821
}

local function isBasketballLegends()
    for _, id in ipairs(BBPlaces) do
        if PlaceId == id then
            return true
        end
    end
    return false
end

-- Load Basketball Legends Script
if isBasketballLegends() then
    local success2, err = pcall(function()
        loadstring(game:HttpGet(BBL_URL))()
    end)
    if success2 then
        print("Basketball Legends script loaded into Phantom Hub!")
    else
        warn("Failed to load Basketball Legends script:", err)
    end
else
    warn("No compatible game script for this PlaceId.")
end
