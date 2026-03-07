local CurrentConfig = "nil"
local CurrentClothing = "nil"
local CurrentClothingName = "nil"
local Configuration = {}
local ConfigsList = {}

local ConfigName = "Default"
local MainFolderName = "DLKCasualStock"
local formatFile = [[.DCFG]]

local MinPrice = 0
local MaxPrice = 1

local HttpService = game:GetService("HttpService")

_G.ESP_Config = false

-- Переменные для отслеживания баланса
local LastBalance = 0
local BalanceTrackerEnabled = false
local TotalProfit = 0
local TotalLoss = 0

if not isfolder(MainFolderName) then
    makefolder(MainFolderName)
end

if not isfile(MainFolderName.."/Default"..formatFile) then
    writefile(MainFolderName.."/Default"..formatFile, HttpService:JSONEncode(Configuration))
end

if _G.ProximityPromptServicePromptShown or not _G.CurrentObjectText then
    local ProximityPromptService = game:GetService("ProximityPromptService")
    
    _G.ProximityPromptServicePromptShown = true

    ProximityPromptService.PromptShown:Connect(function(prompt)
        _G.CurrentObjectText = prompt.ObjectText
    end)
end

local function convertToTable(str)
    local Table = {}
    for key, value in string.gmatch(str, "(%w+)=(%w+)") do
        Table[key] = value
    end
    return Table
end

local function GetCurrentBalance()
    local player = game:GetService("Players").LocalPlayer
    if player and player:FindFirstChild("leaderstats") then
        local leaderstats = player.leaderstats
        local rubleStat = leaderstats:FindFirstChild("Рубли") or leaderstats:FindFirstChild("рубли") or leaderstats:FindFirstChild("RUB") or leaderstats:FindFirstChild("Money")
        if rubleStat then
            return rubleStat.Value
        end
    end
    return 0
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Casual Stock | by Dadilk",
    LoadingTitle = "Powered by Dadilk",
    LoadingSubtitle = "by Dadilk", 
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Tami4kaCasualHub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

local function Notify(name, content, time, image)
    Rayfield:Notify({
        Title = name,
        Content = content,
        Duration = time or 5,
        Image = image or 4483362458,
    })
end

Notify("Casual Stock V2.1", "Version - 2.0", 5)

local Misc = Window:CreateTab("Configuration", 4483362458)
local Settings = Window:CreateTab("Settings", 4483362458)
local ESP = Window:CreateTab("ESP", 4483362458)
local Mics = Window:CreateTab("Mics", 4483362458)
local BalanceTab = Window:CreateTab("Balance", 4483362458)

_G.CurrentObjectText = ""

local LabelCurrentConfig = Misc:CreateLabel("Текущий конфиг: "..CurrentConfig, "rewind")
local InformationLabel = Settings:CreateLabel("Одежда для добавления: ".._G.CurrentObjectText.."\nМин. цена: "..MinPrice.."\nМакс. Цена: "..MaxPrice, "rewind")

-- Таб Balance
BalanceTab:CreateSection("Отслеживание баланса")

local BalanceLabel = BalanceTab:CreateLabel("Текущий баланс: 0")
local ChangeLabel = BalanceTab:CreateLabel("Изменение: +0")
local ProfitLabel = BalanceTab:CreateLabel("+Прибыль: 0")
local LossLabel = BalanceTab:CreateLabel("-Убыток: 0")
local TotalLabel = BalanceTab:CreateLabel("Итог: +0")

BalanceTab:CreateToggle({
    Name = "Включить отслеживание баланса",
    CurrentValue = false,
    Callback = function(Value)
        BalanceTrackerEnabled = Value
        if Value then
            LastBalance = GetCurrentBalance()
            BalanceLabel:Set("Текущий баланс: " .. LastBalance)
            ChangeLabel:Set("Изменение: +0")
            TotalLabel:Set("Итог: +0")
            Notify("Отслеживание", "Включено отслеживание баланса", 3)
        end
    end
})

