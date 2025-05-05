local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SynX-WS " .. Fluent.Version,
    SubTitle = "by SynXteam",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Главная", Icon = "home" }),
    States = Window:AddTab({ Title = "Статистика игрока", Icon = "chart-column" }),
    esp = Window:AddTab({ Title = "ESP", Icon = "chart-column" }),
    Settings = Window:AddTab({ Title = "Настройки", Icon = "settings" })
}

local Players = game:GetService("Players")
_G.espits = false

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "SynX-WS",
        Content = "Скрипт загружен!",
        SubContent = "SynX-Welcome Script", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })

    local Toggle = Tabs.esp:AddToggle("MyToggle", {Title = "ESP", Default = false })
    Toggle:OnChanged(function(Value)
        if Value == true then
            _G.espits = true
            for i, v in pairs(game.Workspace:GetDescendants()) do
                if v:FindFirstChild("Highlight") then
                    --nichego    

                else
                    
                    if v:FindFirstChild("Humanoid")then
                        local esp = Instance.new("Highlight", v)
                        esp.FillColor = Color3.fromRGB(17, 164, 255)                                         
                    end
                end
            end
        else
            _G.espits = false
            for i, v in pairs(game.Workspace:GetDescendants()) do
                if v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end)

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if _G.espits == true then
                local esp = Instance.new("Highlight", character)
                esp.FillColor = Color3.fromRGB(17, 164, 255)
            end
        end)
    end)

    Players.PlayerAdded:Connect(onPlayerAdded)

    local function onCharacterAdded(character)      
        if _G.espits == true then
            local esp = Instance.new("Highlight", character)
            esp.FillColor = Color3.fromRGB(17, 164, 255)
        end
    end


    Tabs.Main:AddParagraph({
        Title = "Главная",
        --Content = ""
    })



    Tabs.Main:AddButton({
        Title = "Infinity Yield",
        Description = "Запускает мульти скрипт Infinity Yield",
        Callback = function()
            Window:Dialog({
                Title = "Подтверждение",
                Content = "Загрузить скрипт?",
                Buttons = {
                    {
                        Title = "Да",
                        Callback = function()
                            loadstring(game: HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
                            Fluent:Notify({
                                Title = "SynX-WS",
                                Content = "Infinity Yield успешно загружен",
                                SubContent = "", -- Optional
                                Duration = 2 -- Set to nil to make the notification not disappear
                            })
                        end
                    },
                    {
                        Title = "Нет",
                        Callback = function()
                            
                        end
                    }
                }
            })
        end
    })

    Tabs.Main:AddButton({
        Title = "Sirius",
        Description = "Запускает удобный мульти скрипт с красивым интерфейсом",
        Callback = function()
            Window:Dialog({
                Title = "Подтверждение",
                Content = "Загрузить скрипт?",
                Buttons = {
                    {
                        Title = "Да",
                        Callback = function()
                            loadstring(game:HttpGet('https://sirius.menu/sirius'))()
                            Fluent:Notify({
                                Title = "SynX-WS",
                                Content = "Sirius успешно загружен",
                                SubContent = "", -- Optional
                                Duration = 2 -- Set to nil to make the notification not disappear
                            })
                        end
                    },
                    {
                        Title = "Нет",
                        Callback = function()
                            
                        end
                    }
                }
            })
        end
    })



    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Toggle", Default = false })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)

    Tabs.States:AddButton({
        Title = "Сбросить",
        Description = "Сбрашивает статистику игрока до стандартных значений",
        Callback = function()
            Window:Dialog({
                Title = "Подтверждение",
                Content = "Сбросить статистику?",
                Buttons = {
                    {
                        Title = "Да",
                        Callback = function()
                            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
                            game.Players.LocalPlayer.Character.Humanoid.JumpHeight = 7
                            Fluent:Notify({
                                Title = "SynX-WS",
                                Content = "Статистика сброшена до значений по умолчанию",
                                SubContent = "", -- Optional
                                Duration = 2 -- Set to nil to make the notification not disappear
                            })
                        end
                    },
                    {
                        Title = "Нет",
                        Callback = function()
                            
                        end
                    }
                }
            })
        end
    })
    
    local Slider = Tabs.States:AddSlider("Slider", {
        Title = "Скорость",
        Description = "Скорость игрока",
        Default = 16,
        Min = 0,
        Max = 300,
        Rounding = 1,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    })

    local Slider = Tabs.States:AddSlider("Slider1", {
        Title = "Прыжок",
        Description = "Высота прыжка",
        Default = 7,
        Min = 0,
        Max = 120,
        Rounding = 1,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpHeight = Value
        end
    })    

    --Slider:OnChanged(function(Value)
     --   print("Slider changed:", Value)
   -- end)

   -- Slider:SetValue(3)



    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)


    
    local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "You can select multiple values.",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = true,
        Default = {"seven", "twelve"},
    })

    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        print("Mutlidropdown changed:", table.concat(Values, ", "))
    end)



    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)
    
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))



    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "but you can change the transparency.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    TColorpicker:OnChanged(function()
        print(
            "TColorpicker changed:", TColorpicker.Value,
            "Transparency:", TColorpicker.Transparency
        )
    end)



    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle", -- Always, Toggle, Hold
        Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

        -- Occurs when the keybind is clicked, Value is `true`/`false`
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,

        -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    -- OnClick is only fired when you press the keybind and the mode is Toggle
    -- Otherwise, you will have to use Keybind:GetState()
    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)

            -- example for checking if a keybind is being pressed
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold


    local Input = Tabs.Main:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    --Input:OnChanged(function()
   --     print("Input updated:", Input.Value)
   -- end)
end


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
