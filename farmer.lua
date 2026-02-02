--====================================================================
-- PURE FARMER (KESİCİ) - TWEEN İLE KESER
--====================================================================
local TweenService = game:GetService("TweenService")

local function GetVic()
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            return v
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(1) do
        local vic = GetVic()
        if vic and vic:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            
            -- Tween Ayarı (Hız: 100)
            local dist = (hrp.Position - vic.HumanoidRootPart.Position).Magnitude
            local tween = TweenService:Create(hrp, TweenInfo.new(dist/100, Enum.EasingStyle.Linear), {
                CFrame = vic.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0) -- 12 stud üstünde durur
            })
            tween:Play()
        end
    end
end)
