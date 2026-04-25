-- ============================================================================
-- ROBLOX SCRIPT HUB - Production Quality Implementation
-- Compatible with Delta Executor on Chromebook
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local Config = {
    CorrectKey = "123",
    Theme = {
        Primary = Color3.fromRGB(138, 43, 226),      -- Purple
        Secondary = Color3.fromRGB(75, 0, 130),      -- Indigo
        Accent = Color3.fromRGB(0, 191, 255),        -- DeepSkyBlue
        Dark = Color3.fromRGB(20, 20, 20),           -- Nearly Black
        Light = Color3.fromRGB(240, 240, 240),       -- Nearly White
        Success = Color3.fromRGB(50, 205, 50),       -- LimeGreen
        Danger = Color3.fromRGB(220, 20, 60),        -- Crimson
        Warning = Color3.fromRGB(255, 165, 0),       -- Orange
    },
    Padding = 10,
    CornerRadius = UDim.new(0, 8),
    TransitionSpeed = 0.3,
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local UI = {}

function UI.Create(ClassName, Properties)
    local Instance = Instance.new(ClassName)
    for Property, Value in pairs(Properties or {}) do
        Instance[Property] = Value
    end
    return Instance
end

function UI.CreateFrame(Parent, Properties)
    Properties = Properties or {}
    local Frame = UI.Create("Frame", {
        Parent = Parent,
        BackgroundColor3 = Properties.BackgroundColor3 or Config.Theme.Dark,
        BackgroundTransparency = Properties.BackgroundTransparency or 0.1,
        BorderSizePixel = 0,
        Size = Properties.Size or UDim2.new(1, 0, 1, 0),
        Position = Properties.Position or UDim2.new(0, 0, 0, 0),
    })
    
    if Properties.CornerRadius ~= false then
        UI.Create("UICorner", {
            Parent = Frame,
            CornerRadius = Properties.CornerRadius or Config.CornerRadius,
        })
    end
    
    if Properties.UseStroke then
        UI.Create("UIStroke", {
            Parent = Frame,
            Color = Config.Theme.Accent,
            Thickness = 1.5,
            Transparency = 0.7,
        })
    end
    
    return Frame
end

function UI.CreateLabel(Parent, Properties)
    Properties = Properties or {}
    local Label = UI.Create("TextLabel", {
        Parent = Parent,
        BackgroundTransparency = 1,
        TextColor3 = Properties.TextColor3 or Config.Theme.Light,
        TextSize = Properties.TextSize or 14,
        Font = Enum.Font.GothamMedium,
        Text = Properties.Text or "",
        Size = Properties.Size or UDim2.new(1, 0, 0, 30),
        Position = Properties.Position or UDim2.new(0, 0, 0, 0),
        TextXAlignment = Properties.TextXAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = Properties.TextYAlignment or Enum.TextYAlignment.Center,
    })
    return Label
end

function UI.CreateButton(Parent, Properties)
    Properties = Properties or {}
    local Button = UI.Create("TextButton", {
        Parent = Parent,
        Size = Properties.Size or UDim2.new(0, 120, 0, 40),
        Position = Properties.Position,
        BackgroundColor3 = Properties.BackgroundColor3 or Config.Theme.Primary,
        BorderSizePixel = 0,
        Text = Properties.Text or "Button",
        TextColor3 = Properties.TextColor3 or Config.Theme.Dark,
        TextSize = Properties.TextSize or 13,
        Font = Properties.Font or Enum.Font.GothamMedium,
        AutoButtonColor = false,
    })
    
    UI.Create("UICorner", {
        Parent = Button,
        CornerRadius = Properties.CornerRadius or Config.CornerRadius,
    })
    
    if Properties.UseStroke then
        UI.Create("UIStroke", {
            Parent = Button,
            Color = Properties.StrokeColor or Config.Theme.Accent,
            Thickness = Properties.StrokeThickness or 1.5,
            Transparency = Properties.StrokeTransparency or 0.6,
        })
    end
    
    local OriginalColor = Properties.BackgroundColor3 or Config.Theme.Primary
    local HoverColor = Properties.HoverColor or Config.Theme.Accent
    
    local function OnHover()
        local Tween = TweenService:Create(Button, TweenInfo.new(Config.TransitionSpeed), {BackgroundColor3 = HoverColor})
        Tween:Play()
    end
    
    local function OnLeave()
        local Tween = TweenService:Create(Button, TweenInfo.new(Config.TransitionSpeed), {BackgroundColor3 = OriginalColor})
        Tween:Play()
    end
    
    Button.MouseEnter:Connect(OnHover)
    Button.MouseLeave:Connect(OnLeave)
    
    if Properties.Callback then
        Button.MouseButton1Click:Connect(Properties.Callback)
    end
    
    Button.Name = Properties.Name or "Button"
    return Button
end

function UI.CreateTextBox(Parent, Properties)
    Properties = Properties or {}
    local TextBox = UI.Create("TextBox", {
        Parent = Parent,
        BackgroundColor3 = Config.Theme.Secondary,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        TextColor3 = Config.Theme.Light,
        TextSize = 16,
        Font = Enum.Font.GothamMedium,
        PlaceholderText = Properties.PlaceholderText or "Enter text...",
        PlaceholderColor3 = Config.Theme.Light,
        Size = Properties.Size or UDim2.new(1, -20, 0, 40),
        Position = Properties.Position or UDim2.new(0, 10, 0, 0),
        Text = "",
    })
    
    UI.Create("UICorner", {
        Parent = TextBox,
        CornerRadius = Config.CornerRadius,
    })
    
    UI.Create("UIStroke", {
        Parent = TextBox,
        Color = Config.Theme.Accent,
        Thickness = 1.5,
        Transparency = 0.7,
    })
    
    return TextBox
end

function UI.Notify(Message, Duration)
    Duration = Duration or 2
    local Notification = UI.CreateFrame(PlayerGui, {
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, -330, 0, 20),
        BackgroundColor3 = Config.Theme.Primary,
        UseStroke = true,
    })
    
    UI.CreateLabel(Notification, {
        Text = Message,
        TextSize = 14,
        Size = UDim2.new(1, 0, 1, 0),
    })
    
    local TweenIn = TweenService:Create(Notification, TweenInfo.new(0.3), {Position = UDim2.new(1, -330, 0, 20)})
    TweenIn:Play()
    
    task.wait(Duration)
    
    local TweenOut = TweenService:Create(Notification, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0, 20)})
    TweenOut:Play()
    TweenOut.Completed:Connect(function()
        Notification:Destroy()
    end)
