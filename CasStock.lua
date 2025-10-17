local CurrentConfig = "nil"
local CurrentClothing = "nil"
local CurrentClothingName = "nil"
local Configuration = {}
local ConfigsList = {}

local ConfigName = "Default"
local MainFolderName = "DLKCasualStock"
local formatFile = [[.json]]

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

-- Функция для получения текущего баланса
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

local Window = Rayfield:CreateWindow({Name = "Casual Stock | by Dadilk", LoadingTitle = "Powered by Dadilk", LoadingSubtitle = "by Dadilk", 
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

Notify("Casual Stock V2.1","Version - 2.0", 5)

local Misc = Window:CreateTab("Configuration", 4483362458)
local Settings = Window:CreateTab("Settings", 4483362458)
local ESP = Window:CreateTab("ESP", 4483362458)
local Mics = Window:CreateTab("Mics", 4483362458)
local BalanceTab = Window:CreateTab("Balance", 4483362458)

_G.CurrentObjectText = ""

local LabelCurrentConfig = Misc:CreateLabel("Текущий конфиг: "..CurrentConfig, "rewind")
local InformationLabel = Settings:CreateLabel("Одежда для добавления: ".._G.CurrentObjectText.."\nМин. цена: "..MinPrice.."\n".."Макс. Цена: "..MaxPrice, "rewind")

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
	Callback = function(Options)
		if typeof(Options) == "table" then print("Unpack [1]") Options = table.unpack(Options) end
		if typeof(CurrentConfig) == "table" then print("Unpack [2]")  CurrentConfig = table.unpack(CurrentConfig) end

 		CurrentConfig = Options
		Configuration = HttpService:JSONDecode(readfile(MainFolderName.."/"..CurrentConfig))
		
		LabelCurrentConfig:Set("Текущий конфиг: "..CurrentConfig)
	end
})

local Section = Misc:CreateSection("Настройка⚙")

Misc:CreateButton({
	Name = "Обновить список [Config]",
	Callback = function()
		ConfigsList = {}
		for index, configurationFile in listfiles(MainFolderName) do
			local lastSlash = configurationFile:find("/[^/]*$")
			table.insert(ConfigsList, configurationFile:sub(lastSlash + 1))
		end

		ConfigsDropdown:Refresh(ConfigsList)
	end
})

Misc:CreateInput({
	Name = "Введите имя конфига",
	CurrentValue = "Name",
	PlaceholderText = "name",
	RemoveTextAfterFocusLost = false,
	Flag = "Input1",
	Callback = function(Text)
		ConfigName = Text
	end,
})

Misc:CreateButton({
	Name = "Создать кофиг [Config]",
	Callback = function()
		if not isfile(MainFolderName.."/"..ConfigName..formatFile) then
			local Config = HttpService:JSONEncode({})
			Configuration = Config
			writefile(MainFolderName.."/"..ConfigName..formatFile, Config)

			Notify('Успешно!', "Название: ".. ConfigName, 5)
		else
			Notify("Конфиг с таким название уже существует", "попрорбуйте другое имя", 5)
		end
	end
})

Misc:CreateButton({
	Name = "Сохранить кофиг [Config]",
	Callback = function()
		if isfile(MainFolderName.."/"..CurrentConfig) then
			Notify('Успешно!', "Название: ".. CurrentConfig, 5)
			writefile(MainFolderName.."/"..CurrentConfig, HttpService:JSONEncode(Configuration))
		else
			Notify("Конфига с таким название не существует", "попрорбуйте другое имя", 5)
		end
	end
})

Misc:CreateButton({
	Name = "Debug [/console]",
	Callback = function()
		print(HttpService:JSONEncode(Configuration))
	end
})

