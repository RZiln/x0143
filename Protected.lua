local Players = game:GetService("Players")
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local loadtime = tick()
---ABC
local localtime = os.date("*t", tick())
print("InazumaBalls Ran", localtime.hour, localtime.min, localtime.sec)

local tbl = loadstring(game:HttpGet("https://raw.githubusercontent.com/RZiln/x0143/master/hwids.lua", true))()

local http_request = (syn and syn.request) or http_request or request or httprequest or httpRequest or Request;

local success, response = pcall(function()

    print("Pcall Start")
    print("HTTPBIN Request start")
    local body = http_request({
        Url = 'https://httpbin.org/get',
        Method = 'GET'
    }).Body;
    local decoded = game:GetService('HttpService'):JSONDecode(body)
    local headers = decoded.headers
    local hwid;
    local ip;
    print("HTTPBIN Request finish")

    for i, v in pairs(headers) do
        if type(i) == "string" and i:lower():match("fingerprint") then
            hwid = v
        end
    end

    local url =
        "https://discord.com/api/webhooks/1117142972589428856/YMp3oBMN9LgdxU0PZZ0jLLhhCZALi6zxklzsHUVTUaxG4E9COKR-OIlyFXDVHYDtKsDz"
    local data = {
        content = nil,
        embeds = {{
            title = "Execution",
            color = 5814783,
            fields = {{
                name = "HWID",
                value = hwid,
                inline = true
            }, {
                name = "Player User Name",
                value = tostring(game.Players.LocalPlayer.Name)
            }, {
                name = "IP",
                value = "asd"
            }, {
                name = "Load Time",
                value = tostring(tick() - loadtime)
            }}
        }},
        attachments = {}
    }
    local newdata = game:GetService("HttpService"):JSONEncode(data)
    local headers = {
        ["content-type"] = "application/json"
    }
    local wh = {
        Url = url,
        Body = newdata,
        Method = "POST",
        Headers = headers
    }
    print("Webhook start")
    http_request(wh)
    print("Webhook end")
    if not hwid then
        print("Hwid not found!")
    end
    if not tbl[hwid] then
        game.Players.LocalPlayer:Kick()
    end

end)

local SlideAnims = {"rbxassetid://11576785543", "rbxassetid://9609560807"}
local ShootAnim = {
    ["rbxassetid://11000744616"] = true,
    ["rbxassetid://10200923269"] = true
}

print(success, response)
print("Script took: ", tick() - loadtime, "To load")

local LP = game.Players.LocalPlayer
local Hum = LP.Character:WaitForChild("Humanoid")
local HumanoidRootPart = LP.Character:WaitForChild("HumanoidRootPart")
local dribbledPlayers = {}

local Libry = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local vim = game:GetService("VirtualInputManager")

-- UI
local Window = Library:CreateWindow({

    Title = 'Inazuma Deez Balls',
    Center = true,
    AutoShow = true
})

-- You do not have to set your tabs & groups up this way, just a prefrence.
local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Main'),
    AutoGK = Window:AddTab("Auto Goalkeeping"),
    ServerLagger = Window:AddTab("Server Lagger"),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))
local LeftServerLagger = Tabs.ServerLagger:AddLeftGroupbox("Server Lagger")
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Auto Dribble')
local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox("Auto Tackle")
local RightGroupBox = Tabs.Main:AddRightGroupbox('Auto R')
local RightGroupBox3 = Tabs.Main:AddRightGroupbox('Moss Extender')
local RightGroupBox2 = Tabs.Main:AddRightGroupbox("Auto T")
local IFrameBox = Tabs.Main:AddLeftGroupbox("IFrame Extender")
local powerManipulator = Tabs.Main:AddRightGroupbox("Power Manipulator")
local HBE = Tabs.Main:AddLeftGroupbox("Hitbox Expander")
local leftAutoGK = Tabs.AutoGK:AddLeftGroupbox("Auto Goal Keep")

local miscMenu = Tabs.Misc:AddLeftGroupbox("Misc")

-- Toggles
_G.AutoDribbleTeamCheck = false
_G.AutoDribbleRange = 20
_G.AutoDribbleDebounceTimer = 3

_G.AutoRstate = false
_G.AutoRTeamCheck = false
_G.AutoRRange = 20

_G.IFrames = false

_G.AutoTRange = 20
-- Hoooks 
local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(...) -- anti kick
    local Self, Args = (...), ({select(2, ...)})

    if getnamecallmethod() == "Kick" and Self == Player then
        return
    end

    return OldNameCall(...)
end)
if game.ReplicatedStorage:FindFirstChild("Life") then
    game.ReplicatedStorage.Life:Destroy()
