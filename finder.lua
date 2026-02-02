--==============================
-- ULTRA FAST FINDER
--==============================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Found = false

-- BENZERSİZ SUNUCU BULMA FONKSİYONU
local function serverHop()
    print("Yeni ve farkli bir sunucu araniyor...")
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)

    if success then
        for _, server in ipairs(servers) do
            -- Dolu olmayan ve şu anki sunucudan farklı olanı seç
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                return
            end
        end
    end
    -- Hata olursa rastgele teleport
    TeleportService:Teleport(game.PlaceId)
end

-- VERİ GÖNDERME
local function sendData()
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
            jobId = game.JobId,
            placeId = game.PlaceId,
            viciousFound = true
        }))
    end)
end

-- TARAMA MANTIK (SADECE 2 SANİYE SÜRER)
local function startSearch()
    -- Mevcutları kontrol et
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("vicious") then
            Found = true
            sendData()
            print("Vicious Bulundu! Farmer'a haber verildi.")
            task.wait(5) -- Farmer'ın girmesi için çok kısa bir bekleme
            break
        end
    end

    if not Found then
        print("Vicious yok, vakit kaybetmeden yeni sunucuya geciliyor...")
        serverHop()
    end
end

-- Script başladığı gibi tarasın
task.wait(1) -- Dünyanın yüklenmesi için 1 sn bekleme yeterli
startSearch()
