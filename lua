local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local lastJobId = ""

print("Farmer dinlemede... Gözcüden veri bekleniyor.")

while task.wait(5) do
    pcall(function()
        local response = HttpService:GetAsync(WEBHOOK_URL)
        -- Webhook.site genelde son gelen POST verisini gösterir
        -- Veriyi decode edip kontrol ediyoruz
        local data = HttpService:JSONDecode(response)
        
        if data and data.jobId and data.jobId ~= lastJobId then
            print("Yeni Vicious bulundu! Işınlanılıyor: " .. data.jobId)
            lastJobId = data.jobId
            TeleportService:TeleportToPlaceInstance(data.placeId, data.jobId)
        end
    end)
end