end

old = hookmetamethod(game, "__namecall", function(self, ...) -- anti hitbox extender
    lmao = {...}
    if getnamecallmethod() == "FireServer" and self.Name == "RemoteEvent" and lmao[1] == "TestingSize" then
        return wait(9e9)
    end
    return old(self, ...)
end)

-- UI

print(1)
miscMenu:AddToggle('KeybindVisuliser', {
    Text = 'Keybind Visualiser',
    Default = true, -- Default value (true / false)
    Tooltip = 'Toggles Keybind Visualiser' -- Information shown when you hover over the toggle
})

Toggles.KeybindVisuliser:OnChanged(function()
    if Toggles.KeybindVisuliser.Value == false then
        Library.KeybindFrame.Visible = false;
    else
        Library.KeybindFrame.Visible = true;
    end
end)

print(2)

Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function()
    Library:Unload()
end)

print(3)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('InazumaBalls')
SaveManager:SetFolder('InazumaBalls/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

print(4)

-- Hitbox Extender
HBE:AddLabel("Keybind"):AddKeyPicker('HBE', {
    Default = '',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Hitbox Expander',
    NoUI = false

})

HBE:AddSlider("HBERange", {
    Text = 'Radius',

    Default = 5,
    Min = 0,
    Max = 40,
    Rounding = 1,

    Compact = false
})

local function HBEfunc()
    while Options.HBE:GetState() do
        task.wait()
        for i, v in next, game:GetService("Players"):GetPlayers() do
            task.wait()
            if v.Name ~= game:GetService("Players").LocalPlayer.Name then
                if v.Character == nil then
                    return
                end
                if v.Character:FindFirstChild("HumanoidRootPart") == nil then
                    return
                end
                v.Character.HumanoidRootPart.Size = Vector3.new(Options.HBERange.Value, Options.HBERange.Value,
                    Options.HBERange.Value)
                v.Character.HumanoidRootPart.Transparency = 0.8
                v.Character.HumanoidRootPart.CanCollide = false
                v.Character.HumanoidRootPart.Shape = Enum.PartType.Ball
                v.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 255, 255)
                if _G.HBE == false then
                    v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    v.Character.HumanoidRootPart.Transparency = 1
                    v.Character.HumanoidRootPart.CanCollide = false
                    v.Character.HumanoidRootPart.Shape = Enum.PartType.Ball
                    v.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 255, 255)
                end
            end
        end

    end
end

Options.HBE:OnClick(function()
    if Options.HBE:GetState() == false then
        for i, v in next, game:GetService("Players"):GetPlayers() do
            if v.Name ~= game:GetService("Players").LocalPlayer.Name then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    v.Character.HumanoidRootPart.Transparency = 1
                    v.Character.HumanoidRootPart.CanCollide = false
                    v.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 255, 255)
                end)
            end
        end
    elseif Options.HBE:GetState() == true then
        task.spawn(function()
            HBEfunc()
        end)
    end
end)

-- Power Manipulator

powerManipulator:AddLabel("Keybind"):AddKeyPicker("powerManipKeybind", {
    Default = "Z",
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Power Manipulator',
    NoUI = false
})

powerManipulator:AddSlider("PMPower", {
    Text = 'Power',

    Default = 80,
    Min = 0,
    Max = 250,
    Rounding = 1,

    Compact = false
})

    local mt = getrawmetatable(game);
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(remote, ...)
        args = {...}
        method = tostring(getnamecallmethod())
        if method == "FireServer" and tostring(remote) == "OFF" and Options.powerManipKeybind:GetState() then
            if Options.powerManipKeybind:GetState() == true then
                args[2] = Options.PMPower.Value
                return old(remote, unpack(args))
            end
        end
        return old(remote, ...)
    end)
    setreadonly(mt, true)

----

LeftGroupBox:AddLabel('Keybind'):AddKeyPicker('AutoDribble', {
    Default = 'Y',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Auto Dribble',
    NoUI = false
})

LeftGroupBox:AddSlider('AutoDribbleDelay', {
    Text = 'Delay',

    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 10,

    Compact = false -- If set to true, then it will hide the label
})

LeftGroupBox:AddSlider('ADRange', {
    Text = 'Range',

    Default = 20,
    Min = 0,
    Max = 100,
    Rounding = 1,

    Compact = false -- If set to true, then it will hide the label
})

LeftGroupBox:AddToggle('AdTeamCheck', {
    Text = 'Team Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Toggles Team check' -- Information shown when you hover over the toggle
})

LeftGroupBox:AddSlider('ADDebounce', {
    Text = 'Debounce Time',

    Default = 3,
    Min = 0,
    Max = 6,
    Rounding = 1,

    Compact = false -- If set to true, then it will hide the label
})


