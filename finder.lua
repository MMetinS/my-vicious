--====================================================================
-- KODU ÇÖZÜLMÜŞ VICIOUS FINDER (1TOOP LOGIC)
--====================================================================
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))()

-- AYARLAR
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- UI KURULUMU
local Window = UI:CreateWindow("Vicious Finder PRO", Vector2.new(350, 260))
local Tab = Window:CreateTab("Gözcü Modu")
local Status = Tab:CreateLabel("Sistem: Başlatılıyor...")
local Servers = Tab:CreateLabel("Gezilen Sunucu: 0")
_G.SCount = _G.SCount or 0

-- SUNUCU DEĞİŞTİRİCİ (Vichop'un kullandığı en hızlı yöntem)
local function fastHop()
    Status.Text = "Sistem: Boş sunucu aranıyor..."
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    
    if success then
        for _, s in ipairs(result) do
            if s.id ~= game.JobId and s.playing < (s.maxPlayers - 1) then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId)
end

-- VICHOP'UN İÇİNDEKİ VICIOUS BULMA MANTIĞI (DEŞİFRE EDİLDİ)
local function findVicious()
    Status.Text = "Sistem: Harita analiz ediliyor..."
    task.wait(2.5) -- Modellerin tam yüklenmesi için 1toop'un kullandığı süre

    local target = nil
    
    -- 1. ADIM: Workspace taraması (Vichop'un filtreleri)
    for _, v in pairs(workspace:GetChildren()) do
        -- İsim tam eşleşmeli
        if v.Name == "Rogue Vicious Bee" and v:IsA("Model") then
            -- 2. ADIM: Owner kontrolü (Eğer sahibi yoksa gerçek vahşi arıdır)
            if not v:FindFirstChild("Owner") then
                target = v
                break
            end
        end
    end

    -- 3. ADIM: Eğer arı henüz çıkmadıysa ama "Diken" (Stinger) varsa (Vichop bunu da kontrol eder)
    if not target then
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "ViciousStinger" or v.Name == "ViciousThorn" then
                target = v -- Diken varsa arı yoldadır
                break
            end
        end
    end

    if target then
        Status.Text = "BULDUM! Karakter sabitlendi."
        
        -- FINDER OLDUĞU İÇİN KESMEYE GİTMESİN DİYE DONDURUYORUZ
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = true end

        -- Webhook Gönder
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                content = "📢 **Vicious Bee Bulundu!**",
                embeds = {{
                    title = "Sunucu Detayları",
                    description = "Oyuncu Sayısı: " .. #game.Players:GetPlayers() .. "\nJobId: " .. game.JobId,
                    color = 16711680 -- Kırmızı
                }}
            }))
        end)
        
        task.wait(60) -- Farmer'ın girmesi için güvenli zaman
    else
        _G.SCount = _G.SCount + 1
        Servers.Text = "Gezilen Sunucu: " .. _G.SCount
        Status.Text = "Bulunamadı, zıplanıyor..."
        task.wait(0.5)
        fastHop()
    end
end

-- BAŞLAT
task.spawn(findVicious)
