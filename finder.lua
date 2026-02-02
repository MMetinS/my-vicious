local HttpService = game:GetService("HttpService")
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local function sendToFarmer()
    local data = {
        jobId = game.JobId,
        placeId = game.PlaceId,
        timestamp = os.time()
    }
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data))
    end)
end

-- Vicious Bee Kontrolü
for _, v in pairs(workspace:GetDescendants()) do
    if v.Name:lower():find("vicious") then
        sendToFarmer()
        print("Veri gönderildi, 10 saniye sonra yeni servera geçiliyor...")
        task.wait(10)
        break
    end
end

-- Server Hop (Vicious bulsa da bulmasa da SearchTime sonunda çalışır)
task.wait(15) 
game:GetService("TeleportService"):Teleport(game.PlaceId)
