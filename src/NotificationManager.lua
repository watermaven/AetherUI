local Utilities = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/main/src/Utilities.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/watermaven/AetherUI/main/src/ThemeManager.lua"))()

local NotificationManager = {}
local Holder = nil

function NotificationManager:Init(ScreenGui)
	Holder = Instance.new("Frame")
	Holder.Name = "AetherNotifications"
	Holder.Parent = ScreenGui
	Holder.AnchorPoint = Vector2.new(1,0)
	Holder.Position = UDim2.new(1,-15,0,15)
	Holder.Size = UDim2.new(0,320,1,-30)
	Holder.BackgroundTransparency = 1

	local Layout = Instance.new("UIListLayout")
	Layout.Parent = Holder
	Layout.Padding = UDim.new(0,8)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
end

function NotificationManager:Notify(Title, Content, Duration)
	if not Holder then return end

	local Theme = ThemeManager:Get()

	local Card = Utilities:Create("Frame",{
		Parent = Holder,
		Size = UDim2.new(1,0,0,65),
		BackgroundColor3 = Theme.SecondaryBackground,
		BackgroundTransparency = 1
	})

	ThemeManager:ApplyCorner(Card)
	ThemeManager:ApplyStroke(Card)

	local TitleLabel = Utilities:Create("TextLabel",{
		Parent = Card,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,12,0,8),
		Size = UDim2.new(1,-24,0,18),
		Font = Enum.Font.GothamBold,
		Text = Title or "Notification",
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.Text
	})

	local Desc = Utilities:Create("TextLabel",{
		Parent = Card,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,12,0,28),
		Size = UDim2.new(1,-24,0,28),
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		Text = Content or "",
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = Theme.SubText
	})

	Card.Position = UDim2.new(1,40,0,0)

	Utilities:Tween(Card,{
		BackgroundTransparency = Theme.Transparency,
		Position = UDim2.new(0,0,0,0)
	})

	task.delay(Duration or 4,function()
		Utilities:Tween(Card,{
			BackgroundTransparency = 1,
			Position = UDim2.new(1,40,0,0)
		})
		task.wait(0.35)
		Card:Destroy()
	end)
end

return NotificationManager
