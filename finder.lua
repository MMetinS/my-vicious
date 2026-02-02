-- [[ ALT HESAP - GÖNDERİCİ (V8 - Claimer Filtreli) ]] --
local webhook_url = "SENİN_WEBHOOK_LİNKİN" -- Buraya kendi Webhook linkini yapıştır!
local aranacak = "Spike" 

local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Players = game:GetService("Players")

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    wait(0.5); TPS:Teleport(game.PlaceId, Players.LocalPlayer)
end)

local function ViciousBul()
    for _, v in pairs(workspace:GetDescendants()) do
        if (string.find(v.Name, "Spike") or (string.find(v.Name, "Vicious") and v:FindFirstChild("Humanoid"))) then
            -- "Claimer" yazan sahte şeyleri ve oyuncu eşyalarını eliyoruz
            if not v:IsDescendantOf(Players) and not string.find(v.Name, "Claimer") and not (v.Parent and v.Parent.Name == "Bees") then
                return true
            end
        end
    end
    return false
end

local function ServerDegistir()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local s, r = pcall(function() return game:HttpGet(url) end)
    if s then
        local d = Http:JSONDecode(r).data
        for i=1,15 do 
            local sv = d[math.random(1,#d)]
            if sv and sv.playing > 0 and (sv.maxPlayers-sv.playing)>=2 and sv.id~=game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, sv.id, Players.LocalPlayer); return
            end
        end
    end
    TPS:Teleport(game.PlaceId, Players.LocalPlayer)
end

if not game:IsLoaded() then game.Loaded:Wait() end
wait(3)

if ViciousBul() then
    local veri = {
        ["content"] = "🎯 **HEDEF KİLİTLENDİ!**\nSECRET_ID:" .. game.JobId .. "\n(Main bekleniyor...)"
    }
    local req = (syn and syn.request) or request
    if req then req({Url=webhook_url, Method="POST", Headers={["Content-Type"]="application/json"}, Body=Http:JSONEncode(veri)}) end

    local VU = game:GetService("VirtualUser")
    Players.LocalPlayer.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    while true do wait(2) if not ViciousBul() then ServerDegistir(); break end end
else
    ServerDegistir()
end
