local Library = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(Config)
    local WindowName = Config.Name or "Feral Hub"
    local LogoID = Config.LogoID or "rbxassetid://0" -- Görsel ID buraya gelecek

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FeralUI_Library"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Ana Panel
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 630, 0, 390)
    Main.Position = UDim2.new(0.5, -315, 0.5, -195)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.BackgroundTransparency = 0.15 -- Transparan Arka Plan
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 35, 35)
    Stroke.Thickness = 1
    Stroke.Parent = Main

    -- Üst Bar (Header)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 38)
    Header.BackgroundTransparency = 1
    Header.Parent = Main

    -- ASSET ID LOGO
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 22, 0, 22)
    Logo.Position = UDim2.new(0, 12, 0.5, -11)
    Logo.BackgroundTransparency = 1
    Logo.Image = LogoID
    Logo.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Text = WindowName
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 40, 0, 0)
    Title.TextColor3 = Color3.fromRGB(85, 170, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = Header

    -- Sürükleme (Drag) Sistemi
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

    -- Sidebar (Sol Bölüm)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -38)
    Sidebar.Position = UDim2.new(0, 0, 0, 38)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Size = UDim2.new(1, 0, 1, 0)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 0
    TabHolder.Parent = Sidebar
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 2)
    TabList.Parent = TabHolder

    -- İçerik Alanı
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -160, 1, -38)
    Container.Position = UDim2.new(0, 160, 0, 38)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Tabs = {}

    function Tabs:AddTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "          " .. TabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = TabHolder

        -- Aktif Tab Çizgisi
        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(0, 3, 0, 16)
        Line.Position = UDim2.new(0, 10, 0.5, -8)
        Line.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
        Line.Visible = false
        Line.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.Parent = Container
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") then 
                v.TextColor3 = Color3.fromRGB(150, 150, 150) 
                v.Frame.Visible = false
            end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Line.Visible = true
        end)

        local Elements = {}

        function Elements:AddToggle(Name, Config)
            local Tgl = {Value = Config.Default or false}
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(0, 440, 0, 42)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ToggleFrame.BackgroundTransparency = 0.5
            ToggleFrame.Text = ""
            ToggleFrame.Parent = Page
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)

            local TTitle = Instance.new("TextLabel")
            TTitle.Text = Name
            TTitle.Size = UDim2.new(1, -50, 1, 0)
            TTitle.Position = UDim2.new(0, 15, 0, 0)
            TTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
            TTitle.Font = Enum.Font.Gotham
            TTitle.TextSize = 13
            TTitle.BackgroundTransparency = 1
            TTitle.TextXAlignment = Enum.TextXAlignment.Left
            TTitle.Parent = ToggleFrame

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 16, 0, 16)
            Box.Position = UDim2.new(1, -30, 0.5, -8)
            Box.BackgroundColor3 = Tgl.Value and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(0, 0, 0)
            Box.Parent = ToggleFrame
            Instance.new("UIStroke", Box).Color = Color3.fromRGB(85, 170, 255)

            ToggleFrame.MouseButton1Click:Connect(function()
                Tgl.Value = not Tgl.Value
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Tgl.Value and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(0, 0, 0)}):Play()
                Config.Callback(Tgl.Value)
            end)
            return Tgl
        end

        return Elements
    end

    return Tabs
end

return Library
