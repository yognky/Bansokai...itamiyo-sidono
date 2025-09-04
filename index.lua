-- LocalScript di StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- ===========================
-- Fungsi buat buat menu cheat
-- ===========================
local function createCheatMenu(player)
    local cheatMenuGui = Instance.new("ScreenGui")
    cheatMenuGui.Name = "CheatMenuGui"
    cheatMenuGui.Parent = player:WaitForChild("PlayerGui")

    local cheatMenuFrame = Instance.new("Frame")
    cheatMenuFrame.Name = "CheatMenuFrame"
    cheatMenuFrame.Size = UDim2.new(0, 220, 0, 250)
    cheatMenuFrame.Position = UDim2.new(0.5, -110, 0.5, -125)
    cheatMenuFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    cheatMenuFrame.BackgroundTransparency = 0.5
    cheatMenuFrame.BorderSizePixel = 0
    cheatMenuFrame.Active = true
    cheatMenuFrame.Draggable = true -- bisa geser
    cheatMenuFrame.Parent = cheatMenuGui

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(20,20,20)
    title.Text = "Visual Fun Menu"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextScaled = true
    title.Parent = cheatMenuFrame

    -- Tombol X close
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    closeBtn.Parent = cheatMenuFrame
    closeBtn.MouseButton1Click:Connect(function()
        cheatMenuFrame.Visible = false
    end)

    -- ===========================
    -- Tombol cheat
    -- ===========================
    local function createButton(text, posY, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 200, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Text = text
        btn.Parent = cheatMenuFrame
        btn.MouseButton1Click:Connect(callback)
    end

    -- Contoh tombol cheat
    createButton("Visual Kill All", 50, function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.7
                    end
                end
            end
        end
    end)

    createButton("Visual Lift All", 100, function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.CFrame = hrp.CFrame + Vector3.new(0,10,0)
            end
        end
    end)

    local flyEnabled = false
    local flySpeed = 50
    createButton("Toggle Fly Visual", 150, function()
        flyEnabled = not flyEnabled
    end)

    -- Fly logic
    RunService.RenderStepped:Connect(function(delta)
        if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + hrp.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - hrp.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - hrp.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + hrp.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + dir.Unit * flySpeed * delta
            end
        end
    end)

    -- Chat trigger
    LocalPlayer.Chatted:Connect(function(msg)
        if msg:lower():match("shinra tensei") then
            if Workspace:FindFirstChild("Terrain") then
                Workspace.Terrain:Clear()
            end
        end
    end)

    return cheatMenuGui
end

-- ===========================
-- Create menu untuk player lokal
-- ===========================
local menu = createCheatMenu(Players.LocalPlayer)

-- Toggle menu dengan M
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        menu.CheatMenuFrame.Visible = not menu.CheatMenuFrame.Visible
    end
end)
