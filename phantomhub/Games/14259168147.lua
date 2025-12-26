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

-- 🔽 PUT THAT GAME'S ACTUAL SCRIPT BELOW 🔽

-- Basketball Legends - Phantom Hub Edition
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local Char = player.Character or player.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Hrp = Char:WaitForChild("HumanoidRootPart")

-- Game Services
local shootingElement = player.PlayerGui:WaitForChild("Visual"):WaitForChild("Shooting")
local Shoot = ReplicatedStorage.Packages.Knit.Services.ControlService.RE.Shoot

-- Toggles
local autoShootEnabled = false
local autoGuardEnabled = false
local speedBoostEnabled = false
local holdingG = false

-- Settings
local desiredSpeed = 30
local guardDistance = 10
local predictionTime = 0.3
local shootPower = 0.8

local lastPositions = {}
local autoGuardConnection = nil
local speedBoostConnection = nil
local visibleConn = nil

-- 🔫 Auto Shoot
local function AutoShoot(value)
    autoShootEnabled = value
    if value then
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

local function SetShootPower(value)
    shootPower = value / 100
end

-- 🏃 Speed Boost
local function startCFrameSpeed(speed)
    local conn
    conn = RunService.RenderStepped:Connect(function(deltaTime)
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        local moveVec = humanoid.MoveDirection
        if moveVec.Magnitude > 0 then
            local speedDelta = math.max(speed - humanoid.WalkSpeed, 0)
            root.CFrame = root.CFrame + (moveVec.Unit * speedDelta * deltaTime)
        end
    end)
    return function() if conn then conn:Disconnect() end end
end

local function SpeedBoost(value)
    speedBoostEnabled = value
    if value then
        if speedBoostConnection then speedBoostConnection() end
        speedBoostConnection = startCFrameSpeed(desiredSpeed)
    else
        if speedBoostConnection then speedBoostConnection() end
        speedBoostConnection = nil
    end
end

-- 🛡 Auto Guard
local function getPlayerFromModel(model)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character == model then return plr end
    end
    return nil
end

local function isOnDifferentTeam(otherModel)
    local otherPlayer = getPlayerFromModel(otherModel)
    if not otherPlayer then return false end
    if not player.Team or not otherPlayer.Team then
        return otherPlayer ~= player
    end
    return player.Team ~= otherPlayer.Team
end

local function findPlayerWithBall()
    local looseBall = workspace:FindFirstChild("Basketball")
    if looseBall and looseBall:IsA("BasePart") then
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _, model in pairs(workspace:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model ~= player.Character then
                if isOnDifferentTeam(model) then
                    local rootPart = model:FindFirstChild("HumanoidRootPart")
                    local distance = (looseBall.Position - rootPart.Position).Magnitude
                    if distance < closestDistance and distance < 15 then
                        closestDistance = distance
                        closestPlayer = model
                    end
                end
            end
        end
        
        if closestPlayer then
            return closestPlayer, closestPlayer:FindFirstChild("HumanoidRootPart")
        end
    end
    return nil, nil
end

local function autoGuard()
    if not autoGuardEnabled then return end
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    local ballCarrier, ballCarrierRoot = findPlayerWithBall()
    if ballCarrier and ballCarrierRoot then
        local distance = (rootPart.Position - ballCarrierRoot.Position).Magnitude
        local currentPos = ballCarrierRoot.Position
        local velocity = Vector3.new(0,0,0)
        if lastPositions[ballCarrier] then
            velocity = (currentPos - lastPositions[ballCarrier]) / task.wait()
        end
        lastPositions[ballCarrier] = currentPos
        local predictedPos = currentPos + (velocity * predictionTime * 60)
        local defensiveOffset = (predictedPos - rootPart.Position).Unit * 5
        local defensivePosition = predictedPos - defensiveOffset
        defensivePosition = Vector3.new(defensivePosition.X, rootPart.Position.Y, defensivePosition.Z)
        if distance <= guardDistance then
            humanoid:MoveTo(defensivePosition)
            if distance <= 10 then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            else
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
        else
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        end
    else
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.G and not gameProcessed then
        holdingG = true
        autoGuardEnabled = true
        lastPositions = {}
        if not autoGuardConnection then
            autoGuardConnection = RunService.Heartbeat:Connect(autoGuard)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        holdingG = false
        autoGuardEnabled = false
        if autoGuardConnection then
            autoGuardConnection:Disconnect()
            autoGuardConnection = nil
        end
        lastPositions = {}
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end
end)

-- Return functions for GUI toggles
return {
    AutoShoot = AutoShoot,
    SpeedBoost = SpeedBoost,
    AutoGuard = function(val) autoGuardEnabled = val end,
    SetShootPower = SetShootPower
}
