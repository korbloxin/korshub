_G.KorsHubRunning = true
--to make sure you can move your cursor when menu is open
local modalgui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local firstclose = true
do --to localize the modalbutton only to this since the variable isnt important anywhere else
    local modalbutton = Instance.new("TextButton", modalgui)
    modalbutton.Modal = true
    modalbutton.Text = "1"
    modalbutton.BackgroundTransparency = 1
    modalbutton.TextTransparency = 1
    modalbutton.Size = UDim2.fromOffset(0, 0)
end

local Stats = game:GetService("Stats")
local FrameRateManager = Stats and Stats:FindFirstChild("FrameRateManager")
local RenderAverage = FrameRateManager and FrameRateManager:FindFirstChild("RenderAverage")


local function GetFramerate(): number
	return 1000 / RenderAverage:GetValue()
end


local SCRIPTVERSION = "1.0"
local LATESTVERSION = loadstring(game:HttpGet("https://raw.githubusercontent.com/korbloxin/korshub/refs/heads/main/latestversion.lua"))()

local RenderSteppedLoop = nil
local InputLoop = nil
local DescAddedLoop = nil   
local LastSpawnTime = nil
local EndAllLoops = false


local function anonymousmodeerror(actionname:string)
    WindUI:Popup({
    Title = `Action Blocked ({actionname})`,
    Icon = "shield-alert",
    Content = "Anonymous mode is on - any actions involving internet access is blocked",
    Buttons = {
        {
            Title = "Okay",
            Variant = "Primary",
            Icon = "check"
        },
    }
})
end

local function errornotif(error:string)
    WindUI:Notify({
        Title = "Kor's Hub Script Error",
        Content = `{error}\n<~~~~~~~~~~~~~~~~~~>\nIf this persists, please report the error through the Discord.`,
        Duration = 30,
        Icon = "circle-slash",
    })
end
local function keybindnotif(keybind:string)
    WindUI:Notify({
        Title = "Kor's Hub",
        Content = `{keybind} key pressed`,
        Duration = 2,
        Icon = "command",
    })
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LastSpawn = nil
local LastSpawnChecker = LocalPlayer.CharacterAdded:Connect(function()
    LastSpawn = os.clock()
end)

local function gettimesincespawn()
    if LastSpawn ~= nil then
        return os.clock() - LastSpawn
    else
        return nil --use accordingly depending on usage as it effectively says the last respawn time hasn't been tracked yet
    end
end

WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
WindUI:SetFont("rbxassetid://12187365364")
local Window = true
Window = WindUI:CreateWindow({
    Title = "Kor's Hub",
    Author = "Open Source",
    Folder = "korshub",
    IconSize = 22*2,
    NewElements = true,
    Size = UDim2.fromOffset(700,2000),
    
    HideSearchBar = false,
    
    OpenButton = {
        Title = "Kor's Hub", -- can be changed
        CornerRadius = UDim.new(1,0), -- fully rounded
        StrokeThickness = 3, -- removing outline
        Enabled = true, -- enable or disable openbutton
        Draggable = false,
        OnlyMobile = false,
        
        Color = ColorSequence.new(
            {ColorSequenceKeypoint.new(0, Color3.fromHex("#0400ff")), 
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#6d0fd9")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#00ffc8"))}
        )
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac", -- Default or Mac
    },
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:Popup({
                Title = "User Menu",
                Icon = "user-round-cog",
                Content = "Choose an option below:",
                Buttons = {
                    {
                        Title = "Kick Player",
                        Variant = "Primary",
                        Icon = "user-round-minus",
                        Callback = function()
                            LocalPlayer:Kick("Kick initiated by user")
                        end
                    },
                    {
                        Title = "Kill Player",
                        Variant = "Primary",
                        Icon = "skull",
                        Callback = function()
                            keybindnotif("Reset Character")
    if LocalPlayer.Character == nil then
        errornotif("Character doesn't exist")
        return
    end
if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil then
    errornotif("Humanoid doesn't exist")
    return
end
if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
    errornotif("Humanoid's Health is already equal to or below 0. Wait a bit before resetting again.")
    return
end
if not (gettimesincespawn() == nil or gettimesincespawn() > 2) then
    errornotif("Wait a few seconds before trying to reset.")
    return
end
LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
                        end
                    },
                    {
                        Title = "Close",
                        Variant = "Secondary",
                        Icon = "x"
                    },
                    {
                        Title = "Destroy Window",
                        Variant = "tertiary",
                        Icon = "log-out",
                        Callback = function()
                            WindUI:Popup({
                Title = "Warning",
                Icon = "triangle-alert",
                Content = "This will end all loops. Are you sure you want to destroy the window?",
                Buttons = {
                    {
                        Title = "Yes, I'm sure",
                        Variant = "Primary",
                        Icon = "check",
                        Callback = function()
                            RenderSteppedLoop:Disconnect()
                            InputLoop:Disconnect()
                            DescAddedLoop:Disconnect()
                            LastSpawnChecker:Disconnect()
                            EndAllLoops = true
                            _G.KorsHubRunning = false
                            Window:Destroy()
                        end
                    },
                    {
                        Title = "No, cancel",
                        Variant = "Secondary",
                        Icon = "x"
                    }
                }
            })
                        end
                    }
                }
            })
        end,
    },
})




