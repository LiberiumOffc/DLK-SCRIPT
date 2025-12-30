-- LocalScript (поместить в StarterGui)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Настройки
local Settings = {
	touchEnabled = true,
	rotationAngle = -90  -- Влево
}

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WallHopSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- === МЕНЮ НАСТРОЕК ===
local menuButton = Instance.new("TextButton")
menuButton.Name = "MenuButton"
menuButton.Size = UDim2.new(0, 50, 0, 50)
menuButton.Position = UDim2.new(1, -60, 0, 10)
menuButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
menuButton.Text = "⚙"
menuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
menuButton.TextSize = 24
menuButton.Font = Enum.Font.FredokaOne

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = menuButton

menuButton.Parent = screenGui

-- Панель меню
local menuPanel = Instance.new("Frame")
menuPanel.Name = "MenuPanel"
menuPanel.Size = UDim2.new(0, 200, 0, 120)
menuPanel.Position = UDim2.new(1, -210, 0, 70)
menuPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menuPanel.Visible = false

local menuPanelCorner = Instance.new("UICorner")
menuPanelCorner.CornerRadius = UDim.new(0, 10)
menuPanelCorner.Parent = menuPanel

-- Заголовок
local menuTitle = Instance.new("TextLabel")
menuTitle.Name = "Title"
menuTitle.Size = UDim2.new(1, 0, 0, 40)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "НАСТРОЙКИ"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.TextSize = 18
menuTitle.Font = Enum.Font.FredokaOne
menuTitle.Parent = menuPanel

-- Переключатель Touch
local touchToggleFrame = Instance.new("Frame")
touchToggleFrame.Name = "TouchToggle"
touchToggleFrame.Size = UDim2.new(1, -20, 0, 40)
touchToggleFrame.Position = UDim2.new(0, 10, 0, 50)
touchToggleFrame.BackgroundTransparency = 1

local touchLabel = Instance.new("TextLabel")
touchLabel.Name = "Label"
touchLabel.Size = UDim2.new(0.7, 0, 1, 0)
touchLabel.BackgroundTransparency = 1
touchLabel.Text = "ДВИГАТЬ КНОПКУ"
touchLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
touchLabel.TextSize = 16
touchLabel.TextXAlignment = Enum.TextXAlignment.Left
touchLabel.Font = Enum.Font.Gotham
touchLabel.Parent = touchToggleFrame

local touchToggle = Instance.new("TextButton")
touchToggle.Name = "Toggle"
touchToggle.Size = UDim2.new(0, 60, 0, 30)
touchToggle.Position = UDim2.new(1, -60, 0.5, -15)
touchToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
touchToggle.Text = "ДА"
touchToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
touchToggle.TextSize = 14
touchToggle.Font = Enum.Font.GothamBold

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = touchToggle

touchToggle.Parent = touchToggleFrame
touchToggleFrame.Parent = menuPanel
menuPanel.Parent = screenGui

-- === КНОПКА HOP ===
local hopButton = Instance.new("TextButton")
hopButton.Name = "HopButton"
hopButton.Size = UDim2.new(0, 100, 0, 100)
hopButton.Position = UDim2.new(0, 50, 0.5, -50)
hopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
hopButton.Text = "HOP"
hopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hopButton.TextSize = 20
hopButton.Font = Enum.Font.FredokaOne
hopButton.BackgroundTransparency = 0.3

local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 20)
hopCorner.Parent = hopButton

hopButton.Parent = screenGui

-- === ПЕРЕМЕННЫЕ ===
local originalCFrame
local isButtonPressed = false
local dragStartPosition

-- === ФУНКЦИИ КАМЕРЫ (РЕЗКИЕ) ===
local function rotateCamera()
	local camera = workspace.CurrentCamera
	if not camera then return end
	
	originalCFrame = camera.CFrame
	-- РЕЗКИЙ ПОВОРОТ БЕЗ АНИМАЦИИ
	camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(Settings.rotationAngle), 0)
end

local function returnCamera()
	local camera = workspace.CurrentCamera
	if not camera or not originalCFrame then return end
	
	-- РЕЗКИЙ ВОЗВРАТ БЕЗ АНИМАЦИИ
	camera.CFrame = originalCFrame
	originalCFrame = nil
end

-- === УПРАВЛЕНИЕ TOUCH ===
local function enableTouchControl()
	Settings.touchEnabled = true
	touchToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	touchToggle.Text = "ДА"
	hopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end

local function disableTouchControl()
	Settings.touchEnabled = false
	touchToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	touchToggle.Text = "НЕТ"
	hopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Серый когда не двигается
end

