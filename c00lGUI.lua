--[[

c00lLibrary v1.2

STILL A WIP AND IN BETA

]]

local CoolGUI = {}

local function create(instanceType, props)
	local inst = Instance.new(instanceType)
	for prop, val in pairs(props) do
		inst[prop] = val
	end
	return inst
end

function CoolGUI:CreateWindow(title)
	local screen = create("ScreenGui", {
		Name = "c00lkiddGUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
	})

	local frame = create("Frame", {
		Size = UDim2.new(0, 350, 0, 300),
		Position = UDim2.new(0.5, -175, 0.5, -150),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderColor3 = Color3.fromRGB(255, 0, 0),
		BorderSizePixel = 3,
		Name = "Main",
		Draggable = true,
		Active = true,
		Parent = screen
	})

	local titleLabel = create("TextLabel", {
		Text = title,
		Size = UDim2.new(1, -60, 0, 30),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSans,
		TextScaled = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})

	local closeBtn = create("TextButton", {
		Text = "X",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -30, 0, 0),
		BackgroundColor3 = Color3.fromRGB(60, 0, 0),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Code,
		TextScaled = true,
		Parent = frame
	})
	closeBtn.MouseButton1Click:Connect(function()
		screen:Destroy()
	end)

	local minimizeBtn = create("TextButton", {
		Text = "-",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -60, 0, 0),
		BackgroundColor3 = Color3.fromRGB(30, 30, 0),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSans,
		TextScaled = true,
		Parent = frame
	})

	local scroll = create("ScrollingFrame", {
		Name = "Container",
		Size = UDim2.new(1, -10, 1, -40),
		Position = UDim2.new(0, 5, 0, 35),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 4,
		BackgroundTransparency = 1,
		Parent = frame
	})

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = scroll

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 5)
	end)

	local minimized = false
	minimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		scroll.Visible = not minimized
		frame.Size = minimized and UDim2.new(0, 350, 0, 35) or UDim2.new(0, 350, 0, 300)
	end)

	return {
		ScreenGui = screen,
		Frame = frame,
		Container = scroll
	}
end

function CoolGUI:AddButton(parent, text, callback)
	local button = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderColor3 = Color3.fromRGB(255, 0, 0),
		Text = text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSans,
		TextScaled = true,
		Parent = parent
	})
	button.MouseButton1Click:Connect(callback)
	return button
end

function CoolGUI:AddInput(parent, placeholder, callback)
	local box = create("TextBox", {
		Size = UDim2.new(1, 0, 0, 35),
		PlaceholderText = placeholder,
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderColor3 = Color3.fromRGB(255, 0, 0),
		Text = "",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSans,
		TextScaled = true,
		ClearTextOnFocus = false,
		Parent = parent
	})
	box.FocusLost:Connect(function(enter)
		if enter then callback(box.Text) end
	end)
	return box
end

function CoolGUI:AddSlider(parent, title, min, max, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 50)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = title .. ": " .. min
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.SourceSans
	label.TextScaled = true
	label.Parent = frame

	local sliderBar = Instance.new("Frame")
	sliderBar.Size = UDim2.new(1, 0, 0, 15)
	sliderBar.Position = UDim2.new(0, 0, 0, 30)
	sliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	sliderBar.BorderColor3 = Color3.fromRGB(255, 0, 0)
	sliderBar.Parent = frame

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	fill.BorderSizePixel = 0
	fill.Parent = sliderBar

	local UserInputService = game:GetService("UserInputService")
	local dragging = false

	local function updateValueFromX(x)
		local rel = math.clamp((x - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + (max - min) * rel)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		label.Text = title .. ": " .. value
		callback(value)
	end

	local function startDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateValueFromX(input.Position.X)

			local main = parent:FindFirstAncestor("Main")
			if main then main.Draggable = false end

			local moveConn, endConn

			moveConn = UserInputService.InputChanged:Connect(function(moveInput)
				if (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) and dragging then
					updateValueFromX(moveInput.Position.X)
				end
			end)

			endConn = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
					dragging = false
					moveConn:Disconnect()
					endConn:Disconnect()
					if main then main.Draggable = true end
				end
			end)
		end
	end

	sliderBar.InputBegan:Connect(startDrag)

	return sliderBar
end

function CoolGUI:AddToggle(parent, labelText, callback)
	local toggle = false
	local button = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 35),
		Text = labelText .. ": OFF",
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderColor3 = Color3.fromRGB(255, 0, 0),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSans,
		TextScaled = true,
		Parent = parent
	})
	button.MouseButton1Click:Connect(function()
		toggle = not toggle
		button.Text = labelText .. ": " .. (toggle and "ON" or "OFF")
		callback(toggle)
	end)
	return button
end

function CoolGUI:AddDropdown(parent, title, options, callback)
	local open = false
	local container = create("Frame", {
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderColor3 = Color3.fromRGB(255, 0, 0),
		ClipsDescendants = true,
		Parent = parent
	})

	local main = create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		Text = title .. " ▼",
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSans,
		TextScaled = true,
		Parent = container
	})

	local function toggleDropdown()
		open = not open
		container.Size = UDim2.new(1, 0, 0, open and (#options + 1) * 35 or 35)
		main.Text = title .. (open and " ▲" or " ▼")
	end

	main.MouseButton1Click:Connect(toggleDropdown)

	for i, item in ipairs(options) do
		local btn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 35),
			Position = UDim2.new(0, 0, 0, 35 * i),
			Text = item,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderColor3 = Color3.fromRGB(255, 0, 0),
			Font = Enum.Font.SourceSans,
			TextScaled = true,
			Parent = container
		})
		btn.MouseButton1Click:Connect(function()
			toggleDropdown()
			callback(item)
		end)
	end

	return container
end

return CoolGUI
