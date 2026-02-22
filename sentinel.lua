-- ███████╗███████╗███╗   ██╗████████╗██╗███╗   ██╗███████╗██╗     
-- ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██║████╗  ██║██╔════╝██║     
-- ███████╗█████╗  ██╔██╗ ██║   ██║   ██║██╔██╗ ██║█████╗  ██║     
-- ╚════██║██╔══╝  ██║╚██╗██║   ██║   ██║██║╚██╗██║██╔══╝  ██║     
-- ███████║███████╗██║ ╚████║   ██║   ██║██║ ╚████║███████╗███████╗
-- ╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
--
-- Advanced Roblox Enhancement Suite
-- Version: 1.0.0 | Build: #1024
-- Press INSERT to open menu

-- Loading Screen
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "SentinelLoader"
LoaderGui.ResetOnSpawn = false
LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoaderGui.Parent = game:GetService("CoreGui")

local LoaderFrame = Instance.new("Frame")
LoaderFrame.Size = UDim2.new(0, 400, 0, 250)
LoaderFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
LoaderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LoaderFrame.BorderSizePixel = 0
LoaderFrame.Parent = LoaderGui

local LoaderCorner = Instance.new("UICorner")
LoaderCorner.CornerRadius = UDim.new(0, 15)
LoaderCorner.Parent = LoaderFrame

-- Gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
Gradient.Rotation = 90
Gradient.Parent = LoaderFrame

-- Logo
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.Position = UDim2.new(0, 0, 0, 30)
Logo.BackgroundTransparency = 1
Logo.Text = "SENTINEL"
Logo.TextColor3 = Color3.fromRGB(0, 200, 255)
Logo.TextSize = 36
Logo.Font = Enum.Font.GothamBold
Logo.Parent = LoaderFrame

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 95)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Advanced Roblox Enhancement Suite"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = LoaderFrame

-- Version
local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, 0, 0, 18)
Version.Position = UDim2.new(0, 0, 0, 120)
Version.BackgroundTransparency = 1
Version.Text = "Version 1.0.0 | Build #1024"
Version.TextColor3 = Color3.fromRGB(100, 100, 150)
Version.TextSize = 10
Version.Font = Enum.Font.Gotham
Version.Parent = LoaderFrame

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0, 155)
Status.BackgroundTransparency = 1
Status.Text = "Initializing..."
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Parent = LoaderFrame

-- Progress Bar Background
local ProgressBG = Instance.new("Frame")
ProgressBG.Size = UDim2.new(0, 300, 0, 6)
ProgressBG.Position = UDim2.new(0.5, -150, 0, 190)
ProgressBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ProgressBG.BorderSizePixel = 0
ProgressBG.Parent = LoaderFrame

local ProgressBGCorner = Instance.new("UICorner")
ProgressBGCorner.CornerRadius = UDim.new(0, 3)
ProgressBGCorner.Parent = ProgressBG

-- Progress Bar
local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = ProgressBG

local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(0, 3)
ProgressBarCorner.Parent = ProgressBar

-- Progress Gradient
local ProgressGradient = Instance.new("UIGradient")
ProgressGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
}
ProgressGradient.Parent = ProgressBar

-- Loading Animation
local function UpdateProgress(progress, text)
    Status.Text = text
    game:GetService("TweenService"):Create(ProgressBar, TweenInfo.new(0.3), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
    wait(0.3)
end

-- Loading Steps
task.spawn(function()
    wait(0.5)
    UpdateProgress(0.2, "Loading services...")
    wait(0.3)
    UpdateProgress(0.4, "Initializing ESP...")
    wait(0.3)
    UpdateProgress(0.6, "Loading aimbot...")
    wait(0.3)
    UpdateProgress(0.8, "Setting up GUI...")
    wait(0.3)
    UpdateProgress(1, "Ready!")
    wait(0.5)
    
    -- Fade out
    game:GetService("TweenService"):Create(LoaderFrame, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    }):Play()
    
    for _, child in ipairs(LoaderFrame:GetDescendants()) do
        if child:IsA("TextLabel") then
            game:GetService("TweenService"):Create(child, TweenInfo.new(0.5), {
                TextTransparency = 1
            }):Play()
        elseif child:IsA("Frame") and child ~= LoaderFrame then
            game:GetService("TweenService"):Create(child, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
        end
    end
    
    wait(0.6)
    LoaderGui:Destroy()
    
    -- Активируем GUI после завершения загрузки
    wait(0.2)
    local sentinelGui = game:GetService("CoreGui"):FindFirstChild("SentinelGui")
    if sentinelGui then
        sentinelGui.Enabled = true
    end
    _G.SentinelLoaded = true
    
    -- Show TopPanel with animation after load
    task.wait(0.5)
    TopPanel.Visible = true
    Tween(TopPanel, {BackgroundTransparency = 0}, 0.15)
    Tween(TopPanelStroke, {Transparency = 0.7}, 0.15)
    -- Animate buttons with delay
    for i, child in ipairs(TopPanel:GetChildren()) do
        if child:IsA("TextButton") then
            task.spawn(function()
                task.wait(0.03 * i)
                Tween(child, {BackgroundTransparency = 0}, 0.15)
                local stroke = child:FindFirstChildOfClass("UIStroke")
                if stroke then
                    Tween(stroke, {Transparency = 0.5}, 0.15)
                end
            end)
        end
    end
    
    -- Show notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Sentinel",
        Text = "Loaded successfully! Press INSERT to open menu",
        Duration = 5
    })
end)

-- Roblox Sentinel
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Check and create Sentinel folder
local sentinelFolder = "Sentinel"
local configFolder = sentinelFolder .. "/Configs"

-- Create folders using exploit functions
local function EnsureFolders()
    if makefolder and isfolder then
        if not isfolder(sentinelFolder) then
            makefolder(sentinelFolder)
            print("[Sentinel] Created folder: " .. sentinelFolder)
        end
        if not isfolder(configFolder) then
            makefolder(configFolder)
            print("[Sentinel] Created folder: " .. configFolder)
        end
        print("[Sentinel] Config folder: workspace/" .. configFolder)
        return true
    else
        warn("[Sentinel] File system functions not available")
        return false
    end
end

-- Initialize folders
local fileSystemAvailable = EnsureFolders()

-- Settings
local Settings = {
    ESP = true,
    ESPActive = true, -- Actual activation state controlled by keybind
    Fullbright = false,
    FullbrightActive = false,
    HealthBar = false,
    HealthBarActive = false,
    Name = false,
    Distance = false,
    TeamCheck = false,
    TeamCheckActive = false,
    FilledBox = false,
    FilledBoxActive = false,
    BoxCorner = false,
    BoxCornerActive = false,
    BoxColor = Color3.fromRGB(255, 0, 0),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    ESPMaxDistance = 2000,
    Aimbot = false,
    AimbotActive = false, -- Actual activation state controlled by keybind
    AimbotFOV = 100,
    ShowFOV = false,
    FOVColor = Color3.fromRGB(255, 255, 255),
    AimbotSmooth = 1,
    AimbotHitbox = "Head",
    AimLock = false,
    AimLockActive = false,
    AimbotMaxDistance = 500,
    NoRecoil = false,
    NoRecoilActive = false,
    RecoilStrength = 50,
    Prediction = false,
    PredictionActive = false,
    PredictionStrength = 10,
    InfiniteJump = false,
    InfiniteJumpActive = false, -- Actual activation state controlled by keybind
    DebugPanel = false,
    DebugPanelActive = false,
    DebugPanelPos = {X = -360, Y = 10},
    MenuBind = Enum.KeyCode.Insert,
    Skeleton = false,
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    LocalSkeleton = false,
    LocalSkeletonActive = false,
    LocalSkeletonColor = Color3.fromRGB(0, 255, 0),
    LocalHighlight = false,
    LocalHighlightActive = false,
    LocalHighlightColor = Color3.fromRGB(255, 255, 0),
    ShowKeylist = true,
    ShowKeylistActive = true,
    MenuColor = Color3.fromRGB(255, 20, 147),
    
    -- Keybinds
    Keybinds = {
        ESP = {Key = Enum.KeyCode.E, Mode = "Always On", Enabled = true},
        Aimbot = {Key = Enum.UserInputType.MouseButton2, Mode = "Hold", Enabled = true},
        InfiniteJump = {Key = Enum.KeyCode.J, Mode = "Toggle", Enabled = true},
        AimLock = {Key = Enum.KeyCode.L, Mode = "Toggle", Enabled = false},
        Prediction = {Key = Enum.KeyCode.P, Mode = "Toggle", Enabled = false},
        NoRecoil = {Key = Enum.KeyCode.R, Mode = "Toggle", Enabled = false},
        HealthBar = {Key = Enum.KeyCode.H, Mode = "Toggle", Enabled = false},
        TeamCheck = {Key = Enum.KeyCode.T, Mode = "Toggle", Enabled = false},
        FilledBox = {Key = Enum.KeyCode.F, Mode = "Toggle", Enabled = false},
        BoxCorner = {Key = Enum.KeyCode.C, Mode = "Toggle", Enabled = false},
        Fullbright = {Key = Enum.KeyCode.B, Mode = "Toggle", Enabled = false},
        DebugPanel = {Key = Enum.KeyCode.O, Mode = "Toggle", Enabled = false},
        ShowKeylist = {Key = Enum.KeyCode.K, Mode = "Toggle", Enabled = false},
        LocalSkeleton = {Key = Enum.KeyCode.N, Mode = "Toggle", Enabled = false},
        LocalHighlight = {Key = Enum.KeyCode.M, Mode = "Toggle", Enabled = false}
    }
}

-- UI Elements storage for updating
local UIElements = {}

-- Global keybind menu reference
local currentKeybindMenu = nil

-- Store all elements that use accent color (pink)
local AccentColorElements = {
    StatusBarBottom = nil,
    Title = {},
    TabIndicatorStroke = nil,
    ScrollBars = {},
    CheckboxBackgrounds = {},
    CheckboxStrokes = {},
    SliderFills = {},
    SliderHandles = {},
    DropdownStrokes = {},
    ColorButtonStrokes = {},
    ConfigLoadButtons = {},
    ConfigActionButtons = {},
    KeylistGradient = nil,
    KeylistStroke = nil,
    SentinelTitleGradient = nil
}

-- Function to update all accent colors
local function UpdateAccentColor(newColor)
    Settings.MenuColor = newColor
    
    -- Update StatusBarBottom
    if AccentColorElements.StatusBarBottom then
        AccentColorElements.StatusBarBottom.BackgroundColor3 = newColor
    end
    
    -- Update Title elements
    if AccentColorElements.Title then
        for _, title in pairs(AccentColorElements.Title) do
            if title and title.Parent then
                title.TextColor3 = newColor
            end
        end
    end
    
    -- Update TabIndicator stroke
    if AccentColorElements.TabIndicatorStroke then
        AccentColorElements.TabIndicatorStroke.Color = newColor
    end
    
    -- Update ScrollBars
    for _, sb in pairs(AccentColorElements.ScrollBars) do
        if sb and sb.Parent then
            sb.ScrollBarImageColor3 = newColor
        end
    end
    
    -- Update Checkbox backgrounds
    for _, cb in pairs(AccentColorElements.CheckboxBackgrounds) do
        if cb and cb.Parent then
            cb.BackgroundColor3 = newColor
        end
    end
    
    -- Update Checkbox strokes
    for _, stroke in pairs(AccentColorElements.CheckboxStrokes) do
        if stroke and stroke.Parent then
            stroke.Color = newColor
        end
    end
    
    -- Update Slider fills
    for _, fill in pairs(AccentColorElements.SliderFills) do
        if fill and fill.Parent then
            fill.BackgroundColor3 = newColor
        end
    end
    
    -- Update Slider handles
    for _, handle in pairs(AccentColorElements.SliderHandles) do
        if handle and handle.Parent then
            handle.BackgroundColor3 = newColor
        end
    end
    
    -- Update Dropdown strokes
    for _, stroke in pairs(AccentColorElements.DropdownStrokes) do
        if stroke and stroke.Parent then
            stroke.Color = newColor
        end
        if stroke and stroke.Parent then
            stroke.Color = newColor
        end
    end
    
    -- Update Config Load buttons
    for _, btn in pairs(AccentColorElements.ConfigLoadButtons) do
        if btn and btn.Parent then
            btn.BackgroundColor3 = newColor
        end
    end
    
    -- Update Config Action buttons (Refresh, Save, Load)
    for _, btn in pairs(AccentColorElements.ConfigActionButtons) do
        if btn and btn.Parent then
            btn.BackgroundColor3 = newColor
        end
    end
    
    -- Update Keylist gradient
    if AccentColorElements.KeylistGradient then
        AccentColorElements.KeylistGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, newColor),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, newColor),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, newColor)
        })
    end
    
    -- Update Keylist glow
    if AccentColorElements.KeylistGlow then
        AccentColorElements.KeylistGlow.ImageColor3 = newColor
    end
    
    -- Update SENTINEL title gradient
    if AccentColorElements.SentinelTitleGradient then
        AccentColorElements.SentinelTitleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, newColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, newColor)
        })
    end
    
    -- Update Keylist item key labels
    if KeylistItems then
        for _, item in pairs(KeylistItems) do
            if item and item.Parent then
                for _, child in ipairs(item:GetChildren()) do
                    if child:IsA("TextLabel") and child.TextXAlignment == Enum.TextXAlignment.Right then
                        child.TextColor3 = newColor
                    end
                end
            end
        end
    end
end

-- Notification system
local NotificationQueue = {}
local MaxNotifications = 5

local function ShowNotification(text, duration)
    duration = duration or 2
    
    -- Remove oldest notification if queue is full
    if #NotificationQueue >= MaxNotifications then
        local oldest = NotificationQueue[1]
        if oldest and oldest.Parent then
            TweenService:Create(oldest, TweenInfo.new(0.2), {
                Position = UDim2.new(0.5, -150, 1, 100)
            }):Play()
            task.wait(0.2)
            oldest.Parent:Destroy()
        end
        table.remove(NotificationQueue, 1)
    end
    
    -- Create notification
    local notif = Instance.new("ScreenGui")
    notif.Name = "SentinelNotification"
    notif.ResetOnSpawn = false
    notif.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notif.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = UDim2.new(0.5, -150, 1, 100)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    frame.BorderSizePixel = 0
    frame.Parent = notif
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 50, 200)
    stroke.Thickness = 2
    stroke.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextWrapped = true
    textLabel.Parent = frame
    
    -- Add to queue
    table.insert(NotificationQueue, frame)
    
    -- Update positions of all notifications
    for i, notifFrame in ipairs(NotificationQueue) do
        local targetY = -70 - ((i - 1) * 60)
        TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -150, 1, targetY)
        }):Play()
    end
    
    -- Remove after duration
    task.spawn(function()
        task.wait(duration)
        
        -- Find index
        local index = table.find(NotificationQueue, frame)
        if index then
            table.remove(NotificationQueue, index)
        end
        
        -- Animate out
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -150, 1, 100)
        }):Play()
        
        task.wait(0.3)
        if notif and notif.Parent then
            notif:Destroy()
        end
        
        -- Update positions of remaining notifications
        for i, notifFrame in ipairs(NotificationQueue) do
            local targetY = -70 - ((i - 1) * 60)
            TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -150, 1, targetY)
            }):Play()
        end
    end)
end

-- Function to get full workspace path
local function GetWorkspacePath()
    -- Try to detect workspace path by creating a test file and checking common locations
    local testFileName = "sentinel_path_detection.txt"
    
    if writefile and readfile and isfile then
        writefile(testFileName, "test")
        
        -- Common executor workspace paths
        local username = game:GetService("Players").LocalPlayer.Name -- Not actual Windows username but we'll try
        local possiblePaths = {
            os.getenv("LOCALAPPDATA") .. "\\Solara\\workspace",
            os.getenv("LOCALAPPDATA") .. "\\Synapse\\workspace", 
            os.getenv("LOCALAPPDATA") .. "\\SynapseX\\workspace",
            os.getenv("LOCALAPPDATA") .. "\\Fluxus\\workspace",
            os.getenv("LOCALAPPDATA") .. "\\Electron\\workspace",
            os.getenv("APPDATA") .. "\\Krnl\\workspace",
            os.getenv("LOCALAPPDATA") .. "\\Arceus\\workspace",
            os.getenv("LOCALAPPDATA") .. "\\Oxygen\\workspace"
        }
        
        -- Try each path
        for _, basePath in ipairs(possiblePaths) do
            local fullPath = basePath .. "\\" .. sentinelFolder .. "\\Configs"
            local success = pcall(function()
                -- Check if path exists by trying to access it
                local handle = io.popen('dir "' .. fullPath .. '" 2>nul')
                if handle then
                    local result = handle:read("*a")
                    handle:close()
                    if result and result ~= "" then
                        return fullPath
                    end
                end
            end)
            
            if success then
                delfile(testFileName)
                return fullPath
            end
        end
        
        delfile(testFileName)
    end
    
    -- Fallback to relative path
    return "workspace\\" .. sentinelFolder .. "\\Configs"
end

-- Function to set autoload config
local function SetAutoloadConfig(configName)
    if not fileSystemAvailable then
        ShowNotification("File system not available!", 2)
        return false
    end
    
    local success, err = pcall(function()
        local lastConfigPath = sentinelFolder .. "/last_config.txt"
        if writefile then
            writefile(lastConfigPath, configName)
            ShowNotification("Autoload set: " .. configName, 2)
            print("[Sentinel] Autoload config set: " .. configName)
            return true
        else
            warn("[Sentinel] writefile function not available")
            return false
        end
    end)
    
    if not success then
        warn("[Sentinel] Failed to set autoload config: " .. tostring(err))
        ShowNotification("Failed to set autoload!", 2)
        return false
    end
    
    return true
end

-- Function to get current autoload config
local function GetAutoloadConfig()
    if not fileSystemAvailable or not isfile then
        return nil
    end
    
    local lastConfigPath = sentinelFolder .. "/last_config.txt"
    if isfile(lastConfigPath) then
        local success, lastConfig = pcall(function()
            return readfile(lastConfigPath)
        end)
        if success and lastConfig and lastConfig ~= "" then
            return lastConfig
        end
    end
    
    return nil
end

-- Try to auto-load last config (moved to end of file after UI is created)

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
    if not Settings.Prediction or not Settings.PredictionActive then
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
    
    -- No Recoil - works independently, only when shooting
    if Settings.NoRecoil and Settings.NoRecoilActive and isShooting then
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
    
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    -- AimLock - works independently when aiming
    if Settings.AimLock and Settings.AimLockActive and isAiming then
        if not lockedTarget or not lockedTarget.Character then
            lockedTarget, lockedHitbox = GetClosestPlayer()
        end
        
        -- Check if locked target is still alive
        if lockedTarget and lockedTarget.Character then
            local humanoid = lockedTarget.Character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                lockedTarget = nil
                lockedHitbox = nil
            end
        end
        
        if lockedTarget and lockedTarget.Character and lockedHitbox and localHRP then
            local distance = (lockedHitbox.Position - localHRP.Position).Magnitude
            
            -- Check if target is within max distance
            if distance <= Settings.AimbotMaxDistance then
                local predictedPos = GetPredictedPosition(lockedHitbox, distance)
                local targetPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                
                -- Only aim if target is on screen and in front of camera
                if onScreen and targetPos.Z > 0 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local deltaX = targetPos.X - mousePos.X
                    local deltaY = targetPos.Y - mousePos.Y
                    
                    -- Calculate distance to target on screen
                    local distanceToTarget = math.sqrt(deltaX * deltaX + deltaY * deltaY)
                    
                    -- AimLock: smooth approach, then instant lock
                    if distanceToTarget > 15 then
                        -- Far - smooth movement to bring cursor to head
                        local smoothness = 2
                        deltaX = deltaX / smoothness
                        deltaY = deltaY / smoothness
                    end
                    -- Close (<=15px) - instant lock on center, always track target
                    
                    if mousemoverel and (deltaX ~= 0 or deltaY ~= 0) then
                        mousemoverel(deltaX, deltaY)
                    end
                else
                    -- Target not visible, reset lock
                    lockedTarget = nil
                    lockedHitbox = nil
                end
            else
                -- Target too far, reset lock
                lockedTarget = nil
                lockedHitbox = nil
            end
        end
    elseif not isAiming then
        -- Reset locked target when not aiming
        lockedTarget = nil
        lockedHitbox = nil
    end
    
    -- Smooth Aimbot - requires Aimbot to be enabled
    if Settings.Aimbot and Settings.AimbotActive and isAiming then
        -- Only run smooth aimbot if AimLock is not active
        if not (Settings.AimLock and Settings.AimLockActive) then
            local target, hitbox = GetClosestPlayer()
            if target and target.Character and hitbox and localHRP then
                local distance = (hitbox.Position - localHRP.Position).Magnitude
                local predictedPos = GetPredictedPosition(hitbox, distance)
                local targetPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local deltaX = targetPos.X - mousePos.X
                    local deltaY = targetPos.Y - mousePos.Y
                    
                    -- Smoothness 1 = AimLock behavior
                    if Settings.AimbotSmooth == 1 then
                        local distanceToTarget = math.sqrt(deltaX * deltaX + deltaY * deltaY)
                        
                        -- AimLock mode: smooth approach, then instant lock
                        if distanceToTarget > 15 then
                            -- Far - smooth movement
                            local smoothness = 2
                            deltaX = deltaX / smoothness
                            deltaY = deltaY / smoothness
                        end
                        -- Close (<=15px) - instant lock
                    else
                        -- Normal smooth aimbot
                        local smoothFactor = 1 / Settings.AimbotSmooth
                        deltaX = deltaX * smoothFactor
                        deltaY = deltaY * smoothFactor
                    end
                    
                    if mousemoverel then
                        mousemoverel(deltaX, deltaY)
                    end
                end
            end
        end
    end
end

-- Update FOV Circle (independent from aimbot)
local function UpdateFOVCircle()
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
    if not Settings.InfiniteJump or not Settings.InfiniteJumpActive then
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

-- Skeleton ESP Functions
local function CreateSkeletonLine()
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Transparency = 1
    line.Visible = false
    return line
end