BalanceTab:CreateButton({
    Name = "Обновить баланс вручную",
    Callback = function()
        local current = GetCurrentBalance()
        BalanceLabel:Set("Текущий баланс: " .. current)
        
        if BalanceTrackerEnabled then
            local change = current - LastBalance
            if change > 0 then
                ChangeLabel:Set("Изменение: +" .. change)
                Notify("Пополнение", "+" .. change .. " рублей", 3)
            elseif change < 0 then
                ChangeLabel:Set("Изменение: " .. change)
                Notify("Списание", change .. " рублей", 3)
            end
            LastBalance = current
        end
    end
})

BalanceTab:CreateButton({
    Name = "Сбросить отслеживание",
    Callback = function()
        LastBalance = GetCurrentBalance()
        BalanceLabel:Set("Текущий баланс: " .. LastBalance)
        ChangeLabel:Set("Изменение: +0")
        TotalLabel:Set("Итог: +0")
        Notify("Отслеживание", "Отслеживание сброшено", 3)
    end
})

BalanceTab:CreateButton({
    Name = "Сбросить прибыль/убыток",
    Callback = function()
        TotalProfit = 0
        TotalLoss = 0
        ProfitLabel:Set("+Прибыль: 0")
        LossLabel:Set("-Убыток: 0")
        TotalLabel:Set("Итог: +0")
        Notify("Сброс", "Прибыль и убыток сброшены", 3)
    end
})

local ConfigsDropdown = Misc:CreateDropdown({
    Name = "Конфиг [Config]",
    Options = ConfigsList,
    CurrentOption = "...",
    MultipleOptions = false,
    Callback = function(Option)
        if typeof(Option) == "table" then Option = Option[1] end
        CurrentConfig = Option
        if isfile(MainFolderName.."/"..CurrentConfig) then
            Configuration = HttpService:JSONDecode(readfile(MainFolderName.."/"..CurrentConfig))
            LabelCurrentConfig:Set("Текущий конфиг: "..CurrentConfig)
        end
    end
})

Misc:CreateSection("Настройка⚙")

Misc:CreateButton({
    Name = "Обновить список [Config]",
    Callback = function()
        ConfigsList = {}
        for _, file in listfiles(MainFolderName) do
            local name = file:match("[^/\\]+$")
            if name then
                table.insert(ConfigsList, name)
            end
        end
        ConfigsDropdown:Refresh(ConfigsList, true)
    end
})

Misc:CreateInput({
    Name = "Введите имя конфига",
    CurrentValue = "Name",
    PlaceholderText = "name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        ConfigName = Text
    end,
})

Misc:CreateButton({
    Name = "Создать конфиг [Config]",
    Callback = function()
        local path = MainFolderName.."/"..ConfigName..formatFile
        if not isfile(path) then
            writefile(path, HttpService:JSONEncode({}))
            Notify('Успешно!', "Создан: "..ConfigName, 5)
            -- автообновление списка
            ConfigsDropdown:Refresh(ConfigsList, true) -- можно добавить вызов обновления
        else
            Notify("Ошибка", "Конфиг уже существует", 5)
        end
    end
})

Misc:CreateButton({
    Name = "Сохранить конфиг [Config]",
    Callback = function()
        if CurrentConfig ~= "nil" and isfile(MainFolderName.."/"..CurrentConfig) then
            writefile(MainFolderName.."/"..CurrentConfig, HttpService:JSONEncode(Configuration))
            Notify('Успешно!', "Сохранён: "..CurrentConfig, 5)
        else
            Notify("Ошибка", "Выберите конфиг сначала", 5)
        end
    end
})

Misc:CreateButton({
    Name = "Debug [/console]",
    Callback = function()
        print("Configuration:", HttpService:JSONEncode(Configuration))
    end
})