Window:OnOpen(function()
modalgui.Enabled = true
end)
Window:OnClose(function()
if firstclose then
    firstclose = false
    WindUI:Notify({
    Title = "Modal Glitch",
    Content = "In order to fix the cursor not locking, you might have to re-open the window and close it again. It's a weird bug and I don't know why it's caused.\n(It only happens on the first window close, and doesn't happen all the time)",
    Duration = 30,
    Icon = "info",
})
end
modalgui.Enabled = false
end)
Window.OnDestroy(function()
modalgui:Destroy()
end)

Window:Tag({
    Title = "UI Version: " .. WindUI.Version,
    Icon = "tv-minimal",
    Color = Color3.fromHex("#1c1c1c")
})
Window:Tag({
    Title = "Script Version: " .. SCRIPTVERSION,
    Icon = "hard-drive-download",
    Color = Color3.fromHex("#1c1c1c")
})
if SCRIPTVERSION == LATESTVERSION then
    Window:Tag({
        Title = "Up to Date",
        Icon = "cloud-check",
        Color = Color3.fromHex("#1c1c1c")
    })
else
    Window:Tag({
    Title = "Update Required - Latest Version: " .. LATESTVERSION,
    Icon = "cloud-alert",
    Color = Color3.fromHex("#b00c0c")
})
end

Window:SetToggleKey(Enum.KeyCode.Backquote)
Window:DisableTopbarButtons({"Close"})
WindUI:SetNotificationLower(true)

local ConfigTab = Window:Tab({
    Title = "Configuration",
    Icon = "settings-2",
    Locked = false,
})

ConfigTab:Select()

ConfigTab:Keybind({
    Title = "Quick Hide Keybind",
    Desc = "Keybind to quickly show/hide UI",
    Value = "Backquote",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})
ConfigTab:Toggle({
    Title = "Lock Window Resizing",
    Desc = "Whether window resizing should be locked or not",
    Icon = "lock",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        Window:IsResizable(not state)
    end
})
local Anonymous = ConfigTab:Toggle({
    Title = "Anonymous",
    Desc = "Whether or not to block any internet-related actions (Does not impact the User Menu)",
    Icon = "globe-lock",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        Window.Icon:SetAnonymous(state)
    end
})
ConfigTab:Slider({
    Title = "Icon Size",
    Desc = "Is broken, but the UI is in beta soooo",
    Icons = {
        From = "scaling",
        To = "image-upscale"
    },
    IsTooltip = true,

    Step = 0.5,
    Value = {
        Min = 10,
        Max = 48,
        Default = 20,
    },
    Callback = function(value)
        Window:SetIconSize(value)
    end
})
ConfigTab:Toggle({
    Title = "Lower Notifications",
    Desc = "Whether or not to put the notifications at the very bottom (visual only)",
    Icon = "arrow-down-wide-narrow",
    Type = "Toggle",
    Value = true,
    Callback = function(state) 
        WindUI:SetNotificationLower(state)
    end
})
ConfigTab:Space()
local DeathKeybind = nil
local DeathKeybindToggle = ConfigTab:Toggle({
    Title = "Death Keybind Toggle",
    Desc = "Whether to reset your character when the death keybind is pressed",
    Icon = "keyboard",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        if state then
            DeathKeybind:Unlock()
        else
            DeathKeybind:Lock()
        end
    end
})
DeathKeybind = ConfigTab:Keybind({
    Title = "Death Keybind",
    Desc = "What key to press to reset character",
    Value = "R",
    Locked = true
})



