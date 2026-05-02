local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/Utilities.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/ThemeManager.lua"))()
local NotificationManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/NotificationManager.lua"))()
local UserInputService = game:GetService("UserInputService")

local Components = {}

function Components:CreateSection(Parent, Title)
	local Theme = ThemeManager:Get()

	local Section = Utilities:Create("Frame",{
		Parent = Parent,
		BackgroundTransparency = 1,
		Size = UDim2.new(1,-10,0,28)
	})

	Utilities:Create("TextLabel",{
		Parent = Section,
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,1,0),
		Font = Enum.Font.GothamBold,
		Text = Title or "Section",
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	return Section
end

function Components:CreateParagraph(Parent, Title, Desc)
	local Theme = ThemeManager:Get()

	local Holder = Utilities:Create("Frame",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,58),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency
	})

	ThemeManager:ApplyCorner(Holder)
	ThemeManager:ApplyStroke(Holder)

	Utilities:Create("TextLabel",{
		Parent = Holder,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,10,0,6),
		Size = UDim2.new(1,-20,0,18),
		Font = Enum.Font.GothamBold,
		Text = Title or "Paragraph",
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	Utilities:Create("TextLabel",{
		Parent = Holder,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,10,0,24),
		Size = UDim2.new(1,-20,0,28),
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		Text = Desc or "",
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = Theme.SubText
	})

	return Holder
end

function Components:CreateButton(Parent, Text, Callback)
	local Theme = ThemeManager:Get()

	local Button = Utilities:Create("TextButton",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,34),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency,
		Text = "",
		AutoButtonColor = false
	})

	ThemeManager:ApplyCorner(Button)
	ThemeManager:ApplyStroke(Button)
	Utilities:CreateRipple(Button)

	local Label = Utilities:Create("TextLabel",{
		Parent = Button,
		BackgroundTransparency = 1,
		Size = UDim2.new(1,-14,1,0),
		Position = UDim2.new(0,14,0,0),
		Font = Enum.Font.Gotham,
		Text = Text or "Button",
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	Button.MouseButton1Click:Connect(function()
		Utilities:SafeCallback(Callback)
	end)

	return Button
end

function Components:CreateToggle(Parent, Text, Default, Callback)
	local Theme = ThemeManager:Get()
	local State = Default or false

	local Holder = Utilities:Create("TextButton",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,34),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency,
		Text = "",
		AutoButtonColor = false
	})

	ThemeManager:ApplyCorner(Holder)
	ThemeManager:ApplyStroke(Holder)

	Utilities:Create("TextLabel",{
		Parent = Holder,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,12,0,0),
		Size = UDim2.new(1,-60,1,0),
		Font = Enum.Font.Gotham,
		Text = Text or "Toggle",
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	local ToggleBack = Utilities:Create("Frame",{
		Parent = Holder,
		AnchorPoint = Vector2.new(1,0.5),
		Position = UDim2.new(1,-12,0.5,0),
		Size = UDim2.new(0,32,0,16),
		BackgroundColor3 = Theme.Stroke
	})

	ThemeManager:ApplyCorner(ToggleBack)

	local Knob = Utilities:Create("Frame",{
		Parent = ToggleBack,
		Position = UDim2.new(0,2,0.5,-6),
		Size = UDim2.new(0,12,0,12),
		BackgroundColor3 = Color3.fromRGB(255,255,255)
	})

	local KC = Instance.new("UICorner")
	KC.CornerRadius = UDim.new(1,0)
	KC.Parent = Knob

	local function Refresh()
		if State then
			Utilities:Tween(ToggleBack,{BackgroundColor3 = Theme.Accent})
			Utilities:Tween(Knob,{Position = UDim2.new(1,-14,0.5,-6)})
		else
			Utilities:Tween(ToggleBack,{BackgroundColor3 = Theme.Stroke})
			Utilities:Tween(Knob,{Position = UDim2.new(0,2,0.5,-6)})
		end
		Utilities:SafeCallback(Callback, State)
	end

	Holder.MouseButton1Click:Connect(function()
		State = not State
		Refresh()
	end)

	Refresh()
	return Holder
end

function Components:CreateTextbox(Parent, Placeholder, Callback)
	local Theme = ThemeManager:Get()

	local Box = Utilities:Create("TextBox",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,34),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency,
		ClearTextOnFocus = false,
		PlaceholderText = Placeholder or "Enter text...",
		Text = "",
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextColor3 = Theme.Text,
		PlaceholderColor3 = Theme.SubText
	})

	ThemeManager:ApplyCorner(Box)
	ThemeManager:ApplyStroke(Box)

	Box.FocusLost:Connect(function()
		Utilities:SafeCallback(Callback, Box.Text)
	end)

	return Box
end

