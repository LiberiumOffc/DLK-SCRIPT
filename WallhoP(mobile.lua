local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Settings = {
	touchEnabled = true,
	blinkEnabled = true
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
menuPanel.Size = UDim2.new(0, 200, 0, 150)
menuPanel.Position = UDim2.new(1, -210, 0, 70)
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
	
	-- Ждем 0.35 секунды (было 0.5)
	wait(0.35)
	
	-- Меняем цвет на зеленый
	local originalColor = hopButton.BackgroundColor3
	hopButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	
	-- Ждем 0.10 секунды
	wait(0.10)
	
	-- Возвращаем цвет
	hopButton.BackgroundColor3 = originalColor
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

print("✅ Wall Hop System loaded!")
print("⚙ - settings menu")
print("HOP - camera rotate button (90°)")
print("JUMP → 0.35s wait → HOP blinks green for 0.10s")

-- Отслеживаем прыжок
local character = player.Character
if character then
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.StateChanged:Connect(function(oldState, newState)
			if newState == Enum.HumanoidStateType.Jumping then
				coroutine.wrap(blinkAfterJump)()
			end
		end)
	end
end

player.CharacterAdded:Connect(function(newCharacter)
	task.wait(1)
	local humanoid = newCharacter:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.StateChanged:Connect(function(oldState, newState)
			if newState == Enum.HumanoidStateType.Jumping then
				coroutine.wrap(blinkAfterJump)()
			end
		end)
	end
end)

-- Пробел для ПК
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.Space then
		coroutine.wrap(blinkAfterJump)()
	end
end)
