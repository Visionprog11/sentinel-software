-- ══════════════════════════════════════════════════════════
-- ESP Script + Simple Settings Menu
-- LocalScript | Insert = Toggle Menu
-- ══════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer
local sharedRayParams = RaycastParams.new()
sharedRayParams.FilterType = Enum.RaycastFilterType.Exclude
sharedRayParams.IgnoreWater = true
local HttpService = game:GetService("HttpService")

local function SafeRaycast(origin, target, params)
    local diff = target - origin
    local dist = diff.Magnitude
    if dist <= 5000 then
        return workspace:Raycast(origin, diff, params)
    end
    
    local dir = diff.Unit
    local cur = 0
    while cur < dist do
        local step = math.min(dist - cur, 5000)
        local res = workspace:Raycast(origin + dir * cur, dir * step, params)
        if res then return res end
        cur = cur + step
    end
    return nil
end

local StoredBinds = {} -- { [Name] = {Key = Enum.KeyCode, Mode = "Toggle"/"Hold", State = false, Callback = function } }
local currentlyBinding = nil -- Stores the name of the function being bound

-- ═══════════ CONFIG ═══════════
local CONFIG = {
    Enabled = false,
    MaxDistance = 500, -- Meters (1m = 3 studs)
    TeamCheck = false,

    BoxEnabled = false,
    BoxColor = Color3.fromRGB(0, 255, 0),

    SkeletonEnabled = false,
    SkeletonColor = Color3.fromRGB(255, 255, 255),

    PanelEnabled = false,
    PanelBgColor = Color3.fromRGB(25, 25, 30),

    ShowDistance = false,
    ShowName = false,
    ShowHealth = false,
    ShowAvatar = false,

    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(255, 255, 255),
    HeartColor = Color3.fromRGB(255, 60, 60),

    DeadESP = false,
    DeadESPColor = Color3.fromRGB(255, 0, 0),
    DeadESPDuration = 30,

    TracersEnabled = false,
    TracersColor = Color3.fromRGB(255, 255, 255),
    TracerOrigin = "Bottom", -- "Top", "Bottom", "Middle", "Mouse"

    HealthBarEnabled = false,

    VisibilityCheck = false,
    VisibleColor = Color3.fromRGB(0, 255, 0),
    HiddenColor = Color3.fromRGB(255, 0, 0),

    -- AIMBOT
    AimbotEnabled = false,
    AimbotSmoothness = 0.15,
    AimbotMaxDistance = 300, -- Meters
    AimbotFOV = 150,
    ShowFOV = false,
    FOVColor = Color3.fromRGB(255, 255, 255),
    AimbotTargetPart = "Head", -- "Head", "Torso", "Random"
    AimbotSticky = true, -- Locks onto target until it dies or goes out of FOV
    AimbotDistanceWeight = 0.3, -- Impact of distance vs FOV distance
    AimbotVisibleOnly = true, -- Only targets visible players
    
    PredictionEnabled = false,
    PredictionStrength = 10,
    NoRecoilEnabled = false,
    NoRecoilStrength = 50,

    ShowBindWindow = false,

    -- LOCAL PLAYER
    LocalPlayerESP = false,
    LocalPlayerColor = Color3.fromRGB(150, 150, 255),
    LocalBox = false,
    LocalBoxColor = Color3.fromRGB(150, 150, 255),
    LocalSkeleton = false,
    LocalSkeletonColor = Color3.fromRGB(255, 255, 255),
    LocalHealthBar = false,
    LocalTracers = false,
    LocalTracersColor = Color3.fromRGB(255, 255, 255),

    -- WORLD
    AmbienceEnabled = false,
    AmbienceColor = Color3.fromHex("ABABAB"),

    -- MENU
    MenuWidth = 880,
    MenuHeight = 750,

    -- MISC
    HighJumpEnabled = false,
    HighJumpValue = 50,

    -- SCOPE
    ScopeEnabled = false,
    ScopeColor = Color3.fromRGB(0, 255, 0),
    ScopeGap = 4,
    ScopeLength = 10,
    ScopeThickness = 1.5,
    ScopeCenterDot = false,
    ScopeOutline = true,
}

-- ═══════════ SKELETON MAP ═══════════
local BONES = {
    R15 = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        -- Arms
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        -- Legs
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    },
    R6 = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
}

-- ═══════════ UTILS ═══════════
local function tw(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ════════════════════════════════
-- MENU GUI
-- ════════════════════════════════
local menuOpen = false

local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "ESP_Menu"
MenuGui.ResetOnSpawn = false
MenuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MenuGui.IgnoreGuiInset = true
MenuGui.DisplayOrder = 100
MenuGui.Parent = LP:WaitForChild("PlayerGui")

-- Главная панель меню
-- Главная панель меню
local mainPanel = Instance.new("CanvasGroup")
mainPanel.Name = "Main"
mainPanel.Size = UDim2.new(0, CONFIG.MenuWidth, 0, CONFIG.MenuHeight)
mainPanel.Position = UDim2.new(0.5, -CONFIG.MenuWidth/2, 0.5, -CONFIG.MenuHeight/2)
mainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.GroupTransparency = 1
mainPanel.Parent = MenuGui

Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 55)
mainStroke.Thickness = 1
mainStroke.Parent = mainPanel

-- Сайдбар
-- Сайдбар
local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 210, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 4
sidebar.ScrollBarThickness = 0
sidebar.CanvasSize = UDim2.new(0,0,0,0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.Parent = mainPanel

-- Разделитель (вертикальный) - ВЫНЕСЕН ИЗ САЙДБАРА
local vSep = Instance.new("Frame")
vSep.Size = UDim2.new(0, 1, 1, -40)
vSep.Position = UDim2.new(0, 210, 0, 40)
vSep.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
vSep.BorderSizePixel = 0
vSep.ZIndex = 5
vSep.Parent = mainPanel

local sideLay = Instance.new("UIListLayout")
sideLay.Padding = UDim.new(0, 4) -- Увеличим отступ
sideLay.SortOrder = Enum.SortOrder.LayoutOrder
sideLay.Parent = sidebar

-- Контент
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -210, 1, -40)
content.Position = UDim2.new(0, 210, 0, 40)
content.BackgroundTransparency = 1
content.ZIndex = 2
content.Parent = mainPanel

-- ═══════════ PREVIEW PANEL ═══════════
-- ═══════════ PREVIEW PANEL ═══════════
local previewPanel = Instance.new("CanvasGroup")
previewPanel.Name = "ESPPreview"
previewPanel.Size = UDim2.new(0, 240, 0, 320)
previewPanel.Position = UDim2.new(1, 15, 0, 0)
previewPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
previewPanel.BorderSizePixel = 0
previewPanel.Visible = false
previewPanel.GroupTransparency = 1
previewPanel.ClipsDescendants = true
previewPanel.Parent = MenuGui 

Instance.new("UICorner", previewPanel).CornerRadius = UDim.new(0, 10)
local pStroke = Instance.new("UIStroke", previewPanel)
pStroke.Color = Color3.fromRGB(40, 40, 55)
pStroke.Thickness = 1

local pHeader = Instance.new("TextLabel", previewPanel)
pHeader.Size = UDim2.new(1, 0, 0, 40)
pHeader.BackgroundTransparency = 1
pHeader.Font = Enum.Font.GothamBold
pHeader.Text = "ESP PREVIEW"
pHeader.TextColor3 = Color3.fromRGB(150, 150, 165)
pHeader.TextSize = 11
pHeader.TextYAlignment = Enum.TextYAlignment.Bottom
pHeader.ZIndex = 2

local pVP = Instance.new("ViewportFrame", previewPanel)
pVP.Size = UDim2.new(1, 0, 1, 0)
pVP.BackgroundTransparency = 1
pVP.Ambient = Color3.fromRGB(150, 150, 150)
pVP.LightColor = Color3.fromRGB(255, 255, 255)
pVP.LightDirection = Vector3.new(-1, -1, -1)
pVP.ZIndex = 5

local pCam = Instance.new("Camera", pVP)
pCam.FieldOfView = 50
pVP.CurrentCamera = pCam

-- Mock ESP Elements for Preview
local pmBox = Instance.new("Frame", previewPanel)
pmBox.BackgroundTransparency = 1
pmBox.ZIndex = 12
local pmBoxStroke = Instance.new("UIStroke", pmBox)
pmBoxStroke.Thickness = 1.2

local pmSkeleton = Instance.new("Frame", previewPanel)
pmSkeleton.Size = UDim2.new(1, 0, 1, 0)
pmSkeleton.BackgroundTransparency = 1
pmSkeleton.ZIndex = 10

-- Skeleton Line Pool
local pmLines = {}
for i = 1, 32 do
    local l = Instance.new("Frame", pmSkeleton)
    l.BorderSizePixel = 0
    l.BackgroundColor3 = Color3.new(1,1,1)
    l.Visible = false
    l.ZIndex = 10 
    pmLines[i] = l
end

local pmHealthBar = Instance.new("Frame", previewPanel)
pmHealthBar.Size = UDim2.new(0, 4, 0, 280)
pmHealthBar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
pmHealthBar.BorderSizePixel = 0
pmHealthBar.ZIndex = 11
local pmHealthIn = Instance.new("Frame", pmHealthBar)
pmHealthIn.Size = UDim2.new(1, 0, 0.7, 0) -- 70% health
pmHealthIn.Position = UDim2.new(0, 0, 0.3, 0)
pmHealthIn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
pmHealthIn.BorderSizePixel = 0
Instance.new("UICorner", pmHealthBar).CornerRadius = UDim.new(0, 2)
Instance.new("UICorner", pmHealthIn).CornerRadius = UDim.new(0, 2)

local pmPanel = Instance.new("Frame", previewPanel)
pmPanel.AutomaticSize = Enum.AutomaticSize.X
pmPanel.Size = UDim2.new(0, 0, 0, 28)
pmPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
pmPanel.BorderSizePixel = 0
pmPanel.ZIndex = 15 -- Way above
Instance.new("UICorner", pmPanel).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", pmPanel).Color = Color3.fromRGB(45, 45, 55)

local pmPanelLay = Instance.new("UIListLayout", pmPanel)
pmPanelLay.FillDirection = Enum.FillDirection.Horizontal
pmPanelLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
pmPanelLay.VerticalAlignment = Enum.VerticalAlignment.Center
pmPanelLay.SortOrder = Enum.SortOrder.LayoutOrder
pmPanelLay.Padding = UDim.new(0, 8)
Instance.new("UIPadding", pmPanel).PaddingLeft = UDim.new(0, 10)
Instance.new("UIPadding", pmPanel).PaddingRight = UDim.new(0, 10)

local pmDist = Instance.new("TextLabel", pmPanel)
pmDist.BackgroundTransparency = 1
pmDist.Font = Enum.Font.GothamMedium
pmDist.Text = "142m"
pmDist.TextColor3 = Color3.new(1,1,1)
pmDist.TextSize = 12
pmDist.TextXAlignment = Enum.TextXAlignment.Center
pmDist.TextYAlignment = Enum.TextYAlignment.Center
pmDist.AutomaticSize = Enum.AutomaticSize.XY
pmDist.LayoutOrder = 1

local pmDiv1 = Instance.new("Frame", pmPanel)
pmDiv1.Size = UDim2.new(0, 1, 0, 12)
pmDiv1.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
pmDiv1.BackgroundTransparency = 0.5
pmDiv1.BorderSizePixel = 0
pmDiv1.LayoutOrder = 2

local pmName = Instance.new("TextLabel", pmPanel)
pmName.BackgroundTransparency = 1
pmName.Font = Enum.Font.GothamMedium
pmName.Text = "Enemy"
pmName.TextColor3 = Color3.new(1,1,1)
pmName.TextSize = 12
pmName.TextXAlignment = Enum.TextXAlignment.Center
pmName.TextYAlignment = Enum.TextYAlignment.Center
pmName.AutomaticSize = Enum.AutomaticSize.XY
pmName.LayoutOrder = 3

local pmDiv2 = Instance.new("Frame", pmPanel)
pmDiv2.Size = UDim2.new(0, 1, 0, 12)
pmDiv2.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
pmDiv2.BackgroundTransparency = 0.5
pmDiv2.BorderSizePixel = 0
pmDiv2.LayoutOrder = 4

local pmAv = Instance.new("ImageLabel", pmPanel)
pmAv.Size = UDim2.new(0, 16, 0, 16)
pmAv.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
pmAv.Image = "rbxassetid://6034502931"
Instance.new("UICorner", pmAv).CornerRadius = UDim.new(0, 4)
pmAv.LayoutOrder = 5

local pmDiv3 = Instance.new("Frame", pmPanel)
pmDiv3.Size = UDim2.new(0, 1, 0, 12)
pmDiv3.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
pmDiv3.BackgroundTransparency = 0.5
pmDiv3.BorderSizePixel = 0
pmDiv3.LayoutOrder = 6

local pmHP = Instance.new("TextLabel", pmPanel)
pmHP.BackgroundTransparency = 1
pmHP.Font = Enum.Font.GothamMedium
pmHP.Text = "♥ 100"
pmHP.TextColor3 = Color3.new(1,1,1)
pmHP.TextSize = 12
pmHP.TextXAlignment = Enum.TextXAlignment.Center
pmHP.TextYAlignment = Enum.TextYAlignment.Center
pmHP.AutomaticSize = Enum.AutomaticSize.XY
pmHP.LayoutOrder = 7


local dummyPartsData = {
    Head = {s = Vector3.new(1, 1, 1), p = Vector3.new(0, 2.5, 0)},
    UpperTorso = {s = Vector3.new(1.8, 1.4, 0.9), p = Vector3.new(0, 1.35, 0)},
    LowerTorso = {s = Vector3.new(1.8, 0.7, 0.9), p = Vector3.new(0, 0.35, 0)},
    
    -- Arms (relaxed pose)
    LeftUpperArm = {s = Vector3.new(0.8, 1.2, 0.8), p = Vector3.new(-1.3, 1.45, 0)},
    LeftLowerArm = {s = Vector3.new(0.8, 1.2, 0.8), p = Vector3.new(-1.5, 0.3, 0)},
    LeftHand = {s = Vector3.new(0.7, 0.7, 0.7), p = Vector3.new(-1.6, -0.6, 0)},
    
    RightUpperArm = {s = Vector3.new(0.8, 1.2, 0.8), p = Vector3.new(1.3, 1.45, 0)},
    RightLowerArm = {s = Vector3.new(0.8, 1.2, 0.8), p = Vector3.new(1.5, 0.3, 0)},
    RightHand = {s = Vector3.new(0.7, 0.7, 0.7), p = Vector3.new(1.6, -0.6, 0)},
    
    -- Legs (natural stance)
    LeftUpperLeg = {s = Vector3.new(0.8, 1.2, 0.8), p = Vector3.new(-0.55, -0.6, 0)},
    LeftLowerLeg = {s = Vector3.new(0.8, 1.2, 0.8), p = Vector3.new(-0.7, -1.8, 0)},
    LeftFoot = {s = Vector3.new(0.9, 0.6, 1), p = Vector3.new(-0.8, -2.7, 0)},
    
    RightUpperLeg = {s = Vector3.new(0.8, 1.2, 0.8), p = Vector3.new(0.55, -0.6, 0)},
    RightLowerLeg = {s = Vector3.new(0.8, 1.2, 0.8), p = Vector3.new(0.7, -1.8, 0)},
    RightFoot = {s = Vector3.new(0.9, 0.6, 1), p = Vector3.new(0.8, -2.7, 0)},
    
    HumanoidRootPart = {s = Vector3.new(2, 2, 1), p = Vector3.new(0, 0, 0), t = 1}
}


local function createDummy()
    local m = Instance.new("Model")
    m.Name = "PreviewDummy"
    
    for name, data in pairs(dummyPartsData) do
        local p = Instance.new("Part")
        p.Name = name
        p.Size = data.s
        p.Position = data.p
        p.Transparency = 1 
        p.Color = Color3.fromRGB(100, 100, 120)
        p.Anchored = true
        p.CanCollide = false
        p.Parent = m
    end
    
    local hum = Instance.new("Humanoid", m)
    hum.RigType = Enum.HumanoidRigType.R15
    m.PrimaryPart = m.HumanoidRootPart
    m:PivotTo(CFrame.new(0, -0.4, 0)) -- Adjusted for shorter panel
    return m
end

local pCharClone
local function initPreview()
    -- Clear only dummies, keep camera
    for _, obj in ipairs(pVP:GetChildren()) do
        if obj:IsA("Model") then obj:Destroy() end
    end
    pCharClone = createDummy()
    pCharClone.Parent = pVP
    pVP.CurrentCamera = pCam
    pCam.CFrame = CFrame.new(Vector3.new(0, 0, 10), Vector3.new(0, 0, 0))
end

