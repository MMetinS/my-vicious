--====================================================================
-- VICIOUS FINDER PRO (HOP-BASED)
--====================================================================

local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Ekranın ortasında çalışıp çalışmadığını anlaman için küçük bir yazı
local sg = Instance.new("ScreenGui", lp.PlayerGui)
local txt = Instance.new("TextLabel", sg)
txt.Size = UDim2.new(0, 200, 0, 50)
txt.Position = UDim2.new(0.5, -100, 0.1, 0)
txt.Text = "Vicious Gözcü Aktif..."
txt.BackgroundColor3 = Color3.new(0, 0, 0)
txt.TextColor3 = Color3.new(0, 1, 0)

-- TARAMA FONKSİYONU
local function scan()
    print("Vicious araniyor...")
    task.wait(2)
    
    local found = false
    -- Senin hop.lua içindeki mantığa göre en temiz arama
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            found = true
            txt.Text = "BULDUM! Webhook Gidiyor..."
            
            pcall(function()
                HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                    jobId = game.JobId,
                    found = true,
                    info = "Rogue Vicious Bee Bulundu!"
                }))
            end)
            task.wait(15) -- Farmer'ın girmesi için bekle
            break
        end
    end

    if not found then
        txt.Text = "Bulunamadı, Yeni Sunucuya..."
        task.wait(1)
        -- Senin verdiğin profesyonel hop kodunu çalıştırır
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))()
    end
end

-- Başlat
scan()
