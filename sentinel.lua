-- Roblox Sentinel
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Check and create Sentinel folder
local sentinelFolder = "C:/Sentinel/"
local configFolder = sentinelFolder .. "Configs/"

-- Create folders using exploit functions or os
if makefolder and isfolder then
    if not isfolder(sentinelFolder) then
        makefolder(sentinelFolder)
    end
    if not isfolder(configFolder) then
        makefolder(configFolder)
    end
    print("Sentinel folder: " .. sentinelFolder)
elseif os and os.execute then
    pcall(function()
        os.execute('mkdir "' .. sentinelFolder:gsub("/", "\\") .. '" 2>nul')
        os.execute('mkdir "' .. configFolder:gsub("/", "\\") .. '" 2>nul')
    end)
    print("Sentinel folder: " .. sentinelFolder)
else
    warn("No file system functions available")
end

-- Settings
local Settings = {
    ESP = false,
    Fullbright = false,
    HealthBar = false,
    Name = false,
    Distance = false,
    TeamCheck = false,
    FilledBox = false,
    BoxCorner = false,
    BoxColor = Color3.fromRGB(255, 0, 0),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    ESPMaxDistance = 2000,
    Aimbot = false,
    AimbotFOV = 100,
    ShowFOV = false,
    FOVColor = Color3.fromRGB(255, 255, 255),
    AimbotSmooth = 1,
    AimbotHitbox = "Head",
    AimLock = false,
    AimbotMaxDistance = 500,
    NoRecoil = false,
    RecoilStrength = 50,
    Prediction = false,
    PredictionStrength = 10,
    InfiniteJump = false,
    DebugPanel = false,
    DebugPanelPos = {X = -360, Y = 10} -- Позиция дебаг панели
}

-- Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Color = Settings.FOVColor
FOVCircle.Visible = Settings.ShowFOV
FOVCircle.Transparency = 1
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Settings.AimbotFOV
    local closestHitbox = nil
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil, nil
    end
    
    local localHRP = LocalPlayer.Character.HumanoidRootPart
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                -- Check distance limit
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local distanceToPlayer = (hrp.Position - localHRP.Position).Magnitude
                    if distanceToPlayer > Settings.AimbotMaxDistance then
                        continue
                    end
                end
                
                local hitboxes = {}
                
                -- Auto hitbox - find all possible hitboxes
                if Settings.AimbotHitbox == "Auto" then
                    local head = character:FindFirstChild("Head")
                    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                    local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
                    local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
                    local leftLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg")
                    local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg")
                    
                    if head then table.insert(hitboxes, head) end
                    if torso then table.insert(hitboxes, torso) end
                    if leftArm then table.insert(hitboxes, leftArm) end
                    if rightArm then table.insert(hitboxes, rightArm) end
                    if leftLeg then table.insert(hitboxes, leftLeg) end
                    if rightLeg then table.insert(hitboxes, rightLeg) end
                else
                    -- Specific hitbox
                    local hitbox = nil
                    if Settings.AimbotHitbox == "Torso" then
                        hitbox = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                    else
                        hitbox = character:FindFirstChild(Settings.AimbotHitbox)
                    end
                    if hitbox then table.insert(hitboxes, hitbox) end
                end
                
                -- Find closest hitbox to crosshair
                for _, hitbox in ipairs(hitboxes) do
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hitbox.Position)
                    
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        
                        if distance < shortestDistance then
                            closestPlayer = player
                            closestHitbox = hitbox
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer, closestHitbox
end

local lockedTarget = nil
local lockedHitbox = nil
local oldCameraCFrame = nil
local lastCameraRotation = nil

-- Function to calculate predicted position
local function GetPredictedPosition(hitbox, distance)
    if not Settings.Prediction then
        return hitbox.Position
    end
    
    -- Calculate velocity
    local velocity = hitbox.AssemblyLinearVelocity or hitbox.Velocity or Vector3.new(0, 0, 0)
    
    -- Calculate prediction based on distance in 10 meter steps up to 1000m
    -- Each 10m adds more prediction
    local distanceSteps = math.min(math.floor(distance / 10), 100) -- Max 100 steps (1000m)
    local predictionTime = (distanceSteps / 100) * (Settings.PredictionStrength / 10)
    
    -- Calculate predicted position
    local predictedPos = hitbox.Position + (velocity * predictionTime)
    
    return predictedPos
end

local function UpdateAimbot()
    local isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local isShooting = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    
    -- No Recoil - compensate recoil only when shooting
    if Settings.NoRecoil and isShooting then
        local currentRotation = Camera.CFrame.LookVector
        
        if lastCameraRotation then
            -- Calculate camera rotation change
            local rotationChange = currentRotation - lastCameraRotation
            
            -- If camera moved up (recoil), compensate by moving mouse down
            if rotationChange.Y > 0.0001 then
                -- Convert 3D rotation to screen space with adjustable strength
                local recoilStrength = rotationChange.Y * Settings.RecoilStrength * 100
                
                if mousemoverel then
                    mousemoverel(0, recoilStrength) -- Move mouse down to compensate
                end
            end
        end
        
        lastCameraRotation = currentRotation
    else
        lastCameraRotation = nil
    end
    
    -- Only aim when right mouse button is pressed
    if isAiming then
        local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        -- AimLock - instant lock
        if Settings.AimLock then
            if not lockedTarget or not lockedTarget.Character then
                lockedTarget, lockedHitbox = GetClosestPlayer()
            end
            
            if lockedTarget and lockedTarget.Character and lockedHitbox and localHRP then
                local distance = (lockedHitbox.Position - localHRP.Position).Magnitude
                local predictedPos = GetPredictedPosition(lockedHitbox, distance)
                local targetPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local deltaX = targetPos.X - mousePos.X
                    local deltaY = targetPos.Y - mousePos.Y
                    
                    if mousemoverel then
                        mousemoverel(deltaX, deltaY)
                    end
                end
            end
        end
        
        -- Smooth Aimbot (works independently)
        if Settings.Aimbot and not Settings.AimLock then
            local target, hitbox = GetClosestPlayer()
            if target and target.Character and hitbox and localHRP then
                local distance = (hitbox.Position - localHRP.Position).Magnitude
                local predictedPos = GetPredictedPosition(hitbox, distance)
                local targetPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local deltaX = targetPos.X - mousePos.X
                    local deltaY = targetPos.Y - mousePos.Y
                    
                    -- Apply smoothing
                    local smoothFactor = 1 / Settings.AimbotSmooth
                    deltaX = deltaX * smoothFactor
                    deltaY = deltaY * smoothFactor
                    
                    if mousemoverel then
                        mousemoverel(deltaX, deltaY)
                    end
                end
            end
        end
    else
        -- Reset locked target when not aiming
        lockedTarget = nil
        lockedHitbox = nil
    end
    
    -- Update FOV circle
    FOVCircle.Visible = Settings.ShowFOV
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Color = Settings.FOVColor
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

-- Infinite Jump with Anti-Cheat Bypass
local oldIndex = nil
local oldNamecall = nil
local lastJumpTime = 0

local function SetupHooks()
    if not hookmetamethod or not checkcaller then
        return
    end
    
    -- Hook __index to fake properties
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if checkcaller() == false and self:IsA("Humanoid") then
            -- Infinite Jump - only when enabled
            if Settings.InfiniteJump then
                -- Fake that we're always on ground for anti-cheat
                if key == "FloorMaterial" then
                    return Enum.Material.Plastic
                end
            end
        end
        return oldIndex(self, key)
    end)
    
    -- Hook __namecall to intercept calls
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if checkcaller() == false and self:IsA("Humanoid") then
            -- Infinite Jump checks
            if Settings.InfiniteJump then
                -- Block anti-cheat from detecting jump spam
                if method == "GetState" or method == "GetStateEnabled" then
                    return oldNamecall(self, ...)
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end

local function UpdateInfiniteJump()
    if not Settings.InfiniteJump then
        return
    end
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            -- Listen for jump input
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                local currentTime = tick()
                -- Add delay to prevent instant spam and make jumps normal height
                if currentTime - lastJumpTime > 0.2 then
                    -- Use ChangeState to force jump
                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end)
                    lastJumpTime = currentTime
                end
            end
        end
    end
