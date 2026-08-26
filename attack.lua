local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local ATTACK_RANGE = 20
local ATTACK_DELAY = 0.05

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

local function equipWeapon()
    if not Character then return nil end
    local currentTool = Character:FindFirstChildOfClass("Tool")
    if currentTool then return currentTool end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        local tool = backpack:FindFirstChildOfClass("Tool")
        if tool then
            tool.Parent = Character
            return tool
        end
    end
    return nil
end
local function doAttack()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(0.01)
    VirtualUser:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end
task.spawn(function()
    while true do
        task.wait(ATTACK_DELAY)
        local tool = equipWeapon()
        if tool and Character and Character:FindFirstChild("HumanoidRootPart") then
            local hrp = Character.HumanoidRootPart
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj ~= Character then
                    local targetHrp = obj.HumanoidRootPart
                    local distance = (hrp.Position - targetHrp.Position).Magnitude
                    
                    if distance <= ATTACK_RANGE and obj.Humanoid.Health > 0 then
                        doAttack()
                        break
                    end
                end
            end
        end
    end
end)
