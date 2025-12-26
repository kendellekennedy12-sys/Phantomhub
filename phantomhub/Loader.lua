-- Phantom Hub Loader (Universal + Basketball Legends)

-- 1️⃣ Load Phantom Hub GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local Window = Library:Window({
    Title = "Phantom Hub [Universal]",
    Desc = "tect on top",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = { Keybind = Enum.KeyCode.LeftControl, Size = UDim2.new(0,500,0,400) },
    CloseUIButton = { Enabled = true, Text = "PH" }
})

-- Tabs
local MainTab = Window:Tab({Title="Main", Icon="star"})
local PlayerTab = Window:Tab({Title="Player", Icon="user"})
local MiscTab = Window:Tab({Title="Misc", Icon="settings"})
local UISettingsTab = Window:Tab({Title="UI Settings", Icon="monitor"})

-- 2️⃣ Load the game-specific script (Basketball Legends)
local placeId = tostring(game.PlaceId)
local gameScript = nil

pcall(function()
    gameScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/kendellekennedy12-sys/PhantomHub/main/Games/"..placeId..".lua"))()
end)

if not gameScript then
    print("[Phantom Hub] No game script found for this place.")
else
    print("[Phantom Hub] Loaded game script for place ID "..placeId)
end

-- 3️⃣ Add GUI toggles and hook to script functions
-- Main tab example
MainTab:Section({Title="Basketball Legends Features"})

local autoShootToggle = MainTab:Toggle({
    Title="Auto Shoot",
    Desc="Automatically shoots with perfect timing",
    Value=false,
    Callback=function(val)
        if gameScript then gameScript.AutoShoot(val) end
    end
})

local ballMagnetToggle = MainTab:Toggle({
    Title="Ball Magnet",
    Desc="Automatically moves you to the ball",
    Value=false,
    Callback=function(val)
        if gameScript then gameScript.BallMagnet(val) end
    end
})

local speedBoostToggle = PlayerTab:Toggle({
    Title="Speed Boost",
    Desc="Enable CFrame speed boost",
    Value=false,
    Callback=function(val)
        if gameScript then gameScript.SpeedBoost(val) end
    end
})

local postAimbotToggle = PlayerTab:Toggle({
    Title="Post Aimbot",
    Desc="Automatically face opponents when posting up",
    Value=false,
    Callback=function(val)
        if gameScript then gameScript.PostAimbot(val) end
    end
})

local stealReachToggle = PlayerTab:Toggle({
    Title="Steal Reach",
    Desc="Enable extended reach for stealing",
    Value=false,
    Callback=function(val)
        if gameScript then gameScript.StealReach(val) end
    end
})

-- Misc / teleport examples
MiscTab:Section({Title="Miscellaneous"})
local teleportButton = MiscTab:Button({
    Title="Rejoin Server",
    Desc="Rejoin current server",
    Callback=function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

-- 4️⃣ Anti-AFK
local Players = game:GetService("Players")
Players.LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- 5️⃣ Notification
Window:Notify({
    Title="Phantom Hub",
    Desc="Loaded successfully for place ID "..placeId,
    Time=4
})