end

-- Setup hooks
SetupHooks()

-- Debug Panel
local DebugGui = Instance.new("ScreenGui")
DebugGui.Name = "DebugPanel"
DebugGui.ResetOnSpawn = false
DebugGui.Enabled = false
DebugGui.Parent = game:GetService("CoreGui")

local DebugFrame = Instance.new("Frame")
DebugFrame.Size = UDim2.new(0, 350, 0, 500)
DebugFrame.Position = UDim2.new(1, Settings.DebugPanelPos.X, 0, Settings.DebugPanelPos.Y)
DebugFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
DebugFrame.BorderSizePixel = 2
DebugFrame.BorderColor3 = Color3.fromRGB(100, 50, 200)
DebugFrame.Parent = DebugGui

local DebugCorner = Instance.new("UICorner")
DebugCorner.CornerRadius = UDim.new(0, 10)
DebugCorner.Parent = DebugFrame

local DebugTitle = Instance.new("TextLabel")
DebugTitle.Size = UDim2.new(1, 0, 0, 30)
DebugTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
DebugTitle.Text = "Debug Panel"
DebugTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DebugTitle.TextSize = 14
DebugTitle.Font = Enum.Font.GothamBold
DebugTitle.BorderSizePixel = 0
DebugTitle.Parent = DebugFrame

local DebugTitleCorner = Instance.new("UICorner")
DebugTitleCorner.CornerRadius = UDim.new(0, 10)
DebugTitleCorner.Parent = DebugTitle

-- Drag functionality for Debug Panel
local debugDragging = false
local debugDragStart = nil
local debugStartPos = nil

DebugTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        debugDragging = true
        debugDragStart = input.Position
        debugStartPos = DebugFrame.Position
    end
end)

DebugTitle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        debugDragging = false
        -- Сохраняем позицию
        Settings.DebugPanelPos.X = DebugFrame.Position.X.Offset
        Settings.DebugPanelPos.Y = DebugFrame.Position.Y.Offset
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if debugDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - debugDragStart
        DebugFrame.Position = UDim2.new(
            debugStartPos.X.Scale,
            debugStartPos.X.Offset + delta.X,
            debugStartPos.Y.Scale,
            debugStartPos.Y.Offset + delta.Y
        )
    end
end)

local DebugScroll = Instance.new("ScrollingFrame")
DebugScroll.Size = UDim2.new(1, -10, 1, -40)
DebugScroll.Position = UDim2.new(0, 5, 0, 35)
DebugScroll.BackgroundTransparency = 1
DebugScroll.BorderSizePixel = 0
DebugScroll.ScrollBarThickness = 4
DebugScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
DebugScroll.Parent = DebugFrame

local DebugLayout = Instance.new("UIListLayout")
DebugLayout.Padding = UDim.new(0, 3)
DebugLayout.Parent = DebugScroll

local debugLabels = {}

local function CreateDebugLabel(name)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 22)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = DebugScroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.45, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.55, -5, 1, 0)
    valueLabel.Position = UDim2.new(0.45, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = "N/A"
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.Code
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    debugLabels[name] = valueLabel
end

local function CreateDebugSection(title)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -10, 0, 18)
    section.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    section.Text = "  " .. title
    section.TextColor3 = Color3.fromRGB(255, 255, 255)
    section.TextSize = 12
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.BorderSizePixel = 0
    section.Parent = DebugScroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = section
end

local function UpdateDebugLabel(name, value)
    if debugLabels[name] then
        debugLabels[name].Text = tostring(value)
    end
end

-- Create debug sections
CreateDebugSection("POSITION")
CreateDebugLabel("X")
CreateDebugLabel("Y")
CreateDebugLabel("Z")

CreateDebugSection("HEALTH")
CreateDebugLabel("HP")
CreateDebugLabel("Max HP")

CreateDebugSection("MOVEMENT")
CreateDebugLabel("WalkSpeed")
CreateDebugLabel("JumpPower")

CreateDebugSection("VELOCITY")
CreateDebugLabel("Vel X")
CreateDebugLabel("Vel Y")
CreateDebugLabel("Vel Z")
CreateDebugLabel("Speed")

CreateDebugSection("CAMERA")
CreateDebugLabel("Cam X")
CreateDebugLabel("Cam Y")
CreateDebugLabel("Cam Z")
CreateDebugLabel("FOV")

CreateDebugSection("NEAREST PLAYER")
CreateDebugLabel("Name")
CreateDebugLabel("Distance")
CreateDebugLabel("Health")

-- Update debug panel
local function UpdateDebugPanel()
    if not Settings.DebugPanel then
        DebugGui.Enabled = false
        return
    end
    
    DebugGui.Enabled = true
    
    if LocalPlayer.Character then
        local char = LocalPlayer.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local camera = workspace.CurrentCamera
        
        -- Position
        if hrp then
            local pos = hrp.Position
            UpdateDebugLabel("X", string.format("%.2f", pos.X))
            UpdateDebugLabel("Y", string.format("%.2f", pos.Y))
            UpdateDebugLabel("Z", string.format("%.2f", pos.Z))
            
            -- Velocity
            local vel = hrp.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
            UpdateDebugLabel("Vel X", string.format("%.2f", vel.X))
            UpdateDebugLabel("Vel Y", string.format("%.2f", vel.Y))
            UpdateDebugLabel("Vel Z", string.format("%.2f", vel.Z))
            UpdateDebugLabel("Speed", string.format("%.2f", vel.Magnitude))
        end
        
        -- Health
        if humanoid then
            UpdateDebugLabel("HP", string.format("%.1f", humanoid.Health))
            UpdateDebugLabel("Max HP", string.format("%.1f", humanoid.MaxHealth))
            UpdateDebugLabel("WalkSpeed", string.format("%.1f", humanoid.WalkSpeed))
            UpdateDebugLabel("JumpPower", string.format("%.1f", humanoid.JumpPower or humanoid.JumpHeight or 0))
        end
        
        -- Camera
        if camera then
            local camPos = camera.CFrame.Position
            UpdateDebugLabel("Cam X", string.format("%.2f", camPos.X))
            UpdateDebugLabel("Cam Y", string.format("%.2f", camPos.Y))
            UpdateDebugLabel("Cam Z", string.format("%.2f", camPos.Z))
            UpdateDebugLabel("FOV", string.format("%.1f", camera.FieldOfView))
        end
        
        -- Nearest player
        if hrp then
            local nearest = nil
            local nearestDist = math.huge
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local enemyHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    if enemyHRP then
                        local dist = (enemyHRP.Position - hrp.Position).Magnitude
                        if dist < nearestDist then
                            nearest = player
                            nearestDist = dist
                        end
                    end
                end
            end
            
            if nearest then
                UpdateDebugLabel("Name", nearest.Name)
                UpdateDebugLabel("Distance", string.format("%.1f", nearestDist))
                
                local enemyHumanoid = nearest.Character:FindFirstChildOfClass("Humanoid")
                if enemyHumanoid then
                    UpdateDebugLabel("Health", string.format("%.1f", enemyHumanoid.Health))
                end
            else
                UpdateDebugLabel("Name", "None")
                UpdateDebugLabel("Distance", "0")
                UpdateDebugLabel("Health", "0")
            end
        end
    end
    
    -- Update scroll canvas
    DebugScroll.CanvasSize = UDim2.new(0, 0, 0, DebugLayout.AbsoluteContentSize.Y + 10)
end

-- ESP
local ESPBoxes = {}
local ESPCorners = {}
local ESPNames = {}
local ESPDistances = {}
local ESPHealthBars = {}

-- Model Dumper - automatically detect custom character models
local ModelCache = {}

