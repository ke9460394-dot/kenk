--[[
    ████████████████████████████████████████████████████████████████
    █                                                              █
    █   ██████╗ ██╗██╗  ██╗███████╗██╗      ██████╗██████╗  █████╗ █
    █   ██╔══██╗██║╚██╗██╔╝██╔════╝██║     ██╔════╝██╔══██╗██╔══██╗█
    █   ██████╔╝██║ ╚███╔╝ █████╗  ██║     ██║     ██████╔╝███████║█
    █   ██╔═══╝ ██║ ██╔██╗ ██╔══╝  ██║     ██║     ██╔══██╗██╔══██║█
    █   ██║     ██║██╔╝ ██╗███████╗███████╗╚██████╗██║  ██║██║  ██║█
    █   ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝█
    █                                                              █
    █          MINECRAFT STYLE UI LIBRARY FOR ROBLOX               █
    █                    Version 2.0.0                             █
    █                                                              █
    ████████████████████████████████████████████████████████████████
    
    特性:
    • 8x8/16x16 像素网格系统
    • 硬边缘无抗锯齿渲染
    • Minecraft 原版配色方案
    • CRT 复古显示效果
    • 完整组件库 (按钮/滑块/复选框/输入框/下拉菜单/标签页等)
    • 像素完美字体渲染
    • 音效反馈系统
    • 窗口拖拽系统
    • 通知系统
--]]

local PixelCraft = {}
PixelCraft.__index = PixelCraft
PixelCraft.Version = "2.0.0"

--============================================================================--
--                              核心服务                                       --
--============================================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

--============================================================================--
--                         MINECRAFT 配色方案                                  --
--============================================================================--

PixelCraft.Colors = {
    -- 主要界面颜色 (直接从 Minecraft 取色)
    Background = Color3.fromRGB(0, 0, 0),                    -- 纯黑背景
    BackgroundDark = Color3.fromRGB(16, 16, 16),             -- 深色背景
    BackgroundLight = Color3.fromRGB(32, 32, 32),            -- 浅色背景
    
    -- 容器颜色 (物品栏风格)
    ContainerBg = Color3.fromRGB(139, 139, 139),             -- 容器背景灰
    ContainerBorder = Color3.fromRGB(55, 55, 55),            -- 容器边框深灰
    ContainerHighlight = Color3.fromRGB(255, 255, 255),      -- 容器高亮白
    ContainerShadow = Color3.fromRGB(85, 85, 85),            -- 容器阴影
    
    -- 按钮颜色 (Minecraft 按钮精确配色)
    ButtonNormal = Color3.fromRGB(128, 128, 128),            -- 按钮正常
    ButtonHover = Color3.fromRGB(160, 160, 160),             -- 按钮悬停
    ButtonPressed = Color3.fromRGB(96, 96, 96),              -- 按钮按下
    ButtonDisabled = Color3.fromRGB(64, 64, 64),             -- 按钮禁用
    ButtonBorderLight = Color3.fromRGB(200, 200, 200),       -- 按钮亮边
    ButtonBorderDark = Color3.fromRGB(60, 60, 60),           -- 按钮暗边
    
    -- 文本颜色
    TextPrimary = Color3.fromRGB(255, 255, 255),             -- 主要文本白
    TextSecondary = Color3.fromRGB(170, 170, 170),           -- 次要文本灰
    TextDisabled = Color3.fromRGB(100, 100, 100),            -- 禁用文本
    TextShadow = Color3.fromRGB(63, 63, 63),                 -- 文本阴影
    TextTitle = Color3.fromRGB(255, 255, 85),                -- 标题黄
    
    -- Minecraft 特殊颜色
    Gold = Color3.fromRGB(255, 170, 0),                      -- 金色
    Diamond = Color3.fromRGB(85, 255, 255),                  -- 钻石蓝
    Emerald = Color3.fromRGB(85, 255, 85),                   -- 绿宝石绿
    Redstone = Color3.fromRGB(255, 85, 85),                  -- 红石红
    Lapis = Color3.fromRGB(85, 85, 255),                     -- 青金石蓝
    
    -- 状态颜色
    Success = Color3.fromRGB(85, 255, 85),                   -- 成功绿
    Warning = Color3.fromRGB(255, 255, 85),                  -- 警告黄
    Error = Color3.fromRGB(255, 85, 85),                     -- 错误红
    Info = Color3.fromRGB(85, 85, 255),                      -- 信息蓝
    
    -- 特效颜色
    Highlight = Color3.fromRGB(255, 255, 160),               -- 高亮
    Selection = Color3.fromRGB(128, 128, 255),               -- 选中
    
    -- 物品槽颜色
    SlotNormal = Color3.fromRGB(139, 139, 139),              -- 普通槽位
    SlotEmpty = Color3.fromRGB(55, 55, 55),                  -- 空槽位
    SlotHover = Color3.fromRGB(180, 180, 180),               -- 悬停槽位
    
    -- 进度条颜色
    ProgressBg = Color3.fromRGB(32, 32, 32),                 -- 进度条背景
    ProgressFill = Color3.fromRGB(85, 255, 85),              -- 进度条填充
    ProgressXP = Color3.fromRGB(128, 255, 32),               -- 经验条绿
    
    -- 滚动条
    ScrollBg = Color3.fromRGB(48, 48, 48),                   -- 滚动条背景
    ScrollHandle = Color3.fromRGB(128, 128, 128),            -- 滚动条把手
    ScrollHandleHover = Color3.fromRGB(160, 160, 160),       -- 滚动条悬停
}

--============================================================================--
--                            像素网格配置                                     --
--============================================================================--

PixelCraft.Config = {
    PixelSize = 2,                                           -- 基础像素大小
    GridSize = 8,                                            -- 8x8 网格
    LargeGridSize = 16,                                      -- 16x16 网格
    
    -- 字体配置
    FontSize = 16,                                           -- 基础字体大小
    FontSizeLarge = 24,                                      -- 大字体
    FontSizeSmall = 12,                                      -- 小字体
    
    -- 动画配置
    AnimationSpeed = 0.1,                                    -- 动画速度
    HoverScale = 1.02,                                       -- 悬停缩放
    
    -- 间距配置
    Padding = 8,                                             -- 内边距
    Margin = 4,                                              -- 外边距
    BorderWidth = 2,                                         -- 边框宽度
    
    -- CRT 效果
    EnableCRT = true,                                        -- 启用CRT效果
    ScanlineOpacity = 0.03,                                  -- 扫描线透明度
    EnableNoise = true,                                      -- 启用噪点
    NoiseOpacity = 0.02,                                     -- 噪点透明度
}

--============================================================================--
--                              工具函数                                       --
--============================================================================--

local Utils = {}

-- 对齐到像素网格
function Utils.SnapToGrid(value, gridSize)
    gridSize = gridSize or PixelCraft.Config.GridSize
    return math.floor(value / gridSize + 0.5) * gridSize
end

-- 创建像素完美的圆角 (实际上是无圆角)
function Utils.CreatePixelCorner()
    return UDim.new(0, 0)
end

-- 创建 3D 边框效果 (Minecraft 风格)
function Utils.Create3DBorder(parent, lightColor, darkColor, thickness)
    thickness = thickness or 2
    lightColor = lightColor or PixelCraft.Colors.ButtonBorderLight
    darkColor = darkColor or PixelCraft.Colors.ButtonBorderDark
    
    local borders = {}
    
    -- 顶部亮边
    local topLight = Instance.new("Frame")
    topLight.Name = "TopLight"
    topLight.Size = UDim2.new(1, 0, 0, thickness)
    topLight.Position = UDim2.new(0, 0, 0, 0)
    topLight.BackgroundColor3 = lightColor
    topLight.BorderSizePixel = 0
    topLight.ZIndex = parent.ZIndex + 1
    topLight.Parent = parent
    table.insert(borders, topLight)
    
    -- 左侧亮边
    local leftLight = Instance.new("Frame")
    leftLight.Name = "LeftLight"
    leftLight.Size = UDim2.new(0, thickness, 1, 0)
    leftLight.Position = UDim2.new(0, 0, 0, 0)
    leftLight.BackgroundColor3 = lightColor
    leftLight.BorderSizePixel = 0
    leftLight.ZIndex = parent.ZIndex + 1
    leftLight.Parent = parent
    table.insert(borders, leftLight)
    
    -- 底部暗边
    local bottomDark = Instance.new("Frame")
    bottomDark.Name = "BottomDark"
    bottomDark.Size = UDim2.new(1, 0, 0, thickness)
    bottomDark.Position = UDim2.new(0, 0, 1, -thickness)
    bottomDark.BackgroundColor3 = darkColor
    bottomDark.BorderSizePixel = 0
    bottomDark.ZIndex = parent.ZIndex + 1
    bottomDark.Parent = parent
    table.insert(borders, bottomDark)
    
    -- 右侧暗边
    local rightDark = Instance.new("Frame")
    rightDark.Name = "RightDark"
    rightDark.Size = UDim2.new(0, thickness, 1, 0)
    rightDark.Position = UDim2.new(1, -thickness, 0, 0)
    rightDark.BackgroundColor3 = darkColor
    rightDark.BorderSizePixel = 0
    rightDark.ZIndex = parent.ZIndex + 1
    rightDark.Parent = parent
    table.insert(borders, rightDark)
    
    return borders
end

-- 创建反向 3D 边框 (按下状态)
function Utils.CreateInverse3DBorder(parent, lightColor, darkColor, thickness)
    return Utils.Create3DBorder(parent, darkColor, lightColor, thickness)
end

-- 创建带阴影的文本
function Utils.CreateShadowText(parent, text, textColor, shadowColor, offset)
    offset = offset or 2
    textColor = textColor or PixelCraft.Colors.TextPrimary
    shadowColor = shadowColor or PixelCraft.Colors.TextShadow
    
    -- 阴影文本
    local shadow = Instance.new("TextLabel")
    shadow.Name = "TextShadow"
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, offset, 0, offset)
    shadow.BackgroundTransparency = 1
    shadow.Text = text
    shadow.TextColor3 = shadowColor
    shadow.Font = Enum.Font.Code
    shadow.TextSize = PixelCraft.Config.FontSize
    shadow.TextXAlignment = Enum.TextXAlignment.Center
    shadow.TextYAlignment = Enum.TextYAlignment.Center
    shadow.ZIndex = parent.ZIndex
    shadow.Parent = parent
    
    -- 主文本
    local mainText = Instance.new("TextLabel")
    mainText.Name = "TextMain"
    mainText.Size = UDim2.new(1, 0, 1, 0)
    mainText.Position = UDim2.new(0, 0, 0, 0)
    mainText.BackgroundTransparency = 1
    mainText.Text = text
    mainText.TextColor3 = textColor
    mainText.Font = Enum.Font.Code
    mainText.TextSize = PixelCraft.Config.FontSize
    mainText.TextXAlignment = Enum.TextXAlignment.Center
    mainText.TextYAlignment = Enum.TextYAlignment.Center
    mainText.ZIndex = parent.ZIndex + 1
    mainText.Parent = parent
    
    return {Main = mainText, Shadow = shadow}
end

-- 创建像素化纹理 (模拟 Minecraft 材质)
function Utils.CreatePixelTexture(parent, pattern, scale)
    scale = scale or 1
    local texture = Instance.new("Frame")
    texture.Name = "PixelTexture"
    texture.Size = UDim2.new(1, 0, 1, 0)
    texture.BackgroundTransparency = 1
    texture.ZIndex = parent.ZIndex + 1
    texture.Parent = parent
    
    -- 创建像素图案
    local pixelSize = 4 * scale
    for y = 0, math.floor(parent.AbsoluteSize.Y / pixelSize) do
        for x = 0, math.floor(parent.AbsoluteSize.X / pixelSize) do
            if pattern == "noise" and math.random() > 0.7 then
                local pixel = Instance.new("Frame")
                pixel.Size = UDim2.new(0, pixelSize, 0, pixelSize)
                pixel.Position = UDim2.new(0, x * pixelSize, 0, y * pixelSize)
                pixel.BackgroundColor3 = Color3.fromRGB(
                    math.random(0, 30),
                    math.random(0, 30),
                    math.random(0, 30)
                )
                pixel.BackgroundTransparency = 0.8
                pixel.BorderSizePixel = 0
                pixel.ZIndex = texture.ZIndex
                pixel.Parent = texture
            end
        end
    end
    
    return texture
