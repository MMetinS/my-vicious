--==============================================
-- FINDER (GÖZCÜ) - ANTI-FULL SERVER & AUTO-RETRY
--==============================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- STATS
_G.FoundCount = _G.FoundCount or 0
_G.StartTime = _G.StartTime or os.time()

-- ARAYÜZ
local function createUI()
    if lp.PlayerGui:FindFirstChild("FinderPanel") then lp.PlayerGui.FinderPanel:Destroy() end
    local sg = Instance.new("ScreenGui", lp.PlayerGui); sg.Name = "FinderPanel"
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 220, 0, 100); frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); frame.Active = true; frame.Draggable = true
    Instance.new("UICorner", frame)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30); title.Text = "🔍 ROGUE FINDER"; title.TextColor3 = Color3.new(1, 0.2, 0.2)
    title.BackgroundColor3 = Color3.fromRGB(40, 0, 0); title.Font = "GothamBold"; title.TextSize = 14

    local statusLbl = Instance.new("TextLabel", frame)
    statusLbl.Size = UDim2.new(1, -20, 0, 30); statusLbl.Position = UDim2.new(0, 10, 0, 45)
    statusLbl.Text = "Durum: Başlatılıyor..."; statusLbl.TextColor3 = Color3.new(1, 1, 1); statusLbl.BackgroundTransparency = 1; statusLbl.TextSize = 14
    
    return statusLbl
end

local statusLabel = createUI()

-- GELİŞMİŞ SERVER HOP (DOLU SERVER FİLTRESİ)
local function serverHop()
    statusLabel.Text = "Yeni sunucu aranıyor..."
    local success, servers = pcall(function()
        -- Sunucuları oyuncu sayısı en az olandan başlayarak çek (Max 100 sunucu)
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)

    if success and servers then
        for _, s in ipairs(servers) do
            -- Filtreler: 
            -- 1. Şu anki sunucu olmamalı 
            -- 2. Sunucu kapasitesi (maxPlayers - 2) olmalı ki biz ve farmer girebilsin
            if s.id ~= game.JobId and s.playing <= (s.maxPlayers - 2) then
                statusLabel.Text = "Sunucuya gidiliyor: " .. s.playing .. "/" .. s.maxPlayers
                
                local teleportError = false
                local tpConnection
                
                -- Işınlanma hatasını yakala (Sunucu doluysa veya hata verirse)
                tpConnection = TeleportService.TeleportInitFailed:Connect(function(player, result, errorMessage)
                    if player == lp then
                        teleportError = true
                        warn("Işınlanma Hatası: " .. errorMessage)
                        tpConnection:Disconnect()
                    end
                end)

                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                
                task.wait(5) -- Işınlanma süreci için bekle
                if teleportError then
                    statusLabel.Text = "Bağlantı başarısız, tekrar deneniyor..."
                    continue -- Döngüdeki bir sonraki sunucuya geç
                else
                    return -- Başarılıysa fonksiyondan çık
                end
            end
        end
    end
    
    statusLabel.Text = "Uygun sunucu yok, rastgele deneniyor..."
    task.wait(1)
    TeleportService:Teleport(game.PlaceId)
end

-- ANA TARAMA
local function scan()
    statusLabel.Text = "Rogue Vicious taranıyor..."
    task.wait(1.5)
    
    local target = nil
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" then
            target = v
            break
        end
    end

    if target then
        _G.FoundCount = _G.FoundCount + 1
        statusLabel.Text = "BULDUM! Farmer bekleniyor."
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({jobId = game.JobId
