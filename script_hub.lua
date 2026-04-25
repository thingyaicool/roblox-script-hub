-- ============================================================================
-- ROBLOX SCRIPT HUB - Modern Sirius UI Edition
-- Built-in UI effects, gradients, and polished modern layout
-- ============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function clearOldHub()
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ScriptHubGui" then
            pcall(function()
                gui:Destroy()
            end)
        end
    end
end

clearOldHub()

local SiriusUI = {}

function SiriusUI.Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

function SiriusUI.ApplyGradient(instance, colorA, colorB, rotation)
    local gradient = SiriusUI.Create("UIGradient", {
        Parent = instance,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colorA),
            ColorSequenceKeypoint.new(1, colorB),
        }),
        Rotation = rotation or 0,
    })
    return gradient
end

function SiriusUI.Tween(instance, properties, duration, easing, direction)
    easing = easing or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration or 0.25, easing, direction)
    return TweenService:Create(instance, tweenInfo, properties)
end

function SiriusUI.Notify(message, duration)
    duration = duration or 2.5
    local toast = SiriusUI.Create("Frame", {
        Parent = PlayerGui,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.025, 0),
        Size = UDim2.new(0, 380, 0, 56),
        BackgroundColor3 = Color3.fromRGB(23, 26, 42),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 999,
    })
    SiriusUI.Create("UICorner", {Parent = toast, CornerRadius = UDim.new(0, 18)})
    SiriusUI.Create("UIStroke", {Parent = toast, Color = Color3.fromRGB(97, 142, 255), Thickness = 1, Transparency = 0.7})

    local label = SiriusUI.Create("TextLabel", {
        Parent = toast,
        Size = UDim2.new(1, -32, 1, -20),
        Position = UDim2.new(0, 16, 0, 10),
        BackgroundTransparency = 1,
        Text = message,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(235, 240, 255),
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })

    toast.Position = UDim2.new(0.5, -toast.Size.X.Offset / 2, 0, 18)
    SiriusUI.Tween(toast, {BackgroundTransparency = 0}, 0.2):Play()
    task.delay(duration, function()
        if toast and toast.Parent then
            SiriusUI.Tween(toast, {BackgroundTransparency = 1}, 0.2):Play()
            task.delay(0.25, function()
                if toast then
                    toast:Destroy()
                end
            end)
        end
    end)
end