end

-- ============================================================================
-- KEY SYSTEM
-- ============================================================================

local KeySystem = {}
KeySystem.Attempts = 0
KeySystem.MaxAttempts = 3

function KeySystem.Show()
    KeySystem.Attempts = 0

    local ScreenGui = UI.Create("ScreenGui", {
        Parent = PlayerGui,
        ResetOnSpawn = false,
        Name = "KeySystemGui",
    })

    local Overlay = UI.CreateFrame(ScreenGui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.7,
        CornerRadius = false,
    })

    local KeyPanel = UI.CreateFrame(Overlay, {
        Size = UDim2.new(0, 380, 0, 300),
        Position = UDim2.new(0.5, -190, 0.5, -150),
        BackgroundColor3 = Config.Theme.Dark,
        UseStroke = true,
    })

    local Header = UI.CreateFrame(KeyPanel, {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        UseStroke = false,
        CornerRadius = false,
    })

    local Title = UI.CreateLabel(Header, {
        Text = "🔐 KEY SYSTEM",
        TextSize = 19,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextColor3 = Config.Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local Description = UI.CreateLabel(KeyPanel, {
        Text = "Enter the correct key and press SUBMIT or Enter.",
        TextSize = 13,
        Position = UDim2.new(0, 10, 0, 75),
        Size = UDim2.new(1, -20, 0, 35),
        TextColor3 = Config.Theme.Light,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local KeyInput = UI.CreateTextBox(KeyPanel, {
        Size = UDim2.new(1, -20, 0, 45),
        Position = UDim2.new(0, 10, 0, 120),
        PlaceholderText = "Enter key...",
    })
    KeyInput.Name = "KeyInput"
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.ClearTextOnFocus = false

    local SubmitButton = UI.CreateButton(KeyPanel, {
        Text = "UNLOCK",
        Size = UDim2.new(0, 170, 0, 45),
        Position = UDim2.new(0.5, -85, 0, 180),
        BackgroundColor3 = Config.Theme.Success,
        TextColor3 = Config.Theme.Dark,
        TextSize = 14,
    })

    local AttemptsLabel = UI.CreateLabel(KeyPanel, {
        Text = "Attempts left: " .. (KeySystem.MaxAttempts - KeySystem.Attempts),
        TextSize = 12,
        Position = UDim2.new(0, 10, 0, 240),
        Size = UDim2.new(1, -20, 0, 30),
        TextColor3 = Config.Theme.Warning,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local function UpdateAttemptsLabel()
        AttemptsLabel.Text = "Attempts left: " .. math.max(0, KeySystem.MaxAttempts - KeySystem.Attempts)
    end

    local function FlashPanel(Color)
        local OriginalColor = KeyPanel.BackgroundColor3
        KeyPanel.BackgroundColor3 = Color
        task.delay(0.15, function()
            if KeyPanel and KeyPanel.Parent then
                KeyPanel.BackgroundColor3 = OriginalColor
            end
        end)
    end

    local function CheckKey()
        local InputText = tostring(KeyInput.Text or ""):gsub("^%s*(.-)%s*$", "%1")
        if InputText == "" then
            UI.Notify("Please enter the key first", 1.5)
            return
        end

        if InputText == Config.CorrectKey then
            UI.Notify("Key valid. Opening hub...", 2)
            ScreenGui:Destroy()
            task.wait(0.3)
            ScriptHub.Show()
            return
        end

        KeySystem.Attempts = KeySystem.Attempts + 1
        FlashPanel(Config.Theme.Danger)
        KeyInput.Text = ""
        UpdateAttemptsLabel()

        if KeySystem.Attempts >= KeySystem.MaxAttempts then
            task.wait(0.2)
            UI.Notify("Maximum attempts exceeded. Kicking...", 2)
            task.wait(2)
            LocalPlayer:Kick("Key system failed")
        else
            UI.Notify("Invalid key. Try again.", 1.5)
        end
    end

    SubmitButton.MouseButton1Click:Connect(CheckKey)
    KeyInput.FocusLost:Connect(function(EnterPressed)
        if EnterPressed then
            CheckKey()
        end
    end)

    KeyInput:CaptureFocus()
end

-- ============================================================================
-- SCRIPT HUB DATA
-- ============================================================================

local ScriptLibrary = {
    {Name = "Infinite Jump", Category = "player / stats", Code = [[
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local JumpHeight = 50

local CanJump = false
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.Space then
        CanJump = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.Space then
        CanJump = false
    end
end)

Humanoid.StateChanged:Connect(function(OldState, NewState)
    if CanJump then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
]]},
    {Name = "WalkSpeed+", Category = "player / stats", Code = "LocalPlayer.Character.Humanoid.WalkSpeed = 50"},
    {Name = "Fling Script", Category = "players", Code = [[
local Target = game.Players:FindFirstChild("TargetName")
if Target and Target.Character then
    local TargetChar = Target.Character
    local RootPart = TargetChar:FindFirstChild("HumanoidRootPart")
    if RootPart then
        RootPart.Velocity = Vector3.new(math.random(-100, 100), 100, math.random(-100, 100))
    end
end
]]},
    {Name = "Teleport All Players", Category = "players", Code = [[
local SpawnLocation = game.Workspace:FindFirstChild("Spawn")
if SpawnLocation then
    for _, Player in pairs(game.Players:GetPlayers()) do
        if Player.Character then
            Player.Character:MoveTo(SpawnLocation.Position)
        end
    end
end
]]},
    {Name = "Lag Everyone", Category = "troll", Code = [[
while true do
    local Part = Instance.new("Part")
    Part.Parent = game.Workspace
    Part.CanCollide = false
    task.wait(0.01)
end
]]},
    {Name = "Chat Spam", Category = "troll", Code = [[
local Chat = game:GetService("Chat")
for i = 1, 50 do
    Chat:Chat(LocalPlayer.Character.Head, "SPAM DATA GO BRRRR", Enum.ChatColor.Red)
    task.wait(0.1)
end
]]},
    {Name = "Desync Walk", Category = "exploits (dangerous)", Code = [[
local Character = LocalPlayer.Character
local RootPart = Character:FindFirstChild("HumanoidRootPart")
for i = 1, 100 do
    RootPart.CFrame = RootPart.CFrame * CFrame.new(10, 0, 0)
    task.wait(0.01)
end
]]},
    {Name = "Speed Exploit", Category = "exploits (dangerous)", Code = [[
local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
if Humanoid then
    Humanoid.WalkSpeed = 999
end
]]},
}

-- ============================================================================
-- CUSTOM CATEGORIES (New Features)
-- ============================================================================

-- Category 1: Animation Controls
table.insert(ScriptLibrary, {Name = "Emote Dance", Category = "animations", Code = [[
local AnimationId = "rbxassetid://507766666"
local Animation = Instance.new("Animation")
Animation.AnimationId = AnimationId
local LoadedAnim = LocalPlayer.Character.Humanoid:LoadAnimation(Animation)
LoadedAnim:Play()
]]})

table.insert(ScriptLibrary, {Name = "Sit Animation", Category = "animations", Code = [[
LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
]]})

-- Category 2: Cosmetics & Appearance
table.insert(ScriptLibrary, {Name = "Character Transparency", Category = "cosmetics", Code = [[
for _, Part in pairs(LocalPlayer.Character:GetDescendants()) do
    if Part:IsA("BasePart") then
        Part.Transparency = 0.5
    end
end
]]})

table.insert(ScriptLibrary, {Name = "Rainbow Character", Category = "cosmetics", Code = [[
while true do
    for _, Part in pairs(LocalPlayer.Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            Part.Color = Color3.fromHSV(math.random() % 1, 1, 1)
        end
    end
    task.wait(0.1)
end
]]})

-- Category 3: World Interaction
table.insert(ScriptLibrary, {Name = "Delete All Parts", Category = "world", Code = [[
for _, Part in pairs(game.Workspace:GetChildren()) do
    if Part:IsA("BasePart") and Part.Name ~= "Baseplate" then
        Part:Destroy()
    end
end
]]})

table.insert(ScriptLibrary, {Name = "Make Everything Unanchored", Category = "world", Code = [[
for _, Part in pairs(game.Workspace:GetChildren()) do
    if Part:IsA("BasePart") then
        Part.CanCollide = false
        Part.Anchored = false
    end
end
]]})

-- ============================================================================
-- SCRIPT HUB UI
-- ============================================================================

local ScriptHub = {}
ScriptHub.CurrentCategory = "player / stats"
ScriptHub.FavoriteScripts = {}

function ScriptHub.GetScriptsByCategory(Category)
    local Scripts = {}
    for _, Script in pairs(ScriptLibrary) do
        if Script.Category == Category then
            table.insert(Scripts, Script)
        end
    end
    return Scripts
end

function ScriptHub.GetCategories()
    local Categories = {}
    local Seen = {}
    for _, Script in pairs(ScriptLibrary) do
        if not Seen[Script.Category] then
            table.insert(Categories, Script.Category)
            Seen[Script.Category] = true
        end
    end
    table.sort(Categories)
    return Categories
end

function ScriptHub.ExecuteScript(ScriptCode)
    local Success, Error = pcall(function()
        loadstring(ScriptCode)()
    end)
    
    if Success then
        UI.Notify("Script executed!", 2)
    else
        UI.Notify("Error: " .. tostring(Error), 3)
    end
end

function ScriptHub.Show()
    local MainGui = UI.Create("ScreenGui", {
        Parent = PlayerGui,
        ResetOnSpawn = false,
        Name = "ScriptHubGui",
    })
    
    -- Background
    local Background = UI.CreateFrame(MainGui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Config.Theme.Dark,
        BackgroundTransparency = 0,
        CornerRadius = false,
    })
    
    -- Top Bar
    local TopBar = UI.CreateFrame(Background, {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Config.Theme.Secondary,
        CornerRadius = false,
    })
    
    local HubTitle = UI.CreateLabel(TopBar, {
        Text = "⚙️ ROBLOX SCRIPT HUB",
        TextSize = 18,
        TextColor3 = Config.Theme.Accent,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
    })
    
    local FloatingText = UI.Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        TextColor3 = Config.Theme.Light,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        Text = GetExecutorName and GetExecutorName() or "Unknown Executor",
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.65, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    FloatingText.Position = UDim2.new(1, -200, 0, 0)
    
    -- Sidebar
    local Sidebar = UI.CreateFrame(Background, {
        Size = UDim2.new(0, 200, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Config.Theme.Secondary,
        CornerRadius = false,
    })
    
    local SidebarList = UI.Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Config.Theme.Accent,
    })
    
    local UIListLayout = UI.Create("UIListLayout", {
        Parent = SidebarList,
        Padding = UDim.new(0, 5),
    })
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Main Content Area
    local ContentArea = UI.CreateFrame(Background, {
        Size = UDim2.new(1, -200, 1, -50),
        Position = UDim2.new(0, 200, 0, 50),
        BackgroundColor3 = Config.Theme.Dark,
        CornerRadius = false,
    })
    
    local ContentScroll = UI.Create("ScrollingFrame", {
        Parent = ContentArea,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Config.Theme.Accent,
    })
    
    local ContentLayout = UI.Create("UIListLayout", {
        Parent = ContentScroll,
        Padding = UDim.new(0, 10),
    })
    ContentLayout.FillDirection = Enum.FillDirection.Vertical
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Function to populate sidebar
    local function PopulateSidebar()
        for _, Child in pairs(SidebarList:GetChildren()) do
            if Child:IsA("Frame") then
                Child:Destroy()
            end
        end
        
        for _, Category in pairs(ScriptHub.GetCategories()) do
            local CategoryButton = UI.CreateFrame(SidebarList, {
                Size = UDim2.new(1, -10, 0, 40),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundColor3 = ScriptHub.CurrentCategory == Category and Config.Theme.Accent or Config.Theme.Primary,
            })
            CategoryButton.Name = Category
            
            local CategoryLabel = UI.CreateLabel(CategoryButton, {
                Text = Category,
                TextSize = 12,
                TextColor3 = Config.Theme.Dark,
                Size = UDim2.new(1, 0, 1, 0),
            })
            
            CategoryButton.MouseButton1Click:Connect(function()
                ScriptHub.CurrentCategory = Category
                PopulateSidebar()
                PopulateContent()
            end)
        end
    end
    
    -- Function to populate content
    local function PopulateContent()
        for _, Child in pairs(ContentScroll:GetChildren()) do
            if Child:IsA("Frame") then
                Child:Destroy()
            end
        end
        
        if ScriptHub.CurrentCategory == "player / stats" then
            -- Default Landing Page
            ScriptHub.ShowStatsPage(ContentScroll)
        else
            -- Script listing
            for _, Script in pairs(ScriptHub.GetScriptsByCategory(ScriptHub.CurrentCategory)) do
                local ScriptFrame = UI.CreateFrame(ContentScroll, {
                    Size = UDim2.new(1, -20, 0, 80),
                    BackgroundColor3 = Config.Theme.Secondary,
                    UseStroke = true,
                })
                
                local ScriptName = UI.CreateLabel(ScriptFrame, {
                    Text = Script.Name,
                    TextSize = 14,
                    Position = UDim2.new(0, 10, 0, 5),
                    Size = UDim2.new(0.6, 0, 0, 25),
                })
                
                local ExecuteBtn = UI.CreateButton(ContentScroll:FindFirstChild("Parent") or ContentScroll.Parent, {
                    Text = "Execute",
                    Size = UDim2.new(0, 80, 0, 30),
                    Position = UDim2.new(0, 10, 0, 35),
                    BackgroundColor3 = Config.Theme.Success,
                    Callback = function()
                        ScriptHub.ExecuteScript(Script.Code)
                    end
                })
                ExecuteBtn.Parent = ScriptFrame
                ExecuteBtn.Position = UDim2.new(0, 10, 0, 35)
                
                local CopyBtn = UI.CreateButton(ScriptFrame, {
                    Text = "Copy",
                    Size = UDim2.new(0, 80, 0, 30),
                    Position = UDim2.new(0, 100, 0, 35),
                    BackgroundColor3 = Config.Theme.Accent,
                    Callback = function()
                        setclipboard(Script.Code)
                        UI.Notify("Script copied to clipboard!", 2)
                    end
                })
                
                local FavBtn = UI.CreateButton(ScriptFrame, {
                    Text = ScriptHub.FavoriteScripts[Script.Name] and "❤️ Fav" or "🤍 Fav",
                    Size = UDim2.new(0, 80, 0, 30),
                    Position = UDim2.new(0, 190, 0, 35),
                    BackgroundColor3 = ScriptHub.FavoriteScripts[Script.Name] and Config.Theme.Danger or Config.Theme.Primary,
                    Callback = function()
                        ScriptHub.FavoriteScripts[Script.Name] = not ScriptHub.FavoriteScripts[Script.Name]
                        PopulateContent()
                    end
                })
            end
        end
    end
    
    -- Stats Page Implementation
    function ScriptHub.ShowStatsPage(Parent)
        local MainContainer = UI.CreateFrame(Parent, {
            Size = UDim2.new(1, -20, 0, 400),
            BackgroundColor3 = Config.Theme.Secondary,
            UseStroke = true,
        })
        
        -- Welcome Section
        local WelcomeFrame = UI.CreateFrame(MainContainer, {
            Size = UDim2.new(0.5, -10, 0, 120),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundColor3 = Config.Theme.Primary,
        })
        
        UI.CreateLabel(WelcomeFrame, {
            Text = "Welcome, " .. LocalPlayer.Name,
            TextSize = 16,
            TextColor3 = Config.Theme.Accent,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 0, 30),
        })
        
        -- Stats Section
        local StatsFrame = UI.CreateFrame(MainContainer, {
            Size = UDim2.new(0.5, -10, 0, 120),
            Position = UDim2.new(0.5, 5, 0, 10),
            BackgroundColor3 = Config.Theme.Primary,
        })
        
        local Ping = game:GetService("Stats"):FindFirstChild("Network") and math.floor(game:GetService("Stats").Network.ServerReplicator:FindFirstChild("Data") and tonumber(game:GetService("Stats").Network.ServerReplicator.Data.value) or 0) or 0
        
        UI.CreateLabel(StatsFrame, {
            Text = "📊 Stats",
            TextSize = 14,
            TextColor3 = Config.Theme.Accent,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 0, 25),
        })
        
        UI.CreateLabel(StatsFrame, {
            Text = "Ping: " .. Ping .. "ms",
            TextSize = 12,
            Position = UDim2.new(0, 10, 0, 40),
            Size = UDim2.new(1, -20, 0, 20),
        })
        
        UI.CreateLabel(StatsFrame, {
            Text = "Players: " .. #game.Players:GetPlayers(),
            TextSize = 12,
            Position = UDim2.new(0, 10, 0, 65),
            Size = UDim2.new(1, -20, 0, 20),
        })
        
        -- Executor Detection
        local ExecutorFrame = UI.CreateFrame(MainContainer, {
            Size = UDim2.new(1, -20, 0, 80),
            Position = UDim2.new(0, 10, 0, 140),
            BackgroundColor3 = Config.Theme.Primary,
        })
        
        local ExecutorName = "Unknown Executor"
        if GetExecutorName then ExecutorName = GetExecutorName() end
        
        UI.CreateLabel(ExecutorFrame, {
            Text = "🔧 Executor: " .. ExecutorName,
            TextSize = 13,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 0, 25),
        })
        
        -- Player Controls
        local ControlsFrame = UI.CreateFrame(MainContainer, {
            Size = UDim2.new(1, -20, 0, 140),
            Position = UDim2.new(0, 10, 0, 230),
            BackgroundColor3 = Config.Theme.Secondary,
        })
        
        UI.CreateLabel(ControlsFrame, {
            Text = "⚡ Player Controls",
            TextSize = 13,
            TextColor3 = Config.Theme.Accent,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
        })
        
        -- WalkSpeed Control
        local WalkSpeedLabel = UI.CreateLabel(ControlsFrame, {
            Text = "WalkSpeed: 16",
            TextSize = 11,
            Position = UDim2.new(0, 10, 0, 30),
            Size = UDim2.new(0.3, 0, 0, 20),
        })
        
        local WalkSpeedBox = UI.CreateTextBox(ControlsFrame, {
            Size = UDim2.new(0.3, -15, 0, 25),
            Position = UDim2.new(0.35, 5, 0, 30),
            PlaceholderText = "Enter value",
        })
        
        local WalkSpeedBtn = UI.CreateButton(ControlsFrame, {
            Text = "Apply",
            Size = UDim2.new(0.25, -5, 0, 25),
            Position = UDim2.new(0.7, 5, 0, 30),
            BackgroundColor3 = Config.Theme.Success,
            Callback = function()
                local Value = tonumber(WalkSpeedBox.Text)
                if Value then
                    LocalPlayer.Character.Humanoid.WalkSpeed = Value
                    WalkSpeedLabel.Text = "WalkSpeed: " .. Value
                    UI.Notify("WalkSpeed set to " .. Value, 1)
                end
            end
        })
        
        -- JumpHeight Control
        local JumpHeightLabel = UI.CreateLabel(ControlsFrame, {
            Text = "JumpHeight: 50",
            TextSize = 11,
            Position = UDim2.new(0, 10, 0, 65),
            Size = UDim2.new(0.3, 0, 0, 20),
        })
        
        local JumpHeightBox = UI.CreateTextBox(ControlsFrame, {
            Size = UDim2.new(0.3, -15, 0, 25),
            Position = UDim2.new(0.35, 5, 0, 65),
            PlaceholderText = "Enter value",
        })
        
        local JumpHeightBtn = UI.CreateButton(ControlsFrame, {
            Text = "Apply",
            Size = UDim2.new(0.25, -5, 0, 25),
            Position = UDim2.new(0.7, 5, 0, 65),
            BackgroundColor3 = Config.Theme.Success,
            Callback = function()
                local Value = tonumber(JumpHeightBox.Text)
                if Value then
                    LocalPlayer.Character.Humanoid.JumpHeight = Value
                    JumpHeightLabel.Text = "JumpHeight: " .. Value
                    UI.Notify("JumpHeight set to " .. Value, 1)
                end
            end
        })
        
        -- Noclip Toggle
        local NoclipButton = UI.CreateButton(ControlsFrame, {
            Text = "Noclip: OFF",
            Size = UDim2.new(0.4, -5, 0, 25),
            Position = UDim2.new(0, 10, 0, 100),
            BackgroundColor3 = Config.Theme.Danger,
            Callback = function()
                -- Noclip implementation
                NoclipButton.BackgroundColor3 = NoclipButton.BackgroundColor3 == Config.Theme.Danger and Config.Theme.Success or Config.Theme.Danger
                local ButtonLabel = NoclipButton:FindFirstChildOfClass("TextLabel")
                ButtonLabel.Text = NoclipButton.BackgroundColor3 == Config.Theme.Success and "Noclip: ON" or "Noclip: OFF"
            end
        })
        
        -- Respawn Button
        local RespawnBtn = UI.CreateButton(ControlsFrame, {
            Text = "Respawn",
            Size = UDim2.new(0.4, -5, 0, 25),
            Position = UDim2.new(0.55, 5, 0, 100),
            BackgroundColor3 = Config.Theme.Warning,
            Callback = function()
                LocalPlayer.Character:FindFirstChild("Humanoid").Health = 0
            end
        })
    end
    
    PopulateSidebar()
    PopulateContent()
end

-- ============================================================================
-- EXECUTION
-- ============================================================================

KeySystem.Show()