end

-- 深拷贝表
function Utils.DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = Utils.DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- 合并表
function Utils.Merge(base, override)
    local result = Utils.DeepCopy(base)
    for k, v in pairs(override or {}) do
        if type(v) == "table" and type(result[k]) == "table" then
            result[k] = Utils.Merge(result[k], v)
        else
            result[k] = v
        end
    end
    return result
end

-- 生成唯一ID
local idCounter = 0
function Utils.GenerateId()
    idCounter = idCounter + 1
    return "PixelCraft_" .. tostring(idCounter) .. "_" .. tostring(tick())
end

PixelCraft.Utils = Utils

--============================================================================--
--                            CRT 效果系统                                     --
--============================================================================--

local CRTEffect = {}

function CRTEffect.Create(parent)
    if not PixelCraft.Config.EnableCRT then return end
    
    local crtContainer = Instance.new("Frame")
    crtContainer.Name = "CRTEffect"
    crtContainer.Size = UDim2.new(1, 0, 1, 0)
    crtContainer.BackgroundTransparency = 1
    crtContainer.ZIndex = 999
    crtContainer.Parent = parent
    
    -- 扫描线效果
    local scanlines = Instance.new("Frame")
    scanlines.Name = "Scanlines"
    scanlines.Size = UDim2.new(1, 0, 1, 0)
    scanlines.BackgroundTransparency = 1
    scanlines.ZIndex = 999
    scanlines.Parent = crtContainer
    
    -- 创建扫描线
    for i = 0, 200 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 0, i * 2)
        line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        line.BackgroundTransparency = 1 - PixelCraft.Config.ScanlineOpacity
        line.BorderSizePixel = 0
        line.ZIndex = 999
        line.Parent = scanlines
    end
    
    -- 边缘暗角
    local vignette = Instance.new("ImageLabel")
    vignette.Name = "Vignette"
    vignette.Size = UDim2.new(1, 0, 1, 0)
    vignette.BackgroundTransparency = 1
    vignette.ImageTransparency = 0.7
    vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
    vignette.ZIndex = 998
    vignette.Parent = crtContainer
    
    -- 轻微的绿色色调 (CRT 特征)
    local tint = Instance.new("Frame")
    tint.Name = "CRTTint"
    tint.Size = UDim2.new(1, 0, 1, 0)
    tint.BackgroundColor3 = Color3.fromRGB(0, 20, 0)
    tint.BackgroundTransparency = 0.97
    tint.ZIndex = 997
    tint.Parent = crtContainer
    
    return crtContainer
end

PixelCraft.CRTEffect = CRTEffect

--============================================================================--
--                             核心 UI 类                                      --
--============================================================================--

-- 基础组件类
local Component = {}
Component.__index = Component

function Component.new(componentType)
    local self = setmetatable({}, Component)
    self.Type = componentType
    self.Id = Utils.GenerateId()
    self.Instance = nil
    self.Connections = {}
    self.Children = {}
    self.Visible = true
    self.Enabled = true
    return self
end

function Component:Destroy()
    for _, conn in pairs(self.Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    for _, child in pairs(self.Children) do
        if child.Destroy then
            child:Destroy()
        end
    end
    if self.Instance then
        self.Instance:Destroy()
    end
end

function Component:SetVisible(visible)
    self.Visible = visible
    if self.Instance then
        self.Instance.Visible = visible
    end
end

function Component:SetEnabled(enabled)
    self.Enabled = enabled
end

function Component:AddConnection(connection)
    table.insert(self.Connections, connection)
end

PixelCraft.Component = Component

--============================================================================--
--                              主窗口类                                       --
--============================================================================--

local Window = setmetatable({}, {__index = Component})
Window.__index = Window

function Window.new(options)
    local self = setmetatable(Component.new("Window"), Window)
    
    options = Utils.Merge({
        Title = "PixelCraft Window",
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150),
        Draggable = true,
        Closable = true,
        Minimizable = true,
        Theme = "dark",
        Parent = nil,
    }, options)
    
    self.Options = options
    self.Minimized = false
    self.Tabs = {}
    self.ActiveTab = nil
    self.Notifications = {}
    
    self:Create()
    return self
end

function Window:Create()
    -- 尝试获取父级
    local parent = self.Options.Parent
    if not parent then
        local success, result = pcall(function()
            return CoreGui
        end)
        if success then
            parent = result
        else
            parent = Player:WaitForChild("PlayerGui")
        end
    end
    
    -- 创建 ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "PixelCraft_" .. self.Id
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = parent
    
    -- 主窗口容器
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = self.Options.Size
    self.MainFrame.Position = self.Options.Position
    self.MainFrame.BackgroundColor3 = PixelCraft.Colors.ContainerBg
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    self.Instance = self.MainFrame
    
    -- 创建 Minecraft 风格边框
    self:CreateMinecraftBorder()
    
    -- 创建标题栏
    self:CreateTitleBar()
    
    -- 创建内容区域
    self:CreateContentArea()
    
    -- 创建标签页容器
    self:CreateTabContainer()
    
    -- 添加 CRT 效果
    if PixelCraft.Config.EnableCRT then
        CRTEffect.Create(self.MainFrame)
    end
    
    -- 添加拖拽功能
    if self.Options.Draggable then
        self:EnableDragging()
    end
end

function Window:CreateMinecraftBorder()
    local borderWidth = 4
    
    -- 外边框 (深色)
    local outerBorder = Instance.new("Frame")
    outerBorder.Name = "OuterBorder"
    outerBorder.Size = UDim2.new(1, 8, 1, 8)
    outerBorder.Position = UDim2.new(0, -4, 0, -4)
    outerBorder.BackgroundColor3 = PixelCraft.Colors.ContainerBorder
    outerBorder.BorderSizePixel = 0
    outerBorder.ZIndex = self.MainFrame.ZIndex - 1
    outerBorder.Parent = self.MainFrame
    
    -- 3D 效果边框
    Utils.Create3DBorder(self.MainFrame, 
        PixelCraft.Colors.ContainerHighlight,
        PixelCraft.Colors.ContainerShadow,
        2
    )
    
    -- 内边框线
    local innerBorder = Instance.new("Frame")
    innerBorder.Name = "InnerBorder"
    innerBorder.Size = UDim2.new(1, -8, 1, -8)
    innerBorder.Position = UDim2.new(0, 4, 0, 4)
    innerBorder.BackgroundTransparency = 1
    innerBorder.BorderSizePixel = 0
    innerBorder.ZIndex = self.MainFrame.ZIndex + 1
    innerBorder.Parent = self.MainFrame
    
    -- 角落装饰 (Minecraft 风格)
    local corners = {"TopLeft", "TopRight", "BottomLeft", "BottomRight"}
    for _, corner in ipairs(corners) do
        local cornerPixel = Instance.new("Frame")
        cornerPixel.Name = corner .. "Corner"
        cornerPixel.Size = UDim2.new(0, 4, 0, 4)
        cornerPixel.BackgroundColor3 = PixelCraft.Colors.ContainerBorder
        cornerPixel.BorderSizePixel = 0
        cornerPixel.ZIndex = self.MainFrame.ZIndex + 2
        
        if corner == "TopLeft" then
            cornerPixel.Position = UDim2.new(0, 0, 0, 0)
        elseif corner == "TopRight" then
            cornerPixel.Position = UDim2.new(1, -4, 0, 0)
        elseif corner == "BottomLeft" then
            cornerPixel.Position = UDim2.new(0, 0, 1, -4)
        elseif corner == "BottomRight" then
            cornerPixel.Position = UDim2.new(1, -4, 1, -4)
        end
        
        cornerPixel.Parent = self.MainFrame
    end
end

function Window:CreateTitleBar()
    -- 标题栏容器
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, -8, 0, 32)
    self.TitleBar.Position = UDim2.new(0, 4, 0, 4)
    self.TitleBar.BackgroundColor3 = PixelCraft.Colors.BackgroundDark
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.ZIndex = self.MainFrame.ZIndex + 5
    self.TitleBar.Parent = self.MainFrame
    
    -- 标题栏 3D 边框
    Utils.Create3DBorder(self.TitleBar, 
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
    
    -- 标题图标 (像素方块)
    local iconContainer = Instance.new("Frame")
    iconContainer.Name = "IconContainer"
    iconContainer.Size = UDim2.new(0, 24, 0, 24)
    iconContainer.Position = UDim2.new(0, 6, 0.5, -12)
    iconContainer.BackgroundTransparency = 1
    iconContainer.ZIndex = self.TitleBar.ZIndex + 1
    iconContainer.Parent = self.TitleBar
    
    -- 创建像素化图标 (草方块风格)
    self:CreatePixelIcon(iconContainer)
    
    -- 标题文本
    local titleTextContainer = Instance.new("Frame")
    titleTextContainer.Name = "TitleTextContainer"
    titleTextContainer.Size = UDim2.new(1, -100, 1, -4)
    titleTextContainer.Position = UDim2.new(0, 36, 0, 2)
    titleTextContainer.BackgroundTransparency = 1
    titleTextContainer.ZIndex = self.TitleBar.ZIndex + 1
    titleTextContainer.Parent = self.TitleBar
    
    self.TitleText = Utils.CreateShadowText(
        titleTextContainer,
        self.Options.Title,
        PixelCraft.Colors.TextTitle,
        PixelCraft.Colors.TextShadow,
        2
    )
    self.TitleText.Main.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 控制按钮容器
    local controlsContainer = Instance.new("Frame")
    controlsContainer.Name = "Controls"
    controlsContainer.Size = UDim2.new(0, 60, 0, 24)
    controlsContainer.Position = UDim2.new(1, -66, 0.5, -12)
    controlsContainer.BackgroundTransparency = 1
    controlsContainer.ZIndex = self.TitleBar.ZIndex + 1
    controlsContainer.Parent = self.TitleBar
    
-- 继续上面的代码...

    -- 最小化按钮
    if self.Options.Minimizable then
        self.MinimizeBtn = self:CreateControlButton(controlsContainer, "_", UDim2.new(0, 0, 0, 0), function()
            self:ToggleMinimize()
        end)
    end
    
    -- 关闭按钮
    if self.Options.Closable then
        self.CloseBtn = self:CreateControlButton(controlsContainer, "X", UDim2.new(0, 28, 0, 0), function()
            self:Close()
        end, PixelCraft.Colors.Redstone)
    end
end

function Window:CreateControlButton(parent, text, position, callback, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Name = text .. "Button"
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.Position = position
    btn.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = parent.ZIndex + 1
    btn.Parent = parent
    
    -- 3D 边框
    local borders = Utils.Create3DBorder(btn, 
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    
    -- 按钮文字
    local textLabels = Utils.CreateShadowText(btn, text, PixelCraft.Colors.TextPrimary)
    textLabels.Main.TextSize = 14
    textLabels.Shadow.TextSize = 14
    
    -- 交互效果
    local normalColor = PixelCraft.Colors.ButtonNormal
    local hColor = hoverColor or PixelCraft.Colors.ButtonHover
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = hColor
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = normalColor
    end)
    
    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = PixelCraft.Colors.ButtonPressed
        -- 反转边框 (按下效果)
        for _, border in ipairs(borders) do
            if border.Name == "TopLight" or border.Name == "LeftLight" then
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderDark
            else
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderLight
            end
        end
    end)
    
    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = hColor
        -- 恢复边框
        for _, border in ipairs(borders) do
            if border.Name == "TopLight" or border.Name == "LeftLight" then
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderLight
            else
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderDark
            end
        end
        if callback then callback() end
    end)
    
    return btn
end

