--====================================================================
-- VICIOUS HUNTER PRO - MOBILE OPTIMIZED
--====================================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer

-- Webhook Linkin
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

-- DOSYALARI ÇEK (Hata Korumalı)
local success_ui, UI = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))() end)
local success_hop = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))() end)

-- STATS
_G.ViciousFound = _G.ViciousFound or 0
_G.ServersChecked = _G.ServersChecked or 0

-- ARAYÜZ KURULUMU
if success_ui and type(UI) == "table" then
    local Window = UI:CreateWindow("Vicious Finder Pro", Vector2.new(350, 250))
    local Main = Window:CreateTab("Gözcü")
    
    local StatusLabel = Main:CreateLabel("Durum: Başlatılıyor...")
    local FoundLabel = Main:CreateLabel("Bulunan: " .. _G.ViciousFound)
    local ServerLabel = Main:CreateLabel("Sunucu: " .. _G.ServersChecked)

    -- TARAMA MANTIĞI (vichop.lua'dan alınan yöntemle)
    local function findRogue()
        StatusLabel.Text = "Durum: Rogue Vicious Aranıyor..."
        task.wait(2)
        
        local target = nil
        -- Rogue Vicious tespiti için en kesin döngü
        for _, v in ipairs(workspace:GetChildren()) do
            if v.Name == "Rogue Vicious Bee" and v:IsA("Model") then
                -- Kendi arımız olup olmadığını kontrol et (Owner yoksa vahşidir)
                if not v:FindFirstChild("Owner") then
                    target = v
                    break
                end
            end
        end

        if target then
            _G.ViciousFound = _G.ViciousFound + 1
            FoundLabel.Text = "Bulunan: " .. _G.ViciousFound
            StatusLabel.Text = "Durum: BULDUM! Webhook gönderiliyor..."
            
            pcall(function()
                HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                    jobId = game.JobId,
                    found = true,
                    time = os.date("%X")
                }))
            end)
            task.wait(20) -- Farmer için bekleme süresi
        end
        
        -- Bulunsa da bulunmasa da hop yap (Döngü için)
        _G.ServersChecked = _G.ServersChecked + 1
        ServerLabel.Text = "Sunucu: " .. _G.ServersChecked
        StatusLabel.Text = "Durum: Yeni Sunucuya Zıplanıyor..."
        
        -- Yeni paylaştığın hızlı hop'u tetikle
        if success_hop then
            -- vichop içindeki hop fonksiyonunu çağırır
            pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))() end)
        else
            -- Yedek hop sistemi
            TeleportService:Teleport(game.PlaceId)
        end
    end

    task.spawn(findRogue)
else
    -- UI Yüklenmezse konsola hata bas ve basitçe çalış
    warn("UI Library yuklenemedi, arka planda calisiyor...")
end
