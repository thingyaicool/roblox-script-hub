-- ============================================================================
-- ROBLOX SCRIPT HUB - Rebuilt Client Architecture
-- Full UI + Key System Overhaul
-- Compatible with Delta Executor on Chromebook
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function IsLegacyHubGui(Gui)
    if not Gui:IsA("ScreenGui") then
        return false
    end

    if Gui.Name == "ScriptHubGui" or Gui.Name == "KeySystemGui" then
        return true
    end

    local function ContainsLegacyText(Object)
        for _, Descendant in ipairs(Object:GetDescendants()) do
            if Descendant:IsA("TextLabel") or Descendant:IsA("TextButton") or Descendant:IsA("TextBox") then
                local ok, Text = pcall(function()
                    return Descendant.Text
                end)
                if ok and type(Text) == "string" then
                    local Up = string.upper(Text)
                    if Up:find("KEY SYSTEM") or Up:find("KEY AUTH") or Up:find("SUBMIT") or Up:find("SCRIPT HUB") then
                        return true
                    end
                end
            end
        end
        return false
    end

    return ContainsLegacyText(Gui)
end

local function CleanupExistingHubs()
    for _, Gui in ipairs(PlayerGui:GetChildren()) do
        if IsLegacyHubGui(Gui) then
            pcall(function()
                Gui:Destroy()
            end)
        end
    end
end

CleanupExistingHubs()

-- ============================================================================
-- CORE + CONFIG
-- ============================================================================

local Config = {
    CorrectKey = "123",
    Version = "1.0",
    Theme = {
        Primary = Color3.fromRGB(40, 40, 70),
        Secondary = Color3.fromRGB(20, 20, 30),
        Accent = Color3.fromRGB(45, 189, 255),
        Success = Color3.fromRGB(50, 205, 50),
        Danger = Color3.fromRGB(220, 20, 60),
        Warning = Color3.fromRGB(255, 165, 0),
        Light = Color3.fromRGB(235, 235, 245),
        Dark = Color3.fromRGB(10, 10, 15),
    },
    CornerRadius = UDim.new(0, 12),
    TransitionSpeed = 0.22,
    NotificationDuration = 2,
    UiScaleMin = 0.8,
    UiScaleMax = 1.2,
    MaxVisibleScriptCards = 10,
}

local Core = {
    State = {
        ActiveCategory = "player / stats",
        LastCategory = nil,
        KeyAttempts = 0,
        MaxKeyAttempts = 3,
        ModalOpen = false,
        UiScale = 1,
        HasHydrated = false,
        SearchText = "",
    },
    Modules = {},
    Connections = {},
    TaskQueue = {},
    Services = {
        Players = Players,
        UIS = UserInputService,
        Run = RunService,
        Http = HttpService,
        Tween = TweenService,
        LocalPlayer = LocalPlayer,
        PlayerGui = PlayerGui,
    },
}

function Core:BindConnection(Connection)
    if Connection and typeof(Connection.Disconnect) == "function" then
        table.insert(self.Connections, Connection)
    end
    return Connection
end