task.spawn(function()
    while task.wait() do
        if not previewPanel.Visible or not pCharClone then continue end

        local pW, pH = 240, 440
        local absSize = pVP.AbsoluteSize
        if absSize.X > 10 then 
            pW, pH = absSize.X, absSize.Y
        end


        -- Manual Projection for Preview
        local function project(v3)
            local rel = pCam.CFrame:PointToObjectSpace(v3)
            if rel.Z >= 0 then return nil end -- Behind camera
            
            local fov = math.rad(pCam.FieldOfView)
            local h = math.tan(fov / 2) * math.abs(rel.Z) * 1.1 -- Slightly zoomed to keep size
            local w = h * (pW / pH)
            
            return Vector2.new(
                (rel.X / w) * 0.5 + 0.5,
                (-rel.Y / h) * 0.5 + 0.5
            ) * Vector2.new(pW, pH)
        end

        local centerX, centerY = pW/2, pH/2 + 30 -- Re-centered for shorter panel
        
        -- Static Dummy Positioning (No Animation)
        for _, p in ipairs(pCharClone:GetChildren()) do
            if p:IsA("BasePart") then
                local data = dummyPartsData[p.Name]
                if data then
                    -- Position is relative to the dummy model, which is lowered to (0, -1.2, 0)
                    p.Position = data.p + Vector3.new(0, -1.2, 0)
                end
            end
        end
        
        -- Skeleton Projection
        pmSkeleton.Visible = CONFIG.SkeletonEnabled
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        local allOff = true

        if CONFIG.SkeletonEnabled then
            local lineIdx = 1
            for _, pair in pairs(BONES.R15) do
                local p1 = pCharClone:FindFirstChild(pair[1])
                local p2 = pCharClone:FindFirstChild(pair[2])
                local l = pmLines[lineIdx]
                if p1 and p2 and l then
                    local s1 = project(p1.Position)
                    local s2 = project(p2.Position)
                    
                    if s1 and s2 then
                        l.Visible = true
                        l.ZIndex = 20
                        local dist = (s1 - s2).Magnitude
                        
                        l.Size = UDim2.new(0, 2.5, 0, dist)
                        l.Position = UDim2.new(0, (s1.X + s2.X)/2, 0, (s1.Y + s2.Y)/2)
                        l.Rotation = math.deg(math.atan2(s2.Y - s1.Y, s2.X - s1.X)) - 90
                        l.AnchorPoint = Vector2.new(0.5, 0.5)
                        l.BackgroundColor3 = CONFIG.SkeletonColor
                        l.BackgroundTransparency = 0
                        
                        minX = math.min(minX, s1.X, s2.X)
                        minY = math.min(minY, s1.Y, s2.Y)
                        maxX = math.max(maxX, s1.X, s2.X)
                        maxY = math.max(maxY, s1.Y, s2.Y)
                        allOff = false
                    else
                        l.Visible = false
                    end
                end
                lineIdx = lineIdx + 1
            end
            for i = lineIdx, #pmLines do if pmLines[i] then pmLines[i].Visible = false end end
        end

        -- Calculate Box based on Dummy (Head to Feet) for stability
        local headPart = pCharClone:FindFirstChild("Head")
        local lFoot = pCharClone:FindFirstChild("LeftFoot")
        local rFoot = pCharClone:FindFirstChild("RightFoot")
        
        local hProj = headPart and project(headPart.Position + Vector3.new(0, 0.8, 0))
        local fProj = lFoot and rFoot and project((lFoot.Position + rFoot.Position)/2 - Vector3.new(0, 0.5, 0))
        
        if hProj and fProj then
            local bH = math.abs(hProj.Y - fProj.Y)
            local bW = bH * 0.6
            minX, minY = hProj.X - bW/2, hProj.Y
            maxX, maxY = hProj.X + bW/2, fProj.Y
            allOff = false
        else
            -- Stable Fallback
            local bH, bW = 290, 170
            minX, minY = centerX - bW/2, centerY - bH*0.45
            maxX, maxY = centerX + bW/2, centerY + bH*0.55
        end

        local boxW, boxH = maxX - minX, maxY - minY
        local boxPosX, boxPosY = (minX + maxX)/2, (minY + maxY)/2

        -- Box
        pmBox.Size = UDim2.new(0, boxW, 0, boxH)
        pmBox.Position = UDim2.new(0, boxPosX - boxW/2, 0, boxPosY - boxH/2)
        pmBox.Visible = CONFIG.BoxEnabled
        pmBoxStroke.Color = CONFIG.BoxColor

        -- Health Bar
        pmHealthBar.Size = UDim2.new(0, 3, 0, boxH)
        pmHealthBar.Position = UDim2.new(0, boxPosX - boxW/2 - 8, 0, boxPosY - boxH/2)
        pmHealthBar.Visible = CONFIG.HealthBarEnabled
        
        local hProg = (math.sin(tick()*2)*0.5 + 0.5)
        pmHealthIn.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 100), hProg)
        pmHealthIn.Size = UDim2.new(1, 0, hProg, 0)
        pmHealthIn.Position = UDim2.new(0, 0, 1 - hProg, 0)

        -- Panel
        pmPanel.AnchorPoint = Vector2.new(0.5, 1)
        pmPanel.Position = UDim2.new(0, boxPosX, 0, boxPosY - boxH/2 - 10)
        pmPanel.Visible = CONFIG.PanelEnabled and (CONFIG.ShowDistance or CONFIG.ShowAvatar or CONFIG.ShowName or CONFIG.ShowHealth)
        pmPanel.BackgroundColor3 = CONFIG.PanelBgColor
    end
end)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainPanel
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 10)
tbFix.Position = UDim2.new(0, 0, 1, -10)
tbFix.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar

-- Лого
local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 30, 0, 22)
logo.Position = UDim2.new(0, 12, 0.5, -11)
logo.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
logo.BorderSizePixel = 0
logo.Parent = titleBar
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 4)

local logoTxt = Instance.new("TextLabel")
logoTxt.Size = UDim2.new(1, 0, 1, 0)
logoTxt.BackgroundTransparency = 1
logoTxt.Font = Enum.Font.GothamBlack
logoTxt.TextColor3 = Color3.new(1, 1, 1)
logoTxt.TextSize = 11
logoTxt.Text = "ESP"
logoTxt.Parent = logo

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 150, 1, 0)
titleLbl.Position = UDim2.new(0, 50, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
titleLbl.TextSize = 18 -- Увеличено
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Text = "NEVERLOSE"
titleLbl.Parent = titleBar

-- ════════════ FLOATING PICKER ════════════
local pickerPanel = Instance.new("CanvasGroup")
pickerPanel.Size = UDim2.new(0, 200, 0, 220)
pickerPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
pickerPanel.BorderSizePixel = 0
pickerPanel.Visible = false
pickerPanel.Active = true
pickerPanel.ZIndex = 20 -- Increased ZIndex
pickerPanel.Parent = MenuGui

local pickerBlocker = Instance.new("TextButton", pickerPanel)
pickerBlocker.Size = UDim2.new(1, 0, 1, 0)
pickerBlocker.BackgroundTransparency = 1
pickerBlocker.Text = ""
pickerBlocker.ZIndex = -1

Instance.new("UICorner", pickerPanel).CornerRadius = UDim.new(0, 8)
local pickerStroke = Instance.new("UIStroke", pickerPanel)
pickerStroke.Color = Color3.fromRGB(50, 50, 65)
pickerStroke.Transparency = 1

local pickerScale = Instance.new("UIScale", pickerPanel)
pickerScale.Scale = 0.8
pickerPanel.GroupTransparency = 1

local svSquare = Instance.new("Frame")
svSquare.Size = UDim2.new(1, -16, 0, 140)
svSquare.Position = UDim2.new(0, 8, 0, 8)
svSquare.BorderSizePixel = 0
svSquare.Parent = pickerPanel
Instance.new("UICorner", svSquare).CornerRadius = UDim.new(0, 4)

local whiteG = Instance.new("Frame")
whiteG.Size = UDim2.new(1, 0, 1, 0)
whiteG.BorderSizePixel = 0
whiteG.Parent = svSquare
Instance.new("UICorner", whiteG).CornerRadius = UDim.new(0, 4)
local wg = Instance.new("UIGradient")
wg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
wg.Color = ColorSequence.new(Color3.new(1,1,1))
wg.Parent = whiteG

local blackG = Instance.new("Frame")
blackG.Size = UDim2.new(1, 0, 1, 0)
blackG.BorderSizePixel = 0
blackG.Parent = svSquare
Instance.new("UICorner", blackG).CornerRadius = UDim.new(0, 4)
local bg = Instance.new("UIGradient")
bg.Rotation = 90
bg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})
bg.Color = ColorSequence.new(Color3.new(0,0,0))
bg.Parent = blackG

local svCursor = Instance.new("Frame")
svCursor.Size = UDim2.new(0, 6, 0, 6)
svCursor.BackgroundColor3 = Color3.new(1,1,1)
svCursor.Parent = svSquare
Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", svCursor).Thickness = 1

local hueSlider = Instance.new("Frame")
hueSlider.Size = UDim2.new(1, -16, 0, 14)
hueSlider.Position = UDim2.new(0, 8, 0, 156)
hueSlider.BorderSizePixel = 0
hueSlider.Parent = pickerPanel
Instance.new("UICorner", hueSlider).CornerRadius = UDim.new(1,0)

local hg = Instance.new("UIGradient")
hg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1,0,0)),
    ColorSequenceKeypoint.new(0.16, Color3.new(1,1,0)),
    ColorSequenceKeypoint.new(0.33, Color3.new(0,1,0)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0,1,1)),
    ColorSequenceKeypoint.new(0.66, Color3.new(0,0,1)),
    ColorSequenceKeypoint.new(0.83, Color3.new(1,0,1)),
    ColorSequenceKeypoint.new(1, Color3.new(1,0,0))
})
hg.Parent = hueSlider

local hCursor = Instance.new("Frame")
hCursor.Size = UDim2.new(0, 4, 1, 4)
hCursor.Position = UDim2.new(0, 0, 0.5, 0)
hCursor.AnchorPoint = Vector2.new(0.5, 0.5)
hCursor.BackgroundColor3 = Color3.new(1,1,1)
hCursor.Parent = hueSlider
Instance.new("UICorner", hCursor).CornerRadius = UDim.new(0,2)

local hexDisp = Instance.new("TextLabel")
hexDisp.Size = UDim2.new(1, 0, 0, 30)
hexDisp.Position = UDim2.new(0, 0, 0, 180)
hexDisp.BackgroundTransparency = 1
hexDisp.Font = Enum.Font.Code
hexDisp.TextColor3 = Color3.new(0.7, 0.7, 0.7)
hexDisp.TextSize = 12
hexDisp.Parent = pickerPanel

-- ════════════ SUBSETTINGS PANEL ════════════
local subPanel = Instance.new("CanvasGroup")
subPanel.Size = UDim2.new(0, 250, 0, 240)
subPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
subPanel.BorderSizePixel = 0
subPanel.Visible = false
subPanel.Active = true
subPanel.ZIndex = 20 -- Increased ZIndex
subPanel.Parent = MenuGui

local subBlocker = Instance.new("TextButton", subPanel)
subBlocker.Size = UDim2.new(1, 0, 1, 0)
subBlocker.BackgroundTransparency = 1
subBlocker.Text = ""
subBlocker.ZIndex = -1

Instance.new("UICorner", subPanel).CornerRadius = UDim.new(0, 8)
local subStroke = Instance.new("UIStroke", subPanel)
subStroke.Color = Color3.fromRGB(50, 50, 65)
subStroke.Transparency = 1 -- Старт с прозрачности

local subScale = Instance.new("UIScale", subPanel)
subScale.Scale = 0.8
subPanel.GroupTransparency = 1

local subScroll = Instance.new("ScrollingFrame")
subScroll.Size = UDim2.new(1, -16, 1, -16)
subScroll.Position = UDim2.new(0, 8, 0, 8)
subScroll.BackgroundTransparency = 1
subScroll.BorderSizePixel = 0
subScroll.ScrollBarThickness = 2
subScroll.CanvasSize = UDim2.new(0,0,0,0)
subScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
subScroll.Parent = subPanel
local subLay = Instance.new("UIListLayout")
subLay.Padding = UDim.new(0, 4)
subLay.Parent = subScroll

-- ════════════ BIND PANEL ════════════
local bindPanel = Instance.new("CanvasGroup")
bindPanel.Size = UDim2.new(0, 180, 0, 140)
bindPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
bindPanel.BorderSizePixel = 0
bindPanel.Visible = false
bindPanel.Active = true
bindPanel.ZIndex = 25
bindPanel.Parent = MenuGui

local bindBlocker = Instance.new("TextButton", bindPanel)
bindBlocker.Size = UDim2.new(1, 0, 1, 0)
bindBlocker.BackgroundTransparency = 1
bindBlocker.Text = ""
bindBlocker.ZIndex = -1

Instance.new("UICorner", bindPanel).CornerRadius = UDim.new(0, 8)
local bindStroke = Instance.new("UIStroke", bindPanel)
bindStroke.Color = Color3.fromRGB(60, 60, 80)
bindStroke.Thickness = 1

local bindScale = Instance.new("UIScale", bindPanel)
bindScale.Scale = 0.8
bindPanel.GroupTransparency = 1

-- ════════════ BIND LIST UI ════════════
local bindListWindow = Instance.new("CanvasGroup")
bindListWindow.Name = "BindList"
bindListWindow.Size = UDim2.new(0, 150, 0, 30)
bindListWindow.Position = UDim2.new(0.02, 0, 0.4, 0)
bindListWindow.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
bindListWindow.Visible = false
bindListWindow.ZIndex = 5
bindListWindow.Parent = MenuGui
Instance.new("UICorner", bindListWindow).CornerRadius = UDim.new(0, 6)
local blStroke = Instance.new("UIStroke", bindListWindow)
blStroke.Color = Color3.fromRGB(40, 40, 50)
blStroke.Thickness = 1

local blHeader = Instance.new("Frame", bindListWindow)
blHeader.Size = UDim2.new(1, 0, 0, 24)
blHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
blHeader.BorderSizePixel = 0

local blIcon = Instance.new("ImageLabel", blHeader)
blIcon.Size = UDim2.new(0, 14, 0, 14)
blIcon.Position = UDim2.new(0, 6, 0.5, -7)
blIcon.BackgroundTransparency = 1
blIcon.Image = "rbxassetid://6034440156"
blIcon.ImageColor3 = Color3.fromRGB(70, 110, 255)

local blTitle = Instance.new("TextLabel", blHeader)
blTitle.Size = UDim2.new(1, -26, 1, 0)
blTitle.Position = UDim2.new(0, 24, 0, 0)
blTitle.BackgroundTransparency = 1
blTitle.Font = Enum.Font.GothamBold
blTitle.Text = "Binds"
blTitle.TextColor3 = Color3.new(1, 1, 1)
blTitle.TextSize = 12
blTitle.TextXAlignment = Enum.TextXAlignment.Left

local blContainer = Instance.new("Frame", bindListWindow)
blContainer.Size = UDim2.new(1, 0, 1, -24)
blContainer.Position = UDim2.new(0, 0, 0, 24)
blContainer.BackgroundTransparency = 1

local blLay = Instance.new("UIListLayout", blContainer)
blLay.Padding = UDim.new(0, 2)
blLay.SortOrder = Enum.SortOrder.LayoutOrder

local function updateBindList()
    -- Clear current list but preserve layout
    for _, child in ipairs(blContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    if not CONFIG.ShowBindWindow then 
        bindListWindow.Visible = false
        return 
    end
    
    local count = 0
    for name, b in pairs(StoredBinds) do
        if b.Key or b.InputType then
            count = count + 1
            local f = Instance.new("Frame", blContainer)
            f.Size = UDim2.new(1, 0, 0, 20)
            f.BackgroundTransparency = 1
            
            local n = Instance.new("TextLabel", f)
            n.Size = UDim2.new(1, -40, 1, 0)
            n.Position = UDim2.new(0, 8, 0, 0)
            n.BackgroundTransparency = 1
            n.Font = Enum.Font.GothamMedium
            n.Text = name
            n.TextColor3 = Color3.fromRGB(200, 200, 210)
            n.TextSize = 11
            n.TextXAlignment = Enum.TextXAlignment.Left
            
            local s = Instance.new("TextLabel", f)
            s.Size = UDim2.new(0, 35, 1, 0)
            s.Position = UDim2.new(1, -40, 0, 0)
            s.BackgroundTransparency = 1
            s.Font = Enum.Font.GothamBold
            s.Text = b.State and "on" or "off"
            s.TextColor3 = b.State and Color3.new(1, 1, 1) or Color3.fromRGB(100, 100, 110)
            s.TextSize = 10
            s.TextXAlignment = Enum.TextXAlignment.Right
        end
    end
    
    if count > 0 then
        bindListWindow.Visible = true
        tw(bindListWindow, {Size = UDim2.new(0, 150, 0, 28 + (count * 22))}, 0.2)
    else
        bindListWindow.Visible = false
    end
end

-- Dragging for Bind List
local blDragging, blDragStart, blStartPos
bindListWindow.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        blDragging = true
        blDragStart = i.Position
        blStartPos = bindListWindow.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if blDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - blDragStart
        bindListWindow.Position = UDim2.new(blStartPos.X.Scale, blStartPos.X.Offset + delta.X, blStartPos.Y.Scale, blStartPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then blDragging = false end
end)

local bindTitle = Instance.new("TextLabel", bindPanel)
bindTitle.Size = UDim2.new(1, 0, 0, 30)
bindTitle.BackgroundTransparency = 1
bindTitle.Font = Enum.Font.GothamBold
bindTitle.TextColor3 = Color3.fromRGB(150, 150, 170)
bindTitle.TextSize = 11
bindTitle.Text = "ASSIGN KEYBIND"

local bindKeyBtn = Instance.new("TextButton", bindPanel)
bindKeyBtn.Size = UDim2.new(1, -20, 0, 32)
bindKeyBtn.Position = UDim2.new(0, 10, 0, 35)
bindKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
bindKeyBtn.Font = Enum.Font.GothamBold
bindKeyBtn.Text = "NONE"
bindKeyBtn.TextColor3 = Color3.fromRGB(70, 110, 255)
bindKeyBtn.TextSize = 13
Instance.new("UICorner", bindKeyBtn).CornerRadius = UDim.new(0, 6)

local bindDropdown = Instance.new("Frame", bindPanel)
bindDropdown.Size = UDim2.new(1, -20, 0, 32)
bindDropdown.Position = UDim2.new(0, 10, 0, 72)
bindDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Instance.new("UICorner", bindDropdown).CornerRadius = UDim.new(0, 6)

local bindModeBtn = Instance.new("TextButton", bindDropdown)
bindModeBtn.Name = "ModeButton"
bindModeBtn.Size = UDim2.new(1, 0, 1, 0)
bindModeBtn.BackgroundTransparency = 1
bindModeBtn.Font = Enum.Font.GothamMedium
bindModeBtn.Text = "MODE: TOGGLE"
bindModeBtn.TextColor3 = Color3.new(1, 1, 1)
bindModeBtn.TextSize = 12

local bindDropList = Instance.new("CanvasGroup", bindPanel)
bindDropList.Size = UDim2.new(0, 160, 0, 0)
bindDropList.Position = UDim2.new(0, 10, 0, 106)
bindDropList.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
bindDropList.Visible = false
bindDropList.ZIndex = 30 -- High ZIndex to be above blockers
Instance.new("UICorner", bindDropList).CornerRadius = UDim.new(0, 6)
local bdStroke = Instance.new("UIStroke", bindDropList)
bdStroke.Color = Color3.fromRGB(50, 50, 70)

local bdLay = Instance.new("UIListLayout", bindDropList)

local function createModeOpt(name)
    local b = Instance.new("TextButton", bindDropList)
    b.Name = "Option" .. name
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundTransparency = 1
    b.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
    b.Font = Enum.Font.GothamMedium
    b.Text = name
    b.TextColor3 = Color3.fromRGB(200, 200, 210)
    b.TextSize = 12
    b.ZIndex = 35
    b.Active = true
    
    b.MouseButton1Click:Connect(function()
        if currentlyBinding then
            local bObj = StoredBinds[currentlyBinding] or {State = false, Mode = "Toggle"}
            bObj.Mode = name
            StoredBinds[currentlyBinding] = bObj
            
            -- Immediate UI Update
            bindModeBtn.Text = "MODE: " .. string.upper(name)
            updateBindPanel(currentlyBinding)
            updateBindList()
            
            tw(bindDropList, {Size = UDim2.new(1, 0, 0, 0), GroupTransparency = 1}, 0.2).Completed:Connect(function()
                bindDropList.Visible = false
            end)
            tw(bindPanel, {Size = UDim2.new(0, 180, 0, 140)}, 0.2)
        end
    end)

    b.MouseEnter:Connect(function()
        tw(b, {BackgroundTransparency = 0.85, TextColor3 = Color3.new(1, 1, 1)}, 0.15)
    end)
    b.MouseLeave:Connect(function()
        if currentlyBinding and StoredBinds[currentlyBinding] and StoredBinds[currentlyBinding].Mode == name then
             return -- Keep highlight if selected
        end
        tw(b, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 200, 210)}, 0.15)
    end)