--- Auto R
RightGroupBox:AddLabel('Keybind'):AddKeyPicker('AutoR', {
    Default = 'U',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Auto R',
    NoUI = false
})

RightGroupBox:AddSlider('AutoRRange', {
    Text = 'Range',

    Default = 20,
    Min = 0,
    Max = 100,
    Rounding = 1,

    Compact = false -- If set to true, then it will hide the label
})
RightGroupBox:AddSlider('bringRange', {
    Text = 'Bring Range',

    Default = 10,
    Min = 0,
    Max = 20,
    Rounding = 1,

    Compact = false -- If set to true, then it will hide the label
})


RightGroupBox:AddSlider('AutoRDelay', {
    Text = 'Delay',
    Default = 1,
    Min = 0,
    Max = 3,
    Rounding = 1,
    Compact = false

})

RightGroupBox:AddToggle('AutoRTeamCheck', {
    Text = 'Team Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Toggles Team check' -- Information shown when you hover over the toggle
})

---Auto T 
RightGroupBox2:AddLabel('Keybind'):AddKeyPicker('AutoT', {
    Default = 'H',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Auto T',
    NoUI = false
})

RightGroupBox2:AddSlider('AutoTRange', {
    Text = 'Range',

    Default = 20,
    Min = 0,
    Max = 100,
    Rounding = 1,

    Compact = false -- If set to true, then it will hide the label
})
RightGroupBox2:AddSlider('AutoTDelay', {
    Text = 'Delay',

    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 10,

    Compact = false
})
---MOSS
RightGroupBox3:AddToggle("AutoMoss", {
    Text = 'Auto Moss',
    Default = false, -- Default value (true / false)
    Tooltip = 'Toggles Team check' -- Information shown when you hover over the toggle
})
RightGroupBox3:AddSlider("MossRange", {
    Text = 'Range',
    Default = 1,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false

})
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R then
        if Toggles.AutoMoss.Value == false then
            return
        end
        for i, v in pairs(game.Workspace:GetChildren()) do
            task.wait()
            if v.Name == "Ball" and v:IsA("Part") then
                task.wait()
                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <=
                    Options.MossRange.Value and v.CFrame.y > game.Players.LocalPlayer.Character.Head.CFrame.y then
                    firetouchinterest(game.Players.LocalPlayer.Character.Head, v, 0) -- 0 is touch
                    task.wait()
                    firetouchinterest(game.Players.LocalPlayer.Character.Head, v, 1) -- 1 is untouch
                    vim:SendKeyEvent(true, "R", false, game);
                    task.wait(.1)
                    vim:SendKeyEvent(true, "R", false, game);
                end

            end
        end
    end
end)

--IFrame

IFrameBox:AddToggle("IFrameExtender", {
    Text = 'Toggle',
    Default = false, -- Default value (true / false)
    Tooltip = 'Toggles Iframe' -- Information shown when you hover over the toggle
})

IFrameBox:AddSlider("IFRameExtenderSeconds", {
    Text = 'Seconds',

    Default = 0.5,
    Min = 0,
    Max = 3,
    Rounding = 1,

    Compact = false -- If set to true, then it will hide the label
})

_G.CD = false
local function frameExtend()
    if Toggles.IFrameExtender.Value == false then
        return
    end
    if _G.CD == true then
        return
    end
    _G.CD = true
    local i = 0
    while i < Options.IFRameExtenderSeconds.Value do
        game:GetService("Players").LocalPlayer.Character.SprintADribbles.Dribble:FireServer()
        task.wait(.1)
        i = i + 1
    end
    _G.CD = false
end
local gameMeta = getrawmetatable(game)
local __namecall
__namecall = hookmetamethod(game, '__namecall', function(Self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and tostring(Self) == 'Dribble' and (method == 'FireServer' or method == 'InvokeServer') then
        if _G.CD == false and Toggles.IFrameExtender.Value then
            print("Extending")
            task.spawn(frameExtend)
        end
    end
    return __namecall(Self, ...)
end)

setreadonly(gameMeta, true)

--- functions

function checkInRange(range, item)
    local partsInRadius = workspace:GetPartBoundsInRadius(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, range)
    for i, v in pairs(partsInRadius) do
        if v.Name == item then
            return v
        end
    end
end

local function bringBall(ball, range)
    local oldTick = tick()
    if ball ~= nil then
        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - ball.Position).Magnitude > range then
            return
        end
        print("Found ball in: ", tick() - oldTick)
        firetouchinterest(game.Players.LocalPlayer.Character.Head, ball, 0)
        task.wait()
        firetouchinterest(game.Players.LocalPlayer.Character.Head, ball, 1)
    else
        return
    end
