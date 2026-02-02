--====================================================================
-- VICHOP MANTIĞI İLE GÜÇLENDİRİLMİŞ GÖZCÜ (FINDER)
--====================================================================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))()
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

-- UI KURULUMU
local Window = library:CreateWindow("Vicious Finder V3", Vector2.new(350, 250))
local Tab = Window:CreateTab("Gözcü Modu")
local Status = Tab:CreateLabel("Sistem: Başlatılıyor...")
local FoundCount = Tab:CreateLabel("Bulunan Arı: 0")
_G.FoundTotal = _G.FoundTotal or 0

-- SUNUCU DEĞİŞTİRME (Senin verdiğin linkteki gibi en boşları hedefler)
local function fastServerHop()
    Status.Text = "Sistem: Hızlı sunucu aranıyor..."
    local HttpService = game:GetService("HttpService")
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)

    if success then
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing <= (s.maxPlayers - 2) then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
                return
            end
        end
    end
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

-- LİNKTEKİ TESPİT MANTIĞINI BURADA UYGULUYORUZ
local function checkVicious()
    Status.Text = "Sistem: Harita taranıyor (vichop mantığı)..."
    task.wait(2.5) -- Haritanın ve modellerin yüklenmesi için kritik süre

    local targetBee = nil
    
    -- Linkteki kodun yaptığı gibi Workspace'i tarıyoruz
    for _, obj in ipairs(workspace:GetChildren()) do
        -- 1. İsim kontrolü
        if obj.Name == "Rogue Vicious Bee" then
            -- 2. "Owner" değeri yoksa bu vahşi/doğal bir arıdır (En sağlam tespit)
            if not obj:FindFirstChild("Owner") and obj:IsA("Model") then
                targetBee = obj
                break
            end
        end
    end

    if targetBee then
        _G.FoundTotal = _G.FoundTotal + 1
        FoundCount.Text = "Bulunan Arı: " .. _G.FoundTotal
        Status.Text = "Durum: BULDUM! Kesilmiyor, bekleniyor..."

        -- ÖNEMLİ: Kesmeye gitmemesi için karakteri olduğu yere çiviliyoruz (Anchored)
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then 
            hrp.Anchored = true 
        end

        -- Webhook Gönder (Farmer'a haber ver)
        pcall(function()
            game:GetService("HttpService"):PostAsync(WEBHOOK_URL, game:GetService("HttpService"):JSONEncode({
                jobId = game.JobId,
                found = true,
                server = #game.Players:GetPlayers() .. " oyuncu"
            }))
        end)

        task.wait(60) -- Farmer gelesiye kadar sunucuda kal
    else
        Status.Text = "Sistem: Rogue yok, zıplanıyor..."
        task.wait(0.5)
        fastServerHop()
    end
end

-- Çalıştır
task.spawn(checkVicious)