end
createModeOpt("Toggle")
createModeOpt("Hold")

local bindClearBtn = Instance.new("TextButton", bindPanel)
bindClearBtn.Size = UDim2.new(1, -20, 0, 24)
bindClearBtn.Position = UDim2.new(0, 10, 0, 110)
bindClearBtn.BackgroundTransparency = 1
bindClearBtn.Font = Enum.Font.GothamMedium
bindClearBtn.Text = "CLEAR BIND"
bindClearBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
bindClearBtn.TextSize = 11

-- ════════════ POPUP LOGIC ════════════

local ph, ps, pv = 0, 0, 0
local pCallback = nil
local activePopup = nil -- Храним текущую открытую панель (pickerPanel или subPanel)
local activeSource = nil

local function closePopup(panel, scale)
    if not panel or not panel.Visible then return end
    tw(scale or panel:FindFirstChildOfClass("UIScale"), {Scale = 0.8}, 0.15)
    tw(panel, {GroupTransparency = 1}, 0.1)
    
    local str = panel:FindFirstChildOfClass("UIStroke")
    if str then tw(str, {Transparency = 1}, 0.1) end
    
    task.wait(0.12)
    panel.Visible = false
end

local previousPopup = nil
local function openPopup(panel, scale)
    if activePopup and activePopup ~= panel then
        if activePopup == subPanel and panel == pickerPanel then
            previousPopup = activePopup
        else
            local oldPanel = activePopup
            local oldScale = (oldPanel == pickerPanel) and pickerScale or (oldPanel == bindPanel and bindScale or subScale)
            task.spawn(function() closePopup(oldPanel, oldScale) end)
            previousPopup = nil
        end
    end
    
    activePopup = panel
    local mPos = UIS:GetMouseLocation()
    panel.Position = UDim2.new(0, mPos.X + 15, 0, mPos.Y - 20)
    
    -- Коррекция границ
    local screen = MenuGui.AbsoluteSize
    if panel.Position.X.Offset + panel.Size.X.Offset > screen.X then
        panel.Position = UDim2.new(0, mPos.X - panel.Size.X.Offset - 15, 0, mPos.Y - 20)
    end

    panel.Visible = true
    panel.GroupTransparency = 1
    scale.Scale = 0.85
    
    local str = panel:FindFirstChildOfClass("UIStroke")
    if str then 
        str.Transparency = 1
        task.delay(0.05, function() tw(str, {Transparency = 0}, 0.25) end) -- Небольшая задержка для красоты
    end
    
    tw(panel, {GroupTransparency = 0}, 0.25)
    tw(scale, {Scale = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

-- ════════════ BIND LOGIC ════════════
local isTrackingKey = false
local function updateBindPanel(name)
    local b = StoredBinds[name]
    local currentMode = (b and b.Mode) or "Toggle"
    
    -- Update Main Label
    bindModeBtn.Text = "MODE: " .. string.upper(currentMode)
    bindModeBtn.TextColor3 = Color3.new(1, 1, 1)

    if b and (b.Key or b.InputType) then
        local keyName = b.Key and b.Key.Name:upper() or (b.InputType and b.InputType.Name:upper() or "NONE")
        bindKeyBtn.Text = keyName
        bindClearBtn.Visible = true
    else
        bindKeyBtn.Text = "NONE"
        bindClearBtn.Visible = false
    end

    -- Highlight the active mode in the dropdown
    for _, child in ipairs(bindDropList:GetChildren()) do
        if child:IsA("TextButton") and child.Name:match("^Option") then
            local modeName = child.Name:gsub("^Option", "")
            if modeName == currentMode then
                tw(child, {BackgroundTransparency = 0.85, TextColor3 = Color3.new(1, 1, 1)}, 0.15)
            else
                tw(child, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 200, 210)}, 0.15)
            end
        end
    end
end

bindKeyBtn.MouseButton1Click:Connect(function()
    isTrackingKey = true
    bindKeyBtn.Text = "..."
    bindKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

bindModeBtn.MouseButton1Click:Connect(function()
    local isOpen = bindDropList.Visible
    if not isOpen then
        bindDropList.Visible = true
        bindDropList.GroupTransparency = 1
        updateBindPanel(currentlyBinding) -- Refresh highlights
        tw(bindDropList, {Size = UDim2.new(1, 0, 0, 60), GroupTransparency = 0}, 0.2)
        tw(bindPanel, {Size = UDim2.new(0, 180, 0, 200)}, 0.2)
    else
        tw(bindDropList, {Size = UDim2.new(1, 0, 0, 0), GroupTransparency = 1}, 0.2).Completed:Connect(function()
            if not bindDropList.Visible then bindDropList.Visible = false end -- Extra safety
            bindDropList.Visible = false
        end)
        tw(bindPanel, {Size = UDim2.new(0, 180, 0, 140)}, 0.2)
    end
end)

bindClearBtn.MouseButton1Click:Connect(function()
    if currentlyBinding then
        StoredBinds[currentlyBinding] = nil
        updateBindPanel(currentlyBinding)
        closePopup(bindPanel, bindScale)
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    -- 1. Priority: Capture Key/Mouse for binding
    if isTrackingKey then
        -- Check if user is clicking ON the bind panel itself
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            local p = input.Position
            local objects = LP.PlayerGui:GetGuiObjectsAtPosition(p.X, p.Y)
            for _, obj in ipairs(objects) do
                if obj:IsDescendantOf(bindPanel) or obj == bindPanel then
                    return -- Let the UI buttons handle the click (for Mode dropdown etc)
                end
            end
        end

        if input.UserInputType == Enum.UserInputType.Keyboard or 
           input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.MouseButton2 or 
           input.UserInputType == Enum.UserInputType.MouseButton3 then
            
            isTrackingKey = false
            local key = input.KeyCode
            local it = input.UserInputType
            
            -- ESC to clear
            if key == Enum.KeyCode.Escape then
                bindKeyBtn.Text = "NONE"
                if currentlyBinding then StoredBinds[currentlyBinding] = nil end
            else
                local keyName = (key ~= Enum.KeyCode.Unknown) and key.Name:upper() or it.Name:upper()
                bindKeyBtn.Text = keyName
                if currentlyBinding then
                    StoredBinds[currentlyBinding] = StoredBinds[currentlyBinding] or {Mode = "Toggle", State = false}
                    StoredBinds[currentlyBinding].Key = (key ~= Enum.KeyCode.Unknown) and key or nil
                    StoredBinds[currentlyBinding].InputType = it
                    updateBindPanel(currentlyBinding)
                end
            end
            
            bindKeyBtn.TextColor3 = Color3.fromRGB(70, 110, 255)
            updateBindList()
            return -- Important: stop here so we don't trigger "outside click" or other logic
        end
    end

    -- 2. Close popups on outside click
    if input.UserInputType == Enum.UserInputType.MouseButton1 and activePopup and activePopup.Visible then
        local p = input.Position
        local objects = LP.PlayerGui:GetGuiObjectsAtPosition(p.X, p.Y)
        local isOver = false
        
        for _, obj in ipairs(objects) do
            if obj:IsDescendantOf(activePopup) or obj == activePopup then
                isOver = true
                break
            end
        end
        
        if not isOver then
            -- Layered popup check
            if previousPopup and previousPopup.Visible then
                local overPrev = false
                for _, obj in ipairs(objects) do
                    if obj:IsDescendantOf(previousPopup) or obj == previousPopup then
                        overPrev = true
                        break
                    end
                end
                if overPrev then
                    local p = activePopup
                    local s = (p == pickerPanel) and pickerScale or (p == bindPanel and bindScale or subScale)
                    task.spawn(function() closePopup(p, s) end)
                    activePopup = previousPopup
                    previousPopup = nil
                    return
                end
            end

            -- Double check we aren't clicking the button that just opened this
            local oldPanel = activePopup
            local oldScale = (oldPanel == pickerPanel) and pickerScale or (oldPanel == bindPanel and bindScale or subScale)
            task.spawn(function() closePopup(oldPanel, oldScale) end)
            
            if previousPopup then
                local p = previousPopup
                local s = (p == bindPanel) and bindScale or subScale
                task.spawn(function() closePopup(p, s) end)
                previousPopup = nil
            end
            
            activePopup = nil
            return
        end
    end

    if gp then return end
    
    -- 3. Process Active Binds
    local changed = false
    for name, b in pairs(StoredBinds) do
        local isTriggered = false
        if name == "Aimbot" then -- Special handling for Aimbot
            isTriggered = (input.UserInputType == Enum.UserInputType.MouseButton2)
        elseif b.Key and b.Key ~= Enum.KeyCode.Unknown then
            isTriggered = (input.KeyCode == b.Key)
        elseif b.InputType then
            isTriggered = (input.UserInputType == b.InputType)
        end

        if isTriggered then
            if b.Mode == "Toggle" then
                b.State = not b.State
                if b.Callback then b.Callback(b.State) end
                changed = true
            elseif b.Mode == "Hold" then
                b.State = true
                if b.Callback then b.Callback(true) end
                changed = true
            end
        end
    end
    if changed then updateBindList() end
end)

UIS.InputEnded:Connect(function(input)
    local changed = false
    for name, b in pairs(StoredBinds) do
        local isReleased = false
        if name == "Aimbot" then -- Special handling for Aimbot
            isReleased = (input.UserInputType == Enum.UserInputType.MouseButton2)
        elseif b.Key and b.Key ~= Enum.KeyCode.Unknown then
            isReleased = (input.KeyCode == b.Key)
        elseif b.InputType then
            isReleased = (input.UserInputType == b.InputType)
        end

        if isReleased and b.Mode == "Hold" then
            b.State = false
            if b.Callback then b.Callback(false) end
            changed = true
        end
    end
    if changed then updateBindList() end
end)

local function updatePicker(ch, cs, cv)
    ph, ps, pv = ch or ph, cs or ps, cv or pv
    local color = Color3.fromHSV(ph, ps, pv)
    svSquare.BackgroundColor3 = Color3.fromHSV(ph, 1, 1)
    svCursor.Position = UDim2.new(ps, 0, 1-pv, 0)
    hCursor.Position = UDim2.new(ph, 0, 0.5, 0)
    hexDisp.Text = "#" .. color:ToHex():upper() .. " (" .. math.floor(ps*100) .. "%)"
    if pCallback then pCallback(color) end
end

local svDrag = false
local hDrag = false
svSquare.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = true end
end)
hueSlider.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then hDrag = true end
end)

UIS.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement then
        if svDrag then
            local rx = math.clamp((i.Position.X - svSquare.AbsolutePosition.X)/svSquare.AbsoluteSize.X, 0, 1)
            local ry = math.clamp((i.Position.Y - svSquare.AbsolutePosition.Y)/svSquare.AbsoluteSize.Y, 0, 1)
            updatePicker(nil, rx, 1-ry)
        elseif hDrag then
            local rx = math.clamp((i.Position.X - hueSlider.AbsolutePosition.X)/hueSlider.AbsoluteSize.X, 0, 1)
            updatePicker(rx, nil, nil)
        end
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then svDrag, hDrag = false, false end
end)

-- ════════════ UI BUILDERS ════════════
local activeTab = nil
local tabs = {}
local ord = 0
local function nextO() ord = ord + 1; return ord end

-- Tab function
local function addTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50) -- Увеличено (40 * 1.25)
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamBold -- Сделаем жирнее
    btn.TextSize = 15 -- Увеличено
    btn.TextColor3 = Color3.fromRGB(180, 180, 200) -- Ярче
    btn.Text = "      " .. name
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.LayoutOrder = nextO()
    btn.ZIndex = 20 -- Выше сайдбара
    btn.Visible = true
    btn.Parent = sidebar

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 0.6, 0)
    accent.Position = UDim2.new(0, 0, 0.2, 0)
    accent.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
    accent.BorderSizePixel = 0
    accent.Visible = false
    accent.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -10)
    page.Position = UDim2.new(0, 10, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = content

    local leftCol = Instance.new("Frame")
    leftCol.Size = UDim2.new(0.5, -5, 1, 0)
    leftCol.BackgroundTransparency = 1
    leftCol.Parent = page
    Instance.new("UIListLayout", leftCol).Padding = UDim.new(0, 15)

    local rightCol = Instance.new("Frame")
    rightCol.Size = UDim2.new(0.5, -5, 1, 0)
    rightCol.Position = UDim2.new(0.5, 5, 0, 0)
    rightCol.BackgroundTransparency = 1
    rightCol.Parent = page
    Instance.new("UIListLayout", rightCol).Padding = UDim.new(0, 15)

    local pl = Instance.new("UIListLayout")
    pl.FillDirection = Enum.FillDirection.Horizontal
    pl.Padding = UDim.new(0, 10)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Parent = page

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Page.Visible = false
            t.Accent.Visible = false
            tw(t.Button, {TextColor3 = Color3.fromRGB(150, 150, 165), BackgroundTransparency = 1}, 0.15)
        end
        page.Visible = true
        accent.Visible = true
        tw(btn, {TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.92}, 0.15)
        pickerPanel.Visible = false

        if name == "Visuals" then
            initPreview()
            previewPanel.Visible = true
            tw(previewPanel, {GroupTransparency = 0}, 0.25)
        else
            tw(previewPanel, {GroupTransparency = 1}, 0.2).Completed:Connect(function()
                if not (tabs[1] and tabs[1].Page.Visible) then
                    previewPanel.Visible = false 
                end
            end)
        end
    end)

    btn.MouseEnter:Connect(function() 
        if not page.Visible then tw(btn, {TextColor3 = Color3.new(0.9, 0.9, 0.9), BackgroundTransparency = 0.96}, 0.15) end 
    end)
    btn.MouseLeave:Connect(function() 
        if not page.Visible then tw(btn, {TextColor3 = Color3.fromRGB(150, 150, 165), BackgroundTransparency = 1}, 0.15) end 
    end)

    local tab = {Button = btn, Page = page, Accent = accent, Left = leftCol, Right = rightCol}
    table.insert(tabs, tab)
    if #tabs == 1 then -- По умолчанию первый таб
        page.Visible = true
        accent.Visible = true
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.new(1, 1, 1) -- Добавим слабый фон
        btn.BackgroundTransparency = 0.95
    end
    return tab
end

local function section(parent, title)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.LayoutOrder = nextO()
    container.Parent = parent

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Position = UDim2.new(0, 5, 0, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = Color3.fromRGB(100, 100, 120) -- Приглушенный заголовок
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = string.upper(title)
    l.Parent = container

    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 0)
    box.Position = UDim2.new(0, 0, 0, 22)
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    box.BorderSizePixel = 0
    box.Parent = container
    
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local str = Instance.new("UIStroke", box)
    str.Color = Color3.fromRGB(35, 35, 45)
    str.Thickness = 1

    local il = Instance.new("UIListLayout", box)
    il.Padding = UDim.new(0, 1)
    il.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", box)
    pad.PaddingBottom = UDim.new(0, 2)
    pad.PaddingTop = UDim.new(0, 2)

    return box
end

