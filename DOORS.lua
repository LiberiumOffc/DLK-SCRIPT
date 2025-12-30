local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local backpack = player:WaitForChild("Backpack")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DOORS Hub by Grok"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 480)
mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "🚪 DOORS Hub | ESP + Нотифер + Правильная Дверь + Tools | by Grok"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0, 10, 0, 55)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = scroll
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

-- Нотифер GUI
local notifierGui = Instance.new("ScreenGui")
notifierGui.Name = "DOORSNotifier"
notifierGui.Parent = player.PlayerGui
notifierGui.ResetOnSpawn = false

local function showNotify(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.2, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = notifierGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 20)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://138081500"
    sound.Volume = 0.8
    sound.Parent = workspace
    sound:Play()

    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0.6, 0, 0.25, 0),
        BackgroundTransparency = 0.1
    })
    tweenIn:Play()

    task.wait(3)

    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        frame:Destroy()
    end)
    sound:Destroy()
end

-- Тогглы
local toggles = {
    EntityESP = false,
    ItemESP = false,
    InfHealth = false,
    InfSanity = false,
    NoClip = false,
    Fly = false,
    Notifier = false,
    SafeDoorESP = false
}

local loops = {}
local ESPs = {}
local notified = {Rush = false, Ambush = false}

local entityNames = {"RushMoving", "AmbushMoving", "Eyes", "Screech", "Halt", "Glitch", "Jack", "Hide", "Dupe", "Timothy", "FigureRig", "Figure", "SeekEye", "SeekHand", "Snare", "Spook", "A60", "A120"}
local itemNames = {"Lever", "Key", "Vitamin", "Red Key", "Bandage"}

-- ESP функции
local function createESP(part, text, color)
    if not part or ESPs[part] then return end
    local box = Drawing.new("Square")
    box.Size = Vector2.new(1, 1)
    box.Position = Vector2.new(0, 0)
    box.Color = color
    box.Thickness = 3
    box.Filled = false
    box.Transparency = 0.8
    box.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Color = color
    tracer.Thickness = 2
    tracer.Transparency = 0.8
    tracer.Visible = false

    local label = Drawing.new("Text")
    label.Text = text
    label.Size = 20
    label.Center = true
    label.Outline = true
    label.Font = 2
    label.Color = color
    label.Visible = false

    ESPs[part] = {box = box, tracer = tracer, label = label}
end

local espUpdateConn = RunService.Heartbeat:Connect(function()
    for part, esp in pairs(ESPs) do
        if part and part.Parent then
            local pos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local headPos = camera:WorldToViewportPoint(part.Position + Vector3.new(0, 4, 0))
                local size = (headPos - pos).Magnitude
                local width = size / 2.5
                esp.box.Size = Vector2.new(width * 2, size)
                esp.box.Position = Vector2.new(pos.X - width, pos.Y - size / 2)
                esp.box.Visible = true

                esp.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                esp.tracer.To = Vector2.new(pos.X, pos.Y)
                esp.tracer.Visible = true

                esp.label.Position = Vector2.new(pos.X, pos.Y - size / 2 - 25)
                esp.label.Visible = true
            else
                esp.box.Visible = esp.tracer.Visible = esp.label.Visible = false
            end
        else
            if esp then
                esp.box:Remove()
                esp.tracer:Remove()
                esp.label:Remove()
            end
            ESPs[part] = nil
        end
    end
end)

local function scanESP(isEntity)
    local names = isEntity and entityNames or itemNames
    local color = isEntity and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and table.find(names, model.Name) then
            local part = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model:FindFirstChild("Torso") or model:FindFirstChild("Door")
            if part and part:IsA("BasePart") then
                createESP(part, model.Name, color)
            end
        end
    end
end

