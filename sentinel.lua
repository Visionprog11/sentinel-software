-- ══════════════════════════════════════════════════════════
-- ESP Script + Simple Settings Menu
-- LocalScript | Insert = Toggle Menu
-- ══════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local V = {
    StoredBinds = {},
    currentlyBinding = nil,
    isAuthorized = false,
    githubKeysURL = "https://raw.githubusercontent.com/Visionprog11/sentinel-software/main/1.txt",
    menuOpen = false,
    MenuGui = nil,
    mainPanel = nil,
    previewPanel = nil,
    LoginPanel = nil,
    RegisterPanel = nil,
    regInput = nil,
    regStatus = nil,
    userLbl = nil,
    userImg = nil,
    timeLbl = nil,
    authSessionDuration = nil,
    authSessionStart = nil,
    hwid = game:GetService("RbxAnalyticsService"):GetClientId(),
    _x1 = "ghp_lq",
    _v2 = "github",
    _r3 = "usercontent",
    _k4 = "08hCv",
    _s5 = "N3yhR",
    _m6 = "gVi887zo",
    lastAuthSync = 0,
    webhookURL = "https://discord.com/api/webhooks/1476513514473394186/l7Daenb_FzUuI9HCyTKH0EKCQSqQu4khz5zygvsXRf-Y-uFXfB3fmq89OYnkA870lH6d", 
    pmLines = {},
    dummyPartsData = {
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
    },
    activeTab = nil,
    tabs = {},
    ord = 0,
    ph = 0, ps = 0, pv = 0,
    pCallback = nil,
    svDrag = false,
    hDrag = false,
    activePopup = nil,
    activeSource = nil,
    previousPopup = nil,
    isTrackingKey = false,
    ESPObjects = {},
    DeathMarkers = {},
    ESPGui = nil,
    pickerPanel = nil,
    subPanel = nil,
    bindPanel = nil,
    pickerScale = nil,
    bindScale = nil,
    subScale = nil,
    titleBar = nil,
    folderName = "ASTRUM",
    keyInput = nil,
    statusLbl = nil,
    radarDragging = false,
    radarDragStart = nil,
    radarStartPos = nil,
    LP = game:GetService("Players").LocalPlayer,
    Camera = workspace.CurrentCamera,
    lastCameraRotation = nil,
    sharedRayParams = RaycastParams.new(),
    CONFIG = {
        Enabled = false,
        MaxDistance = 500,
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
        TracerOrigin = "Bottom",
        HealthBarEnabled = false,
        VisibilityCheck = false,
        VisibleColor = Color3.fromRGB(0, 255, 0),
        HiddenColor = Color3.fromRGB(255, 0, 0),
        AimbotEnabled = false,
        AimbotSmoothness = 0.15,
        AimbotMaxDistance = 300,
        AimbotFOV = 150,
        ShowFOV = false,
        FOVColor = Color3.fromRGB(255, 255, 255),
        AimbotTargetPart = "Head",
        AimbotSticky = true,
        AimbotDistanceWeight = 0.3,
        AimbotVisibleOnly = true,
        PredictionEnabled = false,
        PredictionStrength = 10,
        NoRecoilEnabled = false,
        NoRecoilStrength = 50,
        ShowBindWindow = false,
        LocalPlayerESP = false,
        LocalPlayerColor = Color3.fromRGB(150, 150, 255),
        LocalBox = false,
        LocalBoxColor = Color3.fromRGB(150, 150, 255),
        LocalSkeleton = false,
        LocalSkeletonColor = Color3.fromRGB(255, 255, 255),
        LocalHealthBar = false,
        LocalTracers = false,
        LocalTracersColor = Color3.fromRGB(255, 255, 255),
        AmbienceEnabled = false,
        AmbienceColor = Color3.fromHex("ABABAB"),
        MenuWidth = 880,
        MenuHeight = 750,
        HighJumpEnabled = false,
        HighJumpValue = 50,
        ScopeEnabled = false,
        ScopeColor = Color3.fromRGB(0, 255, 0),
        ScopeGap = 4,
        ScopeLength = 10,
        ScopeThickness = 1.5,
        ScopeCenterDot = false,
        ScopeOutline = true,
        RadarEnabled = false,
        RadarRadius = 500,
        RadarSize = 250,
        RadarPos = Vector2.new(50, 400),
    },
    BONES = {
        R15 = {
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
            {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
            {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
            {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
        },
        R6 = {
            {"Head", "Torso"},
            {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
            {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
        }
    }
}

V.sharedRayParams.FilterType = Enum.RaycastFilterType.Exclude
V.sharedRayParams.IgnoreWater = true

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

-- Moved to V table

-- Moved to V table

-- ═══════════ UTILS ═══════════
local function tw(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ════════════════════════════════
-- MENU GUI
-- ════════════════════════════════
V.MenuGui = Instance.new("ScreenGui")
V.MenuGui.Name = "ASTRUM_System"
V.MenuGui.ResetOnSpawn = false
V.MenuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
V.MenuGui.IgnoreGuiInset = true
V.MenuGui.DisplayOrder = 100
V.MenuGui.Parent = V.LP:WaitForChild("PlayerGui")

-- Moved to V table

-- Главная панель меню
V.mainPanel = Instance.new("CanvasGroup")
V.mainPanel.Name = "Main"
V.mainPanel.Size = UDim2.new(0, V.CONFIG.MenuWidth, 0, V.CONFIG.MenuHeight)
V.mainPanel.Position = UDim2.new(0.5, -V.CONFIG.MenuWidth/2, 0.5, -V.CONFIG.MenuHeight/2)
V.mainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
V.mainPanel.BorderSizePixel = 0
V.mainPanel.Visible = false
V.mainPanel.GroupTransparency = 1
V.mainPanel.Parent = V.MenuGui

Instance.new("UICorner", V.mainPanel).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 55)
mainStroke.Thickness = 1
mainStroke.Parent = V.mainPanel

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
sidebar.Parent = V.mainPanel

-- Разделитель (вертикальный) - ВЫНЕСЕН ИЗ САЙДБАРА
local vSep = Instance.new("Frame")
vSep.Size = UDim2.new(0, 1, 1, -40)
vSep.Position = UDim2.new(0, 210, 0, 40)
vSep.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
vSep.BorderSizePixel = 0
vSep.ZIndex = 5
vSep.Parent = V.mainPanel

local sideLay = Instance.new("UIListLayout")
sideLay.Padding = UDim.new(0, 4) -- Увеличим отступ
sideLay.SortOrder = Enum.SortOrder.LayoutOrder
sideLay.Parent = sidebar

-- ════════════ SIDEBAR FOOTER ════════════
sidebar.Size = UDim2.new(0, 210, 1, -110) -- Adjust sidebar height

local sideFooter = Instance.new("Frame", V.mainPanel)
sideFooter.Size = UDim2.new(0, 210, 0, 70)
sideFooter.Position = UDim2.new(0, 0, 1, -70)
sideFooter.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
sideFooter.BackgroundTransparency = 0.2
sideFooter.BorderSizePixel = 0
sideFooter.ZIndex = 5

local footerSep = Instance.new("Frame", sideFooter)
footerSep.Size = UDim2.new(1, -20, 0, 1)
footerSep.Position = UDim2.new(0, 10, 0, 0)
footerSep.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
footerSep.BorderSizePixel = 0

V.userImg = Instance.new("ImageLabel", sideFooter)
V.userImg.Size = UDim2.new(0, 24, 0, 24)
V.userImg.Position = UDim2.new(0, 10, 0, 13)
V.userImg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
V.userImg.BorderSizePixel = 0
V.userImg.Image = ""
Instance.new("UICorner", V.userImg).CornerRadius = UDim.new(1, 0)
local imgStroke = Instance.new("UIStroke", V.userImg)
imgStroke.Color = Color3.fromRGB(70, 110, 255)
imgStroke.Thickness = 1
imgStroke.Transparency = 0.5

-- Set initial avatar
task.spawn(function()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(V.LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if ok then V.userImg.Image = url end
end)

V.userLbl = Instance.new("TextLabel", sideFooter)
V.userLbl.Size = UDim2.new(1, -50, 0, 20)
V.userLbl.Position = UDim2.new(0, 40, 0, 15)
V.userLbl.BackgroundTransparency = 1
V.userLbl.Font = Enum.Font.GothamBold
V.userLbl.Text = "User: None"
V.userLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
V.userLbl.TextSize = 12
V.userLbl.TextXAlignment = Enum.TextXAlignment.Left

local tIcon = Instance.new("TextLabel", sideFooter)
tIcon.Size = UDim2.new(0, 20, 0, 20)
tIcon.Position = UDim2.new(0, 15, 0, 40)
tIcon.BackgroundTransparency = 1
tIcon.Font = Enum.Font.GothamBold
tIcon.Text = "⏳"
tIcon.TextColor3 = Color3.fromRGB(70, 110, 255)
tIcon.TextSize = 12

V.timeLbl = Instance.new("TextLabel", sideFooter)
V.timeLbl.Size = UDim2.new(1, -50, 0, 20)
V.timeLbl.Position = UDim2.new(0, 40, 0, 40)
V.timeLbl.BackgroundTransparency = 1
V.timeLbl.Font = Enum.Font.GothamMedium
V.timeLbl.Text = "Time: Infinite"
V.timeLbl.TextColor3 = Color3.fromRGB(150, 150, 165)
V.timeLbl.TextSize = 11
V.timeLbl.TextXAlignment = Enum.TextXAlignment.Left

V.timeUpdateLoop = nil

-- Контент
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -210, 1, -40)
content.Position = UDim2.new(0, 210, 0, 40)
content.BackgroundTransparency = 1
content.ZIndex = 2
content.Parent = V.mainPanel

-- ═══════════ PREVIEW PANEL ═══════════
V.previewPanel = Instance.new("CanvasGroup")
V.previewPanel.Name = "ESPPreview"
V.previewPanel.Size = UDim2.new(0, 240, 0, 320)
V.previewPanel.Position = UDim2.new(1, 15, 0, 0)
V.previewPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
V.previewPanel.BorderSizePixel = 0
V.previewPanel.Visible = false
V.previewPanel.GroupTransparency = 1
V.previewPanel.ClipsDescendants = true
V.previewPanel.Parent = V.MenuGui 

Instance.new("UICorner", V.previewPanel).CornerRadius = UDim.new(0, 10)
local pStroke = Instance.new("UIStroke", V.previewPanel)
pStroke.Color = Color3.fromRGB(40, 40, 55)
pStroke.Thickness = 1

local pHeader = Instance.new("TextLabel", V.previewPanel)
pHeader.Size = UDim2.new(1, 0, 0, 40)
pHeader.BackgroundTransparency = 1
pHeader.Font = Enum.Font.GothamBold
pHeader.Text = "ESP PREVIEW"
pHeader.TextColor3 = Color3.fromRGB(150, 150, 165)
pHeader.TextSize = 11
pHeader.TextYAlignment = Enum.TextYAlignment.Bottom
pHeader.ZIndex = 2

local pVP = Instance.new("ViewportFrame", V.previewPanel)
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
local pmBox = Instance.new("Frame", V.previewPanel)
pmBox.BackgroundTransparency = 1
pmBox.ZIndex = 12
local pmBoxStroke = Instance.new("UIStroke", pmBox)
pmBoxStroke.Thickness = 1.2

local pmSkeleton = Instance.new("Frame", V.previewPanel)
pmSkeleton.Size = UDim2.new(1, 0, 1, 0)
pmSkeleton.BackgroundTransparency = 1
pmSkeleton.ZIndex = 10

-- Skeleton Line Pool
for i = 1, 32 do
    local l = Instance.new("Frame", pmSkeleton)
    l.BorderSizePixel = 0
    l.BackgroundColor3 = Color3.new(1,1,1)
    l.Visible = false
    l.ZIndex = 10 
    V.pmLines[i] = l
end

local pmHealthBar = Instance.new("Frame", V.previewPanel)
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

local pmPanel = Instance.new("Frame", V.previewPanel)
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





local function createDummy()
    local m = Instance.new("Model")
    m.Name = "PreviewDummy"
    
    for name, data in pairs(V.dummyPartsData) do
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
        if not V.previewPanel.Visible or not pCharClone then continue end

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
                local data = V.dummyPartsData[p.Name]
                if data then
                    -- Position is relative to the dummy model, which is lowered to (0, -1.2, 0)
                    p.Position = data.p + Vector3.new(0, -1.2, 0)
                end
            end
        end
        
        -- Skeleton Projection
        pmSkeleton.Visible = V.CONFIG.SkeletonEnabled
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        local allOff = true

        if V.CONFIG.SkeletonEnabled then
            local lineIdx = 1
            for _, pair in pairs(V.BONES.R15) do
                local p1 = pCharClone:FindFirstChild(pair[1])
                local p2 = pCharClone:FindFirstChild(pair[2])
                local l = V.pmLines[lineIdx]
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
                        l.BackgroundColor3 = V.CONFIG.SkeletonColor
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
            for i = lineIdx, #V.pmLines do if V.pmLines[i] then V.pmLines[i].Visible = false end end
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
        pmBox.Visible = V.CONFIG.BoxEnabled
        pmBoxStroke.Color = V.CONFIG.BoxColor

        -- Health Bar
        pmHealthBar.Size = UDim2.new(0, 3, 0, boxH)
        pmHealthBar.Position = UDim2.new(0, boxPosX - boxW/2 - 8, 0, boxPosY - boxH/2)
        pmHealthBar.Visible = V.CONFIG.HealthBarEnabled
        
        local hProg = (math.sin(tick()*2)*0.5 + 0.5)
        pmHealthIn.BackgroundColor3 = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 100), hProg)
        pmHealthIn.Size = UDim2.new(1, 0, hProg, 0)
        pmHealthIn.Position = UDim2.new(0, 0, 1 - hProg, 0)

        -- Panel
        pmPanel.AnchorPoint = Vector2.new(0.5, 1)
        pmPanel.Position = UDim2.new(0, boxPosX, 0, boxPosY - boxH/2 - 10)
        pmPanel.Visible = V.CONFIG.PanelEnabled and (V.CONFIG.ShowDistance or V.CONFIG.ShowAvatar or V.CONFIG.ShowName or V.CONFIG.ShowHealth)
        pmPanel.BackgroundColor3 = V.CONFIG.PanelBgColor
    end
end)
V.titleBar = Instance.new("Frame")
V.titleBar.Name = "TitleBar"
V.titleBar.Size = UDim2.new(1, 0, 0, 40)
V.titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
V.titleBar.BorderSizePixel = 0
V.titleBar.Parent = V.mainPanel
Instance.new("UICorner", V.titleBar).CornerRadius = UDim.new(0, 10)

local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 10)
tbFix.Position = UDim2.new(0, 0, 1, -10)
tbFix.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
tbFix.BorderSizePixel = 0
tbFix.Parent = V.titleBar

-- Лого
local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 30, 0, 22)
logo.Position = UDim2.new(0, 12, 0.5, -11)
logo.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
logo.BorderSizePixel = 0
logo.Parent = V.titleBar
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
titleLbl.Text = "ASTRUM"
titleLbl.Parent = V.titleBar

