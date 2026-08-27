-- =====================
-- SERVICES
-- =====================
task.wait(0.5)
local GameStarted = false
local GameRunning = true
local bossDead = false
local RS = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local gold = player:WaitForChild("leaderstats"):WaitForChild("Gold")
local RunService = game:GetService("RunService")
local Towers = workspace:WaitForChild("Towers")
local BUILD_LOCK = false
local ACTIVE_STEP = nil
local STOP_ALL = false

-- =====================
-- AUTO CHARM
-- =====================
local AUTO_CHARM = true
local COOLDOWN = 61
local lastUse = 0

task.spawn(function()
    while true do
        task.wait(1)

        if not AUTO_CHARM then continue end
        if bossDead then continue end

        if tick() - lastUse >= COOLDOWN then
            local success = pcall(function()
                RS.Events.UseCharm:FireServer(3)
                RS.Events.UseCharm:FireServer(2)
                RS.Events.UseCharm:FireServer(1)
            end)

            if success then
                lastUse = tick()
                print("Charm đã sài")
            end
        end
    end
end)

-- =====================
-- SIMPLE GUI (AUTO)
-- =====================
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Insane Farm"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 110)
frame.Position = UDim2.new(0, 10, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- UI CORNER
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,20)
title.BackgroundTransparency = 1
title.Text = "67 Insane 69?"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- GOLD
goldLabel = Instance.new("TextLabel")
goldLabel.Size = UDim2.new(1,0,0,20)
goldLabel.Position = UDim2.new(0,0,0,20)
goldLabel.BackgroundTransparency = 1
goldLabel.TextColor3 = Color3.fromRGB(255,255,0)
goldLabel.Text = "Gold: 0"
goldLabel.TextScaled = true
goldLabel.Font = Enum.Font.Gotham
goldLabel.Parent = frame

-- NEED
needLabel = Instance.new("TextLabel")
needLabel.Size = UDim2.new(1,0,0,20)
needLabel.Position = UDim2.new(0,0,0,40)
needLabel.BackgroundTransparency = 1
needLabel.TextColor3 = Color3.fromRGB(255,100,100)
needLabel.Text = "Need: 0"
needLabel.TextScaled = true
needLabel.Font = Enum.Font.Gotham
needLabel.Parent = frame

-- COST
costLabel = Instance.new("TextLabel")
costLabel.Size = UDim2.new(1,0,0,20)
costLabel.Position = UDim2.new(0,0,0,60)
costLabel.BackgroundTransparency = 1
costLabel.TextColor3 = Color3.fromRGB(100,255,100)
costLabel.Text = "Cost: 0"
costLabel.TextScaled = true
costLabel.Font = Enum.Font.Gotham
costLabel.Parent = frame

-- NEXT
nextLabel = Instance.new("TextLabel")
nextLabel.Size = UDim2.new(1,0,0,20)
nextLabel.Position = UDim2.new(0,0,0,80)
nextLabel.BackgroundTransparency = 1
nextLabel.TextColor3 = Color3.fromRGB(150,150,255)
nextLabel.Text = "Next: -"
nextLabel.TextScaled = true
nextLabel.Font = Enum.Font.Gotham
nextLabel.Parent = frame

-- =====================
-- VOTE
-- =====================
RS.Events.VoteForMap:FireServer("INSANE GeoCage")
task.wait(1)
RS.Events.VoteForMap:FireServer("Ready")

task.spawn(function()
    local info = workspace:WaitForChild("Info")
    local wave = info:WaitForChild("Wave")

    while true do
        task.wait(0.2)

        if STOP_ALL or bossDead then break end

        if wave.Value >= 21 then
            STOP_ALL = true
            bossDead = true
            GameRunning = false

            print("🛑 Wave 21 → FORCE LOSE")

            -- xoá sạch tower
            for i = 1, 3 do
                for _, tower in ipairs(workspace.Towers:GetChildren()) do
                    pcall(function()
                        RS.Functions.SellTower:InvokeServer(tower)
                    end)
                end
                task.wait(0.2)
            end

            break
        end
    end
end)