function Components:CreateSlider(Parent, Text, Min, Max, Default, Callback)
	local Theme = ThemeManager:Get()
	local Value = Default or Min

	local Holder = Utilities:Create("Frame",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,46),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency
	})

	ThemeManager:ApplyCorner(Holder)
	ThemeManager:ApplyStroke(Holder)

	local Label = Utilities:Create("TextLabel",{
		Parent = Holder,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,10,0,5),
		Size = UDim2.new(1,-20,0,14),
		Font = Enum.Font.Gotham,
		Text = (Text or "Slider").." : "..tostring(Value),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	local Bar = Utilities:Create("Frame",{
		Parent = Holder,
		Position = UDim2.new(0,10,0,28),
		Size = UDim2.new(1,-20,0,6),
		BackgroundColor3 = Theme.Stroke
	})

	ThemeManager:ApplyCorner(Bar)

	local Fill = Utilities:Create("Frame",{
		Parent = Bar,
		Size = UDim2.new((Value-Min)/(Max-Min),0,1,0),
		BackgroundColor3 = Theme.Accent
	})

	ThemeManager:ApplyCorner(Fill)

	local Dragging = false

	Bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if Dragging then
			local Percent = math.clamp((i.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
			Value = math.floor((Min + ((Max-Min)*Percent)) + 0.5)
			Fill.Size = UDim2.new(Percent,0,1,0)
			Label.Text = (Text or "Slider").." : "..tostring(Value)
			Utilities:SafeCallback(Callback, Value)
		end
	end)

	return Holder
end

function Components:CreateDropdown(Parent, Text, Options, Callback)
	local Theme = ThemeManager:Get()
	local Open = false

	local Holder = Utilities:Create("Frame",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,34),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency,
		ClipsDescendants = true
	})

	ThemeManager:ApplyCorner(Holder)
	ThemeManager:ApplyStroke(Holder)

	local Main = Utilities:Create("TextButton",{
		Parent = Holder,
		Size = UDim2.new(1,0,0,34),
		Text = "",
		BackgroundTransparency = 1
	})

	local Label = Utilities:Create("TextLabel",{
		Parent = Main,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,10,0,0),
		Size = UDim2.new(1,-20,1,0),
		Font = Enum.Font.Gotham,
		Text = Text or "Dropdown",
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	local ListLayoutY = 34

	for _,Option in ipairs(Options or {}) do
		local Opt = Utilities:Create("TextButton",{
			Parent = Holder,
			Position = UDim2.new(0,0,0,ListLayoutY),
			Size = UDim2.new(1,0,0,28),
			Text = Option,
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Theme.SubText
		})

		Opt.MouseButton1Click:Connect(function()
			Label.Text = (Text or "Dropdown")..": "..Option
			Open = false
			Utilities:Tween(Holder,{Size = UDim2.new(1,-10,0,34)})
			Utilities:SafeCallback(Callback, Option)
		end)

		ListLayoutY += 28
	end

	Main.MouseButton1Click:Connect(function()
		Open = not Open
		if Open then
			Utilities:Tween(Holder,{Size = UDim2.new(1,-10,0,ListLayoutY)})
		else
			Utilities:Tween(Holder,{Size = UDim2.new(1,-10,0,34)})
		end
	end)

	return Holder
end

function Components:CreateKeybind(Parent, Text, DefaultKey, Callback)
	local Theme = ThemeManager:Get()
	local CurrentKey = DefaultKey or Enum.KeyCode.RightShift

	local Button = Utilities:Create("TextButton",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,34),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency,
		Text = "",
		AutoButtonColor = false
	})

	ThemeManager:ApplyCorner(Button)
	ThemeManager:ApplyStroke(Button)

	local Label = Utilities:Create("TextLabel",{
		Parent = Button,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,10,0,0),
		Size = UDim2.new(1,-20,1,0),
		Font = Enum.Font.Gotham,
		Text = (Text or "Keybind").." : "..CurrentKey.Name,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	local Listening = false

	Button.MouseButton1Click:Connect(function()
		Listening = true
		Label.Text = (Text or "Keybind").." : ..."
	end)

	UserInputService.InputBegan:Connect(function(Input, GPE)
		if GPE then return end

		if Listening and Input.KeyCode ~= Enum.KeyCode.Unknown then
			CurrentKey = Input.KeyCode
			Label.Text = (Text or "Keybind").." : "..CurrentKey.Name
			Listening = false
		elseif Input.KeyCode == CurrentKey then
			Utilities:SafeCallback(Callback)
		end
	end)

	return Button
end

function Components:CreateConsole(Parent)
	local Theme = ThemeManager:Get()

	local Box = Utilities:Create("TextBox",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,120),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency,
		Text = "",
		ClearTextOnFocus = false,
		MultiLine = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = 12,
		Font = Enum.Font.Code,
		TextColor3 = Theme.Text
	})

	ThemeManager:ApplyCorner(Box)
	ThemeManager:ApplyStroke(Box)

	return {
		Object = Box,
		Log = function(_,Text)
			Box.Text = Box.Text .. tostring(Text) .. "\n"
		end,
		Clear = function(_)
			Box.Text = ""
		end
	}
end

return Components