local function GetSkeletonConnections()
    return {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
end

local function UpdateSkeleton(player, skeletonLines, color)
    if not player.Character then
        for _, line in pairs(skeletonLines) do
            line.Visible = false
        end
        return
    end
    
    local connections = GetSkeletonConnections()
    local lineIndex = 1
    
    for _, connection in ipairs(connections) do
        local part1 = player.Character:FindFirstChild(connection[1])
        local part2 = player.Character:FindFirstChild(connection[2])
        
        if not skeletonLines[lineIndex] then
            skeletonLines[lineIndex] = CreateSkeletonLine()
        end
        
        local line = skeletonLines[lineIndex]
        
        if part1 and part2 then
            local pos1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
            
            if onScreen1 and onScreen2 then
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Color = color
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
        
        lineIndex = lineIndex + 1
    end
end
-- Local ESP Functions
local function UpdateLocalHighlight()
    if not (Settings.LocalHighlight and Settings.LocalHighlightActive) then
        if LocalHighlight then
            pcall(function()
                LocalHighlight:Destroy()
            end)
            LocalHighlight = nil
        end
        return
    end
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalHighlight then
            pcall(function()
                LocalHighlight.Enabled = false
            end)
        end
        return
    end
    
    -- Create or update highlight
    if not LocalHighlight or not LocalHighlight.Parent then
        pcall(function()
            if LocalHighlight then
                LocalHighlight:Destroy()
            end
            LocalHighlight = Instance.new("Highlight")
            LocalHighlight.Name = "SentinelLocalHighlight"
            LocalHighlight.FillTransparency = 0.5
            LocalHighlight.OutlineTransparency = 0
            LocalHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            LocalHighlight.Adornee = LocalPlayer.Character
            LocalHighlight.Parent = game:GetService("CoreGui")
        end)
    end
    
    -- Update colors and adornee
    if LocalHighlight then
        pcall(function()
            LocalHighlight.FillColor = Settings.LocalHighlightColor
            LocalHighlight.OutlineColor = Settings.LocalHighlightColor
            LocalHighlight.Enabled = true
            
            -- Update adornee if character changed
            if LocalHighlight.Adornee ~= LocalPlayer.Character then
                LocalHighlight.Adornee = LocalPlayer.Character
            end
        end)
    end
end

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
local ESPSkeletons = {}
local LocalSkeletonLines = {}
local LocalHighlight = nil
local ESPDistances = {}
local ESPHealthBars = {}

-- Model Dumper - automatically detect custom character models
-- Clear cache when character is removed
Players.PlayerRemoving:Connect(function(player)
    -- Clean up ESP objects when player leaves
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
    if ESPSkeletons[player] then
        for _, line in pairs(ESPSkeletons[player]) do
            line:Remove()
        end
        ESPSkeletons[player] = nil
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

-- Track local player alive state
local isLocalPlayerAlive = true

-- Handle local player respawn for Local Highlight
LocalPlayer.CharacterAdded:Connect(function(character)
    -- Reset Local Highlight on respawn
    if LocalHighlight then
        LocalHighlight.Adornee = character
    end
    
    -- Set alive state to true on respawn
    isLocalPlayerAlive = true
    
    -- Setup death detection for local player
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.Died:Connect(function()
            isLocalPlayerAlive = false
        end)
    end
end)

-- Setup death detection for existing character
if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        isLocalPlayerAlive = humanoid.Health > 0
        humanoid.Died:Connect(function()
            isLocalPlayerAlive = false
        end)
    end
end

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
    if ESPSkeletons[player] then
        for _, line in pairs(ESPSkeletons[player]) do
            if line then
                line.Visible = false
            end
        end
    end
end

-- Setup death detection for all players
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                -- Just hide ESP, don't delete it
                HidePlayerESP(player)
            end)
        end
    end
    
    player.CharacterAdded:Connect(function(character)
        -- Setup death detection for new character
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                -- Just hide ESP, don't delete it
                HidePlayerESP(player)
            end)
        end
    end)
    
    player.CharacterRemoving:Connect(function(character)
        -- Just hide ESP when character is removed
        HidePlayerESP(player)
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Setup death detection for new character
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                -- Just hide ESP, don't delete it
                HidePlayerESP(player)
            end)
        end
    end)
    
    player.CharacterRemoving:Connect(function(character)
        -- Just hide ESP when character is removed
        HidePlayerESP(player)
    end)
end)

local function UpdateESP()
    -- Hide all ESP boxes first if ESP is disabled or not active
    if not Settings.ESP or not Settings.ESPActive then
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
        for _, skeleton in pairs(ESPSkeletons) do
            if skeleton then
                for _, line in pairs(skeleton) do
                    if line then line.Visible = false end
                end
            end
        end
        return
    end
    
    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    -- Cache camera for performance
    local cam = workspace.CurrentCamera
    if not cam then return end
    
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
                if ESPSkeletons[player] then
                    for _, line in pairs(ESPSkeletons[player]) do
                        if line then
                            line.Visible = false
                        end
                    end
                end
            end
        elseif player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            
            -- Simple validation - just check if parts exist and player is alive
            local isValid = hrp and humanoid and humanoid.Health > 0
            
            -- Early exit if not valid
            if not isValid then
                if ESPBoxes[player] then
                    ESPBoxes[player].Visible = false
                    ESPNames[player].Visible = false
                    ESPDistances[player].Visible = false
                    if ESPHealthBars[player] then
                        ESPHealthBars[player].bg.Visible = false
                        ESPHealthBars[player].outline.Visible = false
                        ESPHealthBars[player].bar.Visible = false
                    end
                    if ESPSkeletons[player] then
                        for _, line in pairs(ESPSkeletons[player]) do
                            if line then line.Visible = false end
                        end
                    end
                end
            else
                local passTeamCheck = not Settings.TeamCheck or player.Team ~= LocalPlayer.Team
                
                -- Check distance limit
                local withinDistance = true
                if localHRP then
                    local distanceToPlayer = (hrp.Position - localHRP.Position).Magnitude
                    withinDistance = distanceToPlayer <= Settings.ESPMaxDistance
                end
                
                if not passTeamCheck or not withinDistance then
                    if ESPBoxes[player] then
                        ESPBoxes[player].Visible = false
                        ESPNames[player].Visible = false
                        ESPDistances[player].Visible = false
                        if ESPHealthBars[player] then
                            ESPHealthBars[player].bg.Visible = false
                            ESPHealthBars[player].outline.Visible = false
                            ESPHealthBars[player].bar.Visible = false
                        end
                        if ESPSkeletons[player] then
                            for _, line in pairs(ESPSkeletons[player]) do
                                if line then line.Visible = false end
                            end
                        end
                    end
                else
                    -- Create ESP elements only once
                    if not ESPBoxes[player] then
                    ESPBoxes[player] = Drawing.new("Square")
                    ESPBoxes[player].Thickness = 2
                    ESPBoxes[player].Visible = false
                    
                    -- Create 8 corner lines (2 per corner)
                    ESPCorners[player] = {}
                    for i = 1, 8 do
                        ESPCorners[player][i] = Drawing.new("Line")
                        ESPCorners[player][i].Thickness = 2
                        ESPCorners[player][i].Color = Settings.BoxColor
                        ESPCorners[player][i].Visible = false
                    end
                    
                    ESPNames[player] = Drawing.new("Text")
                    ESPNames[player].Size = 13
                    ESPNames[player].Center = true
                    ESPNames[player].Outline = true
                    ESPNames[player].Text = player.Name
                    ESPNames[player].Visible = false
                    
                    ESPDistances[player] = Drawing.new("Text")
                    ESPDistances[player].Size = 13
                    ESPDistances[player].Center = true
                    ESPDistances[player].Outline = true
                    ESPDistances[player].Visible = false
                    
                    ESPHealthBars[player] = {
                        bg = Drawing.new("Square"),
                        outline = Drawing.new("Square"),
                        bar = Drawing.new("Square")
                    }
                    ESPHealthBars[player].bg.Color = Color3.fromRGB(50, 50, 50)
                    ESPHealthBars[player].bg.Thickness = 1
                    ESPHealthBars[player].bg.Filled = true
                    ESPHealthBars[player].bg.Visible = false
                    ESPHealthBars[player].outline.Color = Color3.fromRGB(0, 0, 0)
                    ESPHealthBars[player].outline.Thickness = 1
                    ESPHealthBars[player].outline.Filled = false
                    ESPHealthBars[player].outline.Visible = false
                    ESPHealthBars[player].bar.Thickness = 1
                    ESPHealthBars[player].bar.Filled = true
                    ESPHealthBars[player].bar.Visible = false
                end
                
                -- Update colors
                ESPBoxes[player].Color = Settings.BoxColor
                ESPBoxes[player].Filled = Settings.FilledBox and Settings.FilledBoxActive
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
                    if Settings.BoxCorner and Settings.BoxCornerActive then
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
                    if Settings.HealthBar and Settings.HealthBarActive then
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
                    
                    -- Update skeleton
                    if Settings.Skeleton then
                        if not ESPSkeletons[player] then
                            ESPSkeletons[player] = {}
                        end
                        UpdateSkeleton(player, ESPSkeletons[player], Settings.SkeletonColor)
                    else
                        if ESPSkeletons[player] then
                            for _, line in pairs(ESPSkeletons[player]) do
                                line.Visible = false
                            end
                        end
                    end
                else
                    ESPBoxes[player].Visible = false
                    ESPNames[player].Visible = false
                    ESPDistances[player].Visible = false
                    ESPHealthBars[player].bg.Visible = false
                    ESPHealthBars[player].outline.Visible = false
                    ESPHealthBars[player].bar.Visible = false
                    if ESPSkeletons[player] then
                        for _, line in pairs(ESPSkeletons[player]) do
                            line.Visible = false
                        end
                    end
                end
                end -- Close passTeamCheck else block
            end -- Close isValid else block
        end -- Close player.Character if
    end -- Close for loop
end -- Close function

-- Local ESP Update Function (independent from regular ESP)
local function UpdateLocalESP()
    -- Local Skeleton
    if Settings.LocalSkeleton and Settings.LocalSkeletonActive and LocalPlayer.Character then
        UpdateSkeleton(LocalPlayer, LocalSkeletonLines, Settings.LocalSkeletonColor)
    else
        if LocalSkeletonLines and #LocalSkeletonLines > 0 then
            for _, line in pairs(LocalSkeletonLines) do
                if line then line.Visible = false end
            end
        end
    end
    
    -- Local Highlight
    UpdateLocalHighlight()
end



-- Loading flag (global)
_G.SentinelLoaded = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SentinelGui"
ScreenGui.ResetOnSpawn = false

-- Loading flag to prevent ESP from showing during initialization
local isMenuLoaded = false
ScreenGui.Enabled = false
ScreenGui.Parent = game:GetService("CoreGui")

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad), props):Play()
end

-- Main Frame - Modern Dark Theme
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 680, 0, 500)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui

local savedMenuSize = Main.Size

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

-- Hint Frame (shows only once on first load)
local HintFrame = Instance.new("Frame")
HintFrame.Size = UDim2.new(0, 280, 0, 50)
HintFrame.Position = UDim2.new(0.5, -140, 1, -70)
HintFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
HintFrame.BorderSizePixel = 0
HintFrame.Visible = false
HintFrame.Parent = ScreenGui

local HintCorner = Instance.new("UICorner")
HintCorner.CornerRadius = UDim.new(0, 10)
HintCorner.Parent = HintFrame

local HintText = Instance.new("TextLabel")
HintText.Size = UDim2.new(1, -20, 1, 0)
HintText.Position = UDim2.new(0, 10, 0, 0)
HintText.BackgroundTransparency = 1
HintText.Text = "Press INSERT to open menu"
HintText.TextColor3 = Color3.fromRGB(200, 200, 200)
HintText.TextSize = 14
HintText.Font = Enum.Font.Gotham
HintText.Parent = HintFrame

-- Top Button Panel
local TopPanel = Instance.new("Frame")
TopPanel.Size = UDim2.new(0, 360, 0, 50)
TopPanel.Position = UDim2.new(0.5, 0, 0, -20)
TopPanel.AnchorPoint = Vector2.new(0.5, 0)
TopPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TopPanel.BorderSizePixel = 0
TopPanel.BackgroundTransparency = 1
TopPanel.Visible = false
TopPanel.Parent = ScreenGui

local TopPanelCorner = Instance.new("UICorner")
TopPanelCorner.CornerRadius = UDim.new(0, 8)
TopPanelCorner.Parent = TopPanel

local TopPanelStroke = Instance.new("UIStroke")
TopPanelStroke.Color = Settings.MenuColor
TopPanelStroke.Thickness = 2
TopPanelStroke.Transparency = 1
TopPanelStroke.Parent = TopPanel
table.insert(AccentColorElements.DropdownStrokes, TopPanelStroke)

-- Create 6 buttons
local buttonSize = 40
local buttonSpacing = 10
local totalWidth = (buttonSize * 6) + (buttonSpacing * 5)
local startX = (360 - totalWidth) / 2

for i = 1, 6 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    btn.Position = UDim2.new(0, startX + (i-1) * (buttonSize + buttonSpacing), 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.BackgroundTransparency = 1
    btn.Parent = TopPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Settings.MenuColor
    btnStroke.Thickness = 1
    btnStroke.Transparency = 1
    btnStroke.Parent = btn
    table.insert(AccentColorElements.CheckboxStrokes, btnStroke)
    
    -- Add keyboard icon to first button
    if i == 1 then
        -- Store button reference for updating background color
        _G.KeybindManagerButton = btn
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.Position = UDim2.new(0, 0, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "⌨"
        icon.TextColor3 = Settings.MenuColor
        icon.TextSize = 24
        icon.Font = Enum.Font.GothamBold
        icon.TextTransparency = 1
        icon.Parent = btn
        
        -- Animate icon with button
        task.spawn(function()
            while true do
                task.wait()
                if btn.BackgroundTransparency < 1 then
                    icon.TextTransparency = btn.BackgroundTransparency
                end
            end
        end)
    end
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        if i == 1 and _G.KeybindManagerOpen then
            -- Don't change color on hover if keybind manager is open
            return
        end
        Tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        if i == 1 and _G.KeybindManagerOpen then
            -- Keep menu color if keybind manager is open
            return
        end
        Tween(btn, {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}, 0.2)
    end)
    
    -- Click handler
    btn.MouseButton1Click:Connect(function()
        if i == 1 then
            -- Toggle keybind manager window
            if _G.KeybindManagerOpen then
                -- Close window
                if _G.KeybindManagerWindow and _G.KeybindManagerWindow.Parent then
                    -- Save position
                    _G.KeybindManagerPosition = _G.KeybindManagerWindow.Position
                    
                    local titleBar = _G.KeybindManagerWindow:FindFirstChild("Frame")
                    local scrollFrame = _G.KeybindManagerWindow:FindFirstChild("ScrollingFrame")
                    
                    Tween(_G.KeybindManagerWindow, {BackgroundTransparency = 1}, 0.2)
                    local stroke = _G.KeybindManagerWindow:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        Tween(stroke, {Transparency = 1}, 0.2)
                    end
                    if titleBar then
                        Tween(titleBar, {BackgroundTransparency = 1}, 0.2)
                        for _, element in ipairs(titleBar:GetChildren()) do
                            if element:IsA("TextLabel") then
                                Tween(element, {TextTransparency = 1}, 0.2)
                            elseif element:IsA("TextButton") then
                                Tween(element, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                            end
                        end
                    end
                    if scrollFrame then
                        for _, child in ipairs(scrollFrame:GetChildren()) do
                            if child:IsA("Frame") then
                                Tween(child, {BackgroundTransparency = 1}, 0.2)
                                for _, element in ipairs(child:GetChildren()) do
                                    if element:IsA("TextLabel") then
                                        Tween(element, {TextTransparency = 1}, 0.2)
                                    elseif element:IsA("TextButton") then
                                        Tween(element, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(0.2)
                    _G.KeybindManagerWindow:Destroy()
                    _G.KeybindManagerWindow = nil
                    _G.KeybindManagerOpen = false
                    
                    -- Update button background color
                    if _G.KeybindManagerButton then
                        Tween(_G.KeybindManagerButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}, 0.2)
                    end
                end
                return
            end
            
            _G.KeybindManagerOpen = true
            
            -- Update button background color
            if _G.KeybindManagerButton then
                Tween(_G.KeybindManagerButton, {BackgroundColor3 = Settings.MenuColor}, 0.2)
            end
            
            local managerWindow = Instance.new("Frame")
            -- Use saved position or default to center
            if _G.KeybindManagerPosition then
                managerWindow.Position = _G.KeybindManagerPosition
            else
                managerWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
            managerWindow.AnchorPoint = Vector2.new(0.5, 0.5)
            managerWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            managerWindow.BorderSizePixel = 0
            managerWindow.ZIndex = 100
            managerWindow.BackgroundTransparency = 1
            managerWindow.Parent = ScreenGui
            
            _G.KeybindManagerWindow = managerWindow
            
            local managerCorner = Instance.new("UICorner")
            managerCorner.CornerRadius = UDim.new(0, 10)
            managerCorner.Parent = managerWindow
            
            local managerStroke = Instance.new("UIStroke")
            managerStroke.Color = Settings.MenuColor
            managerStroke.Thickness = 2
            managerStroke.Transparency = 1
            managerStroke.Parent = managerWindow
            
            -- Title
            local titleBar = Instance.new("Frame")
            titleBar.Size = UDim2.new(1, 0, 0, 40)
            titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            titleBar.BorderSizePixel = 0
            titleBar.BackgroundTransparency = 1
            titleBar.ZIndex = 101
            titleBar.Parent = managerWindow
            
            local titleCorner = Instance.new("UICorner")
            titleCorner.CornerRadius = UDim.new(0, 10)
            titleCorner.Parent = titleBar
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -50, 1, 0)
            titleLabel.Position = UDim2.new(0, 15, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = "Keybind Manager"
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 16
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.TextTransparency = 1
            titleLabel.ZIndex = 102
            titleLabel.Parent = titleBar
            
            -- Close button
            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 30, 0, 30)
            closeBtn.Position = UDim2.new(1, -35, 0, 5)
            closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            closeBtn.Text = "×"
            closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeBtn.TextSize = 20
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.BorderSizePixel = 0
            closeBtn.BackgroundTransparency = 1
            closeBtn.TextTransparency = 1
            closeBtn.ZIndex = 102
            closeBtn.Parent = titleBar
            
            local closeBtnCorner = Instance.new("UICorner")
            closeBtnCorner.CornerRadius = UDim.new(0, 6)
            closeBtnCorner.Parent = closeBtn
            
            closeBtn.MouseEnter:Connect(function()
                Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
            end)
            
            closeBtn.MouseLeave:Connect(function()
                Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            closeBtn.MouseButton1Click:Connect(function()
                -- Save position before closing
                _G.KeybindManagerPosition = managerWindow.Position
                Tween(managerWindow, {BackgroundTransparency = 1}, 0.2)
                Tween(managerStroke, {Transparency = 1}, 0.2)
                Tween(titleBar, {BackgroundTransparency = 1}, 0.2)
                Tween(titleLabel, {TextTransparency = 1}, 0.2)
                Tween(closeBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                
                -- Animate all items
                for _, child in ipairs(scrollFrame:GetChildren()) do
                    if child:IsA("Frame") then
                        Tween(child, {BackgroundTransparency = 1}, 0.2)
                        for _, element in ipairs(child:GetChildren()) do
                            if element:IsA("TextLabel") then
                                Tween(element, {TextTransparency = 1}, 0.2)
                            elseif element:IsA("TextButton") then
                                Tween(element, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                            end
                        end
                    end
                end
                
                task.wait(0.2)
                managerWindow:Destroy()
                _G.KeybindManagerWindow = nil
                _G.KeybindManagerOpen = false
                
                -- Update button background color
                if _G.KeybindManagerButton then
                    Tween(_G.KeybindManagerButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}, 0.2)
                end
            end)
            
            -- Make window draggable
            local dragging = false
            local dragStart = nil
            local startPos = nil
            
            titleBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = managerWindow.Position
                end
            end)
            
            titleBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    managerWindow.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
            
            -- Scroll frame for keybinds
            local scrollFrame = Instance.new("ScrollingFrame")
            scrollFrame.Size = UDim2.new(1, -20, 1, -50)
            scrollFrame.Position = UDim2.new(0, 10, 0, 45)
            scrollFrame.BackgroundTransparency = 1
            scrollFrame.BorderSizePixel = 0
            scrollFrame.ScrollBarThickness = 4
            scrollFrame.ScrollBarImageColor3 = Settings.MenuColor
            scrollFrame.ZIndex = 101
            scrollFrame.Parent = managerWindow
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 8)
            listLayout.Parent = scrollFrame
            
            -- Count keybinds to show
            local keybindCount = 0
            for name, bind in pairs(Settings.Keybinds) do
                if name ~= "Hitbox" then
                    if bind.Enabled then
                        keybindCount = keybindCount + 1
                    end
                else
                    -- Count hitbox binds
                    for _, hitboxBind in pairs(bind) do
                        if hitboxBind.Enabled then
                            keybindCount = keybindCount + 1
                        end
                    end
                end
            end
            
            -- Create keybind items
            for name, bind in pairs(Settings.Keybinds) do
                if name ~= "Hitbox" then
                    if bind.Enabled then
                        local item = Instance.new("Frame")
                        item.Size = UDim2.new(1, 0, 0, 50)
                        item.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                        item.BackgroundTransparency = 1
                        item.BorderSizePixel = 0
                        item.ZIndex = 101
                        item.Parent = scrollFrame
                        
                        local itemCorner = Instance.new("UICorner")
                        itemCorner.CornerRadius = UDim.new(0, 6)
                        itemCorner.Parent = item
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(0, 150, 1, 0)
                        nameLabel.Position = UDim2.new(0, 10, 0, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = name
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.TextSize = 13
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                        nameLabel.TextTransparency = 1
                        nameLabel.ZIndex = 102
                        nameLabel.Parent = item
                        
                        local keyLabel = Instance.new("TextButton")
                        keyLabel.Size = UDim2.new(0, 80, 0, 25)
                        keyLabel.Position = UDim2.new(1, -180, 0.5, -12.5)
                        keyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                        keyLabel.Text = bind.Enabled and "[" .. (typeof(bind.Key) == "EnumItem" and bind.Key.Name or "NONE") .. "]" or "[NONE]"
                        keyLabel.TextColor3 = Settings.MenuColor
                        keyLabel.TextSize = 11
                        keyLabel.Font = Enum.Font.GothamBold
                        keyLabel.BorderSizePixel = 0
                        keyLabel.BackgroundTransparency = 1
                        keyLabel.TextTransparency = 1
                        keyLabel.ZIndex = 102
                        keyLabel.Parent = item
                        
                        local keyCorner = Instance.new("UICorner")
                        keyCorner.CornerRadius = UDim.new(0, 4)
                        keyCorner.Parent = keyLabel
                        
                        -- Click to change key
                        local bindingKey = false
                        keyLabel.MouseButton1Click:Connect(function()
                            if bindingKey then return end
                            bindingKey = true
                            keyLabel.Text = "[Press...]"
                            keyLabel.BackgroundColor3 = Settings.MenuColor
                            
                            local connection
                            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                                if input.UserInputType == Enum.UserInputType.Keyboard then
                                    if input.KeyCode == Enum.KeyCode.Escape then
                                        Settings.Keybinds[name].Enabled = false
                                        keyLabel.Text = "[NONE]"
                                    else
                                        Settings.Keybinds[name].Enabled = true
                                        Settings.Keybinds[name].Key = input.KeyCode
                                        keyLabel.Text = "[" .. input.KeyCode.Name .. "]"
                                    end
                                    keyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                                    bindingKey = false
                                    connection:Disconnect()
                                elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                                    Settings.Keybinds[name].Enabled = true
                                    Settings.Keybinds[name].Key = input.UserInputType
                                    keyLabel.Text = input.UserInputType == Enum.UserInputType.MouseButton1 and "[M1]" or "[M2]"
                                    keyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                                    bindingKey = false
                                    connection:Disconnect()
                                end
                            end)
                        end)
                        
                        local modeLabel = Instance.new("TextButton")
                        modeLabel.Size = UDim2.new(0, 80, 0, 25)
                        modeLabel.Position = UDim2.new(1, -90, 0.5, -12.5)
                        modeLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                        modeLabel.Text = bind.Mode
                        modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                        modeLabel.TextSize = 10
                        modeLabel.Font = Enum.Font.Gotham
                        modeLabel.BorderSizePixel = 0
                        modeLabel.BackgroundTransparency = 1
                        modeLabel.TextTransparency = 1
                        modeLabel.ZIndex = 102
                        modeLabel.Parent = item
                        
                        local modeCorner = Instance.new("UICorner")
                        modeCorner.CornerRadius = UDim.new(0, 4)
                        modeCorner.Parent = modeLabel
                        
                        -- Click to cycle through modes
                        modeLabel.MouseButton1Click:Connect(function()
                            local modes = {"Toggle", "Hold", "Always On"}
                            local currentIndex = 1
                            for i, mode in ipairs(modes) do
                                if Settings.Keybinds[name].Mode == mode then
                                    currentIndex = i
                                    break
                                end
                            end
                            
                            -- Cycle to next mode
                            local nextIndex = (currentIndex % 3) + 1
                            local newMode = modes[nextIndex]
                            
                            Settings.Keybinds[name].Mode = newMode
                            modeLabel.Text = newMode
                            ShowNotification(name .. " mode: " .. newMode, 1.5)
                            
                            local activeName = name .. "Active"
                            -- If Always On mode, activate the function
                            if newMode == "Always On" and Settings[name] then
                                Settings[activeName] = true
                            elseif newMode ~= "Always On" then
                                -- If switching from Always On to Toggle/Hold, deactivate
                                Settings[activeName] = false
                            end
                        end)
                    end
                else
                    -- Handle Hitbox binds
                    for hitboxName, hitboxBind in pairs(bind) do
                        if hitboxBind.Enabled then
                            local item = Instance.new("Frame")
                            item.Size = UDim2.new(1, 0, 0, 50)
                            item.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                            item.BorderSizePixel = 0
                            item.ZIndex = 101
                            item.Parent = scrollFrame
                            
                            local itemCorner = Instance.new("UICorner")
                            itemCorner.CornerRadius = UDim.new(0, 6)
                            itemCorner.Parent = item
                            
                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Size = UDim2.new(0, 150, 1, 0)
                            nameLabel.Position = UDim2.new(0, 10, 0, 0)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.Text = "Hitbox: " .. hitboxName
                            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            nameLabel.TextSize = 13
                            nameLabel.Font = Enum.Font.GothamBold
                            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                            nameLabel.ZIndex = 102
                            nameLabel.Parent = item
                            
                            local keyLabel = Instance.new("TextButton")
                            keyLabel.Size = UDim2.new(0, 80, 0, 25)
                            keyLabel.Position = UDim2.new(1, -90, 0.5, -12.5)
                            keyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                            keyLabel.Text = "[" .. (typeof(hitboxBind.Key) == "EnumItem" and hitboxBind.Key.Name or "NONE") .. "]"
                            keyLabel.TextColor3 = Settings.MenuColor
                            keyLabel.TextSize = 11
                            keyLabel.Font = Enum.Font.GothamBold
                            keyLabel.BorderSizePixel = 0
                            keyLabel.ZIndex = 102
                            keyLabel.Parent = item
                            
                            local keyCorner = Instance.new("UICorner")
                            keyCorner.CornerRadius = UDim.new(0, 4)
                            keyCorner.Parent = keyLabel
                            
                            -- Click to change key
                            local bindingKey = false
                            keyLabel.MouseButton1Click:Connect(function()
                                if bindingKey then return end
                                bindingKey = true
                                keyLabel.Text = "[Press...]"
                                keyLabel.BackgroundColor3 = Settings.MenuColor
                                
                                local connection
                                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                                    if input.UserInputType == Enum.UserInputType.Keyboard then
                                        if input.KeyCode == Enum.KeyCode.Escape then
                                            Settings.Keybinds.Hitbox[hitboxName].Enabled = false
                                            keyLabel.Text = "[NONE]"
                                        else
                                            Settings.Keybinds.Hitbox[hitboxName].Enabled = true
                                            Settings.Keybinds.Hitbox[hitboxName].Key = input.KeyCode
                                            keyLabel.Text = "[" .. input.KeyCode.Name .. "]"
                                        end
                                        keyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                                        bindingKey = false
                                        connection:Disconnect()
                                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                                        Settings.Keybinds.Hitbox[hitboxName].Enabled = true
                                        Settings.Keybinds.Hitbox[hitboxName].Key = input.UserInputType
                                        keyLabel.Text = input.UserInputType == Enum.UserInputType.MouseButton1 and "[M1]" or "[M2]"
                                        keyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                                        bindingKey = false
                                        connection:Disconnect()
                                    end
                                end)
                            end)
                        end
                    end
                end
            end
            
            -- Update scroll canvas size
            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
            end)
            
            -- Animate window opening with fade in
            local targetHeight = math.min(60 + (keybindCount * 58), 500)
            managerWindow.Size = UDim2.new(0, 400, 0, targetHeight)
            Tween(managerWindow, {BackgroundTransparency = 0}, 0.2)
            Tween(managerStroke, {Transparency = 0}, 0.2)
            Tween(titleBar, {BackgroundTransparency = 0}, 0.2)
            Tween(titleLabel, {TextTransparency = 0}, 0.2)
            Tween(closeBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
            
            -- Animate all items
            for _, child in ipairs(scrollFrame:GetChildren()) do
                if child:IsA("Frame") then
                    Tween(child, {BackgroundTransparency = 0}, 0.2)
                    for _, element in ipairs(child:GetChildren()) do
                        if element:IsA("TextLabel") then
                            Tween(element, {TextTransparency = 0}, 0.2)
                        elseif element:IsA("TextButton") then
                            Tween(element, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
                        end
                    end
                end
            end
        else
            ShowNotification("Button " .. i .. " clicked", 1.5)
        end
    end)
end

-- Title Bar
HintText.TextColor3 = Color3.fromRGB(255, 255, 255)
HintText.TextSize = 13
HintText.Font = Enum.Font.Gotham
HintText.Parent = HintFrame

local hintShown = false

task.spawn(function()
    task.wait(2.5)
    if _G.SentinelLoaded and not hintShown then
        hintShown = true
        HintFrame.Visible = true
        Tween(HintFrame, {Position = UDim2.new(0.5, -140, 1, -80)}, 0.3)
    end
end)

-- Top Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 35)
StatusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = Main

