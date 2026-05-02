local Utilities = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

Utilities.DefaultTween = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function Utilities:Create(ClassName, Properties)
	local Object = Instance.new(ClassName)
	for Property, Value in pairs(Properties or {}) do
		Object[Property] = Value
	end
	return Object
end

function Utilities:Tween(Object, Properties, TweenInfoData)
	local Tween = TweenService:Create(Object, TweenInfoData or self.DefaultTween, Properties)
	Tween:Play()
	return Tween
end

function Utilities:SafeCallback(Func, ...)
	if typeof(Func) == "function" then
		local Success, ErrorMessage = pcall(Func, ...)
		if not Success then
			warn("[AetherUI Callback Error]:", ErrorMessage)
		end
	end
end

function Utilities:GetTextBounds(Text, Size, Font, Vector)
	return TextService:GetTextSize(Text or "", Size or 14, Font or Enum.Font.Gotham, Vector or Vector2.new(9999,9999))
end

function Utilities:UpdateCanvas(ScrollingFrame, Layout, Padding)
	local function Refresh()
		ScrollingFrame.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + (Padding or 10))
	end
	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Refresh)
	Refresh()
end

function Utilities:ResponsiveScale(Frame, BaseX, BaseY)
	local Camera = workspace.CurrentCamera
	if not Camera then return end

	local Size = Camera.ViewportSize
	local ScaleX = math.clamp(Size.X / 1920, 0.55, 1)
	local ScaleY = math.clamp(Size.Y / 1080, 0.55, 1)

	Frame.Size = UDim2.new(0, BaseX * ScaleX, 0, BaseY * ScaleY)
end

function Utilities:MakeDraggable(DragFrame, MainObject)
	local Dragging = false
	local DragInput
	local MousePos
	local FramePos

	DragFrame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			MousePos = Input.Position
			FramePos = MainObject.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	DragFrame.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos
			MainObject.Position = UDim2.new(
				FramePos.X.Scale,
				FramePos.X.Offset + Delta.X,
				FramePos.Y.Scale,
				FramePos.Y.Offset + Delta.Y
			)
		end
	end)
end

function Utilities:CreateRipple(Button)
	Button.ClipsDescendants = true

	Button.MouseButton1Down:Connect(function(X, Y)
		local Ripple = Instance.new("Frame")
		Ripple.Name = "Ripple"
		Ripple.Parent = Button
		Ripple.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Ripple.BackgroundTransparency = 0.75
		Ripple.BorderSizePixel = 0
		Ripple.AnchorPoint = Vector2.new(0.5,0.5)
		Ripple.Position = UDim2.new(0, X - Button.AbsolutePosition.X, 0, Y - Button.AbsolutePosition.Y)
		Ripple.Size = UDim2.new(0,0,0,0)

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(1,0)
		Corner.Parent = Ripple

		local MaxSize = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2

		self:Tween(Ripple,{
			Size = UDim2.new(0, MaxSize, 0, MaxSize),
			BackgroundTransparency = 1
		}, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

		task.delay(0.5,function()
			Ripple:Destroy()
		end)
	end)
end

function Utilities:AutoResizeTextbox(TextBox, MinHeight)
	local function Update()
		local Bounds = TextService:GetTextSize(
			TextBox.Text,
			TextBox.TextSize,
			TextBox.Font,
			Vector2.new(TextBox.AbsoluteSize.X - 10, 99999)
		)
		TextBox.Size = UDim2.new(TextBox.Size.X.Scale, TextBox.Size.X.Offset, 0, math.max(MinHeight or 30, Bounds.Y + 12))
	end

	TextBox:GetPropertyChangedSignal("Text"):Connect(Update)
	Update()
end

function Utilities:CountLines(Text)
	local Count = 1
	for _ in string.gmatch(Text, "\n") do
		Count += 1
	end
	return Count
end

function Utilities:BindHover(Object, EnterProps, LeaveProps)
	Object.MouseEnter:Connect(function()
		self:Tween(Object, EnterProps)
	end)

	Object.MouseLeave:Connect(function()
		self:Tween(Object, LeaveProps)
	end)
end

function Utilities:LerpColor(Color1, Color2, Alpha)
	return Color3.new(
		Color1.R + (Color2.R - Color1.R) * Alpha,
		Color1.G + (Color2.G - Color1.G) * Alpha,
		Color1.B + (Color2.B - Color1.B) * Alpha
	)
end

function Utilities:HeartbeatLoop(Func)
	RunService.RenderStepped:Connect(function()
		self:SafeCallback(Func)
	end)
end

return Utilities