task.spawn(function()
    local info = workspace:WaitForChild("Info")
    local gameRunning = info:WaitForChild("GameRunning")

    task.wait(15)
    GameStarted = true

    while true do
        task.wait(0.5)

        if GameStarted and gameRunning.Value == false then
            GameRunning = false
            bossDead = true
            break
        end
    end
end)

-- =====================
-- RESULT CHECK
-- =====================
task.spawn(function()
    local info = workspace:WaitForChild("Info")
    local messages = info:WaitForChild("Message")
    local wave = info:FindFirstChild("Wave")

    local resultDetected = false

    local function check(text)
        text = string.lower(text)

        if string.find(text, "victory") or string.find(text, "victory!") then
            return "WIN"
        end

        if string.find(text, "game over") or string.find(text, "defeat") then
            return "LOSE"
        end
    end

    messages:GetPropertyChangedSignal("Value"):Connect(function()
        if resultDetected then return end

        local result = check(messages.Value)
        if not result then return end

        resultDetected = true
        bossDead = true
        GameRunning = false

        local waveValue = wave and wave.Value or 0

        if result == "WIN" then
            print("🏆 VICTORY")
            print("User:", player.Name)
            print("Gold:", gold.Value)
            print("Wave:", waveValue)
        else
            print("❌ DEFEAT")
            print("User:", player.Name)
            print("Gold:", gold.Value)
            print("Wave:", waveValue)
        end

        task.wait(1)
        pcall(function()
            RS.Events.ExitGame:FireServer()
        end)
    end)
end)

-- =====================
-- COST SYSTEM
-- =====================
local effects = workspace.Info.TowerEffects
local placeMulti = effects.PlacingTowerMultiplier
local upgradeMulti = effects.UpgradePriceMultiplier

local BASE_COST = {}

for _, f in ipairs(RS.Towers:GetChildren()) do
    for _, v in ipairs(f:GetChildren()) do
        for _, lvl in ipairs(v:GetChildren()) do
            for _, m in ipairs(lvl:GetChildren()) do
                if m:IsA("Model") and m:FindFirstChild("Config") then
                    local p = m.Config:FindFirstChild("Price")
                    if p and not BASE_COST[m.Name] then
                        BASE_COST[m.Name] = p.Value
                    end
                end
            end
        end
    end
end

local CUSTOM_COST = {
    ["Galaxy Wizard"] = 950,
    ["Galaxy Potions"] = 1350,
    ["Galaxy Spells"] = 3450,
    ["Enhanced Galaxy Spells"] = 7750,
    ["Galactic Staff"] = 56500,
    ["Geo Blaster"] = 2875,
    ["Geometrical Suit"] = 1200,
    ["Hacker"] = 3875
}

local function getCost(name, up, towerInstance)
    local base = CUSTOM_COST[name] or BASE_COST[name] or 0
    local cost = base * (up and upgradeMulti.Value or placeMulti.Value)

    if towerInstance and towerInstance:FindFirstChild("Config") then
        local cheaper = towerInstance.Config:FindFirstChild("CheaperUpgrades")
        if cheaper then
            cost = cost * cheaper.Value
        end
    end

    return math.floor(cost + 1)
end

-- =====================
-- WAIT GOLD
-- =====================
local currentTarget = {}

local function waitGold(name, isUpgrade, towerInstance)
    currentTarget.name = name
    currentTarget.isUpgrade = isUpgrade

    while true do
        if bossDead or STOP_ALL then return false end

        local cost = getCost(name, isUpgrade, towerInstance)

        if gold.Value >= cost then
            return true
        end

        task.wait(0.1)
    end
end

task.spawn(function()
    while true do
        task.wait(0.2)

        local target = currentTarget.name
        local isUp = currentTarget.isUpgrade

        if target then
            local cost = getCost(target, isUp, nil)

            costLabel.Text = "Cost: " .. cost
            needLabel.Text = "Need: " .. (cost - gold.Value)

            nextLabel.Text = "Next: " .. target
        else
            costLabel.Text = "Cost: 0"
            needLabel.Text = "Need: 0"
            nextLabel.Text = "Next: -"
        end
    end
end)

-- =====================
-- GLOBAL LOCK
-- =====================
local STEP_LOCK = nil
local STEP_TIMEOUT = 8
local stepStart = 0

local function startStep(name)
    STEP_LOCK = name
    stepStart = os.clock()
end

