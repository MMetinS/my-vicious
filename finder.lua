--====================================================================
-- VICIOUS FINDER PRO (MOBILE - ALL-IN-ONE)
--====================================================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

-- Kütüphaneleri Safe-Mode ile Yükle
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))()
local fastHop = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))() end

-- UI Kurulumu (Telefon Uyumlu)
local Window = library:CreateWindow("Vicious Finder", Vector2.new(340, 260))
local Tab = Window:CreateTab("Gözcü Paneli")
local Status = Tab:CreateLabel("Durum: Başlatılıyor...")
local FoundCount = Tab:CreateLabel("Toplam Bulunan: 0")
_G.TotalFound = _G.TotalFound or 0

-- Tarama ve Hop Mantığı
local function scan()
    Status.Text = "Durum: Rogue Taranıyor..."
    task.wait(2.5) -- Haritanın yüklenmesi için
    
    local target = nil
    for _, v in ipairs(workspace:GetChildren()) do
        -- Gerçek vahşi Rogue Vicious'un sahibi olmaz ve ismi tam budur
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            target = v
            break
        end
    end

    if target then
        _G.TotalFound = _G.TotalFound + 1
        FoundCount.Text = "Toplam Bulunan: " .. _G.TotalFound
        Status.Text = "Durum: BULDUM! Webhook gönderildi."
        
        pcall(function()
            game:GetService("HttpService"):PostAsync(WEBHOOK_URL, game:GetService("HttpService"):JSONEncode({
                jobId = game.JobId,
                found = true,
                server = #game.Players:GetPlayers() .. " oyuncu"
            }))
        end)
        task.wait(25) -- Farmer'ın girmesi için bekleme süresi
    else
        Status.Text = "Durum: Yok, yeni sunucu aranıyor..."
        task.wait(1)
        fastHop() -- Senin verdiğin linkteki hızlı zıplama motoru
    end
end

task.spawn(scan)
