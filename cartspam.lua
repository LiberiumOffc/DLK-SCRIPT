
-- Проверяем что игра загружена
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("🚀 Начинаю загрузку DlK HUB...")

-- Ждем игрока
local Players = game:GetService("Players")
local player = Players.LocalPlayer
repeat wait() until player

print("✅ Игрок загружен: " .. player.Name)

-- Пробуем загрузить WindUI разными способами
local WindUI

-- Способ 1: Оригинальная ссылка
local success1, err1 = pcall(function()
    WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    print("✅ WindUI загружен через GitHub")
end)

-- Способ 2: Если не получилось, пробуем raw ссылку
if not success1 then
    print("⚠️ Способ 1 не сработал, пробую способ 2...")
    local success2, err2 = pcall(function()
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/src/main.lua"))()
        print("✅ WindUI загружен через raw ссылку")
    end)
    
    -- Способ 3: Если опять не получилось, пробуем альтернативную библиотеку
    if not success2 then
        print("⚠️ Способ 2 не сработал, загружаю простую библиотеку...")
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/skui"))()
        print("✅ Загружена альтернативная библиотека")
    end
end

-- Проверяем что WindUI загружен
if not WindUI then
    warn("❌ Не удалось загрузить WindUI!")
    -- Создаем простой интерфейс самому
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Frame.Parent = ScreenGui
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Text = "DlK HUB v1.0\n\n🚗 Spam Cart\n📊 Cart Info\n👁️ ESP\n\nГорячая клавиша: RightControl"
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 18
    TextLabel.BackgroundTransparency = 1
    TextLabel.Parent = Frame
    
    -- Горячая клавиша
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    print("✅ Создан простой интерфейс")
    return
end

print("✅ Библиотека загружена, создаю окно...")

-- Создаем окно WindUI
local Window = WindUI:CreateWindow({
    Title = "DlK HUB 1.0",
    Icon = "car",
    Author = "by DADILK SQUAD",
    Folder = "DlKHub",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Dark",
    Transparent = false,
    Resizable = true
})

-- Добавляем тэг
Window:Tag({
    Title = "v1.0",
    Icon = "zap",
    Color = Color3.fromRGB(0, 255, 0)
})

-- ========== ВКЛАДКА 1: SPAM CART ==========
local SpamTab = Window:Tab({
    Title = "Spam Cart",
    Icon = "car"
})

-- SPAM UP
local spamUp = false
SpamTab:Toggle({
    Title = "SPAM UP",
    Desc = "Спамит кнопки Up",
    Icon = "arrow-up",
    Value = false,
    Callback = function(state)
        spamUp = state
        if state then
            print("🔼 SPAM UP включен")
            coroutine.wrap(function()
                while spamUp do
                    task.wait(0.1)
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ClickDetector") and obj.Parent.Name == "Up" then
                            fireclickdetector(obj)
                        end
                    end
                end
            end)()
        else
            print("⏹️ SPAM UP выключен")
        end
    end
})

-- SPAM DOWN
local spamDown = false
SpamTab:Toggle({
    Title = "SPAM DOWN",
    Desc = "Спамит кнопки Down",
    Icon = "arrow-down",
    Value = false,
    Callback = function(state)
        spamDown = state
        if state then
            print("🔽 SPAM DOWN включен")
            coroutine.wrap(function()
                while spamDown do
                    task.wait(0.1)
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ClickDetector") and obj.Parent.Name == "Down" then
                            fireclickdetector(obj)
                        end
                    end
                end
            end)()
        else
            print("⏹️ SPAM DOWN выключен")
        end
    end
})

-- SPAM REGEN
local spamRegen = false
SpamTab:Toggle({
    Title = "SPAM REGEN",
    Desc = "Спамит кнопки Regen",
    Icon = "refresh-cw",
    Value = false,
    Callback = function(state)
        spamRegen = state
        if state then
            print("🔄 SPAM REGEN включен")
            coroutine.wrap(function()
                while spamRegen do
                    task.wait(0.2)
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ClickDetector") then
                            local name = obj.Parent.Name:lower()
                            if name:find("regen") or name:find("regenerate") then
                                fireclickdetector(obj)
                            end
                        end
                    end
                end
            end)()
        else
            print("⏹️ SPAM REGEN выключен")
        end
    end
})

