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
local ignore = {}
local BUILD_LOCK = false
local ACTIVE_STEP = nil
local STOP_ALL = false
-- =====================
-- AUTO CHARM
-- =====================
local RS = game:GetService("ReplicatedStorage")

local AUTO_CHARM = true
local COOLDOWN = 99
local lastUse = 0

task.spawn(function()
    while true do
        task.wait(1)

        if not AUTO_CHARM then continue end
        if bossDead then continue end

        if tick() - lastUse >= COOLDOWN then
            local success = pcall(function()
                RS.Events.UseCharm:FireServer(3)
            end)

            if success then
                lastUse = tick()
                print("Charm đã sài")
            end
        end
    end
end)


local function isIgnored(pos)
    for _,v in ipairs(ignore) do
        if (v - pos).Magnitude < 3 then
            return true
        end
    end
    return false
end

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
frame.Size = UDim2.new(0, 200, 0, 130)
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
title.Text = "67 Insane 67"
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

local rebuildLabel = Instance.new("TextLabel")
rebuildLabel.Size = UDim2.new(1,0,0,20)
rebuildLabel.Position = UDim2.new(0,0,0,100)
rebuildLabel.BackgroundTransparency = 1
rebuildLabel.TextColor3 = Color3.fromRGB(255,150,150)
rebuildLabel.Text = "Rebuild: False"
rebuildLabel.TextScaled = true
rebuildLabel.Font = Enum.Font.Gotham
rebuildLabel.Parent = frame

-- =====================
-- STATE
-- =====================
local REBUILDING = false
local rebuildQueue = {}
local rebuildingNow = false
local rebuildState = {
    active = false,
    name = "-",
    level = 0
}
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

            -- 🔥 clear queue rebuild luôn
            rebuildQueue = {}

            -- 🔥 xóa sạch nhiều lần cho chắc (anti fail)
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

    task.wait(15) -- đợi game vô ( ~15s )
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

        -- print win/thua
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

        -- out game
        task.wait(1)
        pcall(function()
            RS.Events.ExitGame:FireServer()
        end)
    end)
end)

local function waitTowerByCF(class, cf)
    for _ = 1, 20 do
        for _, t in ipairs(Towers:GetChildren()) do
            local c = t:FindFirstChild("Class")
            if c and c.Value == class then
                local dist = (t:GetPivot().Position - cf.Position).Magnitude
                if dist < 3 then
                    return t
                end
            end
        end
        task.wait(0.1)
    end
    return nil
end

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
    ["Galaxy Wizard"] = 3500,
    ["Galaxy Potions"] = 2000,
    ["Galaxy Spells"] = 4400,
    ["Enhanced Galaxy Spells"] = 7800,
    ["Galactic Staff"] = 41650
}

local function getCost(name, up, towerInstance)
    local base = CUSTOM_COST[name] or BASE_COST[name] or 0
    local cost = base * (up and upgradeMulti.Value or placeMulti.Value)

    -- check giá giảm
    if towerInstance and towerInstance:FindFirstChild("Config") then
        local cheaper = towerInstance.Config:FindFirstChild("CheaperUpgrades")
        if cheaper then
            cost = cost * cheaper.Value
        end
    end

    return math.floor(cost + 1)
end

local UPGRADE_CHAIN = {
    ["Guardian"] = {
        "Deserted Armor",
        "Snowy Helmet",
        "Lava Knight",
        "Electrifying Sword",
        "Guardian Angel"
    },

    ["Laser Sniper"] = {
        "Pro Sniper",
        "Glowing Hat",
        "More Grip",
        "Heavy Clothes",
        "Frosted Lasers"
    },

    ["Wizard"] = {
        "Galaxy Potions",
        "Galaxy Spells",
        "Enhanced Galaxy Spells",
        "Galactic Staff"
    },

    ["Machinist"] = {
        "Faster Working",
        "Second Machine",
        "True Machinist",
        "Futurist"
    },

    ["Lava Mortar"] = {
        "Electric Hat",
        "Lightning Lava",
        "Electrically Trained",
        "Mega Zap Mortar"
    },

    ["Drone Pilot"] = {
        "Stable Flying",
        "Bombs",
        "Toxic Bombs",
        "Death Heli"
    }
}

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


local function waitGoldRebuild(name, isUpgrade, towerInstance)
    while true do
        if bossDead then return false end

        local cost = getCost(name, isUpgrade, towerInstance)

        -- first check
        if gold.Value >= cost then

            -- double check
            task.wait(0.5)

            if bossDead then return false end

            local cost = getCost(name, isUpgrade, towerInstance)

            if gold.Value >= cost then
                return true
            end
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