local function addSubTab(tab, name)
    if not tab.SubBar then
        -- Clean up default tab structure for subtabs
        if tab.Left then tab.Left.Visible = false tab.Left:Destroy() tab.Left = nil end
        if tab.Right then tab.Right.Visible = false tab.Right:Destroy() tab.Right = nil end
        local currLayout = tab.Page:FindFirstChildOfClass("UIListLayout")
        if currLayout then currLayout:Destroy() end
        
        tab.Page.AutomaticCanvasSize = Enum.AutomaticSize.None
        tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        tab.Page.ScrollBarThickness = 0

        tab.SubBar = Instance.new("Frame")
        tab.SubBar.Size = UDim2.new(1, -10, 0, 35)
        tab.SubBar.Position = UDim2.new(0, 5, 0, 2)
        tab.SubBar.BackgroundTransparency = 1
        tab.SubBar.Parent = tab.Page
        
        local sl = Instance.new("UIListLayout")
        sl.FillDirection = Enum.FillDirection.Horizontal
        sl.Padding = UDim.new(0, 15)
        sl.VerticalAlignment = Enum.VerticalAlignment.Center
        sl.Parent = tab.SubBar
        
        tab.SubTabs = {}
    end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 0, 1, 0)
    btn.AutomaticSize = Enum.AutomaticSize.X
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(140, 140, 155)
    btn.Text = name:upper()
    btn.AutoButtonColor = false
    btn.Parent = tab.SubBar

    local bLine = Instance.new("Frame")
    bLine.Size = UDim2.new(1, 0, 0, 2)
    bLine.Position = UDim2.new(0, 0, 1, -2)
    bLine.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
    bLine.BorderSizePixel = 0
    bLine.Visible = false
    bLine.Parent = btn
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, -40)
    page.Position = UDim2.new(0, 0, 0, 40)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = tab.Page
    
    local left = Instance.new("Frame")
    left.Size = UDim2.new(0.5, -5, 1, 0)
    left.BackgroundTransparency = 1
    left.Parent = page
    Instance.new("UIListLayout", left).Padding = UDim.new(0, 15)
    
    local right = Instance.new("Frame")
    right.Size = UDim2.new(0.5, -5, 1, 0)
    right.Position = UDim2.new(0.5, 5, 0, 0)
    right.BackgroundTransparency = 1
    right.Parent = page
    Instance.new("UIListLayout", right).Padding = UDim.new(0, 15)
    
    local pl = Instance.new("UIListLayout")
    pl.FillDirection = Enum.FillDirection.Horizontal
    pl.Padding = UDim.new(0, 10)
    pl.Parent = page
    
    local sub = {Button = btn, Page = page, Left = left, Right = right, Line = bLine}
    
    btn.MouseButton1Click:Connect(function()
        for _, s in pairs(tab.SubTabs) do
            s.Page.Visible = false
            s.Line.Visible = false
            tw(s.Button, {TextColor3 = Color3.fromRGB(140, 140, 155)}, 0.2)
        end
        page.Visible = true
        bLine.Visible = true
        tw(btn, {TextColor3 = Color3.new(1, 1, 1)}, 0.2)
    end)
    
    table.insert(tab.SubTabs, sub)
    if #tab.SubTabs == 1 then
        page.Visible = true
        bLine.Visible = true
        btn.TextColor3 = Color3.new(1, 1, 1)
    end
    
    return sub
end

-- Toggle
local refreshers = {}
local function RefreshUI()
    for _, rf in ipairs(refreshers) do rf() end
end

-- Toggle with optional Color Picker or Settings Icon
local function toggle(parent, name, default, callback, opts)
    local state = default
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42) -- Увеличено (32 -> 42)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    f.BorderSizePixel = 0
    f.LayoutOrder = nextO()
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -110, 1, 0) -- Больше места для кнопок
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = name
    lbl.Parent = f

    -- Toggle Switch
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 48, 0, 24) -- Еще чуть больше (40x20 -> 48x24)
    bg.Position = UDim2.new(1, -64, 0.5, -12)
    bg.BackgroundColor3 = default and Color3.fromRGB(70, 110, 255) or Color3.fromRGB(45, 45, 55)
    bg.BorderSizePixel = 0
    bg.Parent = f
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20) -- Больше (16x16 -> 20x20)
    knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0) -- На весь размер плашки
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 2
    btn.Parent = f

    local function updateVisuals()
        tw(bg, {BackgroundColor3 = state and Color3.fromRGB(70, 110, 255) or Color3.fromRGB(45, 45, 55)}, 0.2)
        tw(knob, {Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        callback(state)
    end)

    btn.MouseButton2Click:Connect(function()
        currentlyBinding = name
        StoredBinds[name] = StoredBinds[name] or {Mode = "Toggle", State = false}
        StoredBinds[name].Callback = function(val)
            state = val
            updateVisuals()
            callback(val)
            StoredBinds[name].State = val
            updateBindList()
        end
        updateBindPanel(name)
        openPopup(bindPanel, bindScale)
    end)

    -- Extra Actions
    if opts then
        if opts.ColorData then
            local cp = Instance.new("TextButton")
            cp.Size = UDim2.new(0, 24, 0, 14) 
            cp.Position = UDim2.new(1, -115, 0.5, -7) 
            cp.BackgroundColor3 = opts.ColorData.Default
            cp.BorderSizePixel = 0
            cp.Text = ""
            cp.ZIndex = 3 -- Выше основной кнопки переключения
            cp.Parent = f
            Instance.new("UICorner", cp).CornerRadius = UDim.new(0, 3)
            Instance.new("UIStroke", cp).Color = Color3.new(0,0,0)

            cp.MouseButton1Click:Connect(function()
                if pickerPanel.Visible and activeSource == cp then
                    closePopup(pickerPanel, pickerScale)
                    activeSource = nil
                    activePopup = previousPopup
                    previousPopup = nil
                else
                    openPopup(pickerPanel, pickerScale)
                    activeSource = cp
                    pCallback = function(color)
                        cp.BackgroundColor3 = color
                        opts.ColorData.Callback(color)
                    end
                    local h, s, v = cp.BackgroundColor3:ToHSV()
                    updatePicker(h, s, v)
                end
            end)

            table.insert(refreshers, function()
                local colorKey = opts.ColorKey or (name:gsub(" ", "") .. "Color")
                if CONFIG[colorKey] then
                    cp.BackgroundColor3 = CONFIG[colorKey]
                end
            end)
        end

        if opts.UseSettings then
            local gear = Instance.new("TextButton")
            gear.Size = UDim2.new(0, 24, 0, 24)
            gear.Position = UDim2.new(1, -145, 0.5, -12) 
            gear.BackgroundTransparency = 1
            gear.Font = Enum.Font.GothamBold
            gear.TextSize = 18
            gear.TextColor3 = Color3.fromRGB(150, 150, 160)
            gear.Text = "⚙"
            gear.ZIndex = 3 -- Выше основной кнопки
            gear.Parent = f
            
            gear.MouseButton1Click:Connect(function()
                if subPanel.Visible and activeSource == gear then
                    closePopup(subPanel, subScale)
                    activeSource = nil
                    activePopup = nil
                else
                    openPopup(subPanel, subScale)
                    activeSource = gear
                end
            end)
        end
    end

    f.MouseEnter:Connect(function() tw(f, {BackgroundColor3 = Color3.fromRGB(28, 28, 36)}, 0.15) end)
    f.MouseLeave:Connect(function() tw(f, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}, 0.15) end)
    
    table.insert(refreshers, function()
        local configKey = opts and opts.ConfigKey or name:gsub(" ", "")
        if name == "Enable Aimbot" then configKey = "AimbotEnabled" end
        if name == "Enable Local ESP" then configKey = "LocalPlayerESP" end
        if name == "Bounding Box" then configKey = "BoxEnabled" end
        
        for k, v in pairs(CONFIG) do
            if k:lower() == configKey:lower() or k:lower() == (configKey .. "Enabled"):lower() then
                state = v
                updateVisuals()
                callback(state)
                break
            end
        end
    end)

    return f
end

-- Standalone Color picker
local function colorPick(parent, name, default, callback, opts)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42) -- В тон к тогглам
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    f.BorderSizePixel = 0
    f.LayoutOrder = nextO()
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = name
    lbl.Parent = f

    local preview = Instance.new("TextButton")
    preview.Size = UDim2.new(0, 28, 0, 16) -- Крупнее
    preview.Position = UDim2.new(1, -44, 0.5, -8)
    preview.BackgroundColor3 = default
    preview.BorderSizePixel = 0
    preview.Text = ""
    preview.Parent = f
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 3)

    preview.MouseButton1Click:Connect(function()
        if pickerPanel.Visible and activeSource == preview then
            closePopup(pickerPanel, pickerScale)
            activeSource = nil
            activePopup = previousPopup
            previousPopup = nil
        else
            openPopup(pickerPanel, pickerScale)
            activeSource = preview
            pCallback = function(color)
                preview.BackgroundColor3 = color
                callback(color)
            end
            local h, s, v = preview.BackgroundColor3:ToHSV()
            updatePicker(h, s, v)
        end
    end)

    f.MouseEnter:Connect(function() tw(f, {BackgroundColor3 = Color3.fromRGB(28, 28, 36)}, 0.15) end)
    f.MouseLeave:Connect(function() tw(f, {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}, 0.15) end)
    
    table.insert(refreshers, function()
        local search = opts and opts.ConfigKey or name:gsub(" ", "")
        for k, v in pairs(CONFIG) do
            if k:lower() == search:lower() or k:lower() == (search .. "Color"):lower() then
                preview.BackgroundColor3 = v
                callback(v)
                break
            end
        end
    end)

    return f
end

