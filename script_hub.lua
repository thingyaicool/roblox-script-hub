-- ============================================================================
-- ROBLOX SCRIPT HUB - Clean Hub-Only Version
-- Key system removed completely
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function CleanupOldHub()
    for _, Gui in ipairs(PlayerGui:GetChildren()) do
        if Gui:IsA("ScreenGui") and Gui.Name == "ScriptHubGui" then
            pcall(function()
                Gui:Destroy()
            end)
        end
    end
end

CleanupOldHub()

local Config = {
    Theme = {
        Primary = Color3.fromRGB(18, 18, 28),
        Secondary = Color3.fromRGB(24, 24, 40),
        Accent = Color3.fromRGB(53, 153, 255),
        Success = Color3.fromRGB(50, 205, 50),
        Warning = Color3.fromRGB(255, 165, 0),
        Light = Color3.fromRGB(230, 230, 240),
        Dark = Color3.fromRGB(12, 12, 18),
    },
    CornerRadius = UDim.new(0, 12),
    TransitionSpeed = 0.22,
    NotificationDuration = 2,
}

local UI = {}

function UI.Create(ClassName, Properties)
    local Instance = Instance.new(ClassName)
    for Property, Value in pairs(Properties or {}) do
        Instance[Property] = Value
    end
    return Instance
end

function UI.SafeDestroy(Object)
    if Object and Object.Parent then
        pcall(function()
            Object:Destroy()
        end)
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

    local Original = Button.BackgroundColor3
    local Hover = Properties.HoverColor or Config.Theme.Success

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(Config.TransitionSpeed), {BackgroundColor3 = Hover}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(Config.TransitionSpeed), {BackgroundColor3 = Original}):Play()
    end)

    if Properties.Callback then
        Button.MouseButton1Click:Connect(function()
            Properties.Callback()
        end)
    end

    return Button
end

function UI.CreateTextBox(Parent, Properties)
    local TextBox = UI.Create("TextBox", {
        Parent = Parent,
        BackgroundColor3 = Properties.BackgroundColor3 or Config.Theme.Secondary,
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

function UI.Notify(Message, Duration, Style)
    Duration = Duration or Config.NotificationDuration
    local Frame = UI.CreateFrame(PlayerGui, {
        Size = UDim2.new(0, 320, 0, 52),
        Position = UDim2.new(1, -340, 0, 24),
        BackgroundColor3 = Style == "Danger" and Config.Theme.Warning or Style == "Success" and Config.Theme.Success or Config.Theme.Secondary,
        ZIndex = 50,
    })

    UI.CreateLabel(Frame, {
        Text = Message,
        TextSize = 14,
        TextColor3 = Config.Theme.Dark,
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local In = TweenService:Create(Frame, TweenInfo.new(0.2), {Position = UDim2.new(1, -340, 0, 24)})
    In:Play()

    task.delay(Duration, function()
        local Out = TweenService:Create(Frame, TweenInfo.new(0.2), {Position = UDim2.new(1, 20, 0, 24)})
        Out:Play()
        Out.Completed:Connect(function()
            UI.SafeDestroy(Frame)
        end)
    end)
end

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
local player = game.Players.LocalPlayer
if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = 90
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
}

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

function ScriptHub:GetScripts(Category)
    local Items = {}
    for _, Item in ipairs(ScriptLibrary) do
        if Item.Category == Category then
            table.insert(Items, Item)
        end
    end
    return Items
end

function ScriptHub:Execute(ScriptData)
    local Loaded = loadstring(ScriptData.Code)
    if Loaded then
        pcall(Loaded)
        UI.Notify("Executed " .. ScriptData.Name, 2, "Success")
    else
        UI.Notify("Failed to load script", 2, "Danger")
    end
end

function ScriptHub:Open()
    if self.MainGui then
        UI.SafeDestroy(self.MainGui)
    end

    local Gui = UI.Create("ScreenGui", {
        Parent = PlayerGui,
        ResetOnSpawn = false,
        Name = "ScriptHubGui",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    self.MainGui = Gui

    local Root = UI.CreateFrame(Gui, {
        Size = UDim2.new(0.94, 0, 0.88, 0),
        Position = UDim2.new(0.03, 0, 0.06, 0),
        BackgroundColor3 = Config.Theme.Dark,
        UseStroke = true,
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
        Position = UDim2.new(0, 14, 0, 14),
        Size = UDim2.new(0.5, 0, 0, 34),
    })

    local SearchBox = UI.CreateTextBox(Header, {
        Size = UDim2.new(0.35, 0, 0, 38),
        Position = UDim2.new(0.55, 0, 0, 12),
        PlaceholderText = "Search scripts...",
    })

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

    local Content = UI.CreateFrame(Body, {
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
    })

    local SidebarLayout = UI.Create("UIListLayout", {
        Parent = SidebarScroll,
        Padding = UDim.new(0, 8),
    })
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentScroll = UI.Create("ScrollingFrame", {
        Parent = Content,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 6,
    })

    local ContentLayout = UI.Create("UIListLayout", {
        Parent = ContentScroll,
        Padding = UDim.new(0, 12),
    })
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Categories = self:GetCategories()
    local ActiveCategory = Categories[1] or "player / stats"

    local function RenderSidebar()
        for _, Child in ipairs(SidebarScroll:GetChildren()) do
            if Child:IsA("Frame") then
                UI.SafeDestroy(Child)
            end
        end

        for _, Category in ipairs(Categories) do
            local Button = UI.CreateButton(SidebarScroll, {
                Text = Category,
                Size = UDim2.new(1, -18, 0, 38),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = ActiveCategory == Category and Config.Theme.Accent or Config.Theme.Primary,
                TextColor3 = Config.Theme.Light,
                HoverColor = Config.Theme.Success,
                Callback = function()
                    ActiveCategory = Category
                    RenderSidebar()
                    RenderContent()
                end,
            })
            Button.TextXAlignment = Enum.TextXAlignment.Left
        end

        SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 12)
    end

    local function RenderContent()
        for _, Child in ipairs(ContentScroll:GetChildren()) do
            if Child:IsA("Frame") then
                UI.SafeDestroy(Child)
            end
        end

        local Scripts = self:GetScripts(ActiveCategory)
        local Height = 0
        for _, ScriptData in ipairs(Scripts) do
            local Card = UI.CreateFrame(ContentScroll, {
                Size = UDim2.new(1, -20, 0, 96),
                BackgroundColor3 = Config.Theme.Secondary,
                UseStroke = true,
                ZIndex = 2,
            })

            UI.CreateLabel(Card, {
                Text = ScriptData.Name,
                TextSize = 16,
                Position = UDim2.new(0, 14, 0, 12),
                Size = UDim2.new(0.55, 0, 0, 24),
            })

            UI.CreateLabel(Card, {
                Text = ScriptData.Category,
                TextSize = 12,
                Position = UDim2.new(0, 14, 0, 40),
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
                    self:Execute(ScriptData)
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
                        UI.Notify("Copied script", 2, "Success")
                    else
                        UI.Notify("Clipboard unavailable", 2, "Warning")
                    end
                end,
            })

            Height = Height + 108
        end

        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, Height + 16)
    end

    RenderSidebar()
    RenderContent()
end

ScriptHub:Open()