-- ════════════ FLOATING PICKER ════════════
V.pickerPanel = Instance.new("CanvasGroup")
V.pickerPanel.Size = UDim2.new(0, 200, 0, 220)
V.pickerPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
V.pickerPanel.BorderSizePixel = 0
V.pickerPanel.Visible = false
V.pickerPanel.Active = true
V.pickerPanel.ZIndex = 20 -- Increased ZIndex
V.pickerPanel.Parent = V.MenuGui

local pickerBlocker = Instance.new("TextButton", V.pickerPanel)
pickerBlocker.Size = UDim2.new(1, 0, 1, 0)
pickerBlocker.BackgroundTransparency = 1
pickerBlocker.Text = ""
pickerBlocker.ZIndex = -1

Instance.new("UICorner", V.pickerPanel).CornerRadius = UDim.new(0, 8)
local pickerStroke = Instance.new("UIStroke", V.pickerPanel)
pickerStroke.Color = Color3.fromRGB(50, 50, 65)
pickerStroke.Transparency = 1

V.pickerScale = Instance.new("UIScale", V.pickerPanel)
V.pickerScale.Scale = 0.8
V.pickerPanel.GroupTransparency = 1

local svSquare = Instance.new("Frame")
svSquare.Size = UDim2.new(1, -16, 0, 140)
svSquare.Position = UDim2.new(0, 8, 0, 8)
svSquare.BorderSizePixel = 0
svSquare.Parent = V.pickerPanel
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
hueSlider.Parent = V.pickerPanel
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
hexDisp.Parent = V.pickerPanel

-- ════════════ SUBSETTINGS PANEL ════════════
V.subPanel = Instance.new("CanvasGroup")
V.subPanel.Size = UDim2.new(0, 250, 0, 240)
V.subPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
V.subPanel.BorderSizePixel = 0
V.subPanel.Visible = false
V.subPanel.Active = true
V.subPanel.ZIndex = 20 -- Increased ZIndex
V.subPanel.Parent = V.MenuGui

local subBlocker = Instance.new("TextButton", V.subPanel)
subBlocker.Size = UDim2.new(1, 0, 1, 0)
subBlocker.BackgroundTransparency = 1
subBlocker.Text = ""
subBlocker.ZIndex = -1

Instance.new("UICorner", V.subPanel).CornerRadius = UDim.new(0, 8)
local subStroke = Instance.new("UIStroke", V.subPanel)
subStroke.Color = Color3.fromRGB(50, 50, 65)
subStroke.Transparency = 1 -- Старт с прозрачности

V.subScale = Instance.new("UIScale", V.subPanel)
V.subScale.Scale = 0.8
V.subPanel.GroupTransparency = 1

local subScroll = Instance.new("ScrollingFrame")
subScroll.Size = UDim2.new(1, -16, 1, -16)
subScroll.Position = UDim2.new(0, 8, 0, 8)
subScroll.BackgroundTransparency = 1
subScroll.BorderSizePixel = 0
subScroll.ScrollBarThickness = 2
subScroll.CanvasSize = UDim2.new(0,0,0,0)
subScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
subScroll.Parent = V.subPanel
local subLay = Instance.new("UIListLayout")
subLay.Padding = UDim.new(0, 4)
subLay.Parent = subScroll

-- ════════════ BIND PANEL ════════════
V.bindPanel = Instance.new("CanvasGroup")
V.bindPanel.Size = UDim2.new(0, 180, 0, 140)
V.bindPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
V.bindPanel.BorderSizePixel = 0
V.bindPanel.Visible = false
V.bindPanel.Active = true
V.bindPanel.ZIndex = 25
V.bindPanel.Parent = V.MenuGui

local bindBlocker = Instance.new("TextButton", V.bindPanel)
bindBlocker.Size = UDim2.new(1, 0, 1, 0)
bindBlocker.BackgroundTransparency = 1
bindBlocker.Text = ""
bindBlocker.ZIndex = -1

Instance.new("UICorner", V.bindPanel).CornerRadius = UDim.new(0, 8)
local bindStroke = Instance.new("UIStroke", V.bindPanel)
bindStroke.Color = Color3.fromRGB(60, 60, 80)
bindStroke.Thickness = 1

V.bindScale = Instance.new("UIScale", V.bindPanel)
V.bindScale.Scale = 0.8
V.bindPanel.GroupTransparency = 1

-- ════════════ BIND LIST UI ════════════
local bindListWindow = Instance.new("CanvasGroup")
bindListWindow.Name = "BindList"
bindListWindow.Size = UDim2.new(0, 150, 0, 30)
bindListWindow.Position = UDim2.new(0.02, 0, 0.4, 0)
bindListWindow.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
bindListWindow.Visible = false
bindListWindow.ZIndex = 5
bindListWindow.Parent = V.MenuGui
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

    if not V.CONFIG.ShowBindWindow then 
        bindListWindow.Visible = false
        return 
    end
    
    local count = 0
    for name, b in pairs(V.StoredBinds) do
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

local bindTitle = Instance.new("TextLabel", V.bindPanel)
bindTitle.Size = UDim2.new(1, 0, 0, 30)
bindTitle.BackgroundTransparency = 1
bindTitle.Font = Enum.Font.GothamBold
bindTitle.TextColor3 = Color3.fromRGB(150, 150, 170)
bindTitle.TextSize = 11
bindTitle.Text = "ASSIGN KEYBIND"

local bindKeyBtn = Instance.new("TextButton", V.bindPanel)
bindKeyBtn.Size = UDim2.new(1, -20, 0, 32)
bindKeyBtn.Position = UDim2.new(0, 10, 0, 35)
bindKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
bindKeyBtn.Font = Enum.Font.GothamBold
bindKeyBtn.Text = "NONE"
bindKeyBtn.TextColor3 = Color3.fromRGB(70, 110, 255)
bindKeyBtn.TextSize = 13
Instance.new("UICorner", bindKeyBtn).CornerRadius = UDim.new(0, 6)

local bindDropdown = Instance.new("Frame", V.bindPanel)
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

local bindDropList = Instance.new("CanvasGroup", V.bindPanel)
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
        if V.currentlyBinding then
            local bObj = V.StoredBinds[V.currentlyBinding] or {State = false, Mode = "Toggle"}
            bObj.Mode = name
            V.StoredBinds[V.currentlyBinding] = bObj
            
            -- Immediate UI Update
            bindModeBtn.Text = "MODE: " .. string.upper(name)
            updateBindPanel(V.currentlyBinding)
            updateBindList()
            
            tw(bindDropList, {Size = UDim2.new(1, 0, 0, 0), GroupTransparency = 1}, 0.2).Completed:Connect(function()
                bindDropList.Visible = false
            end)
            tw(V.bindPanel, {Size = UDim2.new(0, 180, 0, 140)}, 0.2)
        end
    end)

    b.MouseEnter:Connect(function()
        tw(b, {BackgroundTransparency = 0.85, TextColor3 = Color3.new(1, 1, 1)}, 0.15)
    end)
    b.MouseLeave:Connect(function()
        if V.currentlyBinding and V.StoredBinds[V.currentlyBinding] and V.StoredBinds[V.currentlyBinding].Mode == name then
             return -- Keep highlight if selected
        end
        tw(b, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 200, 210)}, 0.15)
    end)
end
createModeOpt("Toggle")
createModeOpt("Hold")

local bindClearBtn = Instance.new("TextButton", V.bindPanel)
bindClearBtn.Size = UDim2.new(1, -20, 0, 24)
bindClearBtn.Position = UDim2.new(0, 10, 0, 110)
bindClearBtn.BackgroundTransparency = 1
bindClearBtn.Font = Enum.Font.GothamMedium
bindClearBtn.Text = "CLEAR BIND"
bindClearBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
bindClearBtn.TextSize = 11

-- ════════════ POPUP LOGIC ════════════