local function endStep()
    STEP_LOCK = nil
end

local function stepBlocked(name)
    if STEP_LOCK and STEP_LOCK ~= name then
        return true
    end
    if STEP_LOCK and os.clock() - stepStart > STEP_TIMEOUT then
        STEP_LOCK = nil
    end
    return false
end

-- =====================
-- SPAWN TOWER SAFE
-- =====================
local function spawnTowerSafe(args)
    if STOP_ALL then return nil end
    local old = args[3]
    local name = args[1]
    local isUpgrade = old ~= nil
    local cf = args[2]
    local class = args[4]

    local timeout = 10
    local startTime = os.clock()

    while true do
        if bossDead then
            BUILD_LOCK = false
            ACTIVE_STEP = nil
            return nil
        end

        if os.clock() - startTime > timeout then
            warn("❌ Timeout spawn:", name)
            BUILD_LOCK = false
            ACTIVE_STEP = nil
            return nil
        end

        local cost = getCost(name, isUpgrade, old)

        if gold.Value < cost then
            task.wait(0.1)
            continue
        end

        BUILD_LOCK = true
        ACTIVE_STEP = name

        local beforeGold = gold.Value

        local result = RS.Functions.SpawnTower:InvokeServer(unpack(args))

        local waited = 0
        local afterGold = beforeGold

        while waited < 0.5 do
            task.wait(0.05)
            waited += 0.05
            afterGold = gold.Value
            if afterGold < beforeGold then
                break
            end
        end

        if afterGold >= beforeGold then
            BUILD_LOCK = false
            ACTIVE_STEP = nil
            task.wait(0.2)
            continue
        end

        if result and result.Parent then
            task.wait(0.1)
            BUILD_LOCK = false
            ACTIVE_STEP = nil
            return result
        end

        local found

        for _ = 1, 10 do
            for _, tower in ipairs(Towers:GetChildren()) do
                local c = tower:FindFirstChild("Class")

                if c and c.Value == class then
                    local dist = (tower:GetPivot().Position - cf.Position).Magnitude
                    if dist < 3 then
                        found = tower
                        break
                    end
                end
            end

            if found then break end
            task.wait(0.1)
        end

        BUILD_LOCK = false
        ACTIVE_STEP = nil

        return found
    end
end

-- =====================
-- SAFE UPGRADE
-- =====================
local function safeUpgrade(name, tower, class)
    while true do
        if bossDead or STOP_ALL then return nil end
        if not tower or not tower.Parent then return nil end

        waitGold(name, true, tower)

        local new = spawnTowerSafe({
            name,
            tower:GetPivot(),
            tower,
            class
        })

        if new then
            task.wait(0.15)
            return new
        end

        task.wait(0.2)
    end
end

-- =====================
-- AUTO SKIP
-- =====================
local args = {
    [1] = "AutoSkip",
    [2] = true
}
game:GetService("ReplicatedStorage").Events.RequestSettingSave:FireServer(unpack(args))

-- =====================
-- BUILD FLOW
-- =====================

-- 1. EXPLORER × 4
local explorerPos = {
    CFrame.new(-221.7653,7.8147,-81.3051),
    CFrame.new(-221.9095,7.8147,-78.5632),
    CFrame.new(-225.7108,7.8147,-78.7834),
    CFrame.new(-225.7969,7.8147,-81.4535),
}

for _,cf in ipairs(explorerPos) do
    startStep("Explorer")

    if not stepBlocked("Explorer") then
        waitGold("Desert Explorer", false)
        spawnTowerSafe({"Desert Explorer", cf, nil, "Explorer", "Desert Explorer"})
    end

    endStep()
    task.wait(0.2)
end

-- 2. GUARDIAN × 6
local guardians = {}
local guardianPos = {
    CFrame.new(-225.6411,7.8147,-84.9286),
    CFrame.new(-223.0359,7.8147,-85.0404),
    CFrame.new(-220.5131,7.8147,-85.0323),
    CFrame.new(-220.7988,7.8147,-87.6007),
    CFrame.new(-223.5070,7.8147,-87.6033),
    CFrame.new(-226.1602,7.8147,-87.5709)
}

