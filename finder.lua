--====================================================================
-- PURE FINDER (GÖZCÜ) - SADECE BULUR VE HABER VERİR
--====================================================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

-- Basit UI
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 60)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.new(0,0,0)
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1,0,1,0)
label.Text = "VICIOUS ARANIYOR..."
label.TextColor3 = Color3.new(1,1,1)

local function ServerHop()
    label.Text = "SUNUCU DEGISTIRILIYOR..."
    local HttpService = game:GetService("HttpService")
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, s in ipairs(servers) do
        if s.id ~= game.JobId and s.playing < (s.maxPlayers - 1) then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
            return
        end
    end
end

local function check()
    for _, v in pairs(workspace:GetChildren()) do
        -- Sahipsiz Rogue Vicious Bee kontrolü
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            return v
        end
    end
    return nil
end

task.spawn(function()
    task.wait(3)
    local vic = check()
    if vic then
        label.Text = "BULDUM! WEBHOOK ATILDI."
        -- Dondur
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        
        -- Webhook'a Join Kodu Atma
        local joinCode = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..game.PlaceId..', "'..game.JobId..'")'
        game:GetService("HttpService"):PostAsync(WEBHOOK_URL, game:GetService("HttpService"):JSONEncode({
            content = "🐝 **Vicious Bee Bulundu!**\n\n**Join Kodu (Farmer için):**\n```lua\n"..joinCode.."\n```"
        }))
    else
        task.wait(1)
        ServerHop()
    end
end)
