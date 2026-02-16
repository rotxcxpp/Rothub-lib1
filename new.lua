-- ════════════════════════════════════════════════════════════════
--   ROTHUB / FERAL UI LIBRARY
--   Loading Screen + Menu
-- ════════════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

local C = {
    BgMain     = Color3.fromRGB(22, 22, 35),
    BgRowHov   = Color3.fromRGB(30, 30, 48),
    Sidebar    = Color3.fromRGB(17, 17, 27),
    Header     = Color3.fromRGB(17, 17, 27),
    Border     = Color3.fromRGB(44, 44, 68),
    Accent     = Color3.fromRGB(74, 122, 255),
    TxtMain    = Color3.fromRGB(220, 222, 246),
    TxtSub     = Color3.fromRGB(95, 98, 152),
    TxtMuted   = Color3.fromRGB(68, 68, 115),
    TxtTab     = Color3.fromRGB(255, 255, 255),
    TxtTabOff  = Color3.fromRGB(115, 115, 170),
    ChkBg      = Color3.fromRGB(13, 13, 22),
    ChkBorder  = Color3.fromRGB(52, 52, 88),
    SliderBg   = Color3.fromRGB(28, 28, 50),
    SliderFill = Color3.fromRGB(74, 122, 255),
    InputBg    = Color3.fromRGB(13, 13, 22),
    InputBord  = Color3.fromRGB(44, 44, 68),
    BtnBg      = Color3.fromRGB(22, 22, 38),
    BtnBord    = Color3.fromRGB(52, 52, 88),
    BtnHov     = Color3.fromRGB(32, 32, 52),
    Divider    = Color3.fromRGB(44, 44, 68),
    AvatarPink = Color3.fromRGB(230, 155, 188),
    White      = Color3.fromRGB(255, 255, 255),
    LoadingBar = Color3.fromRGB(220, 80, 80),
    LoadingBg  = Color3.fromRGB(60, 60, 80),
}

local function New(cls, props, kids)
    local o = Instance.new(cls)
    for k,v in pairs(props or {}) do if k~="Parent" then o[k]=v end end
    for _,c in ipairs(kids or {}) do c.Parent=o end
    if props and props.Parent then o.Parent=props.Parent end
    return o
end

local function Tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or .14, Enum.EasingStyle.Quad), props):Play()
end

local function Drag(frame, handle)
    local drag, di, mp, fp = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag=true; mp=i.Position; fp=frame.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement then di=i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i==di and drag then
            local d=i.Position-mp
            frame.Position=UDim2.new(fp.X.Scale,fp.X.Offset+d.X,fp.Y.Scale,fp.Y.Offset+d.Y)
        end
    end)
end

