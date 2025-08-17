local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "DLK SCRIPT|Casual Stock ",
    Icon = "door-open",
    Author = "by Dadilk",
    Folder = "MySuperHub",
    
    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(280, 280),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    
    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]
    
    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
    
    -- !  ↓  remove this all, 
    -- !  ↓  if you DON'T need the key system
    KeySystem = { 
        -- ↓ Optional. You can remove it.
        Key = { "MANSION_PLAYER8905688800", "MANSION_ADMINYuoipLoisAsd90" },
        
        Note = "Example Key System.",
        
        -- ↓ Optional. You can remove it.
        Thumbnail = {
            Image = "rbxassetid://",
            Title = "FREE VERSION",
        },
        
        -- ↓ Optional. You can remove it.
        URL = "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)",
        
        -- ↓ Optional. You can remove it.
        SaveKey = true, -- automatically save and load the key.
        
        -- ↓ Optional. You can remove it.
        -- API = {} ← Services. Read about it below ↓
    },
})
Window:Tag({
    Title = "v1.0",
    Color = Color3.fromHex("#FF0000")
})
WindUI:Notify({
    Title = "SUCCESFUL!",
    Content = "You join has Player!",
    Duration = 3, -- 3 seconds
    Icon = "info",
})
local Tab = Window:Tab({
    Title = "Main",
    Icon = "door-open",
    Locked = false,
})
local Button = Tab:Button({
    Title = "Noclip",
    Desc = "Test проход сковзь стены",
    Locked = false,
    Callback = function()
        print("clicked")
local n = false
local p = game:GetService("Players").LocalPlayer

game:GetService("RunService").Stepped:Connect(function()
    if n and p.Character then
        for _, v in pairs(p.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

n = true
    end
})
local Button = Tab:Button({
    Title = "Teleport to trainstation",
    Desc = "Телепорт к железнодорожной станции",
    Locked = false,
    Callback = function()
        print("clicked")
local player = game.Players.LocalPlayer
for _,obj in pairs(workspace:GetDescendants()) do
    if (obj.Name:find("Seller") or obj.Name:find("Handle")) and obj:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
        break
    end
end
    end
})
local Slider = Tab:Slider({
    Title = "Walk Speed",
    
    -- To make float number supported, 
    -- make the Step a float number.
    -- example: Step = 0.1
    Step = 1,
    
    Value = {
        Min = 0,
        Max = 100,
        Default = 16,
    },
    Callback = function(value)
        print(value)
local speed = 16
local player = game:GetService("Players").LocalPlayer

local function updateSpeed()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateSpeed()
end)

updateSpeed()
    end
})
local Tab = Window:Tab({
    Title = "Visual",
    Icon = "eye",
    Locked = false,
})
local Toggle = Tab:Toggle({
    Title = "ESP 👕",
    Desc = "будет видно выгодные одежды",
    Icon = "eye",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})
local Tab = Window:Tab({
    Title = "settings",
    Icon = "settings",
    Locked = false,
})
local Keybind = Tab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "L",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})
local Button = Tab:Button({
    Title = "Server Hop",
    Desc = "перезайти на другой сервер",
    Locked = false,
    Callback = function()
        print("clicked")
local ts = game:GetService("TeleportService")
local hs = game:GetService("HttpService")

local servers = hs:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))

for _, server in ipairs(servers.data) do
    if server.id ~= game.JobId then
        ts:TeleportToPlaceInstance(game.PlaceId, server.id)
        break
    end
end
    end
})
local Button = Tab:Button({
    Title = "Rejoin",
    Desc = "перезайти на сервер",
    Locked = false,
    Callback = function()
        print("clicked")
local ts = game:GetService("TeleportService")
local serverId = game.JobId

ts:TeleportToPlaceInstance(game.PlaceId, serverId)
    end
})
local Tab = Window:Tab({
    Title = "Info",
    Icon = "info",
    Locked = false,
})
