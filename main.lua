--==============================
-- CONFIG
--==============================
_G.Config = {
    Webhook = "",
    HopAfter = 60,
    FlySpeed = 8,
    SearchTime = 10 -- vicious aramak için beklenecek süre
}

--==============================
-- SERVICES
--==============================
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--==============================
-- CHARACTER WAIT
--==============================
local function waitForCharacter()
    if LocalPlayer.Character then return end
    LocalPlayer.CharacterAdded:Wait()
end

waitForCharacter()
task.wait(2) -- ekstra güvenlik

--==============================
-- WEBHOOK
--==============================
local function sendWebhook(msg)
    if _G.Config.Webhook == "" then return end
    pcall(function()
        HttpService:PostAsync(
            _G.Config.Webhook,
            HttpService:JSONEncode({ content = msg })
        )
    end)
end

--==============================
-- FLY (TWEEN)
--==============================
local function flyToVicious(vic)
    local char = LocalPlayer.Character
    local hrp = char:WaitForChild("HumanoidRootPart")

    local part = vic:IsA("BasePart") and vic
        or vic:FindFirstChildWhichIsA("BasePart")

    if not part then return end

    local distance = (hrp.Position - part.Position).Magnitude
    local time = distance / _G.Config.FlySpeed

    TweenService:Create(
        hrp,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        { CFrame = part.CFrame * CFrame.new(0, 6, 0) }
    ):Play()
end

--==============================
-- VICIOUS LOGIC
--==============================
local Found = false

local function isVicious(obj)
    return obj.Name:lower():find("vicious")
end

local function onViciousFound(vic)
    if Found then return end
    Found = true

    sendWebhook("🐝 Vicious bulundu")
    flyToVicious(vic)

    task.delay(_G.Config.HopAfter, function()
        TeleportService:Teleport(game.PlaceId)
    end)
end

--==============================
-- MEVCUT OLANLARI TARA
--==============================
for _, v in pairs(workspace:GetDescendants()) do
    if isVicious(v) then
        onViciousFound(v)
        return
    end
end

--==============================
-- SONRADAN SPAWN OLURSA
--==============================
workspace.DescendantAdded:Connect(function(obj)
    if isVicious(obj) then
        onViciousFound(obj)
    end
end)

--==============================
-- BELİRLİ SÜRE BEKLE, YOKSA HOP
--==============================
task.delay(_G.Config.SearchTime, function()
    if not Found then
        TeleportService:Teleport(game.PlaceId)
    end
end)
