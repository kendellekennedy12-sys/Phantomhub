-- Game-specific script

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer.Character

print("[PhantomHub] Loaded game:", game.PlaceId)

-- Optional notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Phantom Hub",
        Text = "Game detected & script loaded",
        Duration = 4
    })
end)

-- 🔽 PUT THAT GAME'S ACTUAL SCRIPT 

-- Phantom Hub | Basketball Legends
-- Features: Auto Shoot, Speed Boost, Auto Guard, Rebound/Steal, Magnet, Follow, Anim Spoof
-- Clean rewrite, Phantom-native

repeat task.wait() until game:IsLoaded()

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

--// Phantom GUI reference
local Phantom = getgenv().PhantomHub
if not Phantom then
    warn("Phantom Hub GUI not found")
    return
end

--// Tabs
local Tabs = Phantom.Tabs
local Main = Tabs.Main
local PlayerTab = Tabs.Player

---------------------------------------------------
-- AUTO SHOOT
---------------------------------------------------

local shootPower = 0.9
local autoShoot = false

local ShootRemote =
    ReplicatedStorage.Packages.Knit.Services.ControlService.RE.Shoot

local VisualGui = player.PlayerGui:WaitForChild("Visual")
local ShootingUI = VisualGui:WaitForChild("Shooting")

Main:AddToggle("AutoShoot", {
    Text = "Auto Shoot",
    Default = false,
    Callback = function(v)
        autoShoot = v
    end
})

Main:AddSlider("ShootPower", {
    Text = "Shot Timing",
    Min = 70,
    Max = 100,
    Default = 90,
    Callback = function(v)
        shootPower = v / 100
    end
})

ShootingUI:GetPropertyChangedSignal("Visible"):Connect(function()
    if autoShoot and ShootingUI.Visible then
        task.wait(0.25)
        ShootRemote:FireServer(shootPower)
    end
end)

---------------------------------------------------
-- SPEED BOOST
---------------------------------------------------

local speedEnabled = false
local speedAmount = 22

local speedConn
local function enableSpeed()
    speedConn = RunService.RenderStepped:Connect(function(dt)
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame += hum.MoveDirection * (speedAmount - hum.WalkSpeed) * dt
        end
    end)
end

PlayerTab:AddToggle("SpeedBoost", {
    Text = "Speed Boost",
    Default = false,
    Callback = function(v)
        speedEnabled = v
        if v then
            enableSpeed()
        elseif speedConn then
            speedConn:Disconnect()
        end
    end
})

PlayerTab:AddSlider("SpeedAmount", {
    Text = "Speed Amount",
    Min = 16,
    Max = 26,
    Default = 22,
    Callback = function(v)
        speedAmount = v
    end
})

---------------------------------------------------
-- AUTO GUARD (G)
---------------------------------------------------

local autoGuard = false
local guardDist = 10
local guardConn

local function findBallCarrier()
    for _, m in pairs(workspace:GetChildren()) do
        if m:IsA("Model") and m ~= char and m:FindFirstChild("Basketball") then
            return m:FindFirstChild("HumanoidRootPart")
        end
    end
end

local function guardLoop()
    local target = findBallCarrier()
    if target then
        local pos = target.Position + (target.CFrame.LookVector * -4)
        hum:MoveTo(pos)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    end
end

Main:AddToggle("AutoGuard", {
    Text = "Auto Guard (Hold G)",
    Default = false,
    Callback = function(v)
        autoGuard = v
    end
})

Main:AddSlider("GuardDistance", {
    Text = "Guard Distance",
    Min = 5,
    Max = 20,
    Default = 10,
    Callback = function(v)
        guardDist = v
    end
})

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.G and autoGuard then
        guardConn = RunService.Heartbeat:Connect(guardLoop)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.G and guardConn then
        guardConn:Disconnect()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end
end)

---------------------------------------------------
-- BALL MAGNET
---------------------------------------------------

local magnet = false
local magDist = 35

Main:AddToggle("BallMagnet", {
    Text = "Ball Magnet",
    Default = false,
    Callback = function(v)
        magnet = v
    end
})

Main:AddSlider("MagnetDistance", {
    Text = "Magnet Distance",
    Min = 10,
    Max = 80,
    Default = 35,
    Callback = function(v)
        magDist = v
    end
})

RunService.Heartbeat:Connect(function()
    if not magnet then return end
    for _, b in pairs(workspace:GetDescendants()) do
        if b.Name == "Basketball" and b:IsA("BasePart") then
            if (b.Position - hrp.Position).Magnitude <= magDist then
                firetouchinterest(hrp, b, 0)
                firetouchinterest(hrp, b, 1)
            end
        end
    end
end)

---------------------------------------------------
-- FOLLOW BALL CARRIER
---------------------------------------------------

local follow = false
local followOffset = -8

Main:AddToggle("FollowBall", {
    Text = "Follow Ball Carrier",
    Default = false,
    Callback = function(v)
        follow = v
    end
})

RunService.Heartbeat:Connect(function()
    if not follow then return end
    local target = findBallCarrier()
    if target then
        hrp.CFrame = target.CFrame * CFrame.new(0, 0, followOffset)
    end
end)

---------------------------------------------------
-- AUTO REBOUND / STEAL
---------------------------------------------------

local rebound = false

Main:AddToggle("AutoRebound", {
    Text = "Auto Rebound & Steal",
    Default = false,
    Callback = function(v)
        rebound = v
    end
})

RunService.Heartbeat:Connect(function()
    if not rebound then return end
    for _, b in pairs(workspace:GetChildren()) do
        if b.Name == "Basketball" and b:IsA("BasePart") then
            hrp.CFrame = b.CFrame
        end
    end
end)

---------------------------------------------------
-- CLEANUP
---------------------------------------------------

Phantom.OnUnload(function()
    if speedConn then speedConn:Disconnect() end
    if guardConn then guardConn:Disconnect() end
end)
