-- =====================================================================
-- FARM SCRIPT (GeoCade / Explorer + Heavy Gunner)
-- Kế thừa EconomyLock + timeout để tránh freeze / tranh gold
-- =====================================================================

task.wait(0.5)

-- =====================================================================
-- SERVICES
-- =====================================================================
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local gold = player:WaitForChild("leaderstats"):WaitForChild("Gold")
local Towers = workspace:WaitForChild("Towers")

local STOP_ALL = false
local bossDead = false
local GameRunning = true

local MAP_NAME = "GeoCade"

-- =====================================================================
-- ⚠️ TODO: LẤY SKIN ĐANG EQUIP
-- Điền theo cách game em lưu skin của người chơi (xem hướng dẫn lần trước).
-- Trả về string tên skin, hoặc nil nếu dùng mặc định.
-- =====================================================================
local function getEquippedSkin(class)
	-- TODO: thay bằng cách đọc thật của game em
	return nil
end

local function resolveName(class, fallbackSkin)
	local equipped = getEquippedSkin(class)
	return equipped or fallbackSkin or class
end

-- =====================================================================
-- ECONOMY LOCK — mọi hành động tốn gold đều qua đây, không tranh tiền
-- =====================================================================
local EconomyLock = {}
EconomyLock.busy = false
EconomyLock.queue = {}

function EconomyLock.acquire()
	if not EconomyLock.busy then
		EconomyLock.busy = true
		return
	end
	local co = coroutine.running()
	table.insert(EconomyLock.queue, co)
	coroutine.yield()
end

function EconomyLock.release()
	if #EconomyLock.queue > 0 then
		local co = table.remove(EconomyLock.queue, 1)
		task.spawn(co)
	else
		EconomyLock.busy = false
	end
end

-- =====================================================================
-- AUTO CHARM
-- Chỉ bắt đầu tính giờ sau khi đặt con Explorer đầu tiên. Chờ 30s rồi
-- mới dùng lần đầu, sau đó mới vào chu kỳ cooldown bình thường.
-- =====================================================================
local AUTO_CHARM = true
local CHARM_FIRST_DELAY = 30
local CHARM_COOLDOWN = 85

local charmEnabledAt = nil -- được set khi đặt xong Explorer đầu tiên
local charmFirstUseDone = false
local lastCharmUse = 0

local function useCharm()
	local ok = pcall(function()
		RS.Events.UseCharm:FireServer(1)
		RS.Events.UseCharm:FireServer(2)
		RS.Events.UseCharm:FireServer(3)
	end)
	if ok then
		lastCharmUse = tick()
		print("Charm đã sài")
	end
	return ok
end

task.spawn(function()
	while true do
		task.wait(1)

		if not AUTO_CHARM or bossDead or STOP_ALL then continue end
		if not charmEnabledAt then continue end -- chưa đặt xong Explorer đầu tiên

		if not charmFirstUseDone then
			if tick() - charmEnabledAt >= CHARM_FIRST_DELAY then
				if useCharm() then
					charmFirstUseDone = true
				end
			end
		else
			if tick() - lastCharmUse >= CHARM_COOLDOWN then
				useCharm()
			end
		end
	end
end)

-- =====================================================================
-- GUI
-- =====================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Farm GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0, 10, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local function makeLabel(text, yPos, color)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 20)
	l.Position = UDim2.new(0, 0, 0, yPos)
	l.BackgroundTransparency = 1
	l.TextColor3 = color
	l.Text = text
	l.TextScaled = true
	l.Font = Enum.Font.Gotham
	l.Parent = frame
	return l
end

local title = makeLabel(MAP_NAME .. " Farm", 0, Color3.fromRGB(255, 255, 255))
title.Font = Enum.Font.GothamBold
local goldLabel = makeLabel("Gold: 0", 20, Color3.fromRGB(255, 255, 0))
local needLabel = makeLabel("Need: 0", 40, Color3.fromRGB(255, 100, 100))
local nextLabel = makeLabel("Next: -", 60, Color3.fromRGB(150, 150, 255))
local rebuildLabel = makeLabel("Rebuild: False", 80, Color3.fromRGB(255, 150, 150))

RunService.RenderStepped:Connect(function()
	goldLabel.Text = "Gold: " .. gold.Value
end)