local ClothingDropdown = Settings:CreateDropdown({
	Name = "Одежда [Config]",
	Options = {},
	CurrentOption = "...",
	MultipleOptions = false,
	Callback = function(Options)
		if typeof(Options) == "table" then print("Unpack [1]") Options = table.unpack(Options) end
		if typeof(CurrentConfig) == "table" then print("Unpack [2]")  CurrentConfig = table.unpack(CurrentConfig) end

 		CurrentClothing = Options
		MaxPrice = Configuration[CurrentClothing]["Max"]
		MinPrice = Configuration[CurrentClothing]["Min"]
		_G.CurrentObjectText = CurrentClothing
		
		print(CurrentClothing, Options)
	end
})

local Section = Settings:CreateSection("Настройка")

Settings:CreateButton({
	Name = "Обновить список [Config]",
	Callback = function()
		local Table = {}
		for index, cloth in Configuration do
			table.insert(Table, cloth.Clothing)
		end
		ClothingDropdown:Refresh(Table)
	end
})

Settings:CreateButton({
	Name = "Удалить из списока [Config]",
	Callback = function()
		Configuration[CurrentClothing] = nil

		local Table = {}
		for index, cloth in Configuration do
			table.insert(Table, cloth.Clothing)
		end
		ClothingDropdown:Refresh(Table)
	end
})

Settings:CreateButton({
	Name = "Обновить/Создать одежду",
	Callback = function()
		print(_G.CurrentObjectText)
		if _G.CurrentObjectText then

			Configuration[_G.CurrentObjectText] = {
				["Clothing"] = _G.CurrentObjectText,
				["Min"] = MinPrice,
				["Max"] = MaxPrice
			}

			Notify(_G.CurrentObjectText, "Макс. цена: "..MaxPrice.." | Мин. цена: "..MinPrice, 5)
		end
	end
})

Settings:CreateInput({
	Name = "Введите минимальную сумму покупки",
	CurrentValue = "",
	PlaceholderText = "number",
	RemoveTextAfterFocusLost = true,
	Flag = "Input1",
	Callback = function(Texts)
		MinPrice = Texts:gsub("%D", "")
		print(MinPrice)
	end,
})

Settings:CreateInput({
	Name = "Введите максимальную сумму покупки",
	CurrentValue = "",
	PlaceholderText = "number",
	RemoveTextAfterFocusLost = true,
	Flag = "Input1",
	Callback = function(Texts)
		MaxPrice = Texts:gsub("%D", "")
		print(MaxPrice)
	end,
})

ESP:CreateToggle({
	Name = "config ESP",
	CurrentValue = false,
	Callback = function(toggle)
		if toggle then
			_G.ESP_Config = true

			while _G.ESP_Config do
				for index, store in workspace.World.Debris.Stores:GetChildren() do
					if not store:FindFirstChild("PlacementContainer") then continue end
					for index, container in store.PlacementContainer:GetChildren() do
						if not container:FindFirstChild("ItemContainer") then continue end
						for index, clothing in container.ItemContainer:GetChildren() do
							local Prompt = clothing:FindFirstChildOfClass("ProximityPrompt")
							local Highlight_ESP = clothing:FindFirstChildOfClass("Highlight")

							if Highlight_ESP then Highlight_ESP:Destroy() end
							if not Prompt or Prompt.ActionText == "Повесить" then continue end

							local ItemPrice = Prompt.ActionText:gsub("%D", "")
							local ItemName = Prompt.ObjectText
							
							for index, ClothingInTable in Configuration do
								if ItemName == ClothingInTable.Clothing then
									if tonumber(ItemPrice) >= tonumber(ClothingInTable.Min) and tonumber(ItemPrice) <= tonumber(ClothingInTable.Max) then
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
				end
				
				task.wait(1)
			end

		else
			_G.ESP_Config = false
		end
	end
})

ESP:CreateButton({
	Name = "Очистить ESP",
	Callback = function()
		for index, store in workspace.World.Debris.Stores:GetChildren() do
			if not store:FindFirstChild("PlacementContainer") then continue end
			for index, container in store.PlacementContainer:GetChildren() do
				if not container:FindFirstChild("ItemContainer") then continue end
				for index, clothing in container.ItemContainer:GetChildren() do
					local Highlight_ESP = clothing:FindFirstChildOfClass("Highlight")

					if Highlight_ESP then Highlight_ESP:Destroy() end
				end
			end
		end
	end
})