local function dropdown(parent, name, options, default, callback, opts)
    local open = false
    local current = default
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 42)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false 
    container.LayoutOrder = nextO()
    container.Parent = parent

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    header.BorderSizePixel = 0
    header.Parent = container
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -120, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = name
    lbl.Parent = header

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 24)
    btn.Position = UDim2.new(1, -104, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(70, 110, 255) -- Highlighted text for header
    btn.Text = current:upper()
    btn.Parent = header
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -25, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = ">"
    arrow.TextColor3 = Color3.fromRGB(150, 150, 160)
    arrow.TextSize = 14
    arrow.Rotation = 90
    arrow.Parent = header

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 0, 45)
    list.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    list.BorderSizePixel = 0
    list.ClipsDescendants = true
    list.Visible = false
    list.ZIndex = 10 -- Ensure it's above other elements
    list.Parent = container
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", list)
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1

    local listLay = Instance.new("UIListLayout", list)
    listLay.SortOrder = Enum.SortOrder.LayoutOrder
    listLay.Padding = UDim.new(0, 2)
    Instance.new("UIPadding", list).PaddingTop = UDim.new(0, 4)

    for i, opt in ipairs(options) do
        local oBtn = Instance.new("TextButton")
        oBtn.Size = UDim2.new(1, -10, 0, 32)
        oBtn.Position = UDim2.new(0, 5, 0, 0)
        oBtn.BackgroundTransparency = (opt == current) and 0.9 or 1
        oBtn.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
        oBtn.Font = Enum.Font.GothamMedium
        oBtn.TextColor3 = (opt == current) and Color3.fromRGB(70, 110, 255) or Color3.fromRGB(180, 180, 190)
        oBtn.TextSize = 13
        oBtn.Text = opt
        oBtn.LayoutOrder = i
        oBtn.ZIndex = 11 -- Ensure buttons are visible
        oBtn.Parent = list
        Instance.new("UICorner", oBtn).CornerRadius = UDim.new(0, 6)

        oBtn.MouseEnter:Connect(function()
            if current ~= opt then
                tw(oBtn, {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(220, 220, 230)}, 0.1)
            end
        end)
        oBtn.MouseLeave:Connect(function()
            if current ~= opt then
                tw(oBtn, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 190)}, 0.1)
            end
        end)

        oBtn.MouseButton1Click:Connect(function()
            current = opt
            btn.Text = current:upper()
            callback(current)
            
            open = false
            tw(arrow, {Rotation = 90}, 0.2)
            tw(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.2).Completed:Connect(function()
                if not open then list.Visible = false end
            end)
            tw(container, {Size = UDim2.new(1, 0, 0, 42)}, 0.2)
            
            for _, b in pairs(list:GetChildren()) do
                if b:IsA("TextButton") then
                    local isSel = (b.Text == current)
                    tw(b, {
                        TextColor3 = isSel and Color3.fromRGB(70, 110, 255) or Color3.fromRGB(180, 180, 190),
                        BackgroundTransparency = isSel and 0.9 or 1
                    }, 0.1)
                end
            end
        end)
    end

    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            list.Visible = true
            local targetH = (#options * 34) + 8 -- Dynamic height based on button size + padding
            tw(arrow, {Rotation = 270}, 0.2)
            tw(list, {Size = UDim2.new(1, 0, 0, targetH)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            tw(container, {Size = UDim2.new(1, 0, 0, 45 + targetH)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        else
            tw(arrow, {Rotation = 90}, 0.2)
            tw(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.2).Completed:Connect(function()
                if not open then list.Visible = false end
            end)
            tw(container, {Size = UDim2.new(1, 0, 0, 42)}, 0.2)
        end
    end)

    btn.MouseButton2Click:Connect(function()
        currentlyBinding = name
        StoredBinds[name] = StoredBinds[name] or {Mode = "Toggle", State = false}
        StoredBinds[name].Callback = function(val)
            -- For dropdowns, toggle state isn't very useful, but we'll show it in bind list
            StoredBinds[name].State = val
            updateBindList()
        end
        updateBindPanel(name)
        openPopup(bindPanel, bindScale)
    end)

    table.insert(refreshers, function()
        local search = opts and opts.ConfigKey or name:gsub(" ", "")
        for k, v in pairs(CONFIG) do
            if k:lower() == search:lower() or k:lower() == (search:gsub("Origin", "") .. "Origin"):lower() then
                current = v
                btn.Text = tostring(v):upper()
                callback(v)
                for _, b in pairs(list:GetChildren()) do
                    if b:IsA("TextButton") then
                        local isSel = (b.Text == current)
                        tw(b, {
                            TextColor3 = isSel and Color3.fromRGB(70, 110, 255) or Color3.fromRGB(180, 180, 190),
                            BackgroundTransparency = isSel and 0.9 or 1
                        }, 0.1)
                    end
                end
                break
            end
        end
    end)

    return container
end

-- ═══════════ FILL MENU ═══════════
-- Slider
local function slider(parent, name, min, max, default, dec, callback, opts)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 48)
    f.BackgroundTransparency = 1
    f.LayoutOrder = nextO()
    f.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 14, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = name
    lbl.Parent = f

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 40, 0, 20)
    valLbl.Position = UDim2.new(1, -54, 0, 5)
    valLbl.BackgroundTransparency = 1
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextColor3 = Color3.fromRGB(150, 150, 160)
    valLbl.TextSize = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Text = tostring(default)
    valLbl.Parent = f

    local sbg = Instance.new("Frame")
    sbg.Size = UDim2.new(1, -28, 0, 4)
    sbg.Position = UDim2.new(0, 14, 0, 32)
    sbg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sbg.BorderSizePixel = 0
    sbg.Parent = f
    Instance.new("UICorner", sbg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sbg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default - min)/(max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = sbg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sbg.AbsolutePosition.X) / sbg.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * pos
        if dec == 0 then val = math.floor(val + 0.5) else val = math.floor(val * 10^dec + 0.5) / 10^dec end
        
        tw(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
        tw(knob, {Position = UDim2.new(pos, 0, 0.5, 0)}, 0.1)
        valLbl.Text = tostring(val)
        callback(val)
    end

    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(i) end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton2 then
            currentlyBinding = name
            StoredBinds[name] = StoredBinds[name] or {Mode = "Toggle", State = false}
            StoredBinds[name].Callback = function(val)
                StoredBinds[name].State = val
                updateBindList()
            end
            updateBindPanel(name)
            openPopup(bindPanel, bindScale)
        end
    end)

    table.insert(refreshers, function()
        -- Try to find matching config key
        local search = opts and opts.ConfigKey or name:gsub(" ", "")
        for k, v in pairs(CONFIG) do
            if k:lower() == search:lower() or k:lower() == (search .. "Strength"):lower() or k:lower() == ("Aimbot" .. search):lower() then
                local pos = math.clamp((v - min) / (max - min), 0, 1)
                tw(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                tw(knob, {Position = UDim2.new(pos, 0, 0.5, 0)}, 0.1)
                valLbl.Text = tostring(v)
                callback(v)
                break
            end
        end
    end)

    return f
end

-- TextBox for Config naming
local function textbox(parent, name, placeholder, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 60)
    f.BackgroundTransparency = 1
    f.LayoutOrder = nextO()
    f.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 14, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = name
    lbl.Parent = f

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -28, 0, 30)
    bg.Position = UDim2.new(0, 14, 0, 25)
    bg.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    bg.BorderSizePixel = 0
    bg.Parent = f
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", bg)
    stroke.Color = Color3.fromRGB(45, 45, 55)

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -20, 1, 0)
    tb.Position = UDim2.new(0, 10, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Font = Enum.Font.GothamMedium
    tb.PlaceholderText = placeholder
    tb.Text = ""
    tb.TextColor3 = Color3.new(1, 1, 1)
    tb.PlaceholderColor3 = Color3.fromRGB(80, 80, 90)
    tb.TextSize = 14
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ClearTextOnFocus = false
    tb.Parent = bg
    tb:GetPropertyChangedSignal("Text"):Connect(function()
        callback(tb.Text)
    end)

    tb.FocusLost:Connect(function()
        callback(tb.Text)
    end)

    return f, tb
end

-- Simple Button
local function button(parent, name, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color or Color3.fromRGB(70, 110, 255)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = name:upper()
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.LayoutOrder = nextO()
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function() tw(btn, {BackgroundTransparency = 0.1}, 0.1) end)
    btn.MouseLeave:Connect(function() tw(btn, {BackgroundTransparency = 0}, 0.1) end)

    return btn
end

-- ═══════════ CONFIG SYSTEM ═══════════
local folderName = "Neverlose_ESP"
if isfolder and not isfolder(folderName) then makefolder(folderName) end

local function saveConfig(name)
    if not writefile then return end
    local data = {Settings = {}, Binds = {}}
    
    for k, v in pairs(CONFIG) do
        if typeof(v) == "Color3" then
            data.Settings[k] = {__type = "Color3", r = v.R, g = v.G, b = v.B}
        else
            data.Settings[k] = v
        end
    end

    for n, b in pairs(StoredBinds) do
        data.Binds[n] = {
            Key = b.Key and b.Key.Name,
            InputType = b.InputType and b.InputType.Name,
            Mode = b.Mode
        }
    end

    writefile(folderName .. "/" .. name .. ".json", HttpService:JSONEncode(data))
end

local function loadConfig(name)
    if not readfile then return end
    local path = folderName .. "/" .. name .. ".json"
    if isfile(path) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if success then
            local settings = data.Settings or data -- Fallback for old configs
            for k, v in pairs(settings) do
                if typeof(v) == "table" and v.__type == "Color3" then
                    CONFIG[k] = Color3.new(v.r, v.g, v.b)
                else
                    CONFIG[k] = v
                end
            end

            if data.Binds then
                for n, b in pairs(data.Binds) do
                    if StoredBinds[n] then
                        if b.Key then StoredBinds[n].Key = Enum.KeyCode[b.Key] end
                        if b.InputType then StoredBinds[n].InputType = Enum.UserInputType[b.InputType] end
                        StoredBinds[n].Mode = b.Mode or "Toggle"
                    end
                end
            end

            RefreshUI()
            if updateAimVisibility then updateAimVisibility() end
            updateBindList()
        end
    end
end

-- ═══════════ FILL MENU ═══════════
local vis = addTab("Visuals", "rbxassetid://6031289116")
local aim = addTab("Aimbot", "rbxassetid://6034440156")
local cfg = addTab("Configs", "rbxassetid://6031243717")
local misc = addTab("Misc", "rbxassetid://6034502931")

-- Левая колонка (Aimbot)
local aimMain = section(aim.Left, "Main Settings")
local aimSecondary = {}

local function updateAimVisibility()
    local master = CONFIG.AimbotEnabled
    for _, item in ipairs(aimSecondary) do
        local visible = master
        if item.Key == "PredictionStr" then
            visible = master and CONFIG.PredictionEnabled
        elseif item.Key == "RecoilStr" then
            visible = master and CONFIG.NoRecoilEnabled
        end

        if visible then
            item.Frame.Visible = true
            tw(item.Frame, {Size = UDim2.new(1, 0, 0, item.Height)}, 0.3)
        else
            local t = tw(item.Frame, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
            t.Completed:Connect(function()
                if not master or (item.Key and not CONFIG[item.Key:gsub("Str", "Enabled")]) then 
                    item.Frame.Visible = false 
                end
            end)
        end
    end
end

toggle(aimMain, "Enable Aimbot", CONFIG.AimbotEnabled, function(v) 
    CONFIG.AimbotEnabled = v
    updateAimVisibility()
end)

local vOnly = toggle(aimMain, "Visible Only", CONFIG.AimbotVisibleOnly, function(v) CONFIG.AimbotVisibleOnly = v end, {ConfigKey = "AimbotVisibleOnly"})
local sticky = toggle(aimMain, "Sticky Aim", CONFIG.AimbotSticky, function(v) CONFIG.AimbotSticky = v end, {ConfigKey = "AimbotSticky"})
local targetPart = dropdown(aimMain, "Target Part", {"Head", "UpperTorso", "LowerTorso", "Random"}, CONFIG.AimbotTargetPart, function(v) CONFIG.AimbotTargetPart = v end, {ConfigKey = "AimbotTargetPart"})

local predToggle = toggle(aimMain, "Prediction", CONFIG.PredictionEnabled, function(v) 
    CONFIG.PredictionEnabled = v
    updateAimVisibility()
end, {ConfigKey = "PredictionEnabled"})

local recoilToggle = toggle(aimMain, "No Recoil", CONFIG.NoRecoilEnabled, function(v) 
    CONFIG.NoRecoilEnabled = v
    updateAimVisibility()
end, {ConfigKey = "NoRecoilEnabled"})

-- Правая колонка (Aimbot)
local aimConfig = section(aim.Right, "Configuration")
local smooth = slider(aimConfig, "Smoothness", 0, 1, CONFIG.AimbotSmoothness, 2, function(v) CONFIG.AimbotSmoothness = v end, {ConfigKey = "AimbotSmoothness"})
slider(aimConfig, "Max Distance", 10, 1500, CONFIG.AimbotMaxDistance, 0, function(v) CONFIG.AimbotMaxDistance = v end, {ConfigKey = "AimbotMaxDistance"})

local predSlider = slider(aimConfig, "Prediction Str", 0, 20, CONFIG.PredictionStrength, 1, function(v) CONFIG.PredictionStrength = v end, {ConfigKey = "PredictionStrength"})
local recoilSlider = slider(aimConfig, "Recoil Strength", 0, 100, CONFIG.NoRecoilStrength, 0, function(v) CONFIG.NoRecoilStrength = v end, {ConfigKey = "NoRecoilStrength"})

local fovSize = slider(aimConfig, "FOV Size", 10, 800, CONFIG.AimbotFOV, 0, function(v) CONFIG.AimbotFOV = v end, {ConfigKey = "AimbotFOV"})
local fovCircle = toggle(aimConfig, "Show FOV Circle", CONFIG.ShowFOV, function(v) CONFIG.ShowFOV = v end, {
    ColorData = {Default = CONFIG.FOVColor, Callback = function(v) CONFIG.FOVColor = v end, ConfigKey = "FOVColor"},
    ConfigKey = "ShowFOV"
})

-- Register elements
table.insert(aimSecondary, {Frame = vOnly, Height = 42})
table.insert(aimSecondary, {Frame = sticky, Height = 42})
table.insert(aimSecondary, {Frame = targetPart, Height = 42})
table.insert(aimSecondary, {Frame = predToggle, Height = 42})
table.insert(aimSecondary, {Frame = recoilToggle, Height = 42})
table.insert(aimSecondary, {Frame = smooth, Height = 48})
table.insert(aimSecondary, {Frame = predSlider, Height = 48, Key = "PredictionStr"})
table.insert(aimSecondary, {Frame = recoilSlider, Height = 48, Key = "RecoilStr"})
table.insert(aimSecondary, {Frame = fovSize, Height = 48})
table.insert(aimSecondary, {Frame = fovCircle, Height = 42})

-- Initialize visibility
for _, item in ipairs(aimSecondary) do
    item.Frame.ClipsDescendants = true
    local visible = CONFIG.AimbotEnabled
    if item.Key == "PredictionStr" then visible = visible and CONFIG.PredictionEnabled
    elseif item.Key == "RecoilStr" then visible = visible and CONFIG.NoRecoilEnabled end
    
    if not visible then
        item.Frame.Visible = false
        item.Frame.Size = UDim2.new(1, 0, 0, 0)
    end
end
slider(aimConfig, "Distance Weight", 0, 1, CONFIG.AimbotDistanceWeight, 2, function(v) CONFIG.AimbotDistanceWeight = v end, {ConfigKey = "AimbotDistanceWeight"})

-- ═══════════ VISUALS SUB-TABS ═══════════
local visPlayers = addSubTab(vis, "Players")
local visLocal   = addSubTab(vis, "Local")
local visWorld   = addSubTab(vis, "World")

-- ── PLAYERS ──────────────────────────────
local groupFeatures = section(visPlayers.Left, "Features")
toggle(groupFeatures, "Bounding Box", CONFIG.BoxEnabled, function(v) CONFIG.BoxEnabled = v end, {
    ColorData = {Default = CONFIG.BoxColor, Callback = function(v) CONFIG.BoxColor = v end, ConfigKey = "BoxColor"},
    ConfigKey = "BoxEnabled"
})
toggle(groupFeatures, "Skeleton", CONFIG.SkeletonEnabled, function(v) CONFIG.SkeletonEnabled = v end, {
    ColorData = {Default = CONFIG.SkeletonColor, Callback = function(v) CONFIG.SkeletonColor = v end, ConfigKey = "SkeletonColor"},
    ConfigKey = "SkeletonEnabled"
})
toggle(groupFeatures, "Health Bar", CONFIG.HealthBarEnabled, function(v) CONFIG.HealthBarEnabled = v end, {ConfigKey = "HealthBarEnabled"})
toggle(groupFeatures, "Tracers", CONFIG.TracersEnabled, function(v) CONFIG.TracersEnabled = v end, {
    ColorData = {Default = CONFIG.TracersColor, Callback = function(v) CONFIG.TracersColor = v end, ConfigKey = "TracersColor"},
    ConfigKey = "TracersEnabled"
})
dropdown(groupFeatures, "Tracer Origin", {"Bottom", "Top", "Middle", "Mouse"}, CONFIG.TracerOrigin, function(v) CONFIG.TracerOrigin = v end, {ConfigKey = "TracerOrigin"})
toggle(groupFeatures, "Info Panel", CONFIG.PanelEnabled, function(v) CONFIG.PanelEnabled = v end, {
    ColorData = {Default = CONFIG.PanelBgColor, Callback = function(v) CONFIG.PanelBgColor = v end, ConfigKey = "PanelBgColor"},
    UseSettings = true,
    ConfigKey = "PanelEnabled"
})
local deadSlider
toggle(groupFeatures, "Dead ESP", CONFIG.DeadESP, function(v) 
    CONFIG.DeadESP = v
    if deadSlider then
        if v then
            deadSlider.Visible = true
            tw(deadSlider, {Size = UDim2.new(1, 0, 0, 48)}, 0.3)
        else
            local t = tw(deadSlider, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
            t.Completed:Connect(function() 
                if not CONFIG.DeadESP then deadSlider.Visible = false end 
            end)
        end
    end
end, {
    ColorData = {Default = CONFIG.DeadESPColor, Callback = function(v) CONFIG.DeadESPColor = v end, ConfigKey = "DeadESPColor"},
    ConfigKey = "DeadESP"
})
deadSlider = slider(groupFeatures, "Dead Duration", 5, 120, CONFIG.DeadESPDuration, 0, function(v) CONFIG.DeadESPDuration = v end, {ConfigKey = "DeadESPDuration"})
deadSlider.ClipsDescendants = true
if not CONFIG.DeadESP then
    deadSlider.Visible = false
    deadSlider.Size = UDim2.new(1, 0, 0, 0)
end

local groupBaseP = section(visPlayers.Right, "ESP Base")
toggle(groupBaseP, "Master Switch", CONFIG.Enabled, function(v) CONFIG.Enabled = v end, {ConfigKey = "Enabled"})
toggle(groupBaseP, "Team Check", CONFIG.TeamCheck, function(v) CONFIG.TeamCheck = v end, {ConfigKey = "TeamCheck"})
slider(groupBaseP, "Max Distance", 100, 8500, CONFIG.MaxDistance, 0, function(v) CONFIG.MaxDistance = v end, {ConfigKey = "MaxDistance"})

local groupVisP = section(visPlayers.Right, "Visibility")
toggle(groupVisP, "Check Visibility", CONFIG.VisibilityCheck, function(v) CONFIG.VisibilityCheck = v end, {ConfigKey = "VisibilityCheck"})
colorPick(groupVisP, "Visible Color", CONFIG.VisibleColor, function(v) CONFIG.VisibleColor = v end, {ConfigKey = "VisibleColor"})
colorPick(groupVisP, "Hidden Color", CONFIG.HiddenColor, function(v) CONFIG.HiddenColor = v end, {ConfigKey = "HiddenColor"})

-- ── LOCAL ESP ──────────────────────────────
local groupLocal = section(visLocal.Left, "Self ESP")
toggle(groupLocal, "Enable Local ESP", CONFIG.LocalPlayerESP, function(v) 
    CONFIG.LocalPlayerESP = v 
end, {
    ColorData = {Default = CONFIG.LocalPlayerColor, Callback = function(v) CONFIG.LocalPlayerColor = v end, ConfigKey = "LocalPlayerColor"},
    ConfigKey = "LocalPlayerESP"
})
toggle(groupLocal, "Box", CONFIG.LocalBox, function(v) CONFIG.LocalBox = v end, {
    ColorData = {Default = CONFIG.LocalBoxColor, Callback = function(v) CONFIG.LocalBoxColor = v end, ConfigKey = "LocalBoxColor"},
    ConfigKey = "LocalBox"
})
toggle(groupLocal, "Skeleton", CONFIG.LocalSkeleton, function(v) CONFIG.LocalSkeleton = v end, {
    ColorData = {Default = CONFIG.LocalSkeletonColor, Callback = function(v) CONFIG.LocalSkeletonColor = v end, ConfigKey = "LocalSkeletonColor"},
    ConfigKey = "LocalSkeleton"
})
toggle(groupLocal, "Health Bar", CONFIG.LocalHealthBar, function(v) CONFIG.LocalHealthBar = v end, {ConfigKey = "LocalHealthBar"})
toggle(groupLocal, "Tracers", CONFIG.LocalTracers, function(v) CONFIG.LocalTracers = v end, {
    ColorData = {Default = CONFIG.LocalTracersColor, Callback = function(v) CONFIG.LocalTracersColor = v end, ConfigKey = "LocalTracersColor"},
    ConfigKey = "LocalTracers"
})

-- ── WORLD ──────────────────────────────
local groupWorld = section(visWorld.Left, "Environment")
toggle(groupWorld, "Ambience", CONFIG.AmbienceEnabled, function(v) CONFIG.AmbienceEnabled = v end, {
    ColorData = {Default = CONFIG.AmbienceColor, Callback = function(v) CONFIG.AmbienceColor = v end, ConfigKey = "AmbienceColor"},
    ConfigKey = "AmbienceEnabled"
})

-- ── OTHER ──────────────────────────────
local visOther = addSubTab(vis, "Other")
local scopeGroup = section(visOther.Left, "Custom Scope")

toggle(scopeGroup, "Enable Scope", CONFIG.ScopeEnabled, function(v) CONFIG.ScopeEnabled = v end, {
    ColorData = {Default = CONFIG.ScopeColor, Callback = function(v) CONFIG.ScopeColor = v end, ConfigKey = "ScopeColor"},
    ConfigKey = "ScopeEnabled"
})

slider(scopeGroup, "Scope Gap", 0, 50, CONFIG.ScopeGap, 0, function(v) CONFIG.ScopeGap = v end, {ConfigKey = "ScopeGap"})
slider(scopeGroup, "Scope Length", 1, 100, CONFIG.ScopeLength, 0, function(v) CONFIG.ScopeLength = v end, {ConfigKey = "ScopeLength"})
slider(scopeGroup, "Scope Thickness", 1, 10, CONFIG.ScopeThickness, 1, function(v) CONFIG.ScopeThickness = v end, {ConfigKey = "ScopeThickness"})
toggle(scopeGroup, "Center Dot", CONFIG.ScopeCenterDot, function(v) CONFIG.ScopeCenterDot = v end, {ConfigKey = "ScopeCenterDot"})
toggle(scopeGroup, "Scope Outline", CONFIG.ScopeOutline, function(v) CONFIG.ScopeOutline = v end, {ConfigKey = "ScopeOutline"})

-- ── CONFIGS ──────────────────────────────
local cfgMain = section(cfg.Left, "Config Management")
local configName = ""
local configTB
local tbFrame, realTB = textbox(cfgMain, "Config Name", "Enter name...", function(v) configName = v end)
configTB = realTB

button(cfgMain, "Create New", Color3.fromRGB(70, 110, 255), function()
    if configName ~= "" then
        saveConfig(configName)
        configName = ""
        configTB.Text = ""
        refreshCfgList()
    end
end)

local cfgList = section(cfg.Right, "Saved Configs")
local function refreshCfgList()
    -- Clear current list with animation
    for _, child in ipairs(cfgList:GetChildren()) do
        if child:IsA("Frame") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    
    if listfiles then
        local files = listfiles(folderName)
        for _, file in ipairs(files) do
            -- More robust name extraction to avoid ./ or other path prefixes
            local name = file:match("([^/]+)%.json$") or file:match("([^\\]+)%.json$") or file:gsub(".json", "")
            
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 42)
            f.BackgroundTransparency = 1
            f.ClipsDescendants = true
            f.Parent = cfgList
            
            -- Animation state
            f.Size = UDim2.new(1, 0, 0, 0)
            tw(f, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)

            local hover = Instance.new("Frame")
            hover.Size = UDim2.new(1, 0, 1, 0)
            hover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            hover.BackgroundTransparency = 1
            hover.BorderSizePixel = 0
            hover.ZIndex = 0
            hover.Parent = f
            Instance.new("UICorner", hover).CornerRadius = UDim.new(0, 8)

            f.MouseEnter:Connect(function() tw(hover, {BackgroundTransparency = 0.95}, 0.2) end)
            f.MouseLeave:Connect(function() tw(hover, {BackgroundTransparency = 1}, 0.2) end)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -120, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamMedium
            lbl.Text = name
            lbl.TextColor3 = Color3.new(1, 1, 1)
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f
            
            local loadBtn = Instance.new("TextButton")
            loadBtn.Size = UDim2.new(0, 40, 0, 24)
            loadBtn.Position = UDim2.new(1, -145, 0.5, -12)
            loadBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            loadBtn.Text = "LOAD"
            loadBtn.Font = Enum.Font.GothamBold
            loadBtn.TextColor3 = Color3.new(1, 1, 1)
            loadBtn.TextSize = 10
            loadBtn.Parent = f
            Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 4)
            loadBtn.MouseButton1Click:Connect(function() loadConfig(name) end)

            local saveBtn = Instance.new("TextButton")
            saveBtn.Size = UDim2.new(0, 45, 0, 24)
            saveBtn.Position = UDim2.new(1, -100, 0.5, -12)
            saveBtn.BackgroundColor3 = Color3.fromRGB(40, 70, 40)
            saveBtn.Text = "SAVE"
            saveBtn.Font = Enum.Font.GothamBold
            saveBtn.TextColor3 = Color3.new(1, 1, 1)
            saveBtn.TextSize = 10
            saveBtn.Parent = f
            Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 4)
            saveBtn.MouseButton1Click:Connect(function()
                saveConfig(name)
            end)
            
            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 40, 0, 24)
            delBtn.Position = UDim2.new(1, -50, 0.5, -12)
            delBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
            delBtn.Text = "DEL"
            delBtn.Font = Enum.Font.GothamBold
            delBtn.TextColor3 = Color3.new(1, 1, 1)
            delBtn.TextSize = 10
            delBtn.Parent = f
            Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
            delBtn.MouseButton1Click:Connect(function()
                local fileToDel = file
                if delfile then delfile(fileToDel) end
                tw(f, {Size = UDim2.new(1, 0, 0, 0)}, 0.2).Completed:Connect(function()
                    refreshCfgList()
                end)
            end)
        end
    end
