-- New example script written by wally
-- You can suggest changes with a pull request or something
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local anim = "rbxassetid://11576785543"

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local vim = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local tbl = {"mr_cookie15", "v_Ghoui", "6aim_s", "BigBankDZin"}
if not table.find(tbl, LP.Name) then
    LP:Kick()
end

local Hum = LP.Character:WaitForChild("Humanoid")

local dribbledPlayers = {}

_G.AdTeamCheck = false
_G.AdRange = 20
_G.AdDebounceTimer = 3

local Window = Library:CreateWindow({

    Title = 'Inazuma Deez Balls',
    Center = true,
    AutoShow = true
})

-- You do not have to set your tabs & groups up this way, just a prefrence.
local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Main'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Auto Dribble')
local miscMenu = Tabs.Misc:AddLeftGroupbox("Misc")

-- Groupbox:AddToggle
-- Arguments: Index, Options
LeftGroupBox:AddLabel('Keybind'):AddKeyPicker('AutoDribble', {
    Default = 'Y',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Auto Dribble',
    NoUI = false
})

LeftGroupBox:AddToggle('AdTeamCheck', {
    Text = 'Team Check',
    Default = false, -- Default value (true / false)
    Tooltip = 'Toggles Team check' -- Information shown when you hover over the toggle
})

Toggles.AdTeamCheck:OnChanged(function()
    _G.AdTeamCheck = Toggles.AdTeamCheck.Value
end)

LeftGroupBox:AddDivider()

LeftGroupBox:AddSlider('ADRange', {
    Text = 'Range',

    Default = 20,
    Min = 0,
    Max = 30,
    Rounding = 1,

    Compact = false -- If set to true, then it will hide the label
})

LeftGroupBox:AddSlider('ADDebounce', {
    Text = 'Debounce Time',

    Default = 3,
    Min = 0,
    Max = 6,
    Rounding = 1,

    Compact = false -- If set to true, then it will hide the label
})

Options.ADRange:OnChanged(function()
    _G.ADRange = Options.ADRange.Value
end)
Options.ADDebounce:OnChanged(function()
    _G.AdDebounceTimer = Options.ADDebounce.Value
end)

local function Dribble(plr)
    if table.find(dribbledPlayers, plr) == nil then
        table.insert(dribbledPlayers, plr)
        local picker = math.random(1, 2)
        if picker == 1 then
            vim:SendKeyEvent(true, "Q", false, game);
            task.wait(.1)
            vim:SendKeyEvent(false, "Q", false, game);
        else
            vim:SendKeyEvent(true, "E", false, game);
            task.wait(.1)
            vim:SendKeyEvent(false, "E", false, game);
        end

        task.wait(_G.AdDebounceTimer)
        table.remove(dribbledPlayers, table.find(dribbledPlayers, plr))

    end
end

Options.AutoDribble:OnClick(function()
    _G.ADstate = Options.AutoDribble:GetState()
    task.spawn(function()
        if _G.ADstate then
            local function setupAutoParry(character)
                if _G.ADstate == false then
                    return
                end
                if character == game.Players.LocalPlayer.Character then
                    return
                end
                local Hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart");
                local Humanoid = character:WaitForChild("Humanoid");
                Humanoid.AnimationPlayed:Connect(
                    function(AnimationTrack) -- Do this every time the player plays an animation
                        if _G.ADstate == false then
                            return
                        end
                        if anim ~= AnimationTrack.Animation.AnimationId then
                            return;
                        end -- Check if the animation is in AnimList
                        if (Hrp.Position - character.HumanoidRootPart.Position).Magnitude >= _G.AdRange then
                            return
                        end
                        if _G.AdTeamCheck == true then
                            if character.Parent.Team ~= game.Players.LocalPlayer.Team then
                                Dribble(character.Parent.Name)
                            end
                        else
                            Dribble(character.Parent.Name)
                        end

                    end);
            end
            if _G.ADstate then
                for _, player in ipairs(Players:GetPlayers()) do
                    -- Setup the auto parry for everyone's current character
                    if player.Character and player ~= game.Players.LocalPlayer then
                        setupAutoParry(player.Character)
                    end

                    -- Setup the auto parry for when they respawn and get a new character
                    player.CharacterAdded:Connect(setupAutoParry)
                end
            end

            -- Setup the auto parry for new players who join
            _G.AdConection3 = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(setupAutoParry)
            end)
        else
            print("AD OFF")
            _G.AdConection3:Disconnect()
        end
    end)
end)

-----misc

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

-- todo: add a function for this

Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function()
    Library:Unload()
end)
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
