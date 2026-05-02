local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/Utilities.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/ThemeManager.lua"))()
local NotificationManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/NotificationManager.lua"))()

local CodeEditor = {}

function CodeEditor:Create(Parent)
	local Theme = ThemeManager:Get()

	local Holder = Utilities:Create("Frame",{
		Parent = Parent,
		Size = UDim2.new(1,-10,0,260),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency
	})

	ThemeManager:ApplyCorner(Holder)
	ThemeManager:ApplyStroke(Holder)

	local FileTitle = Utilities:Create("TextBox",{
		Parent = Holder,
		Position = UDim2.new(0,10,0,8),
		Size = UDim2.new(0.45,0,0,24),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = Theme.Transparency,
		Text = "script1.lua",
		ClearTextOnFocus = false,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextColor3 = Theme.Text
	})

	ThemeManager:ApplyCorner(FileTitle)

	local ButtonNames = {"Save","Load","Clear","Execute"}
	local Buttons = {}

	for i,Name in ipairs(ButtonNames) do
		local Btn = Utilities:Create("TextButton",{
			Parent = Holder,
			Size = UDim2.new(0,52,0,24),
			Position = UDim2.new(1,-((5-i)*56)-10,0,8),
			BackgroundColor3 = Theme.Background,
			BackgroundTransparency = Theme.Transparency,
			Text = Name,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = Theme.Text,
			AutoButtonColor = false
		})

		ThemeManager:ApplyCorner(Btn)
		ThemeManager:ApplyStroke(Btn)
		Utilities:CreateRipple(Btn)

		Buttons[Name] = Btn
	end

	local LineBox = Utilities:Create("TextLabel",{
		Parent = Holder,
		Position = UDim2.new(0,10,0,42),
		Size = UDim2.new(0,34,1,-52),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = Theme.Transparency,
		Font = Enum.Font.Code,
		Text = "1",
		TextSize = 12,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextColor3 = Theme.SubText
	})

	ThemeManager:ApplyCorner(LineBox)

	local ScriptBox = Utilities:Create("TextBox",{
		Parent = Holder,
		Position = UDim2.new(0,48,0,42),
		Size = UDim2.new(1,-58,1,-52),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = Theme.Transparency,
		ClearTextOnFocus = false,
		MultiLine = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = "-- AetherUI Code Workspace\n",
		TextSize = 12,
		Font = Enum.Font.Code,
		TextColor3 = Theme.Text,
		TextWrapped = false
	})

	ThemeManager:ApplyCorner(ScriptBox)
	ThemeManager:ApplyStroke(ScriptBox)

	local function UpdateLines()
		local Count = Utilities:CountLines(ScriptBox.Text)
		local Buffer = ""
		for i = 1, Count do
			Buffer = Buffer .. tostring(i) .. "\n"
		end
		LineBox.Text = Buffer
	end

	ScriptBox:GetPropertyChangedSignal("Text"):Connect(UpdateLines)
	UpdateLines()

	Buttons.Save.MouseButton1Click:Connect(function()
		if writefile then
			writefile(FileTitle.Text, ScriptBox.Text)
			NotificationManager:Notify("Code Editor","Saved "..FileTitle.Text,3)
		else
			NotificationManager:Notify("Code Editor","Executor filesystem may not support writefile.",4)
		end
	end)

	Buttons.Load.MouseButton1Click:Connect(function()
		if readfile and isfile then
			if isfile(FileTitle.Text) then
				ScriptBox.Text = readfile(FileTitle.Text)
				UpdateLines()
				NotificationManager:Notify("Code Editor","Loaded "..FileTitle.Text,3)
			else
				NotificationManager:Notify("Code Editor","File does not exist.",3)
			end
		else
			NotificationManager:Notify("Code Editor","Executor filesystem may not support readfile.",4)
		end
	end)

	Buttons.Clear.MouseButton1Click:Connect(function()
		ScriptBox.Text = ""
		UpdateLines()
	end)

	Buttons.Execute.MouseButton1Click:Connect(function()
		NotificationManager:Notify("Execute Placeholder","WindowEngine will later connect this to loadstring executor.",4)
	end)

	return {
		Object = Holder,
		Editor = ScriptBox,
		FileName = FileTitle
	}
end

return CodeEditor
