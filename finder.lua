--====================================================================
-- VICIOUS FINDER PRO (VICHOP LOGIC)
--====================================================================
local success, library = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/MMetinS/my-vicious/main/test4.lua"))() 
end)

local Window = (success and library) and library:CreateWindow("Vicious Gözcü", Vector2.new(350, 250)) or nil
local Tab = Window and Window:CreateTab("Gözcü") or nil

local function log(txt)
    print("[Finder]: " .. txt)
    if Tab then Tab:CreateLabel(txt) end
end

-- VICHOP'UN TESPİT MANTIĞI (ÇÖZÜLMÜŞ)
local function startScan()
    log("Tarama basliyor...")
    task.wait(3)
    
    local target = nil
    for _, v in pairs(workspace:GetChildren()) do
        -- 1toop'un kullandığı en temiz Rogue tespiti
        if v.Name == "Rogue Vicious Bee" and not v:FindFirstChild("Owner") then
            target = v
            break
        end
    end

    if target then
        log("BULDUM! Webhook gidiyor.")
        -- Kesmemesi için dondur (Anchored)
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = true end
        
        -- Buraya Webhook kodunu ekle (HttpService:PostAsync)
        task.wait(60) 
    else
        log("Yok, sunucu degistiriliyor...")
        -- Sunucu degistirme kodun buraya
        task.wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1toop/vichop/main/hop.lua"))()
    end
end

task.spawn(startScan)