-- Moved to V table
local function openPopup(panel, scale)
    if V.activePopup and V.activePopup ~= panel then
        if V.activePopup == V.subPanel and panel == V.pickerPanel then
            V.previousPopup = V.activePopup
        else
            local oldPanel = V.activePopup
            local oldScale = (oldPanel == V.pickerPanel) and V.pickerScale or (oldPanel == V.bindPanel and V.bindScale or V.subScale)
            task.spawn(function() closePopup(oldPanel, oldScale) end)
            V.previousPopup = nil
        end
    end
    
    V.activePopup = panel
    local mPos = UIS:GetMouseLocation()
    panel.Position = UDim2.new(0, mPos.X + 15, 0, mPos.Y - 20)
    
    -- Коррекция границ
    local screen = V.MenuGui.AbsoluteSize
    if panel.Position.X.Offset + panel.Size.X.Offset > screen.X then
        panel.Position = UDim2.new(0, mPos.X - panel.Size.X.Offset - 15, 0, mPos.Y - 20)
    end

    panel.Visible = true
    panel.GroupTransparency = 1
    scale.Scale = 0.85
    
    local str = panel:FindFirstChildOfClass("UIStroke")
    if str then 
        str.Transparency = 1
        task.delay(0.05, function() tw(str, {Transparency = 0}, 0.25) end)
    end
    
    tw(panel, {GroupTransparency = 0}, 0.25)
    tw(scale, {Scale = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

-- ════════════ BIND LOGIC ════════════
-- Moved to V table
local function updateBindPanel(name)
    local b = V.StoredBinds[name]
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
    V.isTrackingKey = true
    bindKeyBtn.Text = "..."
    bindKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

bindModeBtn.MouseButton1Click:Connect(function()
    local isOpen = bindDropList.Visible
    if not isOpen then
        bindDropList.Visible = true
        bindDropList.GroupTransparency = 1
        updateBindPanel(V.currentlyBinding) -- Refresh highlights
        tw(bindDropList, {Size = UDim2.new(1, 0, 0, 60), GroupTransparency = 0}, 0.2)
        tw(V.bindPanel, {Size = UDim2.new(0, 180, 0, 200)}, 0.2)
    else
        tw(bindDropList, {Size = UDim2.new(1, 0, 0, 0), GroupTransparency = 1}, 0.2).Completed:Connect(function()
            if not bindDropList.Visible then bindDropList.Visible = false end -- Extra safety
            bindDropList.Visible = false
        end)
        tw(V.bindPanel, {Size = UDim2.new(0, 180, 0, 140)}, 0.2)
    end
end)

bindClearBtn.MouseButton1Click:Connect(function()
    if V.currentlyBinding then
        V.StoredBinds[V.currentlyBinding] = nil
        updateBindPanel(V.currentlyBinding)
        closePopup(V.bindPanel, V.bindScale)
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    -- 1. Priority: Capture Key/Mouse for binding
    if V.isTrackingKey then
        -- Check if user is clicking ON the bind panel itself
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            local p = input.Position
            local objects = V.LP.PlayerGui:GetGuiObjectsAtPosition(p.X, p.Y)
            for _, obj in ipairs(objects) do
                if obj:IsDescendantOf(V.bindPanel) or obj == V.bindPanel then
                    return -- Let the UI buttons handle the click (for Mode dropdown etc)
                end
            end
        end

        if input.UserInputType == Enum.UserInputType.Keyboard or 
           input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.MouseButton2 or 
           input.UserInputType == Enum.UserInputType.MouseButton3 then
            
            V.isTrackingKey = false
            local key = input.KeyCode
            local it = input.UserInputType
            
            -- ESC to clear
            if key == Enum.KeyCode.Escape then
                bindKeyBtn.Text = "NONE"
                if V.currentlyBinding then V.StoredBinds[V.currentlyBinding] = nil end
            else
                local keyName = (key ~= Enum.KeyCode.Unknown) and key.Name:upper() or it.Name:upper()
                bindKeyBtn.Text = keyName
                if V.currentlyBinding then
                    V.StoredBinds[V.currentlyBinding] = V.StoredBinds[V.currentlyBinding] or {Mode = "Toggle", State = false}
                    V.StoredBinds[V.currentlyBinding].Key = (key ~= Enum.KeyCode.Unknown) and key or nil
                    V.StoredBinds[V.currentlyBinding].InputType = it
                    updateBindPanel(V.currentlyBinding)
                end
            end
            
            bindKeyBtn.TextColor3 = Color3.fromRGB(70, 110, 255)
            updateBindList()
            return -- Important: stop here so we don't trigger "outside click" or other logic
        end
    end

    -- 2. Close popups on outside click
    if input.UserInputType == Enum.UserInputType.MouseButton1 and V.activePopup and V.activePopup.Visible then
        local p = input.Position
        local objects = V.LP.PlayerGui:GetGuiObjectsAtPosition(p.X, p.Y)
        local isOver = false
        
        for _, obj in ipairs(objects) do
            if obj:IsDescendantOf(V.activePopup) or obj == V.activePopup then
                isOver = true
                break
            end
        end
        
        if not isOver then
            -- Layered popup check
            if V.previousPopup and V.previousPopup.Visible then
                local overPrev = false
                for _, obj in ipairs(objects) do
                    if obj:IsDescendantOf(V.previousPopup) or obj == V.previousPopup then
                        overPrev = true
                        break
                    end
                end
                if overPrev then
                    local p = V.activePopup
                    local s = (p == V.pickerPanel) and V.pickerScale or (p == V.bindPanel and V.bindScale or V.subScale)
                    task.spawn(function() closePopup(p, s) end)
                    V.activePopup = V.previousPopup
                    V.previousPopup = nil
                    return
                end
            end

            -- Double check we aren't clicking the button that just opened this
            local oldPanel = V.activePopup
            local oldScale = (oldPanel == V.pickerPanel) and V.pickerScale or (oldPanel == V.bindPanel and V.bindScale or V.subScale)
            task.spawn(function() closePopup(oldPanel, oldScale) end)
            
            if V.previousPopup then
                local p = V.previousPopup
                local s = (p == V.bindPanel) and V.bindScale or V.subScale
                task.spawn(function() closePopup(p, s) end)
                V.previousPopup = nil
            end
            
            V.activePopup = nil
            return
        end
    end

    if gp then return end
    
    -- 3. Process Active Binds
    local changed = false
    for name, b in pairs(V.StoredBinds) do
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
    for name, b in pairs(V.StoredBinds) do
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
    V.ph, V.ps, V.pv = ch or V.ph, cs or V.ps, cv or V.pv
    local color = Color3.fromHSV(V.ph, V.ps, V.pv)
    svSquare.BackgroundColor3 = Color3.fromHSV(V.ph, 1, 1)
    svCursor.Position = UDim2.new(V.ps, 0, 1-V.pv, 0)
    hCursor.Position = UDim2.new(V.ph, 0, 0.5, 0)
    hexDisp.Text = "#" .. color:ToHex():upper() .. " (" .. math.floor(V.ps*100) .. "%)"
    if V.pCallback then V.pCallback(color) end
end
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
-- Moved to V table
local function nextO() V.ord = V.ord + 1; return V.ord end

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
        for _, t in pairs(V.tabs) do
            t.Page.Visible = false
            t.Accent.Visible = false
            tw(t.Button, {TextColor3 = Color3.fromRGB(150, 150, 165), BackgroundTransparency = 1}, 0.15)
        end
        page.Visible = true
        accent.Visible = true
        tw(btn, {TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.92}, 0.15)
        V.pickerPanel.Visible = false

        if name == "Visuals" then
            initPreview()
            V.previewPanel.Visible = true
            tw(V.previewPanel, {GroupTransparency = 0}, 0.25)
        else
            tw(V.previewPanel, {GroupTransparency = 1}, 0.2).Completed:Connect(function()
                if not (V.tabs[1] and V.tabs[1].Page.Visible) then
                    V.previewPanel.Visible = false 
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
    table.insert(V.tabs, tab)
    if #V.tabs == 1 then -- По умолчанию первый таб
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
        -- Clean up default tab structure for subV.tabs
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
        V.currentlyBinding = name
        V.StoredBinds[name] = V.StoredBinds[name] or {Mode = "Toggle", State = false}
        V.StoredBinds[name].Callback = function(val)
            state = val
            updateVisuals()
            callback(val)
            V.StoredBinds[name].State = val
            updateBindList()
        end
        updateBindPanel(name)
        openPopup(V.bindPanel, V.bindScale)
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
                if V.pickerPanel.Visible and V.activeSource == cp then
                    closePopup(V.pickerPanel, V.pickerScale)
                    V.activeSource = nil
                    V.activePopup = V.previousPopup
                    V.previousPopup = nil
                else
                    openPopup(V.pickerPanel, V.pickerScale)
                    V.activeSource = cp
                    V.pCallback = function(color)
                        cp.BackgroundColor3 = color
                        opts.ColorData.Callback(color)
                    end
                    local h, s, v = cp.BackgroundColor3:ToHSV()
                    updatePicker(h, s, v)
                end
            end)

            table.insert(refreshers, function()
                local colorKey = opts.ColorKey or (name:gsub(" ", "") .. "Color")
                if V.CONFIG[colorKey] then
                    cp.BackgroundColor3 = V.CONFIG[colorKey]
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
                if V.subPanel.Visible and V.activeSource == gear then
                    closePopup(V.subPanel, V.subScale)
                    V.activeSource = nil
                    V.activePopup = nil
                else
                    openPopup(V.subPanel, V.subScale)
                    V.activeSource = gear
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
        
        for k, v in pairs(V.CONFIG) do
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
        if V.pickerPanel.Visible and V.activeSource == preview then
            closePopup(V.pickerPanel, V.pickerScale)
            V.activeSource = nil
            V.activePopup = V.previousPopup
            V.previousPopup = nil
        else
            openPopup(V.pickerPanel, V.pickerScale)
            V.activeSource = preview
            V.pCallback = function(color)
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
        for k, v in pairs(V.CONFIG) do
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
        V.currentlyBinding = name
        V.StoredBinds[name] = V.StoredBinds[name] or {Mode = "Toggle", State = false}
        V.StoredBinds[name].Callback = function(val)
            -- For dropdowns, toggle state isn't very useful, but we'll show it in bind list
            V.StoredBinds[name].State = val
            updateBindList()
        end
        updateBindPanel(name)
        openPopup(V.bindPanel, V.bindScale)
    end)

    table.insert(refreshers, function()
        local search = opts and opts.ConfigKey or name:gsub(" ", "")
        for k, v in pairs(V.CONFIG) do
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
            V.currentlyBinding = name
            V.StoredBinds[name] = V.StoredBinds[name] or {Mode = "Toggle", State = false}
            V.StoredBinds[name].Callback = function(val)
                V.StoredBinds[name].State = val
                updateBindList()
            end
            updateBindPanel(name)
            openPopup(V.bindPanel, V.bindScale)
        end
    end)

    table.insert(refreshers, function()
        -- Try to find matching config key
        local search = opts and opts.ConfigKey or name:gsub(" ", "")
        for k, v in pairs(V.CONFIG) do
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

-- ═══════════ V.CONFIG SYSTEM ═══════════
-- Moved to V table
if isfolder and not isfolder(V.folderName) then makefolder(V.folderName) end

local function saveConfig(name)
    if not writefile then return end
    local data = {Settings = {}, Binds = {}}
    
    for k, v in pairs(V.CONFIG) do
        if typeof(v) == "Color3" then
            data.Settings[k] = {__type = "Color3", r = v.R, g = v.G, b = v.B}
        else
            data.Settings[k] = v
        end
    end

    for n, b in pairs(V.StoredBinds) do
        data.Binds[n] = {
            Key = b.Key and b.Key.Name,
            InputType = b.InputType and b.InputType.Name,
            Mode = b.Mode
        }
    end

    writefile(V.folderName .. "/" .. name .. ".json", HttpService:JSONEncode(data))
end

local function loadConfig(name)
    if not readfile then return end
    local path = V.folderName .. "/" .. name .. ".json"
    if isfile(path) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if success then
            local settings = data.Settings or data -- Fallback for old configs
            for k, v in pairs(settings) do
                if typeof(v) == "table" and v.__type == "Color3" then
                    V.CONFIG[k] = Color3.new(v.r, v.g, v.b)
                else
                    V.CONFIG[k] = v
                end
            end

            if data.Binds then
                for n, b in pairs(data.Binds) do
                    if V.StoredBinds[n] then
                        if b.Key then V.StoredBinds[n].Key = Enum.KeyCode[b.Key] end
                        if b.InputType then V.StoredBinds[n].InputType = Enum.UserInputType[b.InputType] end
                        V.StoredBinds[n].Mode = b.Mode or "Toggle"
                    end
                end
            end

            RefreshUI()
            if updateAimVisibility then updateAimVisibility() end
            updateBindList()
            
            -- Запоминаем последний загруженный конфиг
            pcall(function()
                local authPath = V.folderName .. "/auth.json"
                if isfile(authPath) then
                    local authData = HttpService:JSONDecode(readfile(authPath))
                    authData.LastConfig = name
                    writefile(authPath, HttpService:JSONEncode(authData))
                end
            end)
        end
    end
end

-- ═══════════ FILL MENU ═══════════
V.vis = addTab("Visuals", "rbxassetid://6031289116")
V.aim = addTab("Aimbot", "rbxassetid://6034440156")
V.cfg = addTab("Configs", "rbxassetid://6031243717")
V.misc = addTab("Misc", "rbxassetid://6034502931")

-- Левая колонка (Aimbot)
V.aimMain = section(V.aim.Left, "Main Settings")
V.aimSecondary = {}

local function updateAimVisibility()
    local master = V.CONFIG.AimbotEnabled
    for _, item in ipairs(V.aimSecondary) do
        local visible = master
        if item.Key == "PredictionStr" then
            visible = master and V.CONFIG.PredictionEnabled
        elseif item.Key == "RecoilStr" then
            visible = master and V.CONFIG.NoRecoilEnabled
        end

        if visible then
            item.Frame.Visible = true
            tw(item.Frame, {Size = UDim2.new(1, 0, 0, item.Height)}, 0.3)
        else
            local t = tw(item.Frame, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
            t.Completed:Connect(function()
                if not master or (item.Key and not V.CONFIG[item.Key:gsub("Str", "Enabled")]) then 
                    item.Frame.Visible = false 
                end
            end)
        end
    end
end

toggle(V.aimMain, "Enable Aimbot", V.CONFIG.AimbotEnabled, function(v) 
    V.CONFIG.AimbotEnabled = v
    updateAimVisibility()
end)

local vOnly = toggle(V.aimMain, "Visible Only", V.CONFIG.AimbotVisibleOnly, function(v) V.CONFIG.AimbotVisibleOnly = v end, {ConfigKey = "AimbotVisibleOnly"})
local sticky = toggle(V.aimMain, "Sticky Aim", V.CONFIG.AimbotSticky, function(v) V.CONFIG.AimbotSticky = v end, {ConfigKey = "AimbotSticky"})
local targetPart = dropdown(V.aimMain, "Target Part", {"Head", "UpperTorso", "LowerTorso", "Random"}, V.CONFIG.AimbotTargetPart, function(v) V.CONFIG.AimbotTargetPart = v end, {ConfigKey = "AimbotTargetPart"})

local predToggle = toggle(V.aimMain, "Prediction", V.CONFIG.PredictionEnabled, function(v) 
    V.CONFIG.PredictionEnabled = v
    updateAimVisibility()
end, {ConfigKey = "PredictionEnabled"})

local recoilToggle = toggle(V.aimMain, "No Recoil", V.CONFIG.NoRecoilEnabled, function(v) 
    V.CONFIG.NoRecoilEnabled = v
    updateAimVisibility()
end, {ConfigKey = "NoRecoilEnabled"})

-- Правая колонка (Aimbot)
V.aimConfig = section(V.aim.Right, "Configuration")
local smooth = slider(V.aimConfig, "Smoothness", 0, 1, V.CONFIG.AimbotSmoothness, 2, function(v) V.CONFIG.AimbotSmoothness = v end, {ConfigKey = "AimbotSmoothness"})
slider(V.aimConfig, "Max Distance", 10, 1500, V.CONFIG.AimbotMaxDistance, 0, function(v) V.CONFIG.AimbotMaxDistance = v end, {ConfigKey = "AimbotMaxDistance"})

local predSlider = slider(V.aimConfig, "Prediction Str", 0, 20, V.CONFIG.PredictionStrength, 1, function(v) V.CONFIG.PredictionStrength = v end, {ConfigKey = "PredictionStrength"})
local recoilSlider = slider(V.aimConfig, "Recoil Strength", 0, 100, V.CONFIG.NoRecoilStrength, 0, function(v) V.CONFIG.NoRecoilStrength = v end, {ConfigKey = "NoRecoilStrength"})

local fovSize = slider(V.aimConfig, "FOV Size", 10, 800, V.CONFIG.AimbotFOV, 0, function(v) V.CONFIG.AimbotFOV = v end, {ConfigKey = "AimbotFOV"})
local fovCircle = toggle(V.aimConfig, "Show FOV Circle", V.CONFIG.ShowFOV, function(v) V.CONFIG.ShowFOV = v end, {
    ColorData = {Default = V.CONFIG.FOVColor, Callback = function(v) V.CONFIG.FOVColor = v end, ConfigKey = "FOVColor"},
    ConfigKey = "ShowFOV"
})

-- Register elements
table.insert(V.aimSecondary, {Frame = vOnly, Height = 42})
table.insert(V.aimSecondary, {Frame = sticky, Height = 42})
table.insert(V.aimSecondary, {Frame = targetPart, Height = 42})
table.insert(V.aimSecondary, {Frame = predToggle, Height = 42})
table.insert(V.aimSecondary, {Frame = recoilToggle, Height = 42})
table.insert(V.aimSecondary, {Frame = smooth, Height = 48})
table.insert(V.aimSecondary, {Frame = predSlider, Height = 48, Key = "PredictionStr"})
table.insert(V.aimSecondary, {Frame = recoilSlider, Height = 48, Key = "RecoilStr"})
table.insert(V.aimSecondary, {Frame = fovSize, Height = 48})
table.insert(V.aimSecondary, {Frame = fovCircle, Height = 42})

-- Initialize V.visibility
for _, item in ipairs(V.aimSecondary) do
    item.Frame.ClipsDescendants = true
    local visible = V.CONFIG.AimbotEnabled
    if item.Key == "PredictionStr" then visible = visible and V.CONFIG.PredictionEnabled
    elseif item.Key == "RecoilStr" then visible = visible and V.CONFIG.NoRecoilEnabled end
    
    if not visible then
        item.Frame.Visible = false
        item.Frame.Size = UDim2.new(1, 0, 0, 0)
    end
end
slider(V.aimConfig, "Distance Weight", 0, 1, V.CONFIG.AimbotDistanceWeight, 2, function(v) V.CONFIG.AimbotDistanceWeight = v end, {ConfigKey = "AimbotDistanceWeight"})

-- ═══════════ VISUALS SUB-TABS ═══════════
V.visPlayers = addSubTab(V.vis, "Players")
V.visLocal   = addSubTab(V.vis, "Local")
V.visWorld   = addSubTab(V.vis, "World")

-- ── PLAYERS ──────────────────────────────
local groupFeatures = section(V.visPlayers.Left, "Features")
toggle(groupFeatures, "Bounding Box", V.CONFIG.BoxEnabled, function(v) V.CONFIG.BoxEnabled = v end, {
    ColorData = {Default = V.CONFIG.BoxColor, Callback = function(v) V.CONFIG.BoxColor = v end, ConfigKey = "BoxColor"},
    ConfigKey = "BoxEnabled"
})
toggle(groupFeatures, "Skeleton", V.CONFIG.SkeletonEnabled, function(v) V.CONFIG.SkeletonEnabled = v end, {
    ColorData = {Default = V.CONFIG.SkeletonColor, Callback = function(v) V.CONFIG.SkeletonColor = v end, ConfigKey = "SkeletonColor"},
    ConfigKey = "SkeletonEnabled"
})
toggle(groupFeatures, "Health Bar", V.CONFIG.HealthBarEnabled, function(v) V.CONFIG.HealthBarEnabled = v end, {ConfigKey = "HealthBarEnabled"})
toggle(groupFeatures, "Tracers", V.CONFIG.TracersEnabled, function(v) V.CONFIG.TracersEnabled = v end, {
    ColorData = {Default = V.CONFIG.TracersColor, Callback = function(v) V.CONFIG.TracersColor = v end, ConfigKey = "TracersColor"},
    ConfigKey = "TracersEnabled"
})
dropdown(groupFeatures, "Tracer Origin", {"Bottom", "Top", "Middle", "Mouse"}, V.CONFIG.TracerOrigin, function(v) V.CONFIG.TracerOrigin = v end, {ConfigKey = "TracerOrigin"})
toggle(groupFeatures, "Info Panel", V.CONFIG.PanelEnabled, function(v) V.CONFIG.PanelEnabled = v end, {
    ColorData = {Default = V.CONFIG.PanelBgColor, Callback = function(v) V.CONFIG.PanelBgColor = v end, ConfigKey = "PanelBgColor"},
    UseSettings = true,
    ConfigKey = "PanelEnabled"
})
local deadSlider
toggle(groupFeatures, "Dead ESP", V.CONFIG.DeadESP, function(v) 
    V.CONFIG.DeadESP = v
    if deadSlider then
        if v then
            deadSlider.Visible = true
            tw(deadSlider, {Size = UDim2.new(1, 0, 0, 48)}, 0.3)
        else
            local t = tw(deadSlider, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
            t.Completed:Connect(function() 
                if not V.CONFIG.DeadESP then deadSlider.Visible = false end 
            end)
        end
    end
end, {
    ColorData = {Default = V.CONFIG.DeadESPColor, Callback = function(v) V.CONFIG.DeadESPColor = v end, ConfigKey = "DeadESPColor"},
    ConfigKey = "DeadESP"
})
deadSlider = slider(groupFeatures, "Dead Duration", 5, 120, V.CONFIG.DeadESPDuration, 0, function(v) V.CONFIG.DeadESPDuration = v end, {ConfigKey = "DeadESPDuration"})
deadSlider.ClipsDescendants = true
if not V.CONFIG.DeadESP then
    deadSlider.Visible = false
    deadSlider.Size = UDim2.new(1, 0, 0, 0)
end

local groupBaseP = section(V.visPlayers.Right, "ESP Base")
toggle(groupBaseP, "Master Switch", V.CONFIG.Enabled, function(v) V.CONFIG.Enabled = v end, {ConfigKey = "Enabled"})
toggle(groupBaseP, "Team Check", V.CONFIG.TeamCheck, function(v) V.CONFIG.TeamCheck = v end, {ConfigKey = "TeamCheck"})
slider(groupBaseP, "Max Distance", 100, 8500, V.CONFIG.MaxDistance, 0, function(v) V.CONFIG.MaxDistance = v end, {ConfigKey = "MaxDistance"})

local groupVisP = section(V.visPlayers.Right, "Visibility")
toggle(groupVisP, "Check Visibility", V.CONFIG.VisibilityCheck, function(v) V.CONFIG.VisibilityCheck = v end, {ConfigKey = "VisibilityCheck"})
colorPick(groupVisP, "Visible Color", V.CONFIG.VisibleColor, function(v) V.CONFIG.VisibleColor = v end, {ConfigKey = "VisibleColor"})
colorPick(groupVisP, "Hidden Color", V.CONFIG.HiddenColor, function(v) V.CONFIG.HiddenColor = v end, {ConfigKey = "HiddenColor"})

-- ── LOCAL ESP ──────────────────────────────
local groupLocal = section(V.visLocal.Left, "Self ESP")
toggle(groupLocal, "Enable Local ESP", V.CONFIG.LocalPlayerESP, function(v) 
    V.CONFIG.LocalPlayerESP = v 
end, {
    ColorData = {Default = V.CONFIG.LocalPlayerColor, Callback = function(v) V.CONFIG.LocalPlayerColor = v end, ConfigKey = "LocalPlayerColor"},
    ConfigKey = "LocalPlayerESP"
})
toggle(groupLocal, "Box", V.CONFIG.LocalBox, function(v) V.CONFIG.LocalBox = v end, {
    ColorData = {Default = V.CONFIG.LocalBoxColor, Callback = function(v) V.CONFIG.LocalBoxColor = v end, ConfigKey = "LocalBoxColor"},
    ConfigKey = "LocalBox"
})
toggle(groupLocal, "Skeleton", V.CONFIG.LocalSkeleton, function(v) V.CONFIG.LocalSkeleton = v end, {
    ColorData = {Default = V.CONFIG.LocalSkeletonColor, Callback = function(v) V.CONFIG.LocalSkeletonColor = v end, ConfigKey = "LocalSkeletonColor"},
    ConfigKey = "LocalSkeleton"
})
toggle(groupLocal, "Health Bar", V.CONFIG.LocalHealthBar, function(v) V.CONFIG.LocalHealthBar = v end, {ConfigKey = "LocalHealthBar"})
toggle(groupLocal, "Tracers", V.CONFIG.LocalTracers, function(v) V.CONFIG.LocalTracers = v end, {
    ColorData = {Default = V.CONFIG.LocalTracersColor, Callback = function(v) V.CONFIG.LocalTracersColor = v end, ConfigKey = "LocalTracersColor"},
    ConfigKey = "LocalTracers"
})

-- ── WORLD ──────────────────────────────
local groupWorld = section(V.visWorld.Left, "Environment")
toggle(groupWorld, "Ambience", V.CONFIG.AmbienceEnabled, function(v) V.CONFIG.AmbienceEnabled = v end, {
    ColorData = {Default = V.CONFIG.AmbienceColor, Callback = function(v) V.CONFIG.AmbienceColor = v end, ConfigKey = "AmbienceColor"},
    ConfigKey = "AmbienceEnabled"
})

-- ── OTHER ──────────────────────────────
V.visOther = addSubTab(V.vis, "Other")
local scopeGroup = section(V.visOther.Left, "Custom Scope")

toggle(scopeGroup, "Enable Scope", V.CONFIG.ScopeEnabled, function(v) V.CONFIG.ScopeEnabled = v end, {
    ColorData = {Default = V.CONFIG.ScopeColor, Callback = function(v) V.CONFIG.ScopeColor = v end, ConfigKey = "ScopeColor"},
    ConfigKey = "ScopeEnabled"
})

slider(scopeGroup, "Scope Gap", 0, 50, V.CONFIG.ScopeGap, 0, function(v) V.CONFIG.ScopeGap = v end, {ConfigKey = "ScopeGap"})
slider(scopeGroup, "Scope Length", 1, 100, V.CONFIG.ScopeLength, 0, function(v) V.CONFIG.ScopeLength = v end, {ConfigKey = "ScopeLength"})
slider(scopeGroup, "Scope Thickness", 1, 10, V.CONFIG.ScopeThickness, 1, function(v) V.CONFIG.ScopeThickness = v end, {ConfigKey = "ScopeThickness"})
toggle(scopeGroup, "Center Dot", V.CONFIG.ScopeCenterDot, function(v) V.CONFIG.ScopeCenterDot = v end, {ConfigKey = "ScopeCenterDot"})
toggle(scopeGroup, "Scope Outline", V.CONFIG.ScopeOutline, function(v) V.CONFIG.ScopeOutline = v end, {ConfigKey = "ScopeOutline"})

local radarGroup = section(V.visOther.Left, "Radar")
toggle(radarGroup, "Enable Radar", V.CONFIG.RadarEnabled, function(v) V.CONFIG.RadarEnabled = v end, {ConfigKey = "RadarEnabled"})
slider(radarGroup, "Radar Size", 100, 500, V.CONFIG.RadarSize, 0, function(v) V.CONFIG.RadarSize = v end, {ConfigKey = "RadarSize"})
slider(radarGroup, "Detection Range", 50, 2000, V.CONFIG.RadarRadius, 0, function(v) V.CONFIG.RadarRadius = v end, {ConfigKey = "RadarRadius"})

-- ── V.CONFIGS ──────────────────────────────
V.cfgMain = section(V.cfg.Left, "Config Management")
local configName = ""
local configTB
local tbFrame, realTB = textbox(V.cfgMain, "Config Name", "Enter name...", function(v) configName = v end)
configTB = realTB

button(V.cfgMain, "Create New", Color3.fromRGB(70, 110, 255), function()
    if configName ~= "" then
        saveConfig(configName)
        configName = ""
        configTB.Text = ""
        refreshCfgList()
    end
end)

V.cfgList = section(V.cfg.Right, "Saved Configs")
local function refreshCfgList()
    -- Clear current list with animation
    for _, child in ipairs(V.cfgList:GetChildren()) do
        if child:IsA("Frame") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    
    if listfiles then
        local files = listfiles(V.folderName)
        for _, file in ipairs(files) do
            -- More robust name extraction to avoid ./ or other path prefixes
            local name = file:match("([^/]+)%.json$") or file:match("([^\\]+)%.json$") or file:gsub(".json", "")
            
            -- Скрываем системные файлы
            if name == "auth" then continue end
            
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 42)
            f.BackgroundTransparency = 1
            f.ClipsDescendants = true
            f.Parent = V.cfgList
            
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

button(V.cfgMain, "Refresh List", Color3.fromRGB(45, 45, 55), refreshCfgList)
refreshCfgList()

-- ── SETTINGS (Popup) ──────────────────────────
local subGroup = section(subScroll, "Panel Content")
toggle(subGroup, "Distance", V.CONFIG.ShowDistance, function(v) V.CONFIG.ShowDistance = v end, {
    ColorData = {Default = V.CONFIG.DistanceColor, Callback = function(v) V.CONFIG.DistanceColor = v end, ConfigKey = "DistanceColor"},
    ConfigKey = "ShowDistance"
})
toggle(subGroup, "Avatar", V.CONFIG.ShowAvatar, function(v) V.CONFIG.ShowAvatar = v end, {ConfigKey = "ShowAvatar"})
toggle(subGroup, "Player Name", V.CONFIG.ShowName, function(v) V.CONFIG.ShowName = v end, {
    ColorData = {Default = V.CONFIG.NameColor, Callback = function(v) V.CONFIG.NameColor = v end, ConfigKey = "NameColor"},
    ConfigKey = "ShowName"
})
toggle(subGroup, "Health", V.CONFIG.ShowHealth, function(v) V.CONFIG.ShowHealth = v end, {
    ColorData = {Default = V.CONFIG.HealthColor, Callback = function(v) V.CONFIG.HealthColor = v end, ConfigKey = "HealthColor"},
    ConfigKey = "ShowHealth"
})
colorPick(subGroup, "Heart Color", V.CONFIG.HeartColor, function(v) V.CONFIG.HeartColor = v end, {ConfigKey = "HeartColor"})

local groupMisc = section(V.misc.Left, "Miscellaneous")
toggle(groupMisc, "Show Keybinds List", V.CONFIG.ShowBindWindow, function(v) 
    V.CONFIG.ShowBindWindow = v 
    updateBindList()
end, {ConfigKey = "ShowBindWindow"})

toggle(groupMisc, "High Jump", V.CONFIG.HighJumpEnabled, function(v) 
    V.CONFIG.HighJumpEnabled = v 
end, {ConfigKey = "HighJumpEnabled"})

slider(groupMisc, "Jump Height", 0, 200, V.CONFIG.HighJumpValue, 0, function(v) 
    V.CONFIG.HighJumpValue = v 
end, {ConfigKey = "HighJumpValue"})

local groupMenu = section(V.misc.Right, "Menu Settings")
-- Menu size sliders removed

local function unload()
    V.isAuthorized = false
    V.menuOpen = false
    
    -- Disable all visual features
    V.CONFIG.Enabled = false
    V.CONFIG.AmbienceEnabled = false
    V.CONFIG.ScopeEnabled = false
    V.CONFIG.RadarEnabled = false
    V.CONFIG.HighJumpEnabled = false
    
    -- Remove all ESP objects
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if V.ESPObjects[p] then
                for _, obj in pairs(V.ESPObjects[p]) do
                    if typeof(obj) == "Instance" then obj:Destroy()
                    elseif type(obj) == "table" and obj.Remove then obj:Remove()
                    elseif type(obj) == "table" and obj.Destroy then obj:Destroy() end
                end
                V.ESPObjects[p] = nil
            end
        end
    end)
    
    -- Remove death markers
    pcall(function()
        for _, m in pairs(V.DeathMarkers) do
            if m.Line1 then m.Line1:Remove() end
            if m.Line2 then m.Line2:Remove() end
            if m.Text then m.Text:Remove() end
        end
        V.DeathMarkers = {}
    end)
    
    -- Restore lighting
    pcall(function()
        if savedSettings then
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
            savedSettings = nil
        end
    end)
    
    -- Hide radar
    pcall(function()
        if V.RadarSystem and V.RadarSystem.Window then
            V.RadarSystem.Window.Visible = false
        end
    end)
    
    -- Destroy ALL GUI (menu, login, register, everything)
    pcall(function()
        if V.ESPGui then V.ESPGui:Destroy() end
        if V.MenuGui then V.MenuGui:Destroy() end
    end)
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

-- ════════════ REGISTRATION UI ════════════
V.RegisterPanel = Instance.new("CanvasGroup")
V.RegisterPanel.Size = UDim2.new(0, 350, 0, 250)
V.RegisterPanel.Position = UDim2.new(0.5, -175, 0.5, -125)
V.RegisterPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
V.RegisterPanel.BorderSizePixel = 0
V.RegisterPanel.Visible = true
V.RegisterPanel.Parent = V.MenuGui
Instance.new("UICorner", V.RegisterPanel).CornerRadius = UDim.new(0, 12)
local regStroke = Instance.new("UIStroke", V.RegisterPanel)
regStroke.Color = Color3.fromRGB(70, 110, 255)
regStroke.Thickness = 2
regStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local rHeader = Instance.new("Frame", V.RegisterPanel)
rHeader.Size = UDim2.new(1, 0, 0, 45)
rHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
rHeader.BorderSizePixel = 0
Instance.new("UICorner", rHeader).CornerRadius = UDim.new(0, 12)

local rTitle = Instance.new("TextLabel", rHeader)
rTitle.Size = UDim2.new(1, 0, 1, 0)
rTitle.BackgroundTransparency = 1
rTitle.Font = Enum.Font.GothamBold
rTitle.Text = "ASTRUM REGISTRATION"
rTitle.TextColor3 = Color3.fromRGB(70, 110, 255)
rTitle.TextSize = 16

V.regInput = Instance.new("TextBox", V.RegisterPanel)
V.regInput.Size = UDim2.new(1, -60, 0, 40)
V.regInput.Position = UDim2.new(0, 30, 0, 80)
V.regInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
V.regInput.BorderSizePixel = 0
V.regInput.Font = Enum.Font.GothamMedium
V.regInput.PlaceholderText = "Choose a nickname..."
V.regInput.Text = ""
V.regInput.TextColor3 = Color3.new(1, 1, 1)
V.regInput.TextSize = 14
Instance.new("UICorner", V.regInput).CornerRadius = UDim.new(0, 8)
local rsStroke = Instance.new("UIStroke", V.regInput)
rsStroke.Color = Color3.fromRGB(45, 45, 55)

local regBtn = Instance.new("TextButton", V.RegisterPanel)
regBtn.Size = UDim2.new(1, -60, 0, 45)
regBtn.Position = UDim2.new(0, 30, 0, 140)
regBtn.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
regBtn.Font = Enum.Font.GothamBold
regBtn.Text = "CONTINUE"
regBtn.TextColor3 = Color3.new(1, 1, 1)
regBtn.TextSize = 14
Instance.new("UICorner", regBtn).CornerRadius = UDim.new(0, 8)

V.regStatus = Instance.new("TextLabel", V.RegisterPanel)
V.regStatus.Size = UDim2.new(1, 0, 0, 30)
V.regStatus.Position = UDim2.new(0, 0, 0, 200)
V.regStatus.BackgroundTransparency = 1
V.regStatus.Font = Enum.Font.GothamMedium
V.regStatus.Text = "Welcome to Astrum"
V.regStatus.TextColor3 = Color3.fromRGB(150, 150, 165)
V.regStatus.TextSize = 12

regBtn.MouseButton1Click:Connect(function()
    if V.regInput.Text == "" then
        V.regStatus.Text = "Please enter a nickname"
        V.regStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local targetPos = UDim2.new(0.5, -175, 0.5, -25) -- Slide down
    tw(V.RegisterPanel, {GroupTransparency = 1, Position = targetPos}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Connect(function()
        V.RegisterPanel.Visible = false
        V.LoginPanel.Visible = true
        V.LoginPanel.GroupTransparency = 1
        V.LoginPanel.Position = UDim2.new(0.5, -175, 0.5, -185) -- Start from above
        tw(V.LoginPanel, {GroupTransparency = 0, Position = UDim2.new(0.5, -175, 0.5, -155)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
end)

-- ════════════ LOGIN SYSTEM UI ════════════
V.LoginPanel = Instance.new("CanvasGroup")
V.LoginPanel.Size = UDim2.new(0, 350, 0, 310)
V.LoginPanel.Position = UDim2.new(0.5, -175, 0.5, -155)
V.LoginPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
V.LoginPanel.BorderSizePixel = 0
V.LoginPanel.Visible = false
V.LoginPanel.Parent = V.MenuGui
Instance.new("UICorner", V.LoginPanel).CornerRadius = UDim.new(0, 12)
local loginStroke = Instance.new("UIStroke", V.LoginPanel)
loginStroke.Color = Color3.fromRGB(70, 110, 255)
loginStroke.Thickness = 2
loginStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local function animateStroke(stroke)
    task.spawn(function()
        while stroke and stroke.Parent do
            local t = tw(stroke, {Transparency = 0.8}, 1.2)
            t.Completed:Wait()
            local t2 = tw(stroke, {Transparency = 0}, 1.2)
            t2.Completed:Wait()
        end
    end)
end

animateStroke(regStroke)
animateStroke(loginStroke)

local lHeader = Instance.new("Frame", V.LoginPanel)
lHeader.Size = UDim2.new(1, 0, 0, 45)
lHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
lHeader.BorderSizePixel = 0
Instance.new("UICorner", lHeader).CornerRadius = UDim.new(0, 12)

local lTitle = Instance.new("TextLabel", lHeader)
lTitle.Size = UDim2.new(1, 0, 1, 0)
lTitle.BackgroundTransparency = 1
lTitle.Font = Enum.Font.GothamBold
lTitle.Text = "ASTRUM AUTH"
lTitle.TextColor3 = Color3.fromRGB(70, 110, 255)
lTitle.TextSize = 16

V.keyInput = Instance.new("TextBox", V.LoginPanel)
V.keyInput.Size = UDim2.new(1, -60, 0, 40)
V.keyInput.Position = UDim2.new(0, 30, 0, 80)
V.keyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
V.keyInput.BorderSizePixel = 0
V.keyInput.Font = Enum.Font.GothamMedium
V.keyInput.PlaceholderText = "Enter your key here..."
V.keyInput.Text = ""
V.keyInput.TextColor3 = Color3.new(1, 1, 1)
V.keyInput.TextSize = 14
Instance.new("UICorner", V.keyInput).CornerRadius = UDim.new(0, 8)
local kStroke = Instance.new("UIStroke", V.keyInput)
kStroke.Color = Color3.fromRGB(45, 45, 55)

local loginBtn = Instance.new("TextButton", V.LoginPanel)
loginBtn.Size = UDim2.new(1, -60, 0, 45)
loginBtn.Position = UDim2.new(0, 30, 0, 140)
loginBtn.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
loginBtn.Font = Enum.Font.GothamBold
loginBtn.Text = "VERIFY KEY"
loginBtn.TextColor3 = Color3.new(1, 1, 1)
loginBtn.TextSize = 14
Instance.new("UICorner", loginBtn).CornerRadius = UDim.new(0, 8)

V.statusLbl = Instance.new("TextLabel", V.LoginPanel)
V.statusLbl.Size = UDim2.new(1, 0, 0, 30)
V.statusLbl.Position = UDim2.new(0, 0, 0, 200)
V.statusLbl.BackgroundTransparency = 1
V.statusLbl.Font = Enum.Font.GothamMedium
V.statusLbl.Text = "Awaiting input..."
V.statusLbl.TextColor3 = Color3.fromRGB(150, 150, 165)
V.statusLbl.TextSize = 12

local hwidBox = Instance.new("TextBox", V.LoginPanel)
hwidBox.Size = UDim2.new(1, -60, 0, 30)
hwidBox.Position = UDim2.new(0, 30, 0, 240)
hwidBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
hwidBox.BorderSizePixel = 0
hwidBox.Font = Enum.Font.Code
hwidBox.Text = V.hwid
hwidBox.ClearTextOnFocus = false
hwidBox.TextEditable = false
hwidBox.TextColor3 = Color3.fromRGB(100, 100, 120)
hwidBox.TextSize = 10
Instance.new("UICorner", hwidBox).CornerRadius = UDim.new(0, 4)

local hwidLabel = Instance.new("TextLabel", V.LoginPanel)
hwidLabel.Size = UDim2.new(1, 0, 0, 15)
hwidLabel.Position = UDim2.new(0, 30, 0, 275)
hwidLabel.BackgroundTransparency = 1
hwidLabel.Font = Enum.Font.GothamMedium
hwidLabel.Text = "Your HWID (Click to copy)"
hwidLabel.TextColor3 = Color3.fromRGB(80, 80, 90)
hwidLabel.TextSize = 10
hwidLabel.TextXAlignment = Enum.TextXAlignment.Left

local function getDuration(amount, unit)
    amount = tonumber(amount) or 0
    unit = unit:lower()
    if unit:find("hour") then return amount * 3600
    elseif unit:find("day") then return amount * 86400
    elseif unit:find("week") then return amount * 604800
    elseif unit:find("month") then return amount * 2592000
    elseif unit:find("min") or unit == "m" then return amount * 60
    elseif unit:find("lifetime") then return -1
    end
    return 0
end

local function formatTime(seconds)
    if seconds < 0 then return "Infinite" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    if days > 0 then
        return string.format("%dd %02dh %02dm %02ds", days, hours, mins, secs)
    elseif hours > 0 then
        return string.format("%02dh %02dm %02ds", hours, mins, secs)
    else
        return string.format("%02dm %02ds", mins, secs)
    end
end


function V.checkKeyOnServer(entered)
    local result = nil
    local lastError = "Request failed"
    local _h1 = "raw." .. V._v2 .. V._r3 .. ".com"
    local _p1 = "/Visionprog11/sentinel-software/main/1.txt"
    
    local function tryFetch()
        local errors = {}
        local ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        local cacheBuster = "?cb=" .. os.time()
        local rawUrl = "https://" .. _h1 .. _p1 .. cacheBuster
        local apiUrl = "https://api." .. V._v2 .. ".com/repos/Visionprog11/sentinel-software/contents/1.txt"
        local urls = {
            {u = rawUrl, t = "raw"},
            {u = apiUrl, t = "api"}
        }

        local rData = (request or http_request or (http and http.request))
        
        for i, target in ipairs(urls) do
            -- 1. Try with custom headers (Required for API and to avoid Raw blocks)
            if rData then
                local s2, r2 = pcall(function() 
                    return rData({
                        Url = target.u, 
                        Method = "GET", 
                        Headers = {["User-Agent"] = ua, ["Cache-Control"] = "no-cache"}
                    }) 
                end)
                if s2 and type(r2) == "table" and r2.StatusCode == 200 and type(r2.Body) == "string" and #r2.Body > 5 then
                    if target.t == "api" then
                        local success, decoded = pcall(function()
                            local json = HttpService:JSONDecode(r2.Body)
                            local content = json.content:gsub("%s", "")
                            -- Use available Base64 decoder
                            return (syn and syn.crypt and syn.crypt.base64.decode(content)) or 
                                   (base64 and base64.decode(content)) or
                                   (Crypt and Crypt.base64_decode and Crypt.base64_decode(content)) or
                                   content
                        end)
                        if success and #decoded > 5 then return decoded end
                    else
                        return r2.Body
                    end
                elseif s2 and type(r2) == "table" then
                    table.insert(errors, target.t .. ":" .. tostring(r2.StatusCode))
                end
            end

            -- 2. Fallback to HttpGet
            local s1, r1 = pcall(function() return game:HttpGet(target.u) end)
            if s1 and type(r1) == "string" and #r1 > 10 and not r1:find("403") and not r1:find("Forbidden") then
                return r1
            end
            table.insert(errors, target.t .. "G")
        end

        return nil, "Auth: " .. table.concat(errors, " | ")
    end

    result, lastError = tryFetch()
    if not result then return nil, lastError end

    local cleanEntered = entered:gsub("^%s*(.-)%s*$", "%1")
    local currentNick = (V.regInput and V.regInput.Text ~= "") and V.regInput.Text or V.LP.Name
    local cleanNick = currentNick:lower():gsub("%s", "")
    
    local foundKey = nil
    local nickTaken = false
    
    for rawLine in result:gmatch("[^\r\n]+") do
        local line = rawLine:gsub("^%s*(.-)%s*$", "%1")
        if line == "" then continue end
        
        -- Parse: Key (Duration, Nick, HWID)
        local key, params = line:match("^([^%s(]+)%s*%((.+)%)")
        local dPart, nPart, hPart = "lifetime", "", ""
        
        if key then
            local parts = params:split(",")
            dPart = (parts[1] or "lifetime"):gsub("%s", "")
            nPart = (parts[2] or ""):gsub("%s", "")
            hPart = (parts[3] or ""):gsub("%s", "")
        else
            key = line:match("^([^%s(]+)")
        end

        -- Check if this is our key
        if key == cleanEntered then
            foundKey = {k = key, d = dPart, n = nPart, h = hPart}
        end

        -- Check if this nick is used by ANY OTHER key
        if nPart ~= "" and nPart:lower() == cleanNick and key ~= cleanEntered then
            nickTaken = true
        end
    end

    if not foundKey then 
        return false, "key is expired." 
    end

    -- 1. If key already has a nick, it MUST match our entered nick
    if foundKey.n ~= "" and foundKey.n:lower() ~= cleanNick then
        return false, "Wrong Nickname."
    end

    -- 2. If key has NO nick yet, check if chosen nick is already taken by another key
    if foundKey.n == "" and nickTaken then
        return false, "Nickname already taken."
    end

    -- 3. HWID check (ONLY IF KEY HAS A NICKNAME - private key)
    if foundKey.n ~= "" then
        if foundKey.h ~= "" and foundKey.h ~= V.hwid then
            return false, "Invalid HWID"
        end
    end

    local duration = -1
    local isTimestamp = tonumber(foundKey.d)
    
    if foundKey.d == "expired" then
        return false, "key is expired."
    elseif isTimestamp then
        local now = os.time()
        if now >= isTimestamp then
            return false, "key is expired."
        end
        duration = isTimestamp - now
    else
        local amt, unt = foundKey.d:match("(%d*)%s*(%a+)")
        if amt and unt then
            duration = getDuration(amt ~= "" and amt or 0, unt)
        end
    end

    return true, duration, cleanEntered
end

local function verifyKey(savedKey)
    local entered = savedKey or V.keyInput.Text
    if entered == "" then
        V.statusLbl.Text = "Please enter a key"
        V.statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    V.statusLbl.Text = (savedKey and "Auto-logging in..." or "Connecting to server...")
    V.statusLbl.TextColor3 = Color3.fromRGB(255, 255, 255)

    task.spawn(function()
        local success, data, cleanKey = V.checkKeyOnServer(entered)
        
        if success then
            local authPath = V.folderName .. "/auth.json"
            local authData = {Key = cleanKey, ActivatedAt = os.time()}
            
            if isfile(authPath) then
                pcall(function() 
                    local decoded = HttpService:JSONDecode(readfile(authPath))
                    if decoded and decoded.Key == cleanKey then authData = decoded end
                end)
            end

            V.lastUsedKey = cleanKey
            V.lastAuthSync = os.time()
            local duration = data

            -- [DIRECT HWID AUTO-BINDING]
            task.spawn(function()
                local _z7 = "V31jk"
                local _q8 = "DNdi3"
                local _f9 = "3sf1jq"
                local full_token = V._x1 .. V._k4 .. V._s5 .. V._m6 .. _z7 .. _q8 .. _f9
                
                local _api = "api." .. V._v2 .. ".com"
                local owner = "Visionprog11"
                local repo = "sentinel-software"
                local path = "1.txt"
                local api_url = string.format("https://%s/repos/%s/%s/contents/%s", _api, owner, repo, path)
                local rData = (request or http_request or (http and http.request))
                
                if not rData then return end

                pcall(function()
                    -- 1. Получаем текущий файл
                    local g = rData({
                        Url = api_url,
                        Method = "GET",
                        Headers = {["Authorization"] = "token " .. full_token, ["User-Agent"] = "Sentinel-Auth"}
                    })
                    
                    if g.StatusCode == 200 then
                        local json = HttpService:JSONDecode(g.Body)
                        local sha = json.sha
                        
                        -- Декодируем содержимое
                        local b64 = json.content:gsub("%s", "")
                        local content = (syn and syn.crypt and syn.crypt.base64.decode(b64)) or 
                                        (base64 and base64.decode(b64)) or ""
                        
                        if content == "" then return end

                        local lines = content:split("\n")
                        local changed = false
                        -- Сначала определяем ник текущего ключа
                        local myNick = ""
                        for i, line in ipairs(lines) do
                            local cleanLine = line:gsub("^%s*(.-)%s*$", "%1")
                            if cleanLine:sub(1, #cleanKey) == cleanKey then
                                local k, p = cleanLine:match("^([^%s(]+)%s*%((.+)%)")
                                if k and p then
                                    local pts = p:split(",")
                                    myNick = (pts[2] or ""):gsub("%s","")
                                end
                                break
                            end
                        end
                        
                        -- Если НИК пустой — ключ ОБЩИЙ, не привязываем
                        if myNick == "" then return end

                        -- Теперь привязываем HWID ко ВСЕМ ключам с этим ником
                        for i, line in ipairs(lines) do
                            local cleanLine = line:gsub("^%s*(.-)%s*$", "%1")
                            local k, p = cleanLine:match("^([^%s(]+)%s*%((.+)%)")
                            if k and p then
                                local parts = p:split(",")
                                local dur = (parts[1] or "lifetime"):gsub("%s","")
                                local nick = (parts[2] or ""):gsub("%s","")
                                local hw = (parts[3] or ""):gsub("%s","")
                                
                                -- Только ключи с таким же ником
                                if nick:lower() == myNick:lower() then
                                    -- Переводим относительное время в TIMESTAMP
                                    local origDur = dur
                                    local isTS = tonumber(dur)
                                    if not isTS and dur ~= "lifetime" and dur ~= "expired" then
                                        local amt, unt = dur:match("(%d*)%s*(%a+)")
                                        if amt and unt then
                                            local dSecs = getDuration(amt ~= "" and amt or 0, unt)
                                            if dSecs > 0 then
                                                dur = tostring(os.time() + dSecs)
                                            end
                                        end
                                    end

                                    -- Если HWID пустой ИЛИ время изменилось — обновляем
                                    if hw == "" or dur ~= origDur then
                                        lines[i] = string.format("%s (%s, %s, %s)", k, dur, nick, V.hwid)
                                        changed = true
                                    end
                                end
                            end
                        end

                        -- 2. Если файл изменился — отправляем назад
                        if changed then
                            local new_content = table.concat(lines, "\n")
                            local encoded = (syn and syn.crypt and syn.crypt.base64.encode(new_content)) or 
                                            (base64 and base64.encode(new_content)) or ""
                            
                            if encoded ~= "" then
                                rData({
                                    Url = api_url,
                                    Method = "PUT",
                                    Headers = {
                                        ["Authorization"] = "token " .. full_token,
                                        ["Content-Type"] = "application/json"
                                    },
                                    Body = HttpService:JSONEncode({
                                        message = "Auto-bind HWID: " .. cleanKey,
                                        content = encoded,
                                        sha = sha
                                    })
                                })
                            end
                        end
                    end
                end)
            end)

                if duration ~= -1 then
                    local now = os.time()
                    local elapsed = now - authData.ActivatedAt
                    if elapsed >= duration then
                        V.expireSession()
                        return
                    else
                        V.statusLbl.Text = "Success! " .. formatTime(duration - elapsed) .. " left"
                    end
                else
                    V.statusLbl.Text = "Success! Lifetime access."
                end


                local finalNick = (V.regInput and V.regInput.Text ~= "") and V.regInput.Text or V.LP.Name
                authData.Nick = finalNick
                writefile(authPath, HttpService:JSONEncode(authData))
                
                V.userLbl.Text = "User: " .. finalNick
                V.authSessionDuration = duration
                V.authSessionStart = authData.ActivatedAt
                
                -- Автозагрузка последнего конфига
                pcall(function()
                    if authData.LastConfig and authData.LastConfig ~= "" then
                        loadConfig(authData.LastConfig)
                    end
                end)
                
                if duration == -1 then
                    V.timeLbl.Text = "Time: Lifetime"
                else
                    local left = duration - (os.time() - authData.ActivatedAt)
                    V.timeLbl.Text = "Time: " .. formatTime(left)
                end

                V.statusLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
                
                -- [WEBHOOK NOTIFICATION]
                task.spawn(function()
                    if V.webhookURL ~= "" and V.webhookURL:find("discord") then
                        pcall(function()
                            local payload = {
                                ["content"] = "",
                                ["embeds"] = {{
                                    ["title"] = "🚀 Новая авторизация в Astrum",
                                    ["color"] = 5814783, -- Blue
                                    ["fields"] = {
                                        {["name"] = "Ник", ["value"] = finalNick, ["inline"] = true},
                                        {["name"] = "Ключ", ["value"] = "`" .. cleanKey .. "`", ["inline"] = true},
                                        {["name"] = "ID", ["value"] = "`" .. V.hwid .. "`", ["inline"] = false},
                                        {["name"] = "Доступ", ["value"] = (duration == -1 and "Lifetime" or formatTime(duration)), ["inline"] = true}
                                    },
                                    ["footer"] = {["text"] = "Astrum Auth System | " .. os.date("%X")}
                                }}
                            }
                            local r = (request or http_request or (http and http.request))
                            if r then
                                r({
                                    Url = V.webhookURL,
                                    Method = "POST",
                                    Headers = {["Content-Type"] = "application/json"},
                                    Body = HttpService:JSONEncode(payload)
                                })
                            end
                        end)
                    end
                end)

                local exitPos = UDim2.new(0.5, -175, 0.5, -55)
                tw(V.LoginPanel, {GroupTransparency = 1, Position = exitPos}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                tw(V.RegisterPanel, {GroupTransparency = 1}, 0.5)
                task.wait(0.6)
                V.LoginPanel.Visible = false
                V.RegisterPanel.Visible = false
                V.isAuthorized = true
                toggleMenu()
            else
                V.statusLbl.Text = tostring(data or "key is expired.")
                V.statusLbl.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end)
end

loginBtn.MouseButton1Click:Connect(function() verifyKey() end)

function toggleMenu(force)
    if not V.isAuthorized and not force then return end
    V.menuOpen = not V.menuOpen
    if V.menuOpen then
        V.mainPanel.Visible = true
        tw(V.mainPanel, {GroupTransparency = 0}, 0.2)
        
        -- Force re-pin positioning
        V.previewPanel.Position = UDim2.new(V.mainPanel.Position.X.Scale, V.mainPanel.Position.X.Offset + 880 + 15, V.mainPanel.Position.Y.Scale, V.mainPanel.Position.Y.Offset)

        if V.tabs[1] and V.tabs[1].Page.Visible then
            V.previewPanel.Visible = true
            initPreview()
            tw(V.previewPanel, {GroupTransparency = 0}, 0.2)
        end
    else
        local t = tw(V.mainPanel, {GroupTransparency = 1}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        tw(V.previewPanel, {GroupTransparency = 1}, 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        
        if V.activePopup then
            local s = (V.activePopup == V.pickerPanel) and V.pickerScale or (V.activePopup == V.bindPanel and V.bindScale or V.subScale)
            task.spawn(function() closePopup(V.activePopup, s) end)
            V.activePopup = nil
            V.activeSource = nil
        end

        t.Completed:Connect(function()
            if not V.menuOpen then 
                V.mainPanel.Visible = false 
                V.previewPanel.Visible = false
            end
        end)
    end
end

function V.expireSession()
    if not V.isAuthorized then return end
    V.isAuthorized = false
    
    -- Close menu and radar UI
    if V.menuOpen then toggleMenu(true) end
    
    -- Disable all visual features
    V.CONFIG.Enabled = false
    V.CONFIG.AmbienceEnabled = false
    V.CONFIG.ScopeEnabled = false
    V.CONFIG.RadarEnabled = false
    V.CONFIG.HighJumpEnabled = false
    
    -- Remove all ESP objects
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if V.ESPObjects[p] then
                for _, obj in pairs(V.ESPObjects[p]) do
                    if typeof(obj) == "Instance" then obj:Destroy()
                    elseif type(obj) == "table" and obj.Remove then obj:Remove()
                    elseif type(obj) == "table" and obj.Destroy then obj:Destroy() end
                end
                V.ESPObjects[p] = nil
            end
        end
    end)
    
    -- Remove death markers
    pcall(function()
        for _, m in pairs(V.DeathMarkers) do
            if m.Line1 then m.Line1:Remove() end
            if m.Line2 then m.Line2:Remove() end
            if m.Text then m.Text:Remove() end
        end
        V.DeathMarkers = {}
    end)
    
    -- Restore lighting (ambience)
    pcall(function()
        if savedSettings then
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
            savedSettings = nil
        end
    end)
    
    -- Hide radar
    pcall(function()
        if V.RadarSystem and V.RadarSystem.Window then
            V.RadarSystem.Window.Visible = false
        end
    end)
    
    -- Remove local auth to prevent auto-login
    local authPath = V.folderName .. "/auth.json"
    if isfile(authPath) then pcall(delfile, authPath) end
    
    task.spawn(function()
        local notice = Instance.new("CanvasGroup", V.MenuGui)
        notice.Size = UDim2.new(0, 400, 0, 100)
        notice.Position = UDim2.new(0.5, -200, 0.45, -50)
        notice.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        notice.GroupTransparency = 1
        notice.ZIndex = 500
        
        Instance.new("UICorner", notice).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", notice)
        stroke.Color = Color3.fromRGB(255, 60, 60)
        stroke.Thickness = 2
        
        local t1 = Instance.new("TextLabel", notice)
        t1.Size = UDim2.new(1, 0, 0.6, 0)
        t1.BackgroundTransparency = 1
        t1.Font = Enum.Font.GothamBold
        t1.Text = "Your key has expired("
        t1.TextColor3 = Color3.new(1, 1, 1)
        t1.TextSize = 22
        
        local t2 = Instance.new("TextLabel", notice)
        t2.Size = UDim2.new(1, 0, 0.4, 0)
        t2.Position = UDim2.new(0, 0, 0.55, 0)
        t2.BackgroundTransparency = 1
        t2.Font = Enum.Font.GothamMedium
        t2.Text = "Get a new key for continue"
        t2.TextColor3 = Color3.fromRGB(220, 220, 220)
        t2.TextSize = 16
        
        -- Flashy intro
        tw(notice, {GroupTransparency = 0, Position = UDim2.new(0.5, -200, 0.5, -50)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(2.2)
        -- Smooth fade out
        tw(notice, {GroupTransparency = 1, Position = UDim2.new(0.5, -200, 0.55, -50)}, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        task.wait(0.6)
        notice:Destroy()
        
        -- Return to login state
        V.statusLbl.Text = "Key expired. Get a new one."
        V.statusLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
        V.LoginPanel.Visible = true
        tw(V.LoginPanel, {GroupTransparency = 0}, 0.5)
    end)
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then 
        if V.isAuthorized then
            toggleMenu()
        end
    end
end)

-- Drag
V.dragActive = false
V.dragStart = nil
V.startPos = nil

V.titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        V.dragActive = true
        V.dragStart = input.Position
        V.startPos = V.mainPanel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if V.dragActive and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - V.dragStart
        V.mainPanel.Position = UDim2.new(V.startPos.X.Scale, V.startPos.X.Offset + d.X, V.startPos.Y.Scale, V.startPos.Y.Offset + d.Y)
        
        -- Pin preview to menu
        V.previewPanel.Position = UDim2.new(V.mainPanel.Position.X.Scale, V.mainPanel.Position.X.Offset + V.mainPanel.AbsoluteSize.X + 15, V.mainPanel.Position.Y.Scale, V.mainPanel.Position.Y.Offset)
        
        if V.pickerPanel.Visible then
            V.pickerPanel.Position = UDim2.new(0, V.mainPanel.AbsolutePosition.X + V.mainPanel.AbsoluteSize.X + 10, 0, V.mainPanel.AbsolutePosition.Y)
        end
        if V.subPanel.Visible then
            V.subPanel.Position = UDim2.new(0, V.mainPanel.AbsolutePosition.X + V.mainPanel.AbsoluteSize.X + 10, 0, V.mainPanel.AbsolutePosition.Y)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        V.dragActive = false
    end
end)

-- ══════════════════════════════════════════════════════════
-- ESP RENDERING
-- ══════════════════════════════════════════════════════════
local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "ESP_Render"
ESPGui.ResetOnSpawn = false
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ESPGui.IgnoreGuiInset = true
ESPGui.Parent = V.LP:WaitForChild("PlayerGui")

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

-- Moved to V table

local function addDeathMarker(player, position)
    if not V.CONFIG.DeadESP then return end
    
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
    
    table.insert(V.DeathMarkers, marker)
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
        l.Color = V.CONFIG.SkeletonColor
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
    tracer.Color = V.CONFIG.TracersColor
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
    panel.BackgroundColor3 = V.CONFIG.PanelBgColor
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
    distLbl.TextColor3 = V.CONFIG.DistanceColor
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
    nameLbl.TextColor3 = V.CONFIG.NameColor
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
    heart.TextColor3 = V.CONFIG.HeartColor
    heart.TextSize = 13
    heart.Text = "♥"
    heart.LayoutOrder = 1
    heart.Parent = hpFrame

    local hpLbl = Instance.new("TextLabel")
    hpLbl.BackgroundTransparency = 1
    hpLbl.AutomaticSize = Enum.AutomaticSize.XY
    hpLbl.Font = Enum.Font.GothamMedium
    hpLbl.TextColor3 = V.CONFIG.HealthColor
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

    V.ESPObjects[player] = esp
end

local function removeESP(player)
    local e = V.ESPObjects[player]
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
    V.ESPObjects[player] = nil
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
    
    local active = (V.CONFIG.Enabled and ch and hum and hrp and hum.Health > 0 and (not V.CONFIG.TeamCheck or player.Team ~= V.LP.Team))
    local pos, dist
    if active then
        pos = hrp.Position
        dist = (V.Camera.CFrame.Position - pos).Magnitude / 3
        if dist > V.CONFIG.MaxDistance then active = false end
    end

    e.visCache = e.visCache or {}
    e.lastCheck = e.lastCheck or 0
    local now = tick()

    if active and V.CONFIG.VisibilityCheck then
        V.sharedRayParams.FilterDescendantsInstances = {V.LP.Character, ch}

        -- Dynamic frequency based on distance (closer = faster, further = slower)
        local freq = (dist < 50) and 0.05 or (dist < 200 and 0.2 or (dist < 500 and 0.5 or 2.0))
        if now - e.lastCheck > freq then
            e.lastCheck = now
            local camPos = V.Camera.CFrame.Position
            local rigType = hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"
            
            local checked = {}
            for _, conn in ipairs(V.BONES[rigType]) do
                for _, partName in ipairs(conn) do
                    if not checked[partName] then
                        checked[partName] = true
                        local part = ch:FindFirstChild(partName)
                        if part then
                            local res = SafeRaycast(camPos, part.Position, V.sharedRayParams)
                            e.visCache[partName] = not res
                        end
                    end
                end
            end
        end
    end

    -- Evaluate component V.visibility based on actual skeleton parts
    local function getC(pList)
        if not V.CONFIG.VisibilityCheck then return true end
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
    local espColor = isVisible and (V.CONFIG.VisibilityCheck and V.CONFIG.VisibleColor or nil) or (V.CONFIG.VisibilityCheck and V.CONFIG.HiddenColor or nil)

    local function getPartColor(side, lvl)
        local vs = (side == "L") and visL[lvl] or visR[lvl]
        return vs and (V.CONFIG.VisibilityCheck and V.CONFIG.VisibleColor or V.CONFIG.BoxColor) or (V.CONFIG.VisibilityCheck and V.CONFIG.HiddenColor or V.CONFIG.BoxColor)
    end

    -- Animation Logic (Interpolation)
    local lerpSpeed = 0.15
    local function anim(cur, target)
        cur = cur or 0 -- Fail-safe if not initialized
        if math.abs(cur - target) < 0.001 then return target end
        return cur + (target - cur) * lerpSpeed
    end

    local targetBoxAlpha = (active and V.CONFIG.BoxEnabled) and 1 or 0
    local targetSkelAlpha = (active and V.CONFIG.SkeletonEnabled) and 1 or 0
    local targetPanelAlpha = (active and V.CONFIG.PanelEnabled and (V.CONFIG.ShowDistance or V.CONFIG.ShowAvatar or V.CONFIG.ShowName or V.CONFIG.ShowHealth)) and 1 or 0
    local targetTracerAlpha = (active and V.CONFIG.TracersEnabled) and 1 or 0
    local targetHealthBarAlpha = (active and V.CONFIG.HealthBarEnabled and V.CONFIG.BoxEnabled) and 1 or 0

    e.BoxAlpha = anim(e.BoxAlpha, targetBoxAlpha)
    e.SkeletonAlpha = anim(e.SkeletonAlpha, targetSkelAlpha)
    e.PanelAlpha = anim(e.PanelAlpha, targetPanelAlpha)
    e.TracerAlpha = anim(e.TracerAlpha, targetTracerAlpha)
    e.HealthBarAlpha = anim(e.HealthBarAlpha, targetHealthBarAlpha)
    e.Scale = anim(e.Scale, targetPanelAlpha > 0.5 and 1 or 0.7)

    -- Update Viewport Positions
    local tS, bS, tOn, bOn
    if active then
        tS, tOn = V.Camera:WorldToViewportPoint(pos + Vector3.new(0, 3.2, 0))
        bS, bOn = V.Camera:WorldToViewportPoint(pos - Vector3.new(0, 3.2, 0))
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

            -- Top horizontal (uses mixed V.visibility)
            local topColor = (visL[1] or visR[1]) and (V.CONFIG.VisibilityCheck and V.CONFIG.VisibleColor or V.CONFIG.BoxColor) or (V.CONFIG.VisibilityCheck and V.CONFIG.HiddenColor or V.CONFIG.BoxColor)
            e.BoxOutline[11].From, e.BoxOutline[11].To = Vector2.new(cX - bW/2, tS.Y), Vector2.new(cX + bW/2, tS.Y)
            e.BoxOutline[11].Transparency, e.BoxOutline[11].Visible = e.BoxAlpha * 0.5, true
            e.BoxSegments[11].From, e.BoxSegments[11].To = Vector2.new(cX - bW/2, tS.Y), Vector2.new(cX + bW/2, tS.Y)
            e.BoxSegments[11].Color, e.BoxSegments[11].Transparency, e.BoxSegments[11].Visible = topColor, e.BoxAlpha, true

            -- Bottom horizontal
            local botColor = (visL[5] or visR[5]) and (V.CONFIG.VisibilityCheck and V.CONFIG.VisibleColor or V.CONFIG.BoxColor) or (V.CONFIG.VisibilityCheck and V.CONFIG.HiddenColor or V.CONFIG.BoxColor)
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
            local bones = V.BONES[rigType]
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
                        local v1, on1 = V.Camera:WorldToViewportPoint(p1.Position)
                        local v2, on2 = V.Camera:WorldToViewportPoint(p2.Position)
                        
                        -- Draw even if one point is off-screen, as long as both are in front of camera
                        if v1.Z > 0 and v2.Z > 0 then
                            local from, to = Vector2.new(v1.X, v1.Y), Vector2.new(v2.X, v2.Y)
                            
                            outline.From = from
                            outline.To = to
                            outline.Transparency = e.SkeletonAlpha * 0.5
                            outline.Visible = true

                            line.From = from
                            line.To = to
                            line.Color = espColor or V.CONFIG.SkeletonColor
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
            e.Tracer.Color = espColor or V.CONFIG.TracersColor
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
                e.DistLbl.TextColor3 = V.CONFIG.DistanceColor
                e.DistLbl.Visible = V.CONFIG.ShowDistance

                local fhp = math.floor(hum.Health)
                if e.LastTextHp ~= fhp then
                    e.LastTextHp = fhp
                    e.HpLbl.Text = tostring(fhp)
                end
                e.HpLbl.TextSize = fontSize
                e.HpLbl.TextColor3 = V.CONFIG.HealthColor
                
                e.Heart.TextSize = fontSize + 1
                e.Heart.TextColor3 = V.CONFIG.HeartColor
                e.HpFrame.Visible = V.CONFIG.ShowHealth

                e.NameLbl.TextSize = fontSize
                e.NameLbl.TextColor3 = V.CONFIG.NameColor
                e.NameLbl.Visible = V.CONFIG.ShowName

                local targetAvSize = math.clamp(fontSize + 2, 11, 18)
                if e.LastAvSize ~= targetAvSize then
                    e.LastAvSize = targetAvSize
                    e.AvatarImg.Size = UDim2.new(0, targetAvSize, 0, targetAvSize)
                end
                e.AvatarImg.Visible = V.CONFIG.ShowAvatar
            end

            e.Panel.BackgroundColor3 = V.CONFIG.PanelBgColor
            e.Panel.GroupTransparency = 1 - e.PanelAlpha
            e.PanelScale.Scale = e.Scale

            e.Dividers[1].Visible = V.CONFIG.ShowDistance and (V.CONFIG.ShowAvatar or V.CONFIG.ShowName or V.CONFIG.ShowHealth)
            e.Dividers[2].Visible = V.CONFIG.ShowAvatar and (V.CONFIG.ShowName or V.CONFIG.ShowHealth)
            e.Dividers[3].Visible = V.CONFIG.ShowName and V.CONFIG.ShowHealth

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
    if p ~= V.LP then createESP(p) end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= V.LP then createESP(p) end
end)

Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    if not V.isAuthorized then return end
    local tOrigin
    if V.CONFIG.TracersEnabled then
        local vSize = V.Camera.ViewportSize
        if V.CONFIG.TracerOrigin == "Bottom" then
            tOrigin = Vector2.new(vSize.X/2, vSize.Y)
        elseif V.CONFIG.TracerOrigin == "Top" then
            tOrigin = Vector2.new(vSize.X/2, 0)
        elseif V.CONFIG.TracerOrigin == "Middle" then
            tOrigin = Vector2.new(vSize.X/2, vSize.Y/2)
        else
            tOrigin = UIS:GetMouseLocation()
        end
    end

    for p, e in pairs(V.ESPObjects) do
        local ok, err = pcall(function()
            updateESP(p, e, tOrigin)
        end)
        if not ok then
            warn("[ESP] Error updating for " .. tostring(p) .. ": " .. tostring(err))
        end
    end

    -- Dead ESP Rendering
    for i = #V.DeathMarkers, 1, -1 do
        local m = V.DeathMarkers[i]
        local age = tick() - m.Time
        
        if age > V.CONFIG.DeadESPDuration or not V.CONFIG.Enabled then
            m.Line1:Remove()
            m.Line2:Remove()
            m.Text:Remove()
            table.remove(V.DeathMarkers, i)
        elseif V.CONFIG.DeadESP then
            local pos, on = V.Camera:WorldToViewportPoint(m.Pos)
            local dist = (V.Camera.CFrame.Position - m.Pos).Magnitude / 3

            if on and dist <= V.CONFIG.MaxDistance then
                local s = 8
                m.Line1.From = Vector2.new(pos.X - s, pos.Y - s)
                m.Line1.To = Vector2.new(pos.X + s, pos.Y + s)
                m.Line1.Color = V.CONFIG.DeadESPColor
                m.Line1.Visible = true
                
                m.Line2.From = Vector2.new(pos.X + s, pos.Y - s)
                m.Line2.To = Vector2.new(pos.X - s, pos.Y + s)
                m.Line2.Color = V.CONFIG.DeadESPColor
                m.Line2.Visible = true
                
                local timeLeft = math.max(0, math.floor(V.CONFIG.DeadESPDuration - age))
                m.Text.Text = string.format("%s (DEAD) [%dm] [%ds]", m.Name, math.floor(dist), timeLeft)
                m.Text.Position = Vector2.new(pos.X, pos.Y + s + 2)
                m.Text.Color = V.CONFIG.DeadESPColor
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
    if not V.isAuthorized then
        for _, l in pairs(localESP.Box) do l.Visible = false end
        for _, l in pairs(localESP.Skeleton) do l.Visible = false end
        localESP.HealthBar.Visible = false; localESP.HealthBarBg.Visible = false
        localESP.Tracer.Visible = false
        return 
    end
    local ch  = V.LP.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")

    if not V.CONFIG.LocalPlayerESP or not ch or not hum or not hrp or hum.Health <= 0 then
        for _, l in pairs(localESP.Box) do l.Visible = false end
        for _, l in pairs(localESP.Skeleton) do l.Visible = false end
        localESP.HealthBar.Visible = false; localESP.HealthBarBg.Visible = false
        localESP.Tracer.Visible = false
        return
    end

    local col = V.CONFIG.LocalPlayerColor
    local rigType = hum.RigType == Enum.HumanoidRigType.R15 and "R15" or "R6"

    local function proj(v3)
        local p, vis = V.Camera:WorldToViewportPoint(v3)
        if not vis or p.Z <= 0 then return nil end
        return Vector2.new(p.X, p.Y)
    end

    -- BOX + HEALTH BAR
    local head  = ch:FindFirstChild("Head")
    local lFoot = ch:FindFirstChild("LeftFoot")  or ch:FindFirstChild("Left Leg")
    local rFoot = ch:FindFirstChild("RightFoot") or ch:FindFirstChild("Right Leg")
    if V.CONFIG.LocalBox and head and (lFoot or rFoot) then
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
            for _, l in pairs(localESP.Box) do l.Color = V.CONFIG.LocalBoxColor; l.Visible = true end
            if V.CONFIG.LocalHealthBar then
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
    if V.CONFIG.LocalSkeleton and V.BONES[rigType] then
        local idx = 1
        for _, pair in ipairs(V.BONES[rigType]) do
            local p1 = ch:FindFirstChild(pair[1])
            local p2 = ch:FindFirstChild(pair[2])
            local line = localESP.Skeleton[idx]
            if line then
                if p1 and p2 then
                    local s1, s2 = proj(p1.Position), proj(p2.Position)
                    if s1 and s2 then line.From = s1; line.To = s2; line.Color = V.CONFIG.LocalSkeletonColor; line.Visible = true
                    else line.Visible = false end
                else line.Visible = false end
                idx = idx + 1
            end
        end
        for i = idx, #localESP.Skeleton do localESP.Skeleton[i].Visible = false end
    else for _, l in pairs(localESP.Skeleton) do l.Visible = false end end

    -- TRACER
    if V.CONFIG.LocalTracers then
        local hrpPx = proj(hrp.Position)
        if hrpPx then
            local vS = V.Camera.ViewportSize
            localESP.Tracer.From = Vector2.new(vS.X/2, vS.Y); localESP.Tracer.To = hrpPx
            localESP.Tracer.Color = V.CONFIG.LocalTracersColor; localESP.Tracer.Visible = true
        else localESP.Tracer.Visible = false end
    else localESP.Tracer.Visible = false end
end)

local savedSettings = nil
local effectsCache = {}

local function updateLighting()
    if V.CONFIG.AmbienceEnabled then
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

        if Lighting.Ambient ~= V.CONFIG.AmbienceColor then
            Lighting.Ambient = V.CONFIG.AmbienceColor
            Lighting.OutdoorAmbient = V.CONFIG.AmbienceColor
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

V.aimTarget = nil


RunService.RenderStepped:Connect(function()
    if not V.isAuthorized then 
        FOVCircle.Visible = false
        return 
    end
    -- FOV Update
    FOVCircle.Radius = V.CONFIG.AimbotFOV
    FOVCircle.Color = V.CONFIG.FOVColor
    FOVCircle.Visible = V.CONFIG.AimbotEnabled and V.CONFIG.ShowFOV and not V.menuOpen
    FOVCircle.Position = UIS:GetMouseLocation()

    -- No Recoil Logic
    if V.CONFIG.NoRecoilEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local currentRotation = V.Camera.CFrame.LookVector
        if V.lastCameraRotation then
            local rotationChange = currentRotation - V.lastCameraRotation
            if rotationChange.Y > 0.0001 then
                local recoilStrength = rotationChange.Y * V.CONFIG.NoRecoilStrength * 100
                if mousemoverel then
                    mousemoverel(0, recoilStrength) 
                end
            end
        end
        V.lastCameraRotation = currentRotation
    else
        V.lastCameraRotation = nil
    end

    if not V.CONFIG.AimbotEnabled then 
        V.aimTarget = nil
        return 
    end

    -- Target selection
    local bestTarget = nil
    local mousePos = UIS:GetMouseLocation()

    -- Improved Lock-on Logic (prioritize current target)
    if V.aimTarget then
        local p = V.aimTarget.Player
        local ch = p.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        
        if ch and hum and hrp and hum.Health > 0 then
            local part = ch:FindFirstChild(V.aimTarget.PartName or "Head")
            if part then
                local sPos, on = V.Camera:WorldToViewportPoint(part.Position)
                local distToMouse = (Vector2.new(sPos.X, sPos.Y) - mousePos).Magnitude
                
                -- Sticky Retention Logic: If Sticky is enabled, we NEVER drop the target unless they die, 
                -- or move outside the AimbotMaxDistance. FOV check is ignored for active target.
                local worldDistInStuds = (V.Camera.CFrame.Position - part.Position).Magnitude
                
                local isStillValid = isVis and hum.Health > 0
                local withinRange = (worldDistInStuds / 3) <= V.CONFIG.AimbotMaxDistance
                
                if isStillValid and withinRange then
                    if V.CONFIG.AimbotSticky then
                        -- Captured Target: Sticky mode ignores FOV to prevent dropping targets during fast movement
                        bestTarget = V.aimTarget
                    else
                        -- Standard logic with a slightly larger buffer (20%) for stability
                        if on and distToMouse <= (V.CONFIG.AimbotFOV * 1.2) then
                            bestTarget = V.aimTarget
                        end
                    end
                end
            end
        end
    end

    -- Find new target if no valid target is locked
    if not bestTarget then
        V.aimTarget = nil
        local minScore = math.huge
        for p, e in pairs(V.ESPObjects) do
            local ch = p.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            
            if ch and hum and hrp and hum.Health > 0 and (not V.CONFIG.TeamCheck or p.Team ~= V.LP.Team) then
                local targetPartName = V.CONFIG.AimbotTargetPart
                if targetPartName == "Random" then
                    local parts = {"Head", "UpperTorso", "LowerTorso"}
                    targetPartName = parts[math.random(1, #parts)]
                end
                
                local part = ch:FindFirstChild(targetPartName)
                if part then
                    local sPos, on = V.Camera:WorldToViewportPoint(part.Position)
                    if on then
                        local distToMouse = (Vector2.new(sPos.X, sPos.Y) - mousePos).Magnitude
                        
                        -- Simple FOV check for acquisition
                        if distToMouse <= V.CONFIG.AimbotFOV then
                            -- Visibility check
                            local isVis = true
                            if V.CONFIG.AimbotVisibleOnly then
                                if e.visCache and e.visCache[targetPartName] ~= nil then
                                    isVis = e.visCache[targetPartName]
                                else
                                    V.sharedRayParams.FilterDescendantsInstances = {V.LP.Character, ch}
                                    local res = SafeRaycast(V.Camera.CFrame.Position, part.Position, V.sharedRayParams)
                                    isVis = not res
                                end
                            end

                            if isVis then
                                local worldDist = (V.Camera.CFrame.Position - part.Position).Magnitude / 3
                                if worldDist <= V.CONFIG.AimbotMaxDistance then
                                    local score = distToMouse + (worldDist * V.CONFIG.AimbotDistanceWeight)
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
        V.aimTarget = bestTarget
        local targetPos = bestTarget.Part.Position
        
        -- Advanced Prediction Logic (Sentinel Model)
        if V.CONFIG.PredictionEnabled and bestTarget.Part then
            local velocity = bestTarget.Part.AssemblyLinearVelocity or bestTarget.Part.Velocity or Vector3.new(0, 0, 0)
            local distInStuds = (V.Camera.CFrame.Position - targetPos).Magnitude
            local distInMeters = distInStuds / 3
            
            -- Sentinel Mathematical Model:
            -- Calculate prediction based on distance in 10 meter steps up to 1000m
            -- Each 10m adds more prediction time.
            local distanceSteps = math.min(math.floor(distInMeters / 10), 100) -- Max 100 steps (1000m)
            local predictionTime = (distanceSteps / 100) * (V.CONFIG.PredictionStrength / 10)
            
            -- Apply predicted offset
            targetPos = targetPos + (velocity * predictionTime)
        end
        
        -- Update ray params to ignore V.LP
        if V.LP.Character then
            V.sharedRayParams.FilterDescendantsInstances = {V.LP.Character, ESPGui}
        end
        
        -- Aim Logic using Mouse Movement
        local sPos, on = V.Camera:WorldToViewportPoint(targetPos)
        local isStickyClose = V.CONFIG.AimbotSticky and (V.Camera.CFrame.Position - targetPos).Magnitude < 80 
        
        if on or isStickyClose then
            local mouseLocation = UIS:GetMouseLocation()
            local deltaX, deltaY
            
            if on then
                deltaX = sPos.X - mouseLocation.X
                deltaY = sPos.Y - mouseLocation.Y
            else
                -- Target passed through or is behind. Stick to them by forcing rotation!
                local localPos = V.Camera.CFrame:PointToObjectSpace(targetPos)
                -- We move the mouse strongly in the direction of the target to flip the camera
                deltaX = (localPos.X > 0 and 100 or -100) 
                deltaY = (localPos.Y > 0 and 100 or -100)
                -- We use a smaller delta but it's constant until they're back on screen
            end
            
            local smoothness = 1
            if V.CONFIG.AimbotSmoothness > 0 then
                -- When target is behind, we reduce smoothness slightly to flick faster
                local smoothFactor = on and 12 or 4
                smoothness = 1 + (V.CONFIG.AimbotSmoothness * smoothFactor)
            end
            
            if mousemoverel then
                mousemoverel(deltaX / smoothness, deltaY / smoothness)
            end
        end

        -- Character Look-at (Third Person / RootPart)
        if V.LP.Character then
            local hrp = V.LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local lookAtPos = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)
                hrp.CFrame = CFrame.new(hrp.Position, lookAtPos)
            end
        end
    else
        V.aimTarget = nil
    end
end)

-- ════════════ MISC LOGIC ════════════
local function applyJump()
    if not V.isAuthorized then return end
    local char = V.LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and V.CONFIG.HighJumpEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = V.CONFIG.HighJumpValue
        hum.JumpHeight = V.CONFIG.HighJumpValue
    end
end

RunService.Heartbeat:Connect(applyJump)

-- Force jump state when pressing space (helps in many games)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space and V.CONFIG.HighJumpEnabled then
        local hum = V.LP.Character and V.LP.Character:FindFirstChildOfClass("Humanoid")
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
    local enabled = V.isAuthorized and V.CONFIG.ScopeEnabled and not V.menuOpen
    local viewportSize = V.Camera.ViewportSize
    -- Using math.floor for pixel-perfect alignment
    local cx, cy = math.floor(viewportSize.X / 2), math.floor(viewportSize.Y / 2)
    
    local color = V.CONFIG.ScopeColor
    local gap = V.CONFIG.ScopeGap
    local length = V.CONFIG.ScopeLength
    local thickness = V.CONFIG.ScopeThickness
    
    for _, obj in pairs(Scope) do obj.Visible = false end

    if enabled then
        local function drawSegment(line, out, x1, y1, x2, y2)
            if V.CONFIG.ScopeOutline then
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
        if V.CONFIG.ScopeCenterDot then
            if V.CONFIG.ScopeOutline then
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

-- ════════════ RADAR SYSTEM ════════════
local function initRadarSystem()
    local R = {
        Window = Instance.new("CanvasGroup"),
        Header = nil,
        Container = nil,
        Blips = {}
    }
    
    R.Window.Name = "AstrumRadar"
    R.Window.Size = UDim2.new(0, V.CONFIG.RadarSize, 0, V.CONFIG.RadarSize + 30)
    R.Window.Position = UDim2.new(0, V.CONFIG.RadarPos.X, 0, V.CONFIG.RadarPos.Y)
    R.Window.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    R.Window.BorderSizePixel = 0
    R.Window.Visible = false
    R.Window.Parent = V.MenuGui
    Instance.new("UICorner", R.Window).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", R.Window).Color = Color3.fromRGB(40, 40, 50)

    R.Header = Instance.new("Frame", R.Window)
    R.Header.Size = UDim2.new(1, 0, 0, 30)
    R.Header.BackgroundTransparency = 1

    local rIcon = Instance.new("ImageLabel", R.Header)
    rIcon.Size = UDim2.new(0, 16, 0, 16)
    rIcon.Position = UDim2.new(0, 10, 0.5, -8)
    rIcon.BackgroundTransparency = 1
    rIcon.Image = "rbxassetid://6031289136"
    rIcon.ImageColor3 = Color3.fromRGB(70, 110, 255)

    local rTitle = Instance.new("TextLabel", R.Header)
    rTitle.Size = UDim2.new(1, -30, 1, 0)
    rTitle.Position = UDim2.new(0, 32, 0, 0)
    rTitle.BackgroundTransparency = 1
    rTitle.Font = Enum.Font.GothamBold
    rTitle.Text = "Radar"
    rTitle.TextColor3 = Color3.fromRGB(70, 110, 255)
    rTitle.TextSize = 13
    rTitle.TextXAlignment = Enum.TextXAlignment.Left

    R.Container = Instance.new("Frame", R.Window)
    R.Container.Size = UDim2.new(1, -10, 1, -40)
    R.Container.Position = UDim2.new(0, 5, 0, 35)
    R.Container.BackgroundTransparency = 1
    R.Container.ClipsDescendants = true

    -- Grid drawing
    local function createGridLine()
        local f = Instance.new("Frame", R.Container)
        f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        f.BackgroundTransparency = 0.95
        f.BorderSizePixel = 0
        return f
    end

    local function createGridCircle()
        local f = Instance.new("Frame", R.Container)
        f.BackgroundTransparency = 1
        local s = Instance.new("UIStroke", f)
        s.Color = Color3.fromRGB(255, 255, 255)
        s.Transparency = 0.95
        Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
        return f
    end

    local gc = Instance.new("Frame", R.Container)
    gc.Size = UDim2.new(0, 4, 0, 4)
    gc.Position = UDim2.new(0.5, -2, 0.5, -2)
    gc.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", gc).CornerRadius = UDim.new(1, 0)

    for i = 1, 3 do
        local c = createGridCircle()
        local size = (i/3) * 0.95
        c.Size = UDim2.new(size, 0, size * (V.CONFIG.RadarSize / (V.CONFIG.RadarSize - 10)), 0)
        c.Position = UDim2.new(0.5 - size/2, 0, 0.5 - (size * (V.CONFIG.RadarSize / (V.CONFIG.RadarSize - 10)))/2, 0)
    end

    local vl = createGridLine()
    vl.Size = UDim2.new(0, 1, 1, 0)
    vl.Position = UDim2.new(0.5, 0, 0, 0)

    local hl = createGridLine()
    hl.Size = UDim2.new(1, 0, 0, 1)
    hl.Position = UDim2.new(0, 0, 0.5, 0)

    local function createLabel(txt, pos)
        local l = Instance.new("TextLabel", R.Container)
        l.Size = UDim2.new(0, 20, 0, 20)
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(150, 150, 160)
        l.TextSize = 12
        return l
    end

    createLabel("N", UDim2.new(0.5, -10, 0, 2))
    createLabel("S", UDim2.new(0.5, -10, 1, -22))
    createLabel("W", UDim2.new(0, 2, 0.5, -10))
    createLabel("E", UDim2.new(1, -22, 0.5, -10))

    local function getBlip(player)
        if R.Blips[player] then return R.Blips[player] end
        local bBase = Instance.new("Frame", R.Container)
        bBase.Size = UDim2.new(0, 8, 0, 8)
        bBase.AnchorPoint = Vector2.new(0.5, 0.5)
        bBase.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        bBase.BorderSizePixel = 0
        bBase.ZIndex = 10
        Instance.new("UICorner", bBase).CornerRadius = UDim.new(1, 0)
        
        local s = Instance.new("UIStroke", bBase)
        s.Thickness = 1
        s.Color = Color3.new(1,1,1)
        
        R.Blips[player] = {Base = bBase, Stroke = s}
        return R.Blips[player]
    end

    RunService.RenderStepped:Connect(function()
        R.Window.Visible = V.CONFIG.RadarEnabled and V.isAuthorized
        if not V.CONFIG.RadarEnabled or not V.isAuthorized then return end
        R.Window.Size = UDim2.new(0, V.CONFIG.RadarSize, 0, V.CONFIG.RadarSize + 30)
        
        local lpChar = V.LP.Character
        local lHRP = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
        if not lHRP then return end
        
        local rangeS = V.CONFIG.RadarRadius * 3
        local camCF = V.Camera.CFrame
        
        for _, b in pairs(R.Blips) do b.Base.Visible = false end
        
        for _, p in pairs(Players:GetPlayers()) do
            if p == V.LP then continue end
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if hrp and hum and hum.Health > 0 then
                local b = getBlip(p)
                -- Get relative position to camera
                local rel = camCF:PointToObjectSpace(hrp.Position)
                
                -- rel.X is right/left, rel.Z is forward/back (-Z is forward)
                local rX = rel.X
                local rZ = rel.Z 
                
                local fact = (R.Container.AbsoluteSize.X / 2) / rangeS
                local x, y = rX * fact, rZ * fact -- y is now Z (forward)
                
                local curD = math.sqrt(x^2 + y^2)
                local maxR = (R.Container.AbsoluteSize.X / 2) - 6
                
                if curD > maxR then
                    local ang = math.atan2(y, x)
                    x, y = math.cos(ang) * maxR, math.sin(ang) * maxR
                end
                
                -- Position: y (Z in world) mapped to UI Y
                b.Base.Position = UDim2.new(0.5, x, 0.5, y)
                b.Base.Visible = true
                
                if V.CONFIG.TeamCheck then
                    b.Base.BackgroundColor3 = (p.Team == V.LP.Team) and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
                else
                    b.Base.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                end
            end
        end
    end)

    V.radarDragging = false
    V.radarDragStart = nil
    V.radarStartPos = nil

    R.Window.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            V.radarDragging = true
            V.radarDragStart = i.Position
            V.radarStartPos = R.Window.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if V.radarDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local del = i.Position - V.radarDragStart
            local nPos = UDim2.new(V.radarStartPos.X.Scale, V.radarStartPos.X.Offset + del.X, V.radarStartPos.Y.Scale, V.radarStartPos.Y.Offset + del.Y)
            R.Window.Position = nPos
            V.CONFIG.RadarPos = Vector2.new(nPos.X.Offset, nPos.Y.Offset)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then V.radarDragging = false end
    end)
end

initRadarSystem()
RefreshUI()
refreshCfgList()

-- Global Time Update Loop + Auto Sync
task.spawn(function()
    while true do
        if V.isAuthorized and V.timeLbl and V.authSessionDuration then
            local elapsed = os.time() - V.authSessionStart
            local left = 0
            
            if V.authSessionDuration == -1 then
                V.timeLbl.Text = "Time: Lifetime"
            else
                left = V.authSessionDuration - elapsed
                V.timeLbl.Text = "Time: " .. (left > 0 and formatTime(left) or "Expired")
            end
            
            -- Periodic sync with server (every 2.5 minutes)
            if os.time() - V.lastAuthSync > 150 then
                V.lastAuthSync = os.time()
                task.spawn(function()
                    local ok, newDur = V.checkKeyOnServer(V.lastUsedKey)
                    if ok then
                        V.authSessionDuration = newDur
                    elseif newDur == "Key not found." or newDur == "Wrong nickname / user." then
                        V.expireSession()
                    end
                end)
            end

            if V.authSessionDuration ~= -1 and left <= 0 then
                V.expireSession()
            end
        end
        task.wait(1)
    end
end)

-- Auto-login check (Skip registration if profile exists)
task.spawn(function()
    local authPath = V.folderName .. "/auth.json"
    if isfile and isfile(authPath) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(authPath)) 
        end)
        if success and data and data.Nick then
            V.RegisterPanel.Visible = false
            V.LoginPanel.Visible = true
            V.regInput.Text = data.Nick
            V.userLbl.Text = "User: " .. data.Nick
            
            -- Если сохранён ключ — автозаполняем и пробуем автологин
            if data.Key and data.Key ~= "" then
                V.keyInput.Text = data.Key
                V.statusLbl.Text = "Auto-logging in..."
                V.statusLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
                task.wait(0.5)
                verifyKey(data.Key)
            else
                V.statusLbl.Text = "Welcome back! Please enter your key."
                V.statusLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
            end
        end
    end
end)
