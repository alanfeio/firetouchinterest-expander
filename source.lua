local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local hitboxSize = Vector3.new(5, 5, 5) -- initial shit
local hitboxVisible = false 

-- hitbox
local hitbox = Instance.new("Part")
hitbox.Size = hitboxSize
hitbox.Transparency = 1
hitbox.Anchored = true
hitbox.CanCollide = false
hitbox.Parent = character

-- gui shit
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0.4, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Draggable = true
frame.Active = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Text = "Hitbox Control"
title.Parent = frame

local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Text = text
    button.Parent = frame
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
end

createButton("Toggle Hitbox", UDim2.new(0.05, 0, 0.2, 0), function()
    hitboxVisible = not hitboxVisible
    hitbox.Transparency = hitboxVisible and 0.5 or 1
end)

createButton("Aumentar", UDim2.new(0.05, 0, 0.35, 0), function()
    if hitboxVisible then
        hitboxSize = hitboxSize + Vector3.new(1, 1, 1)
        hitbox.Size = hitboxSize
    end
end)

createButton("Diminuir", UDim2.new(0.05, 0, 0.5, 0), function()
    if hitboxVisible then
        hitboxSize = hitboxSize - Vector3.new(1, 1, 1)
        hitbox.Size = hitboxSize
    end
end)

createButton("Resetar", UDim2.new(0.05, 0, 0.65, 0), function()
    hitboxSize = Vector3.new(5, 5, 5)
    hitbox.Size = hitboxSize
end)

local lastUpdate = 0
RunService.Heartbeat:Connect(function()
    if hitboxVisible then
        hitbox.Position = humanoidRootPart.Position
        
        local currentTime = tick()
        if currentTime - lastUpdate > 0.1 then
            lastUpdate = currentTime
            
            local parts = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size)
            for _, part in ipairs(parts) do
                if part:IsA("Part") then
                    local touchInterest = part:FindFirstChildOfClass("TouchTransmitter")
                    if touchInterest then
                        firetouchinterest(humanoidRootPart, part, 0)
                        firetouchinterest(humanoidRootPart, part, 1)
                    end
                end
            end
        end
    end
end)
