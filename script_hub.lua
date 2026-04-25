-- ============================================================================
-- ROBLOX SCRIPT HUB - Orion UI Library Edition
-- Keyless hub with premium window UI and extensive built-in script library
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function CleanupExistingHub()
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ScriptHubGui" then
            pcall(function()
                gui:Destroy()
            end)
        end
    end
end

CleanupExistingHub()

local UI = {}
function UI.Create(ClassName, Properties)
    local instance = Instance.new(ClassName)
    for property, value in pairs(Properties or {}) do
        instance[property] = value
    end
    return instance
end

function UI.Notify(Message, Duration)
    Duration = Duration or 2
    local toast = UI.Create("Frame", {
        Parent = PlayerGui,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.02, 0),
        Size = UDim2.new(0, 360, 0, 52),
        BackgroundColor3 = Color3.fromRGB(22, 24, 34),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 1000,
    })
    UI.Create("UICorner", {Parent = toast, CornerRadius = UDim.new(0, 12)})
    UI.Create("UIStroke", {Parent = toast, Color = Color3.fromRGB(90, 130, 255), Thickness = 1, Transparency = 0.8})

    UI.Create("TextLabel", {
        Parent = toast,
        Size = UDim2.new(1, -24, 1, -12),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Text = Message,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(235, 240, 255),
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })

    toast.Position = UDim2.new(0.5, -180, 0, 16)
    TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
    task.delay(Duration, function()
        if toast and toast.Parent then
            TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
            task.delay(0.25, function()
                if toast then
                    toast:Destroy()
                end
            end)
        end
    end)
end

