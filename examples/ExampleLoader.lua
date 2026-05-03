local AetherUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/watermaven/AetherUI/main/Main.lua"
))()

AetherUI:LoadTheme("Obsidian")
AetherUI:SetWatermark("AetherUI • watermaven")

local Window = AetherUI:CreateWindow({
    Name = "AetherUI Demo"
})

Window:Notify("AetherUI", "Framework Loaded Successfully", 4)

local MainTab = Window:CreateTab("Main")
local EditorTab = Window:CreateTab("Editor")
local MiscTab = Window:CreateTab("Misc")

MainTab:CreateSection("Basic Components")

MainTab:CreateButton("Test Button", function()
    Window:Notify("Button", "Button clicked.", 3)
end)

MainTab:CreateToggle("Auto Farm", false, function(v)
    print("Toggle:", v)
end)

MainTab:CreateSlider("WalkSpeed", 16, 200, 16, function(v)
    print("Slider:", v)
end)

MainTab:CreateDropdown(
    "Select Theme",
    {"Obsidian","Crimson","Emerald","Violet","Mono"},
    function(v)
        AetherUI:LoadTheme(v)
    end
)

MainTab:CreateTextbox("Enter text...", function(v)
    print("Textbox:", v)
end)

MainTab:CreateKeybind("UI Toggle", Enum.KeyCode.RightShift, function()
    print("Keybind Triggered")
end)

local Console = MiscTab:CreateConsole()
Console:Log("AetherUI Console Initialized")

EditorTab:CreateCodeEditor()
