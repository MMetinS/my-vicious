--====================================================================
-- ÖZEL YAPIM: VICIOUS FINDER (1TOOP MANTIĞI ÇÖZÜLDÜ)
--====================================================================

-- 1. Arayüz Tasarımı (Görseldeki stile yakın ama bize özgü)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 160)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 10, 50) -- Koyu Mor/Siyah
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 0, 255)
MainFrame.Draggable = true
MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(80, 0, 140)
Title.Text = "  VIC FINDER PRO"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 80)
Status.Position = UDim2.new(0, 0, 0, 40)
Status.BackgroundTransparency = 1
Status.Text = "Aranıyor..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.Font = Enum.Font.SourceSansItalic
Status.TextSize = 22

-- 2. Vichop Mantığı (Çözülmüş ve Ayıklanmış)
local function CheckVicious()
    local found = nil
    -- Workspace taraması (Adamın kodunun kalbi burası)
    for _, v in pairs(workspace:GetChildren()) do
        -- Sahibi olmayan Rogue Vicious Bee
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            found = v
            break
        end
    end
    -- Diken/Stinger Kontrolü (Arı henüz çıkmamışsa bile bulur)
    if not found then
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "ViciousStinger" or v.Name == "ViciousThorn" then
                found = v
                break
            end
        end
    end
    return found
end

-- 3. Döngü ve Karar Mekanizması
task.spawn(function()
    while task.wait(2) do
        local target = CheckVicious()
        
        if target then
            Status.Text = "VIC FOUND!\nBekleniyor..."
            Status.TextColor3 = Color3.new(0, 1, 0) -- Yeşil
            
            -- Hareketi Kes (Bulucu hesabı dondurur)
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Anchored = true end

            -- Webhook Bildirimi
            pcall(function()
                game:GetService("HttpService"):PostAsync("https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730", 
                game:GetService("HttpService"):JSONEncode({
                    content = "📢 Vicious Bee Bulundu! Sunucu: " .. game.JobId
                }))
            end)
            break -- Bulduğunda döngüyü kır ve serverda kal
        else
            Status.Text = "Hopping...\n(Sunucu Aranıyor)"
            task.wait(1)
            -- SADECE SUNUCU DEĞİŞTİRMEK İÇİN MOTORU ÇALIŞTIR
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))()
        end
    end
end)
