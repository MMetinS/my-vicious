--====================================================================
-- FARMER (GİDİCİ) - ROGUE ONLY VERSION
--====================================================================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))()
local Window = library:CreateWindow("Vicious Farmer", Vector2.new(340, 260))
local Tab = Window:CreateTab("Savaşçı")

local Status = Tab:CreateLabel("Durum: Finder'dan veri bekleniyor...")
local Kills = Tab:CreateLabel("Kesilen Rogue: 0")
_G.KillCount = _G.KillCount or 0

task.spawn(function()
    while task.wait(2) do
        local rogue = nil
        for _, v in ipairs(workspace:GetChildren()) do
            if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
                rogue = v
                break
            end
        end

        if rogue then
            Status.Text = "Durum: Rogue Tespit Edildi! Saldırılıyor..."
            local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            
            -- Arının 12 birim üstünde dur (Stingerlardan kaçmak için)
            while rogue and rogue.Parent == workspace do
                hrp.CFrame = rogue.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                task.wait()
            end
            
            _G.KillCount = _G.KillCount + 1
            Kills.Text = "Kesilen Rogue: " .. _G.KillCount
            Status.Text = "Durum: Öldürüldü! Yeni veri bekleniyor..."
        end
    end
end)
