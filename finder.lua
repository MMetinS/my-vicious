--==============================
-- FINDER CONFIG
--==============================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local SEARCH_TIME = 15 -- Serverda kalma süresi (sn)

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Found = false

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

local function check(obj)
    if not Found and obj.Name:lower():find("vicious") then
        Found = true
        print("Vicious Bee Bulundu! Veri gönderiliyor...")
        sendData()
        task.wait(10) -- Farmer'ın gelmesi için kısa süre tanı
        TeleportService:Teleport(game.PlaceId)
    end
end

-- Arama Başlat
for _, v in pairs(workspace:GetDescendants()) do check(v) end
workspace.DescendantAdded:Connect(check)

-- Bulamazsa Hop yap
task.delay(SEARCH_TIME, function()
    if not Found then
        print("Vicious bulunamadı, yeni servera geçiliyor...")
        TeleportService:Teleport(game.PlaceId)
    end
end)
