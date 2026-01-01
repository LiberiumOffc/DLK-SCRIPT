local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = {
	touchEnabled = true,
	blinkEnabled = true,
	shiftLockEnabled = false
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WallHopSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

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

local menuPanel = Instance.new("Frame")
menuPanel.Name = "MenuPanel"
menuPanel.Size = UDim2.new(0, 220, 0, 210)
menuPanel.Position = UDim2.new(1, -230, 0, 70)
menuPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menuPanel.Visible = false

local menuPanelCorner = Instance.new("UICorner")
menuPanelCorner.CornerRadius = UDim.new(0, 10)
menuPanelCorner.Parent = menuPanel

local menuTitle = Instance.new("TextLabel")
menuTitle.Name = "Title"
menuTitle.Size = UDim2.new(1, 0, 0, 40)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "SETTINGS"
menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
menuTitle.TextSize = 18
menuTitle.Font = Enum.Font.FredokaOne
menuTitle.Parent = menuPanel

local touchToggleFrame = Instance.new("Frame")
touchToggleFrame.Name = "TouchToggle"
touchToggleFrame.Size = UDim2.new(1, -20, 0, 40)
touchToggleFrame.Position = UDim2.new(0, 10, 0, 50)
touchToggleFrame.BackgroundTransparency = 1

local touchLabel = Instance.new("TextLabel")
touchLabel.Name = "Label"
touchLabel.Size = UDim2.new(0.7, 0, 1, 0)
touchLabel.BackgroundTransparency = 1
touchLabel.Text = "MOVE BUTTON"
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
touchToggle.Text = "ON"
touchToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
touchToggle.TextSize = 14
touchToggle.Font = Enum.Font.GothamBold

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = touchToggle
touchToggle.Parent = touchToggleFrame
touchToggleFrame.Parent = menuPanel

local blinkToggleFrame = Instance.new("Frame")
blinkToggleFrame.Name = "BlinkToggle"
blinkToggleFrame.Size = UDim2.new(1, -20, 0, 40)
blinkToggleFrame.Position = UDim2.new(0, 10, 0, 100)
blinkToggleFrame.BackgroundTransparency = 1

local blinkLabel = Instance.new("TextLabel")
blinkLabel.Name = "Label"
blinkLabel.Size = UDim2.new(0.7, 0, 1, 0)
blinkLabel.BackgroundTransparency = 1
blinkLabel.Text = "BLINK AFTER JUMP"
blinkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
blinkLabel.TextSize = 16
blinkLabel.TextXAlignment = Enum.TextXAlignment.Left
blinkLabel.Font = Enum.Font.Gotham
blinkLabel.Parent = blinkToggleFrame

local blinkToggle = Instance.new("TextButton")
blinkToggle.Name = "Toggle"
blinkToggle.Size = UDim2.new(0, 60, 0, 30)
blinkToggle.Position = UDim2.new(1, -60, 0.5, -15)
blinkToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
blinkToggle.Text = "ON"
blinkToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
blinkToggle.TextSize = 14
blinkToggle.Font = Enum.Font.GothamBold

local blinkToggleCorner = Instance.new("UICorner")
blinkToggleCorner.CornerRadius = UDim.new(0, 15)
blinkToggleCorner.Parent = blinkToggle
blinkToggle.Parent = blinkToggleFrame
blinkToggleFrame.Parent = menuPanel

local shiftLockToggleFrame = Instance.new("Frame")
shiftLockToggleFrame.Name = "ShiftLockToggle"
shiftLockToggleFrame.Size = UDim2.new(1, -20, 0, 40)
shiftLockToggleFrame.Position = UDim2.new(0, 10, 0, 150)
shiftLockToggleFrame.BackgroundTransparency = 1

local shiftLockLabel = Instance.new("TextLabel")
shiftLockLabel.Name = "Label"
shiftLockLabel.Size = UDim2.new(0.7, 0, 1, 0)
shiftLockLabel.BackgroundTransparency = 1
shiftLockLabel.Text = "SHIFT LOCK"
shiftLockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
shiftLockLabel.TextSize = 16
shiftLockLabel.TextXAlignment = Enum.TextXAlignment.Left
shiftLockLabel.Font = Enum.Font.Gotham
shiftLockLabel.Parent = shiftLockToggleFrame

local shiftLockToggle = Instance.new("TextButton")
shiftLockToggle.Name = "Toggle"
shiftLockToggle.Size = UDim2.new(0, 60, 0, 30)
shiftLockToggle.Position = UDim2.new(1, -60, 0.5, -15)
shiftLockToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
shiftLockToggle.Text = "OFF"
shiftLockToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
shiftLockToggle.TextSize = 14
shiftLockToggle.Font = Enum.Font.GothamBold

local shiftLockToggleCorner = Instance.new("UICorner")
shiftLockToggleCorner.CornerRadius = UDim.new(0, 15)
shiftLockToggleCorner.Parent = shiftLockToggle
shiftLockToggle.Parent = shiftLockToggleFrame
shiftLockToggleFrame.Parent = menuPanel
menuPanel.Parent = screenGui

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

local originalCFrame
local isButtonPressed = false
local dragStartPosition
local lastBlinkEndTime = 0

local function rotateCamera()
	local camera = workspace.CurrentCamera
	if not camera then return end
	
	originalCFrame = camera.CFrame
	camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(-90), 0)
end

local function returnCamera()
	local camera = workspace.CurrentCamera
	if not camera or not originalCFrame then return end
	
	camera.CFrame = originalCFrame
	originalCFrame = nil
end

