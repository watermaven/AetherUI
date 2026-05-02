local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/Utilities.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/ThemeManager.lua"))()
local NotificationManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/NotificationManager.lua"))()
local Components = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/Components.lua"))()
local CodeEditor = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/refs/heads/main/src/CodeEditor.lua"))()

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local WindowEngine = {}

function WindowEngine:CreateWindow(Config)
	local Theme = ThemeManager:Get()

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AetherUI"
	ScreenGui.ResetOnSpawn = false
	pcall(function()
		ScreenGui.Parent = CoreGui
	end)

	NotificationManager:Init(ScreenGui)

	local Main = Utilities:Create("Frame",{
		Parent = ScreenGui,
		Size = UDim2.new(0,720,0,430),
		Position = UDim2.new(0.5,-360,0.5,-215),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = Theme.Transparency
	})

	ThemeManager:ApplyCorner(Main)
	ThemeManager:ApplyStroke(Main)

	if UserInputService.TouchEnabled then
		Main.Size = UDim2.new(0.92,0,0.8,0)
		Main.Position = UDim2.new(0.04,0,0.1,0)
	end

	Utilities:MakeDraggable(Main)

	local Topbar = Utilities:Create("Frame",{
		Parent = Main,
		Size = UDim2.new(1,0,0,34),
		BackgroundColor3 = Theme.Topbar,
		BackgroundTransparency = Theme.Transparency
	})

	ThemeManager:ApplyCorner(Topbar)

	local Title = Utilities:Create("TextLabel",{
		Parent = Topbar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,12,0,0),
		Size = UDim2.new(0.5,0,1,0),
		Font = Enum.Font.GothamBold,
		Text = Config.Name or "AetherUI",
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	local Watermark = Utilities:Create("TextLabel",{
		Parent = Topbar,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,-70,0,0),
		Size = UDim2.new(0,150,1,0),
		Font = Enum.Font.Gotham,
		Text = Theme.WatermarkText,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextColor3 = Theme.SubText
	})

	local Minimize = Utilities:Create("TextButton",{
		Parent = Topbar,
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.new(1,-10,0.5,-10),
		Size = UDim2.new(0,20,0,20),
		BackgroundTransparency = 1,
		Text = "—",
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Theme.Text
	})

	local Sidebar = Utilities:Create("Frame",{
		Parent = Main,
		Position = UDim2.new(0,10,0,44),
		Size = UDim2.new(0,150,1,-54),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = Theme.Transparency
	})

	ThemeManager:ApplyCorner(Sidebar)
	ThemeManager:ApplyStroke(Sidebar)

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0,6)
	SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local ContentHolder = Utilities:Create("Frame",{
		Parent = Main,
		Position = UDim2.new(0,170,0,44),
		Size = UDim2.new(1,-180,1,-54),
		BackgroundTransparency = 1
	})

	local Tabs = {}
	local CurrentTab = nil

	local Floating = Utilities:Create("TextButton",{
		Parent = ScreenGui,
		Visible = false,
		Size = UDim2.new(0,44,0,44),
		Position = UDim2.new(0,20,0.5,-22),
		BackgroundColor3 = Theme.Accent,
		Text = "A",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(255,255,255),
		AutoButtonColor = false
	})

	local FC = Instance.new("UICorner")
	FC.CornerRadius = UDim.new(1,0)
	FC.Parent = Floating

	Minimize.MouseButton1Click:Connect(function()
		Main.Visible = false
		Floating.Visible = true
	end)

	Floating.MouseButton1Click:Connect(function()
		Main.Visible = true
		Floating.Visible = false
	end)

	local Window = {}

	function Window:Notify(a,b,c)
		NotificationManager:Notify(a,b,c)
	end

	function Window:CreateTab(TabName)
		local Theme = ThemeManager:Get()

		local TabButton = Utilities:Create("TextButton",{
			Parent = Sidebar,
			Size = UDim2.new(1,-12,0,30),
			BackgroundColor3 = Theme.Background,
			BackgroundTransparency = Theme.Transparency,
			Text = TabName,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Theme.Text,
			AutoButtonColor = false
		})

		ThemeManager:ApplyCorner(TabButton)

		local Page = Utilities:Create("ScrollingFrame",{
			Parent = ContentHolder,
			Visible = false,
			Size = UDim2.new(1,0,1,0),
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarThickness = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})

		local Layout = Instance.new("UIListLayout")
		Layout.Parent = Page
		Layout.Padding = UDim.new(0,6)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
		end)

		local function OpenThis()
			for _,tb in pairs(Tabs) do
				tb.Page.Visible = false
			end
			Page.Visible = true
			CurrentTab = Page
		end

		TabButton.MouseButton1Click:Connect(OpenThis)

		if not CurrentTab then
			OpenThis()
		end

		local TabAPI = {}

		function TabAPI:CreateSection(t)
			return Components:CreateSection(Page,t)
		end

		function TabAPI:CreateParagraph(t,d)
			return Components:CreateParagraph(Page,t,d)
		end

		function TabAPI:CreateButton(t,c)
			return Components:CreateButton(Page,t,c)
		end

		function TabAPI:CreateToggle(t,d,c)
			return Components:CreateToggle(Page,t,d,c)
		end

		function TabAPI:CreateTextbox(p,c)
			return Components:CreateTextbox(Page,p,c)
		end

		function TabAPI:CreateSlider(t,min,max,def,c)
			return Components:CreateSlider(Page,t,min,max,def,c)
		end

		function TabAPI:CreateDropdown(t,o,c)
			return Components:CreateDropdown(Page,t,o,c)
		end

		function TabAPI:CreateKeybind(t,k,c)
			return Components:CreateKeybind(Page,t,k,c)
		end

		function TabAPI:CreateConsole()
			return Components:CreateConsole(Page)
		end

		function TabAPI:CreateCodeEditor()
			return CodeEditor:Create(Page)
		end

		table.insert(Tabs,{
			Button = TabButton,
			Page = Page
		})

		return TabAPI
	end

	return Window
end

return WindowEngine