for i,cf in ipairs(guardianPos) do
    startStep("Guardian")

    if not stepBlocked("Guardian") then
        waitGold("Guardian", false)
        guardians[i] = spawnTowerSafe({"Guardian", cf, nil, "Guardian"})
    end

    endStep()
end

-- 3. SNIPER × 5 → LV2 (Pro Sniper)
local snipers = {}
local sniperPos = {
    CFrame.new(-217.88,7.81,-85.06),
    CFrame.new(-218.08,7.81,-87.63),
    CFrame.new(-215.31,7.81,-85.09),
    CFrame.new(-215.53,7.81,-87.81),
    CFrame.new(-212.78,7.81,-85.09),
}

for i,cf in ipairs(sniperPos) do
    startStep("Sniper_LV2")

    if not stepBlocked("Sniper_LV2") then
        waitGold("Laser Sniper", false)

        local s = spawnTowerSafe({"Laser Sniper", cf, nil, "Laser Sniper"})

        if s then
            s = safeUpgrade("Pro Sniper", s, "Laser Sniper")
        end

        snipers[i] = s
    end

    endStep()
end

-- 4. WIZARD × 2 → GALACTIC STAFF
local function fullWizard(cf)
    startStep("Wizard")

    if stepBlocked("Wizard") then endStep() return end

    waitGold("Galaxy Wizard", false)

    local w = spawnTowerSafe({"Galaxy Wizard", cf, nil, "Wizard", "Galaxy Wizard"})

    if not w then endStep() return end

    local chain = {
        "Galaxy Potions",
        "Galaxy Spells",
        "Enhanced Galaxy Spells",
        "Galactic Staff"
    }

    for _,name in ipairs(chain) do
        local new = safeUpgrade(name, w, "Wizard")
        if not new then break end
        w = new
    end

    endStep()
    return w
end

fullWizard(CFrame.new(-213.17,8.08,-80.96))
fullWizard(CFrame.new(-209.98,8.05,-80.41))

-- 5. SNIPER LV3 (Glowing Hat)
for i,s in ipairs(snipers) do
    startStep("Sniper_LV3")

    if s and not stepBlocked("Sniper_LV3") then
        s = safeUpgrade("Glowing Hat", s, "Laser Sniper")
        snipers[i] = s
    end

    endStep()
end

-- 6. GUARDIAN UPGRADE (Deserted Armor → Snowy Helmet → Lava Knight)
for i,g in ipairs(guardians) do
    startStep("GuardianUpgrade")

    if g and not stepBlocked("GuardianUpgrade") then
        for _,name in ipairs({"Deserted Armor","Snowy Helmet","Lava Knight"}) do
            local new = safeUpgrade(name, g, "Guardian")
            if not new then break end
            g = new
        end
        guardians[i] = g
    end

    endStep()
end

-- 7. MACHINIST → FUTURIST
startStep("Machinist")

if not stepBlocked("Machinist") then
    waitGold("Machinist", false)

    local mPos = CFrame.new(-219.16,7.81,-81.14)
    local m = spawnTowerSafe({"Machinist", mPos, nil, "Machinist"})

    if m then
        for _,name in ipairs({"Faster Working","Second Machine","True Machinist","Futurist"}) do
            local new = safeUpgrade(name, m, "Machinist")
            if not new then break end
            m = new
        end
    end
end

endStep()

-- 8. SNIPER FINAL LV3 → LV6 (More Grip → Heavy Clothes → Frosted Lasers)
for i,s in ipairs(snipers) do
    startStep("SniperFinal")

    if s and not stepBlocked("SniperFinal") then
        for _,name in ipairs({
            "More Grip",
            "Heavy Clothes",
            "Frosted Lasers"
        }) do
            local new = safeUpgrade(name, s, "Laser Sniper")
            if not new then break end
            s = new
        end

        snipers[i] = s
    end

    endStep()
end

-- 9. GUARDIAN FINAL (Electrifying Sword → Guardian Angel)
for i,g in ipairs(guardians) do
    startStep("GuardianFinal")

    if g and not stepBlocked("GuardianFinal") then
        for _,name in ipairs({"Electrifying Sword","Guardian Angel"}) do
            local new = safeUpgrade(name, g, "Guardian")
            if not new then break end
            g = new
        end
        guardians[i] = g
    end

    endStep()
end