local StatusBarCorner = Instance.new("UICorner")
StatusBarCorner.CornerRadius = UDim.new(0, 10)
StatusBarCorner.Parent = StatusBar

-- Cover for bottom corners of StatusBar
local StatusBarCover = Instance.new("Frame")
StatusBarCover.Size = UDim2.new(1, 0, 0, 10)
StatusBarCover.Position = UDim2.new(0, 0, 1, -10)
StatusBarCover.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatusBarCover.BorderSizePixel = 0
StatusBarCover.Parent = StatusBar

local StatusBarBottom = Instance.new("Frame")
StatusBarBottom.Size = UDim2.new(1, 0, 0, 1)
StatusBarBottom.Position = UDim2.new(0, 0, 1, 0)
StatusBarBottom.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
StatusBarBottom.BackgroundTransparency = 0.7
StatusBarBottom.BorderSizePixel = 0
StatusBarBottom.ZIndex = 2
StatusBarBottom.Parent = StatusBar
AccentColorElements.StatusBarBottom = StatusBarBottom

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SENTINEL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = StatusBar

-- Add gradient to SENTINEL title
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Settings.MenuColor),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Settings.MenuColor)
})
TitleGradient.Parent = Title

-- Store gradient for updates
AccentColorElements.SentinelTitleGradient = TitleGradient

-- Animate SENTINEL title gradient
task.spawn(function()
    local offset = -2
    while true do
        offset = offset + 0.01
        if offset > 2 then offset = -2 end
        if TitleGradient and TitleGradient.Parent then
            TitleGradient.Offset = Vector2.new(offset, 0)
        end
        task.wait(0.05) -- Increased from 0.03 to 0.05 for better performance
    end
end)

-- Initialize Title as array
AccentColorElements.Title = {}

-- FPS Counter
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0, 80, 1, 0)
FPSLabel.Position = UDim2.new(1, -250, 0, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 60"
FPSLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
FPSLabel.TextSize = 11
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
FPSLabel.Parent = StatusBar

-- Ping Counter
local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(0, 80, 1, 0)
PingLabel.Position = UDim2.new(1, -160, 0, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "PING: 0ms"
PingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
PingLabel.TextSize = 11
PingLabel.Font = Enum.Font.Gotham
PingLabel.TextXAlignment = Enum.TextXAlignment.Right
PingLabel.Parent = StatusBar

-- Update FPS and Ping
local lastUpdate = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastUpdate >= 1 then
        local fps = frameCount / (now - lastUpdate)
        FPSLabel.Text = string.format("FPS: %d", math.floor(fps))
        frameCount = 0
        lastUpdate = now
        
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        PingLabel.Text = string.format("PING: %dms", math.floor(ping))
    end
end)

-- Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 25)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.Parent = StatusBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

Close.MouseEnter:Connect(function()
    Tween(Close, {BackgroundColor3 = Color3.fromRGB(255, 20, 147)}, 0.2)
end)

Close.MouseLeave:Connect(function()
    Tween(Close, {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}, 0.2)
end)

Close.MouseButton1Click:Connect(function()
    savedMenuSize = Main.Size
    Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    Tween(TopPanel, {BackgroundTransparency = 1}, 0.15)
    Tween(TopPanelStroke, {Transparency = 1}, 0.15)
    -- Animate buttons
    for _, child in ipairs(TopPanel:GetChildren()) do
        if child:IsA("TextButton") then
            Tween(child, {BackgroundTransparency = 1}, 0.15)
            local stroke = child:FindFirstChildOfClass("UIStroke")
            if stroke then
                Tween(stroke, {Transparency = 1}, 0.15)
            end
        end
    end
    task.wait(0.3)
    Main.Visible = false
    TopPanel.Visible = false
    
    -- Hide keybind manager if open (but keep state)
    if _G.KeybindManagerOpen and _G.KeybindManagerWindow then
        _G.KeybindManagerPosition = _G.KeybindManagerWindow.Position
        _G.KeybindManagerWindow.Visible = false
    end
end)

-- Horizontal Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 40)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TabBar.BorderSizePixel = 0
TabBar.ClipsDescendants = true
TabBar.Parent = Main

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(1, 0)
TabBarCorner.Parent = TabBar

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -105)
Content.Position = UDim2.new(0, 10, 0, 95)
Content.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Content.BorderSizePixel = 0
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = Content

-- Tab System
local Tabs = {}
local CurrentTab = nil
local TabCount = 0

-- Calculate centered starting position
-- 5 tabs * 100px + 4 gaps * 10px = 540px total
-- TabBar width = 580px (600 - 20)
-- Start offset = (580 - 540) / 2 = 20px

-- Sliding indicator for active tab
local TabIndicator = Instance.new("Frame")
TabIndicator.Size = UDim2.new(0, 100, 0, 30)
TabIndicator.Position = UDim2.new(0, 20, 0, 5)
TabIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabIndicator.BackgroundTransparency = 0.92
TabIndicator.BorderSizePixel = 0
TabIndicator.ZIndex = 5
TabIndicator.Parent = TabBar

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(1, 0)
indicatorCorner.Parent = TabIndicator

local indicatorStroke = Instance.new("UIStroke")
indicatorStroke.Color = Color3.fromRGB(255, 255, 255)
indicatorStroke.Thickness = 1
indicatorStroke.Transparency = 0.3
indicatorStroke.Parent = TabIndicator
AccentColorElements.TabIndicatorStroke = indicatorStroke

-- Function to recalculate tab positions based on TabBar width
local function RecalculateTabPositions()
    local tabBarWidth = TabBar.AbsoluteSize.X
    local totalTabsWidth = 600 -- 6 tabs * 100px
    local totalGaps = 50 -- 5 gaps * 10px
    local startOffset = (tabBarWidth - totalTabsWidth - totalGaps) / 2
    
    for i, tab in ipairs(Tabs) do
        local xPos = startOffset + ((i - 1) * 110)
        tab.Button.Position = UDim2.new(0, xPos, 0, 5)
    end
    
    -- Update indicator position if there's a current tab
    if CurrentTab then
        for i, tab in ipairs(Tabs) do
            if tab == CurrentTab then
                local xPos = startOffset + ((i - 1) * 110)
                TabIndicator.Position = UDim2.new(0, xPos, 0, 5)
                break
            end
        end
    else
        -- Set initial position
        TabIndicator.Position = UDim2.new(0, startOffset, 0, 5)
    end
end

-- Update positions when TabBar size changes
TabBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    RecalculateTabPositions()
end)

