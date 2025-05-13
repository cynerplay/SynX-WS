local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SynX-WS " .. Fluent.Version,
    SubTitle = "by SynXteam",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

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
        SubContent = "SynX-Welcome Script",
        Duration = 5
    })

    local ToggleESP = Tabs.esp:AddToggle("MyToggle", {Title = "ESP", Default = false })
    ToggleESP:OnChanged(function(Value)
        if Value == true then
            _G.espits = true
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if not v:FindFirstChild("Highlight") and v:FindFirstChild("Humanoid") then
                    local esp = Instance.new("Highlight", v)
                    esp.FillColor = Color3.fromRGB(17, 164, 255)
                end
            end
        else
            _G.espits = false
            for _, v in pairs(game.Workspace:GetDescendants()) do
                local highlight = v:FindFirstChild("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end)

    local function onPlayerAdded(player)
        player.CharacterAdded:Connect(function(character)
            if _G.espits == true then
                local esp = Instance.new("Highlight", character)
                esp.FillColor = Color3.fromRGB(17, 164, 255)
            end
        end)
    end

    Players.PlayerAdded:Connect(onPlayerAdded)
    -- Подписываемся на уже существующих игроков (если скрипт запускается после их появления)
    for _, player in pairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end

    Tabs.Main:AddParagraph({
        Title = "Главная",
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
                            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
                            Fluent:Notify({
                                Title = "SynX-WS",
                                Content = "Infinity Yield успешно загружен",
                                Duration = 2
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
                                Duration = 2
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

    local ToggleMain = Tabs.Main:AddToggle("MyToggleMain", {Title = "Toggle", Default = false })
    ToggleMain:OnChanged(function()
        -- Ваш код для этого переключателя
    end)
    Options.MyToggleMain:SetValue(false)

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
                            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid.WalkSpeed = 16
                                humanoid.JumpHeight = 7
                            end
                            Fluent:Notify({
                                Title = "SynX-WS",
                                Content = "Статистика сброшена до значений по умолчанию",
                                Duration = 2
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

    local SliderSpeed = Tabs.States:AddSlider("SliderSpeed", {
        Title = "Скорость",
        Description = "Скорость игрока",
        Default = 16,
        Min = 0,
        Max = 300,
        Rounding = 1,
        Callback = function(Value)
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    })

    local SliderJump = Tabs.States:AddSlider("SliderJump", {
        Title = "Прыжок",
        Description = "Высота прыжка",
        Default = 7,
        Min = 0,
        Max = 120,
        Rounding = 1,
        Callback = function(Value)
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpHeight = Value
            end
        end
    })

    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        -- Ваш код при изменении значения
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
        for k, state in pairs(Value) do
            if state then
                table.insert(Values, k)
            end
        end
        -- Ваш код при изменении множественного выбора
    end)

    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        -- Ваш код при изменении цвета
    end)

    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "but you can change the transparency.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    TColorpicker:OnChanged(function()
        -- Убрано ненужное строковое выражение
        -- Можно добавить код для обработки изменения цвета и прозрачности
    end)

    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle",
        Default = "LeftControl",
        Callback = function(Value)
            print("Keybind clicked! State:", Value)
        end,
        ChangedCallback = function(New)
            print("Keybind changed! New key:", tostring(New))
        end
    })

    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end
            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle")

    local Input = Tabs.Main:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

end

-- Addons:
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
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

SaveManager:LoadAutoloadConfig()
