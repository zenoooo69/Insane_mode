-- =====================
-- SERVICES
-- =====================
task.wait(0.5)
local GameStarted  = false
local GameRunning  = true
local bossDead     = false
local machinistMaxed = false

local RS        = game:GetService("ReplicatedStorage")
local player    = game.Players.LocalPlayer
local gold      = player:WaitForChild("leaderstats"):WaitForChild("Gold")
local RunService = game:GetService("RunService")
local Towers    = workspace:WaitForChild("Towers")

local STOP_ALL  = false

-- =====================
-- SPAWN MUTEX
-- FIX 4: chỉ 1 InvokeServer tại 1 thời điểm, dùng chung cho cả main + rebuild
-- =====================
local spawnMutex = false

local function acquireSpawn()
    while spawnMutex do task.wait(0.05) end
    spawnMutex = true
end

local function releaseSpawn()
    spawnMutex = false
end

-- =====================
-- AUTO CHARM
-- =====================
local AUTO_CHARM = true
local COOLDOWN   = 99
local lastUse    = 0

task.spawn(function()
    while true do
        task.wait(1)
        if not AUTO_CHARM then continue end
        if bossDead then continue end
        if tick() - lastUse >= COOLDOWN then
            local ok = pcall(function()
                RS.Events.UseCharm:FireServer(3)
            end)
            if ok then
                lastUse = tick()
                print("✅ Charm used")
            end
        end
    end
end)

-- =====================
-- GUI
-- =====================
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name          = "AutoFarmUI"
screenGui.ResetOnSpawn  = false
screenGui.Parent        = playerGui

local frame = Instance.new("Frame")
frame.Size              = UDim2.new(0, 200, 0, 130)
frame.Position          = UDim2.new(0, 10, 0.5, -65)
frame.BackgroundColor3  = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel   = 0
frame.Active            = true
frame.Draggable         = true
frame.Parent            = screenGui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