local function CreateTab(name)
    local tab = {}
    
    local tabBarWidth = TabBar.AbsoluteSize.X
    local totalTabsWidth = 540
    local startOffset = (tabBarWidth - totalTabsWidth) / 2
    local xPos = startOffset + (TabCount * 110)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, xPos, 0, 5)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.Parent = TabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn
    
    -- Individual ScrollingFrame for this tab with two-column layout
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size = UDim2.new(1, -20, 1, -20)
    tabScroll.Position = UDim2.new(0, 10, 0, 10)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel = 0
    tabScroll.ScrollBarThickness = 3
    tabScroll.ScrollBarImageColor3 = Settings.MenuColor
    tabScroll.Visible = false
    tabScroll.Parent = Content
    table.insert(AccentColorElements.ScrollBars, tabScroll)
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = tabScroll
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = content
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    tab.Button = btn
    tab.Content = content
    tab.Scroll = tabScroll
    tab.XPos = xPos
    
    btn.MouseButton1Click:Connect(function()
        -- Close keybind menu when switching tabs
        if currentKeybindMenu and currentKeybindMenu.Parent then
            Tween(currentKeybindMenu, {BackgroundTransparency = 1}, 0.2)
            local menuStroke = currentKeybindMenu:FindFirstChildOfClass("UIStroke")
            if menuStroke then
                Tween(menuStroke, {Transparency = 1}, 0.2)
            end
            
            -- Animate all child elements
            for _, child in ipairs(currentKeybindMenu:GetChildren()) do
                if child:IsA("TextLabel") then
                    Tween(child, {TextTransparency = 1}, 0.2)
                elseif child:IsA("TextButton") then
                    Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                end
            end
            
            task.spawn(function()
                task.wait(0.2)
                if currentKeybindMenu then
                    currentKeybindMenu:Destroy()
                    currentKeybindMenu = nil
                end
            end)
        end
        
        for _, t in pairs(Tabs) do
            t.Scroll.Visible = false
            Tween(t.Button, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
        end
        tabScroll.Visible = true
        Tween(btn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        
        -- Animate indicator with squeeze effect
        local currentPos = TabIndicator.Position.X.Offset
        local targetPos = btn.Position.X.Offset
        local distance = math.abs(targetPos - currentPos)
        
        if distance > 0 then
            -- Squeeze and move simultaneously
            Tween(TabIndicator, {Size = UDim2.new(0, 70, 0, 30), Position = UDim2.new(0, targetPos, 0, 5)}, 0.25)
            task.wait(0.18)
            -- Expand back when almost at destination
            Tween(TabIndicator, {Size = UDim2.new(0, 100, 0, 30)}, 0.15)
        end
        
        CurrentTab = tab
    end)
    
    TabCount = TabCount + 1
    table.insert(Tabs, tab)
    return tab
end

-- Modern UI Element Creation Functions

local function CreateToggle(parent, text, default, callback, keybindName)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    -- Square checkbox
    local checkbox = Instance.new("Frame")
    checkbox.Size = UDim2.new(0, 16, 0, 16)
    checkbox.Position = UDim2.new(1, -26, 0.5, -8)
    checkbox.BackgroundColor3 = default and Settings.MenuColor or Color3.fromRGB(30, 30, 35)
    checkbox.BorderSizePixel = 0
    checkbox.Parent = frame
    
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 2)
    checkCorner.Parent = checkbox
    
    local checkStroke = Instance.new("UIStroke")
    checkStroke.Color = Color3.fromRGB(255, 20, 147)
    checkStroke.Thickness = 1
    checkStroke.Transparency = 0.5
    checkStroke.Parent = checkbox
    table.insert(AccentColorElements.CheckboxStrokes, checkStroke)
    if default then table.insert(AccentColorElements.CheckboxBackgrounds, checkbox) end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    
    local enabled = default
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Tween(checkbox, {BackgroundColor3 = Settings.MenuColor}, 0.3)
            table.insert(AccentColorElements.CheckboxBackgrounds, checkbox)
        else
            Tween(checkbox, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.3)
            -- Remove from array when unchecked
            for i, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                if cb == checkbox then
                    table.remove(AccentColorElements.CheckboxBackgrounds, i)
                    break
                end
            end
        end
        callback(enabled)
    end)
    
    -- Right click - open keybind menu (only if keybindName provided)
    if keybindName then
        if not Settings.Keybinds[keybindName] then
            Settings.Keybinds[keybindName] = {Key = Enum.KeyCode.E, Mode = "Toggle", Enabled = false}
        end
        
        btn.MouseButton2Click:Connect(function()
            -- Close existing menu if open (without waiting)
            if currentKeybindMenu and currentKeybindMenu.Parent then
                local oldMenu = currentKeybindMenu
                Tween(oldMenu, {BackgroundTransparency = 1}, 0.2)
                local menuStroke = oldMenu:FindFirstChildOfClass("UIStroke")
                if menuStroke then
                    Tween(menuStroke, {Transparency = 1}, 0.2)
                end
                
                -- Animate all child elements
                for _, child in ipairs(oldMenu:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Tween(child, {TextTransparency = 1}, 0.2)
                    elseif child:IsA("TextButton") then
                        Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                    end
                end
                
                -- Destroy after animation in background
                task.spawn(function()
                    task.wait(0.2)
                    oldMenu:Destroy()
                end)
                
                currentKeybindMenu = nil
            end
            
            -- Get mouse position relative to ScreenGui
            local mousePos = UserInputService:GetMouseLocation()
            local guiInset = game:GetService("GuiService"):GetGuiInset()
            local screenSize = ScreenGui.AbsoluteSize
            
            -- Adjust for GUI inset (top bar)
            local adjustedMouseX = mousePos.X
            local adjustedMouseY = mousePos.Y - guiInset.Y
            
            -- Calculate menu position at cursor (no offset)
            local menuWidth = 200
            local menuHeight = 165
            
            -- Position: cursor at top-left corner of menu
            local posX = adjustedMouseX
            local posY = adjustedMouseY
            
            -- Adjust position if menu would go off screen
            if posX + menuWidth > screenSize.X then
                posX = adjustedMouseX - menuWidth
            end
            
            if posY + menuHeight > screenSize.Y then
                posY = adjustedMouseY - menuHeight
            end
            
            local menu = Instance.new("Frame")
            menu.Size = UDim2.new(0, menuWidth, 0, menuHeight)
            menu.Position = UDim2.new(0, posX, 0, posY)
            menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            menu.BorderSizePixel = 0
            menu.ZIndex = 200
            menu.BackgroundTransparency = 1
            menu.Parent = ScreenGui
            
            currentKeybindMenu = menu
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local menuStroke = Instance.new("UIStroke")
            menuStroke.Color = Settings.MenuColor
            menuStroke.Thickness = 2
            menuStroke.Transparency = 1
            menuStroke.Parent = menu
            
            -- Animate menu appearance
            Tween(menu, {BackgroundTransparency = 0}, 0.2)
            Tween(menuStroke, {Transparency = 0}, 0.2)
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -30, 0, 30)
            title.Position = UDim2.new(0, 5, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = "Keybind: " .. text
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.ZIndex = 201
            title.TextTransparency = 1
            title.Parent = menu
            
            Tween(title, {TextTransparency = 0}, 0.2)
            
            -- Close button (X)
            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 25, 0, 25)
            closeBtn.Position = UDim2.new(1, -28, 0, 2.5)
            closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            closeBtn.Text = "×"
            closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeBtn.TextSize = 18
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.BorderSizePixel = 0
            closeBtn.ZIndex = 202
            closeBtn.BackgroundTransparency = 1
            closeBtn.TextTransparency = 1
            closeBtn.Parent = menu
            
            local closeBtnCorner = Instance.new("UICorner")
            closeBtnCorner.CornerRadius = UDim.new(0, 4)
            closeBtnCorner.Parent = closeBtn
            
            Tween(closeBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
            
            closeBtn.MouseEnter:Connect(function()
                Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
            end)
            
            closeBtn.MouseLeave:Connect(function()
                Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            closeBtn.MouseButton1Click:Connect(function()
                Tween(menu, {BackgroundTransparency = 1}, 0.2)
                Tween(menuStroke, {Transparency = 1}, 0.2)
                
                -- Animate all child elements
                for _, child in ipairs(menu:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Tween(child, {TextTransparency = 1}, 0.2)
                    elseif child:IsA("TextButton") then
                        Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                    end
                end
                
                task.wait(0.2)
                menu:Destroy()
                currentKeybindMenu = nil
            end)
            
            local bindBtn = Instance.new("TextButton")
            bindBtn.Size = UDim2.new(1, -20, 0, 30)
            bindBtn.Position = UDim2.new(0, 10, 0, 40)
            bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            bindBtn.Text = Settings.Keybinds[keybindName].Enabled and "[" .. (typeof(Settings.Keybinds[keybindName].Key) == "EnumItem" and Settings.Keybinds[keybindName].Key.Name or "NONE") .. "]" or "[NONE]"
            bindBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            bindBtn.TextSize = 12
            bindBtn.Font = Enum.Font.Gotham
            bindBtn.BorderSizePixel = 0
            bindBtn.ZIndex = 201
            bindBtn.BackgroundTransparency = 1
            bindBtn.TextTransparency = 1
            bindBtn.Parent = menu
            
            Tween(bindBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
            
            local bindCorner = Instance.new("UICorner")
            bindCorner.CornerRadius = UDim.new(0, 4)
            bindCorner.Parent = bindBtn
            
            local binding = false
            bindBtn.MouseButton1Click:Connect(function()
                if binding then return end
                binding = true
                bindBtn.Text = "[Press key...]"
                bindBtn.BackgroundColor3 = Settings.MenuColor
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            Settings.Keybinds[keybindName].Enabled = false
                            bindBtn.Text = "[NONE]"
                        else
                            Settings.Keybinds[keybindName].Enabled = true
                            Settings.Keybinds[keybindName].Key = input.KeyCode
                            bindBtn.Text = "[" .. input.KeyCode.Name .. "]"
                        end
                        bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                        binding = false
                        connection:Disconnect()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        Settings.Keybinds[keybindName].Enabled = true
                        Settings.Keybinds[keybindName].Key = input.UserInputType
                        bindBtn.Text = input.UserInputType == Enum.UserInputType.MouseButton1 and "[M1]" or "[M2]"
                        bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                        binding = false
                        connection:Disconnect()
                    end
                end)
            end)
            
            local modes = {"Toggle", "Hold", "Always On"}
            for i, mode in ipairs(modes) do
                local modeBtn = Instance.new("TextButton")
                modeBtn.Size = UDim2.new(1, -20, 0, 25)
                modeBtn.Position = UDim2.new(0, 10, 0, 75 + (i-1) * 27)
                modeBtn.BackgroundColor3 = Settings.Keybinds[keybindName].Mode == mode and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35)
                modeBtn.Text = mode
                modeBtn.TextColor3 = Settings.Keybinds[keybindName].Mode == mode and Settings.MenuColor or Color3.fromRGB(200, 200, 200)
                modeBtn.TextSize = 11
                modeBtn.Font = Enum.Font.Gotham
                modeBtn.BorderSizePixel = 0
                modeBtn.ZIndex = 201
                modeBtn.BackgroundTransparency = 1
                modeBtn.TextTransparency = 1
                modeBtn.Parent = menu
                
                -- Animate with delay
                task.spawn(function()
                    task.wait(0.05 * i)
                    Tween(modeBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
                end)
                
                local modeBtnCorner = Instance.new("UICorner")
                modeBtnCorner.CornerRadius = UDim.new(0, 3)
                modeBtnCorner.Parent = modeBtn
                
                modeBtn.MouseButton1Click:Connect(function()
                    Settings.Keybinds[keybindName].Mode = mode
                    
                    -- Update all mode buttons colors
                    for _, child in ipairs(menu:GetChildren()) do
                        if child:IsA("TextButton") and child ~= bindBtn and child ~= closeBtn then
                            if child.Text == mode then
                                Tween(child, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
                                child.TextColor3 = Settings.MenuColor
                            else
                                Tween(child, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
                                child.TextColor3 = Color3.fromRGB(200, 200, 200)
                            end
                        end
                    end
                    
                    local activeName = keybindName .. "Active"
                    -- Activate function if Always On mode is selected
                    if mode == "Always On" and Settings[keybindName] then
                        Settings[activeName] = true
                    elseif mode ~= "Always On" then
                        -- If switching from Always On to Toggle/Hold, deactivate
                        Settings[activeName] = false
                    end
                    
                    -- Legacy support for ESP, Aimbot, InfiniteJump
                    if keybindName == "ESP" and Settings.ESP then
                        Settings.ESPActive = mode == "Always On" or mode == "Toggle"
                    elseif keybindName == "Aimbot" and Settings.Aimbot then
                        Settings.AimbotActive = mode == "Always On" or mode == "Toggle"
                    elseif keybindName == "InfiniteJump" and Settings.InfiniteJump then
                        Settings.InfiniteJumpActive = mode == "Always On" or mode == "Toggle"
                    end
                    
                    ShowNotification(text .. " mode: " .. mode, 1.5)
                end)
            end
        end)
    end
    
    return {
        Frame = frame,
        SetValue = function(value)
            enabled = value
            if value then
                checkbox.BackgroundColor3 = Settings.MenuColor
                local found = false
                for _, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                    if cb == checkbox then found = true break end
                end
                if not found then
                    table.insert(AccentColorElements.CheckboxBackgrounds, checkbox)
                end
            else
                checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                for i, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                    if cb == checkbox then
                        table.remove(AccentColorElements.CheckboxBackgrounds, i)
                        break
                    end
                end
            end
        end,
        UpdateKeybind = keybindName and function() end or nil
    }
end

local function CreateToggleWithKeybind(parent, text, default, keybindName, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -130, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    -- Keybind button
    local keybindBtn = Instance.new("TextButton")
    keybindBtn.Size = UDim2.new(0, 60, 0, 20)
    keybindBtn.Position = UDim2.new(1, -90, 0.5, -10)
    keybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    keybindBtn.Text = "[" .. (typeof(Settings.Keybinds[keybindName].Key) == "EnumItem" and Settings.Keybinds[keybindName].Key.Name or "M2") .. "]"
    keybindBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    keybindBtn.TextSize = 10
    keybindBtn.Font = Enum.Font.Gotham
    keybindBtn.BorderSizePixel = 0
    keybindBtn.Parent = frame
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 3)
    keybindCorner.Parent = keybindBtn
    
    -- Mode dropdown menu
    local modeDropdown = Instance.new("Frame")
    modeDropdown.Size = UDim2.new(0, 90, 0, 90)
    modeDropdown.Position = UDim2.new(1, -90, 1, 5)
    modeDropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    modeDropdown.BorderSizePixel = 0
    modeDropdown.Visible = false
    modeDropdown.ZIndex = 100
    modeDropdown.Parent = frame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = modeDropdown
    
    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Color = Settings.MenuColor
    dropdownStroke.Thickness = 1
    dropdownStroke.Transparency = 0.5
    dropdownStroke.Parent = modeDropdown
    table.insert(AccentColorElements.DropdownStrokes, dropdownStroke)
    
    local modes = {"Toggle", "Hold", "Always On"}
    for i, mode in ipairs(modes) do
        local modeBtn = Instance.new("TextButton")
        modeBtn.Size = UDim2.new(1, -4, 0, 28)
        modeBtn.Position = UDim2.new(0, 2, 0, (i-1) * 30 + 2)
        modeBtn.BackgroundColor3 = Settings.Keybinds[keybindName].Mode == mode and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35)
        modeBtn.Text = mode
        modeBtn.TextColor3 = Settings.Keybinds[keybindName].Mode == mode and Settings.MenuColor or Color3.fromRGB(200, 200, 200)
        modeBtn.TextSize = 11
        modeBtn.Font = Enum.Font.Gotham
        modeBtn.BorderSizePixel = 0
        modeBtn.ZIndex = 101
        modeBtn.Parent = modeDropdown
        
        local modeBtnCorner = Instance.new("UICorner")
        modeBtnCorner.CornerRadius = UDim.new(0, 3)
        modeBtnCorner.Parent = modeBtn
        
        modeBtn.MouseButton1Click:Connect(function()
            Settings.Keybinds[keybindName].Mode = mode
            modeDropdown.Visible = false
            
            -- Update Active state based on new mode
            if keybindName == "ESP" and Settings.ESP then
                if mode == "Always On" then
                    Settings.ESPActive = true
                elseif mode == "Toggle" then
                    Settings.ESPActive = true
                else -- Hold mode
                    Settings.ESPActive = false
                end
            elseif keybindName == "Aimbot" and Settings.Aimbot then
                if mode == "Always On" then
                    Settings.AimbotActive = true
                elseif mode == "Toggle" then
                    Settings.AimbotActive = true
                else -- Hold mode
                    Settings.AimbotActive = false
                end
            elseif keybindName == "InfiniteJump" and Settings.InfiniteJump then
                if mode == "Always On" then
                    Settings.InfiniteJumpActive = true
                elseif mode == "Toggle" then
                    Settings.InfiniteJumpActive = true
                else -- Hold mode
                    Settings.InfiniteJumpActive = false
                end
            end
            
            -- Update all mode buttons
            for _, child in ipairs(modeDropdown:GetChildren()) do
                if child:IsA("TextButton") then
                    if child.Text == mode then
                        child.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        child.TextColor3 = Settings.MenuColor
                    else
                        child.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                        child.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
            end
            
            ShowNotification(text .. " mode: " .. mode, 1.5)
        end)
        
        modeBtn.MouseEnter:Connect(function()
            if Settings.Keybinds[keybindName].Mode ~= mode then
                Tween(modeBtn, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end
        end)
        
        modeBtn.MouseLeave:Connect(function()
            if Settings.Keybinds[keybindName].Mode ~= mode then
                Tween(modeBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end
        end)
    end
    
    -- Checkbox
    local checkbox = Instance.new("Frame")
    checkbox.Size = UDim2.new(0, 16, 0, 16)
    checkbox.Position = UDim2.new(1, -26, 0.5, -8)
    checkbox.BackgroundColor3 = default and Settings.MenuColor or Color3.fromRGB(30, 30, 35)
    checkbox.BorderSizePixel = 0
    checkbox.ZIndex = 5
    checkbox.Parent = frame
    if default then table.insert(AccentColorElements.CheckboxBackgrounds, checkbox) end
    
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 2)
    checkCorner.Parent = checkbox
    
    local checkStroke = Instance.new("UIStroke")
    checkStroke.Color = Settings.MenuColor
    checkStroke.Thickness = 1
    checkStroke.Transparency = 0.5
    checkStroke.Parent = checkbox
    table.insert(AccentColorElements.CheckboxStrokes, checkStroke)
    
    -- Checkbox click area
    local checkboxBtn = Instance.new("TextButton")
    checkboxBtn.Size = UDim2.new(0, 20, 0, 20)
    checkboxBtn.Position = UDim2.new(1, -30, 0.5, -10)
    checkboxBtn.BackgroundTransparency = 1
    checkboxBtn.Text = ""
    checkboxBtn.ZIndex = 11
    checkboxBtn.Parent = frame
    
    local enabled = default
    
    checkboxBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Tween(checkbox, {BackgroundColor3 = Settings.MenuColor}, 0.3)
            table.insert(AccentColorElements.CheckboxBackgrounds, checkbox)
        else
            Tween(checkbox, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.3)
            for i, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                if cb == checkbox then
                    table.remove(AccentColorElements.CheckboxBackgrounds, i)
                    break
                end
            end
        end
        callback(enabled)
    end)
    
    -- Keybind binding
    local binding = false
    
    keybindBtn.MouseButton1Click:Connect(function()
        if binding then return end
        binding = true
        keybindBtn.Text = "[...]"
        keybindBtn.BackgroundColor3 = Settings.MenuColor
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    -- Remove keybind on ESC
                    Settings.Keybinds[keybindName].Enabled = false
                    keybindBtn.Text = "[NONE]"
                    keybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                    binding = false
                    connection:Disconnect()
                    
                    -- Set function to always active when no keybind
                    if keybindName == "ESP" then
                        Settings.ESPActive = Settings.ESP
                    elseif keybindName == "Aimbot" then
                        Settings.AimbotActive = Settings.Aimbot
                    elseif keybindName == "InfiniteJump" then
                        Settings.InfiniteJumpActive = Settings.InfiniteJump
                    end
                else
                    Settings.Keybinds[keybindName].Enabled = true
                    Settings.Keybinds[keybindName].Key = input.KeyCode
                    keybindBtn.Text = "[" .. input.KeyCode.Name .. "]"
                    keybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                    binding = false
                    connection:Disconnect()
                    
                    -- Deactivate function when rebinding
                    if keybindName == "ESP" then
                        Settings.ESPActive = false
                    elseif keybindName == "Aimbot" then
                        Settings.AimbotActive = false
                    elseif keybindName == "InfiniteJump" then
                        Settings.InfiniteJumpActive = false
                    end
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                Settings.Keybinds[keybindName].Enabled = true
                Settings.Keybinds[keybindName].Key = input.UserInputType
                keybindBtn.Text = input.UserInputType == Enum.UserInputType.MouseButton1 and "[M1]" or "[M2]"
                keybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                binding = false
                connection:Disconnect()
                
                -- Deactivate function when rebinding
                if keybindName == "ESP" then
                    Settings.ESPActive = false
                elseif keybindName == "Aimbot" then
                    Settings.AimbotActive = false
                elseif keybindName == "InfiniteJump" then
                    Settings.InfiniteJumpActive = false
                end
                connection:Disconnect()
            end
        end)
    end)
    
    -- Right click for mode dropdown
    keybindBtn.MouseButton2Click:Connect(function()
        modeDropdown.Visible = not modeDropdown.Visible
    end)
    
    return {
        Frame = frame,
        SetValue = function(value)
            enabled = value
            if value then
                Tween(checkbox, {BackgroundColor3 = Settings.MenuColor}, 0.3)
                -- Add to accent color elements if not already there
                local found = false
                for _, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                    if cb == checkbox then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(AccentColorElements.CheckboxBackgrounds, checkbox)
                end
            else
                Tween(checkbox, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.3)
                -- Remove from accent color elements
                for i, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                    if cb == checkbox then
                        table.remove(AccentColorElements.CheckboxBackgrounds, i)
                        break
                    end
                end
            end
        end,
        UpdateKeybind = function()
            local keyText
            if typeof(Settings.Keybinds[keybindName].Key) == "EnumItem" then
                if Settings.Keybinds[keybindName].Key == Enum.UserInputType.MouseButton1 then
                    keyText = "[M1]"
                elseif Settings.Keybinds[keybindName].Key == Enum.UserInputType.MouseButton2 then
                    keyText = "[M2]"
                else
                    keyText = "[" .. Settings.Keybinds[keybindName].Key.Name .. "]"
                end
            else
                keyText = "[?]"
            end
            keybindBtn.Text = keyText
        end
    }
end

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 18)
    valueLabel.Position = UDim2.new(1, -55, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(1, -20, 0, 3)
    sliderBG.Position = UDim2.new(0, 10, 1, -12)
    sliderBG.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    sliderBG.BorderSizePixel = 0
    sliderBG.Parent = frame
    
    local sliderBGCorner = Instance.new("UICorner")
    sliderBGCorner.CornerRadius = UDim.new(1, 0)
    sliderBGCorner.Parent = sliderBG
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBG
    table.insert(AccentColorElements.SliderFills, sliderFill)
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    -- Slider handle
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 8, 0, 8)
    handle.Position = UDim2.new((default - min) / (max - min), -4, 0.5, -4)
    handle.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    handle.BorderSizePixel = 0
    handle.Parent = sliderBG
    table.insert(AccentColorElements.SliderHandles, handle)
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    local dragging = false
    local value = default
    
    local function updateSlider(mouseX)
        if not sliderBG or not sliderBG.Parent then return end
        
        local relativeX = mouseX - sliderBG.AbsolutePosition.X
        local pos = math.clamp(relativeX / sliderBG.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        handle.Position = UDim2.new(pos, -4, 0.5, -4)
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
    
    frame.AncestryChanged:Connect(function()
        if not frame.Parent then
            for _, conn in ipairs(connections) do
                conn:Disconnect()
            end
        end
    end)
    
    return {
        Frame = frame,
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            local pos = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            handle.Position = UDim2.new(pos, -4, 0.5, -4)
            valueLabel.Text = tostring(value)
        end
    }
end

local function CreateDropdown(parent, text, options, default, callback, keybindName)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0, 90, 0, 22)
    dropBtn.Position = UDim2.new(1, -100, 0.5, -11)
    dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    dropBtn.Text = default
    dropBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropBtn.TextSize = 11
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.BorderSizePixel = 0
    dropBtn.ZIndex = 2
    dropBtn.Parent = frame
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 3)
    dropCorner.Parent = dropBtn
    
    local dropStroke = Instance.new("UIStroke")
    dropStroke.Color = Color3.fromRGB(255, 20, 147)
    dropStroke.Thickness = 1
    dropStroke.Transparency = 0.7
    dropStroke.Parent = dropBtn
    table.insert(AccentColorElements.DropdownStrokes, dropStroke)
    
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
    
    -- Right click - open keybind menu for hitbox options (only if keybindName provided)
    if keybindName then
        -- Initialize keybinds for each hitbox option
        if not Settings.Keybinds[keybindName] then
            Settings.Keybinds[keybindName] = {}
        end
        for _, option in ipairs(options) do
            if not Settings.Keybinds[keybindName][option] then
                Settings.Keybinds[keybindName][option] = {Key = nil, Enabled = false}
            end
        end
        
        -- Add right-click handler to the entire frame
        local rightClickBtn = Instance.new("TextButton")
        rightClickBtn.Size = UDim2.new(1, 0, 1, 0)
        rightClickBtn.BackgroundTransparency = 1
        rightClickBtn.Text = ""
        rightClickBtn.ZIndex = 1
        rightClickBtn.Parent = frame
        
        rightClickBtn.MouseButton2Click:Connect(function()
            -- Close existing menu if open (without waiting)
            if currentKeybindMenu and currentKeybindMenu.Parent then
                local oldMenu = currentKeybindMenu
                Tween(oldMenu, {BackgroundTransparency = 1}, 0.2)
                local menuStroke = oldMenu:FindFirstChildOfClass("UIStroke")
                if menuStroke then
                    Tween(menuStroke, {Transparency = 1}, 0.2)
                end
                
                -- Animate all child elements
                for _, child in ipairs(oldMenu:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Tween(child, {TextTransparency = 1}, 0.2)
                    elseif child:IsA("TextButton") then
                        Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                    end
                end
                
                -- Destroy after animation in background
                task.spawn(function()
                    task.wait(0.2)
                    oldMenu:Destroy()
                end)
                
                currentKeybindMenu = nil
            end
            
            -- Get mouse position relative to ScreenGui
            local mousePos = UserInputService:GetMouseLocation()
            local guiInset = game:GetService("GuiService"):GetGuiInset()
            local screenSize = ScreenGui.AbsoluteSize
            
            -- Adjust for GUI inset (top bar)
            local adjustedMouseX = mousePos.X
            local adjustedMouseY = mousePos.Y - guiInset.Y
            
            -- Calculate menu position at cursor
            local menuWidth = 200
            local menuHeight = 40 + (#options * 32)
            
            -- Position: cursor at top-left corner of menu
            local posX = adjustedMouseX
            local posY = adjustedMouseY
            
            -- Adjust position if menu would go off screen
            if posX + menuWidth > screenSize.X then
                posX = adjustedMouseX - menuWidth
            end
            
            if posY + menuHeight > screenSize.Y then
                posY = adjustedMouseY - menuHeight
            end
            
            local menu = Instance.new("Frame")
            menu.Size = UDim2.new(0, menuWidth, 0, menuHeight)
            menu.Position = UDim2.new(0, posX, 0, posY)
            menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            menu.BorderSizePixel = 0
            menu.ZIndex = 200
            menu.BackgroundTransparency = 1
            menu.Parent = ScreenGui
            
            currentKeybindMenu = menu
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local menuStroke = Instance.new("UIStroke")
            menuStroke.Color = Settings.MenuColor
            menuStroke.Thickness = 2
            menuStroke.Transparency = 1
            menuStroke.Parent = menu
            
            -- Animate menu appearance
            Tween(menu, {BackgroundTransparency = 0}, 0.2)
            Tween(menuStroke, {Transparency = 0}, 0.2)
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -30, 0, 30)
            title.Position = UDim2.new(0, 5, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = "Hitbox Keybinds"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.ZIndex = 201
            title.TextTransparency = 1
            title.Parent = menu
            
            Tween(title, {TextTransparency = 0}, 0.2)
            
            -- Close button (X)
            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 25, 0, 25)
            closeBtn.Position = UDim2.new(1, -28, 0, 2.5)
            closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            closeBtn.Text = "×"
            closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeBtn.TextSize = 18
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.BorderSizePixel = 0
            closeBtn.ZIndex = 202
            closeBtn.BackgroundTransparency = 1
            closeBtn.TextTransparency = 1
            closeBtn.Parent = menu
            
            local closeBtnCorner = Instance.new("UICorner")
            closeBtnCorner.CornerRadius = UDim.new(0, 4)
            closeBtnCorner.Parent = closeBtn
            
            Tween(closeBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
            
            closeBtn.MouseEnter:Connect(function()
                Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
            end)
            
            closeBtn.MouseLeave:Connect(function()
                Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            closeBtn.MouseButton1Click:Connect(function()
                Tween(menu, {BackgroundTransparency = 1}, 0.2)
                Tween(menuStroke, {Transparency = 1}, 0.2)
                
                -- Animate all child elements
                for _, child in ipairs(menu:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Tween(child, {TextTransparency = 1}, 0.2)
                    elseif child:IsA("TextButton") then
                        Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                    end
                end
                
                task.wait(0.2)
                menu:Destroy()
                currentKeybindMenu = nil
            end)
            
            -- Create bind button for each option
            for i, option in ipairs(options) do
                local optionBtn = Instance.new("TextButton")
                optionBtn.Size = UDim2.new(1, -20, 0, 28)
                optionBtn.Position = UDim2.new(0, 10, 0, 35 + (i-1) * 32)
                optionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                optionBtn.Text = option .. ": " .. (Settings.Keybinds[keybindName][option].Enabled and "[" .. (typeof(Settings.Keybinds[keybindName][option].Key) == "EnumItem" and Settings.Keybinds[keybindName][option].Key.Name or "NONE") .. "]" or "[NONE]")
                optionBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optionBtn.TextSize = 11
                optionBtn.Font = Enum.Font.Gotham
                optionBtn.BorderSizePixel = 0
                optionBtn.ZIndex = 201
                optionBtn.BackgroundTransparency = 1
                optionBtn.TextTransparency = 1
                optionBtn.Parent = menu
                
                -- Animate with delay
                task.spawn(function()
                    task.wait(0.05 * i)
                    Tween(optionBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
                end)
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 4)
                optionCorner.Parent = optionBtn
                
                local binding = false
                optionBtn.MouseButton1Click:Connect(function()
                    if binding then return end
                    binding = true
                    optionBtn.Text = option .. ": [Press key...]"
                    optionBtn.BackgroundColor3 = Settings.MenuColor
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                Settings.Keybinds[keybindName][option].Enabled = false
                                optionBtn.Text = option .. ": [NONE]"
                            else
                                Settings.Keybinds[keybindName][option].Enabled = true
                                Settings.Keybinds[keybindName][option].Key = input.KeyCode
                                optionBtn.Text = option .. ": [" .. input.KeyCode.Name .. "]"
                            end
                            optionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                            binding = false
                            connection:Disconnect()
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                            Settings.Keybinds[keybindName][option].Enabled = true
                            Settings.Keybinds[keybindName][option].Key = input.UserInputType
                            optionBtn.Text = option .. ": " .. (input.UserInputType == Enum.UserInputType.MouseButton1 and "[M1]" or "[M2]")
                            optionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                            binding = false
                            connection:Disconnect()
                        end
                    end)
                end)
            end
        end)
    end
    
    return frame
end

local function CreateToggleWithColor(parent, text, default, defaultColor, callback, colorCallback, keybindName)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    -- Color button
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 24, 0, 20)
    colorBtn.Position = UDim2.new(1, -60, 0.5, -10)
    colorBtn.BackgroundColor3 = defaultColor
    colorBtn.Text = ""
    colorBtn.BorderSizePixel = 0
    colorBtn.Parent = frame
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 3)
    colorCorner.Parent = colorBtn
    
    local colorStroke = Instance.new("UIStroke")
    colorStroke.Color = Settings.MenuColor
    colorStroke.Thickness = 1
    colorStroke.Transparency = 0.5
    colorStroke.Parent = colorBtn
    table.insert(AccentColorElements.ColorButtonStrokes, colorStroke)
    
    -- Square checkbox
    local checkbox = Instance.new("Frame")
    checkbox.Size = UDim2.new(0, 16, 0, 16)
    checkbox.Position = UDim2.new(1, -26, 0.5, -8)
    checkbox.BackgroundColor3 = default and Settings.MenuColor or Color3.fromRGB(30, 30, 35)
    checkbox.BorderSizePixel = 0
    checkbox.Parent = frame
    if default then table.insert(AccentColorElements.CheckboxBackgrounds, checkbox) end
    
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 2)
    checkCorner.Parent = checkbox
    
    local checkStroke = Instance.new("UIStroke")
    checkStroke.Color = Settings.MenuColor
    checkStroke.Thickness = 1
    checkStroke.Transparency = 0.5
    checkStroke.Parent = checkbox
    table.insert(AccentColorElements.CheckboxStrokes, checkStroke)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 1, 0)
    btn.Position = UDim2.new(1, -30, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 2
    btn.Parent = frame
    
    local enabled = default
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Tween(checkbox, {BackgroundColor3 = Settings.MenuColor}, 0.3)
            table.insert(AccentColorElements.CheckboxBackgrounds, checkbox)
        else
            Tween(checkbox, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.3)
            for i, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                if cb == checkbox then
                    table.remove(AccentColorElements.CheckboxBackgrounds, i)
                    break
                end
            end
        end
        callback(enabled)
    end)
    
    -- Right click - open keybind menu (only if keybindName provided)
    if keybindName then
        if not Settings.Keybinds[keybindName] then
            Settings.Keybinds[keybindName] = {Key = Enum.KeyCode.E, Mode = "Toggle", Enabled = false}
        end
        
        btn.MouseButton2Click:Connect(function()
            -- Close existing menu if open (without waiting)
            if currentKeybindMenu and currentKeybindMenu.Parent then
                local oldMenu = currentKeybindMenu
                Tween(oldMenu, {BackgroundTransparency = 1}, 0.2)
                local menuStroke = oldMenu:FindFirstChildOfClass("UIStroke")
                if menuStroke then
                    Tween(menuStroke, {Transparency = 1}, 0.2)
                end
                
                -- Animate all child elements
                for _, child in ipairs(oldMenu:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Tween(child, {TextTransparency = 1}, 0.2)
                    elseif child:IsA("TextButton") then
                        Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                    end
                end
                
                -- Destroy after animation in background
                task.spawn(function()
                    task.wait(0.2)
                    oldMenu:Destroy()
                end)
                
                currentKeybindMenu = nil
            end
            
            -- Get mouse position relative to ScreenGui
            local mousePos = UserInputService:GetMouseLocation()
            local guiInset = game:GetService("GuiService"):GetGuiInset()
            local screenSize = ScreenGui.AbsoluteSize
            
            -- Adjust for GUI inset (top bar)
            local adjustedMouseX = mousePos.X
            local adjustedMouseY = mousePos.Y - guiInset.Y
            
            -- Calculate menu position at cursor (no offset)
            local menuWidth = 200
            local menuHeight = 165
            
            -- Position: cursor at top-left corner of menu
            local posX = adjustedMouseX
            local posY = adjustedMouseY
            
            -- Adjust position if menu would go off screen
            if posX + menuWidth > screenSize.X then
                posX = adjustedMouseX - menuWidth
            end
            
            if posY + menuHeight > screenSize.Y then
                posY = adjustedMouseY - menuHeight
            end
            
            local menu = Instance.new("Frame")
            menu.Size = UDim2.new(0, menuWidth, 0, menuHeight)
            menu.Position = UDim2.new(0, posX, 0, posY)
            menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            menu.BorderSizePixel = 0
            menu.ZIndex = 200
            menu.BackgroundTransparency = 1
            menu.Parent = ScreenGui
            
            currentKeybindMenu = menu
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local menuStroke = Instance.new("UIStroke")
            menuStroke.Color = Settings.MenuColor
            menuStroke.Thickness = 2
            menuStroke.Transparency = 1
            menuStroke.Parent = menu
            
            -- Animate menu appearance
            Tween(menu, {BackgroundTransparency = 0}, 0.2)
            Tween(menuStroke, {Transparency = 0}, 0.2)
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -30, 0, 30)
            title.Position = UDim2.new(0, 5, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = "Keybind: " .. text
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.ZIndex = 201
            title.TextTransparency = 1
            title.Parent = menu
            
            Tween(title, {TextTransparency = 0}, 0.2)
            
            -- Close button (X)
            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 25, 0, 25)
            closeBtn.Position = UDim2.new(1, -28, 0, 2.5)
            closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            closeBtn.Text = "×"
            closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeBtn.TextSize = 18
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.BorderSizePixel = 0
            closeBtn.ZIndex = 202
            closeBtn.BackgroundTransparency = 1
            closeBtn.TextTransparency = 1
            closeBtn.Parent = menu
            
            local closeBtnCorner = Instance.new("UICorner")
            closeBtnCorner.CornerRadius = UDim.new(0, 4)
            closeBtnCorner.Parent = closeBtn
            
            Tween(closeBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
            
            closeBtn.MouseEnter:Connect(function()
                Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
            end)
            
            closeBtn.MouseLeave:Connect(function()
                Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            closeBtn.MouseButton1Click:Connect(function()
                Tween(menu, {BackgroundTransparency = 1}, 0.2)
                Tween(menuStroke, {Transparency = 1}, 0.2)
                
                -- Animate all child elements
                for _, child in ipairs(menu:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Tween(child, {TextTransparency = 1}, 0.2)
                    elseif child:IsA("TextButton") then
                        Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                    end
                end
                
                task.wait(0.2)
                menu:Destroy()
                currentKeybindMenu = nil
            end)
            
            local bindBtn = Instance.new("TextButton")
            bindBtn.Size = UDim2.new(1, -20, 0, 30)
            bindBtn.Position = UDim2.new(0, 10, 0, 40)
            bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            bindBtn.Text = Settings.Keybinds[keybindName].Enabled and "[" .. (typeof(Settings.Keybinds[keybindName].Key) == "EnumItem" and Settings.Keybinds[keybindName].Key.Name or "NONE") .. "]" or "[NONE]"
            bindBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            bindBtn.TextSize = 12
            bindBtn.Font = Enum.Font.Gotham
            bindBtn.BorderSizePixel = 0
            bindBtn.ZIndex = 201
            bindBtn.BackgroundTransparency = 1
            bindBtn.TextTransparency = 1
            bindBtn.Parent = menu
            
            Tween(bindBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
            
            local bindCorner = Instance.new("UICorner")
            bindCorner.CornerRadius = UDim.new(0, 4)
            bindCorner.Parent = bindBtn
            
            local binding = false
            bindBtn.MouseButton1Click:Connect(function()
                if binding then return end
                binding = true
                bindBtn.Text = "[Press key...]"
                bindBtn.BackgroundColor3 = Settings.MenuColor
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            Settings.Keybinds[keybindName].Enabled = false
                            bindBtn.Text = "[NONE]"
                        else
                            Settings.Keybinds[keybindName].Enabled = true
                            Settings.Keybinds[keybindName].Key = input.KeyCode
                            bindBtn.Text = "[" .. input.KeyCode.Name .. "]"
                        end
                        bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                        binding = false
                        connection:Disconnect()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        Settings.Keybinds[keybindName].Enabled = true
                        Settings.Keybinds[keybindName].Key = input.UserInputType
                        bindBtn.Text = input.UserInputType == Enum.UserInputType.MouseButton1 and "[M1]" or "[M2]"
                        bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                        binding = false
                        connection:Disconnect()
                    end
                end)
            end)
            
            local modes = {"Toggle", "Hold", "Always On"}
            for i, mode in ipairs(modes) do
                local modeBtn = Instance.new("TextButton")
                modeBtn.Size = UDim2.new(1, -20, 0, 25)
                modeBtn.Position = UDim2.new(0, 10, 0, 75 + (i-1) * 27)
                modeBtn.BackgroundColor3 = Settings.Keybinds[keybindName].Mode == mode and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35)
                modeBtn.Text = mode
                modeBtn.TextColor3 = Settings.Keybinds[keybindName].Mode == mode and Settings.MenuColor or Color3.fromRGB(200, 200, 200)
                modeBtn.TextSize = 11
                modeBtn.Font = Enum.Font.Gotham
                modeBtn.BorderSizePixel = 0
                modeBtn.ZIndex = 201
                modeBtn.BackgroundTransparency = 1
                modeBtn.TextTransparency = 1
                modeBtn.Parent = menu
                
                -- Animate with delay
                task.spawn(function()
                    task.wait(0.05 * i)
                    Tween(modeBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
                end)
                
                local modeBtnCorner = Instance.new("UICorner")
                modeBtnCorner.CornerRadius = UDim.new(0, 3)
                modeBtnCorner.Parent = modeBtn
                
                modeBtn.MouseButton1Click:Connect(function()
                    Settings.Keybinds[keybindName].Mode = mode
                    
                    -- Update all mode buttons colors
                    for _, child in ipairs(menu:GetChildren()) do
                        if child:IsA("TextButton") and child ~= bindBtn and child ~= closeBtn then
                            if child.Text == mode then
                                Tween(child, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
                                child.TextColor3 = Settings.MenuColor
                            else
                                Tween(child, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
                                child.TextColor3 = Color3.fromRGB(200, 200, 200)
                            end
                        end
                    end
                    
                    ShowNotification(text .. " mode: " .. mode, 1.5)
                end)
            end
        end)
    end
    
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
        picker.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
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
    
    -- Return object with SetValue and SetColor methods
    return {
        Frame = frame,
        SetValue = function(value)
            enabled = value
            if value then
                checkbox.BackgroundColor3 = Settings.MenuColor
                -- Add to accent color elements if not already there
                local found = false
                for _, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                    if cb == checkbox then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(AccentColorElements.CheckboxBackgrounds, checkbox)
                end
            else
                checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                -- Remove from accent color elements
                for i, cb in ipairs(AccentColorElements.CheckboxBackgrounds) do
                    if cb == checkbox then
                        table.remove(AccentColorElements.CheckboxBackgrounds, i)
                        break
                    end
                end
            end
        end,
        SetColor = function(color)
            colorBtn.BackgroundColor3 = color
            -- Update internal HSV values from the color
            local h, s, v = color:ToHSV()
            currentHue = h
            currentSat = s
            currentVal = v
        end
    }
end

-- Create Tabs
local CombatTab = CreateTab("Combat")
local VisualsTab = CreateTab("Visuals")
local LocalTab = CreateTab("Local")
local MiscTab = CreateTab("Misc")
local UITab = CreateTab("UI")
local ConfigTab = CreateTab("Config")

-- Recalculate tab positions after all tabs are created
RecalculateTabPositions()

-- Combat Tab (Aimbot functions)
UIElements.Aimbot = CreateToggle(CombatTab.Content, "Aimbot", false, function(enabled)
    Settings.Aimbot = enabled
    
    -- Mutual exclusion: disable AimLock when Aimbot is enabled
    if enabled and Settings.AimLock then
        Settings.AimLock = false
        Settings.AimLockActive = false
        if UIElements.AimLock then
            UIElements.AimLock.SetValue(false)
        end
    end
    
    -- Sync Active state based on keybind status and mode
    if enabled then
        if not Settings.Keybinds.Aimbot.Enabled then
            -- No keybind: function works as simple on/off
            Settings.AimbotActive = true
        elseif Settings.Keybinds.Aimbot.Mode == "Always On" then
            Settings.AimbotActive = true
        elseif Settings.Keybinds.Aimbot.Mode == "Toggle" then
            Settings.AimbotActive = true -- Default to active when enabled
        else -- Hold mode
            Settings.AimbotActive = false -- Wait for key press
        end
    else
        Settings.AimbotActive = false
    end
end, "Aimbot")

UIElements.AimbotSmooth = CreateSlider(CombatTab.Content, "Smoothness", 1, 10, 1, function(value)
    Settings.AimbotSmooth = value
end)

UIElements.AimLock = CreateToggle(CombatTab.Content, "AimLock", false, function(enabled)
    Settings.AimLock = enabled
    
    -- Mutual exclusion: disable Aimbot when AimLock is enabled
    if enabled and Settings.Aimbot then
        Settings.Aimbot = false
        Settings.AimbotActive = false
        if UIElements.Aimbot then
            UIElements.Aimbot.SetValue(false)
        end
    end
    
    -- Sync Active state based on keybind status and mode
    if enabled then
        if not Settings.Keybinds.AimLock.Enabled then
            -- No keybind: function works as simple on/off
            Settings.AimLockActive = true
        elseif Settings.Keybinds.AimLock.Mode == "Always On" then
            Settings.AimLockActive = true
        elseif Settings.Keybinds.AimLock.Mode == "Toggle" then
            Settings.AimLockActive = true -- Default to active when enabled
        else -- Hold mode
            Settings.AimLockActive = false -- Wait for key press
        end
    else
        Settings.AimLockActive = false
    end
end, "AimLock")

CreateDropdown(CombatTab.Content, "Hitbox", {"Auto", "Head", "Torso"}, "Head", function(value)
    Settings.AimbotHitbox = value
end, "Hitbox")

UIElements.ShowFOV = CreateToggleWithColor(CombatTab.Content, "Show FOV", false, Color3.fromRGB(255, 255, 255), function(enabled)
    Settings.ShowFOV = enabled
end, function(color)
    Settings.FOVColor = color
end)

UIElements.AimbotFOV = CreateSlider(CombatTab.Content, "FOV Size", 50, 500, 100, function(value)
    Settings.AimbotFOV = value
end)

UIElements.AimbotMaxDistance = CreateSlider(CombatTab.Content, "Max Distance", 100, 1000, 500, function(value)
    Settings.AimbotMaxDistance = value
end)

UIElements.Prediction = CreateToggle(CombatTab.Content, "Prediction", false, function(enabled)
    Settings.Prediction = enabled
    -- Sync Active state based on keybind status and mode
    if enabled then
        if not Settings.Keybinds.Prediction.Enabled then
            -- No keybind: function works as simple on/off
            Settings.PredictionActive = true
        elseif Settings.Keybinds.Prediction.Mode == "Always On" then
            Settings.PredictionActive = true
        elseif Settings.Keybinds.Prediction.Mode == "Toggle" then
            Settings.PredictionActive = true -- Default to active when enabled
        else -- Hold mode
            Settings.PredictionActive = false -- Wait for key press
        end
    else
        Settings.PredictionActive = false
    end
end, "Prediction")

UIElements.PredictionStrength = CreateSlider(CombatTab.Content, "Prediction Strength", 1, 20, 10, function(value)
    Settings.PredictionStrength = value
end)

UIElements.NoRecoil = CreateToggle(CombatTab.Content, "No Recoil", false, function(enabled)
    Settings.NoRecoil = enabled
    -- Sync Active state based on keybind status and mode
    if enabled then
        if not Settings.Keybinds.NoRecoil.Enabled then
            -- No keybind: function works as simple on/off
            Settings.NoRecoilActive = true
        elseif Settings.Keybinds.NoRecoil.Mode == "Always On" then
            Settings.NoRecoilActive = true
        elseif Settings.Keybinds.NoRecoil.Mode == "Toggle" then
            Settings.NoRecoilActive = true -- Default to active when enabled
        else -- Hold mode
            Settings.NoRecoilActive = false -- Wait for key press
        end
    else
        Settings.NoRecoilActive = false
    end
end, "NoRecoil")

UIElements.RecoilStrength = CreateSlider(CombatTab.Content, "Recoil Strength", 1, 100, 50, function(value)
    Settings.RecoilStrength = value
end)

-- Visuals Tab (ESP functions)
UIElements.BoxESP = CreateToggle(VisualsTab.Content, "Box ESP", true, function(enabled)
    Settings.ESP = enabled
    -- Sync Active state based on keybind status and mode
    if enabled then
        if not Settings.Keybinds.ESP.Enabled then
            -- No keybind: function works as simple on/off
            Settings.ESPActive = true
        elseif Settings.Keybinds.ESP.Mode == "Always On" then
            Settings.ESPActive = true
        elseif Settings.Keybinds.ESP.Mode == "Toggle" then
            Settings.ESPActive = true -- Default to active when enabled
        else -- Hold mode
            Settings.ESPActive = false -- Wait for key press
        end
    else
        Settings.ESPActive = false
    end
end, "ESP")

UIElements.HealthBar = CreateToggle(VisualsTab.Content, "Health Bar", false, function(enabled)
    Settings.HealthBar = enabled
end, "HealthBar")

UIElements.Name = CreateToggleWithColor(VisualsTab.Content, "Name", false, Color3.fromRGB(255, 255, 255), function(enabled)
    Settings.Name = enabled
end, function(color)
    Settings.NameColor = color
end)

UIElements.Distance = CreateToggleWithColor(VisualsTab.Content, "Distance", false, Color3.fromRGB(255, 255, 255), function(enabled)
    Settings.Distance = enabled
end, function(color)
    Settings.DistanceColor = color
end)

UIElements.TeamCheck = CreateToggle(VisualsTab.Content, "Team Check", false, function(enabled)
    Settings.TeamCheck = enabled
end, "TeamCheck")

UIElements.FilledBox = CreateToggle(VisualsTab.Content, "Filled Box", false, function(enabled)
    Settings.FilledBox = enabled
    for _, box in pairs(ESPBoxes) do
        if box then
            box.Filled = enabled
        end
    end
end, "FilledBox")

UIElements.BoxCorner = CreateToggle(VisualsTab.Content, "Box Corner", false, function(enabled)
    Settings.BoxCorner = enabled
end, "BoxCorner")

UIElements.Skeleton = CreateToggleWithColor(VisualsTab.Content, "Skeleton", false, Color3.fromRGB(255, 255, 255), function(enabled)
    Settings.Skeleton = enabled
end, function(color)
    Settings.SkeletonColor = color
end)

UIElements.ESPMaxDistance = CreateSlider(VisualsTab.Content, "Max Distance", 100, 5000, 2000, function(value)
    Settings.ESPMaxDistance = value
end)

UIElements.Fullbright = CreateToggle(VisualsTab.Content, "Fullbright", false, function(enabled)
    Settings.Fullbright = enabled
    local lighting = game:GetService("Lighting")
    lighting.Brightness = enabled and 2 or 1
    lighting.ClockTime = 14
    lighting.FogEnd = 100000
end, "Fullbright")

-- Local Tab (Local ESP functions)
UIElements.LocalSkeleton = CreateToggleWithColor(LocalTab.Content, "Local Skeleton", false, Color3.fromRGB(0, 255, 0), function(enabled)
    Settings.LocalSkeleton = enabled
end, function(color)
    Settings.LocalSkeletonColor = color
end, "LocalSkeleton")

UIElements.LocalHighlight = CreateToggleWithColor(LocalTab.Content, "Local Highlight", false, Color3.fromRGB(255, 255, 0), function(enabled)
    Settings.LocalHighlight = enabled
end, function(color)
    Settings.LocalHighlightColor = color
end, "LocalHighlight")

-- Misc Tab
-- Menu Color
local menuColorFrame = Instance.new("Frame")
menuColorFrame.Size = UDim2.new(1, 0, 0, 30)
menuColorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
menuColorFrame.BorderSizePixel = 0
menuColorFrame.Parent = MiscTab.Content

local menuColorCorner = Instance.new("UICorner")
menuColorCorner.CornerRadius = UDim.new(0, 4)
menuColorCorner.Parent = menuColorFrame

local menuColorLabel = Instance.new("TextLabel")
menuColorLabel.Size = UDim2.new(1, -40, 1, 0)
menuColorLabel.Position = UDim2.new(0, 10, 0, 0)
menuColorLabel.BackgroundTransparency = 1
menuColorLabel.Text = "Menu Color"
menuColorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
menuColorLabel.TextSize = 12
menuColorLabel.Font = Enum.Font.Gotham
menuColorLabel.TextXAlignment = Enum.TextXAlignment.Left
menuColorLabel.Parent = menuColorFrame

local menuColorBtn = Instance.new("TextButton")
menuColorBtn.Size = UDim2.new(0, 24, 0, 20)
menuColorBtn.Position = UDim2.new(1, -30, 0.5, -10)
menuColorBtn.BackgroundColor3 = Settings.MenuColor
menuColorBtn.Text = ""
menuColorBtn.BorderSizePixel = 0
menuColorBtn.Parent = menuColorFrame

local menuColorBtnCorner = Instance.new("UICorner")
menuColorBtnCorner.CornerRadius = UDim.new(0, 3)
menuColorBtnCorner.Parent = menuColorBtn

local menuColorStroke = Instance.new("UIStroke")
menuColorStroke.Color = Color3.fromRGB(255, 20, 147)
menuColorStroke.Thickness = 1
menuColorStroke.Transparency = 0.5
menuColorStroke.Parent = menuColorBtn

-- Color picker for menu color (same as CreateToggleWithColor)
local menuColorPickerOpen = false
local currentHue = 0
local currentSat = 1
local currentVal = 1

menuColorBtn.MouseButton1Click:Connect(function()
    if menuColorPickerOpen then return end
    menuColorPickerOpen = true
    
    local picker = Instance.new("Frame")
    picker.Size = UDim2.new(0, 250, 0, 280)
    picker.Position = UDim2.new(0.5, -125, 0.5, -140)
    picker.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
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
    title.Text = "Menu Color Picker"
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
            currentVal = 1 - math.clamp(relY, 0, 1)
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
        menuColorBtn.BackgroundColor3 = finalColor
        UpdateAccentColor(finalColor)
        picker:Destroy()
        menuColorPickerOpen = false
    end)
end)

-- Menu Bind Button
local menuBindButton = Instance.new("TextButton")
menuBindButton.Size = UDim2.new(1, -10, 0, 30)
menuBindButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
menuBindButton.Text = "Menu Bind: " .. Settings.MenuBind.Name
menuBindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
menuBindButton.TextSize = 12
menuBindButton.Font = Enum.Font.Gotham
menuBindButton.Parent = MiscTab.Content

local menuBindCorner = Instance.new("UICorner")
menuBindCorner.CornerRadius = UDim.new(0, 4)
menuBindCorner.Parent = menuBindButton

local bindingKey = false
menuBindButton.MouseButton1Click:Connect(function()
    if bindingKey then return end
    bindingKey = true
    menuBindButton.Text = "Press any key..."
    menuBindButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Settings.MenuBind = input.KeyCode
            menuBindButton.Text = "Menu Bind: " .. input.KeyCode.Name
            menuBindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            bindingKey = false
            connection:Disconnect()
        end
    end)
end)

UIElements.InfiniteJump = CreateToggle(MiscTab.Content, "Infinite Jump", false, function(enabled)
    Settings.InfiniteJump = enabled
    -- Sync Active state based on keybind status and mode
    if enabled then
        if not Settings.Keybinds.InfiniteJump.Enabled then
            -- No keybind: function works as simple on/off
            Settings.InfiniteJumpActive = true
        elseif Settings.Keybinds.InfiniteJump.Mode == "Always On" then
            Settings.InfiniteJumpActive = true
        elseif Settings.Keybinds.InfiniteJump.Mode == "Toggle" then
            Settings.InfiniteJumpActive = true -- Default to active when enabled
        else -- Hold mode
            Settings.InfiniteJumpActive = false -- Wait for key press
        end
    else
        Settings.InfiniteJumpActive = false
    end
end, "InfiniteJump")

UIElements.DebugPanel = CreateToggle(MiscTab.Content, "Debug Panel", false, function(enabled)
    Settings.DebugPanel = enabled
end, "DebugPanel")

-- UI Tab
-- Keylist Frame
local KeylistFrame = Instance.new("Frame")
KeylistFrame.Size = UDim2.new(0, 200, 0, 0)
KeylistFrame.Position = UDim2.new(1, -210, 0, 50)
KeylistFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KeylistFrame.BorderSizePixel = 0
KeylistFrame.Visible = false
KeylistFrame.Parent = ScreenGui

local KeylistCorner = Instance.new("UICorner")
KeylistCorner.CornerRadius = UDim.new(0, 8)
KeylistCorner.Parent = KeylistFrame

local KeylistTitle = Instance.new("TextLabel")
KeylistTitle.Size = UDim2.new(1, 0, 0, 30)
KeylistTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeylistTitle.Text = "Keybinds"
KeylistTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeylistTitle.TextSize = 14
KeylistTitle.Font = Enum.Font.GothamBold
KeylistTitle.BorderSizePixel = 0
KeylistTitle.Parent = KeylistFrame

-- Add gradient to title
local KeylistTitleGradient = Instance.new("UIGradient")
KeylistTitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Settings.MenuColor),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Settings.MenuColor),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Settings.MenuColor)
})
KeylistTitleGradient.Parent = KeylistTitle
AccentColorElements.KeylistGradient = KeylistTitleGradient