-- ══════════════════════════════════════
-- LOADING SCREEN
-- ══════════════════════════════════════
local function ShowLoadingScreen(gui, callback)
    local LoadFrame = New("Frame", {
        Name = "LoadingScreen",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0,
        ZIndex = 50,
        Parent = gui,
    })

    -- Blur arka plan efekti
    local blur = New("BlurEffect", {
        Name = "FeralBlur",
        Size = 20,
        Parent = game:GetService("Lighting"),
    })

    -- Üst çizgi (beyaz dekoratif)
    local TopLine = New("Frame", {
        Size = UDim2.new(0, 200, 0, 2),
        Position = UDim2.new(0.5, -100, 0.5, -50),
        BackgroundColor3 = Color3.fromRGB(180, 180, 200),
        BorderSizePixel = 0,
        ZIndex = 51,
        Parent = LoadFrame,
    })

    -- ROTHUB harfleri
    local letters = {"R", "O", "T", "H", "U", "B"}
    local letterLabels = {}
    local totalWidth = #letters * 55
    local startX = -totalWidth / 2

    local LetterContainer = New("Frame", {
        Size = UDim2.new(0, totalWidth, 0, 70),
        Position = UDim2.new(0.5, startX, 0.5, -40),
        BackgroundTransparency = 1,
        ZIndex = 51,
        Parent = LoadFrame,
    })

    for i, letter in ipairs(letters) do
        local lbl = New("TextLabel", {
            Size = UDim2.new(0, 50, 0, 70),
            Position = UDim2.new(0, (i - 1) * 55, 0, 0),
            BackgroundTransparency = 1,
            Text = letter,
            Font = Enum.Font.GothamBold,
            TextSize = 52,
            TextColor3 = C.White,
            ZIndex = 52,
            Parent = LetterContainer,
        })
        table.insert(letterLabels, lbl)
    end

    -- Alt kırmızı loading bar
    local BarBg = New("Frame", {
        Size = UDim2.new(0, 260, 0, 3),
        Position = UDim2.new(0.5, -130, 0.5, 40),
        BackgroundColor3 = C.LoadingBg,
        BorderSizePixel = 0,
        ZIndex = 51,
        Parent = LoadFrame,
    })
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BarBg})

    local BarFill = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = C.LoadingBar,
        BorderSizePixel = 0,
        ZIndex = 52,
        Parent = BarBg,
    })
    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BarFill})

    -- Status yazısı
    local StatusLabel = New("TextLabel", {
        Size = UDim2.new(0, 260, 0, 18),
        Position = UDim2.new(0.5, -130, 0.5, 48),
        BackgroundTransparency = 1,
        Text = "loading assets...",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(140, 140, 170),
        ZIndex = 51,
        Parent = LoadFrame,
    })

    -- Harf animasyonu (yukarı aşağı bounce)
    local bounceConn
    local startTime = tick()
    bounceConn = RunService.RenderStepped:Connect(function()
        local t = tick() - startTime
        for i, lbl in ipairs(letterLabels) do
            local offset = math.sin((t * 3) + (i * 0.6)) * 10
            lbl.Position = UDim2.new(0, (i - 1) * 55, 0, offset)
        end
    end)

    -- Loading bar animasyonu
    local loadStages = {
        {pct = 0.2,  text = "loading assets..."},
        {pct = 0.4,  text = "checking executor..."},
        {pct = 0.6,  text = "initializing modules..."},
        {pct = 0.8,  text = "preparing interface..."},
        {pct = 1.0,  text = "done!"},
    }

    task.spawn(function()
        for _, stage in ipairs(loadStages) do
            StatusLabel.Text = stage.text
            Tw(BarFill, {Size = UDim2.new(stage.pct, 0, 1, 0)}, 0.4)
            task.wait(0.6)
        end

        task.wait(0.3)

        -- Bounce animasyonu durdur
        if bounceConn then bounceConn:Disconnect() end

        -- Fade out
        Tw(LoadFrame, {BackgroundTransparency = 1}, 0.4)
        for _, lbl in ipairs(letterLabels) do
            Tw(lbl, {TextTransparency = 1}, 0.3)
        end
        Tw(TopLine, {BackgroundTransparency = 1}, 0.3)
        Tw(BarBg, {BackgroundTransparency = 1}, 0.3)
        Tw(BarFill, {BackgroundTransparency = 1}, 0.3)
        Tw(StatusLabel, {TextTransparency = 1}, 0.3)
        Tw(blur, {Size = 0}, 0.4)

        task.wait(0.5)
        LoadFrame:Destroy()
        blur:Destroy()

        if callback then callback() end
    end)
end

-- ══════════════════════════════════════
-- FERAL LIBRARY
-- ══════════════════════════════════════
local Feral = {}

