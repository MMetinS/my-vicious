--====================================================================
-- ÖZEL TASARIM: VICIOUS FINDER PRO (DELTA OPTIMIZED)
--====================================================================

local function CreateUI()
    -- Ana Panel Kurulumu
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 260, 0, 150)
    MainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Koyu Gri/Siyah
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255) -- Mavi Kenarlık
    MainFrame.Active = true
    MainFrame.Draggable = true -- Paneli ekranda sürükleyebilirsin

    -- Başlık
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    Title.Text = "  VICIOUS FINDER V1"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18

    -- Durum Etiketi
    local StatusLabel = Instance.new("TextLabel", MainFrame)
    StatusLabel.Size = UDim2.new(1, -20, 0, 40)
    StatusLabel.Position = UDim2.new(0, 10, 0, 45)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Durum: Taranıyor..."
    StatusLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextSize = 20

    -- Sunucu Sayacı
    local ServerLabel = Instance.new("TextLabel", MainFrame)
    ServerLabel.Size = UDim2.new(1, -20, 0, 30)
    ServerLabel.Position = UDim2.new(0, 10, 0, 85)
    ServerLabel.BackgroundTransparency = 1
    ServerLabel.Text = "Server Hop: Aktif"
    ServerLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    ServerLabel.Font = Enum.Font.SourceSansItalic
    ServerLabel.TextSize = 16

    return StatusLabel
end

local Status = CreateUI()

-- TESPİT VE HOP SİSTEMİ (VICHOP LOGIC)
local function startLogic()
    task.wait(2)
    local target = nil

    -- 1toop'un sahipsiz arı bulma mantığı
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            target = v
            break
        end
    end

    if target then
        Status.Text = "DURUM: BULDUM! BEKLENİYOR..."
        Status.TextColor3 = Color3.new(1, 1, 0) -- Sarı
        
        -- Bulucu karakteri dondur (Hareketi Kes)
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = true end

        -- Webhook (Farmer'a haber ver)
        pcall(function()
            game:GetService("HttpService"):PostAsync("https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730", 
            game:GetService("HttpService"):JSONEncode({
                content = "🐝 **Vicious Bee Bulundu!** Server: " .. game.JobId
            }))
        end)
        task.wait(120)
    else
        Status.Text = "DURUM: YOK, HOPLANIYOR..."
        task.wait(1.5)
        -- Senin linkteki hızlı hop scriptini çalıştırır
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))()
    end
end

pcall(startLogic)
