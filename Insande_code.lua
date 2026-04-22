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
title.Text = "69 Insane 67"
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
        if bossDead then return false end

        -- 🔒 chặn nếu có step khác
        if BUILD_LOCK and ACTIVE_STEP ~= name then
            task.wait(0.1)
            continue
        end

        local cost = getCost(name, isUpgrade, towerInstance)

        if gold.Value >= cost then
            BUILD_LOCK = true
            ACTIVE_STEP = name

            task.wait(0.05)

            cost = getCost(name, isUpgrade, towerInstance)

            if gold.Value >= cost then
                return true
            else
                BUILD_LOCK = false
                ACTIVE_STEP = nil
            end
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

        -- rebuild = ignore
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
        local tower
        local tries = 0
        local maxTries = 3

        while tries < maxTries do
            tower = spawnBase(data)

            if tower then
                break
            end

            tries += 1
            task.wait(0.3)
        end

        
        if not tower then
            REBUILDING = false
            rebuildingNow = false
            rebuildState.active = false
            rebuildState.name = "-"
            rebuildState.level = 0
            continue
        end

        -- =====================
        -- UPGRADE LOOP
        -- =====================
        for lv = 2, data.level do
            if bossDead then break end
            if not tower or not tower.Parent then break end

            local upgraded = false

            while not upgraded do
                if bossDead then break end
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
        REBUILDING = false
        rebuildingNow = false
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
local function safeWait()
    while REBUILDING or rebuildingNow do task.wait() end
end

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
-- 1. EXPLORER (4)
-- =====================
local explorerPos = {
    CFrame.new(-221.7653,7.8147,-81.3051),
    CFrame.new(-221.9095,7.8147,-78.5632),
    CFrame.new(-225.7108,7.8147,-78.7834),
    CFrame.new(-225.7969,7.8147,-81.4535),
}
 
for _,cf in ipairs(explorerPos) do
    safeWait()
    waitGold("Desert Explorer",false)
    spawnTowerSafe({"Desert Explorer",cf,nil,"Explorer","Desert Explorer"})
    task.wait(0.2)
end
 
-- =====================
-- 2. GUARDIAN LV1 (6)
-- =====================
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
    waitGold("Guardian",false)
    guardians[i] = spawnTowerSafe({"Guardian",cf,nil,"Guardian"})
    task.wait(0.2)
end
 
-- =====================
-- 3. SNIPER LV2 (6)
-- =====================
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
    waitGold("Laser Sniper",false)
 
    local s = spawnTowerSafe({"Laser Sniper",cf,nil,"Laser Sniper"})
    task.wait(0.2)
 
    s = safeFix(s, cf, "Laser Sniper")
 
    if s then
        waitGold("Pro Sniper",true,s)
        snipers[i] = spawnTowerSafe({"Pro Sniper",s:GetPivot(),s,"Laser Sniper"})
    end
end
 
-- =====================
-- 4. WIZARD LV5 (2)
-- =====================
local function fullWizard(cf)
    safeWait()
    waitGold("Galaxy Wizard",false)
 
    local w = spawnTowerSafe({"Galaxy Wizard",cf,nil,"Wizard","Galaxy Wizard"})
    task.wait(0.2)
 
    w = safeFix(w, cf, "Wizard")
    if not w then return end
 
    waitGold("Galaxy Potions",true,w)
    w = spawnTowerSafe({"Galaxy Potions",w:GetPivot(),w,"Wizard"})
 
    waitGold("Galaxy Spells",true,w)
    w = spawnTowerSafe({"Galaxy Spells",w:GetPivot(),w,"Wizard"})
 
    waitGold("Enhanced Galaxy Spells",true,w)
    w = spawnTowerSafe({"Enhanced Galaxy Spells",w:GetPivot(),w,"Wizard"})
 
    waitGold("Galactic Staff",true,w)
    return spawnTowerSafe({"Galactic Staff",w:GetPivot(),w,"Wizard"})
end
 
fullWizard(CFrame.new(-213.17,8.08,-80.96))
fullWizard(CFrame.new(-209.98,8.05,-80.41))
 
-- =====================
-- 5. GUARDIAN UPGRADE
-- =====================
for i,g in ipairs(guardians) do
    safeWait()
    g = safeFix(g, guardianPos[i], "Guardian")
    if g then
        waitGold("Deserted Armor",true,g)
        guardians[i] = spawnTowerSafe({"Deserted Armor",g:GetPivot(),g,"Guardian"})
    end
end
 
