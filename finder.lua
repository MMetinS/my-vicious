--====================================================================
-- VICIOUS HUNTER PRO (KESİN TESPİT - MOBİL)
--====================================================================

local success_ui, library = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))() 
end)

local success_hop, fastHop = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/hop.lua"))() 
end)

local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local HttpService = game:GetService("HttpService")

_G.FoundCount = _G.FoundCount or 0
_G.ServerCount = _G.ServerCount or 0

local Window = library:CreateWindow("Vicious Finder V2", Vector2.new(320, 240))
local MainTab = Window:CreateTab("Gözcü")
local StatusLabel = MainTab:CreateLabel("Durum: Başlıyor...")
local FoundLabel = MainTab:CreateLabel("Gerçek Vicious: " .. _G.FoundCount)

-- GERÇEK VICIOUS KONTROLÜ (FİLTRELİ)
local function isRealRogue(v)
    -- 1. İsim tam eşleşmeli
    if v.Name == "Rogue Vicious Bee" then
        -- 2. Bir oyuncuya ait olmamalı (Owner kontrolü)
        if not v:FindFirstChild("Owner") and v:IsA("Model") then
            -- 3. Vahşi arıların seviye etiketi olur
            if v:FindFirstChild("LevelLabel", true) or v:FindFirstChild("HumanoidRootPart") then
                return true
            end
        end
    end
    return false
end

local function scan()
    StatusLabel.Text = "Durum: Harita taranıyor..."
    task.wait(2)
    
    local foundTarget = nil
    -- Workspace içindeki tüm çocuklara bak
    for _, v in ipairs(workspace:GetChildren()) do
        if isRealRogue(v) then
            foundTarget = v
            break
        end
    end

    if foundTarget then
        _G.FoundCount = _G.FoundCount + 1
        FoundLabel.Text = "Gerçek Vicious: " .. _G.FoundCount
        StatusLabel.Text = "Durum: GERÇEK VICIOUS BULUNDU!"
        
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                jobId = game.JobId,
                found = true,
                details = "Doğrulanmış Rogue Vicious Bee"
            }))
        end)
        task.wait(20) -- Farmer için bekle
    else
        StatusLabel.Text = "Durum: Rogue yok, zıplanıyor..."
        _G.ServerCount = _G.ServerCount + 1
        if success_hop then fastHop() else game:GetService("TeleportService"):Teleport(game.PlaceId) end
    end
end

-- Döngü
task.spawn(function()
    while task.wait(1) do
        scan()
        break -- Her sunucuda bir kez çalışıp hop yapması için
    end
end)
