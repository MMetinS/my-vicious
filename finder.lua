--====================================================================
-- VICIOUS HUNTER MOBİL PRO (GÖZCÜ)
--====================================================================

-- Mobil cihazlarda hata almamak için korumalı yükleme yapıyoruz
local success_ui, library = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))() 
end)

local success_hop, fastHop = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/hop.lua"))() 
end)

local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local HttpService = game:GetService("HttpService")

-- İstatistikler
_G.FoundCount = _G.FoundCount or 0
_G.ServerCount = _G.ServerCount or 0

-- EĞER UI YÜKLENEMEZSE BASİT PANEL OLUŞTUR (MOBİL GÜVENLİK)
if not success_ui or type(library) ~= "table" then
    print("Mobil UI hatasi, guvenli moda geciliyor.")
    -- Buraya basit bir mobil GUI eklenebilir ama önce ana yapıyı kuruyoruz
else
    -- PROFESYONEL UI (test4.lua kullanarak)
    local Window = library:CreateWindow("Vicious Mobil v1.0", Vector2.new(320, 240)) -- Telefon ekranı için daha küçük
    local MainTab = Window:CreateTab("Gözcü")
    
    local StatusLabel = MainTab:CreateLabel("Durum: Başlıyor...")
    local FoundLabel = MainTab:CreateLabel("Bulunan: " .. _G.FoundCount)
    local ServerLabel = MainTab:CreateLabel("Sunucu: " .. _G.ServerCount)
    
    MainTab:CreateButton("Sunucu Değiştir", function()
        if success_hop then fastHop() else game:GetService("TeleportService"):Teleport(game.PlaceId) end
    end)

    -- TARAMA DÖNGÜSÜ
    task.spawn(function()
        while task.wait(3) do
            StatusLabel.Text = "Durum: Arı Aranıyor..."
            
            local target = workspace:FindFirstChild("Rogue Vicious Bee")
            if target then
                _G.FoundCount = _G.FoundCount + 1
                FoundLabel.Text = "Bulunan: " .. _G.FoundCount
                StatusLabel.Text = "Durum: BULDUM!"
                
                pcall(function()
                    HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                        jobId = game.JobId,
                        found = true
                    }))
                end)
                task.wait(15) -- Farmer için bekleme
            else
                _G.ServerCount = _G.ServerCount + 1
                ServerLabel.Text = "Sunucu: " .. _G.ServerCount
                StatusLabel.Text = "Durum: Yeni Sunucuya..."
                
                if success_hop then fastHop() else game:GetService("TeleportService"):Teleport(game.PlaceId) end
                break
            end
        end
    end)
end
