--====================================================================
-- TAMAMEN BAĞIMSIZ VICIOUS FINDER (1TOOP MANTIĞI ÇÖZÜLDÜ)
--====================================================================

-- 1. ARAYÜZ (Görsel ve Kullanışlı)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 140)
MainFrame.Position = UDim2.new(0.5, -125, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "  MY-VICIOUS FINDER v1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 110)
Status.Position = UDim2.new(0, 0, 0, 30)
Status.BackgroundTransparency = 1
Status.Text = "Analiz Ediliyor..."
Status.TextColor3 = Color3.new(1, 1, 1)
Status.TextSize = 22

-- 2. ADAMIM LİNKİNDEKİ SUNUCU ATLAMA (HOP) MANTIĞI
local function ServerHop()
    Status.Text = "SUNUCU DEĞİŞİYOR..."
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    
    if success then
        for _, s in ipairs(result) do
            if s.id ~= game.JobId and s.playing < (s.maxPlayers - 1) then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId)
end

-- 3. ADAMIM LİNKİNDEKİ BULMA (DETECTION) MANTIĞI
local function CheckVicious()
    for _, v in pairs(workspace:GetChildren()) do
        -- Sadece Rogue olan ve sahibi olmayan (vahşi) arı
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            return v
        end
    end
    -- Ekstra: Eğer arı henüz çıkmadıysa ama dikeni varsa onu da gör
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "ViciousStinger" or v.Name == "ViciousThorn" then
            return v
        end
    end
    return nil
end

-- 4. ANA DÖNGÜ
task.spawn(function()
    Status.Text = "TARANIYOR..."
    task.wait(3) -- Harita yüklenme payı
    
    local found = CheckVicious()
    
    if found then
        Status.Text = "VIC FOUND!\nBEKLENİYOR..."
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- KRİTİK NOKTA: Karakteri dondur (Asla kesmeye gitmez)
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = true end
        
        -- Webhook (Farmer'ı uyandır)
        pcall(function()
            game:GetService("HttpService"):PostAsync("https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730", 
            game:GetService("HttpService"):JSONEncode({
                content = "🐝 **Vicious Bee Bulundu!** \nJobId: `" .. game.JobId .. "`"
            }))
        end)
    else
        Status.Text = "BULUNAMADI.\nZıplanıyor..."
        task.wait(1)
        ServerHop()
    end
end)
