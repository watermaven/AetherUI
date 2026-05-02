local WindowEngine = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/WindowEngine.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/ThemeManager.lua"))()

local AetherUI = {}

AetherUI.Version = "1.0.0"

function AetherUI:CreateWindow(Config)
	return WindowEngine:CreateWindow(Config or {})
end

function AetherUI:LoadTheme(Name)
	ThemeManager:LoadPreset(Name)
end

function AetherUI:SetAccent(Color)
	ThemeManager:SetAccent(Color)
end

function AetherUI:SetWatermark(Text)
	ThemeManager:SetWatermark(Text)
end

function AetherUI:SetTransparency(Value)
	ThemeManager:SetTransparency(Value)
end

return AetherUI