-- Таб Mics
Mics:CreateSection("Изменение рублей")

Mics:CreateInput({
	Name = "Количество рублей",
	CurrentValue = "100000000",
	PlaceholderText = "Введите количество",
	RemoveTextAfterFocusLost = false,
	Flag = "RubleAmount",
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

-- ESP баланса игроков в табе Mics
Mics:CreateSection("ESP баланса игроков")

Mics:CreateToggle({
	Name = "ESP баланса игроков",
	CurrentValue = false,
	Callback = function(toggle)
		if toggle then
			-- Запускаем ESP баланса
			local Players = game:GetService("Players")
			local RunService = game:GetService("RunService")
			local LocalPlayer = Players.LocalPlayer
			local Camera = workspace.CurrentCamera

			if _G.BalanceESPRunning then
				_G.BalanceESPRunning = false
				wait(0.1)
			end

			_G.BalanceESPRunning = true
			local ESPRunning = true

			local ESPObjects = {}

			local function getBalance(player)
				if not player or not ESPRunning then return 0 end
				
				local balance = 0
				
				if player:FindFirstChild("leaderstats") then
					local ls = player.leaderstats
					local moneyNames = {
						"Рубли", "рубли", "RUB", "Rubles", "Rub", "₽",
						"Money", "money", "Баланс", "баланс"
					}
					
					for _, name in ipairs(moneyNames) do
						local moneyObj = ls:FindFirstChild(name)
						if moneyObj and (moneyObj:IsA("IntValue") or moneyObj:IsA("NumberValue") or moneyObj:IsA("StringValue")) then
							balance = tonumber(moneyObj.Value) or 0
							if balance > 0 then return balance end
						end
					end
				end
				
				return 0
			end

			local function getColor(balance)
				local maxBalance = 10000
				local ratio = math.min(balance / maxBalance, 1)
				return Color3.new(ratio, 1 - ratio, 0)
			end

			local function createPlayerESP(player)
				if player == LocalPlayer or not ESPRunning then return end
				
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Name = "ESP_" .. player.Name
				billboardGui.Size = UDim2.new(0, 200, 0, 60)
				billboardGui.AlwaysOnTop = true
				billboardGui.MaxDistance = 20
				
				local label = Instance.new("TextLabel")
				label.Name = "Label"
				label.BackgroundTransparency = 1
				label.BorderSizePixel = 0
				label.TextSize = 14
				label.Font = Enum.Font.ArialBold
				label.TextColor3 = Color3.new(1, 1, 1)
				label.TextStrokeTransparency = 0.5
				label.TextStrokeColor3 = Color3.new(0, 0, 0)
				label.TextXAlignment = Enum.TextXAlignment.Center
				label.Size = UDim2.new(1, 0, 1, 0)
				label.ZIndex = 10
				label.Visible = true
				label.Parent = billboardGui
				
				ESPObjects[player] = {
					billboardGui = billboardGui,
					label = label,
					lastUpdate = 0
				}
				
				if player.Character then
					local torso = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("Torso")
					if torso then
						billboardGui.Adornee = torso
						billboardGui.Parent = torso
					end
				end
			end

			_G.CleanupBalanceESP = function()
				ESPRunning = false
				_G.BalanceESPRunning = false
				for player, esp in pairs(ESPObjects) do
					if esp and esp.billboardGui then
						esp.billboardGui:Destroy()
					end
				end
				ESPObjects = {}
			end

			-- Инициализация ESP
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					createPlayerESP(player)
				end
			end

			Players.PlayerAdded:Connect(function(player)
				createPlayerESP(player)
			end)

			Players.PlayerRemoving:Connect(function(player)
				if ESPObjects[player] then
					ESPObjects[player].billboardGui:Destroy()
					ESPObjects[player] = nil
				end
			end)

			-- Цикл обновления
			spawn(function()
				while ESPRunning do
					for player, esp in pairs(ESPObjects) do
						if player and player.Character then
							local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
							if humanoidRootPart then
								local distance = (humanoidRootPart.Position - Camera.CFrame.Position).Magnitude
								if distance <= 20 then
									esp.billboardGui.Enabled = true
									local balance = getBalance(player)
									esp.label.Text = player.Name .. "\n" .. balance .. " ₽"
									esp.label.TextColor3 = getColor(balance)
								else
									esp.billboardGui.Enabled = false
								end
							end
						end
					end
					wait(1)
				end
			end)

			Notify("ESP баланса", "Включен (радиус 20 studs)", 5)
		else
			if _G.CleanupBalanceESP then
				_G.CleanupBalanceESP()
				Notify("ESP баланса", "Отключен", 5)
			end
		end
	end
})

Mics:CreateButton({
	Name = "Очистить ESP баланса",
	Callback = function()
		if _G.CleanupBalanceESP then
			_G.CleanupBalanceESP()
			Notify("ESP баланса", "Очищен", 5)
		else
			Notify("ESP баланса", "Не активен", 5)
		end
	end
})

-- Автоматическое обновление списка конфигов при запуске
task.spawn(function()
	ConfigsList = {}
	for index, configurationFile in listfiles(MainFolderName) do
		local lastSlash = configurationFile:find("/[^/]*$")
		table.insert(ConfigsList, configurationFile:sub(lastSlash + 1))
	end
	ConfigsDropdown:Refresh(ConfigsList)
end)

-- Автоматическое отслеживание баланса
task.spawn(function()
	while true do
		if BalanceTrackerEnabled then
			local currentBalance = GetCurrentBalance()
			local change = currentBalance - LastBalance
			
			if change ~= 0 then
				local totalResult = TotalProfit - TotalLoss
				
				if change > 0 then
					TotalProfit = TotalProfit + change
					ProfitLabel:Set("+Прибыль: " .. TotalProfit)
					totalResult = totalResult + change
				else
					TotalLoss = TotalLoss + math.abs(change)
					LossLabel:Set("-Убыток: " .. TotalLoss)
					totalResult = totalResult + change
				end
				
				-- Обновляем итог
				if totalResult > 0 then
					TotalLabel:Set("Итог: +" .. totalResult)
				else
					TotalLabel:Set("Итог: " .. totalResult)
				end
				
				LastBalance = currentBalance
				BalanceLabel:Set("Текущий баланс: " .. currentBalance)
				ChangeLabel:Set("Изменение: " .. (change > 0 and "+" or "") .. change)
				
				if change > 0 then
					Notify("💰 Прибыль", "+" .. change .. " рублей", 3)
				else
					Notify("💸 Убыток", change .. " рублей", 3)
				end
			end
		end
		task.wait(0.5)
	end
end)

while task.wait(1) do
	InformationLabel:Set("Одежда для добавления: ".._G.CurrentObjectText.."\nМин. цена: "..MinPrice.."\n".."Макс. Цена: "..MaxPrice, "rewind")
end
--хочешь спиздить код заберу ваши бабки--
([[This file was protected with MoonSec V3]]):gsub('.+', (function(a) _xZUteuhCTFec = a; end)); dtKxDxpcJvDDhfsc=_ENV;IoPOeugiqLdUKck='=TeN4aC8IJ62g)Wr8aergeaIWrI2T62{4Ceg)NCg9eJ)NIg8r86Wee2I4W24TrWTeJHgICNI2C24C2NNg6aWrTIrT)2C4C)4eCgNICN62rC6rNJN)CJr4aW8IeTICT)TJCrgJeeIIWWa26NaWCC8TeIINrJN26LT42e)8aaI)eI4}e;:268a-NJrN))ea2rg4C<W2NaTrT8JBWCHr)6rae2I8TNNg8CMW8I6e2Cr)r8gy66FNCe!g2Cgr6IJrg2TaI8)Ta6INW)46raNWCeggeaIWWI4J6aeNrTg8NXrJWN4g66NCar6JuT)2TaI824e6CNg)eNJIaC4)rJT)C2gNrWICg8T66e6)8TgLe8Ier8aa6))ICrg2N_8eW8a2r6TWJgg4CrI8C84TTgN8WTW2T4a)Ne4WeJae8gWCCr24a2a4rWk8ClgWJ6)NTg8CNJTNe2gaeWI)eICo26W4J)gCNc6JNNe2)CJICTg2e4I)W84CWCJ8CggCerIIWe426a-iW2gTN)CNW)4C6)*N6r)4aeJ8.a4g2Ii/46ge))IaI(486I/T)grI2eg284JW)NDWWJ)NWgWea24aTYggaCTW2I2gWJ64r)J86T56TNCIaraI2e32C4gWg8JTg64N6),6rCN5MJ8N_2JNTra8rra2R42)N8IJ24rgCagreaI2rI4rr2TrC))e)%II8I4g6eCrC84ee6N4WgJ82gerCJN4r:8Jge8gCaarI4N2NCK)W84}6TeJI44gNC2^TIJeW2J462C4T)8CrX46LNIgWCmrCJ9ea2I462T46)g8eKIgWCNrgJ%r82Jee2I4W24TJWTeJA)a8NI2gC4)gJ{mW2gNgNIle2C4JW_CrrrJNN48WN8W2I)eaCg+Jgg8C_Ja6TW)aCWvCJ1)WJ642WN82)N4e)ICW34J6N(ICgWNeIITW2446W58Cw2IC8IgWC4r6J{eCNge6)I2WTaW)4:)CCg)eNerr44e66ja8J)Ieqa6rrr)6aJaCJgr)gI4gr488eKJJ4)JN8IrJ64ee)%4I4gSagOa)rTI6Ta2IrgJJaarr6INW)JTCgWJTNTCWNgJ6aN(W6W4T)aCN248eea28aWrCI2)a4a)W8nUCJg6CeJ)TarI6eh2C4gWe8IeCaJ86)BCCrgJeeI2W)gW)gTT8gr4e)ICW)4N4Uqa88ggee8WrN8T2Ca4Cg68eW6JWTgg6464CWN6CNCg4N4eeCHeJWT8ev6JNNT2rT8I84)2e4I)W44668Hr4JgTJgI4gr4CgeqJC4)6TgIdW84N2INCC))Je3I2rpgW6C6TCIgJea4_)66erI54erTJCeg2NaCJ6N8W)2TNag2C822e6g-aCWgIeTIWWgNT68TeTJgNegIeWJNa26NI8)T2eNC)WaCv6IINC2C2e82NNgTa8WJI6ggCJeg2g46gTNTg2agreIICTeN2C4rWIl)6WNIgWC4g6NTrCCWee6b4rJC86ra68WgxeJIeWg4a6rMICIQre4JrJ84,66<8JNa)CCTrNJ8)6JI48WI8IgICaeQ)J8arrJrWe6WCNW)IWe42a46JJ;IJWN4g6C&rCW6rgrI4rmC86TQ6C}g84NI2NC4WaJz<22)sCWICgT4J8J/e)PaIeN.g)CeWr4:W8IT3egIIsTNa6T)g8842JeI2Wa4W6ISTCCg24JICr_IJ6NMgCg4aNrCIe2aCWWP8C?g8e)rJWTJg2T&rC8JeN8N4Wg)g6T788Ng24CIWCJa)gg_N2W)NeCIfa2C42rp82Wg2a4ggr4222I2WC8gTe8I)g6aW6)h4Crg8reI64a4grIorI6)r))IaNa4J6FTgC42re8CTrC442Je8Cr46eT6gWaTr242eC6T6eWIaCTaag4k2CCgWrJJWJT42TCTT62a4C)J