-- Add glow effect using shadow image
local KeylistGlow = Instance.new("ImageLabel")
KeylistGlow.Size = UDim2.new(1, 20, 1, 20)
KeylistGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
KeylistGlow.AnchorPoint = Vector2.new(0.5, 0.5)
KeylistGlow.BackgroundTransparency = 1
KeylistGlow.Image = "rbxassetid://5554236805" -- Glow/shadow image
KeylistGlow.ImageColor3 = Settings.MenuColor
KeylistGlow.ImageTransparency = 0.5
KeylistGlow.ScaleType = Enum.ScaleType.Slice
KeylistGlow.SliceCenter = Rect.new(23, 23, 277, 277)
KeylistGlow.ZIndex = 0
KeylistGlow.Parent = KeylistTitle
AccentColorElements.KeylistGlow = KeylistGlow

KeylistTitle.ZIndex = 1

local KeylistTitleCorner = Instance.new("UICorner")
KeylistTitleCorner.CornerRadius = UDim.new(0, 8)
KeylistTitleCorner.Parent = KeylistTitle

-- Animate gradient
task.spawn(function()
    local offset = -2
    while true do
        offset = offset + 0.01
        if offset > 2 then offset = -2 end
        if KeylistTitleGradient and KeylistTitleGradient.Parent then
            KeylistTitleGradient.Offset = Vector2.new(offset, 0)
        end
        task.wait(0.05) -- Increased from 0.03 to 0.05 for better performance
    end
end)