local function safeWait()
    while REBUILDING or rebuildingNow do task.wait() end
end

-- =====================
-- SPAWN
-- =====================
local function spawn(args)
    while REBUILDING and not rebuildingNow do task.wait() end
    if bossDead then return end
    return RS.Functions.SpawnTower:InvokeServer(unpack(args))
end

-- =====================
-- SNAPSHOT
-- =====================
local function readTower(t)
    local c = t:FindFirstChild("Class")
    local s = t:FindFirstChild("Skin")
    if not c or not s then return end

    local lv = t:FindFirstChild("Level")
    return {
        class = c.Value,
        skin = s.Value,
        level = lv and lv.Value or 1,
        pos = t:GetPivot().Position,
        cf = t:GetPivot()
    }
end

local function key(pos)
    return math.floor(pos.X*10).."_"..math.floor(pos.Y*10).."_"..math.floor(pos.Z*10)
end

local function snapshot()
    local snap = {}
    for _,t in ipairs(Towers:GetChildren()) do
        local d = readTower(t)
        if d then snap[key(d.pos)] = d end
    end
    return snap
end

local lastSnapshot = snapshot()
local debounce = {}
-- =====================
-- SPAWN BASE
-- =====================
local function spawnBase(data)
    local name = data.skin ~= "Default" and data.skin or data.class

    if not waitGoldRebuild(name, false) then return end

    if data.skin == "Default" then
        return spawn({data.class, data.cf, nil, data.class})
    else
        return spawn({data.skin, data.cf, nil, data.class, data.skin})
    end
end

-- =====================
-- UPGRADE
-- =====================
local function upgradeTower(tower, lv)
    local class = tower:FindFirstChild("Class").Value
    local chain = UPGRADE_CHAIN[class]

    if not chain then return nil end

    local upgradeName = chain[lv-1]
    if not upgradeName then return nil end

    -- waitGold
    if not waitGoldRebuild(upgradeName, true, tower) then
        return nil
    end

    local newTower = spawn({
        upgradeName,
        tower:GetPivot(),
        tower,
        class
    })

    -- 🔥 return khi success only
    if newTower then
        return newTower
    end

    return nil
end

-- =====================
-- REBUILD QUEUE
-- =====================
local function rebuild(data)
    if STOP_ALL then return end

    for _,v in ipairs(rebuildQueue) do
        if (v.pos - data.pos).Magnitude < 1 then return end
    end
    table.insert(rebuildQueue, data)
end
-- =====================
-- WORKER (SEQUENTIAL FIX)
-- =====================
task.spawn(function()
    while true do
        task.wait(0.05)

        -- 🛑 STOP ALL → clear hết và nghỉ rebuild
        if STOP_ALL then
            rebuildQueue = {}
            REBUILDING = false
            rebuildingNow = false

            -- reset state UI
            rebuildState.active = false
            rebuildState.name = "-"
            rebuildState.level = 0

            continue
        end

        -- đang rebuild thì bỏ qua
        if rebuildingNow then continue end
        if #rebuildQueue == 0 then continue end

        rebuildingNow = true
        REBUILDING = true

        local data = table.remove(rebuildQueue, 1)

        if not data then
            rebuildingNow = false
            REBUILDING = false
            continue
        end

        rebuildState.active = true
        rebuildState.name = data.class
        rebuildState.level = data.level

        -- =====================
        -- SPAWN BASE
        -- =====================
        local tower
        local tries = 0
        local maxTries = 3

        while tries < maxTries do
            if STOP_ALL or bossDead then break end

            tower = spawnBase(data)

            if tower then break end

            tries += 1
            task.wait(0.3)
        end

        if STOP_ALL or bossDead then
            rebuildingNow = false
            REBUILDING = false
            rebuildState.active = false
            continue
        end

        if not tower then
            rebuildingNow = false
            REBUILDING = false
            rebuildState.active = false
            continue
        end

        -- =====================
        -- UPGRADE LOOP
        -- =====================
        for lv = 2, data.level do
            if STOP_ALL or bossDead then break end
            if not tower or not tower.Parent then break end

            local upgraded = false

            while not upgraded do
                if STOP_ALL or bossDead then break end
                if not tower or not tower.Parent then break end

                local newTower = upgradeTower(tower, lv)

                if newTower then
                    tower = newTower
                    upgraded = true
                else
                    task.wait(0.3)
                end
            end
        end

        -- =====================
        -- DONE
        -- =====================
        rebuildingNow = false
        REBUILDING = false
        rebuildState.active = false
        rebuildState.name = "-"
        rebuildState.level = 0
    end
end)