local function DumpCharacterModel(character)
    if ModelCache[character] then
        return ModelCache[character]
    end
    
    local model = {
        RootPart = nil,
        Head = nil,
        Torso = nil,
        Humanoid = nil,
        AllParts = {}
    }
    
    -- Find Humanoid
    model.Humanoid = character:FindFirstChildOfClass("Humanoid")
    
    -- Find Root Part (priority order)
    model.RootPart = character:FindFirstChild("HumanoidRootPart") 
        or character:FindFirstChild("Torso") 
        or character:FindFirstChild("UpperTorso")
        or character.PrimaryPart
    
    -- If still no root, find largest BasePart
    if not model.RootPart then
        local largestSize = 0
        for _, child in ipairs(character:GetDescendants()) do
            if child:IsA("BasePart") then
                local size = child.Size.Magnitude
                if size > largestSize then
                    largestSize = size
                    model.RootPart = child
                end
            end
        end
    end
    
    -- Find Head (look for "Head" or part at highest Y position)
    model.Head = character:FindFirstChild("Head")
    if not model.Head and model.RootPart then
        local highestY = -math.huge
        for _, child in ipairs(character:GetDescendants()) do
            if child:IsA("BasePart") then
                if child.Position.Y > highestY then
                    highestY = child.Position.Y
                    model.Head = child
                end
            end
        end
    end
    
    -- Find Torso
    model.Torso = character:FindFirstChild("Torso") 
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("LowerTorso")
        or model.RootPart
    
    -- Collect all BaseParts for hitbox detection
    for _, child in ipairs(character:GetDescendants()) do
        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
            table.insert(model.AllParts, child)
        end
    end
    
    ModelCache[character] = model
    return model
end

-- Clear cache when character is removed
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        ModelCache[player.Character] = nil
    end
end)

-- Function to hide player ESP
local function HidePlayerESP(player)
    if ESPBoxes[player] then
        ESPBoxes[player].Visible = false
    end
    if ESPCorners[player] then
        for i = 1, 8 do
            ESPCorners[player][i].Visible = false
        end
    end
    if ESPNames[player] then
        ESPNames[player].Visible = false
    end
    if ESPDistances[player] then
        ESPDistances[player].Visible = false
    end
    if ESPHealthBars[player] then
        ESPHealthBars[player].bg.Visible = false
        ESPHealthBars[player].outline.Visible = false
        ESPHealthBars[player].bar.Visible = false
    end
end

-- Clear cache on character added/respawn and detect death
for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(character)
        ModelCache[character] = nil
        
        -- Detect death
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                HidePlayerESP(player)
                ModelCache[character] = nil
            end)
        end
    end)
    player.CharacterRemoving:Connect(function(character)
        ModelCache[character] = nil
        HidePlayerESP(player)
    end)
    
    -- Setup death detection for existing characters
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                HidePlayerESP(player)
                ModelCache[player.Character] = nil
            end)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        ModelCache[character] = nil
        
        -- Detect death
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                HidePlayerESP(player)
                ModelCache[character] = nil
            end)
        end
    end)
    player.CharacterRemoving:Connect(function(character)
        ModelCache[character] = nil
        HidePlayerESP(player)
    end)
end)

local function UpdateESP()
    -- Hide all ESP boxes first if ESP is disabled
    if not Settings.ESP then
        for _, box in pairs(ESPBoxes) do
            if box then box.Visible = false end
        end
        for _, name in pairs(ESPNames) do
            if name then name.Visible = false end
        end
        for _, distance in pairs(ESPDistances) do
            if distance then distance.Visible = false end
        end
        for _, healthBar in pairs(ESPHealthBars) do
            if healthBar and healthBar.bg then
                healthBar.bg.Visible = false
                healthBar.outline.Visible = false
                healthBar.bar.Visible = false
            end
        end
        return
    end
    
    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        -- Skip local player completely
        if player == LocalPlayer then
            if ESPBoxes[player] then
                ESPBoxes[player].Visible = false
                ESPNames[player].Visible = false
                ESPDistances[player].Visible = false
                if ESPHealthBars[player] then
                    ESPHealthBars[player].bg.Visible = false
                    ESPHealthBars[player].outline.Visible = false
                    ESPHealthBars[player].bar.Visible = false
                end
            end
        elseif player.Character then
            local character = player.Character
            local model = DumpCharacterModel(character)
            local humanoid = model.Humanoid
            local hrp = model.RootPart
            
            -- Quick validation
            local isValid = humanoid and humanoid.Health > 0 and hrp
            local passTeamCheck = not Settings.TeamCheck or player.Team ~= LocalPlayer.Team
            
            -- Check distance limit
            local withinDistance = true
            if isValid and localHRP then
                local distanceToPlayer = (hrp.Position - localHRP.Position).Magnitude
                withinDistance = distanceToPlayer <= Settings.ESPMaxDistance
            end
            
            if not isValid or not passTeamCheck or not withinDistance then
                if ESPBoxes[player] then
                    ESPBoxes[player].Visible = false
                    ESPNames[player].Visible = false
                    ESPDistances[player].Visible = false
                    if ESPHealthBars[player] then
                        ESPHealthBars[player].bg.Visible = false
                        ESPHealthBars[player].outline.Visible = false
                        ESPHealthBars[player].bar.Visible = false
                    end
                end
            else
                -- Create ESP elements only once
                if not ESPBoxes[player] then
                    ESPBoxes[player] = Drawing.new("Square")
                    ESPBoxes[player].Thickness = 2
                    
                    -- Create 8 corner lines (2 per corner)
                    ESPCorners[player] = {}
                    for i = 1, 8 do
                        ESPCorners[player][i] = Drawing.new("Line")
                        ESPCorners[player][i].Thickness = 2
                        ESPCorners[player][i].Color = Settings.BoxColor
                    end
                    
                    ESPNames[player] = Drawing.new("Text")
                    ESPNames[player].Size = 13
                    ESPNames[player].Center = true
                    ESPNames[player].Outline = true
                    ESPNames[player].Text = player.Name
                    
                    ESPDistances[player] = Drawing.new("Text")
                    ESPDistances[player].Size = 13
                    ESPDistances[player].Center = true
                    ESPDistances[player].Outline = true
                    
                    ESPHealthBars[player] = {
                        bg = Drawing.new("Square"),
                        outline = Drawing.new("Square"),
                        bar = Drawing.new("Square")
                    }
                    ESPHealthBars[player].bg.Color = Color3.fromRGB(50, 50, 50)
                    ESPHealthBars[player].bg.Thickness = 1
                    ESPHealthBars[player].bg.Filled = true
                    ESPHealthBars[player].outline.Color = Color3.fromRGB(0, 0, 0)
                    ESPHealthBars[player].outline.Thickness = 1
                    ESPHealthBars[player].outline.Filled = false
                    ESPHealthBars[player].bar.Thickness = 1
                    ESPHealthBars[player].bar.Filled = true
                end
                
                -- Update colors
                ESPBoxes[player].Color = Settings.BoxColor
                ESPBoxes[player].Filled = Settings.FilledBox
                ESPNames[player].Color = Settings.NameColor
                ESPDistances[player].Color = Settings.DistanceColor
                
                -- Update corner colors
                if ESPCorners[player] then
                    for i = 1, 8 do
                        ESPCorners[player][i].Color = Settings.BoxColor
                    end
                end
                
                -- Calculate screen position with 4 corners
                local size = Vector3.new(3, 5.5, 0)
                local tl = hrp.CFrame * CFrame.new(-size.X/2, size.Y/2, 0)
                local tr = hrp.CFrame * CFrame.new(size.X/2, size.Y/2, 0)
                local bl = hrp.CFrame * CFrame.new(-size.X/2, -size.Y/2, 0)
                local br = hrp.CFrame * CFrame.new(size.X/2, -size.Y/2, 0)
                
                local tlPos, tlVis = Camera:WorldToViewportPoint(tl.Position)
                local trPos, trVis = Camera:WorldToViewportPoint(tr.Position)
                local blPos, blVis = Camera:WorldToViewportPoint(bl.Position)
                local brPos, brVis = Camera:WorldToViewportPoint(br.Position)
                
                if tlVis and trVis and blVis and brVis then
                    local minX = math.min(tlPos.X, trPos.X, blPos.X, brPos.X)
                    local maxX = math.max(tlPos.X, trPos.X, blPos.X, brPos.X)
                    local minY = math.min(tlPos.Y, trPos.Y, blPos.Y, brPos.Y)
                    local maxY = math.max(tlPos.Y, trPos.Y, blPos.Y, brPos.Y)
                    
                    local width = maxX - minX
                    local height = maxY - minY
                    local cornerLength = math.min(width, height) * 0.25 -- 25% of smallest dimension
                    
                    -- Update box or corners
                    if Settings.BoxCorner then
                        -- Hide full box, show corners
                        ESPBoxes[player].Visible = false
                        
                        -- Top-left corner (horizontal then vertical)
                        ESPCorners[player][1].From = Vector2.new(minX, minY)
                        ESPCorners[player][1].To = Vector2.new(minX + cornerLength, minY)
                        ESPCorners[player][1].Visible = true
                        
                        ESPCorners[player][2].From = Vector2.new(minX, minY)
                        ESPCorners[player][2].To = Vector2.new(minX, minY + cornerLength)
                        ESPCorners[player][2].Visible = true
                        
                        -- Top-right corner (horizontal then vertical)
                        ESPCorners[player][3].From = Vector2.new(maxX, minY)
                        ESPCorners[player][3].To = Vector2.new(maxX - cornerLength, minY)
                        ESPCorners[player][3].Visible = true
                        
                        ESPCorners[player][4].From = Vector2.new(maxX, minY)
                        ESPCorners[player][4].To = Vector2.new(maxX, minY + cornerLength)
                        ESPCorners[player][4].Visible = true
                        
                        -- Bottom-left corner (horizontal then vertical)
                        ESPCorners[player][5].From = Vector2.new(minX, maxY)
                        ESPCorners[player][5].To = Vector2.new(minX + cornerLength, maxY)
                        ESPCorners[player][5].Visible = true
                        
                        ESPCorners[player][6].From = Vector2.new(minX, maxY)
                        ESPCorners[player][6].To = Vector2.new(minX, maxY - cornerLength)
                        ESPCorners[player][6].Visible = true
                        
                        -- Bottom-right corner (horizontal then vertical)
                        ESPCorners[player][7].From = Vector2.new(maxX, maxY)
                        ESPCorners[player][7].To = Vector2.new(maxX - cornerLength, maxY)
                        ESPCorners[player][7].Visible = true
                        
                        ESPCorners[player][8].From = Vector2.new(maxX, maxY)
                        ESPCorners[player][8].To = Vector2.new(maxX, maxY - cornerLength)
                        ESPCorners[player][8].Visible = true
                    else
                        -- Show full box, hide corners
                        ESPBoxes[player].Position = Vector2.new(minX, minY)
                        ESPBoxes[player].Size = Vector2.new(width, height)
                        ESPBoxes[player].Visible = true
                        
                        if ESPCorners[player] then
                            for i = 1, 8 do
                                ESPCorners[player][i].Visible = false
                            end
                        end
                    end
                    
                    -- Update name
                    ESPNames[player].Position = Vector2.new(minX + width/2, minY - 18)
                    ESPNames[player].Visible = Settings.Name
                    
                    -- Update distance
                    if Settings.Distance and localHRP then
                        local distance = (hrp.Position - localHRP.Position).Magnitude
                        ESPDistances[player].Text = math.floor(distance) .. "m"
                        ESPDistances[player].Position = Vector2.new(minX + width/2, maxY + 5)
                        ESPDistances[player].Visible = true
                    else
                        ESPDistances[player].Visible = false
                    end
                    
                    -- Update health bar
                    if Settings.HealthBar then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local barHeight = height
                        local barWidth = 4
                        
                        ESPHealthBars[player].bg.Position = Vector2.new(minX - barWidth - 2, minY)
                        ESPHealthBars[player].bg.Size = Vector2.new(barWidth, barHeight)
                        ESPHealthBars[player].bg.Visible = true
                        
                        ESPHealthBars[player].outline.Position = Vector2.new(minX - barWidth - 2, minY)
                        ESPHealthBars[player].outline.Size = Vector2.new(barWidth, barHeight)
                        ESPHealthBars[player].outline.Visible = true
                        
                        ESPHealthBars[player].bar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        ESPHealthBars[player].bar.Position = Vector2.new(minX - barWidth - 2, minY + barHeight * (1 - healthPercent))
                        ESPHealthBars[player].bar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                        ESPHealthBars[player].bar.Visible = true
                    else
                        ESPHealthBars[player].bg.Visible = false
                        ESPHealthBars[player].outline.Visible = false
                        ESPHealthBars[player].bar.Visible = false
                    end
                else
                    ESPBoxes[player].Visible = false
                    ESPNames[player].Visible = false
                    ESPDistances[player].Visible = false
                    ESPHealthBars[player].bg.Visible = false
                    ESPHealthBars[player].outline.Visible = false
                    ESPHealthBars[player].bar.Visible = false
                end
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Remove()
        ESPBoxes[player] = nil
    end
    if ESPCorners[player] then
        for i = 1, 8 do
            ESPCorners[player][i]:Remove()
        end
        ESPCorners[player] = nil
    end
    if ESPNames[player] then
        ESPNames[player]:Remove()
        ESPNames[player] = nil
    end
    if ESPDistances[player] then
        ESPDistances[player]:Remove()
        ESPDistances[player] = nil
    end
    if ESPHealthBars[player] then
        if ESPHealthBars[player].bg then
            ESPHealthBars[player].bg:Remove()
        end
        if ESPHealthBars[player].outline then
            ESPHealthBars[player].outline:Remove()
        end
        if ESPHealthBars[player].bar then
            ESPHealthBars[player].bar:Remove()
        end
        ESPHealthBars[player] = nil
    end
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SentinelGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad), props):Play()
end

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 400)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

