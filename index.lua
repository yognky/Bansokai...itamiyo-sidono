-- LocalScript di StarterPlayerScripts
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- ===========================
-- GUI Menu
-- ===========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VisualMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100) -- center
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true -- start visible supaya pasti keliatan
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Text = "Visual Fun Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Tombol
local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0, 250, 0, 40)
killBtn.Position = UDim2.new(0, 25, 0, 50)
killBtn.Text = "Visual Kill All"
killBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
killBtn.TextColor3 = Color3.fromRGB(255,255,255)
killBtn.Parent = mainFrame

local liftBtn = Instance.new("TextButton")
liftBtn.Size = UDim2.new(0, 250, 0, 40)
liftBtn.Position = UDim2.new(0, 25, 0, 95)
liftBtn.Text = "Visual Lift All"
liftBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
liftBtn.TextColor3 = Color3.fromRGB(255,255,255)
liftBtn.Parent = mainFrame

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 250, 0, 40)
flyBtn.Position = UDim2.new(0, 25, 0, 140)
flyBtn.Text = "Toggle Fly Visual"
flyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.Parent = mainFrame

-- ===========================
-- Fungsi Visual
-- ===========================
local flyEnabled = false
local flySpeed = 50

local function visualKillAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            -- client-side effect: ganti warna transparan supaya terlihat mati
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.7
                end
            end
        end
    end
end

local function visualLiftAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame + Vector3.new(0,10,0)
        end
    end
end

local function toggleFly()
    flyEnabled = not flyEnabled
end

-- ===========================
-- Fly Loop
-- ===========================
RunService.RenderStepped:Connect(function(delta)
    if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local direction = Vector3.new(0,0,0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + hrp.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - hrp.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - hrp.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + hrp.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0,1,0) end

        if direction.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + direction.Unit * flySpeed * delta
        end
    end
end)

-- ===========================
-- Chat trigger "shinra tensei"
-- ===========================
LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower():match("shinra tensei") then
        if Workspace:FindFirstChild("Terrain") then
            Workspace.Terrain:Clear() -- client-side
        end
    end
end)

-- ===========================
-- Tombol connect
-- ===========================
killBtn.MouseButton1Click:Connect(visualKillAll)
liftBtn.MouseButton1Click:Connect(visualLiftAll)
flyBtn.MouseButton1Click:Connect(toggleFly)

-- ===========================
-- Toggle menu M
-- ===========================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
