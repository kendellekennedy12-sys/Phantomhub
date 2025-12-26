-- Phantom Hub Loader
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ====================
-- Load Phantom Hub GUI
-- ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/PhantomHub/main/GUI/Library.lua"))()
local Window = Library:CreateWindow({
    Title = "Phantom Hub",
    Footer = "by PhantomHub Team",
    ShowCustomCursor = false,
})

local Tabs = {
    Main = Window:AddTab("Main", "house"),
    Player = Window:AddTab("Player", "user")
}

-- ====================
-- Load Game Script
-- ====================
local GameId = tostring(game.PlaceId)
local success, gameModule = pcall(function()
    return require(game:GetService("ReplicatedStorage"):WaitForChild("PhantomHub_Games"):WaitForChild(GameId))
end)

if not success then
    warn("Failed to load game module: " .. tostring(gameModule))
    return
end

-- ====================
-- Main Toggles
-- ====================
local MainGroup = Tabs.Main:AddLeftGroupbox("Game Features", "gamepad")

-- Auto Shoot
local autoShootToggle = MainGroup:AddToggle("AutoShoot", {
    Text = "Auto Shoot",
    Default = false,
    Tooltip = "Automatically shoots the ball with perfect timing",
    Callback = function(value)
        gameModule.AutoShoot(value)
    end
})

MainGroup:AddSlider("ShootTiming", {
    Text = "Shot Timing",
    Default = 80,
    Min = 50,
    Max = 100,
    Rounding = 0,
    Tooltip = "Adjust shooting timing (80 = Mediocre, 100 = Perfect)",
    Callback = function(value)
        gameModule.SetShootPower(value)
    end
})

-- Speed Boost
local PlayerGroup = Tabs.Player:AddLeftGroupbox("Movement", "zap")

local speedToggle = PlayerGroup:AddToggle("SpeedBoost", {
    Text = "Speed Boost",
    Default = false,
    Tooltip = "Enable or disable speed boost",
    Callback = function(value)
        gameModule.SpeedBoost(value)
    end
})

PlayerGroup:AddSlider("SpeedAmount", {
    Text = "Speed Amount",
    Default = 16,
    Min = 16,
    Max = 30,
    Rounding = 1,
    Tooltip = "Adjust speed boost amount",
    Callback = function(value)
        gameModule.SpeedBoost(true) -- re-enable to apply new speed
    end
})

-- Auto Guard
local guardToggle = PlayerGroup:AddToggle("AutoGuard", {
    Text = "Auto Guard (Hold G)",
    Default = false,
    Tooltip = "Automatically guard opponents",
    Callback = function(value)
        gameModule.AutoGuard(value)
    end
})

PlayerGroup:AddSlider("GuardDistance", {
    Text = "Guard Distance",
    Default = 10,
    Min = 5,
    Max = 20,
    Rounding = 0,
    Tooltip = "Maximum distance to start guarding",
    Callback = function(value)
        -- slider updates automatically inside the game script if needed
    end
})

PlayerGroup:AddSlider("PredictionTime", {
    Text = "Prediction Time",
    Default = 0.3,
    Min = 0.1,
    Max = 0.8,
    Rounding = 2,
    Tooltip = "Predict opponent movement (seconds)",
    Callback = function(value)
        -- slider updates automatically inside the game script if needed
    end
})

-- ====================
-- Keybinds
-- ====================
Library:BindKey("AutoGuardKey", Enum.KeyCode.G, function()
    guardToggle:Set(true)
end, function()
    guardToggle:Set(false)
end)

Library:OnUnload(function()
    -- Reset everything on unload
    gameModule.AutoShoot(false)
    gameModule.SpeedBoost(false)
    gameModule.AutoGuard(false)
end)
