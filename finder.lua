--==============================
-- FINDER (GÖZCÜ) - TURBO VERSION
--==============================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- HIZLI SERVER HOP FONKSİYONU
local function serverHop()
    local success, servers = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url)).data
    end)

    if success and servers then
        local available = {}
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                table.insert(available, s.id)
            end
        end
        if #available > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, available[math.random(1, #available)])
            return
        end
    end
    TeleportService:Teleport(game.PlaceId)
end

-- ANA MANTIK
print("Turbo Tarama Basladi...")

-- 1. Dünyanın yüklenmesini bekleme süresini 0.5 saniyeye indirdik
task.wait(0.5) 

local found = false
-- 2. Sadece Workspace'teki "Models" veya "NPCs" gibi yerlere bakmak yerine 
-- direkt isim taraması yapıyoruz (En hızlı yol)
for _, v in ipairs(workspace:GetChildren()) do
    if v.Name:lower():find("vicious") then
        found = true
        print("BULDUM! Veri gonderiliyor...")
        
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                jobId = game.JobId,
                placeId = game.PlaceId,
                viciousFound = true
            }))
        end)
        
        task.wait(5) -- Farmer'ın girmesi için kısa bir mola
        break
    end
end

-- 3. Bulamadıysa HİÇ BEKLEMEDEN çık
if not found then
    print("Vicious yok, yeni servera uculuyor...")
    serverHop()
end
