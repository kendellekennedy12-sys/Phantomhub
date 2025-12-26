-- UI/MainUI.lua

-- Load UI Library
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"
))()

-- Create Main Window
local Window = Library:Window({
    Title = "Phantom Hub [ Universal ]",
    Desc = "tect on top",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "PH"
    }
})

-- Main Tab
local Main = Window:Tab({Title = "Main", Icon = "star"})
Main:Section({Title = "Status"})

-- Status label (used by loader)
local StatusLabel = Main:Label({
    Title = "Status: Initializing..."
})

-- Settings Tab
local Settings = Window:Tab({Title = "Settings", Icon = "wrench"})
Settings:Section({Title = "Config"})

-- Final notification
Window:Notify({
    Title = "Phantom Hub",
    Desc = "UI Loaded",
    Time = 3
})

-- 🔥 IMPORTANT
-- Return window + helpers so Loader.lua can control UI
return {
    Window = Window,
    SetStatus = function(text)
        StatusLabel:Set(text)
    end
}