end

button(cfgMain, "Refresh List", Color3.fromRGB(45, 45, 55), refreshCfgList)
refreshCfgList()

-- ── SETTINGS (Popup) ──────────────────────────
local subGroup = section(subScroll, "Panel Content")
toggle(subGroup, "Distance", CONFIG.ShowDistance, function(v) CONFIG.ShowDistance = v end, {
    ColorData = {Default = CONFIG.DistanceColor, Callback = function(v) CONFIG.DistanceColor = v end, ConfigKey = "DistanceColor"},
    ConfigKey = "ShowDistance"
})
toggle(subGroup, "Avatar", CONFIG.ShowAvatar, function(v) CONFIG.ShowAvatar = v end, {ConfigKey = "ShowAvatar"})
toggle(subGroup, "Player Name", CONFIG.ShowName, function(v) CONFIG.ShowName = v end, {
    ColorData = {Default = CONFIG.NameColor, Callback = function(v) CONFIG.NameColor = v end, ConfigKey = "NameColor"},
    ConfigKey = "ShowName"
})
toggle(subGroup, "Health", CONFIG.ShowHealth, function(v) CONFIG.ShowHealth = v end, {
    ColorData = {Default = CONFIG.HealthColor, Callback = function(v) CONFIG.HealthColor = v end, ConfigKey = "HealthColor"},
    ConfigKey = "ShowHealth"
})
colorPick(subGroup, "Heart Color", CONFIG.HeartColor, function(v) CONFIG.HeartColor = v end, {ConfigKey = "HeartColor"})

local groupMisc = section(misc.Left, "Miscellaneous")
toggle(groupMisc, "Show Keybinds List", CONFIG.ShowBindWindow, function(v) 
    CONFIG.ShowBindWindow = v 
    updateBindList()
end, {ConfigKey = "ShowBindWindow"})

toggle(groupMisc, "High Jump", CONFIG.HighJumpEnabled, function(v) 
    CONFIG.HighJumpEnabled = v 
end, {ConfigKey = "HighJumpEnabled"})

slider(groupMisc, "Jump Height", 0, 200, CONFIG.HighJumpValue, 0, function(v) 
    CONFIG.HighJumpValue = v 
end, {ConfigKey = "HighJumpValue"})

local groupMenu = section(misc.Right, "Menu Settings")
-- Menu size sliders removed

local function unload()
    menuOpen = false
    mainPanel:Destroy()
    pickerPanel:Destroy()
    subPanel:Destroy()
    previewPanel:Destroy()
    for _, p in pairs(Players:GetPlayers()) do removeESP(p) end
    for _, m in pairs(DeathMarkers) do
        m.Line1:Remove()
        m.Line2:Remove()
        m.Text:Remove()
    end
    -- Note: This is a basic unload, in a real script you'd disconnect all events
end

local ub = Instance.new("TextButton")
ub.Size = UDim2.new(1, 0, 0, 42)
ub.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
ub.Font = Enum.Font.GothamBold
ub.Text = "UNLOAD SCRIPT"
ub.TextColor3 = Color3.new(1, 0.4, 0.4)
ub.TextSize = 14
ub.Parent = groupMisc
Instance.new("UICorner", ub).CornerRadius = UDim.new(0, 8)
ub.MouseButton1Click:Connect(unload)

local function toggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        mainPanel.Visible = true
        tw(mainPanel, {GroupTransparency = 0}, 0.2)
        
        -- Force re-pin positioning
        previewPanel.Position = UDim2.new(mainPanel.Position.X.Scale, mainPanel.Position.X.Offset + 880 + 15, mainPanel.Position.Y.Scale, mainPanel.Position.Y.Offset)

        if tabs[1] and tabs[1].Page.Visible then
            previewPanel.Visible = true
            initPreview()
            tw(previewPanel, {GroupTransparency = 0}, 0.2)
        end
    else
        local t = tw(mainPanel, {GroupTransparency = 1}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        tw(previewPanel, {GroupTransparency = 1}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        
        if activePopup then
            local s = (activePopup == pickerPanel) and pickerScale or (activePopup == bindPanel and bindScale or subScale)
            task.spawn(function() closePopup(activePopup, s) end)
            activePopup = nil
            activeSource = nil
        end

        t.Completed:Connect(function()
            if not menuOpen then 
                mainPanel.Visible = false 
                previewPanel.Visible = false
            end
        end)
    end
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then toggleMenu() end
end)

-- Drag
local dragActive = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragActive = true
        dragStart = input.Position
        startPos = mainPanel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
        if dragActive and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        
        -- Pin preview to menu
        previewPanel.Position = UDim2.new(mainPanel.Position.X.Scale, mainPanel.Position.X.Offset + mainPanel.AbsoluteSize.X + 15, mainPanel.Position.Y.Scale, mainPanel.Position.Y.Offset)
        
        if pickerPanel.Visible then
            pickerPanel.Position = UDim2.new(0, mainPanel.AbsolutePosition.X + mainPanel.AbsoluteSize.X + 10, 0, mainPanel.AbsolutePosition.Y)
        end
        if subPanel.Visible then
            subPanel.Position = UDim2.new(0, mainPanel.AbsolutePosition.X + mainPanel.AbsoluteSize.X + 10, 0, mainPanel.AbsolutePosition.Y)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragActive = false end
end)

-- ══════════════════════════════════════════════════════════
-- ESP RENDERING
-- ══════════════════════════════════════════════════════════
local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "ESP_Render"
ESPGui.ResetOnSpawn = false
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ESPGui.IgnoreGuiInset = true
ESPGui.Parent = LP:WaitForChild("PlayerGui")

