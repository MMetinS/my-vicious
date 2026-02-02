--====================================================================
-- VICIOUS HUNTER PRO HUB (GELİŞMİŞ GÖZCÜ)
--====================================================================

-- Senin paylaştığın UI kütüphanesini ve Hop sistemini yüklüyoruz
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))()
local fastHop = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/hop.lua"))()

local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local HttpService = game:GetService("HttpService")

-- İstatistikler
_G.FoundCount = _G.FoundCount or 0
_G.ServerCount = _G.ServerCount or 0

-- PENCERE OLUŞTURMA (test4.lua içindeki fonksiyonlar)
local Window = library:CreateWindow("Vicious Hunter Pro", Vector2.new(420, 320))
local MainTab = Window:CreateTab("Ana Menü")
local InfoTab = Window:CreateTab("İstatistikler")

-- ANA MENÜ ELEMANLARI
MainTab:CreateLabel("Gözcü Modu Aktif")
local StatusLabel = MainTab:CreateLabel("Durum: Taranıyor...")

MainTab:CreateButton("Sunucu Değiştir (Manuel)", function()
    fastHop()
end)

-- İSTATİSTİK ELEMANLARI
local FoundLabel = InfoTab:CreateLabel("Bulunan Arı: " .. _G.FoundCount)
local ServerLabel = InfoTab:CreateLabel("Gezilen Sunucu: " .. _G.ServerCount)

-- TARAMA FONKSİYONU
local function checkVicious()
    StatusLabel.Text = "Durum: Workspace Taranıyor..."
    task.wait(2)
    
    local target = nil
    -- Rogue Vicious Bee modelini ara
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" then
            target = v
            break
        end
    end

    if target then
        _G.FoundCount = _G.FoundCount + 1
        FoundLabel.Text = "Bulunan Arı: " .. _G.FoundCount
        StatusLabel.Text = "Durum: BULDUM! Webhook Gidiyor..."
        
        -- Webhook Gönder
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                jobId = game.JobId,
                found = true,
                msg = "Rogue Vicious Bee Bulundu!"
            }))
        end)
        
        task.wait(15) -- Farmer'ın girmesini bekle
    else
        StatusLabel.Text = "Durum: Bulunamadı, Işınlanılıyor..."
        _G.ServerCount = _G.ServerCount + 1
        ServerLabel.Text = "Gezilen Sunucu: " .. _G.ServerCount
        task.wait(1)
        fastHop() -- hop.lua içindeki profesyonel ışınlanmayı kullanır
    end
end

-- DÖNGÜYÜ BAŞLAT
task.spawn(function()
    checkVicious()
end)