-- Make Keylist draggable
local draggingKeylist = false
local dragInputKeylist = nil
local dragStartKeylist = nil
local startPosKeylist = nil

KeylistTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingKeylist = true
        dragStartKeylist = input.Position
        startPosKeylist = KeylistFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingKeylist = false
            end
        end)
    end
end)

KeylistTitle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInputKeylist = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputKeylist and draggingKeylist then
        local delta = input.Position - dragStartKeylist
        KeylistFrame.Position = UDim2.new(
            startPosKeylist.X.Scale,
            startPosKeylist.X.Offset + delta.X,
            startPosKeylist.Y.Scale,
            startPosKeylist.Y.Offset + delta.Y
        )
    end
end)

local KeylistContainer = Instance.new("Frame")
KeylistContainer.Size = UDim2.new(1, -10, 1, -40)
KeylistContainer.Position = UDim2.new(0, 5, 0, 35)
KeylistContainer.BackgroundTransparency = 1
KeylistContainer.Parent = KeylistFrame

local KeylistLayout = Instance.new("UIListLayout")
KeylistLayout.Padding = UDim.new(0, 5)
KeylistLayout.SortOrder = Enum.SortOrder.LayoutOrder
KeylistLayout.Parent = KeylistContainer

-- Keylist items storage
local KeylistItems = {}
local lastKeylistState = {} -- Track last state to avoid recreating

local function UpdateKeylist()
    local activeCount = 0
    local currentState = {}
    
    -- Check each keybind and build current state
    for name, bind in pairs(Settings.Keybinds) do
        -- Skip Hitbox (it's a nested structure)
        if name == "Hitbox" then
            -- Show active hitbox binds
            for hitboxName, hitboxBind in pairs(bind) do
                if hitboxBind.Enabled and Settings.Aimbot then
                    local keyText = ""
                    if typeof(hitboxBind.Key) == "EnumItem" then
                        if hitboxBind.Key == Enum.UserInputType.MouseButton1 then
                            keyText = "[M1]"
                        elseif hitboxBind.Key == Enum.UserInputType.MouseButton2 then
                            keyText = "[M2]"
                        else
                            keyText = "[" .. hitboxBind.Key.Name .. "]"
                        end
                    end
                    if keyText ~= "" then
                        currentState["Hitbox: " .. hitboxName] = keyText
                        activeCount = activeCount + 1
                    end
                end
            end
        else
            local isEnabled = Settings[name]
            local isActive = false
            
            -- Check if the feature is actually active (not just enabled)
            if name == "ESP" then
                isActive = Settings.ESPActive
            elseif name == "Aimbot" then
                isActive = Settings.AimbotActive
            elseif name == "InfiniteJump" then
                isActive = Settings.InfiniteJumpActive
            else
                -- For other features, show if enabled and keybind is set
                isActive = isEnabled
            end
            
            -- Only show if: feature enabled, keybind enabled, AND currently active
            if isEnabled and bind.Enabled and isActive then
                local keyText = ""
                if typeof(bind.Key) == "EnumItem" then
                    if bind.Key == Enum.UserInputType.MouseButton1 then
                        keyText = "[M1]"
                    elseif bind.Key == Enum.UserInputType.MouseButton2 then
                        keyText = "[M2]"
                    else
                        keyText = "[" .. bind.Key.Name .. "]"
                    end
                end
                if keyText ~= "" then
                    currentState[name] = keyText
                    activeCount = activeCount + 1
                end
            end
        end
    end
    
    -- Compare with last state - only recreate if changed
    local stateChanged = false
    
    -- Count items in both states
    local currentCount = 0
    local lastCount = 0
    for _ in pairs(currentState) do currentCount = currentCount + 1 end
    for _ in pairs(lastKeylistState) do lastCount = lastCount + 1 end
    
    if currentCount ~= lastCount then
        stateChanged = true
    else
        for name, keyText in pairs(currentState) do
            if lastKeylistState[name] ~= keyText then
                stateChanged = true
                break
            end
        end
        -- Also check if any items were removed
        if not stateChanged then
            for name in pairs(lastKeylistState) do
                if currentState[name] == nil then
                    stateChanged = true
                    break
                end
            end
        end
    end
    
    -- Only recreate items if state changed
    if stateChanged then
        -- Determine which items are new (not in lastKeylistState)
        local newItems = {}
        for name in pairs(currentState) do
            if lastKeylistState[name] == nil then
                newItems[name] = true
            end
        end
        
        -- Clear existing items
        for _, item in pairs(KeylistItems) do
            if item then item:Destroy() end
        end
        KeylistItems = {}
        
        local index = 0
        for name, keyText in pairs(currentState) do
            index = index + 1
            
            local isNewItem = newItems[name] == true
            
            local item = Instance.new("Frame")
            item.Size = UDim2.new(1, 0, 0, isNewItem and 0 or 25)
            item.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            item.BorderSizePixel = 0
            item.BackgroundTransparency = 0
            item.ClipsDescendants = true
            item.Parent = KeylistContainer
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(1, 0)
            itemCorner.Parent = item
            
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(1, -10, 0, 25)
            itemLabel.Position = UDim2.new(0, 5, 0, 0)
            itemLabel.BackgroundTransparency = 1
            itemLabel.Text = name
            itemLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            itemLabel.TextSize = 12
            itemLabel.Font = Enum.Font.Gotham
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.TextTransparency = isNewItem and 1 or 0
            itemLabel.Parent = item
            
            -- Background for key text
            local keyBg = Instance.new("Frame")
            keyBg.Size = UDim2.new(0, isNewItem and 0 or 60, 0, 18)
            keyBg.Position = UDim2.new(1, -65, 0.5, -9)
            keyBg.AnchorPoint = Vector2.new(0, 0.5)
            keyBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            keyBg.BorderSizePixel = 0
            keyBg.Parent = item
            
            local keyBgCorner = Instance.new("UICorner")
            keyBgCorner.CornerRadius = UDim.new(0, 4)
            keyBgCorner.Parent = keyBg
            
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Size = UDim2.new(1, 0, 1, 0)
            keyLabel.BackgroundTransparency = 1
            keyLabel.Text = keyText
            keyLabel.TextColor3 = Settings.MenuColor
            keyLabel.TextSize = 11
            keyLabel.Font = Enum.Font.GothamBold
            keyLabel.TextXAlignment = Enum.TextXAlignment.Center
            keyLabel.TextTransparency = isNewItem and 1 or 0
            keyLabel.Parent = keyBg
            
            -- Animate appearance only for new items (without delay)
            if isNewItem then
                Tween(item, {Size = UDim2.new(1, 0, 0, 25)}, 0.2)
                Tween(itemLabel, {TextTransparency = 0}, 0.2)
                Tween(keyBg, {Size = UDim2.new(0, 60, 0, 18)}, 0.2)
                Tween(keyLabel, {TextTransparency = 0}, 0.2)
            end
            
            table.insert(KeylistItems, item)
        end
        
        lastKeylistState = currentState
    end
    
    -- Update frame size with animation and visibility
    local targetHeight = 35 + (activeCount * 30)
    Tween(KeylistFrame, {Size = UDim2.new(0, 200, 0, targetHeight)}, 0.2)
    KeylistFrame.Visible = activeCount > 0 and Settings.ShowKeylist or false
end

-- Add Keylist toggle
Settings.ShowKeylist = false
UIElements.ShowKeylist = CreateToggle(UITab.Content, "Show Keylist", false, function(enabled)
    Settings.ShowKeylist = enabled
    UpdateKeylist()
end, "ShowKeylist")

-- Update keylist periodically (not every frame)
task.spawn(function()
    while true do
        task.wait(0.2) -- Increased from 0.1 to 0.2 for better performance
        UpdateKeylist()
    end
end)

-- Config System
local HttpService = game:GetService("HttpService")

local function SaveConfig(configName)
    if not fileSystemAvailable then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "File system not available!",
            Duration = 3
        })
        return false
    end
    
    -- Ensure folders exist
    EnsureFolders()
    
    local configData = {
        -- ESP Settings
        ESP = Settings.ESP,
        HealthBar = Settings.HealthBar,
        Name = Settings.Name,
        Distance = Settings.Distance,
        TeamCheck = Settings.TeamCheck,
        FilledBox = Settings.FilledBox,
        BoxCorner = Settings.BoxCorner,
        Skeleton = Settings.Skeleton,
        BoxColor = {Settings.BoxColor.R, Settings.BoxColor.G, Settings.BoxColor.B},
        NameColor = {Settings.NameColor.R, Settings.NameColor.G, Settings.NameColor.B},
        DistanceColor = {Settings.DistanceColor.R, Settings.DistanceColor.G, Settings.DistanceColor.B},
        SkeletonColor = {Settings.SkeletonColor.R, Settings.SkeletonColor.G, Settings.SkeletonColor.B},
        ESPMaxDistance = Settings.ESPMaxDistance,
        
        -- Aimbot Settings
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
        
        -- Visual Settings
        Fullbright = Settings.Fullbright,
        
        -- Local ESP Settings
        LocalSkeleton = Settings.LocalSkeleton,
        LocalSkeletonColor = {Settings.LocalSkeletonColor.R, Settings.LocalSkeletonColor.G, Settings.LocalSkeletonColor.B},
        LocalHighlight = Settings.LocalHighlight,
        LocalHighlightColor = {Settings.LocalHighlightColor.R, Settings.LocalHighlightColor.G, Settings.LocalHighlightColor.B},
        
        -- Misc Settings
        InfiniteJump = Settings.InfiniteJump,
        DebugPanel = Settings.DebugPanel,
        DebugPanelPos = Settings.DebugPanelPos,
        MenuBind = Settings.MenuBind.Name,
        MenuColor = {Settings.MenuColor.R, Settings.MenuColor.G, Settings.MenuColor.B},
        
        -- Keybinds
        Keybinds = {}
    }
    
    -- Serialize all keybinds
    for keybindName, keybindData in pairs(Settings.Keybinds) do
        if keybindName == "Hitbox" then
            -- Special handling for Hitbox (nested structure)
            configData.Keybinds[keybindName] = {}
            for hitboxOption, hitboxBind in pairs(keybindData) do
                configData.Keybinds[keybindName][hitboxOption] = {
                    Key = typeof(hitboxBind.Key) == "EnumItem" and hitboxBind.Key.Name or tostring(hitboxBind.Key),
                    KeyType = typeof(hitboxBind.Key) == "EnumItem" and (hitboxBind.Key == Enum.UserInputType.MouseButton1 and "Mouse" or hitboxBind.Key == Enum.UserInputType.MouseButton2 and "Mouse" or "Keyboard") or "Keyboard",
                    Enabled = hitboxBind.Enabled
                }
            end
        else
            -- Regular keybind
            configData.Keybinds[keybindName] = {
                Key = typeof(keybindData.Key) == "EnumItem" and keybindData.Key.Name or tostring(keybindData.Key),
                KeyType = typeof(keybindData.Key) == "EnumItem" and (keybindData.Key == Enum.UserInputType.MouseButton1 and "Mouse" or keybindData.Key == Enum.UserInputType.MouseButton2 and "Mouse" or "Keyboard") or "Keyboard",
                Mode = keybindData.Mode,
                Enabled = keybindData.Enabled
            }
        end
    end
    
    configData.MenuSize = {
        Width = savedMenuSize.X.Offset,
        Height = savedMenuSize.Y.Offset
    }
    
    -- Save Keybind Manager Position
    if _G.KeybindManagerPosition then
        configData.KeybindManagerPosition = {
            XScale = _G.KeybindManagerPosition.X.Scale,
            XOffset = _G.KeybindManagerPosition.X.Offset,
            YScale = _G.KeybindManagerPosition.Y.Scale,
            YOffset = _G.KeybindManagerPosition.Y.Offset
        }
    end
    
    local success, err = pcall(function()
        local jsonData = HttpService:JSONEncode(configData)
        local filePath = configFolder .. "/" .. configName .. ".json"
        
        if writefile then
            writefile(filePath, jsonData)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Sentinel Config",
                Text = "Config '" .. configName .. "' saved!",
                Duration = 3
            })
            print("[Sentinel] Config saved: " .. configName)
            return true
        else
            warn("[Sentinel] writefile function not available")
            return false
        end
    end)
    
    if not success then
        warn("[Sentinel] Failed to save config: " .. tostring(err))
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "Failed to save config!",
            Duration = 3
        })
        return false
    end
    
    return true
end

