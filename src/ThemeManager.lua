local ThemeManager = {}

ThemeManager.Presets = {
	Obsidian = {
		Background = Color3.fromRGB(15,15,18),
		SecondaryBackground = Color3.fromRGB(21,21,25),
		Topbar = Color3.fromRGB(18,18,22),
		Accent = Color3.fromRGB(114,137,255),
		Text = Color3.fromRGB(235,235,235),
		SubText = Color3.fromRGB(150,150,155),
		Stroke = Color3.fromRGB(35,35,40)
	},

	Crimson = {
		Background = Color3.fromRGB(17,14,16),
		SecondaryBackground = Color3.fromRGB(24,18,21),
		Topbar = Color3.fromRGB(20,16,18),
		Accent = Color3.fromRGB(220,70,90),
		Text = Color3.fromRGB(235,235,235),
		SubText = Color3.fromRGB(165,150,155),
		Stroke = Color3.fromRGB(45,28,32)
	},

	Emerald = {
		Background = Color3.fromRGB(13,17,15),
		SecondaryBackground = Color3.fromRGB(18,23,20),
		Topbar = Color3.fromRGB(16,20,18),
		Accent = Color3.fromRGB(60,200,140),
		Text = Color3.fromRGB(235,235,235),
		SubText = Color3.fromRGB(150,165,155),
		Stroke = Color3.fromRGB(28,40,33)
	},

	Violet = {
		Background = Color3.fromRGB(16,14,20),
		SecondaryBackground = Color3.fromRGB(22,19,28),
		Topbar = Color3.fromRGB(18,16,24),
		Accent = Color3.fromRGB(150,95,255),
		Text = Color3.fromRGB(235,235,235),
		SubText = Color3.fromRGB(160,150,170),
		Stroke = Color3.fromRGB(38,30,48)
	},

	Mono = {
		Background = Color3.fromRGB(20,20,20),
		SecondaryBackground = Color3.fromRGB(27,27,27),
		Topbar = Color3.fromRGB(23,23,23),
		Accent = Color3.fromRGB(190,190,190),
		Text = Color3.fromRGB(240,240,240),
		SubText = Color3.fromRGB(145,145,145),
		Stroke = Color3.fromRGB(45,45,45)
	}
}

ThemeManager.Current = table.clone(ThemeManager.Presets.Obsidian)
ThemeManager.Current.Transparency = 0.08
ThemeManager.Current.CornerRadius = UDim.new(0,12)
ThemeManager.Current.WatermarkText = "AetherUI • watermaven"

ThemeManager.RegisteredObjects = {}

function ThemeManager:Get()
	return self.Current
end

function ThemeManager:Register(Object, PropertyName, ThemeKey)
	table.insert(self.RegisteredObjects,{
		Object = Object,
		Property = PropertyName,
		Key = ThemeKey
	})

	if Object and self.Current[ThemeKey] ~= nil then
		Object[PropertyName] = self.Current[ThemeKey]
	end
end

function ThemeManager:LoadPreset(Name)
	local Preset = self.Presets[Name]
	if not Preset then return end

	for Key,Value in pairs(Preset) do
		self.Current[Key] = Value
	end

	self:Refresh()
end

function ThemeManager:SetAccent(NewColor)
	self.Current.Accent = NewColor
	self:Refresh()
end

function ThemeManager:SetTransparency(Value)
	self.Current.Transparency = Value
	self:Refresh()
end

function ThemeManager:SetCornerRadius(Pixel)
	self.Current.CornerRadius = UDim.new(0, Pixel)
end

function ThemeManager:SetWatermark(Text)
	self.Current.WatermarkText = Text
end

function ThemeManager:Refresh()
	for _,Data in ipairs(self.RegisteredObjects) do
		if Data.Object and Data.Object.Parent then
			if self.Current[Data.Key] ~= nil then
				Data.Object[Data.Property] = self.Current[Data.Key]
			end
		end
	end
end

function ThemeManager:ApplyCorner(Object)
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = self.Current.CornerRadius
	Corner.Parent = Object
	return Corner
end

function ThemeManager:ApplyStroke(Object)
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = self.Current.Stroke
	Stroke.Thickness = 1
	Stroke.Transparency = 0.15
	Stroke.Parent = Object
	return Stroke
end

return ThemeManager
