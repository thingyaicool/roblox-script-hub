-- ============================================================================
-- ROBLOX SCRIPT HUB - Sirius UI Library Edition
-- Compact modern UI, real library-style API, all categories visible
-- ============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function cleanupOldHub()
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ScriptHubGui" then
            pcall(function()
                gui:Destroy()
            end)
        end
    end
end
cleanupOldHub()

local Sirius = {}

function Sirius.new(className, props)
    local instance = Instance.new(className)
    for property, value in pairs(props or {}) do
        instance[property] = value
    end
    return instance
end

function Sirius.gradient(target, colorA, colorB, rotation)
    local gradient = Sirius.new("UIGradient", {
        Parent = target,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colorA),
            ColorSequenceKeypoint.new(1, colorB),
        }),
        Rotation = rotation or 90,
    })
    return gradient
end

function Sirius.tween(instance, props, duration)
    local info = TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    return TweenService:Create(instance, info, props)
end

function Sirius.notify(text, duration)
    duration = duration or 2.5
    local toast = Sirius.new("Frame", {
        Parent = PlayerGui,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.025, 0),
        Size = UDim2.new(0, 340, 0, 52),
        BackgroundColor3 = Color3.fromRGB(18, 21, 34),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 999,
    })
    Sirius.new("UICorner", {Parent = toast, CornerRadius = UDim.new(0, 16)})
    Sirius.new("UIStroke", {Parent = toast, Color = Color3.fromRGB(90, 130, 255), Thickness = 1, Transparency = 0.8})

    Sirius.new("TextLabel", {
        Parent = toast,
        Size = UDim2.new(1, -28, 1, -16),
        Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(242, 246, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
    })

    toast.Position = UDim2.new(0.5, -170, 0, 18)
    Sirius.tween(toast, {BackgroundTransparency = 0}, 0.18):Play()
    task.delay(duration, function()
        if toast and toast.Parent then
            Sirius.tween(toast, {BackgroundTransparency = 1}, 0.18):Play()
            task.delay(0.22, function()
                if toast then
                    toast:Destroy()
                end
            end)
        end
    end)
end

function Sirius.createWindow(title)
    local screenGui = Sirius.new("ScreenGui", {
        Parent = PlayerGui,
        Name = "ScriptHubGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    local root = Sirius.new("Frame", {
        Parent = screenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0.5, 0.5, 0),
        Size = UDim2.new(0, 900, 0, 600),
        BackgroundColor3 = Color3.fromRGB(16, 18, 26),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    Sirius.new("UICorner", {Parent = root, CornerRadius = UDim.new(0, 24)})
    Sirius.gradient(root, Color3.fromRGB(14, 17, 26), Color3.fromRGB(17, 20, 32), 90)

    Sirius.new("Frame", {
        Parent = root,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Color3.fromRGB(84, 138, 255),
        BorderSizePixel = 0,
    })

    local header = Sirius.new("Frame", {
        Parent = root,
        Position = UDim2.new(0, 0, 0, 8),
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundTransparency = 1,
    })

    Sirius.new("TextLabel", {
        Parent = header,
        Position = UDim2.new(0.04, 0, 0.15, 0),
        Size = UDim2.new(0.5, 0, 0.7, 0),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(241, 245, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    Sirius.new("TextLabel", {
        Parent = header,
        Position = UDim2.new(0.55, 0, 0.15, 0),
        Size = UDim2.new(0.4, 0, 0.7, 0),
        BackgroundTransparency = 1,
        Text = "Sirius UI Library",
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(168, 180, 209),
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local body = Sirius.new("Frame", {
        Parent = root,
        Position = UDim2.new(0, 16, 0, 72),
        Size = UDim2.new(1, -32, 1, -88),
        BackgroundTransparency = 1,
    })

    local sidebar = Sirius.new("Frame", {
        Parent = body,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 240, 1, 0),
        BackgroundColor3 = Color3.fromRGB(18, 22, 34),
        BorderSizePixel = 0,
    })
    Sirius.new("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0, 18)})
    Sirius.new("UIStroke", {Parent = sidebar, Color = Color3.fromRGB(74, 106, 176), Thickness = 1, Transparency = 0.85})
    Sirius.gradient(sidebar, Color3.fromRGB(18, 22, 34), Color3.fromRGB(16, 20, 30), 90)

    Sirius.new("TextLabel", {
        Parent = sidebar,
        Position = UDim2.new(0, 0, 0, 14),
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "CATEGORIES",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(191, 201, 238),
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    local categoryPanel = Sirius.new("ScrollingFrame", {
        Parent = sidebar,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(1, 0, 1, -52),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 10,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
    })
    local categoryLayout = Sirius.new("UIListLayout", {
        Parent = categoryPanel,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 12),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    })
    Sirius.new("UIPadding", {Parent = categoryPanel, PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), PaddingBottom = UDim.new(0, 14)})

    local contentArea = Sirius.new("Frame", {
        Parent = body,
        Position = UDim2.new(0, 256, 0, 0),
        Size = UDim2.new(1, -256, 1, 0),
        BackgroundColor3 = Color3.fromRGB(19, 22, 34),
        BorderSizePixel = 0,
    })
    Sirius.new("UICorner", {Parent = contentArea, CornerRadius = UDim.new(0, 18)})
    Sirius.new("UIStroke", {Parent = contentArea, Color = Color3.fromRGB(76, 102, 182), Thickness = 1, Transparency = 0.85})
    Sirius.gradient(contentArea, Color3.fromRGB(18, 22, 34), Color3.fromRGB(16, 20, 30), 90)

    local searchBar = Sirius.new("TextBox", {
        Parent = contentArea,
        Position = UDim2.new(0, 18, 0, 18),
        Size = UDim2.new(0.6, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(13, 17, 28),
        BorderSizePixel = 0,
        PlaceholderText = "Search scripts...",
        Text = "",
        TextColor3 = Color3.fromRGB(235, 240, 255),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    Sirius.new("UICorner", {Parent = searchBar, CornerRadius = UDim.new(0, 14)})
    Sirius.new("UIStroke", {Parent = searchBar, Color = Color3.fromRGB(90, 130, 230), Thickness = 1, Transparency = 0.9})

    local infoPill = Sirius.new("Frame", {
        Parent = contentArea,
        Position = UDim2.new(0.62, 20, 0, 18),
        Size = UDim2.new(0.36, -38, 0, 38),
        BackgroundColor3 = Color3.fromRGB(15, 18, 28),
        BorderSizePixel = 0,
    })
    Sirius.new("UICorner", {Parent = infoPill, CornerRadius = UDim.new(0, 14)})
    Sirius.new("UIStroke", {Parent = infoPill, Color = Color3.fromRGB(96, 150, 255), Thickness = 1, Transparency = 0.9})

    Sirius.new("TextLabel", {
        Parent = infoPill,
        Size = UDim2.new(1, -18, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "Sirius style UI with all categories",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(204, 214, 245),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
    })

    local scriptContainer = Sirius.new("ScrollingFrame", {
        Parent = contentArea,
        Position = UDim2.new(0, 18, 0, 68),
        Size = UDim2.new(1, -36, 1, -86),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 10,
    })
    local scriptLayout = Sirius.new("UIListLayout", {Parent = scriptContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 16)})
    Sirius.new("UIPadding", {Parent = scriptContainer, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})

    local window = {
        Gui = screenGui,
        Root = root,
        Categories = {},
        CategoryButtons = {},
        ActiveCategory = nil,
        SearchBox = searchBar,
        ScriptContainer = scriptContainer,
        ScriptLayout = scriptLayout,
        CategoryFrame = categoryPanel,
        CategoryLayout = categoryLayout,
    }

    function window:AddCategory(name)
        local button = Sirius.new("TextButton", {
            Parent = categoryPanel,
            Size = UDim2.new(1, -8, 0, 46),
            BackgroundColor3 = Color3.fromRGB(18, 22, 34),
            BorderSizePixel = 0,
            Text = name,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(195, 205, 235),
            AutoButtonColor = false,
            TextScaled = false,
        })
        Sirius.new("UICorner", {Parent = button, CornerRadius = UDim.new(0, 14)})
        Sirius.new("UIStroke", {Parent = button, Color = Color3.fromRGB(82, 122, 215), Thickness = 1, Transparency = 0.8})

        local category = {
            Name = name,
            Button = button,
            Scripts = {},
        }

        function button:Activate()
            for _, tab in ipairs(window.Categories) do
                tab.Button.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
                tab.Button.TextColor3 = Color3.fromRGB(195, 205, 235)
            end
            button.BackgroundColor3 = Color3.fromRGB(70, 120, 245)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            window.ActiveCategory = category
            window:RefreshScripts()
        end

        button.MouseButton1Click:Connect(function()
            button:Activate()
        end)

        table.insert(window.Categories, category)
        return category
    end
    
    function window:UpdateCategoryLayout()
        task.wait(0.1)
        local buttonHeight = 46
        local padding = 12
        local topBottomPadding = 28
        local totalHeight = (#self.Categories * (buttonHeight + padding)) + topBottomPadding
        categoryPanel.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end

    function window:CreateScriptCard(script)
        local card = Sirius.new("Frame", {
            Parent = self.ScriptContainer,
            Size = UDim2.new(1, 0, 0, 124),
            BackgroundColor3 = Color3.fromRGB(17, 20, 32),
            BorderSizePixel = 0,
        })
        Sirius.new("UICorner", {Parent = card, CornerRadius = UDim.new(0, 16)})
        Sirius.new("UIStroke", {Parent = card, Color = Color3.fromRGB(82, 118, 226), Thickness = 1, Transparency = 0.8})

        Sirius.new("TextLabel", {
            Parent = card,
            Position = UDim2.new(0, 16, 0, 14),
            Size = UDim2.new(1, -32, 0, 24),
            BackgroundTransparency = 1,
            Text = script.Name,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = Color3.fromRGB(242, 248, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        Sirius.new("TextLabel", {
            Parent = card,
            Position = UDim2.new(0, 16, 0, 38),
            Size = UDim2.new(1, -170, 0, 58),
            BackgroundTransparency = 1,
            Text = script.Description,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(176, 188, 215),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
        })

        local runButton = Sirius.new("TextButton", {
            Parent = card,
            Size = UDim2.new(0, 122, 0, 38),
            Position = UDim2.new(1, -138, 1, -52),
            BackgroundColor3 = script.Accent or Color3.fromRGB(85, 130, 255),
            BorderSizePixel = 0,
            Text = script.ButtonText,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(18, 20, 28),
            AutoButtonColor = false,
        })
        Sirius.new("UICorner", {Parent = runButton, CornerRadius = UDim.new(0, 12)})

        runButton.MouseButton1Click:Connect(function()
            local ok, err = pcall(script.Callback)
            if not ok then
                Sirius.notify("Error: " .. tostring(err), 3)
            end
        end)

        return card
    end

    function window:RefreshScripts()
        if not self.ActiveCategory then
            return
        end

        for _, child in ipairs(self.ScriptContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local query = string.lower(self.SearchBox.Text or "")
        local found = 0

        for _, script in ipairs(self.ActiveCategory.Scripts) do
            local nameLower = string.lower(script.Name or "")
            local categoryLower = string.lower(script.Category or "")
            local descLower = string.lower(script.Description or "")
            if query == "" or string.find(nameLower, query, 1, true) or string.find(categoryLower, query, 1, true) or string.find(descLower, query, 1, true) then
                self:CreateScriptCard(script)
                found = found + 1
            end
        end

        if found == 0 then
            Sirius.new("TextLabel", {
                Parent = self.ScriptContainer,
                Size = UDim2.new(1, 0, 0, 100),
                BackgroundTransparency = 1,
                Text = "No scripts match this search.",
                Font = Enum.Font.GothamMedium,
                TextSize = 15,
                TextColor3 = Color3.fromRGB(170, 180, 200),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
            })
        end

        self.ScriptContainer.CanvasSize = UDim2.new(0, 0, 0, self.ScriptLayout.AbsoluteContentSize.Y + 18)
    end

    self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        window:RefreshScripts()
    end)

    return window
end

local function loadSource(code)
    local loader = loadstring or load
    return loader(code)
end

local function makeScriptAction(entry)
    return function()
        local fn = loadSource(entry.Code)
        if fn then
            local ok, err = pcall(fn)
            if not ok then
                Sirius.notify("Execution failed: " .. tostring(err), 3)
            else
                Sirius.notify("Executed: " .. entry.Name, 2.5)
            end
        else
            Sirius.notify("Invalid script code.", 3)
        end
    end
end

local Window = Sirius.createWindow("🔮 ROBLOX SCRIPT HUB")
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

local categoryCache = {}
for _, entry in ipairs(ScriptLibrary) do
    if not categoryCache[entry.Category] then
        categoryCache[entry.Category] = Window:AddCategory(entry.Category)
    end
    table.insert(categoryCache[entry.Category].Scripts, {
        Name = entry.Name,
        Category = entry.Category,
        Description = entry.Description,
        ButtonText = entry.ButtonText,
        Accent = entry.Accent,
        Callback = makeScriptAction(entry),
    })
end

task.spawn(function()
    Window:UpdateCategoryLayout()
end)

if #Window.Categories > 0 then
    Window.Categories[1].Button:Activate()
end