local HubsTab = Window:Tab({
    Title = "Other Scripts",
    Icon = "ellipsis-vertical",
    Locked = false,
})

local infyielddropdown = HubsTab:Dropdown({
    Title = "Infinite Yield",
    Icon = "lock-open",
    Desc = "The generic admin script",
    Values = {
        {
            Title = "Run",
            Desc = "Runs the script",
            Icon = "play",
            Callback = function() 
                if Anonymous.Value then
            anonymousmodeerror("HttpGet")
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end
            end
        },
        {
            Title = "Get Key",
            Desc = "Script doesn't require a key",
            Icon = "ban",
            Locked = true,
            Callback = function() 
                
            end
        },
        {
            Title = "Join Discord",
            Desc = "Copy link to join the discord",
            Icon = "message-circle-question-mark",
            Callback = function() 
                setclipboard("https://discord.com/invite/dYHag43eeU")
            end
        },
        {Type = "Divider"},
        {
            Title = "View Documentation",
            Desc = "Copy link to view the script documentation",
            Icon = "scroll-text",
            Callback = function() 
                setclipboard("https://infyiff.github.io/documentation.html/")
            end
        },
        {
            Title = "View Website",
            Desc = "Copy link to the script website",
            Icon = "github",
            Callback = function() 
                setclipboard("https://infyiff.github.io/")
            end
        },
    }
    
})
HubsTab:Dropdown({
    Title = "Rift",
    Desc = "One of the best script hubs",
    Values = {
        {
            Title = "Run",
            Desc = "Runs the script",
            Icon = "play",
            Callback = function() 
                if Anonymous.Value then
            anonymousmodeerror("HttpGet")
        else
            loadstring(game:HttpGet("https://rifton.top/loader.lua"))()
        end
            end
        },
        {
            Title = "Get Key",
            Desc = "Copy the link to get the key",
            Icon = "file-key",
            Callback = function() 
                setclipboard("https://rifton.top/getkey")
            end
        },
        {
            Title = "Join Discord",
            Desc = "Copy link to join the discord",
            Icon = "message-circle-question-mark",
            Callback = function() 
                setclipboard("rifton.top/discord")
            end
        },
        {Type = "Divider"},
        {
            Title = "View Documentation",
            Desc = "Copy link to view the script documentation",
            Icon = "scroll-text",
            Callback = function() 
                setclipboard("docs.rifton.top")
            end
        },
        {
            Title = "View Website",
            Desc = "Copy link to the script website",
            Icon = "app-window-mac",
            Callback = function() 
                setclipboard("rifton.top")
            end
        },
    }
})
HubsTab:Dropdown({
    Title = "Dex",
    Desc = "Allows you to use Explorer, read scripts if your executor has a decompiler, and potentially find vulnerable RemoteEvents",
    Values = {
        {
            Title = "Run",
            Desc = "Runs the script",
            Icon = "play",
            Callback = function() 
                if Anonymous.Value then
            anonymousmodeerror("HttpGet")
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end
            end
        },
        {
            Title = "Get Key",
            Desc = "Script doesn't require a key",
            Icon = "ban",
            Locked = true,
            Callback = function() 
                
            end
        },
        {
            Title = "Join Discord",
            Desc = "Copy link to join the discord",
            Icon = "message-circle-question-mark",
            Callback = function() 
                setclipboard("https://discord.com/invite/dYHag43eeU")
            end
        },
        {Type = "Divider"},
        {
            Title = "View Documentation",
            Desc = "Script doesn't have a documentation",
            Icon = "ban",
            Locked = true,
            Callback = function() 
                
            end
        },
        {
            Title = "View Website",
            Desc = "Copy link to the script website",
            Icon = "github",
            Callback = function() 
                setclipboard("https://github.com/LorekeeperZinnia/Dex")
            end
        },
    }
})



