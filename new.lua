local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(Config)
    local WindowName = Config.Name or "Feral"
    local LogoID = Config.LogoID or "rbxassetid://0" -- Buraya kendi Asset ID'ni koyabilirsin

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FeralUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Ana Panel (Transparan Arka Plan)
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 630, 0, 390)
    Main.Position = UDim2.new(0.5, -315, 0.5, -195)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BackgroundTransparency = 0.1 -- Hafif transparanlık
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Main

    -- Üst Bar (Header)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Header.BorderSizePixel = 0
    Header.Parent = Main
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 4)
    HeaderCorner.Parent = Header

    -- Logo (ImageLabel - Asset ID)
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 20, 0, 20)
    Logo.Position = UDim2.new(0, 10, 0.5, -10)
    Logo.BackgroundTransparency = 1
    Logo.Image = LogoID
    Logo.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Text = WindowName
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 35, 0, 0)
    Title.TextColor3 = Color3.fromRGB(85, 170, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = Header

    -- Sürükleme Sistemi
    local dragToggle, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
    end)

    -- Sidebar (Sol Menü)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 170, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main

    local GameLabel = Instance.new("TextLabel")
    GameLabel.Text = "Grand Piece Online"
    GameLabel.Size = UDim2.new(1, 0, 0, 30)
    GameLabel.Position = UDim2.new(0, 15, 0, 5)
    GameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    GameLabel.Font = Enum.Font.GothamSemibold
    GameLabel.TextSize = 12
    GameLabel.TextXAlignment = Enum.TextXAlignment.Left
    GameLabel.BackgroundTransparency = 1
    GameLabel.Parent = Sidebar

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Size = UDim2.new(1, 0, 1, -40)
    TabHolder.Position = UDim2.new(0, 0, 0, 35)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 0
    TabHolder.Parent = Sidebar
    Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 2)

    -- İçerik Alanı
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -170, 1, -35)
    Container.Position = UDim2.new(0, 170, 0, 35)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Tabs = {}

    function Tabs:AddTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.Parent = TabHolder
        
        -- Mavi Aktiflik Çizgisi
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 2, 0, 14)
        Indicator.Position = UDim2.new(0, 12, 0.5, -7)
        Indicator.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
        Indicator.Visible = false
        Indicator.BorderSizePixel = 0
        Indicator.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40)
        Page.Parent = Container
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.Parent = Page
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") then 
                v.TextColor3 = Color3.fromRGB(150, 150, 150) 
                v.Frame.Visible = false
            end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Visible = true
        end)

        local Elements = {}

        function Elements:AddToggle(Name, Config)
            local Tgl = {Value = Config.Default or false}
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(0, 440, 0, 45)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ToggleFrame.BackgroundTransparency = 0.6
            ToggleFrame.Text = ""
            ToggleFrame.Parent = Page
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)

            local TTitle = Instance.new("TextLabel")
            TTitle.Text = Name
            TTitle.Size = UDim2.new(1, -50, 1, 0)
            TTitle.Position = UDim2.new(0, 15, 0, 0)
            TTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TTitle.Font = Enum.Font.GothamBold
            TTitle.TextSize = 13
            TTitle.BackgroundTransparency = 1
            TTitle.TextXAlignment = Enum.TextXAlignment.Left
            TTitle.Parent = ToggleFrame

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 18, 0, 18)
            Box.Position = UDim2.new(1, -30, 0.5, -9)
            Box.BackgroundColor3 = Tgl.Value and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(5, 5, 5)
            Box.Parent = ToggleFrame
            Instance.new("UIStroke", Box).Color = Color3.fromRGB(85, 170, 255)

            ToggleFrame.MouseButton1Click:Connect(function()
                Tgl.Value = not Tgl.Value
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Tgl.Value and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(5, 5, 5)}):Play()
                Config.Callback(Tgl.Value)
            end)
            return Tgl
        end

        return Elements
    end

    return Tabs
end

return Library