-- Save menu size
local savedMenuSize = Main.Size

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

-- Mini Frame
local MiniFrame = Instance.new("Frame")
MiniFrame.Size = UDim2.new(0, 0, 0, 0)
MiniFrame.Position = UDim2.new(0, 70, 1, -30)
MiniFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MiniFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MiniFrame.BorderSizePixel = 0
MiniFrame.ClipsDescendants = true
MiniFrame.Visible = false
MiniFrame.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 10)
MiniCorner.Parent = MiniFrame

local MiniButton = Instance.new("TextButton")
MiniButton.Size = UDim2.new(1, 0, 1, 0)
MiniButton.BackgroundTransparency = 1
MiniButton.Text = "Open Menu"
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.TextSize = 14
MiniButton.Font = Enum.Font.GothamBold
MiniButton.Parent = MiniFrame

MiniButton.MouseButton1Click:Connect(function()
    Tween(MiniFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
    task.wait(0.2)
    MiniFrame.Visible = false
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Tween(Main, {Size = savedMenuSize}, 0.5)
end)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Title.Text = "  Sentinel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BorderSizePixel = 0
Title.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- Close
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -45, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    -- Save current size before closing
    savedMenuSize = Main.Size
    Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    task.wait(0.3)
    Main.Visible = false
    MiniFrame.Visible = true
    Tween(MiniFrame, {Size = UDim2.new(0, 120, 0, 40)}, 0.3)
end)

-- Tabs
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 40)
TabBar.Position = UDim2.new(0, 10, 0, 55)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TabBar.BorderSizePixel = 0
TabBar.ClipsDescendants = true
TabBar.Parent = Main

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 10)
TabBarCorner.Parent = TabBar

-- Container for tabs that can scroll
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.Position = UDim2.new(0, 0, 0, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)
TabLayout.Parent = TabContainer

-- Dragging for TabBar (works on buttons too)
local tabDragging = false
local tabDragStart = 0
local tabStartPos = 0

local function startTabDrag(input)
    tabDragging = true
    tabDragStart = input.Position.X
    tabStartPos = TabContainer.Position.X.Offset
end

TabBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startTabDrag(input)
    end
end)

TabContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startTabDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        tabDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if tabDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position.X - tabDragStart
        local newPos = tabStartPos + delta
        -- Limit scrolling
        local maxScroll = math.max(0, TabLayout.AbsoluteContentSize.X - TabBar.AbsoluteSize.X)
        newPos = math.clamp(newPos, -maxScroll, 0)
        TabContainer.Position = UDim2.new(0, newPos, 0, 0)
    end
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -115)
Content.Position = UDim2.new(0, 10, 0, 100)
Content.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Content.BorderSizePixel = 0
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = Content

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -20, 1, -20)
ContentScroll.Position = UDim2.new(0, 10, 0, 10)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ContentScroll.Parent = Content

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.Parent = ContentScroll

