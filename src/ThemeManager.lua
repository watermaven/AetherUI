local ThemeManager = {}

ThemeManager.Current = {
	Background = Color3.fromRGB(15,15,18),
	SecondaryBackground = Color3.fromRGB(21,21,25),
	Topbar = Color3.fromRGB(18,18,22),
	Accent = Color3.fromRGB(114,137,255),
	Text = Color3.fromRGB(235,235,235),
	SubText = Color3.fromRGB(150,150,155),
	Stroke = Color3.fromRGB(35,35,40),
	Transparency = 0.08,
	CornerRadius = UDim.new(0,12),
	WatermarkText = "AetherUI • watermaven"
}

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