local function getAvatar(uid)
    for attempt = 1, 3 do
        local ok, url = pcall(function()
            return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok and url and url ~= "" then
            return url
        end
        task.wait(1)
    end
    return ""
end

local ESPObjects = {}
local DeathMarkers = {}

local function addDeathMarker(player, position)
    if not CONFIG.DeadESP then return end
    
    local marker = {
        Time = tick(),
        Pos = position,
        Name = player.Name,
        Line1 = Drawing.new("Line"),
        Line2 = Drawing.new("Line"),
        Text = Drawing.new("Text")
    }
    
    marker.Line1.Thickness = 1
    marker.Line1.Visible = false
    marker.Line2.Thickness = 1
    marker.Line2.Visible = false
    
    marker.Text.Size = 13
    marker.Text.Center = true
    marker.Text.Outline = true
    marker.Text.Font = Drawing.Fonts.UI
    marker.Text.Visible = false
    marker.Text.Text = marker.Name .. " (DEAD)"
    
    table.insert(DeathMarkers, marker)
end

local function createESP(player)
    local esp = {}

    -- BOX SEGMENTED (Drawing)
    esp.BoxOutline = {}
    esp.BoxSegments = {} -- 10 vertical + 2 horizontal = 12 lines
    for i = 1, 12 do
        local o = Drawing.new("Line")
        o.Color = Color3.fromRGB(0, 0, 0)
        o.Thickness = 3
        o.Visible = false
        esp.BoxOutline[i] = o

        local l = Drawing.new("Line")
        l.Thickness = 1.5
        l.Visible = false
        esp.BoxSegments[i] = l
    end

    -- SKELETON (Drawing)
    esp.SkeletonOutline = {}
    esp.Skeleton = {}
    for i = 1, 15 do
        local o = Drawing.new("Line")
        o.Thickness = 3
        o.Color = Color3.new(0,0,0)
        o.Visible = false
        esp.SkeletonOutline[i] = o

        local l = Drawing.new("Line")
        l.Thickness = 1.2
        l.Color = CONFIG.SkeletonColor
        l.Visible = false
        esp.Skeleton[i] = l
    end

    -- TRACER (Drawing)
    local tOut = Drawing.new("Line")
    tOut.Thickness = 3
    tOut.Color = Color3.new(0,0,0)
    tOut.Visible = false
    esp.TracerOutline = tOut

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = CONFIG.TracersColor
    tracer.Visible = false
    esp.Tracer = tracer

    -- HEALTH BAR (Drawing)
    local hbOut = Drawing.new("Line")
    hbOut.Thickness = 3
    hbOut.Color = Color3.new(0,0,0)
    hbOut.Visible = false
    esp.HealthBarOutline = hbOut

    local hb = Drawing.new("Line")
    hb.Thickness = 1
    hb.Visible = false
    esp.HealthBar = hb

    -- INFO PANEL (CanvasGroup for animations!)
    local panel = Instance.new("CanvasGroup")
    panel.BackgroundColor3 = CONFIG.PanelBgColor
    panel.BackgroundTransparency = 0
    panel.BorderSizePixel = 0
    panel.Size = UDim2.new(0, 0, 0, 0)
    panel.Visible = false
    panel.GroupTransparency = 1
    panel.ClipsDescendants = true
    panel.Parent = ESPGui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 6)

    local pScale = Instance.new("UIScale", panel)
    pScale.Scale = 0.7

    local pad = Instance.new("UIPadding", panel)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)

    local lay = Instance.new("UIListLayout", panel)
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.Padding = UDim.new(0, 6)

    esp.PanelLayout = lay
    esp.CurrentPanelSize = Vector2.new(0, 0)
    
    -- Tracker states for animations
    esp.BoxAlpha = 0
    esp.SkeletonAlpha = 0
    esp.PanelAlpha = 0
    esp.TracerAlpha = 0
    esp.HealthBarAlpha = 0
    esp.Scale = 0.7
    esp.LastValidPos = {tS = Vector3.new(0,0,0), bS = Vector3.new(0,0,0), dist = 0}

    -- Дистанция (1)
    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "1_Dist"
    distLbl.BackgroundTransparency = 1
    distLbl.AutomaticSize = Enum.AutomaticSize.XY
    distLbl.Font = Enum.Font.GothamMedium
    distLbl.TextColor3 = CONFIG.DistanceColor
    distLbl.TextSize = 12
    distLbl.Text = "0m"
    distLbl.LayoutOrder = 1
    distLbl.Parent = panel

    -- Разделитель 1 (2)
    local d1 = Instance.new("Frame")
    d1.Name = "2_Div"
    d1.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    d1.BackgroundTransparency = 0.2
    d1.BorderSizePixel = 0
    d1.Size = UDim2.new(0, 2, 0, 12)
    d1.LayoutOrder = 2
    d1.Parent = panel

    -- Аватарка (3)
    local avImg = Instance.new("ImageLabel")
    avImg.Name = "3_Av"
    avImg.Size = UDim2.new(0, 16, 0, 16)
    avImg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    avImg.ScaleType = Enum.ScaleType.Crop
    avImg.BorderSizePixel = 0
    avImg.LayoutOrder = 3
    avImg.Parent = panel
    Instance.new("UICorner", avImg).CornerRadius = UDim.new(0, 3)

    task.spawn(function()
        local url = getAvatar(player.UserId)
        if url ~= "" then avImg.Image = url end
    end)

    -- Разделитель 2 (4)
    local d2 = Instance.new("Frame")
    d2.Name = "4_Div"
    d2.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    d2.BackgroundTransparency = 0.2
    d2.BorderSizePixel = 0
    d2.Size = UDim2.new(0, 2, 0, 12)
    d2.LayoutOrder = 4
    d2.Parent = panel

    -- Имя (5)
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "5_Name"
    nameLbl.BackgroundTransparency = 1
    nameLbl.AutomaticSize = Enum.AutomaticSize.XY
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextColor3 = CONFIG.NameColor
    nameLbl.TextSize = 12
    nameLbl.Text = player.Name
    nameLbl.LayoutOrder = 5
    nameLbl.Parent = panel

    -- Разделитель 3 (6)
    local d3 = Instance.new("Frame")
    d3.Name = "6_Div"
    d3.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    d3.BackgroundTransparency = 0.2
    d3.BorderSizePixel = 0
    d3.Size = UDim2.new(0, 2, 0, 12)
    d3.LayoutOrder = 6
    d3.Parent = panel

    -- HP (7)
    local hpFrame = Instance.new("Frame")
    hpFrame.Name = "7_HP"
    hpFrame.BackgroundTransparency = 1
    hpFrame.AutomaticSize = Enum.AutomaticSize.XY
    hpFrame.LayoutOrder = 7
    hpFrame.Parent = panel
    
    local hpLay = Instance.new("UIListLayout")
    hpLay.SortOrder = Enum.SortOrder.LayoutOrder
    hpLay.FillDirection = Enum.FillDirection.Horizontal
    hpLay.VerticalAlignment = Enum.VerticalAlignment.Center
    hpLay.Padding = UDim.new(0, 2)
    hpLay.Parent = hpFrame

    local heart = Instance.new("TextLabel")
    heart.BackgroundTransparency = 1
    heart.AutomaticSize = Enum.AutomaticSize.XY
    heart.Font = Enum.Font.GothamMedium
    heart.TextColor3 = CONFIG.HeartColor
    heart.TextSize = 13
    heart.Text = "♥"
    heart.LayoutOrder = 1
    heart.Parent = hpFrame

    local hpLbl = Instance.new("TextLabel")
    hpLbl.BackgroundTransparency = 1
    hpLbl.AutomaticSize = Enum.AutomaticSize.XY
    hpLbl.Font = Enum.Font.GothamMedium
    hpLbl.TextColor3 = CONFIG.HealthColor
    hpLbl.TextSize = 12
    hpLbl.Text = "100"
    hpLbl.LayoutOrder = 2
    hpLbl.Parent = hpFrame

    esp.Panel = panel
    esp.PanelScale = pScale
    esp.DistLbl = distLbl
    esp.NameLbl = nameLbl
    esp.HpLbl = hpLbl
    esp.Heart = heart
    esp.AvatarImg = avImg
    esp.Dividers = {d1, d2, d3}
    esp.HpFrame = hpFrame -- Добавил ссылку на фрейм HP

    local function setupDeathListener(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if hum then
            hum.Died:Connect(function()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    addDeathMarker(player, hrp.Position)
                end
            end)
        end
    end

    if player.Character then setupDeathListener(player.Character) end
    player.CharacterAdded:Connect(setupDeathListener)

    ESPObjects[player] = esp
end

local function removeESP(player)
    local e = ESPObjects[player]
    if not e then return end
    for _, l in pairs(e.BoxOutline) do l:Remove() end
    for _, l in pairs(e.BoxSegments) do l:Remove() end
    for _, l in pairs(e.SkeletonOutline) do l:Remove() end
    for _, l in pairs(e.Skeleton) do l:Remove() end
    if e.TracerOutline then e.TracerOutline:Remove() end
    if e.Tracer then e.Tracer:Remove() end
    if e.HealthBarOutline then e.HealthBarOutline:Remove() end
    if e.HealthBar then e.HealthBar:Remove() end
    e.Panel:Destroy()
    ESPObjects[player] = nil
end

local function hideESP(e)
    e.BoxAlpha = 0
    e.SkeletonAlpha = 0
    e.PanelAlpha = 0
    e.TracerAlpha = 0
    e.HealthBarAlpha = 0
    for _, l in pairs(e.BoxOutline) do l.Visible = false end
    for _, l in pairs(e.BoxSegments) do l.Visible = false end
    for _, l in pairs(e.SkeletonOutline) do l.Visible = false end
    for _, l in pairs(e.Skeleton) do l.Visible = false end
    if e.TracerOutline then e.TracerOutline.Visible = false end
    if e.Tracer then e.Tracer.Visible = false end
    if e.HealthBarOutline then e.HealthBarOutline.Visible = false end
    if e.HealthBar then e.HealthBar.Visible = false end
    e.Panel.Visible = false
end

local function updateESP(player, e, tracerOrigin)
    -- Target checking
    local ch = player.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    
    local active = (CONFIG.Enabled and ch and hum and hrp and hum.Health > 0 and (not CONFIG.TeamCheck or player.Team ~= LP.Team))
    local pos, dist
    if active then
        pos = hrp.Position
        dist = (Camera.CFrame.Position - pos).Magnitude / 3
        if dist > CONFIG.MaxDistance then active = false end
    end

    e.visCache = e.visCache or {}
    e.lastCheck = e.lastCheck or 0
    local now = tick()

    if active and CONFIG.VisibilityCheck then
        sharedRayParams.FilterDescendantsInstances = {LP.Character, ch}

        -- Dynamic frequency based on distance (closer = faster, further = slower)
        local freq = (dist < 50) and 0.05 or (dist < 200 and 0.2 or (dist < 500 and 0.5 or 2.0))
        if now - e.lastCheck > freq then
            e.lastCheck = now
            local camPos = Camera.CFrame.Position
            local rigType = hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
            
            local checked = {}
            for _, conn in ipairs(BONES[rigType]) do
                for _, partName in ipairs(conn) do
                    if not checked[partName] then
                        checked[partName] = true
                        local part = ch:FindFirstChild(partName)
                        if part then
                            local res = SafeRaycast(camPos, part.Position, sharedRayParams)
                            e.visCache[partName] = not res
                        end
                    end
                end
            end
        end
    end

    -- Evaluate component visibility based on actual skeleton parts
    local function getC(pList)
        if not CONFIG.VisibilityCheck then return true end
        for _, pListName in ipairs(pList) do
            if e.visCache[pListName] then return true end
        end
        return false
    end

    local visL = {
        getC({"Head"}),
        getC({"LeftUpperArm", "Left Arm"}),
        getC({"LeftLowerArm", "LeftHand", "LowerTorso", "Torso"}),
        getC({"LeftUpperLeg", "Left Leg"}),
        getC({"LeftFoot", "LeftLowerLeg", "Left Leg"})
    }
    local visR = {
        getC({"Head"}),
        getC({"RightUpperArm", "Right Arm"}),
        getC({"RightLowerArm", "RightHand", "LowerTorso", "Torso"}),
        getC({"RightUpperLeg", "Right Leg"}),
        getC({"RightFoot", "RightLowerLeg", "Right Leg"})
    }

    local isVisible = false
    for i=1,5 do if visL[i] or visR[i] then isVisible = true break end end
    local espColor = isVisible and (CONFIG.VisibilityCheck and CONFIG.VisibleColor or nil) or (CONFIG.VisibilityCheck and CONFIG.HiddenColor or nil)

    local function getPartColor(side, lvl)
        local vs = (side == "L") and visL[lvl] or visR[lvl]
        return vs and (CONFIG.VisibilityCheck and CONFIG.VisibleColor or CONFIG.BoxColor) or (CONFIG.VisibilityCheck and CONFIG.HiddenColor or CONFIG.BoxColor)
    end

    -- Animation Logic (Interpolation)
    local lerpSpeed = 0.15
    local function anim(cur, target)
        cur = cur or 0 -- Fail-safe if not initialized
        if math.abs(cur - target) < 0.001 then return target end
        return cur + (target - cur) * lerpSpeed
    end

    local targetBoxAlpha = (active and CONFIG.BoxEnabled) and 1 or 0
    local targetSkelAlpha = (active and CONFIG.SkeletonEnabled) and 1 or 0
    local targetPanelAlpha = (active and CONFIG.PanelEnabled and (CONFIG.ShowDistance or CONFIG.ShowAvatar or CONFIG.ShowName or CONFIG.ShowHealth)) and 1 or 0
    local targetTracerAlpha = (active and CONFIG.TracersEnabled) and 1 or 0
    local targetHealthBarAlpha = (active and CONFIG.HealthBarEnabled and CONFIG.BoxEnabled) and 1 or 0

    e.BoxAlpha = anim(e.BoxAlpha, targetBoxAlpha)
    e.SkeletonAlpha = anim(e.SkeletonAlpha, targetSkelAlpha)
    e.PanelAlpha = anim(e.PanelAlpha, targetPanelAlpha)
    e.TracerAlpha = anim(e.TracerAlpha, targetTracerAlpha)
    e.HealthBarAlpha = anim(e.HealthBarAlpha, targetHealthBarAlpha)
    e.Scale = anim(e.Scale, targetPanelAlpha > 0.5 and 1 or 0.7)

    -- Update Viewport Positions
    local tS, bS, tOn, bOn
    if active then
        tS, tOn = Camera:WorldToViewportPoint(pos + Vector3.new(0, 3.2, 0))
        bS, bOn = Camera:WorldToViewportPoint(pos - Vector3.new(0, 3.2, 0))
        if tOn or bOn then
            e.LastValidPos = {tS = tS, bS = bS, dist = dist}
        end
    elseif e.LastValidPos then
        tS, bS = e.LastValidPos.tS, e.LastValidPos.bS
        dist = e.LastValidPos.dist
    else
        -- Fallback if no last valid pos
        tS, bS = Vector3.new(0,0,0), Vector3.new(0,0,0)
        dist = 0
    end

    if (active and (tOn or bOn)) or (not active and (e.BoxAlpha > 0.01 or e.SkeletonAlpha > 0.01 or e.TracerAlpha > 0.01 or e.HealthBarAlpha > 0.01)) then
        local bH = math.abs(tS.Y - bS.Y)
        local bW = bH * 0.55
        local cX = tS.X

        local corners = {
            Vector2.new(cX - bW/2, tS.Y),
            Vector2.new(cX + bW/2, tS.Y),
            Vector2.new(cX + bW/2, bS.Y),
            Vector2.new(cX - bW/2, bS.Y),
        }

        -- === BOX RENDERING (Segmented Precision) ===
        if e.BoxAlpha > 0.01 then
            local segHeight = bH / 5
            for i = 1, 5 do
                local segTopY = tS.Y + (i-1) * segHeight
                local segBotY = tS.Y + i * segHeight
                
                -- Left side
                local lColor = getPartColor("L", i)
                local lIdx = i
                local lFrom = Vector2.new(cX - bW/2, segTopY)
                local lTo = Vector2.new(cX - bW/2, segBotY)
                e.BoxOutline[lIdx].From, e.BoxOutline[lIdx].To = lFrom, lTo
                e.BoxOutline[lIdx].Transparency, e.BoxOutline[lIdx].Visible = e.BoxAlpha * 0.5, true
                e.BoxSegments[lIdx].From, e.BoxSegments[lIdx].To = lFrom, lTo
                e.BoxSegments[lIdx].Color, e.BoxSegments[lIdx].Transparency, e.BoxSegments[lIdx].Visible = lColor, e.BoxAlpha, true

                -- Right side
                local rColor = getPartColor("R", i)
                local rIdx = i + 5
                local rFrom = Vector2.new(cX + bW/2, segTopY)
                local rTo = Vector2.new(cX + bW/2, segBotY)
                e.BoxOutline[rIdx].From, e.BoxOutline[rIdx].To = rFrom, rTo
                e.BoxOutline[rIdx].Transparency, e.BoxOutline[rIdx].Visible = e.BoxAlpha * 0.5, true
                e.BoxSegments[rIdx].From, e.BoxSegments[rIdx].To = rFrom, rTo
                e.BoxSegments[rIdx].Color, e.BoxSegments[rIdx].Transparency, e.BoxSegments[rIdx].Visible = rColor, e.BoxAlpha, true
            end

            -- Top horizontal (uses mixed visibility)
            local topColor = (visL[1] or visR[1]) and (CONFIG.VisibilityCheck and CONFIG.VisibleColor or CONFIG.BoxColor) or (CONFIG.VisibilityCheck and CONFIG.HiddenColor or CONFIG.BoxColor)
            e.BoxOutline[11].From, e.BoxOutline[11].To = Vector2.new(cX - bW/2, tS.Y), Vector2.new(cX + bW/2, tS.Y)
            e.BoxOutline[11].Transparency, e.BoxOutline[11].Visible = e.BoxAlpha * 0.5, true
            e.BoxSegments[11].From, e.BoxSegments[11].To = Vector2.new(cX - bW/2, tS.Y), Vector2.new(cX + bW/2, tS.Y)
            e.BoxSegments[11].Color, e.BoxSegments[11].Transparency, e.BoxSegments[11].Visible = topColor, e.BoxAlpha, true

            -- Bottom horizontal
            local botColor = (visL[5] or visR[5]) and (CONFIG.VisibilityCheck and CONFIG.VisibleColor or CONFIG.BoxColor) or (CONFIG.VisibilityCheck and CONFIG.HiddenColor or CONFIG.BoxColor)
            e.BoxOutline[12].From, e.BoxOutline[12].To = Vector2.new(cX - bW/2, bS.Y), Vector2.new(cX + bW/2, bS.Y)
            e.BoxOutline[12].Transparency, e.BoxOutline[12].Visible = e.BoxAlpha * 0.5, true
            e.BoxSegments[12].From, e.BoxSegments[12].To = Vector2.new(cX - bW/2, bS.Y), Vector2.new(cX + bW/2, bS.Y)
            e.BoxSegments[12].Color, e.BoxSegments[12].Transparency, e.BoxSegments[12].Visible = botColor, e.BoxAlpha, true
        else
            for i = 1, 12 do e.BoxOutline[i].Visible, e.BoxSegments[i].Visible = false, false end
        end

        -- === SKELETON RENDERING ===
        if e.SkeletonAlpha > 0.01 and active then
            local rigType = hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
            local bones = BONES[rigType]
            local lineCount = #bones
            
            for i = 1, 15 do
                local line = e.Skeleton[i]
                local outline = e.SkeletonOutline[i]
                if not line then continue end
                
                if i <= lineCount then
                    local connection = bones[i]
                    local p1 = ch:FindFirstChild(connection[1])
                    local p2 = ch:FindFirstChild(connection[2])
                    
                    if p1 and p2 then
                        local v1, on1 = Camera:WorldToViewportPoint(p1.Position)
                        local v2, on2 = Camera:WorldToViewportPoint(p2.Position)
                        
                        -- Draw even if one point is off-screen, as long as both are in front of camera
                        if v1.Z > 0 and v2.Z > 0 then
                            local from, to = Vector2.new(v1.X, v1.Y), Vector2.new(v2.X, v2.Y)
                            
                            outline.From = from
                            outline.To = to
                            outline.Transparency = e.SkeletonAlpha * 0.5
                            outline.Visible = true

                            line.From = from
                            line.To = to
                            line.Color = espColor or CONFIG.SkeletonColor
                            line.Transparency = e.SkeletonAlpha
                            line.Visible = true
                        else
                            line.Visible = false
                            outline.Visible = false
                        end
                    else
                        line.Visible = false
                        outline.Visible = false
                    end
                else
                    -- Hide extra lines if moving from R15 to R6
                    line.Visible = false
                    outline.Visible = false
                end
            end
        else
            for i = 1, 15 do
                if e.Skeleton[i] then e.Skeleton[i].Visible = false end
                if e.SkeletonOutline[i] then e.SkeletonOutline[i].Visible = false end
            end
        end

        -- === TRACER RENDERING ===
        if e.TracerAlpha > 0.01 and tracerOrigin then
            local targetPos = Vector2.new(bS.X, bS.Y)

            e.TracerOutline.From = tracerOrigin
            e.TracerOutline.To = targetPos
            e.TracerOutline.Transparency = e.TracerAlpha * 0.5
            e.TracerOutline.Visible = true

            e.Tracer.From = tracerOrigin
            e.Tracer.To = targetPos
            e.Tracer.Color = espColor or CONFIG.TracersColor
            e.Tracer.Transparency = e.TracerAlpha
            e.Tracer.Visible = true
        else
            e.Tracer.Visible = false
            e.TracerOutline.Visible = false
        end

        -- === HEALTH BAR RENDERING ===
        if e.HealthBarAlpha > 0.01 and hum then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local green = Color3.fromRGB(0, 255, 0)
            local red = Color3.fromRGB(255, 0, 0)
            local hpColor = red:Lerp(green, hp)

            local hbTop = corners[1] + Vector2.new(-5, 0)
            local hbBot = corners[4] + Vector2.new(-5, 0)

            e.HealthBarOutline.From = hbTop
            e.HealthBarOutline.To = hbBot
            e.HealthBarOutline.Transparency = e.HealthBarAlpha * 0.5
            e.HealthBarOutline.Visible = true

            e.HealthBar.From = hbBot
            e.HealthBar.To = hbBot:Lerp(hbTop, hp)
            e.HealthBar.Color = hpColor
            e.HealthBar.Transparency = e.HealthBarAlpha
            e.HealthBar.Visible = true
        else
            e.HealthBarOutline.Visible, e.HealthBar.Visible = false, false
        end

        -- === PANEL RENDERING ===
        if e.PanelAlpha > 0.01 then
            if active then
                local fontSize = math.clamp(math.floor(73 / math.max(dist, 1) * 12 + 0.5), 9, 16)
                local avSize = math.clamp(fontSize + 2, 11, 18)

                local fdist = math.floor(dist)
                if e.LastTextDist ~= fdist then
                    e.LastTextDist = fdist
                    e.DistLbl.Text = fdist .. "m"
                end
                e.DistLbl.TextSize = fontSize
                e.DistLbl.TextColor3 = CONFIG.DistanceColor
                e.DistLbl.Visible = CONFIG.ShowDistance

                local fhp = math.floor(hum.Health)
                if e.LastTextHp ~= fhp then
                    e.LastTextHp = fhp
                    e.HpLbl.Text = tostring(fhp)
                end
                e.HpLbl.TextSize = fontSize
                e.HpLbl.TextColor3 = CONFIG.HealthColor
                
                e.Heart.TextSize = fontSize + 1
                e.Heart.TextColor3 = CONFIG.HeartColor
                e.HpFrame.Visible = CONFIG.ShowHealth

                e.NameLbl.TextSize = fontSize
                e.NameLbl.TextColor3 = CONFIG.NameColor
                e.NameLbl.Visible = CONFIG.ShowName

                local targetAvSize = math.clamp(fontSize + 2, 11, 18)
                if e.LastAvSize ~= targetAvSize then
                    e.LastAvSize = targetAvSize
                    e.AvatarImg.Size = UDim2.new(0, targetAvSize, 0, targetAvSize)
                end
                e.AvatarImg.Visible = CONFIG.ShowAvatar
            end

            e.Panel.BackgroundColor3 = CONFIG.PanelBgColor
            e.Panel.GroupTransparency = 1 - e.PanelAlpha
            e.PanelScale.Scale = e.Scale

            e.Dividers[1].Visible = CONFIG.ShowDistance and (CONFIG.ShowAvatar or CONFIG.ShowName or CONFIG.ShowHealth)
            e.Dividers[2].Visible = CONFIG.ShowAvatar and (CONFIG.ShowName or CONFIG.ShowHealth)
            e.Dividers[3].Visible = CONFIG.ShowName and CONFIG.ShowHealth

            -- Size Stretching Animation with optimization for CanvasGroup
            local absSize = e.PanelLayout.AbsoluteContentSize
            if absSize.X > 0 then
                local targetSize = absSize + Vector2.new(12, 8)
                if (e.CurrentPanelSize - targetSize).Magnitude > 0.5 then
                    e.CurrentPanelSize = e.CurrentPanelSize:Lerp(targetSize, 0.15)
                    e.Panel.Size = UDim2.new(0, math.round(e.CurrentPanelSize.X), 0, math.round(e.CurrentPanelSize.Y))
                end
            end

            e.Panel.Position = UDim2.new(0, cX - (e.CurrentPanelSize.X / 2), 0, tS.Y - e.CurrentPanelSize.Y - 6)
            e.Panel.Visible = true
        else
            e.Panel.Visible = false
            e.CurrentPanelSize = Vector2.new(0, 0)
        end
    else
        hideESP(e)
    end
end

-- ═══════════ INIT ═══════════
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then createESP(p) end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LP then createESP(p) end
end)

Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    local tOrigin
    if CONFIG.TracersEnabled then
        local vSize = Camera.ViewportSize
        if CONFIG.TracerOrigin == "Bottom" then
            tOrigin = Vector2.new(vSize.X/2, vSize.Y)
        elseif CONFIG.TracerOrigin == "Top" then
            tOrigin = Vector2.new(vSize.X/2, 0)
        elseif CONFIG.TracerOrigin == "Middle" then
            tOrigin = Vector2.new(vSize.X/2, vSize.Y/2)
        else
            tOrigin = UIS:GetMouseLocation()
        end
    end

    for p, e in pairs(ESPObjects) do
        local ok, err = pcall(function()
            updateESP(p, e, tOrigin)
        end)
        if not ok then
            warn("[ESP] Error updating for " .. tostring(p) .. ": " .. tostring(err))
        end
    end

    -- Dead ESP Rendering
    for i = #DeathMarkers, 1, -1 do
        local m = DeathMarkers[i]
        local age = tick() - m.Time
        
        if age > CONFIG.DeadESPDuration or not CONFIG.Enabled then
            m.Line1:Remove()
            m.Line2:Remove()
            m.Text:Remove()
            table.remove(DeathMarkers, i)
        elseif CONFIG.DeadESP then
            local pos, on = Camera:WorldToViewportPoint(m.Pos)
            local dist = (Camera.CFrame.Position - m.Pos).Magnitude / 3

            if on and dist <= CONFIG.MaxDistance then
                local s = 8
                m.Line1.From = Vector2.new(pos.X - s, pos.Y - s)
                m.Line1.To = Vector2.new(pos.X + s, pos.Y + s)
                m.Line1.Color = CONFIG.DeadESPColor
                m.Line1.Visible = true
                
                m.Line2.From = Vector2.new(pos.X + s, pos.Y - s)
                m.Line2.To = Vector2.new(pos.X - s, pos.Y + s)
                m.Line2.Color = CONFIG.DeadESPColor
                m.Line2.Visible = true
                
                local timeLeft = math.max(0, math.floor(CONFIG.DeadESPDuration - age))
                m.Text.Text = string.format("%s (DEAD) [%dm] [%ds]", m.Name, math.floor(dist), timeLeft)
                m.Text.Position = Vector2.new(pos.X, pos.Y + s + 2)
                m.Text.Color = CONFIG.DeadESPColor
                m.Text.Visible = true
            else
                m.Line1.Visible = false
                m.Line2.Visible = false
                m.Text.Visible = false
            end
        else
            m.Line1.Visible = false
            m.Line2.Visible = false
            m.Text.Visible = false
        end
    end
end)