local ClothingDropdown = Settings:CreateDropdown({
    Name = "Одежда [Config]",
    Options = {},
    CurrentOption = "...",
    MultipleOptions = false,
    Callback = function(Option)
        if typeof(Option) == "table" then Option = Option[1] end
        CurrentClothing = Option
        if Configuration[CurrentClothing] then
            MaxPrice = Configuration[CurrentClothing].Max or 1
            MinPrice = Configuration[CurrentClothing].Min or 0
            _G.CurrentObjectText = CurrentClothing
            InformationLabel:Set("Одежда для добавления: ".._G.CurrentObjectText.."\nМин. цена: "..MinPrice.."\nМакс. Цена: "..MaxPrice)
        end
    end
})

Settings:CreateSection("Настройка")

Settings:CreateButton({
    Name = "Обновить список одежды",
    Callback = function()
        local clothes = {}
        for _, data in pairs(Configuration) do
            if data.Clothing then
                table.insert(clothes, data.Clothing)
            end
        end
        ClothingDropdown:Refresh(clothes, true)
    end
})

Settings:CreateButton({
    Name = "Удалить выбранную одежду",
    Callback = function()
        if CurrentClothing and CurrentClothing ~= "..." then
            Configuration[CurrentClothing] = nil
            Notify("Удалено", CurrentClothing, 4)
            -- обновляем дропдаун
            local clothes = {}
            for _, data in pairs(Configuration) do
                if data.Clothing then table.insert(clothes, data.Clothing) end
            end
            ClothingDropdown:Refresh(clothes, true)
        end
    end
})

Settings:CreateButton({
    Name = "Обновить/Создать одежду",
    Callback = function()
        if _G.CurrentObjectText and _G.CurrentObjectText ~= "" then
            Configuration[_G.CurrentObjectText] = {
                Clothing = _G.CurrentObjectText,
                Min = tonumber(MinPrice) or 0,
                Max = tonumber(MaxPrice) or 999999
            }
            Notify(_G.CurrentObjectText, "Мин: "..MinPrice.." | Макс: "..MaxPrice, 5)
        else
            Notify("Ошибка", "Выберите/укажите одежду", 5)
        end
    end
})

Settings:CreateInput({
    Name = "Минимальная цена",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        MinPrice = tonumber(Text:gsub("%D+", "")) or 0
    end
})

Settings:CreateInput({
    Name = "Максимальная цена",
    PlaceholderText = "999999",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        MaxPrice = tonumber(Text:gsub("%D+", "")) or 999999
    end
})

-- ESP toggle (только флаг)
ESP:CreateToggle({
    Name = "Включить ESP по конфигу",
    CurrentValue = false,
    Callback = function(Value)
        _G.ESP_Config = Value
        if not Value then
            -- мгновенная очистка при выключении
            for _, store in pairs(workspace.World.Debris.Stores:GetChildren()) do
                if store:FindFirstChild("PlacementContainer") then
                    for _, container in pairs(store.PlacementContainer:GetChildren()) do
                        if container:FindFirstChild("ItemContainer") then
                            for _, item in pairs(container.ItemContainer:GetChildren()) do
                                local hl = item:FindFirstChildOfClass("Highlight")
                                if hl then hl:Destroy() end
                            end
                        end
                    end
                end
            end
            Notify("ESP", "Выключен + очищен", 3)
        else
            Notify("ESP", "Включен", 3)
        end
    end
})

ESP:CreateButton({
    Name = "Очистить все ESP вручную",
    Callback = function()
        for _, store in pairs(workspace.World.Debris.Stores:GetChildren()) do
            if store:FindFirstChild("PlacementContainer") then
                for _, container in pairs(store.PlacementContainer:GetChildren()) do
                    if container:FindFirstChild("ItemContainer") then
                        for _, item in pairs(container.ItemContainer:GetChildren()) do
                            local hl = item:FindFirstChildOfClass("Highlight")
                            if hl then hl:Destroy() end
                        end
                    end
                end
            end
        end
        Notify("Очистка", "Все highlights удалены", 3)
    end
})