-- Tab System
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local tab = {}
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Allow dragging on button
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startTabDrag(input)
        end
    end)
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = ContentScroll
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    tab.Button = btn
    tab.Content = content
    
    local clickStartPos = nil
    
    btn.MouseButton1Down:Connect(function()
        clickStartPos = UserInputService:GetMouseLocation()
    end)
    
    btn.MouseButton1Click:Connect(function()
        -- Only switch tab if not dragging (mouse didn't move much)
        local currentPos = UserInputService:GetMouseLocation()
        if clickStartPos and (currentPos - clickStartPos).Magnitude < 5 then
            for _, t in pairs(Tabs) do
                t.Content.Visible = false
                Tween(t.Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 45), TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.2)
            end
            content.Visible = true
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(100, 50, 200), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            CurrentTab = tab
        end
    end)
    
    table.insert(Tabs, tab)
    return tab
end

-- Function to switch tabs
local function SwitchToTab(index)
    if Tabs[index] then
        for _, t in pairs(Tabs) do
            t.Content.Visible = false
            Tween(t.Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 45), TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.2)
        end
        Tabs[index].Content.Visible = true
        Tween(Tabs[index].Button, {BackgroundColor3 = Color3.fromRGB(100, 50, 200), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        CurrentTab = Tabs[index]
        
        -- Auto scroll to selected tab if not visible
        task.spawn(function()
            task.wait(0.05) -- Wait for layout to update
            local button = Tabs[index].Button
            local buttonPos = button.AbsolutePosition.X
            local buttonSize = button.AbsoluteSize.X
            local tabBarPos = TabBar.AbsolutePosition.X
            local tabBarSize = TabBar.AbsoluteSize.X
            local containerOffset = TabContainer.Position.X.Offset
            
            -- Check if button is outside visible area
            local relativePos = buttonPos - tabBarPos
            
            if relativePos < 0 then
                -- Button is to the left, scroll left
                local newOffset = containerOffset - relativePos + 10
                local maxScroll = math.max(0, TabLayout.AbsoluteContentSize.X - TabBar.AbsoluteSize.X)
                newOffset = math.clamp(newOffset, -maxScroll, 0)
                Tween(TabContainer, {Position = UDim2.new(0, newOffset, 0, 0)}, 0.3)
            elseif relativePos + buttonSize > tabBarSize then
                -- Button is to the right, scroll right
                local overflow = (relativePos + buttonSize) - tabBarSize
                local newOffset = containerOffset - overflow - 10
                local maxScroll = math.max(0, TabLayout.AbsoluteContentSize.X - TabBar.AbsoluteSize.X)
                newOffset = math.clamp(newOffset, -maxScroll, 0)
                Tween(TabContainer, {Position = UDim2.new(0, newOffset, 0, 0)}, 0.3)
            end
        end)
    end
end

-- Mouse wheel scrolling for tabs (only in TabBar area)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        local mousePos = UserInputService:GetMouseLocation()
        local tabBarPos = TabBar.AbsolutePosition
        local tabBarSize = TabBar.AbsoluteSize
        
        -- Check if mouse is over TabBar area
        if mousePos.X >= tabBarPos.X and mousePos.X <= tabBarPos.X + tabBarSize.X and
           mousePos.Y >= tabBarPos.Y and mousePos.Y <= tabBarPos.Y + tabBarSize.Y then
            
            -- Find current tab index
            local currentIndex = 1
            for i, tab in ipairs(Tabs) do
                if tab == CurrentTab then
                    currentIndex = i
                    break
                end
            end
            
            -- Switch tab based on scroll direction
            if input.Position.Z > 0 then
                -- Scroll up - previous tab
                local newIndex = currentIndex - 1
                if newIndex < 1 then newIndex = #Tabs end
                SwitchToTab(newIndex)
            else
                -- Scroll down - next tab
                local newIndex = currentIndex + 1
                if newIndex > #Tabs then newIndex = 1 end
                SwitchToTab(newIndex)
            end
        end
        -- If mouse is over Content area, let the ScrollingFrame handle it naturally
    end
end)

local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 35, 0, 18)
    btn.Position = UDim2.new(1, -45, 0.5, -9)
    btn.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn
    
    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 14, 0, 14)
    ind.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    ind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ind.BorderSizePixel = 0
    ind.Parent = btn
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = ind
    
    local enabled = default
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Tween(btn, {BackgroundColor3 = enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)}, 0.2)
        Tween(ind, {Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
        callback(enabled)
    end)
    
    return frame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -55, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(1, -20, 0, 6)
    sliderBG.Position = UDim2.new(0, 10, 1, -15)
    sliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBG.BorderSizePixel = 0
    sliderBG.Parent = frame
    
    local sliderBGCorner = Instance.new("UICorner")
    sliderBGCorner.CornerRadius = UDim.new(1, 0)
    sliderBGCorner.Parent = sliderBG
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBG
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local dragging = false
    local value = default
    
    local function updateSlider(mouseX)
        if not sliderBG or not sliderBG.Parent then return end
        
        local relativeX = mouseX - sliderBG.AbsolutePosition.X
        local pos = math.clamp(relativeX / sliderBG.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value)
        
        pcall(function()
            callback(value)
        end)
    end
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 1, 0)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 5
    sliderBtn.Parent = sliderBG
    
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
        local mousePos = UserInputService:GetMouseLocation()
        updateSlider(mousePos.X)
    end)
    
    local connections = {}
    
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))
    
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            updateSlider(mousePos.X)
        end
    end))
    
    -- Cleanup connections when frame is destroyed
    frame.AncestryChanged:Connect(function()
        if not frame.Parent then
            for _, conn in ipairs(connections) do
                conn:Disconnect()
            end
        end
    end)
    
    return frame
end

local function CreateDropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0, 100, 0, 25)
    dropBtn.Position = UDim2.new(1, -110, 0.5, -12.5)
    dropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    dropBtn.Text = default
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 12
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.BorderSizePixel = 0
    dropBtn.Parent = frame
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropBtn
    
    local currentOption = default
    local currentIndex = 1
    for i, opt in ipairs(options) do
        if opt == default then
            currentIndex = i
            break
        end
    end
    
    dropBtn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then
            currentIndex = 1
        end
        currentOption = options[currentIndex]
        dropBtn.Text = currentOption
        callback(currentOption)
    end)
    
    return frame
end