function Core:DisconnectAll()
    for _, Connection in ipairs(self.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end
    self.Connections = {}
end

function Core:SafeExecute(Func)
    local Success, Err = pcall(Func)
    if not Success then
        warn("ScriptHub SafeExecute error:", Err)
        self.Modules.UI.Notify("System error: " .. tostring(Err), 3, "Danger")
    end
    return Success, Err
end

function Core:Debounce(Key, Delay)
    Delay = Delay or 0.25
    if not self.State.Debounce then
        self.State.Debounce = {}
    end
    if self.State.Debounce[Key] then
        return false
    end
    self.State.Debounce[Key] = true
    task.delay(Delay, function()
        self.State.Debounce[Key] = nil
    end)
    return true
end

function Core:Throttle(Key, Delay)
    Delay = Delay or 0.15
    if not self.State.Throttle then
        self.State.Throttle = {}
    end
    if self.State.Throttle[Key] then
        return false
    end
    self.State.Throttle[Key] = true
    task.delay(Delay, function()
        self.State.Throttle[Key] = nil
    end)
    return true
end

function Core:SetProp(Object, Property, Value)
    if Object and Object[Property] ~= nil then
        Object[Property] = Value
        return true
    end
    return false
end

function Core:Schedule(TaskName, Func, Delay)
    Delay = Delay or 0
    table.insert(self.TaskQueue, {Name = TaskName or "task", Func = Func, Delay = Delay})
end

function Core:FlushTasks()
    while #self.TaskQueue > 0 do
        local Entry = table.remove(self.TaskQueue, 1)
        task.delay(Entry.Delay, Entry.Func)
    end
end

function Core:CreateTaskRunner()
    self.Services.Run:BindToRenderStep("ScriptHubTaskRunner", Enum.RenderPriority.Last.Value, function()
        if #self.TaskQueue > 0 then
            local Entry = table.remove(self.TaskQueue, 1)
            if Entry and typeof(Entry.Func) == "function" then
                self:SafeExecute(Entry.Func)
            end
        end
    end)
end

-- ============================================================================
-- UTILITIES
-- ============================================================================

local UI = {}

function UI.Create(ClassName, Properties)
    local Instance = Instance.new(ClassName)
    for Property, Value in pairs(Properties or {}) do
        Instance[Property] = Value
    end
    return Instance
end

function UI.Apply(Instance, Properties)
    for Property, Value in pairs(Properties or {}) do
        Instance[Property] = Value
    end
    return Instance
end

function UI.SafeDestroy(Object)
    if Object and Object.Parent then
        pcall(function() Object:Destroy() end)
    end
end

function UI.CreateFrame(Parent, Properties)
    local Frame = UI.Create("Frame", {
        Parent = Parent,
        BackgroundColor3 = Properties.BackgroundColor3 or Config.Theme.Primary,
        BackgroundTransparency = Properties.BackgroundTransparency or 0.05,
        BorderSizePixel = 0,
        Size = Properties.Size or UDim2.new(1, 0, 1, 0),
        Position = Properties.Position or UDim2.new(0, 0, 0, 0),
        ZIndex = Properties.ZIndex or 1,
        Visible = Properties.Visible == false and false or true,
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
            Color = Properties.StrokeColor or Config.Theme.Accent,
            Thickness = Properties.StrokeThickness or 1.5,
            Transparency = Properties.StrokeTransparency or 0.75,
        })
    end

    return Frame
end

function UI.CreateLabel(Parent, Properties)
    return UI.Create("TextLabel", {
        Parent = Parent,
        BackgroundTransparency = 1,
        TextColor3 = Properties.TextColor3 or Config.Theme.Light,
        TextSize = Properties.TextSize or 14,
        Font = Properties.Font or Enum.Font.GothamMedium,
        Text = Properties.Text or "",
        Size = Properties.Size or UDim2.new(1, 0, 0, 20),
        Position = Properties.Position or UDim2.new(0, 0, 0, 0),
        TextXAlignment = Properties.TextXAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = Properties.TextYAlignment or Enum.TextYAlignment.Center,
        ZIndex = Properties.ZIndex or 1,
    })
end

function UI.CreateButton(Parent, Properties)
    local Button = UI.Create("TextButton", {
        Parent = Parent,
        Size = Properties.Size or UDim2.new(0, 120, 0, 40),
        Position = Properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Properties.BackgroundColor3 or Config.Theme.Accent,
        BorderSizePixel = 0,
        Text = Properties.Text or "Button",
        TextColor3 = Properties.TextColor3 or Config.Theme.Dark,
        TextSize = Properties.TextSize or 14,
        Font = Properties.Font or Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = Properties.ZIndex or 2,
    })

    UI.Create("UICorner", {
        Parent = Button,
        CornerRadius = Properties.CornerRadius or Config.CornerRadius,
    })

    if Properties.UseStroke then
        UI.Create("UIStroke", {
            Parent = Button,
            Color = Properties.StrokeColor or Config.Theme.Light,
            Thickness = Properties.StrokeThickness or 1.5,
            Transparency = Properties.StrokeTransparency or 0.7,
        })
    end

    local Original = Button.BackgroundColor3
    local Hover = Properties.HoverColor or Config.Theme.Success

    local onEnter = function()
        Core.Services.Tween:Create(Button, TweenInfo.new(Config.TransitionSpeed), {BackgroundColor3 = Hover}):Play()
    end
    local onLeave = function()
        Core.Services.Tween:Create(Button, TweenInfo.new(Config.TransitionSpeed), {BackgroundColor3 = Original}):Play()
    end

    Button.MouseEnter:Connect(onEnter)
    Button.MouseLeave:Connect(onLeave)

    if Properties.Callback then
        Button.MouseButton1Click:Connect(function()
            if Core:Debounce("button_" .. tostring(Button), 0.18) then
                Core:SafeExecute(Properties.Callback)
            end
        end)
    end

    return Button
end

function UI.CreateTextBox(Parent, Properties)
    local TextBox = UI.Create("TextBox", {
        Parent = Parent,
        BackgroundColor3 = Properties.BackgroundColor3 or Config.Theme.Primary,
        BackgroundTransparency = Properties.BackgroundTransparency or 0,
        BorderSizePixel = 0,
        TextColor3 = Properties.TextColor3 or Config.Theme.Light,
        TextSize = Properties.TextSize or 14,
        Font = Properties.Font or Enum.Font.GothamMedium,
        PlaceholderText = Properties.PlaceholderText or "Enter text...",
        PlaceholderColor3 = Properties.PlaceholderColor3 or Config.Theme.Light,
        Size = Properties.Size or UDim2.new(1, -20, 0, 36),
        Position = Properties.Position or UDim2.new(0, 0, 0, 0),
        Text = Properties.Text or "",
        TextXAlignment = Properties.TextXAlignment or Enum.TextXAlignment.Left,
        ZIndex = Properties.ZIndex or 2,
        ClearTextOnFocus = Properties.ClearTextOnFocus ~= false,
        TextWrapped = true,
    })

    UI.Create("UICorner", {
        Parent = TextBox,
        CornerRadius = Properties.CornerRadius or Config.CornerRadius,
    })

    UI.Create("UIStroke", {
        Parent = TextBox,
        Color = Properties.StrokeColor or Config.Theme.Accent,
        Thickness = 1,
        Transparency = 0.7,
    })

    return TextBox
end

function UI.CreateOverlay(Parent, ZIndex)
    return UI.CreateFrame(Parent, {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.6,
        CornerRadius = false,
        ZIndex = ZIndex or 20,
    })
end

function UI.CreateSkeletonRow(Parent, Index)
    local Skeleton = UI.CreateFrame(Parent, {
        Size = UDim2.new(1, -20, 0, 70),
        Position = UDim2.new(0, 10, 0, (Index - 1) * 80),
        BackgroundColor3 = Color3.fromRGB(30, 30, 45),
        CornerRadius = Config.CornerRadius,
        ZIndex = 1,
    })

    UI.CreateFrame(Skeleton, {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 10, 0, 12),
        BackgroundColor3 = Color3.fromRGB(55, 55, 90),
        CornerRadius = Config.CornerRadius,
    })

    UI.CreateFrame(Skeleton, {
        Size = UDim2.new(0.5, -10, 0, 16),
        Position = UDim2.new(0, 10, 0, 38),
        BackgroundColor3 = Color3.fromRGB(55, 55, 90),
        CornerRadius = Config.CornerRadius,
    })

    return Skeleton
