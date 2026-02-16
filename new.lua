local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Renk Paleti
local Colors = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(12, 12, 12),
    Border = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(85, 170, 255),
    TextMain = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 150),
    InputBg = Color3.fromRGB(20, 20, 20)
}

function Library:CreateWindow(Config)
    local WindowName = Config.Name or "Feral"
    local LogoID = Config.LogoID or "rbxassetid://0"

    local FeralScreen = Instance.new("ScreenGui")
    FeralScreen.Name = "FeralHubUI"
    FeralScreen.Parent = CoreGui
    FeralScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BackgroundTransparency = 0.1 -- Hafif Transparan
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = FeralScreen

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Colors.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = MainFrame

    -- Sürükleme Sistemi
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Üst Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Colors.Sidebar
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 4)
    TopBarCorner.Parent = TopBar

    -- LOGO (ROBLOX ASSET ID) - Gül yerine burası geldi
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 20, 0, 20)
    Logo.Position = UDim2.new(0, 12, 0.5, -10)
    Logo.BackgroundTransparency = 1
    Logo.Image = LogoID
    Logo.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = WindowName
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 38, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Colors.Accent
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 170, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -20)
    TabContainer.Position = UDim2.new(0, 0, 0, 10)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 2)

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -170, 1, -36)
    ContentArea.Position = UDim2.new(0, 170, 0, 36)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local Tabs = {Current = nil}

    function Tabs:AddTab(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.Parent = ContentArea
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
        Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0, 20)

        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = "          " .. name
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.TextColor3 = Colors.TextDim
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = TabContainer

        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(0, 2, 0, 14)
        Line.Position = UDim2.new(0, 12, 0.5, -7)
        Line.BackgroundColor3 = Colors.Accent
        Line.Visible = false
        Line.Parent = TabBtn

        TabBtn.MouseButton1Click:Connect(function()
            if Tabs.Current then
                Tabs.Current.Page.Visible = false
                Tabs.Current.Btn.TextColor3 = Colors.TextDim
                Tabs.Current.Line.Visible = false
            end
            Page.Visible = true
            TabBtn.TextColor3 = Colors.TextMain
            Line.Visible = true
            Tabs.Current = {Page = Page, Btn = TabBtn, Line = Line}
        end)

        local Elements = {}

        function Elements:AddToggle(title, config)
            local callback = config.Callback
            local default = config.Default or false
            
            local TglFrame = Instance.new("Frame")
            TglFrame.Size = UDim2.new(1, -20, 0, 40)
            TglFrame.BackgroundTransparency = 1
            TglFrame.Parent = Page

            local TTitle = Instance.new("TextLabel")
            TTitle.Text = title
            TTitle.Size = UDim2.new(1, 0, 1, 0)
            TTitle.TextColor3 = Colors.TextMain
            TTitle.Font = Enum.Font.GothamBold
            TTitle.TextSize = 13
            TTitle.TextXAlignment = Enum.TextXAlignment.Left
            TTitle.BackgroundTransparency = 1
            TTitle.Parent = TglFrame

            local Box = Instance.new("TextButton")
            Box.Text = ""
            Box.Size = UDim2.new(0, 18, 0, 18)
            Box.Position = UDim2.new(1, -25, 0.5, -9)
            Box.BackgroundColor3 = default and Colors.Accent or Color3.new(0,0,0)
            Box.Parent = TglFrame
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 3)
            Instance.new("UIStroke", Box).Color = Colors.Accent

            local toggled = default
            Box.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Colors.Accent or Color3.new(0,0,0)}):Play()
                callback(toggled)
            end)
        end
        
        return Elements
    end
    return Tabs
end

return Library
