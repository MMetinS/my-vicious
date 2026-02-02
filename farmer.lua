--==============================
-- FARMER (GİDİCİ) - FULL VERSION
--==============================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local FLY_SPEED = 45

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local lastJobId = ""

-- OTOMATİK UÇMA (TWEEN)
local function autoFly(target)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local part = target:IsA("BasePart") and target or target:FindFirstChildWhichIsA("BasePart", true)
    
    if part then
        local dist = (hrp.Position - part.Position).Magnitude
        local tween = TweenService:Create(hrp, TweenInfo.new(dist/FLY_SPEED, Enum.EasingStyle.Linear), {
            CFrame = part.CFrame * CFrame.new(0, 15, 0)
        })
        tween:Play()
    end
end

-- WEBHOOK DİNLEME DÖNGÜSÜ
print("Farmer dinleme modunda...")

while task.wait(5) do
    -- Sunucudaki Vicious Bee kontrolü
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("vicious") then
            autoFly(v)
            break
        end
    end

    -- Yeni veri kontrolü
    local success, response = pcall(function()
        return game:HttpGet(WEBHOOK_URL)
    end)

    if success and response ~= "" then
        local data = HttpService:JSONDecode(response)
        -- Eğer gelen sunucu şu ankinden farklıysa ışınlan
        if data and data.jobId and data.jobId ~= lastJobId and data.jobId ~= game.JobId then
            print("Gözcüden yeni sinyal alindi! Işinlaniliyor...")
            lastJobId = data.jobId
            TeleportService:TeleportToPlaceInstance(data.placeId, data.jobId)
        end
    end
end