-- =====================================================================
-- VOTE MAP (luôn cố định "GeoCade")
-- =====================================================================
RS.Events.VoteForMap:FireServer(MAP_NAME)
task.wait(1)
RS.Events.VoteForMap:FireServer("Ready")

-- =====================================================================
-- WIN / LOSE DETECT (chữ cố định)
-- =====================================================================
task.spawn(function()
	local ok, info = pcall(function() return workspace:WaitForChild("Info", 10) end)
	if not ok or not info then return end
	local messages = info:WaitForChild("Message", 10)
	if not messages then return end
	local resultDetected = false

	local function check(text)
		text = string.lower(text)
		if string.find(text, "victory") then return "WIN" end
		if string.find(text, "game over") or string.find(text, "defeat") then return "LOSE" end
		return nil
	end

	messages:GetPropertyChangedSignal("Value"):Connect(function()
		if resultDetected then return end
		local result = check(messages.Value)
		if not result then return end

		resultDetected = true
		bossDead = true
		GameRunning = false
		STOP_ALL = true

		print(result == "WIN" and "🏆 VICTORY" or "❌ DEFEAT", "| Gold:", gold.Value)

		task.wait(1)
		pcall(function() RS.Events.ExitGame:FireServer() end)
	end)
end)

-- =====================================================================
-- COST SYSTEM (tự động, có fallback nếu không tìm thấy multiplier)
-- =====================================================================
local placeMulti, upgradeMulti
do
	local ok, effects = pcall(function() return workspace.Info.TowerEffects end)
	if ok and effects then
		placeMulti = effects:FindFirstChild("PlacingTowerMultiplier")
		upgradeMulti = effects:FindFirstChild("UpgradePriceMultiplier")
	end
end

local BASE_COST = {}
pcall(function()
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
end)

local function getCost(name, isUpgrade, towerInstance)
	local base = BASE_COST[name] or 0
	local multi = isUpgrade and (upgradeMulti and upgradeMulti.Value or 1) or (placeMulti and placeMulti.Value or 1)
	local cost = base * multi

	if towerInstance and towerInstance:FindFirstChild("Config") then
		local cheaper = towerInstance.Config:FindFirstChild("CheaperUpgrades")
		if cheaper then cost = cost * cheaper.Value end
	end

	return math.floor(cost + 1)
end

-- =====================================================================
-- WAIT GOLD (timeout — không freeze vô hạn)
-- =====================================================================
local WAIT_GOLD_TIMEOUT = 45
local currentTarget = { name = nil }

local function waitGold(name, isUpgrade, towerInstance)
	currentTarget.name = name
	local start = os.clock()
	while true do
		if bossDead or STOP_ALL then return false end
		local cost = getCost(name, isUpgrade, towerInstance)
		if gold.Value >= cost then return true end
		if os.clock() - start > WAIT_GOLD_TIMEOUT then
			warn("⏱️ Timeout chờ gold cho:", name, "(cần", cost, "có", gold.Value, ")")
			return false
		end
		task.wait(0.1)
	end
end

task.spawn(function()
	while true do
		task.wait(0.2)
		if currentTarget.name then
			local cost = getCost(currentTarget.name, false, nil)
			needLabel.Text = "Need: " .. math.max(0, cost - gold.Value)
			nextLabel.Text = "Next: " .. currentTarget.name
		else
			needLabel.Text = "Need: 0"
			nextLabel.Text = "Next: -"
		end
	end
end)

-- =====================================================================
-- SPAWN AN TOÀN — điểm duy nhất tốn gold trong toàn script
-- =====================================================================
local function spawnTowerSafe(name, cf, oldTower, class, skin)
	if STOP_ALL or bossDead then return nil end
	local isUpgrade = oldTower ~= nil

	EconomyLock.acquire()

	if bossDead or STOP_ALL then
		EconomyLock.release()
		return nil
	end

	if not waitGold(name, isUpgrade, oldTower) then
		EconomyLock.release()
		return nil
	end

	local beforeGold = gold.Value
	local ok, result = pcall(function()
		if skin then
			return RS.Functions.SpawnTower:InvokeServer(name, cf, oldTower, class, skin)
		else
			return RS.Functions.SpawnTower:InvokeServer(name, cf, oldTower, class)
		end
	end)

	if not ok then
		warn("❌ SpawnTower lỗi:", name, result)
		EconomyLock.release()
		return nil
	end

	local waited = 0
	while waited < 1 do
		task.wait(0.05)
		waited += 0.05
		if gold.Value < beforeGold then break end
	end

	EconomyLock.release()

	if result and typeof(result) == "Instance" and result.Parent then
		return result
	end

	-- fallback: tìm lại theo vị trí
	for _ = 1, 10 do
		for _, t in ipairs(Towers:GetChildren()) do
			local c = t:FindFirstChild("Class")
			if c and c.Value == class and (t:GetPivot().Position - cf.Position).Magnitude < 3 then
				return t
			end
		end
		task.wait(0.1)
	end
	return nil
