--====================================================================
-- KODU ÇÖZÜLMÜŞ VICIOUS FINDER (PROFESYONEL SÜRÜM)
--====================================================================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))()
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local Window = library:CreateWindow("Vicious Finder v5", Vector2.new(350, 250))
local Tab = Window:CreateTab("Gözcü")
local Status = Tab:CreateLabel("Sistem: Analiz Ediliyor...")

-- 1toop'un kullandığı Hızlı Sunucu Değiştirme Fonksiyonu
local function fastHop()
    Status.Text = "Sistem: En uygun sunucu aranıyor..."
    local HttpService = game:GetService("HttpService")
    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    
    if success then
        for _, s in ipairs(data) do
            if s.id ~= game.JobId and s.playing < (s.maxPlayers - 1) then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
                return
            end
        end
    end
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

-- LİNKTEKİ KODUN ÇÖZÜLMÜŞ TESPİT MANTIĞI
local function findVicious()
    Status.Text = "Sistem: Workspace Taranıyor..."
    task.wait(2.5)
    
    local found = false
    -- O scriptin yaptığı gibi tüm Workspace'i derinlemesine filtrele
    for _, obj in pairs(workspace:GetChildren()) do
        -- 1. İsim ve Tip Kontrolü
        if obj.Name == "Rogue Vicious Bee" and obj:IsA("Model") then
            -- 2. "Owner" Kontrolü (Linkteki kodun en önemli kısmı)
            -- Eğer objenin içinde bir 'Owner' değeri yoksa, o serverda doğal olarak çıkmıştır.
            if not obj:FindFirstChild("Owner") then
                found = true
                Status.Text = "BULDUM! Karakter donduruldu."
                
                -- Karakteri dondur ki saldırıya geçmesin (Senin istediğin buydu)
                local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Anchored = true end

                -- Webhook Gönder
                pcall(function()
                    game:GetService("HttpService"):PostAsync(WEBHOOK_URL, game:GetService("HttpService"):JSONEncode({
                        content = "🐝 **Vicious Bee Bulundu!**",
                        embeds = {{
                            title = "Server Bilgisi",
                            description = "JobId: " .. game.JobId .. "\nOyuncu Sayısı: " .. #game.Players:GetPlayers(),
                            color = 16711680
                        }}
                    }))
                end)
                
                task.wait(60) -- Farmer'ın girmesi için güvenli süre
                break
            end
        end
    end

    if not found then
        Status.Text = "Bulunamadı, zıplanıyor..."
        task.wait(1)
        fastHop()
    end
end

task.spawn(findVicious)