local NotifTestTab = Window:Tab({
    Title = "Notification Test",
    Icon = "bell",
    Locked = false,
})
local NotifTitleInput = NotifTestTab:Input({
    Title = "Title",
    Value = "Hahaha",
    InputIcon = "type-outline",
    Type = "Input", -- or "Textarea"
    Placeholder = "",
})
local NotifDescInput = NotifTestTab:Input({
    Title = "Input",
    Value = "Test notification is here!",
    InputIcon = "type",
    Type = "Textarea",
    Placeholder = "...",
})
local NotifLifetimeSlider = NotifTestTab:Slider({
    Title = "Lifetime",
    Desc = "How long the notification will last without being closed manually",
    
    Step = 1,
    Value = {
        Min = 1,
        Max = 30,
        Default = 5,
    },
})
NotifTestTab:Space()
NotifTestTab:Button({
    Title = "Send Notification",
    Locked = false,
    Icon = "send",
    Callback = function()
        WindUI:Notify({
            Title = NotifTitleInput.Value,
            Content = NotifDescInput.Value,
            Duration = tonumber(NotifLifetimeSlider.Value.Default),
            Icon = "hand",
        })
    end
})

    
Window:Divider()

local HttpGetTab = Window:Tab({
    Title = "View HttpGet Contents",
    Icon = "chevrons-left-right-ellipsis",
    Locked = false,
})

local HttpGetRequester = HttpGetTab:Input({
    Title = "HttpGet Fetcher",
    Desc = "Link to HttpGet",
    Value = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
    InputIcon = "database",
    Type = "Textarea",
    Placeholder = "Your link",
})
local HttpGetOutput = HttpGetTab:Code({
    Title = "Output",
    Code = "...",
})
local HttpGetButton = nil
HttpGetButton = HttpGetTab:Button({
    Title = "Fetch",
    Icon = "router",
    Locked = false,
    Callback = function()
    if Anonymous.Value then
        anonymousmodeerror("HttpGet")
    else
            HttpGetButton:Lock()
HttpGetOutput:SetCode("Fetching...")
local success, output = pcall(function(...)  
    return game:HttpGet(HttpGetRequester.Value)
end)
HttpGetButton:Unlock()
if success then
    HttpGetOutput:SetCode("Text is too long to display")
    HttpGetOutput:SetCode(output) --does nothing if it's too long for the ui library to handle so it works perfectly fine
else
    HttpGetOutput:SetCode(`Fetch failed with error message {output}`)
end
end
    end
})

Window:Divider()

local MechanicsTab = Window:Tab({
    Title = "Gameplay Mechanics",
    Icon = "dices",
    Locked = false,
})

local ShiftlockSection = MechanicsTab:Section({
    Title = "Shiftlock",
    Icon = "locate",
    Opened = false,
})

local ShiftlockLoopDropdown = ShiftlockSection:Dropdown({
    Title = "Loop Mode",
    Desc = "What to constantly set the value to",
    Values = {
        {
            Title = "On",
            Icon = "toggle-right"
        },
        {
            Title = "Off",
            Icon = "toggle-left"
        },
        {Type = "Divider"},
        {
            Title = "Don't Loop",
            Icon = "power-off"
        },
    },
    Value = "Don't Loop",
    Callback = function() end
})
ShiftlockSection:Dropdown({
    Title = "Set to",
    Desc = "Set to once",
    Values = {
        {
            Title = "On",
            Icon = "toggle-right",
            Callback = function()
                LocalPlayer.DevEnableMouseLock = true
            end
        },
        {
            Title = "Off",
            Icon = "toggle-left",
            Callback = function()
                LocalPlayer.DevEnableMouseLock = false
            end
        },
    },
})

ShiftlockSection:Divider()

local CamSection = MechanicsTab:Section({
    Title = "Camera",
    Icon = "camera",
    Opened = false,
})

local CamModeSection = CamSection:Section({
    Title = "Camera Mode",
    Icon = "aperture",
    Opened = false,
})

local CamModeLoopDropdown = CamModeSection:Dropdown({
    Title = "Loop Mode",
    Desc = "What to constantly set the value to",
    Values = {
        {
            Title = "Zoom",
            Desc = "The default camera mode",
            Icon = "webcam"
        },
        {
            Title = "Inviscam",
            Desc = "Allows you to see through walls",
            Icon = "scan-eye"
        },
        {Type = "Divider"},
        {
            Title = "Don't Loop",
            Icon = "power-off"
        },
    },
    Value = "Don't Loop",
    Callback = function() end
})
CamModeSection:Dropdown({
    Title = "Set to",
    Desc = "Set to once",
    Values = {
        {
            Title = "Zoom",
            Desc = "The default camera mode",
            Icon = "webcam",
            Callback = function()
                LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
            end
        },
        {
            Title = "Inviscam",
            Desc = "Allows you to see through walls",
            Icon = "scan-eye",
            Callback = function()
                LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            end
        },
    },
})