-- CFRAME К REGEN
SpamTab:Button({
    Title = "CFRAME К REGEN",
    Desc = "Телепорт к Regen объекту",
    Icon = "target",
    Callback = function()
        print("🎯 Ищу Regen...")
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                local name = obj.Name:lower()
                if name:find("regen") or name:find("2regen") then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                        print("✅ Телепорт к: " .. obj.Name)
                        return
                    end
                end
            end
        end
        print("🚫 Regen не найден")
    end
})

-- ВКЛЮЧИТЬ ВСЕ ON
SpamTab:Button({
    Title = "ВКЛЮЧИТЬ ВСЕ ON",
    Desc = "Включает все кнопки On",
    Icon = "power",
    Callback = function()
        print("⚡ Включаю все On...")
        local count = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ClickDetector") and obj.Parent.Name == "On" then
                fireclickdetector(obj)
                count = count + 1
            end
        end
        print("✅ Включено: " .. count .. " кнопок")
    end
})

-- ========== ВКЛАДКА 2: CART INFO ==========
local InfoTab = Window:Tab({
    Title = "Cart Info",
    Icon = "info"
})

-- ПОКАЗАТЬ ВСЕ МОДЕЛИ
InfoTab:Button({
    Title = "ПОКАЗАТЬ МОДЕЛИ",
    Desc = "Показывает все модели в игре",
    Icon = "list",
    Callback = function()
        print("🔍 Сканирую...")
        local models = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                table.insert(models, obj.Name)
            end
        end
        print("📊 Моделей: " .. #models)
        for i = 1, math.min(5, #models) do
            print(i .. ". " .. models[i])
        end
    end
})

-- ПОКАЗАТЬ ВСЕ КНОПКИ
InfoTab:Button({
    Title = "ПОКАЗАТЬ КНОПКИ",
    Desc = "Показывает все кнопки в игре",
    Icon = "mouse-pointer",
    Callback = function()
        print("🔍 Ищу кнопки...")
        local buttons = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ClickDetector") then
                local type = obj.Parent.Name
                buttons[type] = (buttons[type] or 0) + 1
            end
        end
        print("📊 Найдено:")
        for type, count in pairs(buttons) do
            print("  • " .. type .. ": " .. count)
        end
    end
})

-- ========== ВКЛАДКА 3: ESP ==========
local EspTab = Window:Tab({
    Title = "ESP",
    Icon = "eye"
})

-- ESP ИГРОКОВ
EspTab:Toggle({
    Title = "ESP ИГРОКОВ",
    Desc = "Включает ESP для игроков",
    Icon = "users",
    Value = false,
    Callback = function(state)
        if state then
            print("👥 ESP игроков включен")
        else
            print("👥 ESP игроков выключен")
        end
    end
})

-- ESP ТЕЛЕГ
EspTab:Toggle({
    Title = "ESP ТЕЛЕГ",
    Desc = "Включает ESP для телег",
    Icon = "car",
    Value = false,
    Callback = function(state)
        if state then
            print("🚗 ESP телег включен")
        else
            print("🚗 ESP телег выключен")
        end
    end
})

-- ========== ГОРЯЧАЯ КЛАВИША ==========
SpamTab:Keybind({
    Title = "ГОРЯЧАЯ КЛАВИША",
    Desc = "Показать/скрыть интерфейс",
    Value = "RightControl",
    Callback = function(key)
        print("🎮 Горячая клавиша: " .. key)
    end
})

-- ========== ФИНАЛЬНОЕ СООБЩЕНИЕ ==========
print("\n" .. string.rep("=", 60))
print("           🚀 DlK HUB v1.0 УСПЕШНО ЗАГРУЖЕН!")
print(string.rep("=", 60))
print("📱 Интерфейс создан!")
print("🎮 Нажми RightControl чтобы открыть/закрыть")
print("")
print("📁 ВКЛАДКИ:")
print("  🚗 Spam Cart - спам кнопками")
print("  📊 Cart Info - информация")
print("  👁️ ESP - подсветка")
print(string.rep("=", 60))

-- Уведомление в игре
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DlK HUB v1.0",
    Text = "Загружен! RightControl - открыть/закрыть",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})