local Orion = {}
function Orion:CreateWindow(Title)
    local ScreenGui = UI.Create("ScreenGui", {
        Parent = PlayerGui,
        Name = "ScriptHubGui",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    local mainFrame = UI.Create("Frame", {
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 980, 0, 620),
        BackgroundColor3 = Color3.fromRGB(16, 18, 28),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    UI.Create("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0, 22)})

    local shadow = UI.Create("ImageLabel", {
        Parent = mainFrame,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1.08, 0, 1.08, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6023426915",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ZIndex = 0,
    })

    local container = UI.Create("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(18, 20, 32),
        BorderSizePixel = 0,
    })

    local titleBar = UI.Create("Frame", {
        Parent = container,
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = Color3.fromRGB(10, 12, 22),
        BorderSizePixel = 0,
    })
    UI.Create("UICorner", {Parent = titleBar, CornerRadius = UDim.new(0, 22)})

    local titleLabel = UI.Create("TextLabel", {
        Parent = titleBar,
        Position = UDim2.new(0.03, 0, 0.1, 0),
        Size = UDim2.new(0.7, 0, 0.8, 0),
        BackgroundTransparency = 1,
        Text = Title,
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextColor3 = Color3.fromRGB(190, 210, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local subtitle = UI.Create("TextLabel", {
        Parent = titleBar,
        Position = UDim2.new(0.72, 0, 0.15, 0),
        Size = UDim2.new(0.25, 0, 0.75, 0),
        BackgroundTransparency = 1,
        Text = "Library Edition",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(150, 170, 220),
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local topAccent = UI.Create("UIGradient", {
        Parent = titleBar,
        Rotation = 90,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 120, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 190, 255)),
        },
    })

    local sidebar = UI.Create("Frame", {
        Parent = container,
        Position = UDim2.new(0, 0, 0, 72),
        Size = UDim2.new(0, 260, 1, -72),
        BackgroundColor3 = Color3.fromRGB(14, 16, 26),
        BorderSizePixel = 0,
    })
    UI.Create("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0, 20)})

    local sideTitle = UI.Create("TextLabel", {
        Parent = sidebar,
        Position = UDim2.new(0, 0, 0, 16),
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Text = "CATEGORIES",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(170, 190, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    local tabList = UI.Create("ScrollingFrame", {
        Parent = sidebar,
        Position = UDim2.new(0, 0, 0, 68),
        Size = UDim2.new(1, 0, 1, -74),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 8,
    })

    local tabLayout = UI.Create("UIListLayout", {
        Parent = tabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
    })

    local contentArea = UI.Create("Frame", {
        Parent = container,
        Position = UDim2.new(0, 260, 0, 72),
        Size = UDim2.new(1, -260, 1, -72),
        BackgroundTransparency = 1,
    })

    local contentTitle = UI.Create("TextLabel", {
        Parent = contentArea,
        Position = UDim2.new(0, 20, 0, 12),
        Size = UDim2.new(1, -40, 0, 30),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(220, 232, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local searchBox = UI.Create("TextBox", {
        Parent = contentArea,
        Position = UDim2.new(0, 20, 0, 54),
        Size = UDim2.new(0.55, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(22, 24, 38),
        BorderSizePixel = 0,
        PlaceholderText = "Search scripts...",
        Text = "",
        TextColor3 = Color3.fromRGB(230, 230, 255),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    UI.Create("UICorner", {Parent = searchBox, CornerRadius = UDim.new(0, 12)})
    UI.Create("UIStroke", {Parent = searchBox, Color = Color3.fromRGB(70, 120, 255), Thickness = 1, Transparency = 0.8})

    local tabContainer = UI.Create("Frame", {
        Parent = contentArea,
        Position = UDim2.new(0, 20, 0, 104),
        Size = UDim2.new(1, -40, 1, -118),
        BackgroundTransparency = 1,
    })

    local Window = {
        ScreenGui = ScreenGui,
        Title = Title,
        SearchBox = searchBox,
        TabList = tabList,
        ActiveTab = nil,
        Tabs = {},
        ContentTitle = contentTitle,
        Container = tabContainer,
    }

    function Window:AddTab(Name)
        local button = UI.Create("TextButton", {
            Parent = tabList,
            Size = UDim2.new(1, -24, 0, 44),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundColor3 = Color3.fromRGB(18, 20, 34),
            BorderSizePixel = 0,
            Text = Name,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(200, 215, 255),
            AutoButtonColor = false,
        })
        UI.Create("UICorner", {Parent = button, CornerRadius = UDim.new(0, 12)})
        UI.Create("UIStroke", {Parent = button, Color = Color3.fromRGB(80, 130, 255), Thickness = 1, Transparency = 0.85})

        local page = UI.Create("Frame", {
            Parent = tabContainer,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
        })

        local pageList = UI.Create("ScrollingFrame", {
            Parent = page,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 8,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })

        local listLayout = UI.Create("UIListLayout", {
            Parent = pageList,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 18),
        })

        local tab = {
            Name = Name,
            Button = button,
            Page = page,
            ContentFrame = pageList,
            Layout = listLayout,
            Scripts = {},
        }

        function button:Activate()
            for _, entry in ipairs(Window.Tabs) do
                entry.Button.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
                entry.Button.TextColor3 = Color3.fromRGB(200, 215, 255)
                entry.Page.Visible = false
            end
            button.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            tab.Page.Visible = true
            Window.ActiveTab = tab
            Window.ContentTitle.Text = Name
            Window:RefreshScripts()
        end

        button.MouseButton1Click:Connect(function()
            button:Activate()
        end)

        table.insert(Window.Tabs, tab)
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 12)
        return tab
    end

    function Window:CreateCard(Title, Description, ButtonText, Callback, Accent)
        local card = UI.Create("Frame", {
            Parent = self.ActiveTab.ContentFrame,
            Size = UDim2.new(1, 0, 0, 128),
            BackgroundColor3 = Color3.fromRGB(20, 24, 38),
            BorderSizePixel = 0,
        })
        UI.Create("UICorner", {Parent = card, CornerRadius = UDim.new(0, 18)})
        UI.Create("UIStroke", {Parent = card, Color = Color3.fromRGB(72, 108, 255), Thickness = 1, Transparency = 0.8})

        local titleLabel = UI.Create("TextLabel", {
            Parent = card,
            Position = UDim2.new(0, 18, 0, 14),
            Size = UDim2.new(1, -36, 0, 26),
            BackgroundTransparency = 1,
            Text = Title,
            Font = Enum.Font.GothamBold,
            TextSize = 17,
            TextColor3 = Color3.fromRGB(232, 242, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local descriptionLabel = UI.Create("TextLabel", {
            Parent = card,
            Position = UDim2.new(0, 18, 0, 40),
            Size = UDim2.new(1, -34, 0, 52),
            BackgroundTransparency = 1,
            Text = Description,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(178, 190, 220),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
        })

        local actionButton = UI.Create("TextButton", {
            Parent = card,
            Position = UDim2.new(1, -148, 1, -52),
            Size = UDim2.new(0, 130, 0, 38),
            BackgroundColor3 = Accent or Color3.fromRGB(105, 150, 255),
            BorderSizePixel = 0,
            Text = ButtonText,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(18, 18, 28),
            AutoButtonColor = false,
        })
        UI.Create("UICorner", {Parent = actionButton, CornerRadius = UDim.new(0, 12)})

        actionButton.MouseButton1Click:Connect(function()
            local okay, reason = pcall(Callback)
            if not okay then
                UI.Notify("Failed: " .. tostring(reason), 3)
            end
        end)

        return card
    end

    function Window:RefreshScripts()
        if not self.ActiveTab then
            return
        end

        for _, child in ipairs(self.ActiveTab.ContentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local query = string.lower(self.SearchBox.Text or "")
        for _, scriptData in ipairs(self.ActiveTab.Scripts) do
            local matches = query == "" or string.find(string.lower(scriptData.Name), query, 1, true) or string.find(string.lower(scriptData.Category), query, 1, true)
            if matches then
                self:CreateCard(scriptData.Name, scriptData.Description, scriptData.ButtonText, scriptData.Callback, scriptData.Accent)
            end
        end

        local listLayout = self.ActiveTab.ContentFrame:FindFirstChildOfClass("UIListLayout")
        if listLayout then
            self.ActiveTab.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end
    end

    searchBox.FocusLost:Connect(function(enter)
        if enter then
            Window:RefreshScripts()
        end
    end)

    searchBox.Changed:Connect(function(property)
        if property == "Text" then
            Window:RefreshScripts()
        end
    end)

    return Window
end

local function loadSource(code)
    local loader = loadstring or load
    return loader(code)
end

local Window = Orion:CreateWindow("🔮 ROBLOX SCRIPT HUB")

local ScriptLibrary = {
    {Name = "Infinite Jump", Category = "player / stats", Description = "Unlimited high jumps with smooth control.", ButtonText = "Run", Accent = Color3.fromRGB(120, 225, 255), Code = [[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
Humanoid.JumpPower = 250
Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
]]},
    {Name = "Speed Boost", Category = "player / stats", Description = "Set a fast walk speed instantly.", ButtonText = "Run", Accent = Color3.fromRGB(90, 220, 130), Code = [[
local player = game.Players.LocalPlayer
if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = 140
end
]]},
    {Name = "God Mode", Category = "player / stats", Description = "Max health and no fall damage.", ButtonText = "Run", Accent = Color3.fromRGB(255, 215, 90), Code = [[
local p = game.Players.LocalPlayer
if p.Character and p.Character:FindFirstChild("Humanoid") then
    p.Character.Humanoid.MaxHealth = 1e8
    p.Character.Humanoid.Health = 1e8
    p.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end
]]},
    {Name = "Super Jump", Category = "player / stats", Description = "Boost jump height for epic launch.", ButtonText = "Run", Accent = Color3.fromRGB(180, 100, 255), Code = [[
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
hum.JumpPower = 230
]]},
    {Name = "Auto Sprint", Category = "player / stats", Description = "Hold shift to move faster automatically.", ButtonText = "Run", Accent = Color3.fromRGB(140, 240, 255), Code = [[
local UIS = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local speed = 90
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftShift then
        hum.WalkSpeed = speed
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        hum.WalkSpeed = 16
    end
end)
]]},
    {Name = "Teleport All", Category = "players", Description = "Move every player to your location.", ButtonText = "Run", Accent = Color3.fromRGB(255, 125, 90), Code = [[
local plr = game.Players.LocalPlayer
if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
    local target = plr.Character.HumanoidRootPart.CFrame
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = target
        end
    end
end
]]},
    {Name = "Knockback All", Category = "players", Description = "Send everyone flying with a blast.", ButtonText = "Run", Accent = Color3.fromRGB(255, 90, 90), Code = [[
local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not root then return end
for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= game.Players.LocalPlayer then
        player.Character.HumanoidRootPart.Velocity = (player.Character.HumanoidRootPart.Position - root.Position).Unit * 200 + Vector3.new(0, 100, 0)
    end
end
]]},
    {Name = "Bring All", Category = "players", Description = "Teleport everyone directly to you.", ButtonText = "Run", Accent = Color3.fromRGB(130, 220, 190), Code = [[
local me = game.Players.LocalPlayer
local target = me.Character and me.Character:FindFirstChild("HumanoidRootPart")
if not target then return end
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= me and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = target.CFrame
    end
end
]]},
    {Name = "Freeze All", Category = "players", Description = "Lock all players in place.", ButtonText = "Run", Accent = Color3.fromRGB(170, 170, 255), Code = [[
for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 0
        player.Character.Humanoid.JumpPower = 0
    end
end
]]},
    {Name = "Fling Everyone", Category = "players", Description = "Ragdoll everyone with sudden force.", ButtonText = "Run", Accent = Color3.fromRGB(255, 160, 90), Code = [[
for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= game.Players.LocalPlayer then
        player.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-300, 300), 250, math.random(-300, 300))
    end
end
]]},
    {Name = "Chat Spam", Category = "troll", Description = "Spam chat rapidly with your message.", ButtonText = "Run", Accent = Color3.fromRGB(255, 85, 180), Code = [[
local Chat = game:GetService("Chat")
local plr = game.Players.LocalPlayer
for i = 1, 20 do
    if plr.Character and plr.Character:FindFirstChild("Head") then
        Chat:Chat(plr.Character.Head, "KEYLESS ALL", Enum.ChatColor.Red)
    end
    task.wait(0.12)
end
]]},
    {Name = "Mini Nuke", Category = "troll", Description = "Create a fake explosion at your position.", ButtonText = "Run", Accent = Color3.fromRGB(255, 120, 120), Code = [[
local part = Instance.new("Part")
part.Size = Vector3.new(6, 6, 6)
part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
part.Anchored = true
part.CanCollide = false
part.Material = Enum.Material.Neon
part.BrickColor = BrickColor.new("Bright orange")
part.Parent = workspace
game:GetService("Debris"):AddItem(part, 2)
]]},
    {Name = "Invisible Spray", Category = "troll", Description = "Blind players with purple particles.", ButtonText = "Run", Accent = Color3.fromRGB(150, 80, 255), Code = [[
local emitter = Instance.new("ParticleEmitter")
emitter.Texture = "rbxassetid://241594269"
emitter.Rate = 100
emitter.Lifetime = NumberRange.new(0.5)
emitter.Speed = NumberRange.new(5)
emitter.Parent = game.Players.LocalPlayer.Character.Head
task.delay(2, function()
    emitter.Enabled = false
    task.wait(1)
    emitter:Destroy()
end)
]]},
    {Name = "Lag Server", Category = "troll", Description = "Spawn lots of invisible parts to create lag.", ButtonText = "Run", Accent = Color3.fromRGB(255, 80, 80), Code = [[
for i = 1, 35 do
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.CFrame = CFrame.new(math.random(-500, 500), math.random(0, 150), math.random(-500, 500))
    part.Parent = workspace
end
]]},
    {Name = "Fake Explode", Category = "troll", Description = "Create a dramatic explosion effect near you.", ButtonText = "Run", Accent = Color3.fromRGB(255, 140, 0), Code = [[
local plr = game.Players.LocalPlayer
local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
if not root then return end
local exp = Instance.new("Explosion")
exp.Position = root.Position
exp.BlastPressure = 0
exp.BlastRadius = 18
exp.Parent = workspace
]]},
    {Name = "Rainbow Player", Category = "cosmetics", Description = "Color your character in rainbow mode.", ButtonText = "Run", Accent = Color3.fromRGB(255, 125, 255), Code = [[
local plr = game.Players.LocalPlayer
for _, part in ipairs(plr.Character:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Color = Color3.fromHSV(tick() % 1, 1, 1)
    end
end
]]},
    {Name = "Full Bright", Category = "cosmetics", Description = "Brighten the environment instantly.", ButtonText = "Run", Accent = Color3.fromRGB(120, 255, 200), Code = [[
game:GetService("Lighting").Ambient = Color3.fromRGB(255,255,255)
game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255,255,255)
]]},
    {Name = "Staff Aura", Category = "cosmetics", Description = "Give yourself a glowing aura.", ButtonText = "Run", Accent = Color3.fromRGB(95, 230, 255), Code = [[
local plr = game.Players.LocalPlayer
for _, part in ipairs(plr.Character:GetDescendants()) do
    if part:IsA("BasePart") then
        local ps = Instance.new("ParticleEmitter")
        ps.Texture = "rbxassetid://7506215576"
        ps.LightEmission = 0.8
        ps.Rate = 40
        ps.Parent = part
        game:GetService("Debris"):AddItem(ps, 8)
    end
end
]]},
    {Name = "Hat Float", Category = "cosmetics", Description = "Make your hat float above your head.", ButtonText = "Run", Accent = Color3.fromRGB(205, 120, 255), Code = [[
local plr = game.Players.LocalPlayer
for _, hat in ipairs(plr.Character:GetChildren()) do
    if hat:IsA("Accessory") then
        local attachment = Instance.new("Attachment")
        attachment.Parent = plr.Character.Head
        attachment.Position = Vector3.new(0, 1.5, 0)
        hat.Handle.CFrame = plr.Character.Head.CFrame * CFrame.new(0, 1.5, 0)
    end
end
]]},
    {Name = "Glass Shader", Category = "cosmetics", Description = "Turn your character into glass.", ButtonText = "Run", Accent = Color3.fromRGB(135, 210, 255), Code = [[
local plr = game.Players.LocalPlayer
for _, part in ipairs(plr.Character:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Transparency = 0.4
        part.Material = Enum.Material.Glass
    end
end
]]},
    {Name = "Delete All Parts", Category = "world", Description = "Remove all world parts except the baseplate.", ButtonText = "Run", Accent = Color3.fromRGB(255, 95, 95), Code = [[
for _, part in ipairs(workspace:GetChildren()) do
    if part:IsA("BasePart") and part.Name ~= "Baseplate" then
        part:Destroy()
    end
end
]]},
    {Name = "Unanchor All", Category = "world", Description = "Unanchor every part in the workspace.", ButtonText = "Run", Accent = Color3.fromRGB(255, 170, 80), Code = [[
for _, part in ipairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Anchored = false
    end
end
]]},
    {Name = "Gravity Low", Category = "world", Description = "Drop the gravity for floaty gameplay.", ButtonText = "Run", Accent = Color3.fromRGB(120, 240, 255), Code = [[
game:GetService("Workspace").Gravity = 10
]]},
    {Name = "Sky Teleport", Category = "world", Description = "Teleport your character high above the map.", ButtonText = "Run", Accent = Color3.fromRGB(170, 160, 255), Code = [[
local plr = game.Players.LocalPlayer
if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(0, 300, 0)
end
]]},
    {Name = "Water Walk", Category = "world", Description = "Walk on water surfaces safely.", ButtonText = "Run", Accent = Color3.fromRGB(90, 200, 255), Code = [[
for _, part in ipairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") and part.Material == Enum.Material.Water then
        part.Anchored = true
    end
end
]]},
    {Name = "Rejoin Server", Category = "utility", Description = "Leave and rejoin the current game server.", ButtonText = "Run", Accent = Color3.fromRGB(255, 195, 90), Code = [[
local TeleportService = game:GetService("TeleportService")
local current = game.PlaceId
TeleportService:Teleport(current, game.Players.LocalPlayer)
]]},
    {Name = "SetProp Helper", Category = "utility", Description = "Create a safe property setter function.", ButtonText = "Define", Accent = Color3.fromRGB(140, 220, 255), Code = [[
function SetProp(obj, prop, val)
    if obj and obj[prop] ~= nil then
        obj[prop] = val
    end
end
print("SetProp defined")
]]},
    {Name = "SafeExecute", Category = "utility", Description = "Define a safe script executor function.", ButtonText = "Define", Accent = Color3.fromRGB(120, 255, 170), Code = [[
function SafeExecute(func)
    local success, err = pcall(func)
    if not success then
        warn(err)
    end
end
print("SafeExecute defined")
]]},
    {Name = "Copy All Scripts", Category = "utility", Description = "Copy a helper command reference to clipboard.", ButtonText = "Run", Accent = Color3.fromRGB(255, 170, 255), Code = [[
if setclipboard then
    setclipboard("Use SafeExecute(function() ... end) and SetProp(obj, prop, val)")
    print("Helper copied")
else
    warn("Clipboard unavailable")
end
]]},
    {Name = "Refresh UI", Category = "utility", Description = "Reload the hub UI cleanly.", ButtonText = "Run", Accent = Color3.fromRGB(255, 140, 180), Code = [[
for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
    if gui.Name == "ScriptHubGui" then
        gui:Destroy()
    end
end
print("Reload and run again")
]]},
    {Name = "Anti AFK", Category = "exploits", Description = "Prevent the game from kicking you for AFK.", ButtonText = "Run", Accent = Color3.fromRGB(110, 255, 140), Code = [[
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
]]},
    {Name = "Hitbox Extender", Category = "exploits", Description = "Enlarge hitboxes for better targeting.", ButtonText = "Run", Accent = Color3.fromRGB(255, 120, 120), Code = [[
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local root = plr.Character.HumanoidRootPart
        root.Size = Vector3.new(5, 5, 5)
    end
end
]]},
    {Name = "Silent Aim", Category = "exploits", Description = "Placeholder exploit helper for aiming scripts.", ButtonText = "Run", Accent = Color3.fromRGB(255, 215, 80), Code = [[
print("Silent Aim placeholder initialized")
]]},
    {Name = "No Ragdoll", Category = "exploits", Description = "Disable ragdoll effects on your character.", ButtonText = "Run", Accent = Color3.fromRGB(170, 255, 190), Code = [[
local plr = game.Players.LocalPlayer
if plr.Character and plr.Character:FindFirstChild("Humanoid") then
    plr.Character.Humanoid.RagdollOnDeath = false
end
]]},
    {Name = "Auto Farm", Category = "exploits", Description = "Collect nearby items automatically.", ButtonText = "Run", Accent = Color3.fromRGB(100, 220, 255), Code = [[
for _, item in ipairs(workspace:GetDescendants()) do
    if item:IsA("BasePart") and item.Name:match("Coin") then
        item.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end
]]},
    {Name = "Disco Mode", Category = "fun", Description = "Flash your character with disco lights.", ButtonText = "Run", Accent = Color3.fromRGB(255, 90, 255), Code = [[
local plr = game.Players.LocalPlayer
for _, part in ipairs(plr.Character:GetDescendants()) do
    if part:IsA("BasePart") then
        part.BrickColor = BrickColor.Random()
    end
end
]]},
    {Name = "Spin Around", Category = "fun", Description = "Rotate your character rapidly.", ButtonText = "Run", Accent = Color3.fromRGB(180, 180, 255), Code = [[
local plr = game.Players.LocalPlayer
local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
if not hrp then return end
for i = 1, 40 do
    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
    task.wait(0.05)
end
]]},
    {Name = "Launch Into Sky", Category = "fun", Description = "Blast yourself into the clouds.", ButtonText = "Run", Accent = Color3.fromRGB(120, 200, 255), Code = [[
local plr = game.Players.LocalPlayer
if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
    plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 200, 0)
end
]]},
    {Name = "Moonwalk", Category = "fun", Description = "Slide backward like a moonwalk pro.", ButtonText = "Run", Accent = Color3.fromRGB(200, 255, 180), Code = [[
local plr = game.Players.LocalPlayer
if plr.Character and plr.Character:FindFirstChild("Humanoid") then
    plr.Character.Humanoid.WalkSpeed = 8
    plr.Character.Humanoid.MoveDirection = Vector3.new(0,0,-1)
end
]]},
    {Name = "Dance Party", Category = "fun", Description = "Apply a dance animation to your character.", ButtonText = "Run", Accent = Color3.fromRGB(255, 140, 255), Code = [[
local plr = game.Players.LocalPlayer
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://507766666"
local track = plr.Character.Humanoid:LoadAnimation(anim)
track:Play()
]]},
}

local categoryTabs = {}
for _, entry in ipairs(ScriptLibrary) do
    if not categoryTabs[entry.Category] then
        categoryTabs[entry.Category] = Window:AddTab(entry.Category)
    end
    table.insert(categoryTabs[entry.Category].Scripts, {
        Name = entry.Name,
        Category = entry.Category,
        Description = entry.Description,
        ButtonText = entry.ButtonText,
        Accent = entry.Accent,
        Callback = function()
            local func = loadSource(entry.Code)
            if func then
                local ok, err = pcall(func)
                if not ok then
                    UI.Notify("Script error: " .. tostring(err), 3)
                else
                    UI.Notify("Executed: " .. entry.Name, 2)
                end
            else
                UI.Notify("Invalid script code.", 2)
            end
        end,
    })
end

if #Window.Tabs > 0 then
    Window.Tabs[1].Button:Activate()
end