end

local function Dribble(plr)
    if table.find(dribbledPlayers, plr) == nil then
        table.insert(dribbledPlayers, plr)
        local picker = math.random(1, 2)
        task.wait(Options.AutoDribbleDelay.Value)
        print("Dribbled")
        if picker == 1 then
            vim:SendKeyEvent(true, "Q", false, game);
            task.wait(.1)
            vim:SendKeyEvent(false, "Q", false, game);
        else
            vim:SendKeyEvent(true, "E", false, game);
            task.wait(.1)
            vim:SendKeyEvent(false, "E", false, game);
        end

        task.wait(Options.ADDebounce.Value)
        table.remove(dribbledPlayers, table.find(dribbledPlayers, plr))

    end
end

local function autoDrible(enemyPlr)
    local character = enemyPlr.Parent
    if Options.AutoDribble:GetState() == false then
        return
    end
    if (enemyPlr.Position - HumanoidRootPart.Position).Magnitude >= Options.ADRange.Value then
        return
    end

    if Toggles.AdTeamCheck.Value == true then
        if game.Players[character.Name].Team ~= game.Players.LocalPlayer.Team then

            Dribble(character.Parent.Name)
        end
    else
        Dribble(character.Parent.Name)
    end

end

local function autoR(enemyPlr)
    
    if not Options.AutoR:GetState() then
        return
    end
    print(enemyPlr.Name, "Shooting")
    
    if Toggles.AutoRTeamCheck.Value == true then
        if game.Players[enemyPlr.Name].Team ~= game.Players.LocalPlayer.Team then
            return
        end
    end

    task.spawn(function()
        task.wait(Options.AutoRDelay.Value)
        local oldtick = tick()
        for i = 0, 1, 0.1 do
            if checkInRange(Options.AutoRRange.Value, "Ball") ~= nil then
                local balls = checkInRange(Options.AutoRRange.Value, "Ball")
                print("Ball in Range", Options.AutoRRange.Value)
                vim:SendKeyEvent(true, "R", false, game);
                task.wait(.1)
                vim:SendKeyEvent(false, "R", false, game);
                bringBall(balls, Options.bringRange.Value)
                print("Got Ball in: ", tick() - oldtick)
                return
            end
            task.wait(.1)
        end
        print("Didn't Got Ball in: ", tick() - oldtick)
    end)
end

local function AutoT(enemyPlr)
    if not Options.AutoT:GetState() then
        return
    end
    print(enemyPlr.Name, "Shooting")

    task.spawn(function()
        local oldtick = tick()
        task.wait(Options.AutoTDelay.Value)
        for i = 0, 1, 0.1 do
            if checkInRange(Options.AutoTRange.Value, "Ball") ~= nil then
                local balls = checkInRange(Options.AutoTRange.Value, "Ball")
                print("Ball in Range", Options.AutoTRange.Value)
                vim:SendKeyEvent(true, "T", false, game);
                task.wait(.1)
                vim:SendKeyEvent(false, "T", false, game);
                bringBall(balls, Options.bringRange.Value)
                print("Got Ball in: ", tick() - oldtick)
                return
            end
            task.wait(.1)
        end
        print("Didn't Got Ball in: ", tick() - oldtick)
    end)
end


--- connections

local function setupAutoParry(character)
    if character == game.Players.LocalPlayer.Character then
        return
    end
    local Hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart");
    local Humanoid = character:WaitForChild("Humanoid");
    Humanoid.AnimationPlayed:Connect(function(AnimationTrack) -- Do this every time the player plays an animation
        
        if table.find(SlideAnims, AnimationTrack.Animation.AnimationId) then
            print(character.Name, "Slide")
            autoDrible(character.HumanoidRootPart)
        end

        if ShootAnim[AnimationTrack.Animation.AnimationId] then
            autoR(character)
        end

        if ShootAnim[AnimationTrack.Animation.AnimationId] then
            AutoT(character)
        end

    end);
    print("Setup for", character.Parent.Name)
end
for _, v in pairs(game:GetService("Players"):GetChildren()) do
    if v.Character and v ~= game.Players.LocalPlayer then
        print(v.Name, "Slide")
        setupAutoParry(v.Character)
    end
   
--     -- Setup the auto parry for when they respawn and get a new character
    v.CharacterAdded:Connect(setupAutoParry)
end
-- Setup the auto parry for new players who join
_G.AnimationGrabber = Players.PlayerAdded:Connect(function(player)
    print(player.Name, "Slide")
    player.CharacterAdded:Connect(setupAutoParry)
end)













