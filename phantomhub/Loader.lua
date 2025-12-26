-- Phantom Hub Loader with Basketball Legends Integration

repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local Char = player.Character or player.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Hrp = Char:WaitForChild("HumanoidRootPart")

-- Load Phantom Hub GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local Window = Library:Window({
    Title = "Phantom Hub [Universal]",
    Desc = "Basketball Legends Integration",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {Keybind = Enum.KeyCode.LeftControl, Size = UDim2.new(0, 500, 0, 400)},
    CloseUIButton = {Enabled = true, Text = "PH"}
})

-- Sidebar Line
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui")

-- Tabs
local TabMain = Window:Tab({Title = "Main", Icon = "star"})
local TabPlayer = Window:Tab({Title = "Player", Icon = "user"})
local TabMisc = Window:Tab({Title = "Misc", Icon = "settings"})
local TabUI = Window:Tab({Title = "UI Settings", Icon = "monitor"})

-- Section Groups
local ShootingGroup = TabMain:Section({Title = "Auto Shooting"})
local GuardGroup = TabMain:Section({Title = "Auto Guard"})
local ReboundGroup = TabMain:Section({Title = "Auto Rebound & Steal"})
local BallMagGroup = TabMain:Section({Title = "Ball Magnet"})
local PostGroup = TabMain:Section({Title = "Post Aimbot"})
local ReachGroup = TabMain:Section({Title = "Steal Reach"})
local SpeedGroup = TabPlayer:Section({Title = "Speed Boost"})
local MiscGroup = TabMisc:Section({Title = "Visuals / Teleporters"})

-- Variables
local autoShootEnabled, autoGuardEnabled, speedBoostEnabled, postAimbotEnabled, magnetEnabled, stealReachEnabled = false, false, false, false, false, false
local shootPower, desiredSpeed, guardDistance, predictionTime, postActivationDistance, MagsDist, stealReachMultiplier = 0.8, 30, 10, 0.3, 10, 30, 1.5
local visibleConn, autoGuardConnection, speedBoostConnection, postAimbotConnection, magnetConnection = nil, nil, nil, nil, nil
local lastPositions = {}
local holdingG, postHoldActive = false, false
local POST_UPDATE_INTERVAL, lastPostUpdate = 0.033, 0

-- Shooting
local visualGui = player.PlayerGui:WaitForChild("Visual")
local shootingElement = visualGui:WaitForChild("Shooting")
local Shoot = ReplicatedStorage.Packages.Knit.Services.ControlService.RE.Shoot

ShootingGroup:AddToggle("AutoShoot", {
    Text = "Auto Time",
    Default = false,
    Callback = function(v)
        autoShootEnabled = v
        if autoShootEnabled then
            if not visibleConn then
                visibleConn = shootingElement:GetPropertyChangedSignal("Visible"):Connect(function()
                    if autoShootEnabled and shootingElement.Visible then
                        task.wait(0.25)
                        Shoot:FireServer(shootPower)
                    end
                end)
            end
        else
            if visibleConn then
                visibleConn:Disconnect()
                visibleConn = nil
            end
        end
    end
})

ShootingGroup:AddSlider("ShootTiming", {
    Text = "Shot Timing",
    Default = 80,
    Min = 50,
    Max = 100,
    Callback = function(v) shootPower = v / 100 end
})

-- Auto Guard
GuardGroup:AddToggle("AutoGuard", {
    Text = "Auto Guard (Hold G)",
    Default = false,
    Callback = function(v)
        autoGuardEnabled = v
    end
})

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G and autoGuardEnabled then
        holdingG = true
        if not autoGuardConnection then
            autoGuardConnection = RunService.Heartbeat:Connect(function()
                -- simplified guard logic
                -- move humanoid to predicted ball carrier position
            end)
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        holdingG = false
        if autoGuardConnection then
            autoGuardConnection:Disconnect()
            autoGuardConnection = nil
        end
    end
end)

-- Speed Boost
SpeedGroup:AddToggle("SpeedBoost", {
    Text = "Speed Boost",
    Default = false,
    Callback = function(v)
        speedBoostEnabled = v
        if v then
            if speedBoostConnection then speedBoostConnection() end
            speedBoostConnection = RunService.RenderStepped:Connect(function(delta)
                local moveVec = Hum.MoveDirection
                if moveVec.Magnitude > 0 then
                    Hrp.CFrame = Hrp.CFrame + moveVec.Unit * desiredSpeed * delta
                end
            end)
        else
            if speedBoostConnection then speedBoostConnection:Disconnect() end
        end
    end
})

SpeedGroup:AddSlider("SpeedAmount", {
    Text = "Speed Amount",
    Default = 30,
    Min = 16,
    Max = 50,
    Callback = function(v) desiredSpeed = v end
})

-- Ball Magnet
BallMagGroup:AddToggle("BallMagnet", {
    Text = "Ball Magnet",
    Default = false,
    Callback = function(v)
        magnetEnabled = v
        if v then
            magnetConnection = RunService.Heartbeat:Connect(function()
                -- simplified magnet logic
            end)
        elseif magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
    end
})

-- Post Aimbot
PostGroup:AddToggle("PostAimbot", {
    Text = "Post Aimbot",
    Default = false,
    Callback = function(v) postAimbotEnabled = v end
})

-- Steal Reach
ReachGroup:AddToggle("StealReach", {
    Text = "Steal Reach",
    Default = false,
    Callback = function(v) stealReachEnabled = v end
})

ReachGroup:AddSlider("StealReachMultiplier", {
    Text = "Reach Multiplier",
    Default = 1.5,
    Min = 1,
    Max = 20,
    Callback = function(v) stealReachMultiplier = v end
})

-- Miscellaneous
MiscGroup:AddToggle("ShowBG", {Text="Show BodyGyro", Default=false})
MiscGroup:AddButton("Teleport to Place", {Func=function() end}) -- Add teleport logic
MiscGroup:AddButton("Rejoin Server", {Func=function() end})
MiscGroup:AddButton("Server Hop", {Func=function() end})

-- UI Settings
TabUI:Section({Title="Phantom Hub Settings"})

Window:Notify({Title="Phantom Hub", Desc="Basketball Legends features loaded!", Time=3})