function Feral:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title  or "Feral"
    local game_ = cfg.Game   or "Game"
    local W     = cfg.Width  or 640
    local H     = cfg.Height or 390
    local HDR_H = 40
    local SB_W  = 130

    pcall(function()
        if game.CoreGui:FindFirstChild("FeralMenu") then
            game.CoreGui.FeralMenu:Destroy()
        end
    end)

    local GUI = New("ScreenGui", {
        Name="FeralMenu", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        DisplayOrder=999,
        Parent=game.CoreGui,
    })

    -- Ana menu frame (başta gizli)
    local Main = New("Frame", {
        Size=UDim2.new(0,W,0,H),
        Position=UDim2.new(0.5,-W/2,0.5,-H/2),
        BackgroundColor3=C.BgMain,
        BorderSizePixel=0, ClipsDescendants=true,
        Visible=false,
        Parent=GUI,
    },{
        New("UICorner",{CornerRadius=UDim.new(0,8)}),
        New("UIStroke",{Color=C.Border,Thickness=1}),
    })

    -- HEADER
    local Hdr = New("Frame",{
        Size=UDim2.new(1,0,0,HDR_H),
        BackgroundColor3=C.Header,
        BorderSizePixel=0, ZIndex=3, Parent=Main,
    },{New("UICorner",{CornerRadius=UDim.new(0,8)})})
    New("Frame",{Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0.5,0),
        BackgroundColor3=C.Header,BorderSizePixel=0,ZIndex=3,Parent=Hdr})
    New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=C.Border,BorderSizePixel=0,ZIndex=4,Parent=Hdr})

    local _iconF=New("Frame",{Size=UDim2.new(0,26,0,26),Position=UDim2.new(0,10,0,7),
        BackgroundColor3=C.AvatarPink,BorderSizePixel=0,ZIndex=4,Parent=Hdr})
    New("UICorner",{CornerRadius=UDim.new(1,0),Parent=_iconF})
    if cfg.Icon then
        local _img=New("ImageLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            Image=cfg.Icon,ScaleType=Enum.ScaleType.Fit,ZIndex=5,Parent=_iconF})
        New("UICorner",{CornerRadius=UDim.new(1,0),Parent=_img})
    else
        New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            Text="🐱",TextScaled=true,Font=Enum.Font.GothamBold,
            TextColor3=C.White,ZIndex=5,Parent=_iconF})
    end
    New("TextLabel",{Size=UDim2.new(0,80,1,0),Position=UDim2.new(0,40,0,0),
        BackgroundTransparency=1,Text=title,Font=Enum.Font.GothamBold,
        TextSize=15,TextColor3=C.White,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=Hdr})

    local SettBtn=New("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-58,0,6),
        BackgroundTransparency=1,Text="⚙",TextSize=15,Font=Enum.Font.GothamBold,
        TextColor3=C.TxtMuted,ZIndex=4,Parent=Hdr})
    local ClsBtn=New("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-28,0,6),
        BackgroundTransparency=1,Text="✕",TextSize=13,Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(200,75,75),ZIndex=4,Parent=Hdr})

    ClsBtn.MouseButton1Click:Connect(function()
        Tw(Main,{Size=UDim2.new(0,W,0,0),Position=UDim2.new(0.5,-W/2,0.5,0)},.18)
        task.delay(.2,function() GUI.Enabled=false end)
    end)
    SettBtn.MouseEnter:Connect(function() Tw(SettBtn,{TextColor3=C.White},.1) end)
    SettBtn.MouseLeave:Connect(function() Tw(SettBtn,{TextColor3=C.TxtMuted},.1) end)
    Drag(Main, Hdr)

    local Body=New("Frame",{
        Size=UDim2.new(1,0,1,-HDR_H),Position=UDim2.new(0,0,0,HDR_H),
        BackgroundTransparency=1,ClipsDescendants=true,Parent=Main,
    })

    -- SIDEBAR
    local SB=New("Frame",{
        Size=UDim2.new(0,SB_W,1,0),
        BackgroundColor3=C.Sidebar,BorderSizePixel=0,Parent=Body,
    },{New("UIStroke",{Color=C.Border,Thickness=1})})

    New("TextLabel",{Size=UDim2.new(1,-10,0,28),Position=UDim2.new(0,10,0,4),
        BackgroundTransparency=1,Text=game_,
        Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.TxtMuted,
        TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Parent=SB})

    local TabList=New("Frame",{
        Size=UDim2.new(1,0,1,-32),Position=UDim2.new(0,0,0,32),
        BackgroundTransparency=1,Parent=SB,
    },{New("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder})})

    -- PANEL
    local Panel=New("Frame",{
        Size=UDim2.new(1,-SB_W,1,0),Position=UDim2.new(0,SB_W,0,0),
        BackgroundColor3=Color3.fromRGB(22,22,35),
        BackgroundTransparency=0,BorderSizePixel=0,Parent=Body,
    })
    local TitleRow=New("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=Panel})
    local TitleLbl=New("TextLabel",{
        Size=UDim2.new(1,-36,1,0),Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,Text="",
        Font=Enum.Font.GothamBold,TextSize=14,TextColor3=C.White,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=TitleRow,
    })
    New("TextLabel",{Size=UDim2.new(0,22,1,0),Position=UDim2.new(1,-26,0,0),
        BackgroundTransparency=1,Text="🔍",TextSize=14,
        Font=Enum.Font.GothamBold,TextColor3=C.TxtMuted,Parent=TitleRow})
    New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=C.Divider,BorderSizePixel=0,Parent=TitleRow})

    local TabBtns  = {}
    local TabOrder = 0
    local ActiveTab = nil

    local function SwitchTab(tabData)
        for _, b in pairs(TabBtns) do
            Tw(b.Lbl,{TextColor3=C.TxtTabOff},.12)
            b.Ind.Visible=false; b.Abg.Visible=false
            b.Lbl.Font=Enum.Font.Gotham
        end
        local b = TabBtns[tabData._name]
        Tw(b.Lbl,{TextColor3=C.TxtTab},.12)
        b.Ind.Visible=true; b.Abg.Visible=true
        b.Lbl.Font=Enum.Font.GothamBold
        TitleLbl.Text=tabData._name.." Tab"
        if ActiveTab and ActiveTab._scroll then
            ActiveTab._scroll.Visible=false
        end
        tabData._scroll.Visible=true
        ActiveTab=tabData
    end

    local Window = {_gui=GUI, _main=Main, _tabs={}}

    function Window:Toggle()
        GUI.Enabled = not GUI.Enabled
    end

    function Window:Destroy()
        GUI:Destroy()
    end

    function Window:AddTab(name)
        TabOrder += 1

        local TBtn=New("Frame",{
            Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,
            LayoutOrder=TabOrder,Parent=TabList,
        })
        local Ind=New("Frame",{
            Size=UDim2.new(0,2,0.6,0),Position=UDim2.new(0,0,0.2,0),
            BackgroundColor3=C.Accent,BorderSizePixel=0,Visible=false,Parent=TBtn,
        })
        local Abg=New("Frame",{
            Size=UDim2.new(1,0,1,0),
            BackgroundColor3=Color3.fromRGB(55,95,210),
            BackgroundTransparency=0.88,BorderSizePixel=0,Visible=false,Parent=TBtn,
        })
        local Lbl=New("TextLabel",{
            Size=UDim2.new(1,-12,1,0),Position=UDim2.new(0,12,0,0),
            BackgroundTransparency=1,Text=name,
            Font=Enum.Font.Gotham,TextSize=14,
            TextColor3=C.TxtTabOff,TextXAlignment=Enum.TextXAlignment.Left,Parent=TBtn,
        })
        local BtnClick=New("TextButton",{Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,Text="",Parent=TBtn})

        TabBtns[name]={Lbl=Lbl,Ind=Ind,Abg=Abg}

        local TabScroll=New("ScrollingFrame",{
            Size=UDim2.new(1,0,1,-30),Position=UDim2.new(0,0,0,30),
            BackgroundTransparency=1,
            ScrollBarThickness=3,ScrollBarImageColor3=C.Border,
            BorderSizePixel=0,
            CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            Visible=false,Parent=Panel,
        },{New("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder})})

        local Tab={_name=name, _scroll=TabScroll, _order=0}

        BtnClick.MouseButton1Click:Connect(function() SwitchTab(Tab) end)
        BtnClick.MouseEnter:Connect(function()
            if not Ind.Visible then Tw(Lbl,{TextColor3=C.White},.1) end
        end)
        BtnClick.MouseLeave:Connect(function()
            if not Ind.Visible then Tw(Lbl,{TextColor3=C.TxtTabOff},.1) end
        end)

        if TabOrder==1 then SwitchTab(Tab) end

        -- SECTION
        function Tab:AddSection(label)
            self._order+=1
            local F=New("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,
                LayoutOrder=self._order,Parent=TabScroll})
            New("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Divider,
                BorderSizePixel=0,Parent=F})
            New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                Text=label,Font=Enum.Font.GothamBold,TextSize=12,
                TextColor3=C.Accent,Parent=F})
        end

        -- TOGGLE
        function Tab:AddToggle(id, opts)
            opts=opts or {}
            local title=opts.Title or id
            local desc=opts.Desc or nil
            local value=opts.Default or false
            local callbacks={}

            self._order+=1
            local hd=desc~=nil
            local rh=hd and 52 or 36

            local Row=New("Frame",{Size=UDim2.new(1,0,0,rh),BackgroundTransparency=1,
                LayoutOrder=self._order,Parent=TabScroll})
            New("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Divider,
                BorderSizePixel=0,Parent=Row})
            New("TextLabel",{
                Size=UDim2.new(1,-50,0,18),
                Position=UDim2.new(0,14,0,hd and 7 or 9),
                BackgroundTransparency=1,Text=title,
                Font=Enum.Font.GothamBold,TextSize=13,
                TextColor3=C.TxtMain,TextXAlignment=Enum.TextXAlignment.Left,Parent=Row,
            })
            if hd then
                New("TextLabel",{
                    Size=UDim2.new(1,-50,0,14),Position=UDim2.new(0,14,0,26),
                    BackgroundTransparency=1,Text=desc,
                    Font=Enum.Font.Gotham,TextSize=10.5,
                    TextColor3=C.TxtSub,TextXAlignment=Enum.TextXAlignment.Left,
                    TextWrapped=true,Parent=Row,
                })
            end
            local ChkBg=New("Frame",{
                Size=UDim2.new(0,16,0,16),
                Position=UDim2.new(1,-30,0,hd and 18 or 10),
                BackgroundColor3=C.BgMain,BorderSizePixel=0,Parent=Row,
            },{
                New("UICorner",{CornerRadius=UDim.new(0,3)}),
                New("UIStroke",{Color=C.ChkBorder,Thickness=1.5}),
            })
            local Tick=New("Frame",{
                Size=UDim2.new(0,8,0,8),Position=UDim2.new(0.5,-4,0.5,-4),
                BackgroundColor3=C.Accent,BorderSizePixel=0,
                Visible=value,Parent=ChkBg,
            },{New("UICorner",{CornerRadius=UDim.new(0,2)})})
            local Str=ChkBg:FindFirstChildOfClass("UIStroke")

            local function UpdateVisual()
                Tick.Visible=value
                Tw(Str,{Color=value and C.Accent or C.ChkBorder},.12)
                Tw(ChkBg,{BackgroundColor3=value and C.ChkBg or C.BgMain},.12)
            end
            UpdateVisual()

            local BtnClick=New("TextButton",{Size=UDim2.new(1,0,1,0),
                BackgroundTransparency=1,Text="",Parent=Row})
            BtnClick.MouseButton1Click:Connect(function()
                value=not value
                UpdateVisual()
                for _,cb in ipairs(callbacks) do task.spawn(cb,value) end
            end)
            BtnClick.MouseEnter:Connect(function() Tw(Row,{BackgroundColor3=C.BgRowHov},.1); Row.BackgroundTransparency=0 end)
            BtnClick.MouseLeave:Connect(function() Row.BackgroundTransparency=1 end)

            local Toggle={}
            function Toggle:OnChanged(fn) table.insert(callbacks,fn) end
            function Toggle:Set(v)
                value=v; UpdateVisual()
                for _,cb in ipairs(callbacks) do task.spawn(cb,value) end
            end
            function Toggle:Get() return value end
            return Toggle
        end

        -- SLIDER
        function Tab:AddSlider(id, opts)
            opts=opts or {}
            local title=opts.Title or id
            local min=opts.Min or 0
            local max=opts.Max or 100
            local value=math.clamp(opts.Default or min, min, max)
            local callbacks={}

            self._order+=1
            local Row=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundTransparency=1,
                LayoutOrder=self._order,Parent=TabScroll})
            New("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Divider,
                BorderSizePixel=0,Parent=Row})
            New("TextLabel",{
                Size=UDim2.new(1,-70,0,16),Position=UDim2.new(0,14,0,8),
                BackgroundTransparency=1,Text=title,
                Font=Enum.Font.GothamBold,TextSize=13,
                TextColor3=C.TxtMain,TextXAlignment=Enum.TextXAlignment.Left,Parent=Row,
            })
            local VBox=New("Frame",{Size=UDim2.new(0,50,0,16),Position=UDim2.new(1,-62,0,9),
                BackgroundColor3=C.BgRowHov,BorderSizePixel=0,Parent=Row,
            },{New("UICorner",{CornerRadius=UDim.new(0,3)})})
            local VLbl=New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                Text=tostring(value),Font=Enum.Font.Gotham,TextSize=11,
                TextColor3=C.TxtSub,Parent=VBox})
            local Track=New("Frame",{
                Size=UDim2.new(1,-28,0,5),Position=UDim2.new(0,14,0,36),
                BackgroundColor3=C.SliderBg,BorderSizePixel=0,Parent=Row,
            },{New("UICorner",{CornerRadius=UDim.new(1,0)})})
            local pct=(value-min)/(max-min)
            local Fill=New("Frame",{Size=UDim2.new(pct,0,1,0),
                BackgroundColor3=C.SliderFill,BorderSizePixel=0,Parent=Track,
            },{New("UICorner",{CornerRadius=UDim.new(1,0)})})
            local Knob=New("Frame",{
                Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(pct,0,0.5,0),
                BackgroundColor3=C.White,BorderSizePixel=0,Parent=Track,
            },{New("UICorner",{CornerRadius=UDim.new(1,0)})})

            local sliding=false
            local function UpdateSlider(xPos)
                local rel=math.clamp((xPos-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
                value=math.floor(min+rel*(max-min))
                VLbl.Text=tostring(value)
                Fill.Size=UDim2.new(rel,0,1,0)
                Knob.Position=UDim2.new(rel,0,0.5,0)
                for _,cb in ipairs(callbacks) do task.spawn(cb,value) end
            end

            local SBtn=New("TextButton",{Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0,30),
                BackgroundTransparency=1,Text="",Parent=Row})
            SBtn.MouseButton1Down:Connect(function() sliding=true; UpdateSlider(Mouse.X) end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then UpdateSlider(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
            end)

            local Slider={}
            function Slider:OnChanged(fn) table.insert(callbacks,fn) end
            function Slider:Set(v)
                value=math.clamp(v,min,max)
                local rel=(value-min)/(max-min)
                VLbl.Text=tostring(value)
                Fill.Size=UDim2.new(rel,0,1,0)
                Knob.Position=UDim2.new(rel,0,0.5,0)
                for _,cb in ipairs(callbacks) do task.spawn(cb,value) end
            end
            function Slider:Get() return value end
            return Slider
        end

        -- INPUT
        function Tab:AddInput(id, opts)
            opts=opts or {}
            local title=opts.Title or id
            local value=opts.Default or ""
            local callbacks={}

            self._order+=1
            local Row=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundTransparency=1,
                LayoutOrder=self._order,Parent=TabScroll})
            New("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Divider,
                BorderSizePixel=0,Parent=Row})
            New("TextLabel",{
                Size=UDim2.new(1,-20,0,16),Position=UDim2.new(0,14,0,6),
                BackgroundTransparency=1,Text=title,
                Font=Enum.Font.GothamBold,TextSize=13,
                TextColor3=C.TxtMain,TextXAlignment=Enum.TextXAlignment.Left,Parent=Row,
            })
            local IBg=New("Frame",{
                Size=UDim2.new(1,-28,0,22),Position=UDim2.new(0,14,0,26),
                BackgroundColor3=C.InputBg,BorderSizePixel=0,Parent=Row,
            },{
                New("UICorner",{CornerRadius=UDim.new(0,4)}),
                New("UIStroke",{Color=C.InputBord,Thickness=1}),
            })
            local TB=New("TextBox",{
                Size=UDim2.new(1,-12,1,0),Position=UDim2.new(0,6,0,0),
                BackgroundTransparency=1,Text=value,
                Font=Enum.Font.Gotham,TextSize=12,TextColor3=C.TxtMain,
                PlaceholderText="",PlaceholderColor3=C.TxtMuted,
                TextXAlignment=Enum.TextXAlignment.Left,
                ClearTextOnFocus=false,Parent=IBg,
            })
            local Str=IBg:FindFirstChildOfClass("UIStroke")
            TB.Focused:Connect(function() Tw(Str,{Color=C.Accent},.14) end)
            TB.FocusLost:Connect(function()
                value=TB.Text
                Tw(Str,{Color=C.InputBord},.14)
                for _,cb in ipairs(callbacks) do task.spawn(cb,value) end
            end)

            local Input={}
            function Input:OnChanged(fn) table.insert(callbacks,fn) end
            function Input:Set(v) value=v; TB.Text=v end
            function Input:Get() return value end
            return Input
        end

        -- BUTTON
        function Tab:AddButton(id, opts)
            opts=opts or {}
            local title=opts.Title or id
            local desc=opts.Desc or nil
            local callback=opts.Callback or function() end

            self._order+=1
            local hd=desc~=nil
            local rh=hd and 52 or 36

            local Row=New("Frame",{Size=UDim2.new(1,0,0,rh),BackgroundTransparency=1,
                LayoutOrder=self._order,Parent=TabScroll})
            New("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Divider,
                BorderSizePixel=0,Parent=Row})
            local BtnFrame=New("Frame",{
                Size=UDim2.new(1,-28,0,rh-14),Position=UDim2.new(0,14,0,7),
                BackgroundColor3=C.BtnBg,BorderSizePixel=0,Parent=Row,
            },{
                New("UICorner",{CornerRadius=UDim.new(0,5)}),
                New("UIStroke",{Color=C.BtnBord,Thickness=1}),
            })
            New("TextLabel",{
                Size=UDim2.new(1,-12,0,hd and 18 or rh-14),
                Position=UDim2.new(0,10,0,hd and 4 or 0),
                BackgroundTransparency=1,Text=title,
                Font=Enum.Font.GothamBold,TextSize=13,
                TextColor3=C.TxtMain,TextXAlignment=Enum.TextXAlignment.Left,Parent=BtnFrame,
            })
            if hd then
                New("TextLabel",{
                    Size=UDim2.new(1,-12,0,13),Position=UDim2.new(0,10,0,22),
                    BackgroundTransparency=1,Text=desc,
                    Font=Enum.Font.Gotham,TextSize=10,
                    TextColor3=C.TxtSub,TextXAlignment=Enum.TextXAlignment.Left,
                    TextWrapped=true,Parent=BtnFrame,
                })
            end
            local BtnClick=New("TextButton",{Size=UDim2.new(1,0,1,0),
                BackgroundTransparency=1,Text="",Parent=BtnFrame})
            BtnClick.MouseButton1Click:Connect(function()
                Tw(BtnFrame,{BackgroundColor3=C.Accent},.08)
                task.delay(.12,function() Tw(BtnFrame,{BackgroundColor3=C.BtnBg},.12) end)
                task.spawn(callback)
            end)
            BtnClick.MouseEnter:Connect(function() Tw(BtnFrame,{BackgroundColor3=C.BtnHov},.1) end)
            BtnClick.MouseLeave:Connect(function() Tw(BtnFrame,{BackgroundColor3=C.BtnBg},.1) end)

            local Button={}
            function Button:SetCallback(fn) callback=fn end
            return Button
        end

        table.insert(Window._tabs, Tab)
        return Tab
    end

    -- Loading screen göster, bitince menüyü aç
    ShowLoadingScreen(GUI, function()
        Main.Visible = true
        Main.Size = UDim2.new(0, W, 0, 0)
        Main.Position = UDim2.new(0.5, -W/2, 0.5, 0)
        Tw(Main, {Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W/2, 0.5, -H/2)}, .25)
    end)

    return Window
end

return Feral