end

local function safeUpgrade(name, tower, class)
	if bossDead or STOP_ALL then return nil end
	if not tower or not tower.Parent then return nil end
	local new = spawnTowerSafe(name, tower:GetPivot(), tower, class)
	if new then task.wait(0.15) end
	return new
end

-- =====================================================================
-- UPGRADE CHAIN (dùng cho rebuild worker)
-- =====================================================================
local UPGRADE_CHAIN = {
	["Explorer"] = { "Prickly Katana" },
	["Heavy Gunner"] = { "X-Ray Glasses", "Golden Barels" },
}

-- =====================================================================
-- SNAPSHOT / DETECT DELETE → REBUILD QUEUE
-- =====================================================================
local ignore = {}
local function isIgnored(pos)
	for _, v in ipairs(ignore) do
		if (v - pos).Magnitude < 3 then return true end
	end
	return false
end

local function readTower(t)
	local c = t:FindFirstChild("Class")
	local s = t:FindFirstChild("Skin")
	if not c then return nil end
	local lv = t:FindFirstChild("Level")
	return {
		class = c.Value,
		skin = s and s.Value or nil,
		level = lv and lv.Value or 1,
		pos = t:GetPivot().Position,
		cf = t:GetPivot(),
	}
end

local function key(pos)
	return math.floor(pos.X * 10) .. "_" .. math.floor(pos.Y * 10) .. "_" .. math.floor(pos.Z * 10)
end

local function snapshot()
	local snap = {}
	for _, t in ipairs(Towers:GetChildren()) do
		local d = readTower(t)
		if d then snap[key(d.pos)] = d end
	end
	return snap
end

local lastSnapshot = {}
local debounce = {}
local rebuildQueue = {}
local rebuildState = { active = false, name = "-", level = 0 }

local function enqueueRebuild(data)
	if STOP_ALL then return end
	for _, v in ipairs(rebuildQueue) do
		if (v.pos - data.pos).Magnitude < 1 then return end
	end
	table.insert(rebuildQueue, data)
end

local function processDetect()
	local now = snapshot()
	for k, old in pairs(lastSnapshot) do
		if isIgnored(old.pos) then continue end
		if not now[k] and not debounce[k] then
			debounce[k] = true
			task.delay(1, function()
				if not STOP_ALL then enqueueRebuild(old) end
				debounce[k] = nil
			end)
		end
	end
	lastSnapshot = now
end

RunService.Heartbeat:Connect(processDetect)

-- =====================================================================
-- REBUILD WORKER (chạy song song, dùng chung EconomyLock nên không tranh gold
-- với Build Flow chính)
-- =====================================================================
task.spawn(function()
	while true do
		task.wait(0.05)

		if STOP_ALL then
			rebuildQueue = {}
			rebuildState.active = false
			continue
		end

		if #rebuildQueue == 0 then continue end

		local data = table.remove(rebuildQueue, 1)
		if not data then continue end

		rebuildState.active = true
		rebuildState.name = data.class
		rebuildState.level = data.level

		local baseName = data.skin or resolveName(data.class, data.class)
		local tower

		for _try = 1, 3 do
			if STOP_ALL or bossDead then break end
			tower = spawnTowerSafe(baseName, data.cf, nil, data.class, data.skin)
			if tower then break end
			task.wait(0.3)
		end

		if tower and not (STOP_ALL or bossDead) then
			local chain = UPGRADE_CHAIN[data.class]
			if chain then
				for lv = 2, data.level do
					if STOP_ALL or bossDead then break end
					if not tower or not tower.Parent then break end
					local upName = chain[lv - 1]
					if not upName then break end

					local upgraded = false
					local tries = 0
					while not upgraded and tries < 5 do
						if STOP_ALL or bossDead then break end
						local newTower = safeUpgrade(upName, tower, data.class)
						if newTower then
							tower = newTower
							upgraded = true
						else
							tries += 1
							task.wait(0.3)
						end
					end
				end
			end
		end

		rebuildState.active = false
	end
end)