-- =====================
-- DETECT DELETE
-- =====================
local function process()
    local now = snapshot()


    for k,old in pairs(lastSnapshot) do
        if isIgnored(old.pos) then continue end
        if not now[k] and not debounce[k] then
            debounce[k] = true

            task.delay(1,function()
                if STOP_ALL then return end
                rebuild(old)
                debounce[k] = nil
            end)
            end
        end
    lastSnapshot = now
end

RunService.Heartbeat:Connect(process)
task.wait(1)
lastSnapshot = snapshot()

-- =====================
-- SAFE WAIT
-- =====================

local function markUpgrade(cf)
    local pos = cf.Position

    table.insert(ignore, pos)

    task.delay(0.5, function()
        for i,v in ipairs(ignore) do
            if (v - pos).Magnitude < 0.1 then
                table.remove(ignore, i)
                break
            end
        end
    end)
end

-- =====================
-- BUILD FLOW (GIỮ NGUYÊN)
-- =====================
-- (PHẦN NÀY GIỮ NGUYÊN 100% CODE EM)
-- =====================
-- HELPER
-- =====================
local function getTowerAt(cf, class)
    for _,t in ipairs(Towers:GetChildren()) do
        local c = t:FindFirstChild("Class")
        if c and c.Value == class then
            if (t:GetPivot().Position - cf.Position).Magnitude < 2 then
                return t
            end
        end
    end
end

local function fixTower(tower, cf, class)
    if not tower or not tower.Parent then
        tower = getTowerAt(cf, class)
    end
    return tower
end

task.spawn(function()
    while true do
        if rebuildState.active then
            rebuildLabel.Text = "Rebuild: True (" ..
                rebuildState.name .. " | Lv" .. rebuildState.level .. ")"
        else
            rebuildLabel.Text = "Rebuild: False"
        end

        task.wait(0.1)
    end
end)



-- =====================
-- SAFE FIX HELPERS
-- =====================
local function safeFix(tower, cf, class)
    if not tower or not tower.Parent then
        tower = fixTower(nil, cf, class)
    end
    return tower
end
-- =====================
-- SAFE FIX HELPERS
-- =====================


-- =====================
-- AUTO SPAWN WRAPPER (fiX MARK)
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

        -- ❌ chưa đủ tiền thì đứng yên
        if gold.Value < cost then
            task.wait(0.1)
            continue
        end

        -- 🔒 LOCK STEP trước khi spawn
        BUILD_LOCK = true
        ACTIVE_STEP = name

        local beforeGold = gold.Value

        -- 👉 spawn
        local result = RS.Functions.SpawnTower:InvokeServer(unpack(args))

        -- 🔥 chờ server update gold
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

        -- ❗ nếu không trừ tiền → fail spawn
        if afterGold >= beforeGold then
            BUILD_LOCK = false
            ACTIVE_STEP = nil
            task.wait(0.2)
            continue
        end

        -- =========================
        -- TRY RETURN TOWER
        -- =========================

        -- case 1: server trả luôn model
        if result and result.Parent then
            task.wait(0.1)
            BUILD_LOCK = false
            ACTIVE_STEP = nil
            return result
        end

        -- case 2: phải search lại tower
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

        -- =========================
        -- DONE
        -- =========================
        BUILD_LOCK = false
        ACTIVE_STEP = nil

        return found
    end
end

-- =====================
-- GLOBAL LOCK FIX
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
-- SAFE WRAPPER
-- =====================
local function safeAction(name, fn)
    local ok, res = pcall(fn)
    if not ok then
        warn("❌ step fail:", name)
        STEP_LOCK = nil
        return nil
    end
    return res
end

-- =====================
-- SAFE UPGRADE
-- =====================
local function safeUpgrade(name, tower, class)
    while true do
        if bossDead or STOP_ALL then return nil end
        if not tower or not tower.Parent then return nil end

        waitGold(name, true, tower)

        local new = safeUpgrade(name, tower, class)

        if new then
            tower = new
            task.wait(0.15) -- 🔥 chống double trigger
        end

        task.wait(0.2)
    end
end
-- =====================
-- BUILD FLOW
-- =====================

-- 1. EXPLORER
local explorerPos = {
    CFrame.new(-221.7653,7.8147,-81.3051),
    CFrame.new(-221.9095,7.8147,-78.5632),
    CFrame.new(-225.7108,7.8147,-78.7834),
    CFrame.new(-225.7969,7.8147,-81.4535),
}

for _,cf in ipairs(explorerPos) do
    safeWait()
    startStep("Explorer")

    if not stepBlocked("Explorer") then
        waitGold("Desert Explorer", false)
        spawnTowerSafe({"Desert Explorer", cf, nil, "Explorer", "Desert Explorer"})
    end

    endStep()
    task.wait(0.2)
