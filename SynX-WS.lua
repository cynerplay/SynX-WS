local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SynX-WS " .. Fluent.Version,
    SubTitle = "by SynXteam",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Main = Window:AddTab({ Title = "Главная", Icon = "home" }),
    States = Window:AddTab({ Title = "Статистика игрока", Icon = "chart-column" }),
    esp = Window:AddTab({ Title = "ESP", Icon = "chart-column" }),
    Settings = Window:AddTab({ Title = "Настройки", Icon = "settings" })
}

local Players = game:GetService("Players")

local Options = Fluent.Options

-- Переменная состояния ESP
local espEnabled = false

-- Функция для удаления всех Highlight
local function clearESP()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        local highlight = v:FindFirstChildOfClass("Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Обновление ESP для всех персонажей
local function updateESP()
    clearESP()
    if espEnabled then
        local color = Options.espColorpicker.Value
        local transparency = Options.espColorpicker.Transparency or 0
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and not v:FindFirstChildOfClass("Highlight") then
                local esp = Instance.new("Highlight")
                esp.FillColor = color
                esp.FillTransparency = transparency
                esp.OutlineColor = Color3.new(0,0,0)
                esp.Parent = v
            end
        end
    end
end

-- Подписка на появление персонажей новых игроков
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            local color = Options.espColorpicker.Value
            local transparency = Options.espColorpicker.Transparency or 0
            local highlight = Instance.new("Highlight")
            highlight.FillColor = color
            highlight.FillTransparency = transparency
            highlight.OutlineColor = Color3.new(0,0,0)
            highlight.Parent = character
        end
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

do
    Fluent:Notify({
        Title = "SynX-WS",
        Content = "Скрипт загружен!",
        SubContent = "SynX-Welcome Script",
        Duration = 5
    })

    -- Главная вкладка без изменений
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

    -- Вкладка Статистика без изменений
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

    -- Вкладка ESP: Colorpicker с прозрачностью и Keybind для управления ESP

    local espColorpicker = Tabs.esp:AddColorpicker("espColorpicker", {
        Title = "Цвет и прозрачность ESP",
        Transparency = 26,
        Default = Color3.fromRGB(17, 164, 255)
    })

    espColorpicker:OnChanged(function()
        if espEnabled then
            updateESP()
        end
    end)

    local espKeybind = Tabs.esp:AddKeybind("espKeybind", {
        Title = "Включить/Выключить ESP",
        Mode = "Toggle",
        Default = "LeftControl",
        Callback = function(state)
            espEnabled = state
            updateESP()
        end,
        ChangedCallback = function(newKey)
            -- Убрано print
        end
    })

    -- Убраны обработчики с print

end

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
