-- Delta Executor Fix - Vicious Finder
repeat task.wait() until game:IsLoaded()

local function FinderSystem()
    -- 1. EKRAN YAZISI (Delta'da çalıştığını anlaman için)
    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local txt = Instance.new("TextLabel", sg)
    txt.Size = UDim2.new(0, 200, 0, 50)
    txt.Position = UDim2.new(0.5, -100, 0.1, 0)
    txt.Text = "Gözcü Aktif: Tarıyor..."
    txt.BackgroundColor3 = Color3.new(0,0,0)
    txt.TextColor3 = Color3.new(0,1,0)
    txt.ZIndex = 10

    -- 2. TESPİT MANTIĞI (Vichop'tan çözülen: Sahipsiz Rogue Vicious)
    local function check()
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
                return v
            end
        end
        return nil
    end

    local target = check()

    if target then
        txt.Text = "BULDUM! Donduruldum."
        -- DONDURMA (Kesmeye gitmesini engeller)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = true
        end
        
        -- WEBHOOK
        local url = "https://webhook.site/0fe2a617-0369-4bde-b905-92e568877730"
        pcall(function()
            game:GetService("HttpService"):PostAsync(url, game:GetService("HttpService"):JSONEncode({
                content = "🐝 Vicious Bee Burada! JobId: " .. game.JobId
            }))
        end)
        task.wait(100)
    else
        txt.Text = "Yok, Sunucu Değişiyor..."
        task.wait(2)
        -- SENİN ÇALIŞIYOR DEDİĞİN MOTORU TETİKLE
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))()
    end
end

pcall(FinderSystem)