local function CreateToggleWithColor(parent, text, default, defaultColor, callback, colorCallback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -110, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    -- Color button
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 30, 0, 25)
    colorBtn.Position = UDim2.new(1, -80, 0.5, -12.5)
    colorBtn.BackgroundColor3 = defaultColor
    colorBtn.Text = ""
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = frame
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 6)
    colorCorner.Parent = colorBtn
    
    local colorStroke = Instance.new("UIStroke")
    colorStroke.Color = Color3.fromRGB(100, 100, 100)
    colorStroke.Thickness = 1
    colorStroke.Parent = colorBtn
    
    -- Toggle button
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 35, 0, 18)
    btn.Position = UDim2.new(1, -45, 0.5, -9)
    btn.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn
    
    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 14, 0, 14)
    ind.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    ind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ind.BorderSizePixel = 0
    ind.Parent = btn
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = ind
    
    local enabled = default
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Tween(btn, {BackgroundColor3 = enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)}, 0.2)
        Tween(ind, {Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
        callback(enabled)
    end)
    
    -- Color picker popup
    local pickerOpen = false
    local currentHue = 0
    local currentSat = 1
    local currentVal = 1
    
    colorBtn.MouseButton1Click:Connect(function()
        if pickerOpen then return end
        pickerOpen = true
        
        local picker = Instance.new("Frame")
        picker.Size = UDim2.new(0, 250, 0, 280)
        picker.Position = UDim2.new(0.5, -125, 0.5, -140)
        picker.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        picker.BorderSizePixel = 0
        picker.ZIndex = 200
        picker.Parent = ScreenGui
        
        local pickerCorner = Instance.new("UICorner")
        pickerCorner.CornerRadius = UDim.new(0, 10)
        pickerCorner.Parent = picker
        
        local pickerStroke = Instance.new("UIStroke")
        pickerStroke.Color = Color3.fromRGB(100, 50, 200)
        pickerStroke.Thickness = 2
        pickerStroke.Parent = picker
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.BackgroundTransparency = 1
        title.Text = "Color Picker"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 14
        title.Font = Enum.Font.GothamBold
        title.ZIndex = 201
        title.Parent = picker
        
        -- Main SV palette
        local palette = Instance.new("ImageButton")
        palette.Size = UDim2.new(0, 220, 0, 150)
        palette.Position = UDim2.new(0, 15, 0, 40)
        palette.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
        palette.BorderSizePixel = 0
        palette.ZIndex = 201
        palette.Parent = picker
        
        local paletteCorner = Instance.new("UICorner")
        paletteCorner.CornerRadius = UDim.new(0, 6)
        paletteCorner.Parent = palette
        
        -- White to transparent gradient
        local whiteGrad = Instance.new("Frame")
        whiteGrad.Size = UDim2.new(1, 0, 1, 0)
        whiteGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        whiteGrad.BorderSizePixel = 0
        whiteGrad.ZIndex = 202
        whiteGrad.Parent = palette
        
        local whiteGradCorner = Instance.new("UICorner")
        whiteGradCorner.CornerRadius = UDim.new(0, 6)
        whiteGradCorner.Parent = whiteGrad
        
        local whiteGradient = Instance.new("UIGradient")
        whiteGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        whiteGradient.Parent = whiteGrad
        
        -- Black gradient
        local blackGrad = Instance.new("Frame")
        blackGrad.Size = UDim2.new(1, 0, 1, 0)
        blackGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        blackGrad.BorderSizePixel = 0
        blackGrad.ZIndex = 203
        blackGrad.Parent = palette
        
        local blackGradCorner = Instance.new("UICorner")
        blackGradCorner.CornerRadius = UDim.new(0, 6)
        blackGradCorner.Parent = blackGrad
        
        local blackGradient = Instance.new("UIGradient")
        blackGradient.Rotation = 90
        blackGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        })
        blackGradient.Parent = blackGrad
        
        -- Palette cursor
        local paletteCursor = Instance.new("Frame")
        paletteCursor.Size = UDim2.new(0, 12, 0, 12)
        paletteCursor.Position = UDim2.new(currentSat, -6, 1 - currentVal, -6)
        paletteCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        paletteCursor.BorderSizePixel = 0
        paletteCursor.ZIndex = 204
        paletteCursor.Parent = palette
        
        local paletteCursorCorner = Instance.new("UICorner")
        paletteCursorCorner.CornerRadius = UDim.new(1, 0)
        paletteCursorCorner.Parent = paletteCursor
        
        local paletteCursorStroke = Instance.new("UIStroke")
        paletteCursorStroke.Color = Color3.fromRGB(0, 0, 0)
        paletteCursorStroke.Thickness = 2
        paletteCursorStroke.Parent = paletteCursor
        
        -- Hue slider
        local hueSlider = Instance.new("ImageButton")
        hueSlider.Size = UDim2.new(0, 220, 0, 15)
        hueSlider.Position = UDim2.new(0, 15, 0, 200)
        hueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueSlider.BorderSizePixel = 0
        hueSlider.ZIndex = 201
        hueSlider.Parent = picker
        
        local hueCorner = Instance.new("UICorner")
        hueCorner.CornerRadius = UDim.new(0, 8)
        hueCorner.Parent = hueSlider
        
        local hueGradient = Instance.new("UIGradient")
        hueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        })
        hueGradient.Parent = hueSlider
        
        -- Hue cursor
        local hueCursor = Instance.new("Frame")
        hueCursor.Size = UDim2.new(0, 4, 1, 4)
        hueCursor.Position = UDim2.new(currentHue, -2, 0, -2)
        hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueCursor.BorderSizePixel = 0
        hueCursor.ZIndex = 202
        hueCursor.Parent = hueSlider
        
        local hueCursorStroke = Instance.new("UIStroke")
        hueCursorStroke.Color = Color3.fromRGB(0, 0, 0)
        hueCursorStroke.Thickness = 2
        hueCursorStroke.Parent = hueCursor
        
        -- Apply button
        local applyBtn = Instance.new("TextButton")
        applyBtn.Size = UDim2.new(0, 100, 0, 35)
        applyBtn.Position = UDim2.new(0.5, -50, 0, 230)
        applyBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        applyBtn.Text = "Apply"
        applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        applyBtn.TextSize = 14
        applyBtn.Font = Enum.Font.GothamBold
        applyBtn.BorderSizePixel = 0
        applyBtn.ZIndex = 201
        applyBtn.Parent = picker
        
        local applyCorner = Instance.new("UICorner")
        applyCorner.CornerRadius = UDim.new(0, 8)
        applyCorner.Parent = applyBtn
        
        -- Palette interaction
        local paletteDragging = false
        palette.MouseButton1Down:Connect(function()
            paletteDragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                paletteDragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if paletteDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relX = (input.Position.X - palette.AbsolutePosition.X) / palette.AbsoluteSize.X
                local relY = (input.Position.Y - palette.AbsolutePosition.Y) / palette.AbsoluteSize.Y
                currentSat = math.clamp(relX, 0, 1)
                currentVal = math.clamp(1 - relY, 0, 1)
                paletteCursor.Position = UDim2.new(currentSat, -6, 1 - currentVal, -6)
            end
        end)
        
        -- Hue slider interaction
        local hueDragging = false
        hueSlider.MouseButton1Down:Connect(function()
            hueDragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hueDragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relX = (input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X
                currentHue = math.clamp(relX, 0, 1)
                palette.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                hueCursor.Position = UDim2.new(currentHue, -2, 0, -2)
            end
        end)
        
        applyBtn.MouseButton1Click:Connect(function()
            local finalColor = Color3.fromHSV(currentHue, currentSat, currentVal)
            colorBtn.BackgroundColor3 = finalColor
            colorCallback(finalColor)
            picker:Destroy()
            pickerOpen = false
        end)
    end)
    
    return frame
end

-- Create Tabs
local ESPTab = CreateTab("ESP")
local AimbotTab = CreateTab("Aimbot")
local VisualsTab = CreateTab("Visuals")
local MiscTab = CreateTab("Misc")
local ConfigTab = CreateTab("Config")

-- ESP Tab
CreateToggleWithColor(ESPTab.Content, "Box ESP", false, Color3.fromRGB(255, 0, 0), function(enabled)
    Settings.ESP = enabled
end, function(color)
    Settings.BoxColor = color
end)

CreateToggle(ESPTab.Content, "Health Bar", false, function(enabled)
    Settings.HealthBar = enabled
end)

CreateToggleWithColor(ESPTab.Content, "Name", false, Color3.fromRGB(255, 255, 255), function(enabled)
    Settings.Name = enabled
end, function(color)
    Settings.NameColor = color
end)

CreateToggleWithColor(ESPTab.Content, "Distance", false, Color3.fromRGB(255, 255, 255), function(enabled)
    Settings.Distance = enabled
end, function(color)
    Settings.DistanceColor = color
end)

CreateToggle(ESPTab.Content, "Team Check", false, function(enabled)
    Settings.TeamCheck = enabled
end)

CreateToggle(ESPTab.Content, "Filled Box", false, function(enabled)
    Settings.FilledBox = enabled
    for _, box in pairs(ESPBoxes) do
        if box then
            box.Filled = enabled
        end
    end
end)

CreateToggle(ESPTab.Content, "Box Corner", false, function(enabled)
    Settings.BoxCorner = enabled
end)

CreateSlider(ESPTab.Content, "Max Distance", 100, 5000, 2000, function(value)
    Settings.ESPMaxDistance = value
end)

-- Aimbot Tab
CreateToggle(AimbotTab.Content, "Aimbot", false, function(enabled)
    Settings.Aimbot = enabled
end)

CreateSlider(AimbotTab.Content, "Smoothness", 1, 10, 1, function(value)
    Settings.AimbotSmooth = value
end)

CreateToggle(AimbotTab.Content, "AimLock", false, function(enabled)
    Settings.AimLock = enabled
end)

CreateDropdown(AimbotTab.Content, "Hitbox", {"Auto", "Head", "Torso"}, "Head", function(value)
    Settings.AimbotHitbox = value
end)