-- ═══════════ LOCAL PLAYER ESP ═══════════
local localESP = { Box = {}, Skeleton = {}, HealthBar = nil, HealthBarBg = nil, Tracer = nil }
for i = 1, 4 do
    local l = Drawing.new("Line"); l.Thickness = 1.5; l.Visible = false
    localESP.Box[i] = l
end
for i = 1, 15 do
    local l = Drawing.new("Line"); l.Thickness = 1.2; l.Visible = false
    localESP.Skeleton[i] = l
end
localESP.HealthBar    = Drawing.new("Line"); localESP.HealthBar.Thickness    = 3; localESP.HealthBar.Visible    = false
localESP.HealthBarBg  = Drawing.new("Line"); localESP.HealthBarBg.Thickness  = 3; localESP.HealthBarBg.Color = Color3.fromRGB(50,50,50); localESP.HealthBarBg.Visible = false
localESP.Tracer       = Drawing.new("Line"); localESP.Tracer.Thickness       = 1; localESP.Tracer.Visible       = false

RunService.RenderStepped:Connect(function()
    local ch  = LP.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")

    if not CONFIG.LocalPlayerESP or not ch or not hum or not hrp or hum.Health <= 0 then
        for _, l in pairs(localESP.Box) do l.Visible = false end
        for _, l in pairs(localESP.Skeleton) do l.Visible = false end
        localESP.HealthBar.Visible = false; localESP.HealthBarBg.Visible = false
        localESP.Tracer.Visible = false
        return
    end

    local col = CONFIG.LocalPlayerColor
    local rigType = hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"

    local function proj(v3)
        local p, vis = Camera:WorldToViewportPoint(v3)
        if not vis or p.Z <= 0 then return nil end
        return Vector2.new(p.X, p.Y)
    end

    -- BOX + HEALTH BAR
    local head  = ch:FindFirstChild("Head")
    local lFoot = ch:FindFirstChild("LeftFoot")  or ch:FindFirstChild("Left Leg")
    local rFoot = ch:FindFirstChild("RightFoot") or ch:FindFirstChild("Right Leg")
    if CONFIG.LocalBox and head and (lFoot or rFoot) then
        local topPx = proj(head.Position + Vector3.new(0, 0.8, 0))
        local footPos = (lFoot and rFoot) and (lFoot.Position + rFoot.Position)/2 or (lFoot or rFoot).Position
        local botPx = proj(footPos - Vector3.new(0, 0.5, 0))
        if topPx and botPx then
            local bH = math.abs(botPx.Y - topPx.Y)
            local bW = bH * 0.55
            local cX = (topPx.X + botPx.X) / 2
            local tY, bY = math.min(topPx.Y, botPx.Y), math.max(topPx.Y, botPx.Y)
            local lX, rX = cX - bW/2, cX + bW/2
            localESP.Box[1].From = Vector2.new(lX, tY); localESP.Box[1].To = Vector2.new(rX, tY)
            localESP.Box[2].From = Vector2.new(lX, bY); localESP.Box[2].To = Vector2.new(rX, bY)
            localESP.Box[3].From = Vector2.new(lX, tY); localESP.Box[3].To = Vector2.new(lX, bY)
            localESP.Box[4].From = Vector2.new(rX, tY); localESP.Box[4].To = Vector2.new(rX, bY)
            for _, l in pairs(localESP.Box) do l.Color = CONFIG.LocalBoxColor; l.Visible = true end
            if CONFIG.LocalHealthBar then
                local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                local hpCol = Color3.fromRGB(255,0,0):Lerp(Color3.fromRGB(0,255,0), hp)
                local barX = lX - 5
                localESP.HealthBarBg.From = Vector2.new(barX, tY); localESP.HealthBarBg.To = Vector2.new(barX, bY); localESP.HealthBarBg.Visible = true
                localESP.HealthBar.From   = Vector2.new(barX, bY); localESP.HealthBar.To   = Vector2.new(barX, bY - bH * hp); localESP.HealthBar.Color = hpCol; localESP.HealthBar.Visible = true
            else localESP.HealthBar.Visible = false; localESP.HealthBarBg.Visible = false end
        else
            for _, l in pairs(localESP.Box) do l.Visible = false end
            localESP.HealthBar.Visible = false; localESP.HealthBarBg.Visible = false
        end
    else
        for _, l in pairs(localESP.Box) do l.Visible = false end
        localESP.HealthBar.Visible = false; localESP.HealthBarBg.Visible = false
    end

    -- SKELETON
    if CONFIG.LocalSkeleton and BONES[rigType] then
        local idx = 1
        for _, pair in ipairs(BONES[rigType]) do
            local p1 = ch:FindFirstChild(pair[1])
            local p2 = ch:FindFirstChild(pair[2])
            local line = localESP.Skeleton[idx]
            if line then
                if p1 and p2 then
                    local s1, s2 = proj(p1.Position), proj(p2.Position)
                    if s1 and s2 then line.From = s1; line.To = s2; line.Color = CONFIG.LocalSkeletonColor; line.Visible = true
                    else line.Visible = false end
                else line.Visible = false end
                idx = idx + 1
            end
        end
        for i = idx, #localESP.Skeleton do localESP.Skeleton[i].Visible = false end
    else for _, l in pairs(localESP.Skeleton) do l.Visible = false end end

    -- TRACER
    if CONFIG.LocalTracers then
        local hrpPx = proj(hrp.Position)
        if hrpPx then
            local vS = Camera.ViewportSize
            localESP.Tracer.From = Vector2.new(vS.X/2, vS.Y); localESP.Tracer.To = hrpPx
            localESP.Tracer.Color = CONFIG.LocalTracersColor; localESP.Tracer.Visible = true
        else localESP.Tracer.Visible = false end
    else localESP.Tracer.Visible = false end
end)

local savedSettings = nil
local effectsCache = {}

local function updateLighting()
    if CONFIG.AmbienceEnabled then
        if not savedSettings then
            savedSettings = {
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                Brightness = Lighting.Brightness,
                GlobalShadows = Lighting.GlobalShadows,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart,
                ExposureCompensation = Lighting.ExposureCompensation,
                EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
                EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
                ShadowSoftness = Lighting.ShadowSoftness
            }
        end

        if Lighting.Ambient ~= CONFIG.AmbienceColor then
            Lighting.Ambient = CONFIG.AmbienceColor
            Lighting.OutdoorAmbient = CONFIG.AmbienceColor
        end
    else
        if savedSettings then
            -- Restore everything
            Lighting.Ambient = savedSettings.Ambient
            Lighting.OutdoorAmbient = savedSettings.OutdoorAmbient
            Lighting.Brightness = savedSettings.Brightness
            Lighting.GlobalShadows = savedSettings.GlobalShadows
            Lighting.ClockTime = savedSettings.ClockTime
            Lighting.FogEnd = savedSettings.FogEnd
            Lighting.FogStart = savedSettings.FogStart
            Lighting.ExposureCompensation = savedSettings.ExposureCompensation
            Lighting.EnvironmentDiffuseScale = savedSettings.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = savedSettings.EnvironmentSpecularScale
            Lighting.ShadowSoftness = savedSettings.ShadowSoftness
            
            for obj, _ in pairs(effectsCache) do
                if obj and obj.Parent then obj.Enabled = true end
            end
            effectsCache = {}
            savedSettings = nil
        end
    end
end

-- Use BindToRenderStep to run AFTER game scripts but BEFORE render
RunService:BindToRenderStep("LightingOverride", Enum.RenderPriority.Camera.Value + 1, updateLighting)

print("[ESP] Loaded! Press INSERT for settings.")
updateBindList()

-- ═══════════ AIMBOT LOGIC ═══════════
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

local aimTarget = nil
local lastCameraRotation = nil

RunService.RenderStepped:Connect(function()
    -- FOV Update
    FOVCircle.Radius = CONFIG.AimbotFOV
    FOVCircle.Color = CONFIG.FOVColor
    FOVCircle.Visible = CONFIG.AimbotEnabled and CONFIG.ShowFOV and not menuOpen
    FOVCircle.Position = UIS:GetMouseLocation()

    -- No Recoil Logic
    if CONFIG.NoRecoilEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local currentRotation = Camera.CFrame.LookVector
        if lastCameraRotation then
            local rotationChange = currentRotation - lastCameraRotation
            if rotationChange.Y > 0.0001 then
                local recoilStrength = rotationChange.Y * CONFIG.NoRecoilStrength * 100
                if mousemoverel then
                    mousemoverel(0, recoilStrength) 
                end
            end
        end
        lastCameraRotation = currentRotation
    else
        lastCameraRotation = nil
    end

    if not CONFIG.AimbotEnabled then 
        aimTarget = nil
        return 
    end

    -- Target selection
    local bestTarget = nil
    local mousePos = UIS:GetMouseLocation()

    -- Improved Lock-on Logic (prioritize current target)
    if aimTarget then
        local p = aimTarget.Player
        local ch = p.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        
        if ch and hum and hrp and hum.Health > 0 then
            local part = ch:FindFirstChild(aimTarget.PartName or "Head")
            if part then
                local sPos, on = Camera:WorldToViewportPoint(part.Position)
                local distToMouse = (Vector2.new(sPos.X, sPos.Y) - mousePos).Magnitude
                
                -- Sticky Retention Logic: If Sticky is enabled, we NEVER drop the target unless they die, 
                -- or move outside the AimbotMaxDistance. FOV check is ignored for active target.
                local worldDistInStuds = (Camera.CFrame.Position - part.Position).Magnitude
                
                local isStillValid = isVis and hum.Health > 0
                local withinRange = (worldDistInStuds / 3) <= CONFIG.AimbotMaxDistance
                
                if isStillValid and withinRange then
                    if CONFIG.AimbotSticky then
                        -- Captured Target: Sticky mode ignores FOV to prevent dropping targets during fast movement
                        bestTarget = aimTarget
                    else
                        -- Standard logic with a slightly larger buffer (20%) for stability
                        if on and distToMouse <= (CONFIG.AimbotFOV * 1.2) then
                            bestTarget = aimTarget
                        end
                    end
                end
            end
        end
    end

    -- Find new target if no valid target is locked
    if not bestTarget then
        aimTarget = nil
        local minScore = math.huge
        for p, e in pairs(ESPObjects) do
            local ch = p.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            
            if ch and hum and hrp and hum.Health > 0 and (not CONFIG.TeamCheck or p.Team ~= LP.Team) then
                local targetPartName = CONFIG.AimbotTargetPart
                if targetPartName == "Random" then
                    local parts = {"Head", "UpperTorso", "LowerTorso"}
                    targetPartName = parts[math.random(1, #parts)]
                end
                
                local part = ch:FindFirstChild(targetPartName)
                if part then
                    local sPos, on = Camera:WorldToViewportPoint(part.Position)
                    if on then
                        local distToMouse = (Vector2.new(sPos.X, sPos.Y) - mousePos).Magnitude
                        
                        -- Simple FOV check for acquisition
                        if distToMouse <= CONFIG.AimbotFOV then
                            -- Visibility check
                            local isVis = true
                            if CONFIG.AimbotVisibleOnly then
                                if e.visCache and e.visCache[targetPartName] ~= nil then
                                    isVis = e.visCache[targetPartName]
                                else
                                    sharedRayParams.FilterDescendantsInstances = {LP.Character, ch}
                                    local res = SafeRaycast(Camera.CFrame.Position, part.Position, sharedRayParams)
                                    isVis = not res
                                end
                            end

                            if isVis then
                                local worldDist = (Camera.CFrame.Position - part.Position).Magnitude / 3
                                if worldDist <= CONFIG.AimbotMaxDistance then
                                    local score = distToMouse + (worldDist * CONFIG.AimbotDistanceWeight)
                                    if score < minScore then
                                        minScore = score
                                        bestTarget = {Player = p, Part = part, PartName = targetPartName}
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Trigger Aim (Right Click Default)
    if bestTarget and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        aimTarget = bestTarget
        local targetPos = bestTarget.Part.Position
        
        -- Advanced Prediction Logic (Sentinel Model)
        if CONFIG.PredictionEnabled and bestTarget.Part then
            local velocity = bestTarget.Part.AssemblyLinearVelocity or bestTarget.Part.Velocity or Vector3.new(0, 0, 0)
            local distInStuds = (Camera.CFrame.Position - targetPos).Magnitude
            local distInMeters = distInStuds / 3
            
            -- Sentinel Mathematical Model:
            -- Calculate prediction based on distance in 10 meter steps up to 1000m
            -- Each 10m adds more prediction time.
            local distanceSteps = math.min(math.floor(distInMeters / 10), 100) -- Max 100 steps (1000m)
            local predictionTime = (distanceSteps / 100) * (CONFIG.PredictionStrength / 10)
            
            -- Apply predicted offset
            targetPos = targetPos + (velocity * predictionTime)
        end
        
        -- Update ray params to ignore LP
        if LP.Character then
            sharedRayParams.FilterDescendantsInstances = {LP.Character, ESPGui}
        end
        
        -- Aim Logic using Mouse Movement
        local sPos, on = Camera:WorldToViewportPoint(targetPos)
        local isStickyClose = CONFIG.AimbotSticky and (Camera.CFrame.Position - targetPos).Magnitude < 80 
        
        if on or isStickyClose then
            local mouseLocation = UIS:GetMouseLocation()
            local deltaX, deltaY
            
            if on then
                deltaX = sPos.X - mouseLocation.X
                deltaY = sPos.Y - mouseLocation.Y
            else
                -- Target passed through or is behind. Stick to them by forcing rotation!
                local localPos = Camera.CFrame:PointToObjectSpace(targetPos)
                -- We move the mouse strongly in the direction of the target to flip the camera
                deltaX = (localPos.X > 0 and 100 or -100) 
                deltaY = (localPos.Y > 0 and 100 or -100)
                -- We use a smaller delta but it's constant until they're back on screen
            end
            
            local smoothness = 1
            if CONFIG.AimbotSmoothness > 0 then
                -- When target is behind, we reduce smoothness slightly to flick faster
                local smoothFactor = on and 12 or 4
                smoothness = 1 + (CONFIG.AimbotSmoothness * smoothFactor)
            end
            
            if mousemoverel then
                mousemoverel(deltaX / smoothness, deltaY / smoothness)
            end
        end

        -- Character Look-at (Third Person / RootPart)
        if LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local lookAtPos = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)
                hrp.CFrame = CFrame.new(hrp.Position, lookAtPos)
            end
        end
    else
        aimTarget = nil
    end
end)

-- ════════════ MISC LOGIC ════════════
local function applyJump()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and CONFIG.HighJumpEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = CONFIG.HighJumpValue
        hum.JumpHeight = CONFIG.HighJumpValue
    end
end

RunService.Heartbeat:Connect(applyJump)

-- Force jump state when pressing space (helps in many games)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space and CONFIG.HighJumpEnabled then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Small delay and state change to force the engine to register high jump
            task.spawn(function()
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end
end)

-- ════════════ CUSTOM SCOPE RENDERING ════════════
local function createLine(thick)
    local l = Drawing.new("Line")
    l.Thickness = thick or 1.5
    l.Transparency = 1
    l.Visible = false
    return l
end

local Scope = {
    Top = createLine(), TopOut = createLine(3),
    Bottom = createLine(), BottomOut = createLine(3),
    Left = createLine(), LeftOut = createLine(3),
    Right = createLine(), RightOut = createLine(3),
    Dot = Drawing.new("Circle"), DotOut = Drawing.new("Circle")
}
Scope.TopOut.Color = Color3.new(0,0,0)
Scope.BottomOut.Color = Color3.new(0,0,0)
Scope.LeftOut.Color = Color3.new(0,0,0)
Scope.RightOut.Color = Color3.new(0,0,0)
Scope.Dot.Filled = true
Scope.DotOut.Filled = true
Scope.DotOut.Color = Color3.new(0,0,0)

RunService.RenderStepped:Connect(function()
    local enabled = CONFIG.ScopeEnabled and not menuOpen
    local viewportSize = Camera.ViewportSize
    -- Using math.floor for pixel-perfect alignment
    local cx, cy = math.floor(viewportSize.X / 2), math.floor(viewportSize.Y / 2)
    
    local color = CONFIG.ScopeColor
    local gap = CONFIG.ScopeGap
    local length = CONFIG.ScopeLength
    local thickness = CONFIG.ScopeThickness
    
    for _, obj in pairs(Scope) do obj.Visible = false end

    if enabled then
        local function drawSegment(line, out, x1, y1, x2, y2)
            if CONFIG.ScopeOutline then
                out.From = Vector2.new(x1, y1)
                out.To = Vector2.new(x2, y2)
                out.Thickness = thickness + 2
                out.Visible = true
            end
            
            line.From = Vector2.new(x1, y1)
            line.To = Vector2.new(x2, y2)
            line.Color = color
            line.Thickness = thickness
            line.Visible = true
        end

        -- Top
        drawSegment(Scope.Top, Scope.TopOut, cx, cy - gap, cx, cy - gap - length)
        -- Bottom
        drawSegment(Scope.Bottom, Scope.BottomOut, cx, cy + gap, cx, cy + gap + length)
        -- Left
        drawSegment(Scope.Left, Scope.LeftOut, cx - gap, cy, cx - gap - length, cy)
        -- Right
        drawSegment(Scope.Right, Scope.RightOut, cx + gap, cy, cx + gap + length, cy)
        
        -- Dot
        if CONFIG.ScopeCenterDot then
            if CONFIG.ScopeOutline then
                Scope.DotOut.Position = Vector2.new(cx, cy)
                Scope.DotOut.Radius = thickness + 2
                Scope.DotOut.Visible = true
            end
            
            Scope.Dot.Position = Vector2.new(cx, cy)
            Scope.Dot.Radius = thickness
            Scope.Dot.Color = color
            Scope.Dot.Visible = true
        end
    end
end)

RefreshUI()
refreshCfgList()