-- === ФУНКЦИЯ ПРОВЕРКИ КАСАНИЯ КНОПКИ ===
local function isTouchOnButton(inputPosition)
	local buttonAbsPos = hopButton.AbsolutePosition
	local buttonSize = hopButton.AbsoluteSize
	
	return inputPosition.X >= buttonAbsPos.X and 
		   inputPosition.X <= buttonAbsPos.X + buttonSize.X and
		   inputPosition.Y >= buttonAbsPos.Y and 
		   inputPosition.Y <= buttonAbsPos.Y + buttonSize.Y
end

-- === ОБРАБОТЧИКИ HOP КНОПКИ ===
hopButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or 
	   input.UserInputType == Enum.UserInputType.Touch then
		
		isButtonPressed = true
		dragStartPosition = input.Position
		-- РЕЗКИЙ ПОВОРОТ СРАЗУ
		rotateCamera()
	end
end)

hopButton.InputChanged:Connect(function(input)
	if not Settings.touchEnabled then return end -- НЕ ДВИГАЕМ если выключено
	
	-- ПРОВЕРЯЕМ что это именно перетаскивание кнопки, а не случайное касание
	if isButtonPressed and (input.UserInputType == Enum.UserInputType.MouseMovement or 
	   input.UserInputType == Enum.UserInputType.Touch) then
		
		-- ДВИГАЕМ КНОПКУ РЕЗКО только если включено
		local delta = input.Position - dragStartPosition
		local currentPos = hopButton.Position
		
		-- Ограничиваем движение кнопки в пределах экрана
		local screenSize = screenGui.AbsoluteSize
		local buttonSize = hopButton.AbsoluteSize
		
		local newX = math.clamp(currentPos.X.Offset + delta.X, 0, screenSize.X - buttonSize.X)
		local newY = math.clamp(currentPos.Y.Offset + delta.Y, 0, screenSize.Y - buttonSize.Y)
		
		hopButton.Position = UDim2.new(0, newX, 0, newY)
		dragStartPosition = input.Position
	end
end)

hopButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or 
	   input.UserInputType == Enum.UserInputType.Touch then
		
		isButtonPressed = false
		-- РЕЗКИЙ ВОЗВРАТ СРАЗУ
		returnCamera()
	end
end)

-- Глобальный обработчик для предотвращения ложных срабатываний
UserInputService.InputBegan:Connect(function(input, processed)
	-- Если касание обработано другим элементом UI, игнорируем
	if processed then return end
	
	-- Только для касаний
	if input.UserInputType == Enum.UserInputType.Touch then
		local touchPos = input.Position
		
		-- Если касание НЕ на кнопке, сбрасываем флаги
		if not isTouchOnButton(touchPos) then
			isButtonPressed = false
		end
	end
end)

UserInputService.InputChanged:Connect(function(input, processed)
	if processed then return end
	
	-- Если палец двигается и мы НЕ нажимали на кнопку, игнорируем
	if (input.UserInputType == Enum.UserInputType.MouseMovement or 
		input.UserInputType == Enum.UserInputType.Touch) then
		
		if not isButtonPressed then
			return
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 or 
	   input.UserInputType == Enum.UserInputType.Touch then
		
		-- Если кнопка была нажата, возвращаем камеру
		if isButtonPressed then
			returnCamera()
			isButtonPressed = false
		end
	end
end)

-- === ОБРАБОТЧИКИ МЕНЮ ===
local menuOpen = false

menuButton.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	menuPanel.Visible = menuOpen
end)

touchToggle.MouseButton1Click:Connect(function()
	if Settings.touchEnabled then
		disableTouchControl()
	else
		enableTouchControl()
	end
end)

-- Закрытие меню при клике вне его
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if menuOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mousePos = input.Position
		local menuAbsPos = menuPanel.AbsolutePosition
		local menuSize = menuPanel.AbsoluteSize
		local buttonAbsPos = menuButton.AbsolutePosition
		local buttonSize = menuButton.AbsoluteSize
		
		-- Проверяем клик вне меню и вне кнопки меню
		if (mousePos.X < menuAbsPos.X or mousePos.X > menuAbsPos.X + menuSize.X or
			mousePos.Y < menuAbsPos.Y or mousePos.Y > menuAbsPos.Y + menuSize.Y) and
		   (mousePos.X < buttonAbsPos.X or mousePos.X > buttonAbsPos.X + buttonSize.X or
			mousePos.Y < buttonAbsPos.Y or mousePos.Y > buttonAbsPos.Y + buttonSize.Y) then
			
			menuOpen = false
			menuPanel.Visible = false
		end
	end
end)

-- === ИНИЦИАЛИЗАЦИЯ ===
enableTouchControl()

print("✅ Wall Hop System загружен!")
print("⚙ - меню настроек")
print("HOP - кнопка управления")
print("⚠ Теперь кнопка не срабатывает при случайных касаниях!")