-- НОВАЯ ФУНКЦИЯ: Подсветка правильной двери
local function scanSafeDoors()
    -- Очистка старых Safe ESP
    for part, esp in pairs(ESPs) do
        if esp and esp.label and esp.label.Text:find("Правильная") then
            esp.box:Remove()
            esp.tracer:Remove()
            esp.label:Remove()
            ESPs[part] = nil
        end
    end

    pcall(function()
        local currentRoom = player:GetAttribute("CurrentRoom")
        if not currentRoom then return end
        local roomNum = tonumber(currentRoom)
        local room = workspace.CurrentRooms:FindFirstChild(tostring(currentRoom))
        if not room then return end

        local doors = {}
        -- Поиск дверей: Model "Door" или BasePart с ProximityPrompt / door в имени
        for _, v in ipairs(room:GetDescendants()) do
            if (v.Name == "Door" and v:IsA("Model") and v.PrimaryPart) or
               (v:IsA("BasePart") and (v.Name:lower():find("door") or v:FindFirstChildOfClass("ProximityPrompt"))) then
                table.insert(doors, v)
            end
        end

        -- Если нет специальных — подсветка главной двери
        local mainDoor = room:FindFirstChild("Door")
        if mainDoor and (mainDoor.PrimaryPart or mainDoor:FindFirstChild("Door")) then
            local part = mainDoor.PrimaryPart or mainDoor:FindFirstChild("Door")
            if part then
                createESP(part, "✅ Выходная дверь", Color3.fromRGB(0, 255, 0))
            end
        end

        -- Eyes (комната ~60)
        if roomNum >= 59 and roomNum <= 61 then
            for _, door in ipairs(doors) do
                local part = door.PrimaryPart or door
                if part and not door:FindFirstChild("Eyes", true) then
                    createESP(part, "✅ Правильная дверь", Color3.fromRGB(0, 255, 0))
                end
            end
            return
        end

        -- Halt (комната 20)
        if roomNum >= 19 and roomNum <= 21 then
            for _, doorPart in ipairs(doors) do
                local hasHalt = false
                for _, child in ipairs(doorPart:GetDescendants()) do
                    if child:IsA("TextLabel") and string.find(string.upper(child.Text), "HALT") then
                        hasHalt = true
                        break
                    end
                end
                if not hasHalt and doorPart:IsA("BasePart") then
                    createESP(doorPart, "✅ Правильная дверь", Color3.fromRGB(0, 255, 0))
                end
            end
            return
        end
    end)
end

-- Функция тоггл кнопок
local function makeToggleButton(name, toggleKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = name .. " ❌"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = scroll

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        toggles[toggleKey] = not toggles[toggleKey]
        btn.Text = name .. (toggles[toggleKey] and " ✅" or " ❌")
        btn.BackgroundColor3 = toggles[toggleKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 55)
        callback()
    end)
end

local function makeButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    btn.Text = "🎯 " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = scroll

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- Тогглы
makeToggleButton("Entity ESP (RushMoving и др.)", "EntityESP", function()
    if toggles.EntityESP then
        scanESP(true)
        loops.EntityScan = task.spawn(function()
            while toggles.EntityESP do
                scanESP(true)
                task.wait(1.5)
            end
        end)
    else
        if loops.EntityScan then task.cancel(loops.EntityScan) end
    end
end)

makeToggleButton("Item ESP", "ItemESP", function()
    if toggles.ItemESP then
        scanESP(false)
        loops.ItemScan = task.spawn(function()
            while toggles.ItemESP do
                scanESP(false)
                task.wait(2)
            end
        end)
    else
        if loops.ItemScan then task.cancel(loops.ItemScan) end
    end
end)

makeToggleButton("✅ Правильная Дверь ESP", "SafeDoorESP", function()
    if toggles.SafeDoorESP then
        scanSafeDoors() -- initial
        loops.SafeDoorScan = task.spawn(function()
            while toggles.SafeDoorESP do
                scanSafeDoors()
                task.wait(0.5)
            end
        end)
    else
        if loops.SafeDoorScan then task.cancel(loops.SafeDoorScan) end
        -- Clear all safe ESP
        for part, esp in pairs(ESPs) do
            if esp and esp.label and esp.label.Text:find("Правильная") then
                esp.box:Remove()
                esp.tracer:Remove()
                esp.label:Remove()
                ESPs[part] = nil
            end
        end
    end
end)

