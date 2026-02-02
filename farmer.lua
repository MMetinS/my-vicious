--==============================================
-- FARMER (GİDİCİ) - ROGUE KILLER VERSION
--==============================================
local WEBHOOK_URL = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
local FLY_SPEED = 50
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local lp = game:GetService("Players").LocalPlayer

_G.ViciousKilled = _G.ViciousKilled or 0

local function createUI()
    if lp.PlayerGui:FindFirstChild("FarmerPanel") then lp.PlayerGui.FarmerPanel:Destroy() end
    local sg = Instance.new("ScreenGui", lp.PlayerGui); sg.Name = "FarmerPanel"
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 220, 0, 100); frame.Position = UDim2.new(0, 10, 0, 120)
    frame.BackgroundColor3 = Color3.fromRGB(20, 30, 20); frame.Active = true; frame.Draggable = true
    Instance.new("UICorner", frame)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30); title.Text = "⚔️ ROGUE KILLER"; title.TextColor3 = Color3.new(0.2, 1, 0.2)
    title.BackgroundColor3 = Color3.fromRGB(0, 40, 0); title.Font = "GothamBold"; title.TextSize = 14

    local killLbl = Instance.new("TextLabel", frame)
    killLbl.Size = UDim2.new(1, -20, 0, 30); killLbl.Position = UDim2.new(0, 10, 0, 45)
    killLbl.Text = "Kesilen: " .. _G.ViciousKilled; killLbl.TextColor3 = Color3.new(1,1,1); killLbl.BackgroundTransparency = 1; killLbl.TextSize = 16

    task.spawn(function()
        while task.wait(1) do killLbl.Text = "Kesilen Rogue: " .. _G.ViciousKilled end
    end)
end

local function flyTo(target)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local dist = (hrp.Position - target.Position).Magnitude
    TweenService:Create(hrp, TweenInfo.new(dist/FLY_SPEED, Enum.EasingStyle.Linear), {
        CFrame = target.CFrame * CFrame.new(0, 15, 0) -- Arının biraz üstünde durur (hasar yememek için)
    }):Play()
end

createUI()

while task.wait(5) do
    local rogue = nil
    -- Rogue Vicious Bee kontrolü
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Rogue Vicious Bee" then
            rogue = v
            break
        end
    end

    if rogue then
        local root = rogue:FindFirstChild("HumanoidRootPart")
        if root then
            flyTo(root)
            -- Rogue yok olana kadar bekle (Öldüğünü varsay)
            while rogue.Parent == workspace do task.wait(2) end
            _G.ViciousKilled = _G.ViciousKilled + 1
            print("Rogue Vicious kesildi!")
        end
    else
        -- Webhook'tan veri çek ve ışınlan
        local success, response = pcall(function() return game:HttpGet(WEBHOOK_URL) end)
        if success and response ~= "" then
            local data = HttpService:JSONDecode(response)
            if data and data.jobId and data.jobId ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, data.jobId)
            end
        end
    end
end
