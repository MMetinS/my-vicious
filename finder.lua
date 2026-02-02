--====================================================================
-- FINDER (GÖZCÜ) - PRO MOBILE VERSION
--====================================================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

-- Kütüphaneleri Yükle
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))()
local fastHop = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))() end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- UI Oluştur
local Window = library:CreateWindow("Vicious Finder", Vector2.new(340, 260))
local Tab = Window:CreateTab("Gözcü Paneli")

local Status = Tab:CreateLabel("Durum: Taranıyor...")
local FoundLabel = Tab:CreateLabel("Bulunan Rogue: 0")
_G.TotalFound = _G.TotalFound or 0

-- Tarama Fonksiyonu
local function checkRogue()
    local target = nil
    for _, v in ipairs(workspace:GetChildren()) do
        -- Sadece Rogue olan ve sahibi olmayan (vahşi) arıyı bul
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            target = v
            break
        end
    end

    if target then
        _G.TotalFound = _G.TotalFound + 1
        FoundLabel.Text = "Bulunan Rogue: " .. _G.TotalFound
        Status.Text = "Durum: BULDUM! Farmer bekleniyor..."
        
        -- Webhook Gönder
        pcall(function()
            game:GetService("HttpService"):PostAsync(WEBHOOK_URL, game:GetService("HttpService"):JSONEncode({
                jobId = game.JobId,
                found = true,
                server = #Players:GetPlayers() .. " oyuncu var"
            }))
        end)
        
        task.wait(25) -- Farmer'ın girmesi için güvenli süre
    else
        Status.Text = "Durum: Yok, yeni sunucuya..."
        task.wait(1)
        fastHop() -- Senin verdiğin hızlı hop
    end
end

task.spawn(function()
    task.wait(2) -- Oyunun yüklenmesi için
    checkRogue()
end)