function Window:CreatePixelIcon(parent)
    -- 创建 8x8 像素草方块图标
    local pixelSize = 3
    local grassColors = {
        -- 顶部草地 (绿色)
        {Color3.fromRGB(89, 176, 60), Color3.fromRGB(106, 189, 74), Color3.fromRGB(89, 176, 60), Color3.fromRGB(74, 153, 50), Color3.fromRGB(89, 176, 60), Color3.fromRGB(106, 189, 74), Color3.fromRGB(89, 176, 60), Color3.fromRGB(74, 153, 50)},
        {Color3.fromRGB(106, 189, 74), Color3.fromRGB(89, 176, 60), Color3.fromRGB(74, 153, 50), Color3.fromRGB(89, 176, 60), Color3.fromRGB(106, 189, 74), Color3.fromRGB(89, 176, 60), Color3.fromRGB(74, 153, 50), Color3.fromRGB(89, 176, 60)},
        -- 过渡层
        {Color3.fromRGB(89, 176, 60), Color3.fromRGB(134, 96, 67), Color3.fromRGB(89, 176, 60), Color3.fromRGB(134, 96, 67), Color3.fromRGB(74, 153, 50), Color3.fromRGB(134, 96, 67), Color3.fromRGB(89, 176, 60), Color3.fromRGB(134, 96, 67)},
        -- 泥土层 (棕色)
        {Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50), Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50)},
        {Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50), Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50), Color3.fromRGB(134, 96, 67)},
        {Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50), Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50), Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58)},
        {Color3.fromRGB(109, 76, 50), Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50), Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67)},
        {Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50), Color3.fromRGB(134, 96, 67), Color3.fromRGB(121, 85, 58), Color3.fromRGB(134, 96, 67), Color3.fromRGB(109, 76, 50)},
    }
    
    for y = 1, 8 do
        for x = 1, 8 do
            local pixel = Instance.new("Frame")
            pixel.Name = "Pixel_" .. x .. "_" .. y
            pixel.Size = UDim2.new(0, pixelSize, 0, pixelSize)
            pixel.Position = UDim2.new(0, (x-1) * pixelSize, 0, (y-1) * pixelSize)
            pixel.BackgroundColor3 = grassColors[y][x]
            pixel.BorderSizePixel = 0
            pixel.ZIndex = parent.ZIndex + 1
            pixel.Parent = parent
        end
    end
end

function Window:CreateContentArea()
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, -16, 1, -56)
    self.ContentArea.Position = UDim2.new(0, 8, 0, 44)
    self.ContentArea.BackgroundColor3 = PixelCraft.Colors.BackgroundDark
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.ZIndex = self.MainFrame.ZIndex + 3
    self.ContentArea.ClipsDescendants = true
    self.ContentArea.Parent = self.MainFrame
    
    -- 内容区域内边框
    Utils.Create3DBorder(self.ContentArea,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
end

function Window:CreateTabContainer()
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 120, 1, -8)
    self.TabBar.Position = UDim2.new(0, 4, 0, 4)
    self.TabBar.BackgroundColor3 = PixelCraft.Colors.BackgroundLight
    self.TabBar.BorderSizePixel = 0
    self.TabBar.ZIndex = self.ContentArea.ZIndex + 1
    self.TabBar.Parent = self.ContentArea
    
    -- 标签栏边框
    Utils.Create3DBorder(self.TabBar,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
    
    -- 标签列表布局
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = self.TabBar
    
    -- 标签列表内边距
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 6)
    tabPadding.PaddingLeft = UDim.new(0, 4)
    tabPadding.PaddingRight = UDim.new(0, 4)
    tabPadding.Parent = self.TabBar
    
    -- 标签内容区域
    self.TabContent = Instance.new("Frame")
    self.TabContent.Name = "TabContent"
    self.TabContent.Size = UDim2.new(1, -136, 1, -8)
    self.TabContent.Position = UDim2.new(0, 132, 0, 4)
    self.TabContent.BackgroundColor3 = PixelCraft.Colors.BackgroundLight
    self.TabContent.BorderSizePixel = 0
    self.TabContent.ZIndex = self.ContentArea.ZIndex + 1
    self.TabContent.ClipsDescendants = true
    self.TabContent.Parent = self.ContentArea
    
    Utils.Create3DBorder(self.TabContent,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
end

function Window:EnableDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self:AddConnection(self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end))
    
    self:AddConnection(self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    
    self:AddConnection(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            -- 对齐到像素网格
            local newX = Utils.SnapToGrid(startPos.X.Offset + delta.X, 2)
            local newY = Utils.SnapToGrid(startPos.Y.Offset + delta.Y, 2)
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end))
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        self.ContentArea.Visible = false
        self.MainFrame.Size = UDim2.new(0, self.Options.Size.X.Offset, 0, 44)
    else
        self.ContentArea.Visible = true
        self.MainFrame.Size = self.Options.Size
    end
end

function Window:Close()
    self:Destroy()
end

function Window:SetTitle(title)
    self.Options.Title = title
    if self.TitleText then
        self.TitleText.Main.Text = title
        self.TitleText.Shadow.Text = title
    end
end

--============================================================================--
--                              标签页类                                       --
--============================================================================--

function Window:AddTab(options)
    options = Utils.Merge({
        Name = "Tab",
        Icon = nil,
        LayoutOrder = #self.Tabs + 1
    }, options)
    
    local tab = {
        Name = options.Name,
        Components = {},
        Button = nil,
        Content = nil,
        Active = false
    }
    
    -- 创建标签按钮
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = options.Name .. "Tab"
    tab.Button.Size = UDim2.new(1, 0, 0, 28)
    tab.Button.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = ""
    tab.Button.LayoutOrder = options.LayoutOrder
    tab.Button.ZIndex = self.TabBar.ZIndex + 1
    tab.Button.Parent = self.TabBar
    
    -- 标签按钮边框
    local tabBorders = Utils.Create3DBorder(tab.Button,
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    tab.Borders = tabBorders
    
    -- 标签文字
    tab.TextLabels = Utils.CreateShadowText(tab.Button, options.Name, PixelCraft.Colors.TextPrimary)
    tab.TextLabels.Main.TextSize = 12
    tab.TextLabels.Shadow.TextSize = 12
    
    -- 创建标签内容页
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = options.Name .. "Content"
    tab.Content.Size = UDim2.new(1, -8, 1, -8)
    tab.Content.Position = UDim2.new(0, 4, 0, 4)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 8
    tab.Content.ScrollBarImageColor3 = PixelCraft.Colors.ScrollHandle
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    tab.Content.ZIndex = self.TabContent.ZIndex + 1
    tab.Content.Parent = self.TabContent
    
    -- 内容布局
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tab.Content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 4)
    contentPadding.PaddingLeft = UDim.new(0, 4)
    contentPadding.PaddingRight = UDim.new(0, 4)
    contentPadding.Parent = tab.Content
    
    -- 自动调整 CanvasSize
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- 标签按钮交互
    tab.Button.MouseEnter:Connect(function()
        if not tab.Active then
            tab.Button.BackgroundColor3 = PixelCraft.Colors.ButtonHover
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if not tab.Active then
            tab.Button.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
        end
    end)
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    -- 如果是第一个标签，自动选中
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    -- 返回标签页对象，支持链式调用添加组件
    local tabAPI = {}
    setmetatable(tabAPI, {__index = function(_, key)
        return function(_, ...)
            return self["Add" .. key](self, tab, ...)
        end
    end})
    
    -- 添加常用方法
    function tabAPI:AddButton(options) return self:Button(options) end
    function tabAPI:AddToggle(options) return self:Toggle(options) end
    function tabAPI:AddSlider(options) return self:Slider(options) end
    function tabAPI:AddDropdown(options) return self:Dropdown(options) end
    function tabAPI:AddTextbox(options) return self:Textbox(options) end
    function tabAPI:AddLabel(options) return self:Label(options) end
    function tabAPI:AddSection(options) return self:Section(options) end
    function tabAPI:AddColorPicker(options) return self:ColorPicker(options) end
    function tabAPI:AddKeybind(options) return self:Keybind(options) end
    
    -- 重新绑定 self 引用
    local window = self
    tabAPI.AddButton = function(_, opts) return window:AddButton(tab, opts) end
    tabAPI.AddToggle = function(_, opts) return window:AddToggle(tab, opts) end
    tabAPI.AddSlider = function(_, opts) return window:AddSlider(tab, opts) end
    tabAPI.AddDropdown = function(_, opts) return window:AddDropdown(tab, opts) end
    tabAPI.AddTextbox = function(_, opts) return window:AddTextbox(tab, opts) end
    tabAPI.AddLabel = function(_, opts) return window:AddLabel(tab, opts) end
    tabAPI.AddSection = function(_, opts) return window:AddSection(tab, opts) end
    tabAPI.AddColorPicker = function(_, opts) return window:AddColorPicker(tab, opts) end
    tabAPI.AddKeybind = function(_, opts) return window:AddKeybind(tab, opts) end
    
    return tabAPI
end

function Window:SelectTab(tab)
    -- 取消之前选中的标签
    if self.ActiveTab then
        self.ActiveTab.Active = false
        self.ActiveTab.Button.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
        self.ActiveTab.Content.Visible = false
        self.ActiveTab.TextLabels.Main.TextColor3 = PixelCraft.Colors.TextPrimary
        
        -- 恢复边框
        for _, border in ipairs(self.ActiveTab.Borders) do
            if border.Name == "TopLight" or border.Name == "LeftLight" then
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderLight
            else
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderDark
            end
        end
    end
    
    -- 选中新标签
    tab.Active = true
    tab.Button.BackgroundColor3 = PixelCraft.Colors.Emerald
    tab.Content.Visible = true
    tab.TextLabels.Main.TextColor3 = PixelCraft.Colors.TextPrimary
    
    -- 高亮边框
    for _, border in ipairs(tab.Borders) do
        if border.Name == "TopLight" or border.Name == "LeftLight" then
            border.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
        else
            border.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
        end
    end
    
    self.ActiveTab = tab
end

--============================================================================--
--                              按钮组件                                       --
--============================================================================--

function Window:AddButton(tab, options)
    options = Utils.Merge({
        Name = "Button",
        Description = nil,
        Callback = function() end,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = options.Name .. "Container"
    buttonContainer.Size = UDim2.new(1, -8, 0, options.Description and 48 or 32)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.LayoutOrder = options.LayoutOrder
    buttonContainer.ZIndex = tab.Content.ZIndex + 1
    buttonContainer.Parent = tab.Content
    
    -- 主按钮
    local button = Instance.new("TextButton")
    button.Name = options.Name
    button.Size = UDim2.new(1, 0, 0, 28)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    button.BorderSizePixel = 0
    button.Text = ""
    button.ZIndex = buttonContainer.ZIndex + 1
    button.Parent = buttonContainer
    
    -- 按钮边框
    local borders = Utils.Create3DBorder(button,
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    
    -- 按钮文字
    local textLabels = Utils.CreateShadowText(button, options.Name, PixelCraft.Colors.TextPrimary)
    
    -- 描述文字
    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Size = UDim2.new(1, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 0, 0, 32)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = PixelCraft.Colors.TextSecondary
        descLabel.Font = Enum.Font.Code
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = buttonContainer.ZIndex + 1
        descLabel.Parent = buttonContainer
    end
    
    -- 按钮交互
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = PixelCraft.Colors.ButtonHover
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    end)
    
    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = PixelCraft.Colors.ButtonPressed
        for _, border in ipairs(borders) do
            if border.Name == "TopLight" or border.Name == "LeftLight" then
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderDark
            else
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderLight
            end
        end
    end)
    
    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = PixelCraft.Colors.ButtonHover
        for _, border in ipairs(borders) do
            if border.Name == "TopLight" or border.Name == "LeftLight" then
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderLight
            else
                border.BackgroundColor3 = PixelCraft.Colors.ButtonBorderDark
            end
        end
        options.Callback()
    end)
    
    local component = {
        Type = "Button",
        Instance = buttonContainer,
        Button = button
    }
    
    function component:SetText(text)
        textLabels.Main.Text = text
        textLabels.Shadow.Text = text
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                              开关组件                                       --
--============================================================================--

