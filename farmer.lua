--==============================================
-- FARMER (GİDİCİ) - PANEL & AUTO-FLY VERSION
--==============================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local FLY_SPEED = 50

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- STATS
_G.TotalTeleports = _G.TotalTeleports or 0
_G.FarmerStartTime = _G.FarmerStartTime or os.time()
_G.ViciousKilled = _G.ViciousKilled or 0

-- ARAYÜZ (GUI)
local function createFarmerUI()
    if lp.PlayerGui:FindFirstChild("FarmerPanel") then lp.PlayerGui.FarmerPanel:Destroy() end
    
    local sg = Instance.new("ScreenGui", lp.PlayerGui)
    sg.Name = "FarmerPanel"

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 220, 0, 130)
    frame.Position = UDim2.new(0, 10, 0, 150) -- Finder panelinin altına gelmesi için
    frame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "🚜 FARMER STATUS"
    title.TextColor3 = Color3.fromRGB(0, 255, 127)
    title.BackgroundColor3 = Color3.fromRGB(35, 45, 50)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14

    local function createLabel(yPos)
        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1, -20, 0, 25)
        lbl.Position = UDim2.new(0, 10, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        return lbl
    end

    local statusLbl = createLabel(40)
    local tpLbl = createLabel(65)
    local killLbl = createLabel(90)

    task.spawn(function()
        while task.wait(1) do
            statusLbl.Text = "Durum: Veri Bekleniyor..."
            tpLbl.Text = "Yapılan Işınlanma: " .. _G.TotalTeleports
            killLbl.Text = "Kesilen Vicious: " .. _G.ViciousKilled
        end
    end)
end

-- UÇMA FONKSİYONU
local function flyToVicious(target)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    if target and target.Parent then
        local dist = (hrp.Position - target.Position).Magnitude
        local tween = TweenService:Create(hrp, TweenInfo.new(dist/FLY_SPEED, Enum.EasingStyle.Linear), {
            CFrame = target.CFrame * CFrame.new(0, 12, 0)
        })
        tween:Play()
        return tween
    end
end

-- ANA DÖNGÜ
createFarmerUI()

while task.wait(5) do
    -- 1. Mevcut Sunucuda Vicious Var mı?
    local foundInServer = false
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name:lower():find("vicious") and v:IsA("Model") then
            foundInServer = true
            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if root then
                flyToVicious(root)
                -- Vicious ölünce sayacı artır
                v.AncestryChanged:Wait() 
                _G.ViciousKilled = _G.ViciousKilled + 1
            end
            break
        end
    end

    -- 2. Webhook'tan Yeni Sunucu Kontrolü
    if not foundInServer then
        local success, response = pcall(function()
            return game:HttpGet(WEBHOOK_URL)
        end)

        if success and response ~= "" then
            local data = HttpService:JSONDecode(response)
            if data and data.jobId and data.jobId ~= game.JobId then
                _G.TotalTeleports = _G.TotalTeleports + 1
                TeleportService:TeleportToPlaceInstance(game.PlaceId, data.jobId)
            end
        end
    end
end