-- Отдельный цикл для ESP (без блокировки callback)
task.spawn(function()
    while true do
        if _G.ESP_Config then
            for _, store in pairs(workspace.World.Debris.Stores:GetChildren()) do
                if not store:FindFirstChild("PlacementContainer") then continue end
                for _, container in pairs(store.PlacementContainer:GetChildren()) do
                    if not container:FindFirstChild("ItemContainer") then continue end
                    for _, clothing in pairs(container.ItemContainer:GetChildren()) do
                        local Prompt = clothing:FindFirstChildOfClass("ProximityPrompt")
                        local Highlight_ESP = clothing:FindFirstChildOfClass("Highlight")

                        if Highlight_ESP then Highlight_ESP:Destroy() end
                        if not Prompt or Prompt.ActionText == "Повесить" then continue end

                        local ItemPrice = Prompt.ActionText:gsub("%D", "")
                        local ItemName = Prompt.ObjectText
                        
                        local data = Configuration[ItemName]
                        if data and tonumber(ItemPrice) >= (data.Min or 0) and tonumber(ItemPrice) <= (data.Max or 999999) then
                            local ESP_Highlight = Instance.new("Highlight")
                            ESP_Highlight.FillTransparency = 0.25
                            ESP_Highlight.OutlineTransparency = 1
                            ESP_Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            ESP_Highlight.Parent = clothing
                        end
                    end
                end
            end
        end
        task.wait(1.2) -- чуть реже, чтобы не нагружать
    end
end)

-- Остальной код (Mics, баланс и т.д.) без изменений
-- Таб Mics
Mics:CreateSection("Изменение рублей")

Mics:CreateInput({
    Name = "Количество рублей",
    CurrentValue = "100000000",
    PlaceholderText = "Введите количество",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.RubleAmount = tonumber(Text) or 100000000
    end,
})

Mics:CreateButton({
    Name = "Установить количество рублей",
    Callback = function()
        local amount = _G.RubleAmount or 100000000
        local lp = game:GetService("Players").LocalPlayer
        local leaderstats = lp and lp:FindFirstChild("leaderstats")
        local rubleStat = leaderstats and leaderstats:FindFirstChild("Рубли")
        
        if rubleStat and type(amount) == "number" and amount >= 0 then
            rubleStat.Value = amount
            Notify("Успешно!", "Рубли установлены: " .. amount, 5)
        else
            Notify("Ошибка!", "Не удалось установить рубли", 5)
        end
    end
})

-- ESP баланса игроков (оставил как было, но можно тоже вынести цикл если будут проблемы)

Mics:CreateSection("ESP баланса игроков")

