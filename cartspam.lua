local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:Gradient({                                                      
    ["0"] = { Color = Color3.fromHex("#1f1f23"), Transparency = 0 },            
    ["100"] = { Color = Color3.fromHex("#18181b"), Transparency = 0 },      
}, {                                                                            
    Rotation = 0,                                                               
})

local Window = WindUI:CreateWindow({
    Title = "DlK HUB 1.0",
    Icon = "door-open",
    Author = "by DADILK SQUAD",
    Folder = "MySuperHub",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
    KeySystem = { 
        Key = { "DLKSQUAD", "ADMIN" },
        Note = "Example Key System.",
        SaveKey = true,
    },
})

Window:Tag({
    Title = "v1.0",
    Icon = "car",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 0,
})

local Tab = Window:Tab({
    Title = "Spam Cart",
    Icon = "car",
    Locked = false,
})

-- Переменные для управления спамом
local spamUpEnabled = false
local spamDownEnabled = false
local spamThreads = {}

-- Функция для плавного включения/выключения кнопок On
local function toggleButtons(state, delay)
    delay = delay or 0.05
    
    local buttons = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ClickDetector") and v.Parent.Name == "On" then
            local shouldToggle = false
            if state then
                -- Включаем если не зеленая
                shouldToggle = v.Parent.BrickColor ~= BrickColor.new("Dark green")
            else
                -- Выключаем если зеленая
                shouldToggle = v.Parent.BrickColor == BrickColor.new("Dark green")
            end
            
            if shouldToggle then
                table.insert(buttons, v)
            end
        end
    end
    
    -- Плавное нажатие с задержкой
    for i, button in ipairs(buttons) do
        task.wait(delay / #buttons)
        fireclickdetector(button)
    end
end

-- Функция спама кнопок Up с возможностью остановки
local function startSpamUp()
    print("🔥 Включаю спам кнопок Up...")
    
    -- Плавно включаем все On кнопки
    toggleButtons(true, 0.1)
    
    -- Основной цикл спама
    while spamUpEnabled do
        task.wait(0.05) -- Уменьшил задержку для плавности
        
        -- Собираем все кнопки Up
        local upButtons = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ClickDetector") and v.Parent.Name == "Up" then
                table.insert(upButtons, v)
            end
        end
        
        -- Плавно кликаем все кнопки
        for i, button in ipairs(upButtons) do
            fireclickdetector(button)
            if #upButtons > 10 then
                task.wait(0.01) -- Добавляем небольшую задержку при большом количестве кнопок
            end
        end
    end
    
    print("⏹️ Спам Up остановлен")
end

-- Функция спама кнопок Down с возможностью остановки
local function startSpamDown()
    print("🔥 Включаю спам кнопок Down...")
    
    -- Плавно включаем все On кнопки
    toggleButtons(true, 0.1)
    
    -- Основной цикл спама
    while spamDownEnabled do
        task.wait(0.05) -- Уменьшил задержку для плавности
        
        -- Собираем все кнопки Down
        local downButtons = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ClickDetector") and v.Parent.Name == "Down" then
                table.insert(downButtons, v)
            end
        end
        
        -- Плавно кликаем все кнопки
        for i, button in ipairs(downButtons) do
            fireclickdetector(button)
            if #downButtons > 10 then
                task.wait(0.01) -- Добавляем небольшую задержку при большом количестве кнопок
            end
        end
    end
    
    print("⏹️ Спам Down остановлен")
end

-- Toggle для спама Up с анимацией
local toggleUp = Tab:Toggle({
    Title = "📈 СПАМ UP",
    Desc = "Плавный спам кнопок Вверх",
    Icon = "chevron-up",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        spamUpEnabled = state
        
        if state then
            -- Запускаем в отдельном потоке
            spamThreads.up = coroutine.create(startSpamUp)
            coroutine.resume(spamThreads.up)
            
            -- Плавное изменение цвета текста
            toggleUp:Set({
                Title = "🟢 СПАМ UP (АКТИВЕН)",
                Desc = "Спам работает... Нажмите чтобы выключить"
            })
        else
            -- Останавливаем
            spamUpEnabled = false
            
            -- Плавное выключение On кнопок
            task.spawn(function()
                task.wait(0.2)
                toggleButtons(false, 0.1)
            end)
            
            -- Возвращаем исходный вид
            toggleUp:Set({
                Title = "📈 СПАМ UP",
                Desc = "Плавный спам кнопок Вверх"
            })
            
            print("🔄 Спам Up выключен")
        end
    end
})

-- Toggle для спама Down с анимацией
local toggleDown = Tab:Toggle({
    Title = "📉 СПАМ DOWN",
    Desc = "Плавный спам кнопок Вниз",
    Icon = "chevron-down",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        spamDownEnabled = state
        
        if state then
            -- Запускаем в отдельном потоке
            spamThreads.down = coroutine.create(startSpamDown)
            coroutine.resume(spamThreads.down)
            
            -- Плавное изменение цвета текста
            toggleDown:Set({
                Title = "🟢 СПАМ DOWN (АКТИВЕН)",
                Desc = "Спам работает... Нажмите чтобы выключить"
            })
        else
            -- Останавливаем
            spamDownEnabled = false
            
            -- Плавное выключение On кнопок
            task.spawn(function()
                task.wait(0.2)
                toggleButtons(false, 0.1)
            end)
            
            -- Возвращаем исходный вид
            toggleDown:Set({
                Title = "📉 СПАМ DOWN",
                Desc = "Плавный спам кнопок Вниз"
            })
            
            print("🔄 Спам Down выключен")
        end
    end
})

-- Кнопка для принудительной остановки всего
local stopButton = Tab:Button({
    Title = "⏹️ ОСТАНОВИТЬ ВСЕ",
    Desc = "Полная остановка всех спамов",
    Icon = "square",
    Callback = function()
        -- Останавливаем оба спама
        spamUpEnabled = false
        spamDownEnabled = false
        
        -- Сбрасываем тогглы
        if toggleUp then
            toggleUp:SetValue(false)
            toggleUp:Set({
                Title = "📈 СПАМ UP",
                Desc = "Плавный спам кнопок Вверх"
            })
        end
        
        if toggleDown then
            toggleDown:SetValue(false)
            toggleDown:Set({
                Title = "📉 СПАМ DOWN",
                Desc = "Плавный спам кнопок Вниз"
            })
        end
        
        -- Плавно выключаем все кнопки
        toggleButtons(false, 0.05)
        
        print("🛑 Все спамы остановлены")
    end
})

-- Slider для настройки скорости
local speedSlider = Tab:Slider({
    Title = "⚡ СКОРОСТЬ",
    Desc = "Настройка скорости спама",
    Icon = "zap",
    Default = 0.05,
    Min = 0.01,
    Max = 0.2,
    Decimals = 3,
    Value = 0.05,
    Callback = function(value)
        -- Здесь можно добавить изменение скорости
        print("📊 Установлена задержка: " .. value .. " сек")
    end
})

-- Keybind для быстрого доступа
local Keybind = Tab:Keybind({
    Title = "🔑 ГОРЯЧАЯ КЛАВИША",
    Desc = "G - показать/скрыть интерфейс",
    Value = "G",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
        print("🎮 Горячая клавиша установлена: " .. key)
    end
})

-- Уведомление при загрузке
task.spawn(function()
    task.wait(1)
    print("✅ DlK HUB v1.0 загружен!")
    print("🔥 Используйте спам осторожно")
end)
