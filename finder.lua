--==============================
-- FINDER (GÖZCÜ) - FULL VERSION
--==============================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Found = false

-- FARKLI SUNUCU BULMA FONKSİYONU
local function serverHop()
    print("Mevcut sunucudan farkli bir yer araniyor...")
    local success, servers = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url)).data
    end)

    if success and servers then
        for _, server in ipairs(servers) do
            -- Mevcut sunucuyla aynı ID olmamalı ve doluluk oranı uygun olmalı
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                print("Yeni sunucu bulundu: " .. server.id)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                return
            end
        end
    end
    -- Liste hatası durumunda klasik ışınlanma
    TeleportService:Teleport(game.PlaceId)
end

-- VERİ GÖNDERME
local function sendData()
    local payload = {
        jobId = game.JobId,
        placeId = game.PlaceId,
        viciousFound = true,
        timestamp = os.time()
    }
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(payload))
    end)
end

-- ANA TARAMA DÖNGÜSÜ
local function startSearch()
    print("Vicious Bee taraniyor...")
    task.wait(2) -- Nesnelerin yüklenmesi için kısa süre

    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("vicious") then
            Found = true
            print("Vicious Bee BULUNDU! Farmer'a haber veriliyor.")
            sendData()
            task.wait(10) -- Farmer'ın girmesi için bekleme süresi
            break
        end
    end

    if not Found then
        print("Vicious bulunamadi, yeni sunucuya geciliyor...")
        serverHop()
    end
end

-- Başlat
startSearch()