CreateToggleWithColor(AimbotTab.Content, "Show FOV", false, Color3.fromRGB(255, 255, 255), function(enabled)
    Settings.ShowFOV = enabled
end, function(color)
    Settings.FOVColor = color
end)

CreateSlider(AimbotTab.Content, "FOV Size", 50, 500, 100, function(value)
    Settings.AimbotFOV = value
end)

CreateSlider(AimbotTab.Content, "Max Distance", 100, 1000, 500, function(value)
    Settings.AimbotMaxDistance = value
end)

CreateToggle(AimbotTab.Content, "Prediction", false, function(enabled)
    Settings.Prediction = enabled
end)

CreateSlider(AimbotTab.Content, "Prediction Strength", 1, 20, 10, function(value)
    Settings.PredictionStrength = value
end)

CreateToggle(AimbotTab.Content, "No Recoil", false, function(enabled)
    Settings.NoRecoil = enabled
end)

CreateSlider(AimbotTab.Content, "Recoil Strength", 1, 100, 50, function(value)
    Settings.RecoilStrength = value
end)

-- Visuals Tab
CreateToggle(VisualsTab.Content, "Fullbright", false, function(enabled)
    Settings.Fullbright = enabled
    local lighting = game:GetService("Lighting")
    lighting.Brightness = enabled and 2 or 1
    lighting.ClockTime = 14
    lighting.FogEnd = 100000
end)

-- Misc Tab
CreateToggle(MiscTab.Content, "Infinite Jump", false, function(enabled)
    Settings.InfiniteJump = enabled
end)

CreateToggle(MiscTab.Content, "Debug Panel", false, function(enabled)
    Settings.DebugPanel = enabled
end)

-- Config System
local HttpService = game:GetService("HttpService")

local function SaveConfig(configName)
    local configData = {
        ESP = Settings.ESP,
        HealthBar = Settings.HealthBar,
        Name = Settings.Name,
        Distance = Settings.Distance,
        TeamCheck = Settings.TeamCheck,
        FilledBox = Settings.FilledBox,
        BoxCorner = Settings.BoxCorner,
        BoxColor = {Settings.BoxColor.R, Settings.BoxColor.G, Settings.BoxColor.B},
        NameColor = {Settings.NameColor.R, Settings.NameColor.G, Settings.NameColor.B},
        DistanceColor = {Settings.DistanceColor.R, Settings.DistanceColor.G, Settings.DistanceColor.B},
        ESPMaxDistance = Settings.ESPMaxDistance,
        Aimbot = Settings.Aimbot,
        AimbotFOV = Settings.AimbotFOV,
        ShowFOV = Settings.ShowFOV,
        FOVColor = {Settings.FOVColor.R, Settings.FOVColor.G, Settings.FOVColor.B},
        AimbotSmooth = Settings.AimbotSmooth,
        AimbotHitbox = Settings.AimbotHitbox,
        AimLock = Settings.AimLock,
        AimbotMaxDistance = Settings.AimbotMaxDistance,
        NoRecoil = Settings.NoRecoil,
        RecoilStrength = Settings.RecoilStrength,
        Prediction = Settings.Prediction,
        PredictionStrength = Settings.PredictionStrength,
        Fullbright = Settings.Fullbright,
        InfiniteJump = Settings.InfiniteJump,
        DebugPanel = Settings.DebugPanel
    }
    
    local success, err = pcall(function()
        local jsonData = HttpService:JSONEncode(configData)
        local filePath = configFolder .. configName .. ".json"
        
        -- Try exploit functions first
        if writefile then
            if makefolder and isfolder and not isfolder(configFolder) then
                makefolder(configFolder)
            end
            writefile(filePath, jsonData)
            print("Config saved: " .. configName)
        -- Try io functions
        elseif io and io.open then
            if os and os.execute then
                os.execute('mkdir "' .. configFolder:gsub("/", "\\") .. '" 2>nul')
            end
            local file = io.open(filePath, "w")
            if file then
                file:write(jsonData)
                file:close()
                print("Config saved: " .. configName)
            else
                warn("Failed to open file for writing")
            end
        else
            warn("No file writing functions available")
        end
    end)
    
    if not success then
        warn("Failed to save config: " .. err)
    end
end

local function LoadConfig(configName)
    local filePath = configFolder .. configName .. ".json"
    
    local success, result = pcall(function()
        local content = nil
        
        -- Try exploit functions first
        if readfile and isfile then
            if not isfile(filePath) then
                warn("Config not found: " .. configName)
                return nil
            end
            content = readfile(filePath)
        -- Try io functions
        elseif io and io.open then
            local file = io.open(filePath, "r")
            if not file then
                warn("Config not found: " .. configName)
                return nil
            end
            content = file:read("*all")
            file:close()
        else
            warn("No file reading functions available")
            return nil
        end
        
        if content then
            return HttpService:JSONDecode(content)
        end
        return nil
    end)
    
    if success and result then
        Settings.ESP = result.ESP or false
        Settings.HealthBar = result.HealthBar or false
        Settings.Name = result.Name or false
        Settings.Distance = result.Distance or false
        Settings.TeamCheck = result.TeamCheck or false
        Settings.FilledBox = result.FilledBox or false
        Settings.BoxCorner = result.BoxCorner or false
        
        if result.BoxColor then
            Settings.BoxColor = Color3.new(result.BoxColor[1], result.BoxColor[2], result.BoxColor[3])
        end
        if result.NameColor then
            Settings.NameColor = Color3.new(result.NameColor[1], result.NameColor[2], result.NameColor[3])
        end
        if result.DistanceColor then
            Settings.DistanceColor = Color3.new(result.DistanceColor[1], result.DistanceColor[2], result.DistanceColor[3])
        end
        
        Settings.ESPMaxDistance = result.ESPMaxDistance or 2000
        Settings.Aimbot = result.Aimbot or false
        Settings.AimbotFOV = result.AimbotFOV or 100
        Settings.ShowFOV = result.ShowFOV or false
        
        if result.FOVColor then
            Settings.FOVColor = Color3.new(result.FOVColor[1], result.FOVColor[2], result.FOVColor[3])
        end
        
        Settings.AimbotSmooth = result.AimbotSmooth or 1
        Settings.AimbotHitbox = result.AimbotHitbox or "Head"
        Settings.AimLock = result.AimLock or false
        Settings.AimbotMaxDistance = result.AimbotMaxDistance or 500
        Settings.NoRecoil = result.NoRecoil or false
        Settings.RecoilStrength = result.RecoilStrength or 50
        Settings.Prediction = result.Prediction or false
        Settings.PredictionStrength = result.PredictionStrength or 10
        Settings.Fullbright = result.Fullbright or false
        Settings.InfiniteJump = result.InfiniteJump or false
        Settings.DebugPanel = result.DebugPanel or false
        
        print("Config loaded: " .. configName)
    else
        warn("Failed to load config: " .. tostring(result))
    end
end

local function DeleteConfig(configName)
    local filePath = configFolder .. configName .. ".json"
    local success, err = pcall(function()
        -- Try exploit functions first
        if delfile and isfile then
            if isfile(filePath) then
                delfile(filePath)
                print("Config deleted: " .. configName)
            else
                warn("Config not found: " .. configName)
            end
        -- Try os.remove
        elseif os and os.remove then
            os.remove(filePath)
            print("Config deleted: " .. configName)
        else
            warn("No file deletion functions available")
        end
    end)
    
    if not success then
        warn("Failed to delete config: " .. err)
    end
end

local function CreateButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 1, -10)
    btn.Position = UDim2.new(0, 10, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return frame
end

local function CreateTextBox(parent, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -20, 1, -10)
    textbox.Position = UDim2.new(0, 10, 0, 5)
    textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    textbox.Text = ""
    textbox.PlaceholderText = placeholder
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textbox.TextSize = 13
    textbox.Font = Enum.Font.Gotham
    textbox.BorderSizePixel = 0
    textbox.ClearTextOnFocus = false
    textbox.Parent = frame
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 6)
    textboxCorner.Parent = textbox
    
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and textbox.Text ~= "" then
            callback(textbox.Text)
        end
    end)
    
    return frame, textbox
end