function Window:AddToggle(tab, options)
    options = Utils.Merge({
        Name = "Toggle",
        Description = nil,
        Default = false,
        Callback = function(value) end,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = options.Name .. "Container"
    toggleContainer.Size = UDim2.new(1, -8, 0, options.Description and 48 or 32)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.LayoutOrder = options.LayoutOrder
    toggleContainer.ZIndex = tab.Content.ZIndex + 1
    toggleContainer.Parent = tab.Content
    
    -- 开关背景
    local toggleBg = Instance.new("TextButton")
    toggleBg.Name = options.Name
    toggleBg.Size = UDim2.new(1, 0, 0, 28)
    toggleBg.Position = UDim2.new(0, 0, 0, 0)
    toggleBg.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    toggleBg.BorderSizePixel = 0
    toggleBg.Text = ""
    toggleBg.ZIndex = toggleContainer.ZIndex + 1
    toggleBg.Parent = toggleContainer
    
    -- 边框
    Utils.Create3DBorder(toggleBg,
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    
    -- 开关标签
    local labelContainer = Instance.new("Frame")
    labelContainer.Name = "LabelContainer"
    labelContainer.Size = UDim2.new(1, -50, 1, 0)
    labelContainer.Position = UDim2.new(0, 8, 0, 0)
    labelContainer.BackgroundTransparency = 1
    labelContainer.ZIndex = toggleBg.ZIndex + 1
    labelContainer.Parent = toggleBg
    
    local textLabels = Utils.CreateShadowText(labelContainer, options.Name, PixelCraft.Colors.TextPrimary)
    textLabels.Main.TextXAlignment = Enum.TextXAlignment.Left
    textLabels.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 开关指示器 (Minecraft 风格复选框)
    local checkboxOuter = Instance.new("Frame")
    checkboxOuter.Name = "CheckboxOuter"
    checkboxOuter.Size = UDim2.new(0, 20, 0, 20)
    checkboxOuter.Position = UDim2.new(1, -28, 0.5, -10)
    checkboxOuter.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
    checkboxOuter.BorderSizePixel = 0
    checkboxOuter.ZIndex = toggleBg.ZIndex + 1
    checkboxOuter.Parent = toggleBg
    
    Utils.Create3DBorder(checkboxOuter,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
    
    -- 勾选标记
    local checkmark = Instance.new("Frame")
    checkmark.Name = "Checkmark"
    checkmark.Size = UDim2.new(0, 12, 0, 12)
    checkmark.Position = UDim2.new(0.5, -6, 0.5, -6)
    checkmark.BackgroundColor3 = PixelCraft.Colors.Emerald
    checkmark.BorderSizePixel = 0
    checkmark.Visible = options.Default
    checkmark.ZIndex = checkboxOuter.ZIndex + 1
    checkmark.Parent = checkboxOuter
    
    -- 勾选标记像素化 "✓"
    local checkPixels = {
        {2, 6}, {3, 7}, {4, 8}, {5, 7}, {6, 6}, {7, 5}, {8, 4}, {9, 3}, {10, 2}
    }
    
    for _, pos in ipairs(checkPixels) do
        local pixel = Instance.new("Frame")
        pixel.Size = UDim2.new(0, 2, 0, 2)
        pixel.Position = UDim2.new(0, pos[1] - 2, 0, pos[2] - 2)
        pixel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        pixel.BorderSizePixel = 0
        pixel.ZIndex = checkmark.ZIndex + 1
        pixel.Parent = checkmark
    end
    
    -- 描述文字 (继续)
    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Size = UDim2.new(1, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 0, 0, 32)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = PixelCraft.Colors.TextSecondary
        descLabel.Font = Enum.Font.Code
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = toggleContainer.ZIndex + 1
        descLabel.Parent = toggleContainer
    end
    
    -- 状态管理
    local enabled = options.Default
    
    local function updateVisual()
        checkmark.Visible = enabled
        if enabled then
            checkboxOuter.BackgroundColor3 = PixelCraft.Colors.Emerald
        else
            checkboxOuter.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
        end
    end
    
    updateVisual()
    
    -- 交互
    toggleBg.MouseEnter:Connect(function()
        toggleBg.BackgroundColor3 = PixelCraft.Colors.ButtonHover
    end)
    
    toggleBg.MouseLeave:Connect(function()
        toggleBg.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    end)
    
    toggleBg.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateVisual()
        options.Callback(enabled)
    end)
    
    local component = {
        Type = "Toggle",
        Instance = toggleContainer,
        Value = enabled
    }
    
    function component:SetValue(value)
        enabled = value
        self.Value = value
        updateVisual()
    end
    
    function component:GetValue()
        return enabled
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                              滑块组件                                       --
--============================================================================--

function Window:AddSlider(tab, options)
    options = Utils.Merge({
        Name = "Slider",
        Description = nil,
        Min = 0,
        Max = 100,
        Default = 50,
        Increment = 1,
        Suffix = "",
        Callback = function(value) end,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = options.Name .. "Container"
    sliderContainer.Size = UDim2.new(1, -8, 0, options.Description and 64 or 48)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.LayoutOrder = options.LayoutOrder
    sliderContainer.ZIndex = tab.Content.ZIndex + 1
    sliderContainer.Parent = tab.Content
    
    -- 滑块背景
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = options.Name
    sliderBg.Size = UDim2.new(1, 0, 0, 44)
    sliderBg.Position = UDim2.new(0, 0, 0, 0)
    sliderBg.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = sliderContainer.ZIndex + 1
    sliderBg.Parent = sliderContainer
    
    Utils.Create3DBorder(sliderBg,
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    
    -- 标签和数值显示
    local headerContainer = Instance.new("Frame")
    headerContainer.Name = "Header"
    headerContainer.Size = UDim2.new(1, -16, 0, 18)
    headerContainer.Position = UDim2.new(0, 8, 0, 4)
    headerContainer.BackgroundTransparency = 1
    headerContainer.ZIndex = sliderBg.ZIndex + 1
    headerContainer.Parent = sliderBg
    
    -- 标签
    local labelText = Utils.CreateShadowText(headerContainer, options.Name, PixelCraft.Colors.TextPrimary)
    labelText.Main.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Main.TextSize = 12
    labelText.Shadow.TextSize = 12
    
    -- 数值显示
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 60, 1, 0)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(options.Default) .. options.Suffix
    valueLabel.TextColor3 = PixelCraft.Colors.Gold
    valueLabel.Font = Enum.Font.Code
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = headerContainer.ZIndex + 1
    valueLabel.Parent = headerContainer
    
    -- 滑块轨道
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Size = UDim2.new(1, -16, 0, 12)
    sliderTrack.Position = UDim2.new(0, 8, 0, 26)
    sliderTrack.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
    sliderTrack.BorderSizePixel = 0
    sliderTrack.ZIndex = sliderBg.ZIndex + 1
    sliderTrack.Parent = sliderBg
    
    Utils.Create3DBorder(sliderTrack,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
    
    -- 滑块填充 (经验条风格)
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new(0, 0, 1, -4)
    sliderFill.Position = UDim2.new(0, 2, 0, 2)
    sliderFill.BackgroundColor3 = PixelCraft.Colors.ProgressXP
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = sliderTrack.ZIndex + 1
    sliderFill.Parent = sliderTrack
    
    -- 添加经验条纹理效果
    for i = 0, 20 do
        local stripe = Instance.new("Frame")
        stripe.Size = UDim2.new(0, 2, 1, 0)
        stripe.Position = UDim2.new(0, i * 8, 0, 0)
        stripe.BackgroundColor3 = Color3.fromRGB(180, 255, 100)
        stripe.BackgroundTransparency = 0.7
        stripe.BorderSizePixel = 0
        stripe.ZIndex = sliderFill.ZIndex + 1
        stripe.Parent = sliderFill
    end
    
    -- 滑块把手
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 8, 0, 16)
    sliderHandle.Position = UDim2.new(0, 0, 0.5, -8)
    sliderHandle.BackgroundColor3 = PixelCraft.Colors.ContainerBg
    sliderHandle.BorderSizePixel = 0
    sliderHandle.ZIndex = sliderTrack.ZIndex + 2
    sliderHandle.Parent = sliderTrack
    
    Utils.Create3DBorder(sliderHandle,
        PixelCraft.Colors.ContainerHighlight,
        PixelCraft.Colors.ContainerShadow,
        2
    )
    
    -- 描述
    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Size = UDim2.new(1, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 0, 0, 48)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = PixelCraft.Colors.TextSecondary
        descLabel.Font = Enum.Font.Code
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = sliderContainer.ZIndex + 1
        descLabel.Parent = sliderContainer
    end
    
    -- 滑块逻辑
    local currentValue = options.Default
    local dragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, options.Min, options.Max)
        -- 对齐到增量
        value = math.floor(value / options.Increment + 0.5) * options.Increment
        currentValue = value
        
        local percent = (value - options.Min) / (options.Max - options.Min)
        local trackWidth = sliderTrack.AbsoluteSize.X - 12
        
        sliderFill.Size = UDim2.new(0, trackWidth * percent, 1, -4)
        sliderHandle.Position = UDim2.new(0, trackWidth * percent, 0.5, -8)
        valueLabel.Text = tostring(value) .. options.Suffix
        
        options.Callback(value)
    end
    
    -- 初始化
    task.defer(function()
        updateSlider(options.Default)
    end)
    
    -- 输入处理
    local inputConnection
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            
            local trackStart = sliderTrack.AbsolutePosition.X
            local trackWidth = sliderTrack.AbsoluteSize.X
            local percent = math.clamp((input.Position.X - trackStart) / trackWidth, 0, 1)
            local value = options.Min + (options.Max - options.Min) * percent
            updateSlider(value)
        end
    end)
    
    sliderTrack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local trackStart = sliderTrack.AbsolutePosition.X
            local trackWidth = sliderTrack.AbsoluteSize.X
            local percent = math.clamp((input.Position.X - trackStart) / trackWidth, 0, 1)
            local value = options.Min + (options.Max - options.Min) * percent
            updateSlider(value)
        end
    end)
    
    local component = {
        Type = "Slider",
        Instance = sliderContainer,
        Value = currentValue
    }
    
    function component:SetValue(value)
        updateSlider(value)
        self.Value = currentValue
    end
    
    function component:GetValue()
        return currentValue
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                            下拉菜单组件                                     --
--============================================================================--

function Window:AddDropdown(tab, options)
    options = Utils.Merge({
        Name = "Dropdown",
        Description = nil,
        Items = {},
        Default = nil,
        MultiSelect = false,
        Callback = function(value) end,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = options.Name .. "Container"
    dropdownContainer.Size = UDim2.new(1, -8, 0, options.Description and 64 or 48)
    dropdownContainer.BackgroundTransparency = 1
    dropdownContainer.LayoutOrder = options.LayoutOrder
    dropdownContainer.ZIndex = tab.Content.ZIndex + 1
    dropdownContainer.ClipsDescendants = false
    dropdownContainer.Parent = tab.Content
    
    -- 下拉按钮
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Name = options.Name
    dropdownBtn.Size = UDim2.new(1, 0, 0, 44)
    dropdownBtn.Position = UDim2.new(0, 0, 0, 0)
    dropdownBtn.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = ""
    dropdownBtn.ZIndex = dropdownContainer.ZIndex + 1
    dropdownBtn.Parent = dropdownContainer
    
    Utils.Create3DBorder(dropdownBtn,
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    
    -- 标签
    local labelContainer = Instance.new("Frame")
    labelContainer.Name = "LabelContainer"
    labelContainer.Size = UDim2.new(1, -16, 0, 18)
    labelContainer.Position = UDim2.new(0, 8, 0, 4)
    labelContainer.BackgroundTransparency = 1
    labelContainer.ZIndex = dropdownBtn.ZIndex + 1
    labelContainer.Parent = dropdownBtn
    
    local labelText = Utils.CreateShadowText(labelContainer, options.Name, PixelCraft.Colors.TextPrimary)
    labelText.Main.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Main.TextSize = 12
    labelText.Shadow.TextSize = 12
    
    -- 选中值显示
    local selectedContainer = Instance.new("Frame")
    selectedContainer.Name = "SelectedContainer"
    selectedContainer.Size = UDim2.new(1, -24, 0, 18)
    selectedContainer.Position = UDim2.new(0, 8, 0, 22)
    selectedContainer.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
    selectedContainer.BorderSizePixel = 0
    selectedContainer.ZIndex = dropdownBtn.ZIndex + 1
    selectedContainer.Parent = dropdownBtn
    
    Utils.Create3DBorder(selectedContainer,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        1
    )
    
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "SelectedLabel"
    selectedLabel.Size = UDim2.new(1, -20, 1, 0)
    selectedLabel.Position = UDim2.new(0, 4, 0, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = options.Default or "Select..."
    selectedLabel.TextColor3 = PixelCraft.Colors.TextSecondary
    selectedLabel.Font = Enum.Font.Code
    selectedLabel.TextSize = 11
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
    selectedLabel.ZIndex = selectedContainer.ZIndex + 1
    selectedLabel.Parent = selectedContainer
    
    -- 箭头指示器 (像素化)
    local arrowContainer = Instance.new("Frame")
    arrowContainer.Name = "Arrow"
    arrowContainer.Size = UDim2.new(0, 12, 0, 8)
    arrowContainer.Position = UDim2.new(1, -16, 0.5, -4)
    arrowContainer.BackgroundTransparency = 1
    arrowContainer.ZIndex = selectedContainer.ZIndex + 1
    arrowContainer.Parent = selectedContainer
    
    -- 像素箭头
    local arrowPixels = {
        {6, 1}, {5, 2}, {6, 2}, {7, 2}, {4, 3}, {5, 3}, {6, 3}, {7, 3}, {8, 3},
        {3, 4}, {4, 4}, {5, 4}, {6, 4}, {7, 4}, {8, 4}, {9, 4}
    }
    
    for _, pos in ipairs(arrowPixels) do
        local pixel = Instance.new("Frame")
        pixel.Size = UDim2.new(0, 1, 0, 1)
        pixel.Position = UDim2.new(0, pos[1] - 3, 0, pos[2])
        pixel.BackgroundColor3 = PixelCraft.Colors.TextPrimary
        pixel.BorderSizePixel = 0
        pixel.ZIndex = arrowContainer.ZIndex + 1
        pixel.Parent = arrowContainer
    end
    
    -- 下拉列表容器
    local listContainer = Instance.new("Frame")
    listContainer.Name = "ListContainer"
    listContainer.Size = UDim2.new(1, 0, 0, 0)
    listContainer.Position = UDim2.new(0, 0, 0, 48)
    listContainer.BackgroundColor3 = PixelCraft.Colors.BackgroundDark
    listContainer.BorderSizePixel = 0
    listContainer.Visible = false
    listContainer.ClipsDescendants = true
    listContainer.ZIndex = 100  -- 高层级确保显示在最上面
    listContainer.Parent = dropdownContainer
    
    Utils.Create3DBorder(listContainer,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
    
    -- 列表滚动区域
    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Name = "ListScroll"
    listScroll.Size = UDim2.new(1, -4, 1, -4)
    listScroll.Position = UDim2.new(0, 2, 0, 2)
    listScroll.BackgroundTransparency = 1
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 6
    listScroll.ScrollBarImageColor3 = PixelCraft.Colors.ScrollHandle
    listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    listScroll.ZIndex = listContainer.ZIndex + 1
    listScroll.Parent = listContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = listScroll
    
    -- 状态管理
    local isOpen = false
    local selected = options.MultiSelect and {} or options.Default
    
    if options.MultiSelect and options.Default then
        if type(options.Default) == "table" then
            selected = options.Default
        else
            selected = {options.Default}
        end
    end
    
    local function updateSelectedText()
        if options.MultiSelect then
            if #selected == 0 then
                selectedLabel.Text = "Select..."
                selectedLabel.TextColor3 = PixelCraft.Colors.TextSecondary
            else
                selectedLabel.Text = table.concat(selected, ", ")
                selectedLabel.TextColor3 = PixelCraft.Colors.TextPrimary
            end
        else
            if selected then
                selectedLabel.Text = tostring(selected)
                selectedLabel.TextColor3 = PixelCraft.Colors.TextPrimary
            else
                selectedLabel.Text = "Select..."
                selectedLabel.TextColor3 = PixelCraft.Colors.TextSecondary
            end
        end
    end
    
    local function createListItems()
        -- 清空现有项
        for _, child in ipairs(listScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for i, item in ipairs(options.Items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Name = "Item_" .. i
            itemBtn.Size = UDim2.new(1, -4, 0, 24)
            itemBtn.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
            itemBtn.BorderSizePixel = 0
            itemBtn.Text = ""
            itemBtn.LayoutOrder = i
            itemBtn.ZIndex = listScroll.ZIndex + 1
            itemBtn.Parent = listScroll
            
            -- 项目边框
            Utils.Create3DBorder(itemBtn,
                PixelCraft.Colors.ButtonBorderLight,
                PixelCraft.Colors.ButtonBorderDark,
                1
            )
            
            -- 项目文字
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Size = UDim2.new(1, -8, 1, 0)
            itemLabel.Position = UDim2.new(0, 4, 0, 0)
            itemLabel.BackgroundTransparency = 1
            itemLabel.Text = tostring(item)
            itemLabel.TextColor3 = PixelCraft.Colors.TextPrimary
            itemLabel.Font = Enum.Font.Code
            itemLabel.TextSize = 11
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.ZIndex = itemBtn.ZIndex + 1
            itemLabel.Parent = itemBtn
            
            -- 多选勾选标记
            if options.MultiSelect then
                local checkIndicator = Instance.new("Frame")
                checkIndicator.Name = "CheckIndicator"
                checkIndicator.Size = UDim2.new(0, 10, 0, 10)
                checkIndicator.Position = UDim2.new(1, -16, 0.5, -5)
                checkIndicator.BackgroundColor3 = PixelCraft.Colors.Emerald
                checkIndicator.BorderSizePixel = 0
                checkIndicator.Visible = table.find(selected, item) ~= nil
                checkIndicator.ZIndex = itemBtn.ZIndex + 1
                checkIndicator.Parent = itemBtn
            end
            
            -- 交互
            itemBtn.MouseEnter:Connect(function()
                itemBtn.BackgroundColor3 = PixelCraft.Colors.ButtonHover
            end)
            
            itemBtn.MouseLeave:Connect(function()
                itemBtn.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
            end)
            
            itemBtn.MouseButton1Click:Connect(function()
                if options.MultiSelect then
                    local index = table.find(selected, item)
                    if index then
                        table.remove(selected, index)
                        itemBtn:FindFirstChild("CheckIndicator").Visible = false
                    else
                        table.insert(selected, item)
                        itemBtn:FindFirstChild("CheckIndicator").Visible = true
                    end
                    updateSelectedText()
                    options.Callback(selected)
                else
                    selected = item
                    updateSelectedText()
                    options.Callback(selected)
                    -- 关闭下拉列表
                    isOpen = false
                    listContainer.Visible = false
                    listContainer.Size = UDim2.new(1, 0, 0, 0)
                end
            end)
        end
        
        -- 更新 CanvasSize
        listScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end
    
    createListItems()
    updateSelectedText()
    
    -- 下拉按钮点击
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            local itemCount = math.min(#options.Items, 5)
            local listHeight = itemCount * 26 + 4
            listContainer.Size = UDim2.new(1, 0, 0, listHeight)
            listContainer.Visible = true
            
            -- 更新容器高度
            dropdownContainer.Size = UDim2.new(1, -8, 0, (options.Description and 64 or 48) + listHeight + 4)
        else
            listContainer.Visible = false
            listContainer.Size = UDim2.new(1, 0, 0, 0)
            dropdownContainer.Size = UDim2.new(1, -8, 0, options.Description and 64 or 48)
        end
    end)
    
    -- 描述
    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Size = UDim2.new(1, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 0, 0, 48)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = PixelCraft.Colors.TextSecondary
        descLabel.Font = Enum.Font.Code
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = dropdownContainer.ZIndex + 1
        descLabel.Parent = dropdownContainer
    end
    
    local component = {
        Type = "Dropdown",
        Instance = dropdownContainer,
        Value = selected
    }
    
    function component:SetValue(value)
        if options.MultiSelect then
            selected = type(value) == "table" and value or {value}
        else
            selected = value
        end
        updateSelectedText()
        self.Value = selected
    end
    
    function component:GetValue()
        return selected
    end
    
    function component:SetItems(items)
        options.Items = items
        createListItems()
    end
    
    function component:AddItem(item)
        table.insert(options.Items, item)
        createListItems()
    end
    
    function component:RemoveItem(item)
        local index = table.find(options.Items, item)
        if index then
            table.remove(options.Items, index)
            createListItems()
        end
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                            输入框组件                                       --
--============================================================================--

function Window:AddTextbox(tab, options)
    options = Utils.Merge({
        Name = "Textbox",
        Description = nil,
        Default = "",
        Placeholder = "Enter text...",
        ClearOnFocus = false,
        Callback = function(value) end,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local textboxContainer = Instance.new("Frame")
    textboxContainer.Name = options.Name .. "Container"
    textboxContainer.Size = UDim2.new(1, -8, 0, options.Description and 64 or 48)
    textboxContainer.BackgroundTransparency = 1
    textboxContainer.LayoutOrder = options.LayoutOrder
    textboxContainer.ZIndex = tab.Content.ZIndex + 1
    textboxContainer.Parent = tab.Content
    
    -- 文本框背景
    local textboxBg = Instance.new("Frame")
    textboxBg.Name = options.Name
    textboxBg.Size = UDim2.new(1, 0, 0, 44)
    textboxBg.Position = UDim2.new(0, 0, 0, 0)
    textboxBg.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    textboxBg.BorderSizePixel = 0
    textboxBg.ZIndex = textboxContainer.ZIndex + 1
    textboxBg.Parent = textboxContainer
    
    Utils.Create3DBorder(textboxBg,
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    
    -- 标签
    local labelContainer = Instance.new("Frame")
    labelContainer.Name = "LabelContainer"
    labelContainer.Size = UDim2.new(1, -16, 0, 16)
    labelContainer.Position = UDim2.new(0, 8, 0, 4)
    labelContainer.BackgroundTransparency = 1
    labelContainer.ZIndex = textboxBg.ZIndex + 1
    labelContainer.Parent = textboxBg
    
    local labelText = Utils.CreateShadowText(labelContainer, options.Name, PixelCraft.Colors.TextPrimary)
    labelText.Main.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Main.TextSize = 12
    labelText.Shadow.TextSize = 12
    
    -- 输入框 (继续)
    local textInput = Instance.new("TextBox")
    textInput.Name = "TextInput"
    textInput.Size = UDim2.new(1, -8, 1, -4)
    textInput.Position = UDim2.new(0, 4, 0, 2)
    textInput.BackgroundTransparency = 1
    textInput.Text = options.Default
    textInput.PlaceholderText = options.Placeholder
    textInput.PlaceholderColor3 = PixelCraft.Colors.TextSecondary
    textInput.TextColor3 = PixelCraft.Colors.TextPrimary
    textInput.Font = Enum.Font.Code
    textInput.TextSize = 11
    textInput.TextXAlignment = Enum.TextXAlignment.Left
    textInput.ClearTextOnFocus = options.ClearOnFocus
    textInput.ZIndex = inputContainer.ZIndex + 1
    textInput.Parent = inputContainer
    
    -- 描述
    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Size = UDim2.new(1, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 0, 0, 48)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = PixelCraft.Colors.TextSecondary
        descLabel.Font = Enum.Font.Code
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = textboxContainer.ZIndex + 1
        descLabel.Parent = textboxContainer
    end
    
    -- 焦点效果
    textInput.Focused:Connect(function()
        inputContainer.BackgroundColor3 = PixelCraft.Colors.BackgroundLight
    end)
    
    textInput.FocusLost:Connect(function(enterPressed)
        inputContainer.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
        if enterPressed then
            options.Callback(textInput.Text)
        end
    end)
    
    -- 实时回调 (可选)
    textInput:GetPropertyChangedSignal("Text"):Connect(function()
        -- 可以在这里添加实时验证
    end)
    
    local component = {
        Type = "Textbox",
        Instance = textboxContainer,
        Value = options.Default
    }
    
    function component:SetValue(value)
        textInput.Text = value
        self.Value = value
    end
    
    function component:GetValue()
        return textInput.Text
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                              标签组件                                       --
--============================================================================--

function Window:AddLabel(tab, options)
    options = Utils.Merge({
        Name = "Label",
        Text = "Label Text",
        Color = PixelCraft.Colors.TextPrimary,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local labelContainer = Instance.new("Frame")
    labelContainer.Name = options.Name .. "Container"
    labelContainer.Size = UDim2.new(1, -8, 0, 24)
    labelContainer.BackgroundTransparency = 1
    labelContainer.LayoutOrder = options.LayoutOrder
    labelContainer.ZIndex = tab.Content.ZIndex + 1
    labelContainer.Parent = tab.Content
    
    local textLabels = Utils.CreateShadowText(labelContainer, options.Text, options.Color)
    textLabels.Main.TextXAlignment = Enum.TextXAlignment.Left
    textLabels.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    textLabels.Main.TextSize = 14
    textLabels.Shadow.TextSize = 14
    
    local component = {
        Type = "Label",
        Instance = labelContainer
    }
    
    function component:SetText(text)
        textLabels.Main.Text = text
        textLabels.Shadow.Text = text
    end
    
    function component:SetColor(color)
        textLabels.Main.TextColor3 = color
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                              分隔区组件                                     --
--============================================================================--

function Window:AddSection(tab, options)
    options = Utils.Merge({
        Name = "Section",
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local sectionContainer = Instance.new("Frame")
    sectionContainer.Name = options.Name .. "Section"
    sectionContainer.Size = UDim2.new(1, -8, 0, 28)
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.LayoutOrder = options.LayoutOrder
    sectionContainer.ZIndex = tab.Content.ZIndex + 1
    sectionContainer.Parent = tab.Content
    
    -- 左侧装饰线
    local leftLine = Instance.new("Frame")
    leftLine.Name = "LeftLine"
    leftLine.Size = UDim2.new(0, 20, 0, 2)
    leftLine.Position = UDim2.new(0, 0, 0.5, -1)
    leftLine.BackgroundColor3 = PixelCraft.Colors.Gold
    leftLine.BorderSizePixel = 0
    leftLine.ZIndex = sectionContainer.ZIndex + 1
    leftLine.Parent = sectionContainer
    
    -- 分隔标题
    local titleContainer = Instance.new("Frame")
    titleContainer.Name = "TitleContainer"
    titleContainer.Size = UDim2.new(0, 0, 0, 20)
    titleContainer.Position = UDim2.new(0, 24, 0.5, -10)
    titleContainer.BackgroundTransparency = 1
    titleContainer.AutomaticSize = Enum.AutomaticSize.X
    titleContainer.ZIndex = sectionContainer.ZIndex + 1
    titleContainer.Parent = sectionContainer
    
    local titleText = Utils.CreateShadowText(titleContainer, options.Name, PixelCraft.Colors.Gold)
    titleText.Main.TextSize = 12
    titleText.Shadow.TextSize = 12
    titleText.Main.AutomaticSize = Enum.AutomaticSize.X
    titleText.Shadow.AutomaticSize = Enum.AutomaticSize.X
    
    -- 右侧装饰线
    local rightLine = Instance.new("Frame")
    rightLine.Name = "RightLine"
    rightLine.Size = UDim2.new(1, -100, 0, 2)
    rightLine.Position = UDim2.new(0, 90, 0.5, -1)
    rightLine.BackgroundColor3 = PixelCraft.Colors.Gold
    rightLine.BorderSizePixel = 0
    rightLine.ZIndex = sectionContainer.ZIndex + 1
    rightLine.Parent = sectionContainer
    
    -- 像素装饰点
    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 4, 0, 4)
        dot.Position = UDim2.new(0, (i-1) * 6, 0.5, -2)
        dot.BackgroundColor3 = PixelCraft.Colors.Gold
        dot.BorderSizePixel = 0
        dot.ZIndex = leftLine.ZIndex + 1
        dot.Parent = leftLine
    end
    
    local component = {
        Type = "Section",
        Instance = sectionContainer
    }
    
    function component:SetText(text)
        titleText.Main.Text = text
        titleText.Shadow.Text = text
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                            颜色选择器组件                                   --
--============================================================================--

function Window:AddColorPicker(tab, options)
    options = Utils.Merge({
        Name = "ColorPicker",
        Description = nil,
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(color) end,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local pickerContainer = Instance.new("Frame")
    pickerContainer.Name = options.Name .. "Container"
    pickerContainer.Size = UDim2.new(1, -8, 0, options.Description and 48 or 32)
    pickerContainer.BackgroundTransparency = 1
    pickerContainer.LayoutOrder = options.LayoutOrder
    pickerContainer.ZIndex = tab.Content.ZIndex + 1
    pickerContainer.ClipsDescendants = false
    pickerContainer.Parent = tab.Content
    
    -- 主按钮
    local pickerBtn = Instance.new("TextButton")
    pickerBtn.Name = options.Name
    pickerBtn.Size = UDim2.new(1, 0, 0, 28)
    pickerBtn.Position = UDim2.new(0, 0, 0, 0)
    pickerBtn.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    pickerBtn.BorderSizePixel = 0
    pickerBtn.Text = ""
    pickerBtn.ZIndex = pickerContainer.ZIndex + 1
    pickerBtn.Parent = pickerContainer
    
    Utils.Create3DBorder(pickerBtn,
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    
    -- 标签
    local labelContainer = Instance.new("Frame")
    labelContainer.Name = "LabelContainer"
    labelContainer.Size = UDim2.new(1, -50, 1, 0)
    labelContainer.Position = UDim2.new(0, 8, 0, 0)
    labelContainer.BackgroundTransparency = 1
    labelContainer.ZIndex = pickerBtn.ZIndex + 1
    labelContainer.Parent = pickerBtn
    
    local textLabels = Utils.CreateShadowText(labelContainer, options.Name, PixelCraft.Colors.TextPrimary)
    textLabels.Main.TextXAlignment = Enum.TextXAlignment.Left
    textLabels.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 颜色预览框
    local colorPreview = Instance.new("Frame")
    colorPreview.Name = "ColorPreview"
    colorPreview.Size = UDim2.new(0, 24, 0, 18)
    colorPreview.Position = UDim2.new(1, -32, 0.5, -9)
    colorPreview.BackgroundColor3 = options.Default
    colorPreview.BorderSizePixel = 0
    colorPreview.ZIndex = pickerBtn.ZIndex + 1
    colorPreview.Parent = pickerBtn
    
    Utils.Create3DBorder(colorPreview,
        PixelCraft.Colors.ContainerHighlight,
        PixelCraft.Colors.ContainerShadow,
        2
    )
    
    -- 颜色选择面板
    local colorPanel = Instance.new("Frame")
    colorPanel.Name = "ColorPanel"
    colorPanel.Size = UDim2.new(0, 200, 0, 160)
    colorPanel.Position = UDim2.new(1, -200, 0, 32)
    colorPanel.BackgroundColor3 = PixelCraft.Colors.BackgroundDark
    colorPanel.BorderSizePixel = 0
    colorPanel.Visible = false
    colorPanel.ZIndex = 150
    colorPanel.Parent = pickerContainer
    
    Utils.Create3DBorder(colorPanel,
        PixelCraft.Colors.ContainerHighlight,
        PixelCraft.Colors.ContainerShadow,
        2
    )
    
    -- 色相/饱和度选择区
    local satValPicker = Instance.new("ImageButton")
    satValPicker.Name = "SatValPicker"
    satValPicker.Size = UDim2.new(0, 150, 0, 100)
    satValPicker.Position = UDim2.new(0, 8, 0, 8)
    satValPicker.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
    satValPicker.BorderSizePixel = 0
    satValPicker.ZIndex = colorPanel.ZIndex + 1
    satValPicker.Parent = colorPanel
    
    -- 饱和度渐变 (白色到透明)
    local satGradient = Instance.new("UIGradient")
    satGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    satGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    satGradient.Parent = satValPicker
    
    -- 明度覆盖层
    local valOverlay = Instance.new("Frame")
    valOverlay.Name = "ValOverlay"
    valOverlay.Size = UDim2.new(1, 0, 1, 0)
    valOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    valOverlay.BackgroundTransparency = 0
    valOverlay.BorderSizePixel = 0
    valOverlay.ZIndex = satValPicker.ZIndex + 1
    valOverlay.Parent = satValPicker
    
    local valGradient = Instance.new("UIGradient")
    valGradient.Rotation = 90
    valGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    valGradient.Parent = valOverlay
    
    -- 选择指示器
    local satValIndicator = Instance.new("Frame")
    satValIndicator.Name = "Indicator"
    satValIndicator.Size = UDim2.new(0, 8, 0, 8)
    satValIndicator.Position = UDim2.new(1, -4, 0, -4)
    satValIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    satValIndicator.BorderSizePixel = 0
    satValIndicator.ZIndex = valOverlay.ZIndex + 1
    satValIndicator.Parent = satValPicker
    
    Utils.Create3DBorder(satValIndicator,
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(100, 100, 100),
        1
    )
    
    -- 色相滑块
    local huePicker = Instance.new("ImageButton")
    huePicker.Name = "HuePicker"
    huePicker.Size = UDim2.new(0, 24, 0, 100)
    huePicker.Position = UDim2.new(0, 166, 0, 8)
    huePicker.BorderSizePixel = 0
    huePicker.ZIndex = colorPanel.ZIndex + 1
    huePicker.Parent = colorPanel
    
    -- 色相渐变
    local hueGradient = Instance.new("UIGradient")
    hueGradient.Rotation = 90
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    hueGradient.Parent = huePicker
    
    -- 色相指示器
    local hueIndicator = Instance.new("Frame")
    hueIndicator.Name = "HueIndicator"
    hueIndicator.Size = UDim2.new(1, 4, 0, 4)
    hueIndicator.Position = UDim2.new(0, -2, 0, 0)
    hueIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueIndicator.BorderSizePixel = 0
    hueIndicator.ZIndex = huePicker.ZIndex + 1
    hueIndicator.Parent = huePicker
    
    -- RGB 输入框
    local rgbContainer = Instance.new("Frame")
    rgbContainer.Name = "RGBContainer"
    rgbContainer.Size = UDim2.new(0, 184, 0, 40)
    rgbContainer.Position = UDim2.new(0, 8, 0, 114)
    rgbContainer.BackgroundTransparency = 1
    rgbContainer.ZIndex = colorPanel.ZIndex + 1
    rgbContainer.Parent = colorPanel
    
    local rgbInputs = {}
    local rgbLabels = {"R", "G", "B"}
    
    for i, label in ipairs(rgbLabels) do
        local inputFrame = Instance.new("Frame")
        inputFrame.Size = UDim2.new(0, 56, 0, 36)
        inputFrame.Position = UDim2.new(0, (i-1) * 62, 0, 0)
        inputFrame.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
        inputFrame.BorderSizePixel = 0
        inputFrame.ZIndex = rgbContainer.ZIndex + 1
        inputFrame.Parent = rgbContainer
        
        Utils.Create3DBorder(inputFrame,
            PixelCraft.Colors.ContainerShadow,
            PixelCraft.Colors.ContainerBorder,
            1
        )
        
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0, 16, 0, 16)
        labelText.Position = UDim2.new(0, 4, 0, 2)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.TextColor3 = label == "R" and PixelCraft.Colors.Redstone or 
                              (label == "G" and PixelCraft.Colors.Emerald or PixelCraft.Colors.Lapis)
        labelText.Font = Enum.Font.Code
        labelText.TextSize = 10
        labelText.ZIndex = inputFrame.ZIndex + 1
        labelText.Parent = inputFrame
        
        local input = Instance.new("TextBox")
        input.Name = label .. "Input"
        input.Size = UDim2.new(1, -8, 0, 16)
        input.Position = UDim2.new(0, 4, 0, 18)
        input.BackgroundTransparency = 1
        input.Text = "255"
        input.TextColor3 = PixelCraft.Colors.TextPrimary
        input.Font = Enum.Font.Code
        input.TextSize = 11
        input.ZIndex = inputFrame.ZIndex + 1
        input.Parent = inputFrame
        
        rgbInputs[label] = input
    end
    
    -- 状态管理
    local currentColor = options.Default
    local currentHue, currentSat, currentVal = Color3.toHSV(options.Default)
    local isOpen = false
    
    local function updateColor()
        local color = Color3.fromHSV(currentHue, currentSat, currentVal)
        currentColor = color
        colorPreview.BackgroundColor3 = color
        satValPicker.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
        
        -- 更新指示器位置
        satValIndicator.Position = UDim2.new(currentSat, -4, 1 - currentVal, -4)
        hueIndicator.Position = UDim2.new(0, -2, currentHue, -2)
        
        -- 更新 RGB 输入框
        rgbInputs.R.Text = tostring(math.floor(color.R * 255))
        rgbInputs.G.Text = tostring(math.floor(color.G * 255))
        rgbInputs.B.Text = tostring(math.floor(color.B * 255))
        
        options.Callback(color)
    end
    
    -- 初始化
    updateColor()
    
    -- 饱和度/明度选择
    local satValDragging = false
    
    satValPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            satValDragging = true
            local relX = math.clamp((input.Position.X - satValPicker.AbsolutePosition.X) / satValPicker.AbsoluteSize.X, 0, 1)
            local relY = math.clamp((input.Position.Y - satValPicker.AbsolutePosition.Y) / satValPicker.AbsoluteSize.Y, 0, 1)
            currentSat = relX
            currentVal = 1 - relY
            updateColor()
        end
    end)
    
    satValPicker.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            satValDragging = false
        end
    end)
    
    -- 色相选择
    local hueDragging = false
    
    huePicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            local relY = math.clamp((input.Position.Y - huePicker.AbsolutePosition.Y) / huePicker.AbsoluteSize.Y, 0, 1)
            currentHue = relY
            updateColor()
        end
    end)
    
    huePicker.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
        end
    end)
    
    -- 鼠标移动处理
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if satValDragging then
                local relX = math.clamp((input.Position.X - satValPicker.AbsolutePosition.X) / satValPicker.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - satValPicker.AbsolutePosition.Y) / satValPicker.AbsoluteSize.Y, 0, 1)
                currentSat = relX
                currentVal = 1 - relY
                updateColor()
            elseif hueDragging then
                local relY = math.clamp((input.Position.Y - huePicker.AbsolutePosition.Y) / huePicker.AbsoluteSize.Y, 0, 1)
                currentHue = relY
                updateColor()
            end
        end
    end)
    
    -- RGB 输入框回调
    for label, input in pairs(rgbInputs) do
        input.FocusLost:Connect(function()
            local value = tonumber(input.Text) or 0
            value = math.clamp(value, 0, 255)
            input.Text = tostring(value)
            
            local r = tonumber(rgbInputs.R.Text) or 0
            local g = tonumber(rgbInputs.G.Text) or 0
            local b = tonumber(rgbInputs.B.Text) or 0
            
            currentColor = Color3.fromRGB(r, g, b)
            currentHue, currentSat, currentVal = Color3.toHSV(currentColor)
            updateColor()
        end)
    end
    
    -- 打开/关闭面板
    pickerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        colorPanel.Visible = isOpen
        
        if isOpen then
            pickerContainer.Size = UDim2.new(1, -8, 0, (options.Description and 48 or 32) + 168)
        else
            pickerContainer.Size = UDim2.new(1, -8, 0, options.Description and 48 or 32)
        end
    end)
    
    -- 描述
    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Size = UDim2.new(1, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 0, 0, 32)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = PixelCraft.Colors.TextSecondary
        descLabel.Font = Enum.Font.Code
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = pickerContainer.ZIndex + 1
        descLabel.Parent = pickerContainer
    end
    
    local component = {
        Type = "ColorPicker",
        Instance = pickerContainer,
        Value = currentColor
    }
    
    function component:SetValue(color)
        currentColor = color
        currentHue, currentSat, currentVal = Color3.toHSV(color)
        updateColor()
        self.Value = color
    end
    
    function component:GetValue()
        return currentColor
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                            按键绑定组件                                     --
--============================================================================--

function Window:AddKeybind(tab, options)
    options = Utils.Merge({
        Name = "Keybind",
        Description = nil,
        Default = Enum.KeyCode.F,
        Callback = function(key) end,
        ChangedCallback = function(newKey) end,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local keybindContainer = Instance.new("Frame")
    keybindContainer.Name = options.Name .. "Container"
    keybindContainer.Size = UDim2.new(1, -8, 0, options.Description and 48 or 32)
    keybindContainer.BackgroundTransparency = 1
    keybindContainer.LayoutOrder = options.LayoutOrder
    keybindContainer.ZIndex = tab.Content.ZIndex + 1
    keybindContainer.Parent = tab.Content
    
    -- 背景
    local keybindBg = Instance.new("Frame")
    keybindBg.Name = options.Name
    keybindBg.Size = UDim2.new(1, 0, 0, 28)
    keybindBg.Position = UDim2.new(0, 0, 0, 0)
    keybindBg.BackgroundColor3 = PixelCraft.Colors.ButtonNormal
    keybindBg.BorderSizePixel = 0
    keybindBg.ZIndex = keybindContainer.ZIndex + 1
    keybindBg.Parent = keybindContainer
    
    Utils.Create3DBorder(keybindBg,
        PixelCraft.Colors.ButtonBorderLight,
        PixelCraft.Colors.ButtonBorderDark,
        2
    )
    
    -- 标签
    local labelContainer = Instance.new("Frame")
    labelContainer.Name = "LabelContainer"
    labelContainer.Size = UDim2.new(1, -80, 1, 0)
    labelContainer.Position = UDim2.new(0, 8, 0, 0)
    labelContainer.BackgroundTransparency = 1
    labelContainer.ZIndex = keybindBg.ZIndex + 1
    labelContainer.Parent = keybindBg
    
    local textLabels = Utils.CreateShadowText(labelContainer, options.Name, PixelCraft.Colors.TextPrimary)
    textLabels.Main.TextXAlignment = Enum.TextXAlignment.Left
    textLabels.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 按键显示按钮
    local keyBtn = Instance.new("TextButton")
    keyBtn.Name = "KeyButton"
    keyBtn.Size = UDim2.new(0, 60, 0, 20)
    keyBtn.Position = UDim2.new(1, -68, 0.5, -10)
    keyBtn.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = ""
    keyBtn.ZIndex = keybindBg.ZIndex + 1
    keyBtn.Parent = keybindBg
    
    Utils.Create3DBorder(keyBtn,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Name = "KeyLabel"
    keyLabel.Size = UDim2.new(1, 0, 1, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = options.Default.Name
    keyLabel.TextColor3 = PixelCraft.Colors.Diamond
    keyLabel.Font = Enum.Font.Code
    keyLabel.TextSize = 11
    keyLabel.ZIndex = keyBtn.ZIndex + 1
    keyLabel.Parent = keyBtn
    
    -- 描述 (继续)
    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Size = UDim2.new(1, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 0, 0, 32)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = PixelCraft.Colors.TextSecondary
        descLabel.Font = Enum.Font.Code
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = keybindContainer.ZIndex + 1
        descLabel.Parent = keybindContainer
    end
    
    -- 状态管理
    local currentKey = options.Default
    local isListening = false
    
    -- 按键监听
    keyBtn.MouseButton1Click:Connect(function()
        isListening = true
        keyLabel.Text = "..."
        keyLabel.TextColor3 = PixelCraft.Colors.Gold
        keyBtn.BackgroundColor3 = PixelCraft.Colors.BackgroundLight
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isListening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keyLabel.Text = input.KeyCode.Name
                keyLabel.TextColor3 = PixelCraft.Colors.Diamond
                keyBtn.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
                isListening = false
                options.ChangedCallback(currentKey)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- 点击其他地方取消监听
                task.defer(function()
                    if isListening then
                        keyLabel.Text = currentKey.Name
                        keyLabel.TextColor3 = PixelCraft.Colors.Diamond
                        keyBtn.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
                        isListening = false
                    end
                end)
            end
        else
            -- 触发回调
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                if not gameProcessed then
                    options.Callback(currentKey)
                end
            end
        end
    end)
    
    local component = {
        Type = "Keybind",
        Instance = keybindContainer,
        Value = currentKey
    }
    
    function component:SetValue(key)
        currentKey = key
        keyLabel.Text = key.Name
        self.Value = key
    end
    
    function component:GetValue()
        return currentKey
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                              分隔线组件                                     --
--============================================================================--

function Window:AddDivider(tab, options)
    options = Utils.Merge({
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local dividerContainer = Instance.new("Frame")
    dividerContainer.Name = "Divider"
    dividerContainer.Size = UDim2.new(1, -8, 0, 12)
    dividerContainer.BackgroundTransparency = 1
    dividerContainer.LayoutOrder = options.LayoutOrder
    dividerContainer.ZIndex = tab.Content.ZIndex + 1
    dividerContainer.Parent = tab.Content
    
    -- 主分隔线
    local dividerLine = Instance.new("Frame")
    dividerLine.Name = "Line"
    dividerLine.Size = UDim2.new(1, 0, 0, 2)
    dividerLine.Position = UDim2.new(0, 0, 0.5, -1)
    dividerLine.BackgroundColor3 = PixelCraft.Colors.ContainerShadow
    dividerLine.BorderSizePixel = 0
    dividerLine.ZIndex = dividerContainer.ZIndex + 1
    dividerLine.Parent = dividerContainer
    
    -- 高光线
    local highlightLine = Instance.new("Frame")
    highlightLine.Name = "Highlight"
    highlightLine.Size = UDim2.new(1, 0, 0, 1)
    highlightLine.Position = UDim2.new(0, 0, 0.5, 1)
    highlightLine.BackgroundColor3 = PixelCraft.Colors.ContainerHighlight
    highlightLine.BorderSizePixel = 0
    highlightLine.ZIndex = dividerContainer.ZIndex + 1
    highlightLine.Parent = dividerContainer
    
    local component = {
        Type = "Divider",
        Instance = dividerContainer
    }
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                            进度条组件                                       --
--============================================================================--

function Window:AddProgressBar(tab, options)
    options = Utils.Merge({
        Name = "ProgressBar",
        Description = nil,
        Default = 0,
        Max = 100,
        ShowValue = true,
        Color = PixelCraft.Colors.ProgressXP,
        LayoutOrder = #tab.Components + 1
    }, options)
    
    local progressContainer = Instance.new("Frame")
    progressContainer.Name = options.Name .. "Container"
    progressContainer.Size = UDim2.new(1, -8, 0, options.Description and 48 or 32)
    progressContainer.BackgroundTransparency = 1
    progressContainer.LayoutOrder = options.LayoutOrder
    progressContainer.ZIndex = tab.Content.ZIndex + 1
    progressContainer.Parent = tab.Content
    
    -- 标签容器
    local headerContainer = Instance.new("Frame")
    headerContainer.Name = "Header"
    headerContainer.Size = UDim2.new(1, 0, 0, 16)
    headerContainer.Position = UDim2.new(0, 0, 0, 0)
    headerContainer.BackgroundTransparency = 1
    headerContainer.ZIndex = progressContainer.ZIndex + 1
    headerContainer.Parent = progressContainer
    
    -- 标签
    local textLabels = Utils.CreateShadowText(headerContainer, options.Name, PixelCraft.Colors.TextPrimary)
    textLabels.Main.TextXAlignment = Enum.TextXAlignment.Left
    textLabels.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    textLabels.Main.TextSize = 12
    textLabels.Shadow.TextSize = 12
    
    -- 数值标签
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 60, 1, 0)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = options.ShowValue and (tostring(options.Default) .. "/" .. tostring(options.Max)) or ""
    valueLabel.TextColor3 = PixelCraft.Colors.Gold
    valueLabel.Font = Enum.Font.Code
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Visible = options.ShowValue
    valueLabel.ZIndex = headerContainer.ZIndex + 1
    valueLabel.Parent = headerContainer
    
    -- 进度条轨道 (经验条风格)
    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "Track"
    progressTrack.Size = UDim2.new(1, 0, 0, 12)
    progressTrack.Position = UDim2.new(0, 0, 0, 18)
    progressTrack.BackgroundColor3 = PixelCraft.Colors.SlotEmpty
    progressTrack.BorderSizePixel = 0
    progressTrack.ZIndex = progressContainer.ZIndex + 1
    progressTrack.Parent = progressContainer
    
    Utils.Create3DBorder(progressTrack,
        PixelCraft.Colors.ContainerShadow,
        PixelCraft.Colors.ContainerBorder,
        2
    )
    
    -- 进度条填充
    local progressFill = Instance.new("Frame")
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(0, 0, 1, -4)
    progressFill.Position = UDim2.new(0, 2, 0, 2)
    progressFill.BackgroundColor3 = options.Color
    progressFill.BorderSizePixel = 0
    progressFill.ClipsDescendants = true
    progressFill.ZIndex = progressTrack.ZIndex + 1
    progressFill.Parent = progressTrack
    
    -- 添加条纹效果
    for i = 0, 30 do
        local stripe = Instance.new("Frame")
        stripe.Size = UDim2.new(0, 2, 1, 0)
        stripe.Position = UDim2.new(0, i * 8, 0, 0)
        stripe.BackgroundColor3 = Color3.new(1, 1, 1)
        stripe.BackgroundTransparency = 0.7
        stripe.BorderSizePixel = 0
        stripe.ZIndex = progressFill.ZIndex + 1
        stripe.Parent = progressFill
    end
    
    -- 描述
    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Size = UDim2.new(1, 0, 0, 16)
        descLabel.Position = UDim2.new(0, 0, 0, 32)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = PixelCraft.Colors.TextSecondary
        descLabel.Font = Enum.Font.Code
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = progressContainer.ZIndex + 1
        descLabel.Parent = progressContainer
    end
    
    -- 状态
    local currentValue = options.Default
    
    local function updateProgress(value)
        value = math.clamp(value, 0, options.Max)
        currentValue = value
        
        local percent = value / options.Max
        local trackWidth = progressTrack.AbsoluteSize.X - 4
        progressFill.Size = UDim2.new(0, trackWidth * percent, 1, -4)
        
        if options.ShowValue then
            valueLabel.Text = tostring(math.floor(value)) .. "/" .. tostring(options.Max)
        end
    end
    
    -- 初始化
    task.defer(function()
        updateProgress(options.Default)
    end)
    
    local component = {
        Type = "ProgressBar",
        Instance = progressContainer,
        Value = currentValue
    }
    
    function component:SetValue(value)
        updateProgress(value)
        self.Value = currentValue
    end
    
    function component:GetValue()
        return currentValue
    end
    
    function component:SetMax(max)
        options.Max = max
        updateProgress(currentValue)
    end
    
    function component:SetColor(color)
        progressFill.BackgroundColor3 = color
    end
    
    table.insert(tab.Components, component)
    return component
end

--============================================================================--
--                              通知系统                                       --
--============================================================================--

function PixelCraft:CreateNotification(options)
    options = Utils.Merge({
        Title = "Notification",
        Content = "This is a notification",
        Duration = 3,
        Type = "Info"  -- Info, Success, Warning, Error
    }, options)
    
    -- 通知容器 (如果不存在)
    local notifContainer = ScreenGui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Size = UDim2.new(0, 280, 1, -20)
        notifContainer.Position = UDim2.new(1, -290, 0, 10)
        notifContainer.BackgroundTransparency = 1
        notifContainer.ZIndex = 200
        notifContainer.Parent = ScreenGui
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Parent = notifContainer
    end
    
    -- 确定颜色
    local typeColors = {
        Info = PixelCraft.Colors.Diamond,
        Success = PixelCraft.Colors.Emerald,
        Warning = PixelCraft.Colors.Gold,
        Error = PixelCraft.Colors.Redstone
    }
    local accentColor = typeColors[options.Type] or typeColors.Info
    
    -- 创建通知
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(1, 0, 0, 0)
    notification.AutomaticSize = Enum.AutomaticSize.Y
    notification.BackgroundColor3 = PixelCraft.Colors.BackgroundDark
    notification.BorderSizePixel = 0
    notification.ZIndex = notifContainer.ZIndex + 1
    notification.Parent = notifContainer
    
    Utils.Create3DBorder(notification,
        PixelCraft.Colors.ContainerHighlight,
        PixelCraft.Colors.ContainerShadow,
        2
    )
    
    -- 左侧强调条
    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = accentColor
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = notification.ZIndex + 1
    accentBar.Parent = notification
    
    -- 内容容器
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "Content"
    contentContainer.Size = UDim2.new(1, -12, 0, 0)
    contentContainer.AutomaticSize = Enum.AutomaticSize.Y
    contentContainer.Position = UDim2.new(0, 8, 0, 0)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ZIndex = notification.ZIndex + 1
    contentContainer.Parent = notification
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = contentContainer
    
    -- 标题
    local titleContainer = Instance.new("Frame")
    titleContainer.Name = "TitleContainer"
    titleContainer.Size = UDim2.new(1, 0, 0, 18)
    titleContainer.BackgroundTransparency = 1
    titleContainer.ZIndex = contentContainer.ZIndex + 1
    titleContainer.Parent = contentContainer
    
    local titleLabels = Utils.CreateShadowText(titleContainer, options.Title, accentColor)
    titleLabels.Main.TextXAlignment = Enum.TextXAlignment.Left
    titleLabels.Shadow.TextXAlignment = Enum.TextXAlignment.Left
    titleLabels.Main.TextSize = 14
    titleLabels.Shadow.TextSize = 14
    
    -- 内容
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "ContentLabel"
    contentLabel.Size = UDim2.new(1, 0, 0, 0)
    contentLabel.AutomaticSize = Enum.AutomaticSize.Y
    contentLabel.Position = UDim2.new(0, 0, 0, 22)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = options.Content
    contentLabel.TextColor3 = PixelCraft.Colors.TextPrimary
    contentLabel.Font = Enum.Font.Code
    contentLabel.TextSize = 12
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.ZIndex = contentContainer.ZIndex + 1
    contentLabel.Parent = contentContainer
    
    -- 进度条 (倒计时)
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = accentColor
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = notification.ZIndex + 1
    progressBar.Parent = notification
    
    -- 动画入场
    notification.Position = UDim2.new(1, 0, 0, 0)
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    -- 进度条动画
    TweenService:Create(progressBar, TweenInfo.new(options.Duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    }):Play()
    
    -- 自动关闭
    task.delay(options.Duration, function()
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, 0)
        }):Play()
        
        task.wait(0.3)
        notification:Destroy()
    end)
    
    return notification
end

--============================================================================--
--                             窗口方法                                        --
--============================================================================--

function Window:Show()
    self.Visible = true
    self.MainFrame.Visible = true
    
    -- 动画
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, self.Settings.Width, 0, self.Settings.Height)
    }):Play()
end

function Window:Hide()
    TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(0.2)
    self.Visible = false
    self.MainFrame.Visible = false
end

function Window:Toggle()
    if self.Visible then
        self:Hide()
    else
        self:Show()
    end
end

function Window:Destroy()
    self.MainFrame:Destroy()
    
    -- 从窗口列表中移除
    for i, win in ipairs(PixelCraft.Windows) do
        if win == self then
            table.remove(PixelCraft.Windows, i)
            break
        end
    end
end

function Window:SetTitle(title)
    self.Settings.Title = title
    local titleLabel = self.TitleBar:FindFirstChild("TitleContainer")
    if titleLabel then
        local main = titleLabel:FindFirstChild("MainText")
        local shadow = titleLabel:FindFirstChild("ShadowText")
        if main then main.Text = title end
        if shadow then shadow.Text = title end
    end
end

function Window:Minimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        TweenService:Create(self.ContentContainer, TweenInfo.new(0.2), {
            Size = UDim2.new(1, -8, 0, 0)
        }):Play()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, self.Settings.Width, 0, 32)
        }):Play()
    else
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, self.Settings.Width, 0, self.Settings.Height)
        }):Play()
        TweenService:Create(self.ContentContainer, TweenInfo.new(0.2), {
            Size = UDim2.new(1, -8, 1, -40)
        }):Play()
    end
end

--============================================================================--
--                           主题切换系统                                      --
--============================================================================--

function PixelCraft:SetTheme(themeName)
    local themes = {
        Default = {
            BackgroundDark = Color3.fromRGB(32, 32, 32),
            BackgroundMid = Color3.fromRGB(48, 48, 48),
            BackgroundLight = Color3.fromRGB(64, 64, 64),
            ContainerBg = Color3.fromRGB(139, 139, 139),
            ContainerBorder = Color3.fromRGB(55, 55, 55),
            ContainerHighlight = Color3.fromRGB(255, 255, 255),
            ContainerShadow = Color3.fromRGB(55, 55, 55),
            Accent = Color3.fromRGB(76, 175, 80)
        },
        Dark = {
            BackgroundDark = Color3.fromRGB(20, 20, 20),
            BackgroundMid = Color3.fromRGB(30, 30, 30),
            BackgroundLight = Color3.fromRGB(45, 45, 45),
            ContainerBg = Color3.fromRGB(60, 60, 60),
            ContainerBorder = Color3.fromRGB(40, 40, 40),
            ContainerHighlight = Color3.fromRGB(80, 80, 80),
            ContainerShadow = Color3.fromRGB(25, 25, 25),
            Accent = Color3.fromRGB(100, 100, 255)
        },
        Nether = {
            BackgroundDark = Color3.fromRGB(45, 20, 20),
            BackgroundMid = Color3.fromRGB(60, 30, 30),
            BackgroundLight = Color3.fromRGB(80, 40, 40),
            ContainerBg = Color3.fromRGB(100, 50, 50),
            ContainerBorder = Color3.fromRGB(40, 20, 20),
            ContainerHighlight = Color3.fromRGB(150, 75, 75),
            ContainerShadow = Color3.fromRGB(30, 15, 15),
            Accent = Color3.fromRGB(255, 100, 50)
        },
        End = {
            BackgroundDark = Color3.fromRGB(20, 20, 30),
            BackgroundMid = Color3.fromRGB(30, 30, 45),
            BackgroundLight = Color3.fromRGB(45, 45, 60),
            ContainerBg = Color3.fromRGB(60, 60, 80),
            ContainerBorder = Color3.fromRGB(30, 30, 45),
            ContainerHighlight = Color3.fromRGB(100, 100, 130),
            ContainerShadow = Color3.fromRGB(20, 20, 30),
            Accent = Color3.fromRGB(200, 100, 255)
        }
    }
    
    local theme = themes[themeName]
    if theme then
        for key, value in pairs(theme) do
            PixelCraft.Colors[key] = value
        end
    end
end

--============================================================================--
--                              快捷键系统                                     --
--============================================================================--

function PixelCraft:SetToggleKey(key)
    PixelCraft.ToggleKey = key
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == PixelCraft.ToggleKey then
        for _, window in ipairs(PixelCraft.Windows) do
            window:Toggle()
        end
    end
end)

--============================================================================--
--                                返回库                                       --
--============================================================================--

return PixelCraft