CamModeSection:Divider()

local CamTypeSection = CamSection:Section({
    Title = "Camera Type",
    Icon = "focus",
    Opened = false,
})

local CamTypeLoopDropdown = CamTypeSection:Dropdown({
    Title = "Loop Mode",
    Desc = "What to constantly set the value to",
    Values = {
        {
        Title = "Camera Toggle",
        Desc = "Shift to offset camera (doesn't turn your body like Shiftlock), right click to toggle cursorlock (Fallbacks to Classic on mobile)",
        Icon = "plus"
        },
        {
        Title = "Classic",
        Desc = "The default camera mode for computer",
        Icon = "camera"
        },
        {
            Title = "Follow",
            Desc = "The default camera mode for mobile (your camera follows your walking direction)",
            Icon = "refresh-ccw-dot"
        },
        {
            Title = "Orbital",
            Desc = "Locks zoom and camera to a top-down perspective",
            Icon = "move-up-left"
        },
        {
            Title = "User Choice",
            Desc = "Allow switching by user in Roblox settings",
            Icon = "settings"
        },
        {Type = "Divider"},
        {
        Title = "Don't Loop",
        Icon = "power-off"
        },
    },
    Value = "Don't Loop",
    Callback = function() end
})
CamTypeSection:Dropdown({
    Title = "Set to",
    Desc = "Set to once",
    Values = {
        {
        Title = "Camera Toggle",
        Desc = "Shift to offset camera (doesn't turn your body like Shiftlock), right click to toggle cursorlock (Fallbacks to User Choice on mobile)",
        Icon = "plus",
        Callback = function()
            LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.CameraToggle
            LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.UserChoice
        end
        },
        {
        Title = "Classic",
        Desc = "The default camera mode for computer",
        Icon = "camera",
        Callback = function()
            LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Classic
            LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.Classic
        end
        },
        {
            Title = "Follow",
            Desc = "The default camera mode for mobile (your camera follows your walking direction)",
            Icon = "refresh-ccw-dot",
            Callback = function()
                LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Follow
                LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.Follow
            end
        },
        {
            Title = "Orbital",
            Desc = "Locks zoom and camera to a top-down perspective",
            Icon = "move-up-left",
            Callback = function()
                LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Orbital
                LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.Orbital
            end
        },
        {
            Title = "User Choice",
            Desc = "Allow switching by user in Roblox settings",
            Icon = "settings",
            Callback = function()
                LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.UserChoice
                LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.UserChoice
            end
        },
    },
})

CamTypeSection:Divider()

CamSection:Divider()

Window:Divider()

local compatiblegames = {
    {GameId = 8620685718, GameName = "Don't Get Crushed by 67", Icon = "hand-coins" --[[lucide icon]]},
}

local GamesSection = Window:Section({ 
    Title = "Games",
    Icon = "gamepad-2"
})

do
local compatiblegame = nil
for i, v in ipairs(compatiblegames) do
if v.GameId == game.GameId then
compatiblegame = v
end
end
local tab = nil
if compatiblegame then
    tab = GamesSection:Tab({
    Title = "Compatible Game",
    Icon = "smile-plus",
    Locked = false,
})
local compatiblebutton = nil
compatiblebutton = tab:Button({
    Title = `This game has designated features for {compatiblegame.GameName} ({compatiblegame.GameId})`,
    Desc = "Use the search bar to find the tab for it",
    Locked = false,
    Callback = function()
        compatiblebutton:Highlight()
    end
})
tab:Divider()
else
    tab = GamesSection:Tab({
    Title = "Game Not Compatible",
    Icon = "frown",
    Locked = false,
})
end
local compatiblegamessection = tab:Section({ 
    Title = "Compatible Games",
    Icon = "list-check",
    Opened = compatiblegame == nil
})
for i, v in ipairs(compatiblegames) do
if v.GameId == game.GameId then
compatiblegamessection:Button({
    Title = `{v.GameName} ({v.GameId})`,
    Desc = "You're already in this game",
    Locked = false,
    Icon = "map-pin-check-inside",
})
else
compatiblegamessection:Button({
    Title = `{v.GameName} ({v.GameId})`,
    Desc = "Click to teleport",
    Locked = false,
    Callback = function()
    WindUI:Popup({
    Title = "Are you sure you want to teleport?",
    Icon = "info",
    Content = "This will leave you from the current game and lose all unsaved progress.",
    Buttons = {
        {
            Title = "Cancel",
            Icon = "x",
            Variant = "Secondary",
        },
        {
            Title = "Continue",
            Icon = "arrow-right",
            Callback = function()
            game:GetService("TeleportService"):Teleport(v.GameId) end,
            Variant = "Primary",
        }
    }
})
    end
})
end
end
end


