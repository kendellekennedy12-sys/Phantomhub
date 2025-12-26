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

local BasketballLegends = {}

function BasketballLegends.AutoShoot(state)
    autoShootEnabled = state
end

function BasketballLegends.AutoGuard(state)
    autoGuardToggleEnabled = state
end

function BasketballLegends.BallMagnet(state)
    magnetEnabled = state
end

-- Add other features as needed

return BasketballLegends