Mics:CreateToggle({
    Name = "ESP баланса игроков",
    CurrentValue = false,
    Callback = function(toggle)
        if toggle then
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local Camera = workspace.CurrentCamera

            if _G.BalanceESPRunning then
                _G.BalanceESPRunning = false
                task.wait(0.1)
            end

            _G.BalanceESPRunning = true
            local ESPRunning = true

            local ESPObjects = {}

            local function getBalance(player)
                if not player or not ESPRunning then return 0 end
                
                local ls = player:FindFirstChild("leaderstats")
                if not ls then return 0 end
                
                local moneyNames = {"Рубли", "рубли", "RUB", "Rubles", "Rub", "₽", "Money", "money", "Баланс", "баланс"}
                
                for _, name in ipairs(moneyNames) do
                    local val = ls:FindFirstChild(name)
                    if val and tonumber(val.Value) then
                        return tonumber(val.Value)
                    end
                end
                return 0
            end

            local function getColor(balance)
                local ratio = math.clamp(balance / 10000, 0, 1)
                return Color3.new(ratio, 1 - ratio, 0)
            end

            local function createPlayerESP(player)
                if player == LocalPlayer or not ESPRunning then return end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "BalanceESP"
                billboard.Size = UDim2.new(0, 180, 0, 50)
                billboard.AlwaysOnTop = true
                billboard.MaxDistance = 25
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.TextSize = 14
                label.Font = Enum.Font.SourceSansBold
                label.TextColor3 = Color3.new(1,1,1)
                label.TextStrokeTransparency = 0.6
                label.TextStrokeColor3 = Color3.new(0,0,0)
                label.Parent = billboard
                
                ESPObjects[player] = {gui = billboard, label = label}
                
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    billboard.Adornee = player.Character.HumanoidRootPart
                    billboard.Parent = player.Character
                end
                
                player.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if ESPObjects[player] and char:FindFirstChild("HumanoidRootPart") then
                        billboard.Adornee = char.HumanoidRootPart
                        billboard.Parent = char
                    end
                end)
            end

            _G.CleanupBalanceESP = function()
                ESPRunning = false
                _G.BalanceESPRunning = false
                for _, esp in pairs(ESPObjects) do
                    if esp.gui then esp.gui:Destroy() end
                end
                ESPObjects = {}
            end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    createPlayerESP(plr)
                end
            end

            Players.PlayerAdded:Connect(createPlayerESP)
            Players.PlayerRemoving:Connect(function(plr)
                if ESPObjects[plr] then
                    if ESPObjects[plr].gui then ESPObjects[plr].gui:Destroy() end
                    ESPObjects[plr] = nil
                end
            end)

            task.spawn(function()
                while ESPRunning do
                    for plr, esp in pairs(ESPObjects) do
                        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (plr.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
                            if dist <= 25 then
                                esp.gui.Enabled = true
                                local bal = getBalance(plr)
                                esp.label.Text = plr.Name .. "\n" .. bal .. " ₽"
                                esp.label.TextColor3 = getColor(bal)
                            else
                                esp.gui.Enabled = false
                            end
                        end
                    end
                    task.wait(1)
                end
            end)

            Notify("ESP баланса", "Включён (25 studs)", 4)
        else
            if _G.CleanupBalanceESP then
                _G.CleanupBalanceESP()
                Notify("ESP баланса", "Отключён", 4)
            end
        end
    end
})

Mics:CreateButton({
    Name = "Очистить ESP баланса",
    Callback = function()
        if _G.CleanupBalanceESP then
            _G.CleanupBalanceESP()
            Notify("ESP баланса", "Очищен", 3)
        end
    end
})

-- Автообновление конфигов при старте
task.spawn(function()
    ConfigsList = {}
    for _, file in listfiles(MainFolderName) do
        local name = file:match("[^/\\]+$")
        if name then table.insert(ConfigsList, name) end
    end
    ConfigsDropdown:Refresh(ConfigsList, true)
end)

-- Отслеживание баланса
task.spawn(function()
    while true do
        if BalanceTrackerEnabled then
            local current = GetCurrentBalance()
            local change = current - LastBalance
            
            if change ~= 0 then
                local total = TotalProfit - TotalLoss
                
                if change > 0 then
                    TotalProfit += change
                    ProfitLabel:Set("+Прибыль: " .. TotalProfit)
                    total += change
                else
                    TotalLoss += math.abs(change)
                    LossLabel:Set("-Убыток: " .. TotalLoss)
                    total += change
                end
                
                TotalLabel:Set("Итог: " .. (total >= 0 and "+" or "") .. total)
                BalanceLabel:Set("Текущий баланс: " .. current)
                ChangeLabel:Set("Изменение: " .. (change > 0 and "+" or "") .. change)
                
                Notify(change > 0 and "💰 Прибыль" or "💸 Убыток", (change > 0 and "+" or "") .. change .. " руб.", 3)
                
                LastBalance = current
            end
        end
        task.wait(0.4)
    end
end)

-- Обновление информации
while task.wait(1) do
    InformationLabel:Set("Одежда для добавления: " .. (_G.CurrentObjectText or "не выбрано") .. "\nМин. цена: " .. MinPrice .. "\nМакс. Цена: " .. MaxPrice)
end