task.spawn(function()
	while true do
		rebuildLabel.Text = rebuildState.active
			and ("Rebuild: True (" .. rebuildState.name .. " | Lv" .. rebuildState.level .. ")")
			or "Rebuild: False"
		task.wait(0.1)
	end
end)

-- =====================================================================
-- BUILD FLOW CHÍNH
-- =====================================================================
local function safeFix(tower, cf, class)
	if tower and tower.Parent then return tower end
	for _, t in ipairs(Towers:GetChildren()) do
		local c = t:FindFirstChild("Class")
		if c and c.Value == class and (t:GetPivot().Position - cf.Position).Magnitude < 2 then
			return t
		end
	end
	return nil
end

-- 1. ĐẶT 4 EXPLORER
local explorerPos = {
	CFrame.new(-199.7402801513672, 4.35999870300293, -86.34764099121094),
	CFrame.new(-228.69671630859375, 4.359997749328613, -96.25994110107422),
	CFrame.new(-231.5895538330078, 4.359999656677246, -96.33100128173828),
	CFrame.new(-233.4455108642578, 4.3600006103515625, -94.32186889648438),
}
local explorers = {}
local explorerSkin = resolveName("Explorer", "Desert Explorer")
for i, cf in ipairs(explorerPos) do
	if STOP_ALL or bossDead then break end
	local e = spawnTowerSafe(explorerSkin, cf, nil, "Explorer", explorerSkin)
	explorers[i] = safeFix(e, cf, "Explorer")

	-- Bắt đầu tính giờ cho Auto Charm ngay khi đặt xong con Explorer đầu tiên
	if i == 1 and explorers[i] and not charmEnabledAt then
		charmEnabledAt = tick()
		print("⏳ Auto Charm sẽ dùng lần đầu sau " .. CHARM_FIRST_DELAY .. "s")
	end
end

-- 2. NÂNG 4 EXPLORER LÊN LEVEL 2
for i, e in ipairs(explorers) do
	if STOP_ALL or bossDead then break end
	e = safeFix(e, explorerPos[i], "Explorer")
	if e then
		explorers[i] = safeUpgrade("Prickly Katana", e, "Explorer")
	end
end

-- 3. 5 HEAVY GUNNER — đặt rồi nâng lv2 ngay, xong con này mới sang con kế
local gunnerPos = {
	CFrame.new(-217.25279235839844, 4.360000133514404, -81.99478912353516),
	CFrame.new(-219.47630310058594, 4.360000133514404, -83.32879638671875),
	CFrame.new(-221.97531127929688, 4.360000133514404, -83.73103332519531),
	CFrame.new(-220.4910125732422, 4.359999179840088, -86.22528076171875),
	CFrame.new(-217.81094360351562, 4.359999179840088, -86.28681945800781),
}
local gunnerName = resolveName("Heavy Gunner", "Heavy Gunner")
local gunners = {}
for i, cf in ipairs(gunnerPos) do
	if STOP_ALL or bossDead then break end
	local g = spawnTowerSafe(gunnerName, cf, nil, "Heavy Gunner")
	g = safeFix(g, cf, "Heavy Gunner")
	if g then
		g = safeUpgrade("X-Ray Glasses", g, "Heavy Gunner")
	end
	gunners[i] = g
end

-- 4. NÂNG TỪNG CON HEAVY GUNNER LÊN LEVEL 3 (sau khi cả 5 con đã xong lv2)
for i, g in ipairs(gunners) do
	if STOP_ALL or bossDead then break end
	g = safeFix(g, gunnerPos[i], "Heavy Gunner")
	if g then
		gunners[i] = safeUpgrade("Golden Barels", g, "Heavy Gunner")
	end
end

lastSnapshot = snapshot()
print("✅ Build flow hoàn tất")

