-- Feral Library (Asset ID Support)
local FeralLib = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function FeralLib:CreateWindow(Config)
    local WindowName = Config.Name or "Feral Hub"
    local LogoID = Config.LogoID or "rbxassetid://0" -- Varsayılan boş asset

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FeralUI_Updated"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 630, 0, 390)
    Main.Position = UDim2.new(0.5, -315, 0.5, -195)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.BackgroundTransparency = 0.15 -- İstediğin transparanlık
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Main
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 45)
    Stroke.Thickness = 1
    Stroke.Parent = Main

    -- Header (Logo ve Başlık Alanı)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 38)
    Header.BackgroundTransparency = 1
    Header.Parent = Main

    -- GÜL YERİNE GELEN IMAGE (Asset ID Alanı)
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

    -- Sürükleme Mantığı (Draggable)
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

    -- Sidebar ve İçerik (Kısaltılmış Mantık)
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
    Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 2)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -160, 1, -38)
    Container.Position = UDim2.new(0, 160, 0, 38)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Library = {Tabs = {}}

    function Library:AddTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "          " .. TabName
        TabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = TabHolder

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.Parent = Container
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(160, 160, 160) end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local TabItems = {}
        function TabItems:AddToggle(Name, Config)
            local Tgl = {Value = Config.Default or false}
            local Frame = Instance.new("TextButton") -- Tıklanabilir alan geniş olsun diye TextButton
            Frame.Size = UDim2.new(0, 440, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Frame.BackgroundTransparency = 0.4
            Frame.Text = ""
            Frame.Parent = Page
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

            local Lbl = Instance.new("TextLabel")
            Lbl.Text = Name
            Lbl.Size = UDim2.new(1, -50, 1, 0)
            Lbl.Position = UDim2.new(0, 15, 0, 0)
            Lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 13
            Lbl.BackgroundTransparency = 1
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Frame

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 16, 0, 16)
            Box.Position = UDim2.new(1, -30, 0.5, -8)
            Box.BackgroundColor3 = Tgl.Value and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(0, 0, 0)
            Box.Parent = Frame
            Instance.new("UIStroke", Box).Color = Color3.fromRGB(85, 170, 255)

            Frame.MouseButton1Click:Connect(function()
                Tgl.Value = not Tgl.Value
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Tgl.Value and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(0, 0, 0)}):Play()
                Config.Callback(Tgl.Value)
            end)
            return Tgl
        end
        return TabItems
    end
    return Library
end

return FeralLib