local function LoadConfig(configName)
    if not fileSystemAvailable then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "File system not available!",
            Duration = 3
        })
        return false
    end
    
    local filePath = configFolder .. "/" .. configName .. ".json"
    
    -- Check if file exists
    if not isfile or not isfile(filePath) then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "Config '" .. configName .. "' not found!",
            Duration = 3
        })
        warn("[Sentinel] Config not found: " .. configName)
        return false
    end
    
    local success, result = pcall(function()
        if not readfile then
            warn("[Sentinel] readfile function not available")
            return nil
        end
        
        local content = readfile(filePath)
        if not content or content == "" then
            warn("[Sentinel] Config file is empty")
            return nil
        end
        
        return HttpService:JSONDecode(content)
    end)
    
    if success and result then
        -- ESP Settings
        Settings.ESP = result.ESP or false
        Settings.HealthBar = result.HealthBar or false
        Settings.Name = result.Name or false
        Settings.Distance = result.Distance or false
        Settings.TeamCheck = result.TeamCheck or false
        Settings.FilledBox = result.FilledBox or false
        Settings.BoxCorner = result.BoxCorner or false
        Settings.Skeleton = result.Skeleton or false
        
        if result.BoxColor then
            Settings.BoxColor = Color3.new(result.BoxColor[1], result.BoxColor[2], result.BoxColor[3])
        end
        if result.NameColor then
            Settings.NameColor = Color3.new(result.NameColor[1], result.NameColor[2], result.NameColor[3])
        end
        if result.DistanceColor then
            Settings.DistanceColor = Color3.new(result.DistanceColor[1], result.DistanceColor[2], result.DistanceColor[3])
        end
        if result.SkeletonColor then
            Settings.SkeletonColor = Color3.new(result.SkeletonColor[1], result.SkeletonColor[2], result.SkeletonColor[3])
        end
        
        Settings.ESPMaxDistance = result.ESPMaxDistance or 2000
        
        -- Aimbot Settings
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
        
        -- Visual Settings
        Settings.Fullbright = result.Fullbright or false
        if Settings.Fullbright then
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
        end
        
        -- Local ESP Settings
        Settings.LocalSkeleton = result.LocalSkeleton or false
        if result.LocalSkeletonColor then
            Settings.LocalSkeletonColor = Color3.new(result.LocalSkeletonColor[1], result.LocalSkeletonColor[2], result.LocalSkeletonColor[3])
        end
        Settings.LocalHighlight = result.LocalHighlight or false
        if result.LocalHighlightColor then
            Settings.LocalHighlightColor = Color3.new(result.LocalHighlightColor[1], result.LocalHighlightColor[2], result.LocalHighlightColor[3])
        end
        
        -- Misc Settings
        Settings.InfiniteJump = result.InfiniteJump or false
        Settings.DebugPanel = result.DebugPanel or false
        if result.DebugPanelPos then
            Settings.DebugPanelPos = result.DebugPanelPos
            DebugFrame.Position = UDim2.new(1, Settings.DebugPanelPos.X, 0, Settings.DebugPanelPos.Y)
        end
        if result.MenuBind then
            -- Convert string back to KeyCode
            for _, keyCode in pairs(Enum.KeyCode:GetEnumItems()) do
                if keyCode.Name == result.MenuBind then
                    Settings.MenuBind = keyCode
                    if menuBindButton then
                        menuBindButton.Text = "Menu Bind: " .. keyCode.Name
                    end
                    break
                end
            end
        end
        if result.MenuColor then
            Settings.MenuColor = Color3.new(result.MenuColor[1], result.MenuColor[2], result.MenuColor[3])
            UpdateAccentColor(Settings.MenuColor)
        end
        
        -- UI Settings
        if result.MenuSize then
            savedMenuSize = UDim2.new(0, result.MenuSize.Width, 0, result.MenuSize.Height)
            if Main.Visible then
                Main.Size = savedMenuSize
            end
        end
        
        -- Load Keybind Manager Position
        if result.KeybindManagerPosition then
            _G.KeybindManagerPosition = UDim2.new(
                result.KeybindManagerPosition.XScale,
                result.KeybindManagerPosition.XOffset,
                result.KeybindManagerPosition.YScale,
                result.KeybindManagerPosition.YOffset
            )
        end
        
        -- Keybinds
        if result.Keybinds then
            for name, bind in pairs(result.Keybinds) do
                if Settings.Keybinds[name] then
                    -- Check if it's a mouse button or keyboard key
                    if bind.KeyType == "Mouse" then
                        if bind.Key == "MouseButton1" then
                            Settings.Keybinds[name].Key = Enum.UserInputType.MouseButton1
                        elseif bind.Key == "MouseButton2" then
                            Settings.Keybinds[name].Key = Enum.UserInputType.MouseButton2
                        end
                    else
                        -- Convert string back to KeyCode
                        for _, keyCode in pairs(Enum.KeyCode:GetEnumItems()) do
                            if keyCode.Name == bind.Key then
                                Settings.Keybinds[name].Key = keyCode
                                break
                            end
                        end
                    end
                    Settings.Keybinds[name].Mode = bind.Mode or "Toggle"
                    Settings.Keybinds[name].Enabled = bind.Enabled ~= nil and bind.Enabled or true
                    
                    -- Update UI
                    if name == "ESP" and UIElements.BoxESP then
                        UIElements.BoxESP.UpdateKeybind()
                    elseif name == "Aimbot" and UIElements.Aimbot then
                        UIElements.Aimbot.UpdateKeybind()
                    elseif name == "InfiniteJump" and UIElements.InfiniteJump then
                        UIElements.InfiniteJump.UpdateKeybind()
                    end
                end
            end
        end
        
        -- Update UI elements
        if UIElements.BoxESP then UIElements.BoxESP.SetValue(Settings.ESP) end

        if UIElements.HealthBar then UIElements.HealthBar.SetValue(Settings.HealthBar) end
        if UIElements.Name then UIElements.Name.SetValue(Settings.Name) end
        if UIElements.Name then UIElements.Name.SetColor(Settings.NameColor) end
        if UIElements.Distance then UIElements.Distance.SetValue(Settings.Distance) end
        if UIElements.Distance then UIElements.Distance.SetColor(Settings.DistanceColor) end
        if UIElements.TeamCheck then UIElements.TeamCheck.SetValue(Settings.TeamCheck) end
        if UIElements.FilledBox then UIElements.FilledBox.SetValue(Settings.FilledBox) end
        if UIElements.BoxCorner then UIElements.BoxCorner.SetValue(Settings.BoxCorner) end
        if UIElements.Skeleton then UIElements.Skeleton.SetValue(Settings.Skeleton) end
        if UIElements.Skeleton then UIElements.Skeleton.SetColor(Settings.SkeletonColor) end
        if UIElements.ESPMaxDistance then UIElements.ESPMaxDistance.SetValue(Settings.ESPMaxDistance) end
        
        if UIElements.Aimbot then UIElements.Aimbot.SetValue(Settings.Aimbot) end
        if UIElements.AimbotSmooth then UIElements.AimbotSmooth.SetValue(Settings.AimbotSmooth) end
        if UIElements.AimLock then UIElements.AimLock.SetValue(Settings.AimLock) end
        if UIElements.ShowFOV then UIElements.ShowFOV.SetValue(Settings.ShowFOV) end
        if UIElements.ShowFOV then UIElements.ShowFOV.SetColor(Settings.FOVColor) end
        if UIElements.AimbotFOV then UIElements.AimbotFOV.SetValue(Settings.AimbotFOV) end
        if UIElements.AimbotMaxDistance then UIElements.AimbotMaxDistance.SetValue(Settings.AimbotMaxDistance) end
        if UIElements.Prediction then UIElements.Prediction.SetValue(Settings.Prediction) end
        if UIElements.PredictionStrength then UIElements.PredictionStrength.SetValue(Settings.PredictionStrength) end
        if UIElements.NoRecoil then UIElements.NoRecoil.SetValue(Settings.NoRecoil) end
        if UIElements.RecoilStrength then UIElements.RecoilStrength.SetValue(Settings.RecoilStrength) end
        
        if UIElements.Fullbright then UIElements.Fullbright.SetValue(Settings.Fullbright) end
        
        if UIElements.LocalSkeleton then UIElements.LocalSkeleton.SetValue(Settings.LocalSkeleton) end
        if UIElements.LocalSkeleton then UIElements.LocalSkeleton.SetColor(Settings.LocalSkeletonColor) end
        if UIElements.LocalHighlight then UIElements.LocalHighlight.SetValue(Settings.LocalHighlight) end
        if UIElements.LocalHighlight then UIElements.LocalHighlight.SetColor(Settings.LocalHighlightColor) end
        
        if UIElements.InfiniteJump then UIElements.InfiniteJump.SetValue(Settings.InfiniteJump) end
        if UIElements.DebugPanel then UIElements.DebugPanel.SetValue(Settings.DebugPanel) end
        
        -- Sync Active states after loading config
        if Settings.ESP then
            if not Settings.Keybinds.ESP.Enabled then
                Settings.ESPActive = true
            elseif Settings.Keybinds.ESP.Mode == "Always On" then
                Settings.ESPActive = true
            elseif Settings.Keybinds.ESP.Mode == "Toggle" then
                Settings.ESPActive = true
            else
                Settings.ESPActive = false
            end
        else
            Settings.ESPActive = false
        end
        
        if Settings.Aimbot then
            if not Settings.Keybinds.Aimbot.Enabled then
                Settings.AimbotActive = true
            elseif Settings.Keybinds.Aimbot.Mode == "Always On" then
                Settings.AimbotActive = true
            elseif Settings.Keybinds.Aimbot.Mode == "Toggle" then
                Settings.AimbotActive = true
            else
                Settings.AimbotActive = false
            end
        else
            Settings.AimbotActive = false
        end
        
        if Settings.InfiniteJump then
            if not Settings.Keybinds.InfiniteJump.Enabled then
                Settings.InfiniteJumpActive = true
            elseif Settings.Keybinds.InfiniteJump.Mode == "Always On" then
                Settings.InfiniteJumpActive = true
            elseif Settings.Keybinds.InfiniteJump.Mode == "Toggle" then
                Settings.InfiniteJumpActive = true
            else
                Settings.InfiniteJumpActive = false
            end
        else
            Settings.InfiniteJumpActive = false
        end
        
        if Settings.AimLock then
            if not Settings.Keybinds.AimLock.Enabled then
                Settings.AimLockActive = true
            elseif Settings.Keybinds.AimLock.Mode == "Always On" then
                Settings.AimLockActive = true
            elseif Settings.Keybinds.AimLock.Mode == "Toggle" then
                Settings.AimLockActive = true
            else
                Settings.AimLockActive = false
            end
        else
            Settings.AimLockActive = false
        end
        
        if Settings.NoRecoil then
            if not Settings.Keybinds.NoRecoil.Enabled then
                Settings.NoRecoilActive = true
            elseif Settings.Keybinds.NoRecoil.Mode == "Always On" then
                Settings.NoRecoilActive = true
            elseif Settings.Keybinds.NoRecoil.Mode == "Toggle" then
                Settings.NoRecoilActive = true
            else
                Settings.NoRecoilActive = false
            end
        else
            Settings.NoRecoilActive = false
        end
        
        if Settings.Prediction then
            if not Settings.Keybinds.Prediction.Enabled then
                Settings.PredictionActive = true
            elseif Settings.Keybinds.Prediction.Mode == "Always On" then
                Settings.PredictionActive = true
            elseif Settings.Keybinds.Prediction.Mode == "Toggle" then
                Settings.PredictionActive = true
            else
                Settings.PredictionActive = false
            end
        else
            Settings.PredictionActive = false
        end
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "Config '" .. configName .. "' loaded!",
            Duration = 3
        })
        print("[Sentinel] Config loaded: " .. configName)
        
        return true
    else
        warn("[Sentinel] Failed to load config: " .. tostring(result))
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "Failed to load config!",
            Duration = 3
        })
        return false
    end
end

local function DeleteConfig(configName)
    if not fileSystemAvailable then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "File system not available!",
            Duration = 3
        })
        return false
    end
    
    local filePath = configFolder .. "/" .. configName .. ".json"
    
    -- Check if file exists
    if not isfile or not isfile(filePath) then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "Config '" .. configName .. "' not found!",
            Duration = 3
        })
        warn("[Sentinel] Config not found: " .. configName)
        return false
    end
    
    local success, err = pcall(function()
        if delfile then
            delfile(filePath)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Sentinel Config",
                Text = "Config '" .. configName .. "' deleted!",
                Duration = 3
            })
            print("[Sentinel] Config deleted: " .. configName)
            return true
        else
            warn("[Sentinel] delfile function not available")
            return false
        end
    end)
    
    if not success then
        warn("[Sentinel] Failed to delete config: " .. tostring(err))
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "Failed to delete config!",
            Duration = 3
        })
        return false
    end
    
    return true
end

local function ExportConfigToClipboard()
    -- Check if clipboard functions are available
    if not setclipboard then
        ShowNotification("Clipboard not supported!", 2)
        warn("[Sentinel] setclipboard function not available")
        return false
    end
    
    local configData = {
        -- ESP Settings
        ESP = Settings.ESP,
        HealthBar = Settings.HealthBar,
        Name = Settings.Name,
        Distance = Settings.Distance,
        TeamCheck = Settings.TeamCheck,
        FilledBox = Settings.FilledBox,
        BoxCorner = Settings.BoxCorner,
        Skeleton = Settings.Skeleton,
        BoxColor = {Settings.BoxColor.R, Settings.BoxColor.G, Settings.BoxColor.B},
        NameColor = {Settings.NameColor.R, Settings.NameColor.G, Settings.NameColor.B},
        DistanceColor = {Settings.DistanceColor.R, Settings.DistanceColor.G, Settings.DistanceColor.B},
        SkeletonColor = {Settings.SkeletonColor.R, Settings.SkeletonColor.G, Settings.SkeletonColor.B},
        ESPMaxDistance = Settings.ESPMaxDistance,
        
        -- Aimbot Settings
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
        
        -- Visual Settings
        Fullbright = Settings.Fullbright,
        
        -- Local ESP Settings
        LocalSkeleton = Settings.LocalSkeleton,
        LocalSkeletonColor = {Settings.LocalSkeletonColor.R, Settings.LocalSkeletonColor.G, Settings.LocalSkeletonColor.B},
        LocalHighlight = Settings.LocalHighlight,
        LocalHighlightColor = {Settings.LocalHighlightColor.R, Settings.LocalHighlightColor.G, Settings.LocalHighlightColor.B},
        
        -- Misc Settings
        InfiniteJump = Settings.InfiniteJump,
        DebugPanel = Settings.DebugPanel,
        DebugPanelPos = Settings.DebugPanelPos,
        MenuBind = Settings.MenuBind.Name,
        
        -- Keybinds
        Keybinds = {
            ESP = {
                Key = typeof(Settings.Keybinds.ESP.Key) == "EnumItem" and Settings.Keybinds.ESP.Key.Name or "E",
                KeyType = typeof(Settings.Keybinds.ESP.Key) == "EnumItem" and (Settings.Keybinds.ESP.Key == Enum.UserInputType.MouseButton1 and "Mouse" or Settings.Keybinds.ESP.Key == Enum.UserInputType.MouseButton2 and "Mouse" or "Keyboard") or "Keyboard",
                Mode = Settings.Keybinds.ESP.Mode,
                Enabled = Settings.Keybinds.ESP.Enabled
            },
            Aimbot = {
                Key = typeof(Settings.Keybinds.Aimbot.Key) == "EnumItem" and Settings.Keybinds.Aimbot.Key.Name or "Q",
                KeyType = typeof(Settings.Keybinds.Aimbot.Key) == "EnumItem" and (Settings.Keybinds.Aimbot.Key == Enum.UserInputType.MouseButton1 and "Mouse" or Settings.Keybinds.Aimbot.Key == Enum.UserInputType.MouseButton2 and "Mouse" or "Keyboard") or "Keyboard",
                Mode = Settings.Keybinds.Aimbot.Mode,
                Enabled = Settings.Keybinds.Aimbot.Enabled
            },
            InfiniteJump = {
                Key = typeof(Settings.Keybinds.InfiniteJump.Key) == "EnumItem" and Settings.Keybinds.InfiniteJump.Key.Name or "J",
                KeyType = typeof(Settings.Keybinds.InfiniteJump.Key) == "EnumItem" and (Settings.Keybinds.InfiniteJump.Key == Enum.UserInputType.MouseButton1 and "Mouse" or Settings.Keybinds.InfiniteJump.Key == Enum.UserInputType.MouseButton2 and "Mouse" or "Keyboard") or "Keyboard",
                Mode = Settings.Keybinds.InfiniteJump.Mode,
                Enabled = Settings.Keybinds.InfiniteJump.Enabled
            }
        },
        
        -- UI Settings
        MenuSize = {
            Width = savedMenuSize.X.Offset,
            Height = savedMenuSize.Y.Offset
        }
    }
    
    local success, result = pcall(function()
        local jsonData = HttpService:JSONEncode(configData)
        setclipboard(jsonData)
        ShowNotification("Config exported to clipboard!", 2)
        print("[Sentinel] Config exported to clipboard")
        return true
    end)
    
    if not success then
        warn("[Sentinel] Failed to export config: " .. tostring(result))
        ShowNotification("Failed to export config!", 2)
        return false
    end
    
    return true
end

local function ImportConfigFromClipboard()
    -- Check if clipboard functions are available
    if not getclipboard then
        ShowNotification("Clipboard not supported!", 2)
        warn("[Sentinel] getclipboard function not available")
        return false
    end
    
    local success, result = pcall(function()
        local clipboardContent = getclipboard()
        
        if not clipboardContent or clipboardContent == "" then
            ShowNotification("Clipboard is empty!", 2)
            return false
        end
        
        -- Try to decode JSON
        local configData = HttpService:JSONDecode(clipboardContent)
        
        if not configData then
            ShowNotification("Invalid config data!", 2)
            return false
        end
        
        -- Apply settings (same as LoadConfig)
        -- ESP Settings
        Settings.ESP = configData.ESP or false
        Settings.HealthBar = configData.HealthBar or false
        Settings.Name = configData.Name or false
        Settings.Distance = configData.Distance or false
        Settings.TeamCheck = configData.TeamCheck or false
        Settings.FilledBox = configData.FilledBox or false
        Settings.BoxCorner = configData.BoxCorner or false
        Settings.Skeleton = configData.Skeleton or false
        
        if configData.BoxColor then
            Settings.BoxColor = Color3.new(configData.BoxColor[1], configData.BoxColor[2], configData.BoxColor[3])
        end
        if configData.NameColor then
            Settings.NameColor = Color3.new(configData.NameColor[1], configData.NameColor[2], configData.NameColor[3])
        end
        if configData.DistanceColor then
            Settings.DistanceColor = Color3.new(configData.DistanceColor[1], configData.DistanceColor[2], configData.DistanceColor[3])
        end
        if configData.SkeletonColor then
            Settings.SkeletonColor = Color3.new(configData.SkeletonColor[1], configData.SkeletonColor[2], configData.SkeletonColor[3])
        end
        
        Settings.ESPMaxDistance = configData.ESPMaxDistance or 2000
        
        -- Aimbot Settings
        Settings.Aimbot = configData.Aimbot or false
        Settings.AimbotFOV = configData.AimbotFOV or 100
        Settings.ShowFOV = configData.ShowFOV or false
        
        if configData.FOVColor then
            Settings.FOVColor = Color3.new(configData.FOVColor[1], configData.FOVColor[2], configData.FOVColor[3])
        end
        
        Settings.AimbotSmooth = configData.AimbotSmooth or 1
        Settings.AimbotHitbox = configData.AimbotHitbox or "Head"
        Settings.AimLock = configData.AimLock or false
        Settings.AimbotMaxDistance = configData.AimbotMaxDistance or 500
        Settings.NoRecoil = configData.NoRecoil or false
        Settings.RecoilStrength = configData.RecoilStrength or 50
        Settings.Prediction = configData.Prediction or false
        Settings.PredictionStrength = configData.PredictionStrength or 10
        
        -- Visual Settings
        Settings.Fullbright = configData.Fullbright or false
        if Settings.Fullbright then
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
        end
        
        -- Local ESP Settings
        Settings.LocalSkeleton = configData.LocalSkeleton or false
        if configData.LocalSkeletonColor then
            Settings.LocalSkeletonColor = Color3.new(configData.LocalSkeletonColor[1], configData.LocalSkeletonColor[2], configData.LocalSkeletonColor[3])
        end
        Settings.LocalHighlight = configData.LocalHighlight or false
        if configData.LocalHighlightColor then
            Settings.LocalHighlightColor = Color3.new(configData.LocalHighlightColor[1], configData.LocalHighlightColor[2], configData.LocalHighlightColor[3])
        end
        
        -- Misc Settings
        Settings.InfiniteJump = configData.InfiniteJump or false
        Settings.DebugPanel = configData.DebugPanel or false
        if configData.DebugPanelPos then
            Settings.DebugPanelPos = configData.DebugPanelPos
            DebugFrame.Position = UDim2.new(1, Settings.DebugPanelPos.X, 0, Settings.DebugPanelPos.Y)
        end
        if configData.MenuBind then
            -- Convert string back to KeyCode
            for _, keyCode in pairs(Enum.KeyCode:GetEnumItems()) do
                if keyCode.Name == configData.MenuBind then
                    Settings.MenuBind = keyCode
                    if menuBindButton then
                        menuBindButton.Text = "Menu Bind: " .. keyCode.Name
                    end
                    break
                end
            end
        end
        if configData.MenuColor then
            Settings.MenuColor = Color3.new(configData.MenuColor[1], configData.MenuColor[2], configData.MenuColor[3])
            UpdateAccentColor(Settings.MenuColor)
        end
        
        -- UI Settings
        if configData.MenuSize then
            savedMenuSize = UDim2.new(0, configData.MenuSize.Width, 0, configData.MenuSize.Height)
            if Main.Visible then
                Main.Size = savedMenuSize
            end
        end
        
        -- Keybinds
        if configData.Keybinds then
            for name, bind in pairs(configData.Keybinds) do
                if name == "Hitbox" then
                    -- Special handling for Hitbox (nested structure)
                    if not Settings.Keybinds[name] then
                        Settings.Keybinds[name] = {}
                    end
                    for hitboxOption, hitboxBind in pairs(bind) do
                        if not Settings.Keybinds[name][hitboxOption] then
                            Settings.Keybinds[name][hitboxOption] = {}
                        end
                        
                        if hitboxBind.KeyType == "Mouse" then
                            if hitboxBind.Key == "MouseButton1" then
                                Settings.Keybinds[name][hitboxOption].Key = Enum.UserInputType.MouseButton1
                            elseif hitboxBind.Key == "MouseButton2" then
                                Settings.Keybinds[name][hitboxOption].Key = Enum.UserInputType.MouseButton2
                            end
                        else
                            for _, keyCode in pairs(Enum.KeyCode:GetEnumItems()) do
                                if keyCode.Name == hitboxBind.Key then
                                    Settings.Keybinds[name][hitboxOption].Key = keyCode
                                    break
                                end
                            end
                        end
                        Settings.Keybinds[name][hitboxOption].Enabled = hitboxBind.Enabled ~= nil and hitboxBind.Enabled or false
                    end
                elseif Settings.Keybinds[name] then
                    -- Regular keybind
                    if bind.KeyType == "Mouse" then
                        if bind.Key == "MouseButton1" then
                            Settings.Keybinds[name].Key = Enum.UserInputType.MouseButton1
                        elseif bind.Key == "MouseButton2" then
                            Settings.Keybinds[name].Key = Enum.UserInputType.MouseButton2
                        end
                    else
                        -- Convert string back to KeyCode
                        for _, keyCode in pairs(Enum.KeyCode:GetEnumItems()) do
                            if keyCode.Name == bind.Key then
                                Settings.Keybinds[name].Key = keyCode
                                break
                            end
                        end
                    end
                    Settings.Keybinds[name].Mode = bind.Mode or "Toggle"
                    Settings.Keybinds[name].Enabled = bind.Enabled ~= nil and bind.Enabled or true
                    
                    -- Update UI
                    if name == "ESP" and UIElements.BoxESP then
                        UIElements.BoxESP.UpdateKeybind()
                    elseif name == "Aimbot" and UIElements.Aimbot then
                        UIElements.Aimbot.UpdateKeybind()
                    elseif name == "InfiniteJump" and UIElements.InfiniteJump then
                        UIElements.InfiniteJump.UpdateKeybind()
                    end
                end
            end
        end
        
        -- Update UI elements
        if UIElements.BoxESP then UIElements.BoxESP.SetValue(Settings.ESP) end

        if UIElements.HealthBar then UIElements.HealthBar.SetValue(Settings.HealthBar) end
        if UIElements.Name then UIElements.Name.SetValue(Settings.Name) end
        if UIElements.Name then UIElements.Name.SetColor(Settings.NameColor) end
        if UIElements.Distance then UIElements.Distance.SetValue(Settings.Distance) end
        if UIElements.Distance then UIElements.Distance.SetColor(Settings.DistanceColor) end
        if UIElements.TeamCheck then UIElements.TeamCheck.SetValue(Settings.TeamCheck) end
        if UIElements.FilledBox then UIElements.FilledBox.SetValue(Settings.FilledBox) end
        if UIElements.BoxCorner then UIElements.BoxCorner.SetValue(Settings.BoxCorner) end
        if UIElements.Skeleton then UIElements.Skeleton.SetValue(Settings.Skeleton) end
        if UIElements.Skeleton then UIElements.Skeleton.SetColor(Settings.SkeletonColor) end
        if UIElements.ESPMaxDistance then UIElements.ESPMaxDistance.SetValue(Settings.ESPMaxDistance) end
        
        if UIElements.Aimbot then UIElements.Aimbot.SetValue(Settings.Aimbot) end
        if UIElements.AimbotSmooth then UIElements.AimbotSmooth.SetValue(Settings.AimbotSmooth) end
        if UIElements.AimLock then UIElements.AimLock.SetValue(Settings.AimLock) end
        if UIElements.ShowFOV then UIElements.ShowFOV.SetValue(Settings.ShowFOV) end
        if UIElements.ShowFOV then UIElements.ShowFOV.SetColor(Settings.FOVColor) end
        if UIElements.AimbotFOV then UIElements.AimbotFOV.SetValue(Settings.AimbotFOV) end
        if UIElements.AimbotMaxDistance then UIElements.AimbotMaxDistance.SetValue(Settings.AimbotMaxDistance) end
        if UIElements.Prediction then UIElements.Prediction.SetValue(Settings.Prediction) end
        if UIElements.PredictionStrength then UIElements.PredictionStrength.SetValue(Settings.PredictionStrength) end
        if UIElements.NoRecoil then UIElements.NoRecoil.SetValue(Settings.NoRecoil) end
        if UIElements.RecoilStrength then UIElements.RecoilStrength.SetValue(Settings.RecoilStrength) end
        
        if UIElements.Fullbright then UIElements.Fullbright.SetValue(Settings.Fullbright) end
        
        if UIElements.LocalSkeleton then UIElements.LocalSkeleton.SetValue(Settings.LocalSkeleton) end
        if UIElements.LocalSkeleton then UIElements.LocalSkeleton.SetColor(Settings.LocalSkeletonColor) end
        if UIElements.LocalHighlight then UIElements.LocalHighlight.SetValue(Settings.LocalHighlight) end
        if UIElements.LocalHighlight then UIElements.LocalHighlight.SetColor(Settings.LocalHighlightColor) end
        
        if UIElements.InfiniteJump then UIElements.InfiniteJump.SetValue(Settings.InfiniteJump) end
        if UIElements.DebugPanel then UIElements.DebugPanel.SetValue(Settings.DebugPanel) end
        
        -- Sync Active states after importing config
        if Settings.ESP then
            if not Settings.Keybinds.ESP.Enabled then
                Settings.ESPActive = true
            elseif Settings.Keybinds.ESP.Mode == "Always On" then
                Settings.ESPActive = true
            elseif Settings.Keybinds.ESP.Mode == "Toggle" then
                Settings.ESPActive = true
            else
                Settings.ESPActive = false
            end
        else
            Settings.ESPActive = false
        end
        
        if Settings.Aimbot then
            if not Settings.Keybinds.Aimbot.Enabled then
                Settings.AimbotActive = true
            elseif Settings.Keybinds.Aimbot.Mode == "Always On" then
                Settings.AimbotActive = true
            elseif Settings.Keybinds.Aimbot.Mode == "Toggle" then
                Settings.AimbotActive = true
            else
                Settings.AimbotActive = false
            end
        else
            Settings.AimbotActive = false
        end
        
        if Settings.InfiniteJump then
            if not Settings.Keybinds.InfiniteJump.Enabled then
                Settings.InfiniteJumpActive = true
            elseif Settings.Keybinds.InfiniteJump.Mode == "Always On" then
                Settings.InfiniteJumpActive = true
            elseif Settings.Keybinds.InfiniteJump.Mode == "Toggle" then
                Settings.InfiniteJumpActive = true
            else
                Settings.InfiniteJumpActive = false
            end
        else
            Settings.InfiniteJumpActive = false
        end
        
        ShowNotification("Config imported from clipboard!", 2)
        print("[Sentinel] Config imported from clipboard")
        
        return true
    end)
    
    if not success then
        warn("[Sentinel] Failed to import config: " .. tostring(result))
        ShowNotification("Failed to import config!", 2)
        return false
    end
    
    return true