local DGCB67Tab = GamesSection:Tab({
    Title = "Don't Get Crushed by 67",
    Icon = "hand-coins",
    Locked = (game.GameId ~= 8620685718),
})
DGCB67AutoFarm = DGCB67Tab:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm money and rebirths (Recommended to use Infinite Yield's anti idle with this)",
    Icon = "tractor",
    Type = "Toggle",
    Value = false,
})
DGCB67Tab:Button({
    Title = "Locate Infinite Yield",
    Desc = "for anti idle",
    Icon = "search",
    Locked = false,
    Callback = function()
        HubsTab:Select()
        task.delay(0.2, function() infyielddropdown:Highlight() end)
    end
})
DGCB67Tab:Space()
DGCB67Disable67Alerts = DGCB67Tab:Toggle({
    Title = "Disable 67 Alerts",
    Desc = "Mute all of the 67 sound alerts (This does not mute any currently playing alerts as it only checks when the sound first starts playing)",
    Icon = "megaphone-off",
    Type = "Toggle",
    Value = false,
})
DGCB67Tab:Toggle({
    Title = "Mute Music",
    Icon = "volume-x",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        if state then
            for i, v in pairs(game:GetService("SoundService"):WaitForChild("music"):GetChildren()) do
                v.Volume = 0
            end
        else
            for i, v in pairs(game:GetService("SoundService"):WaitForChild("music"):GetChildren()) do
                v.Volume = 0.1
            end
    end
end
})
DGCB67Tab:Toggle({
    Title = "Hide Notifications",
    Icon = "list-x",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Gui"):WaitForChild("NotificationHolder").Visible = not state
        game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Gui"):WaitForChild("NotificationHolder2").Visible = not state
    end
})



RenderSteppedLoop = game:GetService("RunService").RenderStepped:Connect(function(deltaTime:number)

end)

DescAddedLoop = game.DescendantAdded:Connect(function(added)
    if game.GameId == 8620685718 and added.Name == "67kid sfx" then
        if DGCB67Disable67Alerts.Value then
            added.Volume = 0
        else
            added.Volume = 0.5
        end
    end
end)

InputLoop = game:GetService("UserInputService").InputBegan:Connect(function(input)
if input.KeyCode == Enum.KeyCode[DeathKeybind.Value] and DeathKeybindToggle.Value then
    keybindnotif("Reset Character")
    if LocalPlayer.Character == nil then
        errornotif("Character doesn't exist")
        return
    end
if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") == nil then
    errornotif("Humanoid doesn't exist")
    return
end
if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
    errornotif("Humanoid's Health is already equal to or below 0. Wait a bit before resetting again.")
    return
end
if not (gettimesincespawn() == nil or gettimesincespawn() > 2) then
    errornotif("Wait a few seconds before trying to reset.")
    return
end
LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
end
end)




if game.GameId == 8620685718 then
while task.wait(4) do
if EndAllLoops then return end
if DGCB67AutoFarm.Value then
    if LocalPlayer.Character == nil then
        errornotif("Character doesn't exist")
        continue
    end
    if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        errornotif("HumanoidRootPart doesn't exist")
        continue
    end
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-5229, -54, -4296))
    task.delay(0.65, function()
    if not game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") then
        errornotif("Remotes doesn't exist")
        return
    end
    if not game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):FindFirstChild("rebirthReq") then
        errornotif("rebirthReq doesn't exist")
        return
    end
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("rebirthReq"):FireServer()
    end)
end
end 
end

