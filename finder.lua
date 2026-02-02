--====================================================================
-- VICIOUS HUNTER PRO HUB (FINDER)
--====================================================================

-- UI Library ve Server Hop mantığını entegre ediyoruz
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))() -- Paylaştığın UI Dosyasını buradan çeker
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Stats = {
    Found = 0,
    ServersVisited = 0,
    Status = "Başlatılıyor..."
}

-- PENCERE OLUŞTURMA
local Window = UI:CreateWindow("Vicious Hunter v1.0", Vector2.new(450, 350))
local MainTab = Window:CreateTab("Genel Durum")
local SettingsTab = Window:CreateTab("Ayarlar")

-- DURUM GÖSTERGELERİ
local StatusLabel = MainTab:CreateLabel("Durum: Bekleniyor")
local FoundLabel = MainTab:CreateLabel("Toplam Bulunan: 0")
local ServerLabel = MainTab:CreateLabel("Gezilen Sunucu: 0")

-- GELİŞMİŞ SERVER HOP (hop.lua mantığından esinlenilmiştir)
local function fastHop()
    Stats.Status = "Hızlı Sunucu Aranıyor..."
    StatusLabel.Text = "Durum: " .. Stats.Status
    
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)

    if success then
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing <= (s.maxPlayers - 2) then
                Stats.ServersVisited = Stats.ServersVisited + 1
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                return
            end
        end
    end
    -- Hata durumunda klasik hop
    TeleportService:Teleport(game.PlaceId)
end

-- VICIOUS BULMA MANTIĞI (En Önemli Kısım)
local function scanForVicious()
    Stats.Status = "Rogue Vicious Taranıyor..."
    StatusLabel.Text = "Durum: " .. Stats.Status
    task.wait(1.5)

    local target = nil
    -- Rogue Vicious Bee'nin en doğru tespit yöntemi
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" then
            target = v
            break
        end
    end

    if target then
        Stats.Found = Stats.Found + 1
        FoundLabel.Text = "Toplam Bulunan: " .. Stats.Found
        Stats.Status = "BULDUM! Webhook gönderiliyor..."
        StatusLabel.Text = "Durum: " .. Stats.Status
        
        -- Webhook Gönder
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                jobId = game.JobId,
                found = true,
                serverPop = #game.Players:GetPlayers()
            }))
        end)
        
        task.wait(20) -- Farmer'ın gelmesi için güvenli süre
    else
        Stats.Status = "Bulunamadı, sunucu değişiyor..."
        StatusLabel.Text = "Durum: " .. Stats.Status
        fastHop()
    end
end

-- AYARLAR TABI
SettingsTab:CreateButton("Manuel Server Hop", function()
    fastHop()
end)

SettingsTab:CreateLabel("Webhook: Aktif")

-- BAŞLAT
task.spawn(function()
    while true do
        scanForVicious()
        task.wait(1)
    end
end)
