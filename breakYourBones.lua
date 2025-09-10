
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Settings
local runningAutofarm = false
local runningUpgrade = false
local runningNextRagdoll = false
local runningRefine = false
local slamDuration = 20
local slamVelocity = 100

-- Freeze/unfreeze
local function setFrozen(char, state)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Anchored = state end
end

-- Safe teleport character
local function safeTeleport(char, cframeAbove)
    local parts = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            parts[#parts+1] = part
            part.Anchored = true
            part.AssemblyLinearVelocity = Vector3.new()
            part.AssemblyAngularVelocity = Vector3.new()
        end
    end

    for _, part in pairs(parts) do
        part.CFrame = cframeAbove + Vector3.new(math.random(-1,1), 0, math.random(-1,1))
    end

    -- small wait to let physics settle
    task.wait(0.3)

    -- unanchor parts
    for _, part in pairs(parts) do
        part.Anchored = false
    end
end

-- Fire ragdoll
local function fireRagdollTouch()
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local ragdollPart = workspace:FindFirstChild("RagdollParts") and workspace.RagdollParts:FindFirstChild("RagdollCollission")
    if hrp and ragdollPart then
        local touchInterest = ragdollPart:FindFirstChildOfClass("TouchTransmitter")
        if touchInterest then
            firetouchinterest(hrp, ragdollPart, 0)
            task.wait()
            firetouchinterest(hrp, ragdollPart, 1)
        end
    end
end

-- Autofarm loop
local function autofarmLoop()
    while runningAutofarm do
        local char = plr.Character
        if not char then
            task.wait(1)
        else
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local spawnFolder = workspace:FindFirstChild("Spawn")
            if hrp and head and spawnFolder then
                local targetPart = workspace:GetChildren()[50]
                local teleportTarget = spawnFolder:GetChildren()[84]
                if targetPart and teleportTarget then
                    fireRagdollTouch()
                    local startTime = tick()
                    while tick()-startTime < slamDuration and runningAutofarm do
                        if not (hrp and head and targetPart) then break end
                        local direction = (targetPart.Position - hrp.Position).Unit
                        local velocity = direction * slamVelocity
                        for _, partName in pairs({"HumanoidRootPart","Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}) do
                            local part = char:FindFirstChild(partName)
                            if part then
                                part.AssemblyLinearVelocity = velocity + Vector3.new(0,15,0)
                            end
                        end
                        task.wait(0.15)
                    end
                    -- Freeze + safe teleport
                    setFrozen(char,true)
                    safeTeleport(char, teleportTarget.CFrame + Vector3.new(0,10,0))
                    setFrozen(char,false)
                    -- Wait respawn
                    local oldChar = char
                    repeat task.wait(0.5) until not runningAutofarm or (plr.Character ~= oldChar and plr.Character:FindFirstChild("HumanoidRootPart"))
                    if not runningAutofarm then return end
                    task.wait(1)
                    fireRagdollTouch()
                else
                    task.wait(1)
                end
            else
                task.wait(1)
            end
        end
    end
end

-- Auto upgrade
local function autoUpgradeLoop()
    while runningUpgrade do
        Remotes.PurchaseBoneUpgrade:FireServer("Head")
        Remotes.PurchaseBoneUpgrade:FireServer("Torso")
        Remotes.PurchaseBoneUpgrade:FireServer("Arm")
        Remotes.PurchaseBoneUpgrade:FireServer("Leg")
        task.wait(0.2)
    end
end

-- Auto next ragdoll
local function autoNextRagdollLoop()
    while runningNextRagdoll do
        Remotes.PurchaseNextRagdoll:FireServer()
        task.wait(0.5)
    end
end

-- Auto refine
local function autoRefineLoop()
    while runningRefine do
        Remotes.RefineRagdoll:FireServer()
        task.wait(0.5)
    end
end

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create window
local Window = Rayfield:CreateWindow({
    Name = "Break your Bones | DLK V1.0",
    LoadingTitle = "Dadilk's Script",
    LoadingSubtitle = "by Dadilk",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BreakYourBonesDLK",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Main tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Autofarm toggle
local AutofarmToggle = MainTab:CreateToggle({
    Name = "Autofarm",
    CurrentValue = false,
    Flag = "AutofarmToggle",
    Callback = function(Value)
        runningAutofarm = Value
        if Value then 
            task.spawn(autofarmLoop) 
        end
    end,
})

-- Slam Duration slider
local SlamDurationSlider = MainTab:CreateSlider({
    Name = "Slam Duration",
    Range = {5, 60},
    Increment = 1,
    Suffix = "sec",
    CurrentValue = 20,
    Flag = "SlamDuration",
    Callback = function(Value)
        slamDuration = Value
    end,
})

-- Slam Velocity slider
local SlamVelocitySlider = MainTab:CreateSlider({
    Name = "Slam Velocity",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs/sec",
    CurrentValue = 100,
    Flag = "SlamVelocity",
    Callback = function(Value)
        slamVelocity = Value
    end,
})

-- Auto Upgrade toggle
local UpgradeToggle = MainTab:CreateToggle({
    Name = "Auto Upgrade Bones",
    CurrentValue = false,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        runningUpgrade = Value
        if Value then 
            task.spawn(autoUpgradeLoop) 
        end
    end,
})

-- Auto Next Ragdoll toggle
local NextRagdollToggle = MainTab:CreateToggle({
    Name = "Auto Purchase Next Ragdoll",
    CurrentValue = false,
    Flag = "AutoNextRagdoll",
    Callback = function(Value)
        runningNextRagdoll = Value
        if Value then 
            task.spawn(autoNextRagdollLoop) 
        end
    end,
})

-- Auto Refine toggle
local RefineToggle = MainTab:CreateToggle({
    Name = "Auto Refine Ragdoll",
    CurrentValue = false,
    Flag = "AutoRefine",
    Callback = function(Value)
        runningRefine = Value
        if Value then 
            task.spawn(autoRefineLoop) 
        end
    end,
})

-- Initialize Rayfield
Rayfield:LoadConfiguration()