local function makeLabel(yPos, color, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size                = UDim2.new(1, 0, 0, 20)
    lbl.Position            = UDim2.new(0, 0, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3          = color
    lbl.Text                = text or ""
    lbl.TextScaled          = true
    lbl.Font                = Enum.Font.Gotham
    lbl.Parent              = frame
    return lbl
end

local titleLabel   = makeLabel(0,   Color3.fromRGB(255,255,255), "Auto Farm - GeoCage")
local goldLabel    = makeLabel(20,  Color3.fromRGB(255,255,0),   "Gold: 0")
local needLabel    = makeLabel(40,  Color3.fromRGB(255,100,100), "Need: 0")
local costLabel    = makeLabel(60,  Color3.fromRGB(100,255,100), "Cost: 0")
local nextLabel    = makeLabel(80,  Color3.fromRGB(150,150,255), "Next: -")
local rebuildLabel = makeLabel(100, Color3.fromRGB(255,150,150), "Rebuild: -")
titleLabel.Font = Enum.Font.GothamBold

-- =====================
-- REBUILD STATE
-- FIX 1: tách REBUILDING thành rebuildingNow, safeWait chỉ chờ khi rebuild
--        đang ở bước UPGRADE (có thể conflict), không block khi rebuild chờ gold
-- =====================
local rebuildQueue     = {}
local rebuildingNow    = false   -- true chỉ khi rebuild đang invoke server
local rebuildState     = { active = false, name = "-", level = 0 }

-- build flow chờ rebuild xong invoke hiện tại trước khi tự invoke
local function safeWait()
    while rebuildingNow do task.wait(0.02) end
end

-- =====================
-- VOTE MAP
-- =====================
RS.Events.VoteForMap:FireServer("INSANE GeoCage")
task.wait(1)
RS.Events.VoteForMap:FireServer("Ready")

-- =====================
-- WAVE WATCHER
-- =====================
task.spawn(function()
    local wave = workspace:WaitForChild("Info"):WaitForChild("Wave")
    while true do
        task.wait(0.2)
        if STOP_ALL or bossDead then break end
        if wave.Value >= 21 then
            STOP_ALL    = true
            bossDead    = true
            GameRunning = false
            rebuildQueue = {}
            print("🛑 Wave 21 → Force lose")
            for i = 1, 3 do
                for _, t in ipairs(workspace.Towers:GetChildren()) do
                    pcall(function() RS.Functions.SellTower:InvokeServer(t) end)
                end
                task.wait(0.2)
            end
            break
        end
    end
end)

-- =====================
-- GAME RUNNING WATCHER
-- =====================
task.spawn(function()
    local gameRunning = workspace:WaitForChild("Info"):WaitForChild("GameRunning")
    task.wait(15)
    GameStarted = true
    while true do
        task.wait(0.5)
        if GameStarted and not gameRunning.Value then
            GameRunning = false
            bossDead    = true
            break
        end
    end
end)

-- =====================
-- RESULT CHECK
-- =====================
task.spawn(function()
    local info     = workspace:WaitForChild("Info")
    local messages = info:WaitForChild("Message")
    local wave     = info:FindFirstChild("Wave")
    local detected = false

    local function check(text)
        text = string.lower(text)
        if string.find(text, "victory")                              then return "WIN"  end
        if string.find(text, "game over") or string.find(text, "defeat") then return "LOSE" end
    end

    messages:GetPropertyChangedSignal("Value"):Connect(function()
        if detected then return end
        local result = check(messages.Value)
        if not result then return end
        detected    = true
        bossDead    = true
        GameRunning = false
        local wv = wave and wave.Value or 0
        print(result == "WIN" and "🏆 VICTORY" or "❌ DEFEAT",
              "| Wave:", wv, "| Gold:", gold.Value)
        task.wait(1)
        pcall(function() RS.Events.ExitGame:FireServer() end)
    end)
end)

-- =====================
-- COST SYSTEM
-- =====================
local effects      = workspace.Info.TowerEffects
local placeMulti   = effects.PlacingTowerMultiplier
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
    ["Galaxy Wizard"]          = 3500,
    ["Galaxy Potions"]         = 2000,
    ["Galaxy Spells"]          = 4400,
    ["Enhanced Galaxy Spells"] = 7800,
    ["Galactic Staff"]         = 41650,
}

local function getCost(name, isUpgrade, towerInstance)
    local base = CUSTOM_COST[name] or BASE_COST[name] or 0
    local cost = base * (isUpgrade and upgradeMulti.Value or placeMulti.Value)
    if towerInstance and towerInstance:FindFirstChild("Config") then
        local cheaper = towerInstance.Config:FindFirstChild("CheaperUpgrades")
        if cheaper then cost = cost * cheaper.Value end
    end
    return math.floor(cost + 1)
end

-- =====================
-- UPGRADE CHAINS
-- =====================
local UPGRADE_CHAIN = {
    ["Guardian"]     = {"Deserted Armor","Snowy Helmet","Lava Knight","Electrifying Sword","Guardian Angel"},
    ["Laser Sniper"] = {"Pro Sniper","Glowing Hat","More Grip","Heavy Clothes","Frosted Lasers"},
    ["Wizard"]       = {"Galaxy Potions","Galaxy Spells","Enhanced Galaxy Spells","Galactic Staff"},
    ["Machinist"]    = {"Faster Working","Second Machine","True Machinist","Futurist"},
    ["Drone Pilot"]  = {"Stable Flying","Bombs","Toxic Bombs","Death Heli"},
}

-- =====================
-- WAIT GOLD
-- =====================
local currentTarget = {}

local function waitGold(name, isUpgrade, towerInstance)
    currentTarget.name      = name
    currentTarget.isUpgrade = isUpgrade
    while true do
        if bossDead or STOP_ALL then return false end
        if gold.Value >= getCost(name, isUpgrade, towerInstance) then return true end
        task.wait(0.1)
    end
end

-- rebuild version: sama tapi pakai flag bossDead saja
local function waitGoldR(name, isUpgrade, towerInstance)
    while true do
        if bossDead or STOP_ALL then return false end
        if gold.Value >= getCost(name, isUpgrade, towerInstance) then return true end
        task.wait(0.1)
    end
end

-- GUI updater
task.spawn(function()
    while true do
        task.wait(0.2)
        goldLabel.Text = "Gold: " .. gold.Value
        local t = currentTarget.name
        if t then
            local cost = getCost(t, currentTarget.isUpgrade, nil)
            costLabel.Text = "Cost: " .. cost
            needLabel.Text = "Need: " .. math.max(0, cost - gold.Value)
            nextLabel.Text = "Next: " .. t
        else
            costLabel.Text = "Cost: 0"
            needLabel.Text = "Need: 0"
            nextLabel.Text = "Next: -"
        end
    end
end)

-- =====================
-- CORE INVOKE
-- FIX 4: single invoke point, dùng mutex
-- =====================
local function invokeSpawn(args)
    if bossDead or STOP_ALL then return nil end
    acquireSpawn()
    local ok, result = pcall(function()
        return RS.Functions.SpawnTower:InvokeServer(unpack(args))
    end)
    releaseSpawn()
    if not ok then
        warn("invokeSpawn error:", result)
        return nil
    end
    return result
end

-- =====================
-- TOWER SEARCH BY POSITION
-- =====================
local function findTowerNear(cf, class, radius)
    radius = radius or 3
    local best, bestDist = nil, math.huge
    for _, t in ipairs(Towers:GetChildren()) do
        local c = t:FindFirstChild("Class")
        if c and c.Value == class then
            local d = (t:GetPivot().Position - cf.Position).Magnitude
            if d < radius and d < bestDist then
                best     = t
                bestDist = d
            end
        end
    end
    return best
end

-- =====================
-- SPAWN TOWER SAFE (main build flow)
-- =====================
local function spawnTowerSafe(args)
    if STOP_ALL or bossDead then return nil end

    local name      = args[1]
    local cf        = args[2]   -- CFrame target position
    local old       = args[3]   -- tower instance nếu là upgrade
    local class     = args[4]
    local isUpgrade = (old ~= nil)

    local startTime = os.clock()

    while true do
        if bossDead or STOP_ALL then return nil end
        if os.clock() - startTime > 12 then
            warn("⏱ Timeout spawnTowerSafe:", name)
            return nil
        end

        if gold.Value < getCost(name, isUpgrade, old) then
            task.wait(0.1)
            continue
        end

        -- FIX 2+3: lưu pivot TRƯỚC khi invoke (tránh dùng sau khi tower destroy)
        local searchCF = isUpgrade and old:GetPivot() or cf
        if isUpgrade and (not old or not old.Parent) then
            warn("⚠ spawnTowerSafe: old tower gone before invoke:", name)
            return nil
        end

        local beforeGold = gold.Value

        -- ghi đè args[2] = searchCF nếu upgrade (dùng pivot lúc invoke, không phải sau)
        if isUpgrade then
            args[2] = searchCF
        end

        local result = invokeSpawn(args)

        -- chờ gold bị trừ để confirm server nhận
        local waited = 0
        while waited < 0.6 do
            task.wait(0.05)
            waited += 0.05
            if gold.Value < beforeGold then break end
        end

        if gold.Value >= beforeGold then
            -- server reject, thử lại
            task.wait(0.2)
            continue
        end

        -- case 1: server trả về model trực tiếp
        if result and result.Parent then
            task.wait(0.05)
            return result
        end

        -- case 2: search workspace bằng position đã lưu
        -- FIX 2: dùng searchCF (pivot tại thời điểm invoke), không dùng sau
        local found
        for _ = 1, 15 do
            found = findTowerNear(searchCF, class, 3.5)
            if found then break end
            task.wait(0.1)
        end

        return found  -- có thể nil nếu không tìm thấy
    end
end

-- =====================
-- SAFE UPGRADE (main build flow)
-- =====================
local function safeUpgrade(name, tower, class)
    if bossDead or STOP_ALL then return nil end
    if not tower or not tower.Parent then return nil end

    if not waitGold(name, true, tower) then return nil end
    if not tower or not tower.Parent   then return nil end  -- re-check sau khi chờ

    local new = spawnTowerSafe({name, tower:GetPivot(), tower, class})
    if new then task.wait(0.1) end
    return new
end

-- =====================
-- STEP LOCK
-- =====================
local STEP_LOCK    = nil
local STEP_TIMEOUT = 10
local stepStart    = 0

local function startStep(name) STEP_LOCK = name; stepStart = os.clock() end
local function endStep()       STEP_LOCK = nil end
local function stepBlocked(name)
    if STEP_LOCK and STEP_LOCK ~= name then return true end
    if STEP_LOCK and os.clock() - stepStart > STEP_TIMEOUT then STEP_LOCK = nil end
    return false
end

local function safeFix(tower, cf, class)
    if not tower or not tower.Parent then
        return findTowerNear(cf, class, 2.5)
    end
    return tower
end

-- =====================
-- SNAPSHOT
-- =====================
local function readTower(t)
    local c = t:FindFirstChild("Class")
    local s = t:FindFirstChild("Skin")
    if not c or not s then return nil end
    local lv = t:FindFirstChild("Level")
    return {
        class = c.Value,
        skin  = s.Value,
        level = lv and lv.Value or 1,
        pos   = t:GetPivot().Position,
        cf    = t:GetPivot(),
    }
end

local function posKey(pos)
    return math.floor(pos.X*10).."_"..math.floor(pos.Y*10).."_"..math.floor(pos.Z*10)
end

local function snapshot()
    local snap = {}
    for _, t in ipairs(Towers:GetChildren()) do
        local d = readTower(t)
        if d then snap[posKey(d.pos)] = d end
    end
    return snap
end

local lastSnapshot = snapshot()
local debounce     = {}

-- =====================
-- REBUILD: spawn base
-- =====================
local function rebuildSpawnBase(data)
    if bossDead or STOP_ALL then return nil end

    local name = (data.skin ~= "Default") and data.skin or data.class
    if not waitGoldR(name, false) then return nil end
    if bossDead or STOP_ALL then return nil end

    local args
    if data.skin == "Default" then
        args = {data.class, data.cf, nil, data.class}
    else
        args = {data.skin, data.cf, nil, data.class, data.skin}
    end

    local beforeGold = gold.Value
    local result     = invokeSpawn(args)

    local waited = 0
    while waited < 0.6 do
        task.wait(0.05)
        waited += 0.05
        if gold.Value < beforeGold then break end
    end

    if gold.Value >= beforeGold then
        warn("🔁 rebuildSpawnBase: server reject, skip")
        return nil
    end

    if result and result.Parent then return result end

    -- search
    local found
    for _ = 1, 15 do
        found = findTowerNear(data.cf, data.class, 3.5)
        if found then break end
        task.wait(0.1)
    end
    return found
end

-- =====================
-- REBUILD: upgrade 1 level
-- FIX 3: snapshot pivot TRƯỚC invoke, không dùng tower object sau khi server process
-- =====================
local function rebuildUpgradeOne(tower, upgradeName, class)
    if bossDead or STOP_ALL then return nil end
    if not tower or not tower.Parent then return nil end

    if not waitGoldR(upgradeName, true, tower) then return nil end

    -- re-check tower còn tồn tại sau khi chờ gold
    if not tower or not tower.Parent then
        warn("⚠ rebuildUpgradeOne: tower gone after waitGold:", upgradeName)
        return nil
    end

    -- FIX 3: lưu pivot ngay tại đây, trước invoke
    local pivotNow = tower:GetPivot()

    local beforeGold = gold.Value
    local result = invokeSpawn({upgradeName, pivotNow, tower, class})

    local waited = 0
    while waited < 0.6 do
        task.wait(0.05)
        waited += 0.05
        if gold.Value < beforeGold then break end
    end

    if gold.Value >= beforeGold then
        warn("🔁 rebuildUpgradeOne: server reject:", upgradeName)
        return nil
    end

    if result and result.Parent then return result end

    -- FIX 2: search bằng pivotNow đã lưu
    local found
    for _ = 1, 15 do
        found = findTowerNear(pivotNow, class, 3.5)
        if found then break end
        task.wait(0.1)
    end
    return found
end

-- =====================
-- REBUILD QUEUE
-- =====================
local function queueRebuild(data)
    if STOP_ALL then return end
    -- chống duplicate
    for _, v in ipairs(rebuildQueue) do
        if (v.pos - data.pos).Magnitude < 1 then return end
    end
    table.insert(rebuildQueue, data)
end

-- =====================
-- REBUILD WORKER
-- FIX 1: rebuildingNow = true chỉ bao quanh từng invoke, không bao cả waitGold
--        → build flow safeWait() sẽ không bị block khi rebuild chờ tiền
-- =====================
task.spawn(function()
    while true do
        task.wait(0.05)

        if STOP_ALL then
            rebuildQueue  = {}
            rebuildingNow = false
            rebuildState.active = false
            continue
        end

        if #rebuildQueue == 0 then continue end

        local data = table.remove(rebuildQueue, 1)
        if not data then continue end

        rebuildState.active = true
        rebuildState.name   = data.class
        rebuildState.level  = data.level

        -- === SPAWN BASE ===
        local tower
        for attempt = 1, 3 do
            if bossDead or STOP_ALL then break end

            rebuildingNow = true          -- lock chỉ khi invoke
            tower = rebuildSpawnBase(data)
            rebuildingNow = false         -- unlock ngay sau invoke

            if tower then break end

            if attempt < 3 then
                task.wait(0.5)
            end
        end

        if not tower or bossDead or STOP_ALL then
            rebuildState.active = false
            continue
        end

        -- === UPGRADE LOOP ===
        local chain = UPGRADE_CHAIN[data.class]
        if chain then
            for lv = 2, data.level do
                if bossDead or STOP_ALL then break end
                if not tower or not tower.Parent then
                    warn("🔧 Rebuild: tower lost at lv", lv, "class:", data.class)
                    break
                end

                local upgradeName = chain[lv - 1]
                if not upgradeName then break end

                -- retry upgrade tối đa 3 lần nếu server reject
                local success = false
                for attempt = 1, 3 do
                    if bossDead or STOP_ALL then break end
                    if not tower or not tower.Parent then break end

                    rebuildingNow = true           -- lock chỉ khi invoke
                    local new = rebuildUpgradeOne(tower, upgradeName, data.class)
                    rebuildingNow = false          -- unlock ngay sau invoke

                    if new then
                        tower   = new
                        success = true
                        task.wait(0.1)
                        break
                    end

                    if attempt < 3 then
                        task.wait(0.4)
                    end
                end

                if not success then
                    warn("⚠ Rebuild: upgrade fail lv", lv, upgradeName, "→ stop at current level")
                    break
                end
            end
        end

        rebuildState.active = false
        rebuildState.name   = "-"
        rebuildState.level  = 0




-- ================================================================
-- BUILD FLOW
-- ================================================================

-- 1. EXPLORER
local explorerPos = {
    CFrame.new(-221.7653, 7.8147, -81.3051),
    CFrame.new(-221.9095, 7.8147, -78.5632),
    CFrame.new(-225.7108, 7.8147, -78.7834),
    CFrame.new(-225.7969, 7.8147, -81.4535),
}

for _, cf in ipairs(explorerPos) do
    if STOP_ALL or bossDead then break end
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
local guardians   = {}
local guardianPos = {
    CFrame.new(-225.6411, 7.8147, -84.9286),
    CFrame.new(-223.0359, 7.8147, -85.0404),
    CFrame.new(-220.5131, 7.8147, -85.0323),
    CFrame.new(-220.7988, 7.8147, -87.6007),
    CFrame.new(-223.5070, 7.8147, -87.6033),
    CFrame.new(-226.1602, 7.8147, -87.5709),
}

for i, cf in ipairs(guardianPos) do
    if STOP_ALL or bossDead then break end
    safeWait()
    startStep("Guardian")
    if not stepBlocked("Guardian") then
        waitGold("Guardian", false)
        local g = spawnTowerSafe({"Guardian", cf, nil, "Guardian"})
        guardians[i] = safeFix(g, cf, "Guardian")
    end
    endStep()
end

-- 3. SNIPER lv2
local snipers   = {}
local sniperPos = {
    CFrame.new(-217.88, 7.81, -85.06),
    CFrame.new(-218.08, 7.81, -87.63),
    CFrame.new(-215.31, 7.81, -85.09),
    CFrame.new(-215.53, 7.81, -87.81),
    CFrame.new(-212.78, 7.81, -85.09),
    CFrame.new(-212.82, 7.81, -87.65),
}

for i, cf in ipairs(sniperPos) do
    if STOP_ALL or bossDead then break end
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

-- 4. WIZARD lv5 (x2)
local wizardChain = {"Galaxy Potions","Galaxy Spells","Enhanced Galaxy Spells","Galactic Staff"}

local function buildWizard(cf)
    if STOP_ALL or bossDead then return end
    safeWait()
    startStep("Wizard")
    if stepBlocked("Wizard") then endStep() return end

    waitGold("Galaxy Wizard", false)
    local w = spawnTowerSafe({"Galaxy Wizard", cf, nil, "Wizard", "Galaxy Wizard"})
    w = safeFix(w, cf, "Wizard")
    if not w then endStep() return end

    for _, name in ipairs(wizardChain) do
        if STOP_ALL or bossDead then break end
        local new = safeUpgrade(name, w, "Wizard")
        if not new then break end
        w = new
    end
    endStep()
end

buildWizard(CFrame.new(-213.17, 8.08, -80.96))
buildWizard(CFrame.new(-209.98, 8.05, -80.41))

-- 5. GUARDIAN UPGRADE lv3
for i, g in ipairs(guardians) do
    if STOP_ALL or bossDead then break end
    safeWait()
    startStep("GuardianUpgrade")
    g = safeFix(g, guardianPos[i], "Guardian")
    if g and not stepBlocked("GuardianUpgrade") then
        for _, name in ipairs({"Deserted Armor","Snowy Helmet","Lava Knight"}) do
            if STOP_ALL or bossDead then break end
            local new = safeUpgrade(name, g, "Guardian")
            if not new then break end
            g = new
        end
        guardians[i] = g
    end
    endStep()
end

-- 6. MACHINIST lv5
do
    if not (STOP_ALL or bossDead) then
        safeWait()
        startStep("Machinist")
        if not stepBlocked("Machinist") then
            waitGold("Machinist", false)
            local mPos = CFrame.new(-219.16, 7.81, -81.14)
            local m = spawnTowerSafe({"Machinist", mPos, nil, "Machinist"})
            m = safeFix(m, mPos, "Machinist")
            if m then
                for _, name in ipairs({"Faster Working","Second Machine","True Machinist","Futurist"}) do
                    if STOP_ALL or bossDead then break end
                    local new = safeUpgrade(name, m, "Machinist")
                    if not new then break end
                    m = new
                end
                machinistMaxed = true
            end
        end
        endStep()
    end
end

-- 7. SNIPER FINAL lv5
for i, s in ipairs(snipers) do
    if STOP_ALL or bossDead then break end
    safeWait()
    startStep("SniperFinal")
    s = safeFix(s, sniperPos[i], "Laser Sniper")
    if s and not stepBlocked("SniperFinal") then
        for _, name in ipairs({"Glowing Hat","More Grip","Heavy Clothes","Frosted Lasers"}) do
            if STOP_ALL or bossDead then break end
            local new = safeUpgrade(name, s, "Laser Sniper")
            if not new then break end
            s = new
        end
        snipers[i] = s
    end
    endStep()
end

-- 8. GUARDIAN FINAL lv5
for i, g in ipairs(guardians) do
    if STOP_ALL or bossDead then break end
    safeWait()
    startStep("GuardianFinal")
    g = safeFix(g, guardianPos[i], "Guardian")
    if g and not stepBlocked("GuardianFinal") then
        for _, name in ipairs({"Electrifying Sword","Guardian Angel"}) do
            if STOP_ALL or bossDead then break end
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
    CFrame.new(-218.5349, 8.0547, -72.9919) * CFrame.Angles(0, -1.5558, 0),
    CFrame.new(-215.6939, 8.0547, -72.9911) * CFrame.Angles(0, -1.5558, 0),
    CFrame.new(-213.5199, 7.0576, -76.5772) * CFrame.Angles(0, -1.4760, 0),
    CFrame.new(-213.5248, 12.0576,-76.6233) * CFrame.Angles(0, -1.4528, 0),
    CFrame.new(-218.8291, 8.0547, -78.2545) * CFrame.Angles(0, -0.0342, 0),
}

local drones = {}

for i, cf in ipairs(dronePos) do
    if STOP_ALL or bossDead then break end
    safeWait()
    startStep("Drone")
    waitGold("Helicopter Kid", false)
    local d = spawnTowerSafe({"Helicopter Kid", cf, nil, "Drone Pilot", "Helicopter Kid"})
    drones[i] = safeFix(d, cf, "Drone Pilot")
    endStep()
end

for i, d in ipairs(drones) do
    if STOP_ALL or bossDead then break end
    safeWait()
    startStep("DroneUpgrade")
    d = safeFix(d, dronePos[i], "Drone Pilot")
    if d then
        for _, name in ipairs({"Stable Flying","Bombs","Toxic Bombs","Death Heli"}) do
            if STOP_ALL or bossDead then break end
            local new = safeUpgrade(name, d, "Drone Pilot")
            if not new then break end
            d = new
        end
        drones[i] = d
    end
    endStep()
end

-- =====================
-- DONE
-- =====================
currentTarget.name = nil
nextLabel.Text     = "Next: Done! ✅"
print("✅ Build flow complete")

 