local function blinkAfterJump()
	if not Settings.blinkEnabled then return end
	
	-- Ждем 0.35 секунды
	task.wait(0.35)
	
	-- Запоминаем время начала мигания
	local blinkStartTime = tick()
	
	-- Меняем цвет на зеленый
	hopButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	
	-- Ждем 0.10 секунды
	task.wait(0.10)
	
	-- Возвращаем цвет только если это наше мигание
	if tick() - blinkStartTime >= 0.09 then -- 0.09 чтобы учесть задержки
		if Settings.touchEnabled then
			hopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		else
			hopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
		lastBlinkEndTime = tick()
	end
end

local function enableTouchControl()
	Settings.touchEnabled = true
	touchToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	touchToggle.Text = "ON"
	hopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end

local function disableTouchControl()
	Settings.touchEnabled = false
	touchToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	touchToggle.Text = "OFF"
	hopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end

local function enableBlink()
	Settings.blinkEnabled = true
	blinkToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	blinkToggle.Text = "ON"
end

local function disableBlink()
	Settings.blinkEnabled = false
	blinkToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	blinkToggle.Text = "OFF"
	
	-- Сразу возвращаем цвет
	if Settings.touchEnabled then
		hopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	else
		hopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end
end

local function enableShiftLock()
	Settings.shiftLockEnabled = true
	shiftLockToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	shiftLockToggle.Text = "ON"
	
	player.DevEnableMouseLock = true
	
	if player.Character then
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.AutoRotate = false
		end
	end
end

local function disableShiftLock()
	Settings.shiftLockEnabled = false
	shiftLockToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	shiftLockToggle.Text = "OFF"
	
	player.DevEnableMouseLock = false
	
	if player.Character then
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.AutoRotate = true
		end
	end
end

hopButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or 
	   input.UserInputType == Enum.UserInputType.Touch then
		
		isButtonPressed = true
		dragStartPosition = input.Position
		rotateCamera()
	end
end)

hopButton.InputChanged:Connect(function(input)
	if not Settings.touchEnabled then return end
	
	if isButtonPressed and (input.UserInputType == Enum.UserInputType.MouseMovement or 
	   input.UserInputType == Enum.UserInputType.Touch) then
		
		local delta = input.Position - dragStartPosition
		local currentPos = hopButton.Position
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
		returnCamera()
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.Touch then
		local touchPos = input.Position
		local buttonAbsPos = hopButton.AbsolutePosition
		local buttonSize = hopButton.AbsoluteSize
		
		if not (touchPos.X >= buttonAbsPos.X and touchPos.X <= buttonAbsPos.X + buttonSize.X and
				touchPos.Y >= buttonAbsPos.Y and touchPos.Y <= buttonAbsPos.Y + buttonSize.Y) then
			isButtonPressed = false
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 or 
	   input.UserInputType == Enum.UserInputType.Touch then
		
		if isButtonPressed then
			returnCamera()
			isButtonPressed = false
		end
	end
end)

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

blinkToggle.MouseButton1Click:Connect(function()
	if Settings.blinkEnabled then
		disableBlink()
	else
		enableBlink()
	end
end)

shiftLockToggle.MouseButton1Click:Connect(function()
	if Settings.shiftLockEnabled then
		disableShiftLock()
	else
		enableShiftLock()
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if menuOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mousePos = input.Position
		local menuAbsPos = menuPanel.AbsolutePosition
		local menuSize = menuPanel.AbsoluteSize
		local buttonAbsPos = menuButton.AbsolutePosition
		local buttonSize = menuButton.AbsoluteSize
		
		if (mousePos.X < menuAbsPos.X or mousePos.X > menuAbsPos.X + menuSize.X or
			mousePos.Y < menuAbsPos.Y or mousePos.Y > menuAbsPos.Y + menuSize.Y) and
		   (mousePos.X < buttonAbsPos.X or mousePos.X > buttonAbsPos.X + buttonSize.X or
			mousePos.Y < buttonAbsPos.Y or mousePos.Y > buttonAbsPos.Y + buttonSize.Y) then
			
			menuOpen = false
			menuPanel.Visible = false
		end
	end
end)

enableTouchControl()
enableBlink()
disableShiftLock()

print("✅ Wall Hop System loaded!")
print("⚙ - settings menu")
print("HOP - camera rotate button (90°)")
print("JUMP → 0.35s wait → HOP blinks green for 0.10s")

-- Простая функция отслеживания прыжков
local function setupJumpTracking()
	local character = player.Character
	if not character then return end
	
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end
	
	humanoid.StateChanged:Connect(function(oldState, newState)
		if newState == Enum.HumanoidStateType.Jumping then
			-- Запускаем мигание в отдельной задаче
			task.spawn(function()
				blinkAfterJump()
			end)
		end
	end)
end

-- Настраиваем отслеживание
if player.Character then
	setupJumpTracking()
end

player.CharacterAdded:Connect(function(character)
	task.wait(0.5)
	setupJumpTracking()
	
	-- Применяем Shift Lock если включен
	if Settings.shiftLockEnabled and character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.AutoRotate = false
		end
	end
end)

-- Пробел для ПК
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.Space then
		task.spawn(blinkAfterJump)
	end
end)

-- ФИНАЛЬНЫЙ ФИКС: Периодическая проверка цвета
task.spawn(function()
	while true do
		task.wait(1) -- Проверяем каждую секунду
		
		-- Если кнопка зеленая больше 0.5 секунды - исправляем
		if hopButton.BackgroundColor3 == Color3.fromRGB(0, 255, 0) then
			-- Ждем еще 0.2 секунды на случай нормального мигания
			task.wait(0.2)
			
			-- Если все еще зеленая - исправляем
			if hopButton.BackgroundColor3 == Color3.fromRGB(0, 255, 0) then
				if Settings.touchEnabled then
					hopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
				else
					hopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				end
				print("🔄 Fixed stuck green button")
			end
		end
	end
end)
