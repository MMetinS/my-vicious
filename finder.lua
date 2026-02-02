--==============================
-- FINDER (GÖZCÜ) - ANTI-REJOIN VERSION
--==============================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Found = false

-- GELİŞMİŞ VE RASTGELE SERVER HOP
local function serverHop()
    print("Mevcut sunucudan farkli bir yer araniyor...")
    
    local success, servers = pcall(function()
        -- Rastgelelik için Descending veya Ascending arasında geçiş yapabiliriz
        local sortType = math.random(1, 2) == 1 and "Asc" or "Desc"
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=".. sortType .."&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url)).data
    end)

    if success and servers then
        -- Sunucu listesini karıştır (Aynı sırayla denememesi için)
        local availableServers = {}
        for _, server in ipairs(servers) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                table.insert(availableServers, server.id)
            end
        end

        if #availableServers > 0 then
            -- Listeden rastgele bir sunucu seç
            local targetId = availableServers[math.random(1, #availableServers)]
            print("Yeni sunucu bulundu: " .. targetId)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId)
            return
        end
    end
    
    -- Eğer özel sunucu bulunamazsa standart teleport
    warn("Liste hatasi, standart teleport deneniyor...")
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
    
    -- Nesnelerin tam yüklenmesi için 3 saniye idealdir
    task.wait(3) 

    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("vicious") then
            Found = true
            print("Vicious Bee BULUNDU!")
            sendData()
            task.wait(15) -- Farmer'ın girmesi için biraz daha fazla süre
            break
        end
    end

    if not Found then
        print("Vicious bulunamadi, farkli bir sunucuya geciliyor...")
        serverHop()
    end
end

-- Hata payını azaltmak için scripti başlat
startSearch()