for i,g in ipairs(guardians) do
    safeWait()
    g = safeFix(g, guardianPos[i], "Guardian")
    if g then
        waitGold("Snowy Helmet",true,g)
        g = spawnTowerSafe({"Snowy Helmet",g:GetPivot(),g,"Guardian"})
 
        waitGold("Lava Knight",true,g)
        guardians[i] = spawnTowerSafe({"Lava Knight",g:GetPivot(),g,"Guardian"})
    end
end
 
-- =====================
-- MACHINIST
-- =====================
safeWait()
waitGold("Machinist",false)
 
local mPos = CFrame.new(-219.16,7.81,-81.14)
 
local m = spawnTowerSafe({"Machinist",mPos,nil,"Machinist"})
task.wait(0.2)
 
m = safeFix(m, mPos, "Machinist")
 
if m then
    waitGold("Faster Working",true,m)
    m = spawnTowerSafe({"Faster Working",m:GetPivot(),m,"Machinist"})
 
    waitGold("Second Machine",true,m)
    m = spawnTowerSafe({"Second Machine",m:GetPivot(),m,"Machinist"})
 
    waitGold("True Machinist",true,m)
    m = spawnTowerSafe({"True Machinist",m:GetPivot(),m,"Machinist"})
 
    waitGold("Futurist",true,m)
    m = spawnTowerSafe({"Futurist",m:GetPivot(),m,"Machinist"})
end
 
-- =====================
-- SNIPER FINAL
-- =====================
for i,s in ipairs(snipers) do
    safeWait()
    s = safeFix(s, sniperPos[i], "Laser Sniper")
 
    if s then
        waitGold("Glowing Hat",true,s)
        s = spawnTowerSafe({"Glowing Hat",s:GetPivot(),s,"Laser Sniper"})
 
        waitGold("More Grip",true,s)
        s = spawnTowerSafe({"More Grip",s:GetPivot(),s,"Laser Sniper"})
 
        waitGold("Heavy Clothes",true,s)
        s = spawnTowerSafe({"Heavy Clothes",s:GetPivot(),s,"Laser Sniper"})
 
        waitGold("Frosted Lasers",true,s)
        snipers[i] = spawnTowerSafe({"Frosted Lasers",s:GetPivot(),s,"Laser Sniper"})
    end
end
 
-- =====================
-- GUARDIAN FINAL
-- =====================
for i,g in ipairs(guardians) do
    safeWait()
    g = safeFix(g, guardianPos[i], "Guardian")
 
    if g then
        waitGold("Electrifying Sword",true,g)
        g = spawnTowerSafe({"Electrifying Sword",g:GetPivot(),g,"Guardian"})
 
        waitGold("Guardian Angel",true,g)
        guardians[i] = spawnTowerSafe({"Guardian Angel",g:GetPivot(),g,"Guardian"})
    end
end
 
-- =====================
-- DRONE PILOT (5 → LV5)
-- =====================

local dronePos = {
    CFrame.new(-218.5349, 8.0547, -72.9919) * CFrame.Angles(0, -1.5558, 0),
    CFrame.new(-215.6939, 8.0547, -72.9911) * CFrame.Angles(0, -1.5558, 0),
    CFrame.new(-213.5199, 7.0576, -76.5772) * CFrame.Angles(0, -1.4760, 0),
    CFrame.new(-213.5248, 12.0576, -76.6233) * CFrame.Angles(0, -1.4528, 0),
    CFrame.new(-218.8291, 8.0547, -78.2545) * CFrame.Angles(0, -0.0342, 0)
}

local drones = {}

-- =====================
-- PLACE ALL (delay 0.5s)
-- =====================
for i,cf in ipairs(dronePos) do
    safeWait()
    waitGold("Helicopter Kid", false)

    local d = spawnTowerSafe({
        "Helicopter Kid",
        cf,
        nil,
        "Drone Pilot",
        "Helicopter Kid"
    })

    if d then
        drones[i] = d
    end

    task.wait(1) -- CHẮC CHẮN spacing
end

-- =====================
-- UPGRADE TO LV5
-- =====================
for i,d in ipairs(drones) do
    safeWait()
    d = safeFix(d, dronePos[i], "Drone Pilot")

    if d then
        waitGold("Stable Flying", true, d)
        d = spawnTowerSafe({"Stable Flying", d:GetPivot(), d, "Drone Pilot"})

        waitGold("Bombs", true, d)
        d = spawnTowerSafe({"Bombs", d:GetPivot(), d, "Drone Pilot"})

        waitGold("Toxic Bombs", true, d)
        d = spawnTowerSafe({"Toxic Bombs", d:GetPivot(), d, "Drone Pilot"})

        waitGold("Death Heli", true, d)
        drones[i] = spawnTowerSafe({"Death Heli", d:GetPivot(), d, "Drone Pilot"})
    end
end
