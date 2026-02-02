--==============================================
-- FINDER (GÖZCÜ) - ROGUE VICIOUS VERSION
--==============================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local lp = game:GetService("Players").LocalPlayer

_G.FoundCount = _G.FoundCount or 0
_G.StartTime = _G.StartTime or os.time()

local function createUI()
    if lp.PlayerGui:FindFirstChild("FinderPanel") then lp.PlayerGui.FinderPanel:Destroy() end
    local sg = Instance.new("ScreenGui", lp.PlayerGui); sg.Name = "FinderPanel"
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 220, 0, 100); frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); frame.Active = true; frame.Draggable = true
    Instance.new("UICorner", frame)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30); title.Text = "🔍 ROGUE FINDER"; title.TextColor3 = Color3.new(1,0.2,0.2)
    title.BackgroundColor3 = Color3.fromRGB(40, 0, 0); title.Font = "GothamBold"; title.TextSize = 14

    local foundLbl = Instance.new("TextLabel", frame)
    foundLbl.Size = UDim2.new(1, -20, 0, 30); foundLbl.Position = UDim2.new(0, 10, 0, 45)
    foundLbl.Text = "Bulunan: " .. _G.FoundCount; foundLbl.TextColor3 = Color3.new(1,1,1); foundLbl.BackgroundTransparency = 1; foundLbl.TextSize = 16

    task.spawn(function()
        while task.wait(1) do foundLbl.Text = "Bulunan Rogue: " .. _G.FoundCount end
    end)
end

local function serverHop()
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    if success and servers then
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId)
end

local function scan()
    createUI()
    task.wait(1.5)
    local target = nil
    -- Rogue Vicious Bee genellikle Workspace içinde bir Model olarak spawn olur
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" or (v:IsA("Model") and v.Name:find("Vicious") and v:FindFirstChild("HumanoidRootPart")) then
            target = v
            break
        end
    end

    if target then
        _G.FoundCount = _G.FoundCount + 1
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({jobId = game.JobId, found = true}))
        end)
        print("Rogue Vicious Bulundu! Farmer bekleniyor...")
        task.wait(20) -- Farmer'ın gelip savaşı başlatması için süre
    else
        serverHop()
    end
end
scan()
