--==============================================
-- FINDER (GÖZCÜ) - TURBO PANEL VERSION
--==============================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- STATS (İstatistikler)
_G.FoundCount = _G.FoundCount or 0
_G.StartTime = _G.StartTime or os.time()
_G.StingerCount = _G.StingerCount or 0

-- ARAYÜZ OLUŞTURMA (GUI)
local function createUI()
    if lp.PlayerGui:FindFirstChild("FinderPanel") then lp.PlayerGui.FinderPanel:Destroy() end
    
    local screenGui = Instance.new("ScreenGui", lp.PlayerGui)
    screenGui.Name = "FinderPanel"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 220, 0, 130)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "🐝 VICIOUS TRACKER"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14

    local function createLabel(yPos, text)
        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1, -20, 0, 25)
        lbl.Position = UDim2.new(0, 10, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        return lbl
    end

    local timerLbl = createLabel(40, "Yükleniyor...")
    local foundLbl = createLabel(65, "Bulunan: " .. _G.FoundCount)
    local stingerLbl = createLabel(90, "Stinger: " .. _G.StingerCount)

    task.spawn(function()
        while task.wait(1) do
            local diff = os.time() - _G.StartTime
            local min, sec = math.floor(diff/60), diff%60
            timerLbl.Text = string.format("Süre: %dm %ds", min, sec)
            foundLbl.Text = "Bulunan Vicious: " .. _G.FoundCount
            stingerLbl.Text = "Tahmini Stinger: " .. _G.StingerCount
        end
    end)
end

-- SERVER HOP (AYNI SERVERI ENGELLER)
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

-- ANA TARAMA
local function scan()
    createUI()
    task.wait(0.8)

    local target = nil
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name:lower():find("vicious") and v:IsA("Model") then
            target = v
            break
        end
    end

    if target then
        _G.FoundCount = _G.FoundCount + 1
        pcall(function()
            HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({jobId = game.JobId, vicious = true}))
        end)
        
        -- Stinger takibi için Vicious ölünce sayacı artır
        target.AncestryChanged:Connect(function()
            if not target:IsDescendantOf(workspace) then _G.StingerCount = _G.StingerCount + 5 end
        end)

        task.wait(15) -- Farmer gelene kadar bekle
    end
    
    serverHop()
end

scan()