makeToggleButton("Rush/Ambush Нотифер", "Notifier", function()
    if toggles.Notifier then
        loops.Notifier = task.spawn(function()
            while toggles.Notifier do
                local rushModel = workspace:FindFirstChild("RushMoving")
                local ambushModel = workspace:FindFirstChild("AmbushMoving")
                
                if rushModel and not notified.Rush then
                    task.spawn(function()
                        showNotify("🚨 RUSH! СПРАТЬСЯ В ШКАФ! 🚨")
                    end)
                    notified.Rush = true
                elseif not rushModel then
                    notified.Rush = false
                end
                
                if ambushModel and not notified.Ambush then
                    task.spawn(function()
                        showNotify("🚨 AMBUSH! СПРАТЬСЯ! ОН МОЖЕТ ВЕРНУТЬСЯ! 🚨")
                    end)
                    notified.Ambush = true
                elseif not ambushModel then
                    notified.Ambush = false
                end
                
                task.wait(0.1)
            end
        end)
    else
        if loops.Notifier then task.cancel(loops.Notifier) end
        notified.Rush = false
        notified.Ambush = false
    end
end)

makeToggleButton("Inf Health", "InfHealth", function()
    if toggles.InfHealth then
        loops.Health = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 100
            end
        end)
    else
        if loops.Health then loops.Health:Disconnect() end
    end
end)

makeToggleButton("Inf Sanity", "InfSanity", function()
    if toggles.InfSanity then
        loops.Sanity = RunService.Heartbeat:Connect(function()
            pcall(function()
                player.PlayerGui.MainUI.SanityGUI.SanityBar.Size = UDim2.new(1, 0, 1, 0)
            end)
        end)
    else
        if loops.Sanity then loops.Sanity:Disconnect() end
    end
end)

makeToggleButton("NoClip", "NoClip", function()
    if toggles.NoClip then
        loops.NoClip = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if loops.NoClip then loops.NoClip:Disconnect() end
    end
end)

makeToggleButton("Fly (WASD + Space/Shift)", "Fly", function()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    if toggles.Fly then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new()
        bv.Parent = root

        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 9e4
        bg.Parent = root

        loops.Fly = RunService.Heartbeat:Connect(function()
            local move = Vector3.new()
            local cam = camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
            bv.Velocity = move * 50
            bg.CFrame = cam
        end)
    else
        if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
        if root:FindFirstChild("BodyGyro") then root.BodyGyro:Destroy() end
        if loops.Fly then loops.Fly:Disconnect() end
    end
end)

-- Кнопки
makeButton("Speed 50", function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 50
    end
end)

makeButton("Speed 100", function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 100
    end
end)

makeButton("Give Crucifix (на всё)", function()
    local success, crucifix = pcall(function()
        return game:GetObjects("rbxassetid://12789793344")[1]
    end)
    if success then
        crucifix.Parent = backpack
        local tool = crucifix
        tool.Activated:Connect(function()
            local mouse = player:GetMouse()
            local target = mouse.Target
            if target then
                local model = target:FindFirstAncestorOfClass("Model")
                if model and model ~= player.Character then
                    model:Destroy()
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://13196113644"
                    sound.Volume = 0.5
                    sound.Parent = tool.Handle or workspace
                    sound:Play()
                    sound.Ended:Wait()
                    sound:Destroy()
                end
            end
        end)
    end
end)

makeButton("Give Shears (ножницы на всё)", function()
    local success, shears = pcall(function()
        return game:GetObjects("rbxassetid://12685082209")[1]
    end)
    if success then
        shears.Parent = backpack
        local newGrip = CFrame.new(0, 0, 0, 0.5, 0.707106829, 0.499999911, -0.5, 0.707106769, -0.49999997, 0.707106769, -2.10734239e-08, -0.707106769)
        shears.Grip = newGrip
        local tool = shears
        local useAnim = tool.Animations:FindFirstChild("use")
        tool.Activated:Connect(function()
            local mouse = player:GetMouse()
            local target = mouse.Target
            if target then
                local model = target:FindFirstAncestorOfClass("Model")
                if model and model ~= player.Character then
                    model:Destroy()
                end
            end
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and useAnim then
                local anim = hum:FindFirstChildOfClass("Animator"):LoadAnimation(useAnim)
                anim:Play()
            end
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://9118823101"
            sound.PlaybackSpeed = 1.25
            sound.Volume = 0.5
            sound.Parent = tool
            sound:Play()
            task.wait(0.5)
            sound:Play()
        end)
    end
end)

print("🚪 DOORS Hub с Подсветкой Правильной Дверь загружен!")