end

local function ListConfigs()
    if not fileSystemAvailable then
        return {}
    end
    
    local configs = {}
    
    local success, result = pcall(function()
        if listfiles then
            local files = listfiles(configFolder)
            for _, file in ipairs(files) do
                -- Extract filename without path and extension
                local name = file:match("([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end
    end)
    
    if not success then
        warn("[Sentinel] Failed to list configs: " .. tostring(result))
    end
    
    return configs
end

local function CreateButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 1, -10)
    btn.Position = UDim2.new(0, 10, 0, 5)
    btn.BackgroundColor3 = Settings.MenuColor
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = frame
    table.insert(AccentColorElements.ConfigActionButtons, btn)
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return frame
end

local function CreateTextBox(parent, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -20, 1, -10)
    textbox.Position = UDim2.new(0, 10, 0, 5)
    textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    textbox.Text = ""
    textbox.PlaceholderText = placeholder
    textbox.TextColor3 = Color3.fromRGB(200, 200, 200)
    textbox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    textbox.TextSize = 12
    textbox.Font = Enum.Font.Gotham
    textbox.BorderSizePixel = 0
    textbox.ClearTextOnFocus = false
    textbox.Parent = frame
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 4)
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
local configListFrame

-- Config list display
local configListContainer = Instance.new("Frame")
configListContainer.Size = UDim2.new(1, 0, 0, 150)
configListContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
configListContainer.BorderSizePixel = 0
configListContainer.Parent = ConfigTab.Content

local configListCorner = Instance.new("UICorner")
configListCorner.CornerRadius = UDim.new(0, 8)
configListCorner.Parent = configListContainer

local configListTitle = Instance.new("TextLabel")
configListTitle.Size = UDim2.new(1, 0, 0, 25)
configListTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
configListTitle.Text = "Saved Configs"
configListTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
configListTitle.TextSize = 13
configListTitle.Font = Enum.Font.GothamBold
configListTitle.BorderSizePixel = 0
configListTitle.Parent = configListContainer

local configListTitleCorner = Instance.new("UICorner")
configListTitleCorner.CornerRadius = UDim.new(0, 8)
configListTitleCorner.Parent = configListTitle

local configListScroll = Instance.new("ScrollingFrame")
configListScroll.Size = UDim2.new(1, -10, 1, -35)
configListScroll.Position = UDim2.new(0, 5, 0, 30)
configListScroll.BackgroundTransparency = 1
configListScroll.BorderSizePixel = 0
configListScroll.ScrollBarThickness = 4
configListScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
configListScroll.Parent = configListContainer

local configListLayout = Instance.new("UIListLayout")
configListLayout.Padding = UDim.new(0, 5)
configListLayout.Parent = configListScroll

-- Function to refresh config list
local function RefreshConfigList()
    -- Clear existing items
    for _, child in ipairs(configListScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local configs = ListConfigs()
    
    if #configs == 0 then
        local noConfigLabel = Instance.new("TextLabel")
        noConfigLabel.Size = UDim2.new(1, -10, 0, 30)
        noConfigLabel.BackgroundTransparency = 1
        noConfigLabel.Text = "No configs found"
        noConfigLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        noConfigLabel.TextSize = 12
        noConfigLabel.Font = Enum.Font.Gotham
        noConfigLabel.Parent = configListScroll
    else
        for _, configName in ipairs(configs) do
            local configItem = Instance.new("Frame")
            configItem.Size = UDim2.new(1, -10, 0, 30)
            configItem.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            configItem.BorderSizePixel = 0
            configItem.Parent = configListScroll
            
            local configItemCorner = Instance.new("UICorner")
            configItemCorner.CornerRadius = UDim.new(0, 6)
            configItemCorner.Parent = configItem
            
            -- Check if this is the autoload config
            local isAutoload = GetAutoloadConfig() == configName
            
            local configNameLabel = Instance.new("TextLabel")
            configNameLabel.Size = UDim2.new(1, -205, 1, 0)
            configNameLabel.Position = UDim2.new(0, 10, 0, 0)
            configNameLabel.BackgroundTransparency = 1
            configNameLabel.Text = configName .. (isAutoload and " [AUTO]" or "")
            configNameLabel.TextColor3 = isAutoload and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            configNameLabel.TextSize = 12
            configNameLabel.Font = Enum.Font.Gotham
            configNameLabel.TextXAlignment = Enum.TextXAlignment.Left
            configNameLabel.Parent = configItem
            
            -- Make name clickable
            local nameButton = Instance.new("TextButton")
            nameButton.Size = UDim2.new(1, -205, 1, 0)
            nameButton.Position = UDim2.new(0, 0, 0, 0)
            nameButton.BackgroundTransparency = 1
            nameButton.Text = ""
            nameButton.ZIndex = 2
            nameButton.Parent = configItem
            
            nameButton.MouseButton1Click:Connect(function()
                configNameBox.Text = configName
            end)
            
            -- Hover effect
            nameButton.MouseEnter:Connect(function()
                configNameLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
            end)
            
            nameButton.MouseLeave:Connect(function()
                configNameLabel.TextColor3 = isAutoload and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            end)
            
            -- Autoload button
            local autoloadBtn = Instance.new("TextButton")
            autoloadBtn.Size = UDim2.new(0, 60, 0, 22)
            autoloadBtn.Position = UDim2.new(1, -195, 0.5, -11)
            autoloadBtn.BackgroundColor3 = isAutoload and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 55)
            autoloadBtn.Text = "Auto"
            autoloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            autoloadBtn.TextSize = 11
            autoloadBtn.Font = Enum.Font.GothamBold
            autoloadBtn.BorderSizePixel = 0
            autoloadBtn.Parent = configItem
            
            local autoloadBtnCorner = Instance.new("UICorner")
            autoloadBtnCorner.CornerRadius = UDim.new(0, 4)
            autoloadBtnCorner.Parent = autoloadBtn
            
            autoloadBtn.MouseButton1Click:Connect(function()
                SetAutoloadConfig(configName)
                task.wait(0.1)
                RefreshConfigList()
            end)
            
            -- Load button
            local loadBtn = Instance.new("TextButton")
            loadBtn.Size = UDim2.new(0, 60, 0, 22)
            loadBtn.Position = UDim2.new(1, -130, 0.5, -11)
            loadBtn.BackgroundColor3 = Settings.MenuColor
            loadBtn.Text = "Load"
            loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            loadBtn.TextSize = 11
            loadBtn.Font = Enum.Font.GothamBold
            loadBtn.BorderSizePixel = 0
            loadBtn.Parent = configItem
            table.insert(AccentColorElements.ConfigLoadButtons, loadBtn)
            
            local loadBtnCorner = Instance.new("UICorner")
            loadBtnCorner.CornerRadius = UDim.new(0, 4)
            loadBtnCorner.Parent = loadBtn
            
            loadBtn.MouseButton1Click:Connect(function()
                LoadConfig(configName)
            end)
            
            -- Delete button
            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 60, 0, 22)
            delBtn.Position = UDim2.new(1, -65, 0.5, -11)
            delBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
            delBtn.Text = "Delete"
            delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            delBtn.TextSize = 11
            delBtn.Font = Enum.Font.GothamBold
            delBtn.BorderSizePixel = 0
            delBtn.Parent = configItem
            
            local delBtnCorner = Instance.new("UICorner")
            delBtnCorner.CornerRadius = UDim.new(0, 4)
            delBtnCorner.Parent = delBtn
            
            delBtn.MouseButton1Click:Connect(function()
                DeleteConfig(configName)
                task.wait(0.1)
                RefreshConfigList()
            end)
        end
    end
    
    -- Update scroll canvas
    configListScroll.CanvasSize = UDim2.new(0, 0, 0, configListLayout.AbsoluteContentSize.Y + 10)
end

-- Refresh button
CreateButton(ConfigTab.Content, "Refresh List", function()
    RefreshConfigList()
end)

local _, textboxRef = CreateTextBox(ConfigTab.Content, "Enter config name...", function() end)
configNameBox = textboxRef

CreateButton(ConfigTab.Content, "Save Config", function()
    if configNameBox.Text ~= "" then
        SaveConfig(configNameBox.Text)
        task.wait(0.1)
        RefreshConfigList()
        configNameBox.Text = ""
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "Please enter a config name!",
            Duration = 2
        })
    end
end)

CreateButton(ConfigTab.Content, "Load Config", function()
    if configNameBox.Text ~= "" then
        LoadConfig(configNameBox.Text)
        configNameBox.Text = ""
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sentinel Config",
            Text = "Please enter a config name!",
            Duration = 2
        })
    end
end)

-- Initial refresh
task.spawn(function()
    task.wait(0.5)
    RefreshConfigList()
end)

-- Select first tab
if #Tabs > 0 then
    task.wait(0.1)
    Tabs[1].Scroll.Visible = true
    Tween(Tabs[1].Button, {BackgroundColor3 = Color3.fromRGB(100, 50, 200), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    CurrentTab = Tabs[1]
end

-- Resizing variables
local resizing = false
local resizeDirection = nil
local resizeStart = nil
local startSize = nil
local startPosition = nil
local minSize = Vector2.new(680, 350)
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
StatusBar.InputBegan:Connect(function(input)
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

-- Menu key handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Settings.MenuBind then
        -- Проверка что загрузка завершена
        if not _G.SentinelLoaded then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Sentinel",
                Text = "Please wait, loading...",
                Duration = 2
            })
            return
        end
        
        -- Переключаем видимость меню
        if Main.Visible then
            -- Закрываем меню
            savedMenuSize = Main.Size
            Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
            Tween(TopPanel, {BackgroundTransparency = 1}, 0.15)
            Tween(TopPanelStroke, {Transparency = 1}, 0.15)
            -- Animate buttons
            for _, child in ipairs(TopPanel:GetChildren()) do
                if child:IsA("TextButton") then
                    Tween(child, {BackgroundTransparency = 1}, 0.15)
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        Tween(stroke, {Transparency = 1}, 0.15)
                    end
                end
            end
            task.wait(0.15)
            Main.Visible = false
            TopPanel.Visible = false
            
            -- Close right-click menu if open
            if currentKeybindMenu then
                Tween(currentKeybindMenu, {BackgroundTransparency = 1}, 0.2)
                local menuStroke = currentKeybindMenu:FindFirstChildOfClass("UIStroke")
                if menuStroke then
                    Tween(menuStroke, {Transparency = 1}, 0.2)
                end
                
                -- Animate all child elements
                for _, child in ipairs(currentKeybindMenu:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Tween(child, {TextTransparency = 1}, 0.2)
                    elseif child:IsA("TextButton") then
                        Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.2)
                    end
                end
                
                task.wait(0.2)
                currentKeybindMenu:Destroy()
                currentKeybindMenu = nil
            end
            
            -- Hide keybind manager if open (but keep state)
            if _G.KeybindManagerOpen and _G.KeybindManagerWindow then
                _G.KeybindManagerPosition = _G.KeybindManagerWindow.Position
                _G.KeybindManagerWindow.Visible = false
            end
            -- Don't show hint again
        else
            -- Reset scroll position for all tabs
            for _, tab in pairs(Tabs) do
                if tab.Scroll then
                    tab.Scroll.CanvasPosition = Vector2.new(0, 0)
                end
            end
            
            -- Открываем меню
            HintFrame.Visible = false -- Hide hint when opening menu
            TopPanel.Visible = true
            Main.Visible = true
            Main.Size = UDim2.new(0, 0, 0, 0)
            Tween(Main, {Size = savedMenuSize}, 0.2)
            Tween(TopPanel, {BackgroundTransparency = 0}, 0.15)
            Tween(TopPanelStroke, {Transparency = 0.7}, 0.15)
            -- Animate buttons with delay
            for i, child in ipairs(TopPanel:GetChildren()) do
                if child:IsA("TextButton") then
                    task.spawn(function()
                        task.wait(0.03 * i)
                        Tween(child, {BackgroundTransparency = 0}, 0.15)
                        local stroke = child:FindFirstChildOfClass("UIStroke")
                        if stroke then
                            Tween(stroke, {Transparency = 0.5}, 0.15)
                        end
                    end)
                end
            end
            
            -- Show keybind manager if it was open
            if _G.KeybindManagerOpen and _G.KeybindManagerWindow then
                _G.KeybindManagerWindow.Visible = true
            end
        end
    end
end)

-- Main Loop
-- Initialize Active states based on current settings
if Settings.ESP and Settings.Keybinds.ESP.Mode == "Always On" then
    Settings.ESPActive = true
end
if Settings.Aimbot and Settings.Keybinds.Aimbot.Mode == "Always On" then
    Settings.AimbotActive = true
end
if Settings.InfiniteJump and Settings.Keybinds.InfiniteJump.Mode == "Always On" then
    Settings.InfiniteJumpActive = true
end

-- Initialize Active states for all other functions
local keybindFunctions = {
    "AimLock", "Prediction", "NoRecoil", "HealthBar", "TeamCheck", 
    "FilledBox", "BoxCorner", "Fullbright", "DebugPanel", "ShowKeylist",
    "LocalSkeleton", "LocalHighlight"
}
for _, funcName in ipairs(keybindFunctions) do
    local activeName = funcName .. "Active"
    if Settings[funcName] and Settings.Keybinds[funcName] and Settings.Keybinds[funcName].Mode == "Always On" then
        Settings[activeName] = true
    end
end

RunService.Heartbeat:Connect(UpdateESP)
RunService.Heartbeat:Connect(UpdateLocalESP)
RunService.Heartbeat:Connect(UpdateAimbot)
RunService.Heartbeat:Connect(UpdateFOVCircle)
RunService.RenderStepped:Connect(UpdateDebugPanel)
RunService.Heartbeat:Connect(UpdateInfiniteJump)

-- Menu initialization complete
isMenuLoaded = true

-- Keybind Handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- ESP Keybind
    if Settings.Keybinds.ESP and Settings.Keybinds.ESP.Enabled and Settings.ESP then -- Only work if ESP is enabled and keybind is set
        local keyMatch = false
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Settings.Keybinds.ESP.Key then
            keyMatch = true
        elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == Settings.Keybinds.ESP.Key then
            keyMatch = true
        end
        
        if keyMatch then
            if Settings.Keybinds.ESP.Mode == "Toggle" then
                Settings.ESPActive = not Settings.ESPActive
            elseif Settings.Keybinds.ESP.Mode == "Hold" then
                Settings.ESPActive = true
            end
            -- Always On mode: ESPActive is always true when ESP is enabled
        end
    end
    
    -- Aimbot Keybind
    if Settings.Keybinds.Aimbot and Settings.Keybinds.Aimbot.Enabled and Settings.Aimbot then -- Only work if Aimbot is enabled and keybind is set
        local keyMatch = false
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Settings.Keybinds.Aimbot.Key then
            keyMatch = true
        elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == Settings.Keybinds.Aimbot.Key then
            keyMatch = true
        end
        
        if keyMatch then
            if Settings.Keybinds.Aimbot.Mode == "Toggle" then
                Settings.AimbotActive = not Settings.AimbotActive
            elseif Settings.Keybinds.Aimbot.Mode == "Hold" then
                Settings.AimbotActive = true
            end
        end
    end
    
    -- Infinite Jump Keybind
    if Settings.Keybinds.InfiniteJump and Settings.Keybinds.InfiniteJump.Enabled and Settings.InfiniteJump then -- Only work if InfiniteJump is enabled and keybind is set
        local keyMatch = false
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Settings.Keybinds.InfiniteJump.Key then
            keyMatch = true
        elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == Settings.Keybinds.InfiniteJump.Key then
            keyMatch = true
        end
        
        if keyMatch then
            if Settings.Keybinds.InfiniteJump.Mode == "Toggle" then
                Settings.InfiniteJumpActive = not Settings.InfiniteJumpActive
            elseif Settings.Keybinds.InfiniteJump.Mode == "Hold" then
                Settings.InfiniteJumpActive = true
            end
        end
    end
    
    -- Hitbox Keybinds
    if Settings.Keybinds.Hitbox then
        for hitboxName, hitboxBind in pairs(Settings.Keybinds.Hitbox) do
            if hitboxBind.Enabled then
                local keyMatch = false
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == hitboxBind.Key then
                    keyMatch = true
                elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == hitboxBind.Key then
                    keyMatch = true
                end
                
                if keyMatch then
                    Settings.AimbotHitbox = hitboxName
                    ShowNotification("Hitbox: " .. hitboxName, 1.5)
                    break
                end
            end
        end
    end
    
    -- Generic keybind handler for all other functions
    local keybindFunctions = {
        "AimLock", "Prediction", "NoRecoil", "HealthBar", "TeamCheck", 
        "FilledBox", "BoxCorner", "Fullbright", "DebugPanel", "ShowKeylist",
        "LocalSkeleton", "LocalHighlight"
    }
    
    for _, funcName in ipairs(keybindFunctions) do
        local bind = Settings.Keybinds[funcName]
        if bind and bind.Enabled and Settings[funcName] then
            local keyMatch = false
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == bind.Key then
                keyMatch = true
            elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == bind.Key then
                keyMatch = true
            end
            
            if keyMatch then
                local activeName = funcName .. "Active"
                if bind.Mode == "Toggle" then
                    Settings[activeName] = not Settings[activeName]
                elseif bind.Mode == "Hold" then
                    Settings[activeName] = true
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    -- ESP Hold mode release
    if Settings.Keybinds.ESP and Settings.Keybinds.ESP.Enabled and Settings.Keybinds.ESP.Mode == "Hold" and Settings.ESP then
        local keyMatch = false
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Settings.Keybinds.ESP.Key then
            keyMatch = true
        elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == Settings.Keybinds.ESP.Key then
            keyMatch = true
        end
        
        if keyMatch then
            Settings.ESPActive = false
        end
    end
    
    -- Aimbot Hold mode release
    if Settings.Keybinds.Aimbot and Settings.Keybinds.Aimbot.Enabled and Settings.Keybinds.Aimbot.Mode == "Hold" and Settings.Aimbot then
        local keyMatch = false
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Settings.Keybinds.Aimbot.Key then
            keyMatch = true
        elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == Settings.Keybinds.Aimbot.Key then
            keyMatch = true
        end
        
        if keyMatch then
            Settings.AimbotActive = false
        end
    end
    
    -- Infinite Jump Hold mode release
    if Settings.Keybinds.InfiniteJump and Settings.Keybinds.InfiniteJump.Enabled and Settings.Keybinds.InfiniteJump.Mode == "Hold" and Settings.InfiniteJump then
        local keyMatch = false
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Settings.Keybinds.InfiniteJump.Key then
            keyMatch = true
        elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == Settings.Keybinds.InfiniteJump.Key then
            keyMatch = true
        end
        
        if keyMatch then
            Settings.InfiniteJumpActive = false
        end
    end
    
    -- Generic Hold mode release for all other functions
    local keybindFunctions = {
        "AimLock", "Prediction", "NoRecoil", "HealthBar", "TeamCheck", 
        "FilledBox", "BoxCorner", "Fullbright", "DebugPanel", "ShowKeylist",
        "LocalSkeleton", "LocalHighlight"
    }
    
    for _, funcName in ipairs(keybindFunctions) do
        local bind = Settings.Keybinds[funcName]
        if bind and bind.Enabled and bind.Mode == "Hold" and Settings[funcName] then
            local keyMatch = false
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == bind.Key then
                keyMatch = true
            elseif (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) and input.UserInputType == bind.Key then
                keyMatch = true
            end
            
            if keyMatch then
                local activeName = funcName .. "Active"
                Settings[activeName] = false
            end
        end
    end
end)

print("Sentinel v2.0 (Build 22.02.26) loaded!")

-- Auto-load config after everything is initialized
task.spawn(function()
    task.wait(3) -- Wait for UI to fully load
    local autoloadConfig = GetAutoloadConfig()
    if autoloadConfig then
        print("[Sentinel] Auto-loading config: " .. autoloadConfig)
        task.wait(0.5) -- Extra delay to ensure UI elements are ready
        LoadConfig(autoloadConfig)
    end
end)
