--==============================================
-- FINDER (GÖZCÜ) - STABLE VERSION
--==============================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- BASİT VE ETKİLİ SERVER HOP
local function serverHop()
    print("Farkli sunucu aranıyor...")
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)

    if success and servers then
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing < (s.maxPlayers - 1) then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId)
end

-- TARAMA FONKSİYONU
local function scan()
    print("Tarama basladi...")
    task.wait(2) -- Yuklenme payi

    local found = false
    -- Rogue Vicious Bee'yi bul (Wiki adiyla tam eslesme)
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" then
            found = true
            print("Rogue Vicious BULUNDU!")
            
            -- Webhook'a bildir
            pcall(function()
                HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
                    jobId = game.JobId,
                    placeId = game.PlaceId,
                    found = true
                }))
            end)
            
            task.wait(15) -- Farmer'in gelmesini bekle
            break
        end
    end

    if not found then
        print("Bulunamadi, yeni sunucuya geciliyor.")
        serverHop()
    end
end

-- Calistir
scan()