end

function UI.Notify(Message, Duration, Style)
    Duration = Duration or Config.NotificationDuration
    local Notification = UI.CreateFrame(PlayerGui, {
        Size = UDim2.new(0, 320, 0, 50),
        Position = UDim2.new(1, 20, 0, 20),
        BackgroundColor3 = Style == "Danger" and Config.Theme.Danger or Style == "Success" and Config.Theme.Success or Config.Theme.Secondary,
        ZIndex = 50,
    })

    UI.CreateLabel(Notification, {
        Text = Message,
        TextSize = 14,
        TextColor3 = Config.Theme.Dark,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -24, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local TweenIn = TweenService:Create(Notification, TweenInfo.new(0.25), {Position = UDim2.new(1, -340, 0, 20)})
    TweenIn:Play()

    task.delay(Duration, function()
        local TweenOut = TweenService:Create(Notification, TweenInfo.new(0.25), {Position = UDim2.new(1, 20, 0, 20)})
        TweenOut:Play()
        TweenOut.Completed:Connect(function()
            UI.SafeDestroy(Notification)
        end)
    end)
end

-- ============================================================================
-- DATA
-- ============================================================================

local ScriptLibrary = {
    {Name = "Infinite Jump", Category = "player / stats", Code = [[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
Humanoid.JumpPower = 200
Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
]]},
    {Name = "Speed Boost", Category = "player / stats", Code = [[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.WalkSpeed = 90
end
]]},
    {Name = "God Mode", Category = "player / stats", Code = [[
local p = game.Players.LocalPlayer
if p.Character and p.Character:FindFirstChild("Humanoid") then
    p.Character.Humanoid.MaxHealth = 1e6
    p.Character.Humanoid.Health = 1e6
end
]]},
    {Name = "Teleport All", Category = "players", Code = [[
for _, p in ipairs(game.Players:GetPlayers()) do
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end
]]},
    {Name = "Chat Spam", Category = "troll", Code = [[
local Chat = game:GetService("Chat")
for i = 1, 20 do
    Chat:Chat(game.Players.LocalPlayer.Character.Head, "SPAM", Enum.ChatColor.Red)
    task.wait(0.1)
end
]]},
    {Name = "Rainbow Player", Category = "cosmetics", Code = [[
for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Color = Color3.fromHSV(tick() % 1, 1, 1)
    end
end
]]},
}

-- ============================================================================
-- SCRIPT HUB MODULE
-- ============================================================================

local ScriptHub = {}

function ScriptHub:GetCategories()
    local Categories = {}
    local Seen = {}
    for _, Item in ipairs(ScriptLibrary) do
        if not Seen[Item.Category] then
            table.insert(Categories, Item.Category)
            Seen[Item.Category] = true
        end
    end
    table.sort(Categories)
    return Categories
end

function ScriptHub:GetScriptsByCategory(Category)
    local Results = {}
    for _, Item in ipairs(ScriptLibrary) do
        if Item.Category == Category then
            if Core.State.SearchText == "" or Item.Name:lower():find(Core.State.SearchText:lower()) then
                table.insert(Results, Item)
            end
        end
    end
    return Results
end

function ScriptHub:ExecuteScript(ScriptData)
    Core:SafeExecute(function()
        if type(ScriptData.Code) == "string" then
            local Loaded = loadstring(ScriptData.Code)
            if Loaded then
                Loaded()
                UI.Notify("Executed " .. ScriptData.Name, 2, "Success")
            else
                UI.Notify("Failed to load script.", 2, "Danger")
            end
        end
    end)
end

function ScriptHub:Destroy()
    Core:DisconnectAll()
    if self.MainGui and self.MainGui.Parent then
        UI.SafeDestroy(self.MainGui)
    end
    self.MainGui = nil
    self.State = nil
end

function ScriptHub:Open()
    if self.MainGui then
        self:Destroy()
    end

    local ScreenGui = UI.Create("ScreenGui", {
        Parent = PlayerGui,
        ResetOnSpawn = false,
        Name = "ScriptHubGui",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    self.MainGui = ScreenGui
    self.State = {}

    local Root = UI.CreateFrame(ScreenGui, {
        Size = UDim2.new(0.96, 0, 0.92, 0),
        Position = UDim2.new(0.02, 0, 0.04, 0),
        BackgroundColor3 = Config.Theme.Dark,
        UseStroke = true,
        ZIndex = 2,
    })

    UI.Create("UIPadding", {
        Parent = Root,
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
    })

    local Header = UI.CreateFrame(Root, {
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundColor3 = Config.Theme.Secondary,
        UseStroke = true,
    })

    UI.CreateLabel(Header, {
        Text = "⚙️ ROBLOX SCRIPT HUB",
        TextSize = 20,
        TextColor3 = Config.Theme.Accent,
        Position = UDim2.new(0, 14, 0, 12),
        Size = UDim2.new(0.5, 0, 0, 40),
    })

    self.State.SearchBox = UI.CreateTextBox(Header, {
        Size = UDim2.new(0.35, 0, 0, 38),
        Position = UDim2.new(0.55, 0, 0, 12),
        PlaceholderText = "Search scripts...",
        Text = "",
        ZIndex = 3,
    })

    self.State.SearchBox.FocusLost:Connect(function(EnterPressed)
        if EnterPressed then
            Core.State.SearchText = self.State.SearchBox.Text
            self:RenderSidebar()
            self:RenderContent()
        end
    end)

    self.State.SearchBox.Changed:Connect(function(Property)
        if Property == "Text" then
            Core.State.SearchText = self.State.SearchBox.Text
        end
    end)

    local Body = UI.CreateFrame(Root, {
        Size = UDim2.new(1, 0, 1, -82),
        Position = UDim2.new(0, 0, 0, 72),
        BackgroundColor3 = Config.Theme.Dark,
        CornerRadius = false,
    })

    local Sidebar = UI.CreateFrame(Body, {
        Size = UDim2.new(0, 220, 1, 0),
        BackgroundColor3 = Config.Theme.Secondary,
        UseStroke = true,
    })

    local ContentArea = UI.CreateFrame(Body, {
        Size = UDim2.new(1, -230, 1, 0),
        Position = UDim2.new(0, 230, 0, 0),
        BackgroundColor3 = Config.Theme.Dark,
    })

    local SidebarScroll = UI.Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ZIndex = 2,
    })

    local SidebarLayout = UI.Create("UIListLayout", {
        Parent = SidebarScroll,
        Padding = UDim.new(0, 8),
    })
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentScroll = UI.Create("ScrollingFrame", {
        Parent = ContentArea,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
        ZIndex = 2,
    })

    local ContentLayout = UI.Create("UIListLayout", {
        Parent = ContentScroll,
        Padding = UDim.new(0, 12),
    })
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    self.State.SidebarScroll = SidebarScroll
    self.State.ContentScroll = ContentScroll
    self.State.SidebarLayout = SidebarLayout
    self.State.ContentLayout = ContentLayout

    self.State.StatusLabel = UI.CreateLabel(Root, {
        Text = "Ready",
        TextSize = 12,
        TextColor3 = Config.Theme.Light,
        Position = UDim2.new(0, 14, 1, -30),
        Size = UDim2.new(0.5, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    })

    self:RenderSidebar()
    self:HydrateUI()
end

function ScriptHub:RenderSidebar()
    local Categories = self:GetCategories()
    local Layout = self.State.SidebarScroll

    for _, Child in ipairs(Layout:GetChildren()) do
        if Child:IsA("Frame") then
            UI.SafeDestroy(Child)
        end
    end

    for _, Category in ipairs(Categories) do
        local CategoryFrame = UI.CreateFrame(Layout, {
            Size = UDim2.new(1, -18, 0, 38),
            BackgroundColor3 = Core.State.ActiveCategory == Category and Config.Theme.Accent or Config.Theme.Primary,
            UseStroke = true,
            ZIndex = 3,
        })

        local CategoryButton = UI.CreateButton(CategoryFrame, {
            Text = "  " .. Category,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.new(0, 0, 0),
            TextColor3 = Config.Theme.Light,
            HoverColor = Config.Theme.Success,
            Callback = function()
                if Core.State.ActiveCategory ~= Category then
                    Core.State.ActiveCategory = Category
                    self:RenderSidebar()
                    self:HydrateUI()
                end
            end,
        })
        CategoryButton.BackgroundTransparency = 1
        CategoryButton.TextXAlignment = Enum.TextXAlignment.Left
    end

    Layout.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 12)
end

function ScriptHub:HydrateUI()
    self.State.StatusLabel.Text = "Loading content..."
    self.State.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, Config.MaxVisibleScriptCards * 80)

    for i = 1, Config.MaxVisibleScriptCards do
        UI.CreateSkeletonRow(self.State.ContentScroll, i)
    end

    Core:Schedule("hydrate_content", function()
        self:RenderContentInternal()
    end, 0.18)
end

function ScriptHub:RenderContentInternal()
    local ContentScroll = self.State.ContentScroll
    for _, Child in ipairs(ContentScroll:GetChildren()) do
        if Child:IsA("Frame") then
            UI.SafeDestroy(Child)
        end
    end

    if Core.State.ActiveCategory == "player / stats" then
        self:RenderStatsPage()
        return
    end

    local Scripts = self:GetScriptsByCategory(Core.State.ActiveCategory)
    if #Scripts == 0 then
        local Empty = UI.CreateFrame(ContentScroll, {
            Size = UDim2.new(1, -20, 0, 110),
            BackgroundColor3 = Config.Theme.Secondary,
            UseStroke = true,
        })
        UI.CreateLabel(Empty, {
            Text = "No scripts found.",
            TextSize = 14,
            Position = UDim2.new(0, 14, 0, 14),
            Size = UDim2.new(1, -28, 0, 22),
        })
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 130)
        self.State.StatusLabel.Text = "No scripts available"
        return
    end

    local TotalHeight = 0
    for _, ScriptData in ipairs(Scripts) do
        local Card = UI.CreateFrame(ContentScroll, {
            Size = UDim2.new(1, -20, 0, 96),
            BackgroundColor3 = Config.Theme.Secondary,
            UseStroke = true,
            ZIndex = 3,
        })

        UI.CreateLabel(Card, {
            Text = ScriptData.Name,
            TextSize = 16,
            Position = UDim2.new(0, 14, 0, 14),
            Size = UDim2.new(0.6, 0, 0, 24),
            TextColor3 = Config.Theme.Light,
        })

        UI.CreateLabel(Card, {
            Text = ScriptData.Category,
            TextSize = 12,
            Position = UDim2.new(0, 14, 0, 42),
            Size = UDim2.new(0.4, 0, 0, 20),
            TextColor3 = Config.Theme.Warning,
        })

        UI.CreateButton(Card, {
            Text = "Execute",
            Size = UDim2.new(0, 110, 0, 34),
            Position = UDim2.new(0.62, 0, 0, 28),
            BackgroundColor3 = Config.Theme.Success,
            TextColor3 = Config.Theme.Dark,
            Callback = function()
                self:ExecuteScript(ScriptData)
            end,
        })

        UI.CreateButton(Card, {
            Text = "Copy",
            Size = UDim2.new(0, 110, 0, 34),
            Position = UDim2.new(0.78, 0, 0, 28),
            BackgroundColor3 = Config.Theme.Accent,
            Callback = function()
                if setclipboard then
                    setclipboard(ScriptData.Code)
                    UI.Notify("Copied script", 1.8, "Success")
                else
                    UI.Notify("Clipboard unavailable", 1.8, "Warning")
                end
            end,
        })

        TotalHeight = TotalHeight + 108
    end

    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, TotalHeight + 16)
    self.State.StatusLabel.Text = "Loaded " .. tostring(#Scripts) .. " scripts"
end

function ScriptHub:RenderContent()
    if Core.State.ActiveCategory == "player / stats" then
        self:RenderStatsPage()
    else
        self:HydrateUI()
    end
end

function ScriptHub:RenderStatsPage()
    local ContentScroll = self.State.ContentScroll
    local StatsCard = UI.CreateFrame(ContentScroll, {
        Size = UDim2.new(1, -20, 0, 240),
        BackgroundColor3 = Config.Theme.Secondary,
        UseStroke = true,
        ZIndex = 3,
    })

    UI.CreateLabel(StatsCard, {
        Text = "Welcome back, " .. LocalPlayer.Name,
        TextSize = 18,
        Position = UDim2.new(0, 14, 0, 14),
        Size = UDim2.new(1, -28, 0, 28),
        TextColor3 = Config.Theme.Light,
    })

    UI.CreateLabel(StatsCard, {
        Text = "Executor: " .. (GetExecutorName and GetExecutorName() or "Unknown"),
        TextSize = 14,
        Position = UDim2.new(0, 14, 0, 46),
        Size = UDim2.new(1, -28, 0, 24),
        TextColor3 = Config.Theme.Accent,
    })

    UI.CreateLabel(StatsCard, {
        Text = "Players: " .. tostring(#Players:GetPlayers()),
        TextSize = 14,
        Position = UDim2.new(0, 14, 0, 70),
        Size = UDim2.new(1, -28, 0, 24),
    })

    UI.CreateLabel(StatsCard, {
        Text = "Categories: " .. tostring(#self:GetCategories()),
        TextSize = 14,
        Position = UDim2.new(0, 14, 0, 96),
        Size = UDim2.new(1, -28, 0, 24),
    })

    self.State.StatusLabel.Text = "Stats page active"
    self.State.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 260)
end

-- ============================================================================
-- KEY SYSTEM MODULE
-- ============================================================================

local KeySystem = {}

function KeySystem:Open()
    Core.State.KeyAttempts = 0
    if Core.State.ModalOpen then
        return
    end

    Core.State.ModalOpen = true
    Core:DisconnectAll()

    local Overlay = UI.CreateOverlay(PlayerGui, 40)
    local Panel = UI.CreateFrame(Overlay, {
        Size = UDim2.new(0, 440, 0, 300),
        Position = UDim2.new(0.5, -220, 0.5, -150),
        BackgroundColor3 = Config.Theme.Secondary,
        UseStroke = true,
        ZIndex = 41,
    })

    UI.CreateLabel(Panel, {
        Text = "🔒 KEY AUTH",
        TextSize = 22,
        TextColor3 = Config.Theme.Accent,
        Position = UDim2.new(0, 24, 0, 24),
        Size = UDim2.new(1, -48, 0, 28),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    UI.CreateLabel(Panel, {
        Text = "Enter the code to unlock the hub.",
        TextSize = 14,
        TextColor3 = Config.Theme.Light,
        Position = UDim2.new(0, 24, 0, 58),
        Size = UDim2.new(1, -48, 0, 22),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local KeyInput = UI.CreateTextBox(Panel, {
        Size = UDim2.new(1, -48, 0, 46),
        Position = UDim2.new(0, 24, 0, 100),
        PlaceholderText = "Enter key...",
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 42,
    })

    local Unlock = UI.CreateButton(Panel, {
        Text = "UNLOCK",
        Size = UDim2.new(0, 160, 0, 44),
        Position = UDim2.new(0.5, -80, 0, 164),
        BackgroundColor3 = Config.Theme.Success,
        TextColor3 = Config.Theme.Dark,
        ZIndex = 42,
    })

    local Attempts = UI.CreateLabel(Panel, {
        Text = "Attempts left: " .. tostring(Core.State.MaxKeyAttempts),
        TextSize = 13,
        TextColor3 = Config.Theme.Warning,
        Position = UDim2.new(0, 24, 0, 228),
        Size = UDim2.new(1, -48, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 42,
    })

    local function UpdateAttempts()
        Attempts.Text = "Attempts left: " .. tostring(math.max(0, Core.State.MaxKeyAttempts - Core.State.KeyAttempts))
    end

    local function CloseModal()
        Core.State.ModalOpen = false
        UI.SafeDestroy(Overlay)
    end

    local function Validate()
        local Value = tostring(KeyInput.Text or ""):gsub("^%s*(.-)%s*$", "%1")
        if Value == "" then
            UI.Notify("Please enter the key", 1.5, "Warning")
            return
        end

        if Value == Config.CorrectKey then
            UI.Notify("Key accepted. Loading hub...", 1.8, "Success")
            task.delay(0.18, function()
                CloseModal()
                ScriptHub:Open()
            end)
            return
        end

        Core.State.KeyAttempts = Core.State.KeyAttempts + 1
        UpdateAttempts()
        UI.Notify("Invalid key", 1.6, "Danger")
        TweenService:Create(Panel, TweenInfo.new(0.12), {BackgroundColor3 = Config.Theme.Danger}):Play()
        task.delay(0.14, function()
            if Panel and Panel.Parent then
                Panel.BackgroundColor3 = Config.Theme.Secondary
            end
        end)
        KeyInput.Text = ""

        if Core.State.KeyAttempts >= Core.State.MaxKeyAttempts then
            task.delay(0.2, function()
                UI.Notify("Max attempts reached", 2, "Danger")
                task.wait(2)
                LocalPlayer:Kick("Key system failed")
            end)
        end
    end

    Unlock.MouseButton1Click:Connect(Validate)
    Core:BindConnection(KeyInput.FocusLost:Connect(function(EnterPressed)
        if EnterPressed then
            Validate()
        end
    end))

    Core:BindConnection(UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed or not Core.State.ModalOpen then
            return
        end
        if Input.KeyCode == Enum.KeyCode.Return or Input.KeyCode == Enum.KeyCode.KeypadEnter then
            Validate()
        end
    end))

    KeyInput:CaptureFocus()
end

-- ============================================================================
-- BOOTSTRAP
-- ============================================================================

Core.Modules.UI = UI
Core.Modules.ScriptHub = ScriptHub
Core.Modules.KeySystem = KeySystem

ScriptHub:Open()
KeySystem:Open()