function SiriusUI.CreateWindow(title)
    local screenGui = SiriusUI.Create("ScreenGui", {
        Parent = PlayerGui,
        Name = "ScriptHubGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    local mainFrame = SiriusUI.Create("Frame", {
        Parent = screenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0.5, 0.5, 0),
        Size = UDim2.new(0, 980, 0, 620),
        BackgroundColor3 = Color3.fromRGB(15, 18, 28),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    SiriusUI.Create("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0, 24)})
    SiriusUI.ApplyGradient(mainFrame, Color3.fromRGB(14, 17, 27), Color3.fromRGB(18, 22, 35), 90)

    local accentBar = SiriusUI.Create("Frame", {
        Parent = mainFrame,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = Color3.fromRGB(80, 130, 255),
        BorderSizePixel = 0,
    })
    SiriusUI.Create("UIGradient", {
        Parent = accentBar,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 165, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 200, 255)),
        }),
        Rotation = 0,
    })

    local header = SiriusUI.Create("Frame", {
        Parent = mainFrame,
        Position = UDim2.new(0, 0, 0, 8),
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundTransparency = 1,
    })

    SiriusUI.Create("TextLabel", {
        Parent = header,
        Position = UDim2.new(0.04, 0, 0.2, 0),
        Size = UDim2.new(0.5, 0, 0.7, 0),
        BackgroundTransparency = 1,
        Text = "🔮 ROBLOX SCRIPT HUB",
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextColor3 = Color3.fromRGB(240, 245, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    SiriusUI.Create("TextLabel", {
        Parent = header,
        Position = UDim2.new(0.52, 0, 0.3, 0),
        Size = UDim2.new(0.44, 0, 0.55, 0),
        BackgroundTransparency = 1,
        Text = "Modern Sirius Edition",
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = Color3.fromRGB(170, 180, 215),
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local body = SiriusUI.Create("Frame", {
        Parent = mainFrame,
        Position = UDim2.new(0, 0, 0, 80),
        Size = UDim2.new(1, 0, 1, -80),
        BackgroundTransparency = 1,
    })

    local sidebar = SiriusUI.Create("Frame", {
        Parent = body,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(0, 260, 1, -20),
        BackgroundColor3 = Color3.fromRGB(18, 22, 34),
        BorderSizePixel = 0,
    })
    SiriusUI.Create("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0, 20)})
    SiriusUI.Create("UIStroke", {Parent = sidebar, Color = Color3.fromRGB(62, 86, 160), Thickness = 1, Transparency = 0.75})
    SiriusUI.ApplyGradient(sidebar, Color3.fromRGB(18, 22, 34), Color3.fromRGB(16, 20, 32), 90)

    local sidebarTitle = SiriusUI.Create("TextLabel", {
        Parent = sidebar,
        Position = UDim2.new(0, 0, 0, 18),
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "CATEGORIES",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(165, 180, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    local categoryFrame = SiriusUI.Create("ScrollingFrame", {
        Parent = sidebar,
        Position = UDim2.new(0, 0, 0, 56),
        Size = UDim2.new(1, 0, 1, -66),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 10,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    })
    local categoryLayout = SiriusUI.Create("UIListLayout", {Parent = categoryFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
    SiriusUI.Create("UIPadding", {Parent = categoryFrame, PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14)})

    local mainArea = SiriusUI.Create("Frame", {
        Parent = body,
        Position = UDim2.new(0, 300, 0, 0),
        Size = UDim2.new(1, -320, 1, -20),
        BackgroundColor3 = Color3.fromRGB(18, 20, 30),
        BorderSizePixel = 0,
    })
    SiriusUI.Create("UICorner", {Parent = mainArea, CornerRadius = UDim.new(0, 20)})
    SiriusUI.Create("UIStroke", {Parent = mainArea, Color = Color3.fromRGB(66, 90, 170), Thickness = 1, Transparency = 0.8})
    SiriusUI.ApplyGradient(mainArea, Color3.fromRGB(16, 19, 29), Color3.fromRGB(20, 24, 35), 90)

    local searchBar = SiriusUI.Create("TextBox", {
        Parent = mainArea,
        Position = UDim2.new(0, 20, 0, 20),
        Size = UDim2.new(0.55, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(17, 20, 30),
        BorderSizePixel = 0,
        PlaceholderText = "Search scripts...",
        Text = "",
        TextColor3 = Color3.fromRGB(230, 230, 245),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    SiriusUI.Create("UICorner", {Parent = searchBar, CornerRadius = UDim.new(0, 14)})
    SiriusUI.Create("UIStroke", {Parent = searchBar, Color = Color3.fromRGB(80, 120, 220), Thickness = 1, Transparency = 0.9})

    local quickInfo = SiriusUI.Create("Frame", {
        Parent = mainArea,
        Position = UDim2.new(0.55, 20, 0, 20),
        Size = UDim2.new(0.42, -40, 0, 44),
        BackgroundColor3 = Color3.fromRGB(13, 16, 26),
        BorderSizePixel = 0,
    })
    SiriusUI.Create("UICorner", {Parent = quickInfo, CornerRadius = UDim.new(0, 14)})
    SiriusUI.ApplyGradient(quickInfo, Color3.fromRGB(20, 24, 38), Color3.fromRGB(16, 20, 30), 180)

    SiriusUI.Create("TextLabel", {
        Parent = quickInfo,
        Position = UDim2.new(0.03, 0, 0, 0),
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "Sirius style library with built-in filters",
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(190, 200, 235),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })

    local quickBadge = SiriusUI.Create("TextLabel", {
        Parent = quickInfo,
        Position = UDim2.new(0.8, 0, 0.12, 0),
        Size = UDim2.new(0.18, 0, 0.76, 0),
        BackgroundColor3 = Color3.fromRGB(67, 115, 255),
        BorderSizePixel = 0,
        Text = "LIVE",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    SiriusUI.Create("UICorner", {Parent = quickBadge, CornerRadius = UDim.new(0, 12)})

    local contentPane = SiriusUI.Create("Frame", {
        Parent = mainArea,
        Position = UDim2.new(0, 20, 0, 82),
        Size = UDim2.new(1, -40, 1, -102),
        BackgroundTransparency = 1,
    })

    local contentScroll = SiriusUI.Create("ScrollingFrame", {
        Parent = contentPane,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 10,
    })
    local contentLayout = SiriusUI.Create("UIListLayout", {Parent = contentScroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 18)})
    SiriusUI.Create("UIPadding", {Parent = contentScroll, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})

    local window = {
        ScreenGui = screenGui,
        TabButtons = {},
        Tabs = {},
        ActiveTab = nil,
        SearchBox = searchBar,
        CategoryFrame = categoryFrame,
        ScriptCanvas = contentScroll,
        ContentLayout = contentLayout,
    }

    function window:AddTab(name)
        local button = SiriusUI.Create("TextButton", {
            Parent = categoryFrame,
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = Color3.fromRGB(18, 22, 35),
            BorderSizePixel = 0,
            Text = name,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(210, 220, 255),
            AutoButtonColor = false,
        })
        SiriusUI.Create("UICorner", {Parent = button, CornerRadius = UDim.new(0, 14)})
        SiriusUI.Create("UIStroke", {Parent = button, Color = Color3.fromRGB(70, 110, 225), Thickness = 1, Transparency = 0.8})

        local tabPage = {
            Name = name,
            Button = button,
            Scripts = {},
        }

        function button:Activate()
            for _, tab in ipairs(window.Tabs) do
                tab.Button.BackgroundColor3 = Color3.fromRGB(18, 22, 35)
                tab.Button.TextColor3 = Color3.fromRGB(210, 220, 255)
            end
            button.BackgroundColor3 = Color3.fromRGB(70, 120, 235)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            window.ActiveTab = tabPage
            window:RefreshScripts()
        end

        button.MouseButton1Click:Connect(function()
            button:Activate()
        end)

        table.insert(window.Tabs, tabPage)
        window.CategoryFrame.CanvasSize = UDim2.new(0, 0, 0, categoryLayout.AbsoluteContentSize.Y + 16)
        return tabPage
    end

    function window:CreateCard(title, description, buttonText, callback, accent)
        local card = SiriusUI.Create("Frame", {
            Parent = self.ScriptCanvas,
            Size = UDim2.new(1, 0, 0, 140),
            BackgroundColor3 = Color3.fromRGB(15, 18, 28),
            BorderSizePixel = 0,
        })
        SiriusUI.Create("UICorner", {Parent = card, CornerRadius = UDim.new(0, 18)})
        SiriusUI.Create("UIStroke", {Parent = card, Color = Color3.fromRGB(75, 105, 230), Thickness = 1, Transparency = 0.8})

        SiriusUI.Create("TextLabel", {
            Parent = card,
            Position = UDim2.new(0, 18, 0, 14),
            Size = UDim2.new(1, -36, 0, 28),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = Color3.fromRGB(242, 248, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        SiriusUI.Create("TextLabel", {
            Parent = card,
            Position = UDim2.new(0, 18, 0, 40),
            Size = UDim2.new(1, -36, 0, 58),
            BackgroundTransparency = 1,
            Text = description,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(176, 188, 215),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
        })

        local runButton = SiriusUI.Create("TextButton", {
            Parent = card,
            Position = UDim2.new(1, -150, 1, -52),
            Size = UDim2.new(0, 130, 0, 42),
            BackgroundColor3 = accent or Color3.fromRGB(83, 132, 255),
            BorderSizePixel = 0,
            Text = buttonText,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(20, 24, 36),
            AutoButtonColor = false,
        })
        SiriusUI.Create("UICorner", {Parent = runButton, CornerRadius = UDim.new(0, 14)})
        SiriusUI.Create("UIStroke", {Parent = runButton, Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Transparency = 0.7})

        runButton.MouseButton1Click:Connect(function()
            local success, err = pcall(callback)
            if not success then
                SiriusUI.Notify("Execution failed: " .. tostring(err), 3)
            end
        end)

        return card
    end

    function window:RefreshScripts()
        if not self.ActiveTab then
            return
        end

        for _, child in ipairs(self.ScriptCanvas:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local query = string.lower(self.SearchBox.Text or "")
        local count = 0
        for _, scriptData in ipairs(self.ActiveTab.Scripts) do
            local nameLower = string.lower(scriptData.Name or "")
            local categoryLower = string.lower(scriptData.Category or "")
            local descLower = string.lower(scriptData.Description or "")
            if query == "" or string.find(nameLower, query, 1, true) or string.find(categoryLower, query, 1, true) or string.find(descLower, query, 1, true) then
                self:CreateCard(scriptData.Name, scriptData.Description, scriptData.ButtonText, scriptData.Callback, scriptData.Accent)
                count = count + 1
            end
        end

        self.ScriptCanvas.CanvasSize = UDim2.new(0, 0, 0, self.ContentLayout.AbsoluteContentSize.Y + 24)

        if count == 0 then
            local empty = SiriusUI.Create("TextLabel", {
                Parent = self.ScriptCanvas,
                Size = UDim2.new(1, 0, 0, 100),
                BackgroundTransparency = 1,
                Text = "No scripts match your search.",
                Font = Enum.Font.GothamMedium,
                TextSize = 16,
                TextColor3 = Color3.fromRGB(172, 180, 205),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
            })
            self.ScriptCanvas.CanvasSize = UDim2.new(0, 0, 0, 120)
        end
    end

    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        window:RefreshScripts()
    end)

    return window
end

local function loadSource(code)
    local loader = loadstring or load
    return loader(code)
end

local Window = SiriusUI.CreateWindow("🔮 ROBLOX SCRIPT HUB")

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
        Chat:Chat(plr.Character.Head, "SIRIUS MODE", Enum.ChatColor.Red)
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
                    SiriusUI.Notify("Script failed: " .. tostring(err), 3)
                else
                    SiriusUI.Notify("Executed: " .. entry.Name, 2.5)
                end
            else
                SiriusUI.Notify("Unable to parse script.", 2.5)
            end
        end,
    })
end

if #Window.Tabs > 0 then
    Window.Tabs[1].Button:Activate()
end