-- Config Tab
local configNameBox
CreateTextBox(ConfigTab.Content, "Enter config name...", function(text)
    -- Callback handled by buttons
end)

local _, textboxRef = CreateTextBox(ConfigTab.Content, "Enter config name...", function() end)
configNameBox = textboxRef

CreateButton(ConfigTab.Content, "Save Config", function()
    if configNameBox.Text ~= "" then
        SaveConfig(configNameBox.Text)
    else
        warn("Please enter a config name")
    end
end)

CreateButton(ConfigTab.Content, "Load Config", function()
    if configNameBox.Text ~= "" then
        LoadConfig(configNameBox.Text)
    else
        warn("Please enter a config name")
    end
end)

CreateButton(ConfigTab.Content, "Delete Config", function()
    if configNameBox.Text ~= "" then
        DeleteConfig(configNameBox.Text)
    else
        warn("Please enter a config name")
    end
end)

-- Select first tab
if #Tabs > 0 then
    task.wait(0.1)
    Tabs[1].Content.Visible = true
    Tween(Tabs[1].Button, {BackgroundColor3 = Color3.fromRGB(100, 50, 200), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    CurrentTab = Tabs[1]
end

-- Resizing variables
local resizing = false
local resizeDirection = nil
local resizeStart = nil
local startSize = nil
local startPosition = nil
local minSize = Vector2.new(400, 350)
local maxSize = Vector2.new(99999, 99999) -- Unlimited size (full screen)

-- Resizing indicators (visual edges)
local resizeEdges = {}

-- Right edge
local rightEdge = Instance.new("Frame")
rightEdge.Size = UDim2.new(0, 4, 1, 0)
rightEdge.Position = UDim2.new(1, -2, 0, 0)
rightEdge.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
rightEdge.BackgroundTransparency = 1
rightEdge.BorderSizePixel = 0
rightEdge.ZIndex = 10
rightEdge.Parent = Main
table.insert(resizeEdges, {frame = rightEdge, direction = "right"})

-- Left edge
local leftEdge = Instance.new("Frame")
leftEdge.Size = UDim2.new(0, 4, 1, 0)
leftEdge.Position = UDim2.new(0, -2, 0, 0)
leftEdge.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
leftEdge.BackgroundTransparency = 1
leftEdge.BorderSizePixel = 0
leftEdge.ZIndex = 10
leftEdge.Parent = Main
table.insert(resizeEdges, {frame = leftEdge, direction = "left"})

-- Top edge
local topEdge = Instance.new("Frame")
topEdge.Size = UDim2.new(1, 0, 0, 4)
topEdge.Position = UDim2.new(0, 0, 0, -2)
topEdge.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
topEdge.BackgroundTransparency = 1
topEdge.BorderSizePixel = 0
topEdge.ZIndex = 10
topEdge.Parent = Main
table.insert(resizeEdges, {frame = topEdge, direction = "top"})

-- Bottom edge
local bottomEdge = Instance.new("Frame")
bottomEdge.Size = UDim2.new(1, 0, 0, 4)
bottomEdge.Position = UDim2.new(0, 0, 1, -2)
bottomEdge.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
bottomEdge.BackgroundTransparency = 1
bottomEdge.BorderSizePixel = 0
bottomEdge.ZIndex = 10
bottomEdge.Parent = Main
table.insert(resizeEdges, {frame = bottomEdge, direction = "bottom"})

-- Corner indicators
local cornerSize = 12

-- Top-left corner
local tlCorner = Instance.new("Frame")
tlCorner.Size = UDim2.new(0, cornerSize, 0, cornerSize)
tlCorner.Position = UDim2.new(0, 0, 0, 0)
tlCorner.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
tlCorner.BackgroundTransparency = 1
tlCorner.BorderSizePixel = 0
tlCorner.ZIndex = 11
tlCorner.Parent = Main
table.insert(resizeEdges, {frame = tlCorner, direction = "topleft"})

-- Top-right corner
local trCorner = Instance.new("Frame")
trCorner.Size = UDim2.new(0, cornerSize, 0, cornerSize)
trCorner.Position = UDim2.new(1, -cornerSize, 0, 0)
trCorner.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
trCorner.BackgroundTransparency = 1
trCorner.BorderSizePixel = 0
trCorner.ZIndex = 11
trCorner.Parent = Main
table.insert(resizeEdges, {frame = trCorner, direction = "topright"})

-- Bottom-left corner
local blCorner = Instance.new("Frame")
blCorner.Size = UDim2.new(0, cornerSize, 0, cornerSize)
blCorner.Position = UDim2.new(0, 0, 1, -cornerSize)
blCorner.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
blCorner.BackgroundTransparency = 1
blCorner.BorderSizePixel = 0
blCorner.ZIndex = 11
blCorner.Parent = Main
table.insert(resizeEdges, {frame = blCorner, direction = "bottomleft"})

-- Bottom-right corner
local brCorner = Instance.new("Frame")
brCorner.Size = UDim2.new(0, cornerSize, 0, cornerSize)
brCorner.Position = UDim2.new(1, -cornerSize, 1, -cornerSize)
brCorner.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
brCorner.BackgroundTransparency = 1
brCorner.BorderSizePixel = 0
brCorner.ZIndex = 11
brCorner.Parent = Main
table.insert(resizeEdges, {frame = brCorner, direction = "bottomright"})

-- Hover effects for edges
for _, edge in ipairs(resizeEdges) do
    edge.frame.MouseEnter:Connect(function()
        if not resizing then
            Tween(edge.frame, {BackgroundTransparency = 0.3}, 0.2)
        end
    end)
    
    edge.frame.MouseLeave:Connect(function()
        if not resizing then
            Tween(edge.frame, {BackgroundTransparency = 1}, 0.2)
        end
    end)
    
    edge.frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not dragging then
            resizing = true
            resizeDirection = edge.direction
            resizeStart = UserInputService:GetMouseLocation()
            startSize = Main.AbsoluteSize
            startPosition = Main.AbsolutePosition
            edge.frame.BackgroundTransparency = 0.3
        end
    end)
end

-- Dragging
local dragging, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not resizing then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        if resizing then
            resizing = false
            resizeDirection = nil
            -- Hide all edge indicators
            for _, edge in ipairs(resizeEdges) do
                Tween(edge.frame, {BackgroundTransparency = 1}, 0.2)
            end
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging and not resizing then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        -- Resizing logic
        if resizing and not dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local delta = mousePos - resizeStart
            
            local newWidth = startSize.X
            local newHeight = startSize.Y
            local newX = Main.Position.X.Offset
            local newY = Main.Position.Y.Offset
            
            -- Calculate new size based on direction
            if resizeDirection == "right" or resizeDirection == "topright" or resizeDirection == "bottomright" then
                newWidth = math.clamp(startSize.X + delta.X, minSize.X, maxSize.X)
            end
            
            if resizeDirection == "left" or resizeDirection == "topleft" or resizeDirection == "bottomleft" then
                local potentialWidth = startSize.X - delta.X
                if potentialWidth >= minSize.X and potentialWidth <= maxSize.X then
                    newWidth = potentialWidth
                    newX = startPosition.X + delta.X - (ScreenGui.AbsoluteSize.X / 2)
                end
            end
            
            if resizeDirection == "bottom" or resizeDirection == "bottomleft" or resizeDirection == "bottomright" then
                newHeight = math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
            end
            
            if resizeDirection == "top" or resizeDirection == "topleft" or resizeDirection == "topright" then
                local potentialHeight = startSize.Y - delta.Y
                if potentialHeight >= minSize.Y and potentialHeight <= maxSize.Y then
                    newHeight = potentialHeight
                    newY = startPosition.Y + delta.Y - (ScreenGui.AbsoluteSize.Y / 2)
                end
            end
            
            Main.Size = UDim2.new(0, newWidth, 0, newHeight)
            Main.Position = UDim2.new(0.5, newX, 0.5, newY)
            
            -- Update saved size while resizing
            savedMenuSize = Main.Size
        end
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(UpdateESP)
RunService.RenderStepped:Connect(UpdateAimbot)
RunService.RenderStepped:Connect(UpdateDebugPanel)
RunService.Heartbeat:Connect(UpdateInfiniteJump)

print("Sentinel loaded!")
