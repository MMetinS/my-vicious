--==============================================
-- FINDER (GÖZCÜ) - TURBO PANEL VERSION
--==============================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- STATS (İstatistikler)
_G.FoundCount = _G.FoundCount or 0
_G.StartTime = _G.StartTime or os.time()
_G.StingerCount = _G.StingerCount or 0

-- ARAYÜZ OLUŞTURMA (GUI)
local function createUI()
    local screenGui = Instance.new("ScreenGui", lp.PlayerGui)
    screenGui.Name = "FinderPanel"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 220, 0, 130)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 2
    frame.Active = true
    frame.Draggable = true -- Paneli ekranda taşıyabilirsin

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Text = "VICIOUS FINDER STATUS"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 14

    local function createLabel(yPos, text)
        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1, -10, 0, 25)
        lbl.Position = UDim2.new(0, 5, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.SourceSans
        lbl.TextSize = 16
        return lbl
    end

    local timerLbl = createLabel(35, "Çalışma Süresi: 0s")
    local foundLbl = createLabel(60, "Bulunan Vicious: " .. _G.FoundCount)
    local stingerLbl = createLabel(85, "Toplanan Stinger: " .. _G.StingerCount)

    -- Süre ve Stat Güncelleme Döngüsü
    task.spawn(function()
        while task.wait(1) do
            local diff = os.time() - _G.StartTime
            local min = math.floor(diff / 60)
            local sec = diff % 60
            timerLbl.Text = string.format("Çalışma Süresi: %dm %ds", min, sec)
            foundLbl.Text = "Bulunan Vicious: " .. _G.FoundCount
            stingerLbl.Text = "Toplanan Stinger: " .. _G.StingerCount
        end
    end)
end

-- SERVER HOP FONKSİYONU
local function serverHop()
    print("Farklı sunucu aranıyor...")
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    if success and servers then
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId)
end

-- TARAMA
local function scan()
    createUI() -- Paneli aç
    task.wait(1)

    local isFound = false
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name:lower():find("vicious") then
            isFound = true
            _G.FoundCount = _G.FoundCount + 1
            
            -- Webhook gönder
            pcall(function()
                HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                    jobId = game.JobId,
                    viciousFound = true
                }))
            end)
            
            -- Stinger Takibi (Vicious kesilirse stinger artar)
            v.AncestryChanged:Connect(function(_, parent)
                if parent == nil then _G.StingerCount = _G.StingerCount + 1 end
            end)

            print("Vicious burada! 15 saniye bekleniyor...")
            task.wait(15) -- Farmer gelmesi için süre
            break
        end
    end

    if not isFound then
        serverHop()
    end
end

scan()