end

-- 2. GUARDIAN
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
    safeWait()
    startStep("Guardian")

    if not stepBlocked("Guardian") then
        waitGold("Guardian", false)

        local g = spawnTowerSafe({"Guardian", cf, nil, "Guardian"})
        guardians[i] = safeFix(g, cf, "Guardian")
    end

    endStep()
end

-- 3. SNIPER (LV2)
local snipers = {}
local sniperPos = {
    CFrame.new(-217.88,7.81,-85.06),
    CFrame.new(-218.08,7.81,-87.63),
    CFrame.new(-215.31,7.81,-85.09),
    CFrame.new(-215.53,7.81,-87.81),
    CFrame.new(-212.78,7.81,-85.09),
    CFrame.new(-212.82,7.81,-87.65),
}

for i,cf in ipairs(sniperPos) do
    safeWait()
    startStep("Sniper")

    if not stepBlocked("Sniper") then
        waitGold("Laser Sniper", false)

        local s = spawnTowerSafe({"Laser Sniper", cf, nil, "Laser Sniper"})
        s = safeFix(s, cf, "Laser Sniper")

        if s then
            s = safeUpgrade("Pro Sniper", s, "Laser Sniper")
        end

        snipers[i] = s
    end

    endStep()
end

-- 4. WIZARD
local function fullWizard(cf)
    safeWait()
    startStep("Wizard")

    if stepBlocked("Wizard") then endStep() return end

    waitGold("Galaxy Wizard", false)

    local w = spawnTowerSafe({"Galaxy Wizard", cf, nil, "Wizard", "Galaxy Wizard"})
    w = safeFix(w, cf, "Wizard")

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

-- 5. GUARDIAN UPGRADE
for i,g in ipairs(guardians) do
    safeWait()
    startStep("GuardianUpgrade")

    g = safeFix(g, guardianPos[i], "Guardian")

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

-- 6. MACHINIST
safeWait()
startStep("Machinist")

if not stepBlocked("Machinist") then
    waitGold("Machinist", false)

    local mPos = CFrame.new(-219.16,7.81,-81.14)
    local m = spawnTowerSafe({"Machinist", mPos, nil, "Machinist"})
    m = safeFix(m, mPos, "Machinist")

    if m then
        for _,name in ipairs({"Faster Working","Second Machine","True Machinist","Futurist"}) do
            local new = safeUpgrade(name, m, "Machinist")
            if not new then break end
            m = new
        end
    end
end

endStep()

-- 7. SNIPER FINAL
for i,s in ipairs(snipers) do
    safeWait()
    startStep("SniperFinal")

    s = safeFix(s, sniperPos[i], "Laser Sniper")

    if s and not stepBlocked("SniperFinal") then
        for _,name in ipairs({"Glowing Hat","More Grip","Heavy Clothes","Frosted Lasers"}) do
            local new = safeUpgrade(name, s, "Laser Sniper")
            if not new then break end
            s = new
        end
        snipers[i] = s
    end

    endStep()
end

-- 8. GUARDIAN FINAL
for i,g in ipairs(guardians) do
    safeWait()
    startStep("GuardianFinal")

    g = safeFix(g, guardianPos[i], "Guardian")

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

-- 9. DRONE
local dronePos = {
    CFrame.new(-218.5349,8.0547,-72.9919)*CFrame.Angles(0,-1.5558,0),
    CFrame.new(-215.6939,8.0547,-72.9911)*CFrame.Angles(0,-1.5558,0),
    CFrame.new(-213.5199,7.0576,-76.5772)*CFrame.Angles(0,-1.4760,0),
    CFrame.new(-213.5248,12.0576,-76.6233)*CFrame.Angles(0,-1.4528,0),
    CFrame.new(-218.8291,8.0547,-78.2545)*CFrame.Angles(0,-0.0342,0)
}

local drones = {}

for i,cf in ipairs(dronePos) do
    safeWait()
    startStep("Drone")

    waitGold("Helicopter Kid", false)

    local d = spawnTowerSafe({"Helicopter Kid", cf, nil, "Drone Pilot","Helicopter Kid"})
    drones[i] = safeFix(d, cf, "Drone Pilot")

    endStep()
end

-- DRONE UPGRADE
for i,d in ipairs(drones) do
    safeWait()
    startStep("DroneUpgrade")

    d = safeFix(d, dronePos[i], "Drone Pilot")

    if d then
        for _,name in ipairs({"Stable Flying","Bombs","Toxic Bombs","Death Heli"}) do
            local new = safeUpgrade(name, d, "Drone Pilot")
            if not new then break end
            d = new
        end
        drones[i] = d
    end

    endStep()
end
