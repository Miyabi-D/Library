--[[

    Milenium Library
    -> Made by @finobe
    -> Modified by @miyabi.d 
    -> Kind of got bored idk what to do with life
    -> Idk who or why this got leaked, ui was VERY popular and high in demand with customers
]]

-- Variables
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local ws = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local http_service = game:GetService("HttpService")
local gui_service = game:GetService("GuiService")
local lighting = game:GetService("Lighting")
local run = game:GetService("RunService")
local stats = game:GetService("Stats")
local coregui = gethui and gethui() or game:GetService("CoreGui")
local debris = game:GetService("Debris")
local tween_service = game:GetService("TweenService")
local sound_service = game:GetService("SoundService")

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new
local rect = Rect.new
local cfr = CFrame.new
local empty_cfr = cfr()
local point_object_space = empty_cfr.PointToObjectSpace
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset

local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer
local mouse = lp:GetMouse()
local gui_offset = gui_service:GetGuiInset().Y

local max = math.max
local floor = math.floor
local min = math.min
local abs = math.abs
local noise = math.noise
local rad = math.rad
local random = math.random
local pow = math.pow
local sin = math.sin
local pi = math.pi
local tan = math.tan
local atan2 = math.atan2
local clamp = math.clamp

local insert = table.insert
local find = table.find
local remove = table.remove
local concat = table.concat
--

-- Library init
getgenv().library = {
	directory = "milenium",
	folders = {
		"/fonts",
		"/configs",
	},
	flags = {},
	config_flags = {},
	connections = {},
	notifications = { notifs = {} },
	current_open,
}

local themes = {
	preset = {
		accent = rgb(226, 14, 104),
	},

	utility = {
		accent = {
			BackgroundColor3 = {},
			TextColor3 = {},
			ImageColor3 = {},
			ScrollBarImageColor3 = {},
		},
	},

	gradients = {},
}

local keys = {
	[Enum.KeyCode.LeftShift] = "LS",
	[Enum.KeyCode.RightShift] = "RS",
	[Enum.KeyCode.LeftControl] = "LC",
	[Enum.KeyCode.RightControl] = "RC",
	[Enum.KeyCode.Insert] = "INS",
	[Enum.KeyCode.Backspace] = "BS",
	[Enum.KeyCode.Return] = "Ent",
	[Enum.KeyCode.LeftAlt] = "LA",
	[Enum.KeyCode.RightAlt] = "RA",
	[Enum.KeyCode.CapsLock] = "CAPS",
	[Enum.KeyCode.One] = "1",
	[Enum.KeyCode.Two] = "2",
	[Enum.KeyCode.Three] = "3",
	[Enum.KeyCode.Four] = "4",
	[Enum.KeyCode.Five] = "5",
	[Enum.KeyCode.Six] = "6",
	[Enum.KeyCode.Seven] = "7",
	[Enum.KeyCode.Eight] = "8",
	[Enum.KeyCode.Nine] = "9",
	[Enum.KeyCode.Zero] = "0",
	[Enum.KeyCode.KeypadOne] = "Num1",
	[Enum.KeyCode.KeypadTwo] = "Num2",
	[Enum.KeyCode.KeypadThree] = "Num3",
	[Enum.KeyCode.KeypadFour] = "Num4",
	[Enum.KeyCode.KeypadFive] = "Num5",
	[Enum.KeyCode.KeypadSix] = "Num6",
	[Enum.KeyCode.KeypadSeven] = "Num7",
	[Enum.KeyCode.KeypadEight] = "Num8",
	[Enum.KeyCode.KeypadNine] = "Num9",
	[Enum.KeyCode.KeypadZero] = "Num0",
	[Enum.KeyCode.Minus] = "-",
	[Enum.KeyCode.Equals] = "=",
	[Enum.KeyCode.Tilde] = "~",
	[Enum.KeyCode.LeftBracket] = "[",
	[Enum.KeyCode.RightBracket] = "]",
	[Enum.KeyCode.RightParenthesis] = ")",
	[Enum.KeyCode.LeftParenthesis] = "(",
	[Enum.KeyCode.Semicolon] = ",",
	[Enum.KeyCode.Quote] = "'",
	[Enum.KeyCode.BackSlash] = "\\",
	[Enum.KeyCode.Comma] = ",",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Slash] = "/",
	[Enum.KeyCode.Asterisk] = "*",
	[Enum.KeyCode.Plus] = "+",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Backquote] = "`",
	[Enum.UserInputType.MouseButton1] = "MB1",
	[Enum.UserInputType.MouseButton2] = "MB2",
	[Enum.UserInputType.MouseButton3] = "MB3",
	[Enum.KeyCode.Escape] = "ESC",
	[Enum.KeyCode.Space] = "SPC",
}

library.__index = library

for _, path in next, library.folders do
	makefolder(library.directory .. path)
end

local flags = library.flags
local config_flags = library.config_flags
local notifications = library.notifications

local fonts = {}
do
	function Register_Font(Name, Weight, Style, Asset)
		if not isfile(Asset.Id) then
			writefile(Asset.Id, Asset.Font)
		end

		if isfile(Name .. ".font") then
			delfile(Name .. ".font")
		end

		local Data = {
			name = Name,
			faces = {
				{
					name = "Normal",
					weight = Weight,
					style = Style,
					assetId = getcustomasset(Asset.Id),
				},
			},
		}

		writefile(Name .. ".font", http_service:JSONEncode(Data))

		return getcustomasset(Name .. ".font")
	end

	local Medium = Register_Font("Medium", 200, "Normal", {
		Id = "Medium.ttf",
		Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
	})

	local SemiBold = Register_Font("SemiBold", 200, "Normal", {
		Id = "SemiBold.ttf",
		Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"),
	})

	fonts = {
		small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	}
end
--

-- Library functions
-- Misc functions
function library:tween(obj, properties, easing_style, time)
	local tween = tween_service
		:Create(
			obj,
			TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0),
			properties
		)
		:Play()

	return tween
end

function library:resizify(frame)
	local Frame = Instance.new("TextButton")
	Frame.Position = dim2(1, -10, 1, -10)
	Frame.BorderColor3 = rgb(0, 0, 0)
	Frame.Size = dim2(0, 10, 0, 10)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = rgb(255, 255, 255)
	Frame.Parent = frame
	Frame.BackgroundTransparency = 1
	Frame.Text = ""

	local resizing = false
	local start_size
	local start
	local og_size = frame.Size

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			start = input.Position
			start_size = frame.Size
		end
	end)

	Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end)

	library:connection(uis.InputChanged, function(input, game_event)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local viewport_x = camera.ViewportSize.X
			local viewport_y = camera.ViewportSize.Y

			local current_size = dim2(
				start_size.X.Scale,
				math.clamp(start_size.X.Offset + (input.Position.X - start.X), og_size.X.Offset, viewport_x),
				start_size.Y.Scale,
				math.clamp(start_size.Y.Offset + (input.Position.Y - start.Y), og_size.Y.Offset, viewport_y)
			)

			library:tween(frame, { Size = current_size }, Enum.EasingStyle.Linear, 0.05)
		end
	end)
end

function fag(tbl)
	local Size = 0

	for _ in tbl do
		Size = Size + 1
	end

	return Size
end

function library:next_flag()
	local index = fag(library.flags) + 1
	local str = string.format("flagnumber%s", index)

	return str
end

function library:mouse_in_frame(uiobject)
	local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y
		and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
	local x_cond = uiobject.AbsolutePosition.X <= mouse.X
		and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

	return (y_cond and x_cond)
end

function library:draggify(frame)
	local dragging = false
	local start_size = frame.Position
	local start

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			start = input.Position
			start_size = frame.Position
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	library:connection(uis.InputChanged, function(input, game_event)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local viewport_x = camera.ViewportSize.X
			local viewport_y = camera.ViewportSize.Y

			local current_position = dim2(
				0,
				clamp(start_size.X.Offset + (input.Position.X - start.X), 0, viewport_x - frame.Size.X.Offset),
				0,
				math.clamp(start_size.Y.Offset + (input.Position.Y - start.Y), 0, viewport_y - frame.Size.Y.Offset)
			)

			library:tween(frame, { Position = current_position }, Enum.EasingStyle.Linear, 0.05)
			library:close_element()
		end
	end)
end

function library:convert(str)
	local values = {}

	for value in string.gmatch(str, "[^,]+") do
		insert(values, tonumber(value))
	end

	if #values == 4 then
		return unpack(values)
	else
		return
	end
end

function library:convert_enum(enum)
	local enum_parts = {}

	for part in string.gmatch(enum, "[%w_]+") do
		insert(enum_parts, part)
	end

	local enum_table = Enum
	for i = 2, #enum_parts do
		local enum_item = enum_table[enum_parts[i]]

		enum_table = enum_item
	end

	return enum_table
end

local config_holder
function library:update_config_list()
	if not config_holder then
		return
	end

	local list = {}

	for idx, file in listfiles(library.directory .. "/configs") do
		local name = file:gsub(library.directory .. "/configs\\", "")
			:gsub(".cfg", "")
			:gsub(library.directory .. "\\configs\\", "")
		list[#list + 1] = name
	end

	config_holder.refresh_options(list)
end

function library:get_config()
	local Config = {}

	for _, v in next, flags do
		if type(v) == "table" and v.key then
			Config[_] = { active = v.active, mode = v.mode, key = tostring(v.key) }
		elseif type(v) == "table" and v["Transparency"] and v["Color"] then
			Config[_] = { Transparency = v["Transparency"], Color = v["Color"]:ToHex() }
		else
			Config[_] = v
		end
	end

	return http_service:JSONEncode(Config)
end

function library:load_config(config_json)
	local config = http_service:JSONDecode(config_json)

	for _, v in config do
		local function_set = library.config_flags[_]

		if _ == "config_name_list" then
			continue
		end

		if function_set then
			if type(v) == "table" and v["Transparency"] and v["Color"] then
				function_set(hex(v["Color"]), v["Transparency"])
			elseif type(v) == "table" and v["active"] then
				function_set(v)
			else
				function_set(v)
			end
		end
	end
end

function library:round(number, float)
	local multiplier = 1 / (float or 1)

	return floor(number * multiplier + 0.5) / multiplier
end

function library:apply_theme(instance, theme, property)
	insert(themes.utility[theme][property], instance)
end

function library:accent_sequence()
	local accent = themes.preset.accent

	return rgbseq({
		rgbkey(0, accent),
		rgbkey(1, rgb(accent.R * 255 * 0.72, accent.G * 255 * 0.72, accent.B * 255 * 0.72)),
	})
end

function library:accent_gradient(gradient)
	insert(themes.gradients, gradient)

	gradient.Color = library:accent_sequence()

	return gradient
end

function library:update_theme(theme, color)
	for _, property in themes.utility[theme] do
		for m, object in property do
			if object[_] == themes.preset[theme] then
				object[_] = color
			end
		end
	end

	themes.preset[theme] = color

	for _, gradient in themes.gradients do
		gradient.Color = library:accent_sequence()
	end
end

function library:connection(signal, callback)
	local connection = signal:Connect(callback)

	insert(library.connections, connection)

	return connection
end

function library:close_element(new_path)
	local open_element = library.current_open

	if open_element and new_path ~= open_element then
		open_element.set_visible(false)
		open_element.open = false
	end

	if new_path ~= open_element then
		library.current_open = new_path or nil
	end
end

function library:create(instance, options)
	local ins = Instance.new(instance)

	for prop, value in options do
		ins[prop] = value
	end

	return ins
end

function library:unload_menu()
	if library["items"] then
		library["items"]:Destroy()
	end

	if library["other"] then
		library["other"]:Destroy()
	end

	for index, connection in library.connections do
		connection:Disconnect()
		connection = nil
	end

	library = nil
end
--

-- Library element functions
function library:window(properties)
	local cfg = {
		suffix = properties.suffix or properties.Suffix or "tech",
		name = properties.name or properties.Name or "nebula",
		game_name = properties.gameInfo
			or properties.game_info
			or properties.GameInfo
			or "Milenium for Counter-Strike: Global Offensive",
		size = properties.size or properties.Size or dim2(0, 700, 0, 565),
		selected_tab,
		items = {},

		tween,
	}

	library["items"] = library:create("ScreenGui", {
		Parent = coregui,
		Name = "\0",
		Enabled = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		IgnoreGuiInset = true,
	})

	library["other"] = library:create("ScreenGui", {
		Parent = coregui,
		Name = "\0",
		Enabled = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
	})

	local items = cfg.items
	do
		items["main"] = library:create("Frame", {
			Parent = library["items"],
			Size = cfg.size,
			Name = "\0",
			Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(15, 15, 15),
		})
		items["main"].Position = dim2(0, items["main"].AbsolutePosition.X, 0, items["main"].AbsolutePosition.Y)

		library:create("UICorner", {
			Parent = items["main"],
			CornerRadius = dim(0, 10),
		})

		library:create("UIStroke", {
			Color = rgb(32, 32, 32),
			Parent = items["main"],
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		items["side_frame"] = library:create("Frame", {
			Parent = items["main"],
			BackgroundTransparency = 1,
			Name = "\0",
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 196, 1, -25),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(15, 15, 15),
		})

		library:create("Frame", {
			AnchorPoint = vec2(1, 0),
			Parent = items["side_frame"],
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 1, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(23, 23, 23),
		})

		items["button_holder"] = library:create("Frame", {
			Parent = items["side_frame"],
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 0, 0, 56),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 1, -56),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		cfg.button_holder = items["button_holder"]

		library:create("UIListLayout", {
			Parent = items["button_holder"],
			Padding = dim(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		library:create("UIPadding", {
			PaddingTop = dim(0, 12),
			PaddingBottom = dim(0, 24),
			Parent = items["button_holder"],
			PaddingRight = dim(0, 11),
			PaddingLeft = dim(0, 10),
		})

		local accent = themes.preset.accent
		items["title"] = library:create("TextLabel", {
			FontFace = fonts.font,
			BorderColor3 = rgb(0, 0, 0),
			Text = name,
			Parent = items["side_frame"],
			Name = "\0",
			Text = string.format('<u>%s</u><font color = "rgb(255, 255, 255)">%s</font>', cfg.name, cfg.suffix),
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 70),
			TextColor3 = themes.preset.accent,
			BorderSizePixel = 0,
			RichText = true,
			TextSize = 30,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		library:apply_theme(items["title"], "accent", "TextColor3")

		items["multi_holder"] = library:create("Frame", {
			Parent = items["main"],
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 196, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -196, 0, 40),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		cfg.multi_holder = items["multi_holder"]

		items["shadow"] = library:create("ImageLabel", {
			ImageColor3 = rgb(0, 0, 0),
			ScaleType = Enum.ScaleType.Slice,
			Parent = items["main"],
			BorderColor3 = rgb(0, 0, 0),
			Name = "\0",
			BackgroundColor3 = rgb(255, 255, 255),
			Size = dim2(1, 75, 1, 75),
			AnchorPoint = vec2(0.5, 0.5),
			Image = "rbxassetid://112971167999062",
			BackgroundTransparency = 1,
			Position = dim2(0.5, 0, 0.5, 0),
			SliceScale = 0.75,
			ZIndex = -100,
			BorderSizePixel = 0,
			SliceCenter = rect(vec2(112, 112), vec2(147, 147)),
		})

		items["global_fade"] = library:create("Frame", {
			Parent = items["main"],
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 196, 0, 40),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -196, 1, -65),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(15, 15, 15),
			ZIndex = 2,
		})

		library:create("UICorner", {
			Parent = items["shadow"],
			CornerRadius = dim(0, 5),
		})

		items["info"] = library:create("Frame", {
			AnchorPoint = vec2(0, 1),
			Parent = items["main"],
			Name = "\0",
			Position = dim2(0, 0, 1, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 0, 25),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(23, 23, 23),
		})

		library:create("UICorner", {
			Parent = items["info"],
			CornerRadius = dim(0, 10),
		})

		items["grey_fill"] = library:create("Frame", {
			Name = "\0",
			Parent = items["info"],
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(23, 23, 23),
		})

		items["game"] = library:create("TextLabel", {
			FontFace = fonts.font,
			Parent = items["info"],
			TextColor3 = rgb(122, 122, 122),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.game_name,
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			AnchorPoint = vec2(0, 0.5),
			Position = dim2(0, 10, 0.5, -1),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["other_info"] = library:create("TextLabel", {
			Parent = items["info"],
			RichText = true,
			Name = "\0",
			TextColor3 = themes.preset.accent,
			BorderColor3 = rgb(0, 0, 0),
			Text = '<font color="rgb(122, 122, 122)">32 days left, </font>' .. cfg.name .. cfg.suffix,
			Size = dim2(1, 0, 0, 0),
			Position = dim2(0, -10, 0.5, -1),
			AnchorPoint = vec2(0, 0.5),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = fonts.font,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		library:apply_theme(items["other_info"], "accent", "TextColor3")
	end

	do -- Other
		library:draggify(items["main"])
		library:resizify(items["main"])
	end

	function cfg.toggle_menu(bool)
		-- WIP
		-- if cfg.tween then
		--     cfg.tween:Cancel()
		-- end

		-- items[ "main" ].Size = dim2(items[ "main" ].Size.Scale.X, items[ "main" ].Size.Offset.X - 20, items[ "main" ].Size.Scale.Y, items[ "main" ].Size.Offset.Y - 20)
		-- library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -65)}, Enum.EasingStyle.Quad, 0.4)
		-- cfg.tween =

		library["items"].Enabled = bool
	end

	return setmetatable(cfg, library)
end

function library:tab(properties)
	local cfg = {
		name = properties.name or properties.Name or "visuals",
		icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608",

		-- multi
		tabs = properties.tabs or properties.Tabs or { "Main", "Misc.", "Settings" },
		pages = {}, -- data store for multi sections
		current_multi,

		items = {},
	}

	local items = cfg.items
	do
		items["tab_holder"] = library:create("Frame", {
			Parent = library.cache,
			Name = "\0",
			Visible = false,
			BackgroundTransparency = 1,
			Position = dim2(0, 196, 0, 40),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -216, 1, -85),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		-- Tab buttons
		items["button"] = library:create("TextButton", {
			FontFace = fonts.font,
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			Parent = self.items["button_holder"],
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Name = "\0",
			Size = dim2(1, 0, 0, 32),
			BorderSizePixel = 0,
			TextSize = 15,
			BackgroundColor3 = rgb(34, 34, 34),
		})

		items["icon"] = library:create("ImageLabel", {
			ImageColor3 = rgb(122, 122, 122),
			BorderColor3 = rgb(0, 0, 0),
			Parent = items["button"],
			AnchorPoint = vec2(0, 0.5),
			Image = "http://www.roblox.com/asset/?id=6034767608",
			BackgroundTransparency = 1,
			Position = dim2(0, 10, 0.5, -1),
			Name = "\0",
			Size = dim2(0, 20, 0, 20),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		library:apply_theme(items["icon"], "accent", "ImageColor3")

		items["name"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(122, 122, 122),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["button"],
			Name = "\0",
			Size = dim2(0, 0, 1, 0),
			Position = dim2(0, 36, 0, -1),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 15,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIPadding", {
			Parent = items["name"],
			PaddingRight = dim(0, 4),
			PaddingLeft = dim(0, 4),
		})

		library:create("UICorner", {
			Parent = items["button"],
			CornerRadius = dim(0, 6),
		})

		library:create("UIStroke", {
			Color = rgb(32, 32, 32),
			Parent = items["button"],
			Enabled = false,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})
		--

		-- Multi Sections
		items["multi_section_button_holder"] = library:create("Frame", {
			Parent = library.cache,
			BackgroundTransparency = 1,
			Name = "\0",
			Visible = false,
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			Parent = items["multi_section_button_holder"],
			Padding = dim(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
		})

		library:create("UIPadding", {
			PaddingTop = dim(0, 5),
			PaddingBottom = dim(0, 5),
			Parent = items["multi_section_button_holder"],
			PaddingRight = dim(0, 6),
			PaddingLeft = dim(0, 6),
		})

		for _, section in cfg.tabs do
			local data = { items = {} }

			local multi_items = data.items
			do
				-- Button
				multi_items["button"] = library:create("TextButton", {
					FontFace = fonts.font,
					TextColor3 = rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					AutoButtonColor = false,
					Text = "",
					Parent = items["multi_section_button_holder"],
					Name = "\0",
					Size = dim2(0, 0, 0, 29),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 16,
					BackgroundColor3 = rgb(26, 26, 26),
				})

				multi_items["name"] = library:create("TextLabel", {
					FontFace = fonts.font,
					TextColor3 = rgb(120, 120, 120),
					BorderColor3 = rgb(0, 0, 0),
					Text = section,
					Parent = multi_items["button"],
					Name = "\0",
					Size = dim2(0, 0, 1, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 14,
					BackgroundColor3 = rgb(255, 255, 255),
				})

				library:create("UIPadding", {
					Parent = multi_items["name"],
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4),
				})

				library:create("UIPadding", {
					Parent = multi_items["button"],
					PaddingRight = dim(0, 9),
					PaddingLeft = dim(0, 9),
				})

				library:create("UICorner", {
					Parent = multi_items["button"],
					CornerRadius = dim(0, 7),
				})
				--

				-- Tab
				multi_items["tab"] = library:create("Frame", {
					Parent = library.cache,
					BackgroundTransparency = 1,
					Name = "\0",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -20, 1, -20),
					BorderSizePixel = 0,
					Visible = false,
					BackgroundColor3 = rgb(255, 255, 255),
				})

				library:create("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Parent = multi_items["tab"],
					Padding = dim(0, 7),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill,
				})

				library:create("UIPadding", {
					PaddingTop = dim(0, 7),
					PaddingBottom = dim(0, 7),
					Parent = multi_items["tab"],
					PaddingRight = dim(0, 7),
					PaddingLeft = dim(0, 7),
				})
				--
			end

			data.text = multi_items["name"]
			data.button = multi_items["button"]
			data.page = multi_items["tab"]
			data.parent = setmetatable(data, library):sub_tab({}).items["tab_parent"]

			-- Old column code
			-- data.left = multi_items[ "left" ]
			-- data.right = multi_items[ "right" ]

			function data.open_page()
				local page = cfg.current_multi

				if page and page.text ~= data.text then
					self.items["global_fade"].BackgroundTransparency = 0
					library:tween(self.items["global_fade"], { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, 0.4)

					local old_size = page.page.Size
					page.page.Size = dim2(1, -20, 1, -20)
				end

				if page then
					library:tween(page.text, { TextColor3 = rgb(120, 120, 120) })
					library:tween(page.button, { BackgroundTransparency = 1 })

					page.page.Visible = false
					page.page.Parent = library["cache"]
				end

				library:tween(data.text, { TextColor3 = rgb(255, 255, 255) })
				library:tween(data.button, { BackgroundTransparency = 0 })
				library:tween(data.page, { Size = dim2(1, 0, 1, 0) }, Enum.EasingStyle.Quad, 0.4)

				data.page.Visible = true
				data.page.Parent = items["tab_holder"]

				cfg.current_multi = data

				library:close_element()
			end

			multi_items["button"].MouseButton1Down:Connect(function()
				data.open_page()
			end)

			cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
		end

		cfg.pages[1].open_page()
		--
	end

	function cfg.open_tab()
		local selected_tab = self.selected_tab

		if selected_tab then
			if selected_tab[4] ~= items["tab_holder"] then
				self.items["global_fade"].BackgroundTransparency = 0

				library:tween(self.items["global_fade"], { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, 0.4)
				selected_tab[4].Size = dim2(1, -216, 1, -85)
			end

			library:tween(selected_tab[1], { BackgroundTransparency = 1 })
			library:tween(selected_tab[2], { ImageColor3 = rgb(122, 122, 122) })
			library:tween(selected_tab[3], { TextColor3 = rgb(122, 122, 122) })

			selected_tab[4].Visible = false
			selected_tab[4].Parent = library["cache"]
			selected_tab[5].Visible = false
			selected_tab[5].Parent = library["cache"]
		end

		library:tween(items["button"], { BackgroundTransparency = 0 })
		library:tween(items["icon"], { ImageColor3 = themes.preset.accent })
		library:tween(items["name"], { TextColor3 = rgb(255, 255, 255) })
		library:tween(items["tab_holder"], { Size = dim2(1, -196, 1, -65) }, Enum.EasingStyle.Quad, 0.4)

		items["tab_holder"].Visible = true
		items["tab_holder"].Parent = self.items["main"]
		items["multi_section_button_holder"].Visible = true
		items["multi_section_button_holder"].Parent = self.items["multi_holder"]

		self.selected_tab = {
			items["button"],
			items["icon"],
			items["name"],
			items["tab_holder"],
			items["multi_section_button_holder"],
		}

		library:close_element()
	end

	items["button"].MouseButton1Down:Connect(function()
		cfg.open_tab()
	end)

	if not self.selected_tab then
		cfg.open_tab(true)
	end

	return unpack(cfg.pages)
end

function library:seperator(properties)
	local cfg = { items = {}, name = properties.Name or properties.name or "General" }

	local items = cfg.items
	do
		items["name"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(122, 122, 122),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = self.items["button_holder"],
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			Position = dim2(0, 36, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 15,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIPadding", {
			Parent = items["name"],
			PaddingRight = dim(0, 5),
			PaddingLeft = dim(0, 5),
		})
	end

	return setmetatable(cfg, library)
end

-- Miscellaneous
function library:column(properties)
	local cfg = { items = {}, size = properties.size or 1 }

	local items = cfg.items
	do
		items["column"] = library:create("Frame", {
			Parent = self["parent"] or self.items["tab_parent"],
			BackgroundTransparency = 1,
			Name = "\0",
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, cfg.size, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIPadding", {
			PaddingBottom = dim(0, 10),
			Parent = items["column"],
		})

		library:create("UIListLayout", {
			Parent = items["column"],
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = dim(0, 10),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	end

	return setmetatable(cfg, library)
end

function library:sub_tab(properties)
	local cfg = { items = {}, order = properties.order or 0, size = properties.size or 1 }

	local items = cfg.items
	do
		items["tab_parent"] = library:create("Frame", {
			Parent = self.items["tab"],
			BackgroundTransparency = 1,
			Name = "\0",
			Size = dim2(0, 0, cfg.size, 0),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			Visible = true,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			VerticalFlex = Enum.UIFlexAlignment.Fill,
			Parent = items["tab_parent"],
			Padding = dim(0, 7),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	end

	return setmetatable(cfg, library)
end
--

function library:section(properties)
	local cfg = {
		name = properties.name or properties.Name or "section",
		side = properties.side or properties.Side or "left",
		default = properties.default or properties.Default or false,
		size = properties.size or properties.Size or self.size or 0.5,
		icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898",
		fading_toggle = properties.fading or properties.Fading or false,
		items = {},
	}

	local items = cfg.items
	do
		items["outline"] = library:create("Frame", {
			Name = "\0",
			Parent = self.items["column"],
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, cfg.size, -3),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(26, 26, 26),
		})

		library:create("UICorner", {
			Parent = items["outline"],
			CornerRadius = dim(0, 7),
		})

		items["inline"] = library:create("Frame", {
			Parent = items["outline"],
			Name = "\0",
			Position = dim2(0, 1, 0, 1),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -2, 1, -2),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(19, 19, 19),
		})

		library:create("UICorner", {
			Parent = items["inline"],
			CornerRadius = dim(0, 7),
		})

		items["scrolling"] = library:create("ScrollingFrame", {
			ScrollBarImageColor3 = rgb(44, 44, 44),
			Active = true,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 2,
			Parent = items["inline"],
			Name = "\0",
			Size = dim2(1, 0, 1, -40),
			BackgroundTransparency = 1,
			Position = dim2(0, 0, 0, 35),
			BackgroundColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			CanvasSize = dim2(0, 0, 0, 0),
		})

		items["elements"] = library:create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = items["scrolling"],
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 10, 0, 10),
			Size = dim2(1, -20, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			Parent = items["elements"],
			Padding = dim(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		library:create("UIPadding", {
			PaddingBottom = dim(0, 15),
			Parent = items["elements"],
		})

		items["button"] = library:create("TextButton", {
			FontFace = fonts.font,
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AutoButtonColor = false,
			Parent = items["outline"],
			Name = "\0",
			Position = dim2(0, 1, 0, 1),
			Size = dim2(1, -2, 0, 35),
			BorderSizePixel = 0,
			TextSize = 16,
			BackgroundColor3 = rgb(19, 19, 19),
		})

		library:create("UIStroke", {
			Color = rgb(32, 32, 32),
			Parent = items["button"],
			Enabled = false,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		library:create("UICorner", {
			Parent = items["button"],
			CornerRadius = dim(0, 7),
		})

		items["Icon"] = library:create("ImageLabel", {
			ImageColor3 = themes.preset.accent,
			BorderColor3 = rgb(0, 0, 0),
			Parent = items["button"],
			AnchorPoint = vec2(0, 0.5),
			Image = cfg.icon,
			BackgroundTransparency = 1,
			Position = dim2(0, 10, 0.5, 0),
			Name = "\0",
			Size = dim2(0, 22, 0, 22),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		library:apply_theme(items["Icon"], "accent", "ImageColor3")

		items["section_title"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["button"],
			Name = "\0",
			Size = dim2(0, 0, 1, 0),
			Position = dim2(0, 40, 0, -1),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		if cfg.fading_toggle then
			items["toggle"] = library:create("TextButton", {
				FontFace = fonts.small,
				TextColor3 = rgb(0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				AutoButtonColor = false,
				Text = "",
				AnchorPoint = vec2(1, 0.5),
				Parent = items["button"],
				Name = "\0",
				Position = dim2(1, -9, 0.5, 0),
				Size = dim2(0, 36, 0, 18),
				BorderSizePixel = 0,
				TextSize = 14,
				BackgroundColor3 = rgb(70, 70, 70),
			})
			library:apply_theme(items["toggle"], "accent", "BackgroundColor3")

			library:create("UICorner", {
				Parent = items["toggle"],
				CornerRadius = dim(0, 999),
			})

			items["toggle_outline"] = library:create("Frame", {
				Parent = items["toggle"],
				Size = dim2(1, -2, 1, -2),
				Name = "\0",
				BorderMode = Enum.BorderMode.Inset,
				BorderColor3 = rgb(0, 0, 0),
				Position = dim2(0, 1, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(60, 60, 60),
			})
			library:apply_theme(items["toggle_outline"], "accent", "BackgroundColor3")

			library:create("UICorner", {
				Parent = items["toggle_outline"],
				CornerRadius = dim(0, 999),
			})

			library:create("UIGradient", {
				Color = rgbseq({ rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211)) }),
				Parent = items["toggle_outline"],
			})

			items["toggle_circle"] = library:create("Frame", {
				Parent = items["toggle_outline"],
				Name = "\0",
				Position = dim2(0, 2, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 12, 0, 12),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(110, 110, 110),
			})

			library:create("UICorner", {
				Parent = items["toggle_circle"],
				CornerRadius = dim(0, 999),
			})

			library:create("UICorner", {
				Parent = items["outline"],
				CornerRadius = dim(0, 7),
			})

			items["fade"] = library:create("Frame", {
				Parent = items["outline"],
				BackgroundTransparency = 0.800000011920929,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(0, 0, 0),
			})

			library:create("UICorner", {
				Parent = items["fade"],
				CornerRadius = dim(0, 7),
			})
		end
	end

	if cfg.fading_toggle then
		items["button"].MouseButton1Click:Connect(function()
			cfg.default = not cfg.default
			cfg.toggle_section(cfg.default)
		end)

		function cfg.toggle_section(bool)
			library:tween(
				items["toggle"],
				{ BackgroundColor3 = bool and themes.preset.accent or rgb(70, 70, 70) },
				Enum.EasingStyle.Quad
			)
			library:tween(
				items["toggle_outline"],
				{ BackgroundColor3 = bool and themes.preset.accent or rgb(60, 60, 60) },
				Enum.EasingStyle.Quad
			)
			library:tween(items["toggle_circle"], {
				BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(110, 110, 110),
				Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2),
			}, Enum.EasingStyle.Quad)
			library:tween(items["fade"], { BackgroundTransparency = bool and 1 or 0.8 }, Enum.EasingStyle.Quad)
		end
	end

	return setmetatable(cfg, library)
end

function library:toggle(options)
	local rand = math.random(1, 2)
	local cfg = {
		enabled = options.enabled or nil,
		name = options.name or "Toggle",
		info = options.info or nil,
		flag = options.flag or library:next_flag(),

		type = options.type and string.lower(options.type) or rand == 1 and "toggle" or "checkbox", -- "toggle", "checkbox"

		default = options.default or false,
		folding = options.folding or false,
		callback = options.callback or function() end,

		items = {},
		seperator = options.seperator or options.Seperator or false,
	}

	flags[cfg.flag] = cfg.default

	local items = cfg.items
	do
		items["toggle"] = library:create("TextButton", {
			FontFace = fonts.small,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			Parent = self.items["elements"],
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["name"] = library:create("TextLabel", {
			FontFace = fonts.small,
			TextColor3 = rgb(242, 242, 242),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["toggle"],
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		if cfg.info then
			items["info"] = library:create("TextLabel", {
				FontFace = fonts.small,
				TextColor3 = rgb(130, 130, 130),
				BorderColor3 = rgb(0, 0, 0),
				TextWrapped = true,
				Text = cfg.info,
				Parent = items["toggle"],
				Name = "\0",
				Position = dim2(0, 5, 0, 17),
				Size = dim2(1, -10, 0, 0),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 16,
				BackgroundColor3 = rgb(255, 255, 255),
			})
		end

		library:create("UIPadding", {
			Parent = items["name"],
			PaddingRight = dim(0, 5),
			PaddingLeft = dim(0, 5),
		})

		items["right_components"] = library:create("Frame", {
			Parent = items["toggle"],
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = items["right_components"],
			Padding = dim(0, 9),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		-- Toggle
		if cfg.type == "checkbox" then
			items["toggle_button"] = library:create("TextButton", {
				FontFace = fonts.small,
				TextColor3 = rgb(0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				LayoutOrder = 2,
				AutoButtonColor = false,
				AnchorPoint = vec2(1, 0),
				Parent = items["right_components"],
				Name = "\0",
				Position = dim2(1, 0, 0, 0),
				Size = dim2(0, 16, 0, 16),
				BorderSizePixel = 0,
				TextSize = 14,
				BackgroundColor3 = rgb(80, 80, 80),
			})
			library:apply_theme(items["toggle_button"], "accent", "BackgroundColor3")

			library:create("UICorner", {
				Parent = items["toggle_button"],
				CornerRadius = dim(0, 4),
			})

			items["outline"] = library:create("Frame", {
				Parent = items["toggle_button"],
				Size = dim2(1, -2, 1, -2),
				Name = "\0",
				BorderMode = Enum.BorderMode.Inset,
				BorderColor3 = rgb(0, 0, 0),
				Position = dim2(0, 1, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(19, 19, 19),
			})
			library:apply_theme(items["outline"], "accent", "BackgroundColor3")

			items["tick"] = library:create("ImageLabel", {
				ImageTransparency = 1,
				BorderColor3 = rgb(0, 0, 0),
				Image = "rbxassetid://111862698467575",
				BackgroundTransparency = 1,
				Position = dim2(0, -1, 0, 0),
				Parent = items["outline"],
				Size = dim2(1, 2, 1, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
				ZIndex = 1,
			})

			library:create("UICorner", {
				Parent = items["outline"],
				CornerRadius = dim(0, 4),
			})

			library:create("UIGradient", {
				Enabled = false,
				Parent = items["outline"],
				Color = rgbseq({ rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211)) }),
			})
		else
			items["toggle_button"] = library:create("TextButton", {
				FontFace = fonts.font,
				TextColor3 = rgb(0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				LayoutOrder = 2,
				AnchorPoint = vec2(1, 0.5),
				Parent = items["right_components"],
				Name = "\0",
				Position = dim2(1, -9, 0.5, 0),
				Size = dim2(0, 36, 0, 18),
				BorderSizePixel = 0,
				TextSize = 14,
				BackgroundColor3 = themes.preset.accent,
			})
			library:apply_theme(items["toggle_button"], "accent", "BackgroundColor3")

			library:create("UICorner", {
				Parent = items["toggle_button"],
				CornerRadius = dim(0, 999),
			})

			items["inline"] = library:create("Frame", {
				Parent = items["toggle_button"],
				Size = dim2(1, -2, 1, -2),
				Name = "\0",
				BorderMode = Enum.BorderMode.Inset,
				BorderColor3 = rgb(0, 0, 0),
				Position = dim2(0, 1, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
			})
			library:apply_theme(items["inline"], "accent", "BackgroundColor3")

			library:create("UICorner", {
				Parent = items["inline"],
				CornerRadius = dim(0, 999),
			})

			library:create("UIGradient", {
				Color = rgbseq({ rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211)) }),
				Parent = items["inline"],
			})

			items["circle"] = library:create("Frame", {
				Parent = items["inline"],
				Name = "\0",
				Position = dim2(1, -14, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 12, 0, 12),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
			})

			library:create("UICorner", {
				Parent = items["circle"],
				CornerRadius = dim(0, 999),
			})
		end
		--
	end

	function cfg.set(bool)
		if cfg.type == "checkbox" then
			library:tween(items["tick"], { Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1 })
			library:tween(
				items["toggle_button"],
				{ BackgroundColor3 = bool and themes.preset.accent or rgb(80, 80, 80) }
			)
			library:tween(items["outline"], { BackgroundColor3 = bool and themes.preset.accent or rgb(19, 19, 19) })
		else
			library:tween(
				items["toggle_button"],
				{ BackgroundColor3 = bool and themes.preset.accent or rgb(70, 70, 70) },
				Enum.EasingStyle.Quad
			)
			library:tween(
				items["inline"],
				{ BackgroundColor3 = bool and themes.preset.accent or rgb(60, 60, 60) },
				Enum.EasingStyle.Quad
			)
			library:tween(items["circle"], {
				BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(110, 110, 110),
				Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2),
			}, Enum.EasingStyle.Quad)
		end

		cfg.callback(bool)

		if cfg.folding then
			elements.Visible = bool
		end

		flags[cfg.flag] = bool
	end

	items["toggle"].MouseButton1Click:Connect(function()
		cfg.enabled = not cfg.enabled
		cfg.set(cfg.enabled)
	end)

	items["toggle_button"].MouseButton1Click:Connect(function()
		cfg.enabled = not cfg.enabled
		cfg.set(cfg.enabled)
	end)

	cfg.set(cfg.default)

	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:slider(options)
	local cfg = {
		name = options.name or "Slider",
		suffix = options.suffix or "",
		flag = options.flag or library:next_flag(),
		callback = options.callback or function() end,
		info = options.info or nil,

		min = options.min or options.minimum or 0,
		max = options.max or options.maximum or 100,
		intervals = options.interval or options.decimal or 1,
		default = options.default or 0,
		value = options.default or 0,
		seperator = options.seperator or options.Seperator or true,

		dragging = false,
		current = 0,
		target = 0,
		items = {},
	}

	cfg.default = clamp(cfg.default, cfg.min, cfg.max)
	cfg.value = cfg.default
	flags[cfg.flag] = cfg.default

	local items = cfg.items
	do
		items["slider_object"] = library:create("TextButton", {
			FontFace = fonts.small,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AutoButtonColor = false,
			Parent = self.items["elements"],
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["name"] = library:create("TextLabel", {
			FontFace = fonts.small,
			TextColor3 = rgb(242, 242, 242),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["slider_object"],
			Name = "\0",
			Position = dim2(0, 5, 0, 0),
			Size = dim2(1, -110, 0, 16),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BorderSizePixel = 0,
			TextSize = 15,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["value"] = library:create("TextLabel", {
			FontFace = fonts.small,
			TextColor3 = rgb(120, 120, 120),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AnchorPoint = vec2(1, 0),
			Parent = items["slider_object"],
			Name = "\0",
			Position = dim2(1, -5, 0, 0),
			Size = dim2(0, 100, 0, 16),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BorderSizePixel = 0,
			TextSize = 15,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["track"] = library:create("Frame", {
			Parent = items["slider_object"],
			Name = "\0",
			Position = dim2(0, 5, 0, 24),
			Size = dim2(1, -10, 0, 12),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(34, 34, 34),
		})

		library:create("UICorner", {
			Parent = items["track"],
			CornerRadius = dim(0, 999),
		})

		items["fill"] = library:create("Frame", {
			Name = "\0",
			Parent = items["track"],
			Size = dim2(0, 0, 1, 0),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UICorner", {
			Parent = items["fill"],
			CornerRadius = dim(0, 999),
		})

		items["fill_gradient"] = library:accent_gradient(library:create("UIGradient", {
			Parent = items["fill"],
		}))

		items["hit"] = library:create("TextButton", {
			FontFace = fonts.small,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AutoButtonColor = false,
			Parent = items["slider_object"],
			Name = "\0",
			Position = dim2(0, 0, 0, 18),
			Size = dim2(1, 0, 0, 20),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		if cfg.info then
			items["info"] = library:create("TextLabel", {
				FontFace = fonts.small,
				TextColor3 = rgb(130, 130, 130),
				BorderColor3 = rgb(0, 0, 0),
				TextWrapped = true,
				Text = cfg.info,
				Parent = items["slider_object"],
				Name = "\0",
				Position = dim2(0, 5, 0, 36),
				Size = dim2(1, -10, 0, 0),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = 14,
				BackgroundColor3 = rgb(255, 255, 255),
			})
		end
	end

	function cfg.fraction()
		local span = cfg.max - cfg.min

		if span == 0 then
			return 0
		end

		return (cfg.value - cfg.min) / span
	end

	function cfg.set(value, instant)
		cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)
		cfg.target = cfg.fraction()

		items["value"].Text = tostring(cfg.value) .. cfg.suffix

		flags[cfg.flag] = cfg.value
		cfg.callback(flags[cfg.flag])

		if instant then
			cfg.current = cfg.target
			items["fill"].Size = dim2(cfg.current, 0, 1, 0)
		elseif not cfg.dragging then
			cfg.current = cfg.target
			library:tween(items["fill"], { Size = dim2(cfg.target, 0, 1, 0) }, Enum.EasingStyle.Quart, 0.12)
		end
	end

	function cfg.apply_input(input)
		local offset = (input.Position.X - items["track"].AbsolutePosition.X) / items["track"].AbsoluteSize.X
		local value = ((cfg.max - cfg.min) * clamp(offset, 0, 1)) + cfg.min

		cfg.set(value)
	end

	library:connection(run.RenderStepped, function(delta)
		if not cfg.dragging then
			return
		end

		local difference = cfg.target - cfg.current

		if abs(difference) < 0.0005 then
			return
		end

		cfg.current += difference * min(1, delta * 26)
		items["fill"].Size = dim2(cfg.current, 0, 1, 0)
	end)

	items["hit"].InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		cfg.dragging = true
		cfg.current = items["fill"].Size.X.Scale
		cfg.apply_input(input)
		library:tween(items["value"], { TextColor3 = rgb(255, 255, 255) }, Enum.EasingStyle.Quad, 0.2)
	end)

	library:connection(uis.InputChanged, function(input)
		if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			cfg.apply_input(input)
		end
	end)

	library:connection(uis.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			cfg.dragging = false
			cfg.current = cfg.target
			items["fill"].Size = dim2(cfg.current, 0, 1, 0)
			library:tween(items["value"], { TextColor3 = rgb(120, 120, 120) }, Enum.EasingStyle.Quad, 0.2)
		end
	end)

	cfg.set(cfg.default, true)
	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:dropdown(options)
	local cfg = {
		name = options.name or "Dropdown",
		info = options.info or nil,
		flag = options.flag or library:next_flag(),
		options = options.items or {},
		callback = options.callback or function() end,
		multi = options.multi or false,

		open = false,
		rows = {},
		selected = {},
		items = {},
		y_size = 0,
		seperator = options.seperator or options.Seperator or true,
	}

	if cfg.multi then
		cfg.default = type(options.default) == "table" and options.default or {}
	else
		cfg.default = options.default or cfg.options[1]
	end

	flags[cfg.flag] = cfg.default

	local items = cfg.items
	do
		items["dropdown_object"] = library:create("TextButton", {
			FontFace = fonts.small,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AutoButtonColor = false,
			Parent = self.items["elements"],
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["name"] = library:create("TextLabel", {
			FontFace = fonts.small,
			TextColor3 = rgb(120, 120, 120),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["dropdown_object"],
			Name = "\0",
			Position = dim2(0, 5, 0, 0),
			Size = dim2(1, -110, 0, 16),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BorderSizePixel = 0,
			TextSize = 15,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["box"] = library:create("TextButton", {
			FontFace = fonts.small,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AutoButtonColor = false,
			Parent = items["dropdown_object"],
			Name = "\0",
			Position = dim2(0, 5, 0, 20),
			Size = dim2(1, -10, 0, 30),
			BorderSizePixel = 0,
			TextSize = 14,
			BackgroundColor3 = rgb(33, 33, 33),
		})

		library:create("UICorner", {
			Parent = items["box"],
			CornerRadius = dim(0, 4),
		})

		items["selected"] = library:create("TextLabel", {
			FontFace = fonts.small,
			TextColor3 = rgb(242, 242, 242),
			BorderColor3 = rgb(0, 0, 0),
			Text = "None",
			Parent = items["box"],
			Name = "\0",
			Position = dim2(0, 11, 0, 0),
			Size = dim2(1, -36, 1, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BorderSizePixel = 0,
			TextSize = 15,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["arrow"] = library:create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = items["box"],
			AnchorPoint = vec2(1, 0.5),
			BackgroundTransparency = 1,
			Position = dim2(1, -11, 0.5, 0),
			Name = "\0",
			Size = dim2(0, 11, 0, 11),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("Frame", {
			Parent = items["arrow"],
			AnchorPoint = vec2(0.5, 0.5),
			Position = dim2(0.5, 0, 0.5, 0),
			Name = "\0",
			Size = dim2(1, 0, 0, 1.5),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(150, 150, 150),
		})

		library:create("Frame", {
			Parent = items["arrow"],
			AnchorPoint = vec2(0.5, 0.5),
			Position = dim2(0.5, 0, 0.5, 0),
			Name = "\0",
			Size = dim2(0, 1.5, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(150, 150, 150),
		})

		items["dropdown_holder"] = library:create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = library["items"],
			Name = "\0",
			Visible = false,
			BackgroundTransparency = 1,
			Size = dim_offset(0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(0, 0, 0),
			ZIndex = 10,
		})

		items["search_frame"] = library:create("Frame", {
			Parent = items["dropdown_holder"],
			Name = "\0",
			Size = dim2(1, 0, 0, 24),
			BackgroundColor3 = rgb(25, 25, 25),
			Visible = false,
			BorderSizePixel = 0,
			ZIndex = 12,
		})

		library:create("UICorner", {
			Parent = items["search_frame"],
			CornerRadius = dim(0, 4),
		})

		library:create("UIStroke", {
			Parent = items["search_frame"],
			Color = rgb(42, 42, 42),
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		items["search_ring"] = library:create("Frame", {
			Parent = items["search_frame"],
			Name = "\0",
			Position = dim2(0, 10, 0, 8),
			Size = dim2(0, 8, 0, 8),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
			ZIndex = 13,
		})

		library:create("UICorner", {
			Parent = items["search_ring"],
			CornerRadius = dim(0, 999),
		})

		library:create("UIStroke", {
			Parent = items["search_ring"],
			Color = rgb(122, 122, 122),
			Thickness = 1.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		library:create("Frame", {
			Parent = items["search_frame"],
			Name = "\0",
			AnchorPoint = vec2(0, 0.5),
			Position = dim2(0, 17, 0, 15),
			Size = dim2(0, 4, 0, 2),
			Rotation = 45,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(122, 122, 122),
			ZIndex = 13,
		})

		items["search"] = library:create("TextBox", {
			FontFace = fonts.small,
			TextColor3 = rgb(242, 242, 242),
			PlaceholderColor3 = rgb(110, 110, 110),
			PlaceholderText = "Type here...",
			ClearTextOnFocus = false,
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			Parent = items["search_frame"],
			Name = "\0",
			Position = dim2(0, 27, 0, 0),
			Size = dim2(1, -36, 1, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			TextSize = 13,
			BackgroundColor3 = rgb(255, 255, 255),
			ZIndex = 13,
		})

		items["list_frame"] = library:create("Frame", {
			Parent = items["dropdown_holder"],
			Name = "\0",
			Size = dim2(1, 0, 1, 0),
			BackgroundColor3 = rgb(25, 25, 25),
			ClipsDescendants = true,
			BorderSizePixel = 0,
			ZIndex = 10,
		})

		library:create("UICorner", {
			Parent = items["list_frame"],
			CornerRadius = dim(0, 4),
		})

		items["scroll"] = library:create("ScrollingFrame", {
			Parent = items["list_frame"],
			Name = "\0",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = dim2(1, 0, 1, 0),
			CanvasSize = dim2(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = rgb(62, 62, 62),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BackgroundColor3 = rgb(255, 255, 255),
			ZIndex = 11,
		})

		library:create("UIPadding", {
			PaddingTop = dim(0, 4),
			PaddingBottom = dim(0, 4),
			PaddingLeft = dim(0, 4),
			PaddingRight = dim(0, 4),
			Parent = items["scroll"],
		})

		library:create("UIListLayout", {
			Parent = items["scroll"],
			Padding = dim(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	end

	function cfg.render_option(text)
		local row = library:create("TextButton", {
			FontFace = fonts.small,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AutoButtonColor = false,
			Parent = items["scroll"],
			Name = "\0",
			Size = dim2(1, 0, 0, 21),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextSize = 14,
			BackgroundColor3 = rgb(45, 45, 45),
			ZIndex = 10,
		})

		library:create("UICorner", {
			Parent = row,
			CornerRadius = dim(0, 3),
		})

		local line = library:create("Frame", {
			Parent = row,
			AnchorPoint = vec2(0, 0.5),
			Position = dim2(0, 8, 0.5, 0),
			Name = "\0",
			Size = dim2(0, 3, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.accent,
			ZIndex = 11,
		})
		library:apply_theme(line, "accent", "BackgroundColor3")

		library:create("UICorner", {
			Parent = line,
			CornerRadius = dim(0, 4),
		})

		local label = library:create("TextLabel", {
			FontFace = fonts.small,
			TextColor3 = rgb(120, 120, 120),
			BorderColor3 = rgb(0, 0, 0),
			Text = text,
			Parent = row,
			Name = "\0",
			Position = dim2(0, 10, 0, 0),
			Size = dim2(1, -18, 1, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BorderSizePixel = 0,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
			ZIndex = 11,
		})

		row.MouseEnter:Connect(function()
			if not cfg.is_selected(text) then
				library:tween(row, { BackgroundTransparency = 0.45 }, Enum.EasingStyle.Quad, 0.15)
			end
		end)

		row.MouseLeave:Connect(function()
			if not cfg.is_selected(text) then
				library:tween(row, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, 0.15)
			end
		end)

		return { text = text, row = row, label = label, line = line }
	end

	function cfg.is_selected(text)
		if cfg.multi then
			return find(cfg.selected, text) ~= nil
		end

		return cfg.selected[1] == text
	end

	function cfg.paint(data, active)
		library:tween(data.row, { BackgroundTransparency = active and 0 or 1 }, Enum.EasingStyle.Quad, 0.15)
		library:tween(data.line, { Size = dim2(0, 3, 0, active and 11 or 0) }, Enum.EasingStyle.Quad, 0.15)
		library:tween(
			data.label,
			{ TextColor3 = active and rgb(255, 255, 255) or rgb(120, 120, 120) },
			Enum.EasingStyle.Quad,
			0.15
		)
		library:tween(data.label, { Position = dim2(0, active and 18 or 10, 0, 0) }, Enum.EasingStyle.Quad, 0.15)
	end

	function cfg.update_size()
		local visible = 0

		for _, data in cfg.rows do
			if data.row.Visible then
				visible += 1
			end
		end

		local list_height = visible > 0 and (visible * 23 + 6) or 0
		cfg.y_size = math.min(list_height, 150) + (cfg.search_visible and 28 or 0)
	end

	function cfg.filter(query)
		query = string.lower(query)

		for _, data in cfg.rows do
			data.row.Visible = query == "" or string.find(string.lower(data.text), query, 1, true) ~= nil
		end

		cfg.update_size()

		if cfg.open then
			library:tween(
				items["dropdown_holder"],
				{ Size = dim_offset(items["box"].AbsoluteSize.X, cfg.y_size) },
				Enum.EasingStyle.Quad,
				0.12
			)
		end
	end

	function cfg.set_visible(bool)
		cfg.open = bool
		items["dropdown_holder"].Visible = bool
		items["dropdown_holder"].Parent = library["items"]
		items["dropdown_holder"].Position = dim_offset(
			items["box"].AbsolutePosition.X,
			items["box"].AbsolutePosition.Y + items["box"].AbsoluteSize.Y + 4 + gui_offset
		)

		cfg.search_visible = #cfg.rows > 8
		items["search_frame"].Visible = cfg.search_visible
		items["list_frame"].Position = dim_offset(0, cfg.search_visible and 28 or 0)
		items["list_frame"].Size = dim2(1, 0, 1, cfg.search_visible and -28 or 0)

		if bool then
			items["search"].Text = ""
		end

		cfg.update_size()

		library:tween(
			items["dropdown_holder"],
			{ Size = dim_offset(items["box"].AbsoluteSize.X, bool and cfg.y_size or 0) },
			Enum.EasingStyle.Quad,
			0.18
		)
		library:tween(items["arrow"], { Rotation = bool and 180 or 0 }, Enum.EasingStyle.Quad, 0.18)

		if not (self.sanity and library.current_open == self) then
			library:close_element(cfg)
		end
	end

	function cfg.set(value)
		cfg.selected = {}

		if cfg.multi then
			if type(value) == "table" then
				for _, entry in value do
					insert(cfg.selected, entry)
				end
			end
		elseif value ~= nil then
			insert(cfg.selected, value)
		end

		for _, data in cfg.rows do
			cfg.paint(data, cfg.is_selected(data.text))
		end

		if cfg.multi then
			items["selected"].Text = #cfg.selected > 0 and concat(cfg.selected, ", ") or "None"
			flags[cfg.flag] = cfg.selected
		else
			items["selected"].Text = cfg.selected[1] or "None"
			flags[cfg.flag] = cfg.selected[1]
		end

		cfg.callback(flags[cfg.flag])
	end

	function cfg.refresh_options(list)
		for _, data in cfg.rows do
			data.row:Destroy()
		end

		cfg.rows = {}
		cfg.y_size = 0

		for _, option in list do
			local data = cfg.render_option(tostring(option))
			insert(cfg.rows, data)
			cfg.y_size += 29

			data.row.MouseButton1Down:Connect(function()
				if cfg.multi then
					local index = find(cfg.selected, data.text)

					if index then
						remove(cfg.selected, index)
					else
						insert(cfg.selected, data.text)
					end

					cfg.set(cfg.selected)
				else
					cfg.set_visible(false)
					cfg.open = false

					cfg.set(data.text)
				end
			end)
		end

		cfg.update_size()
	end

	items["box"].MouseButton1Click:Connect(function()
		cfg.set_visible(not cfg.open)
	end)

	items["search"]:GetPropertyChangedSignal("Text"):Connect(function()
		cfg.filter(items["search"].Text)
	end)

	config_flags[cfg.flag] = cfg.set

	cfg.refresh_options(cfg.options)
	cfg.set(cfg.default)

	return setmetatable(cfg, library)
end

function library:label(options)
	local cfg = {
		enabled = options.enabled or nil,
		name = options.name or "Toggle",
		seperator = options.seperator or options.Seperator or false,
		info = options.info or nil,

		items = {},
	}

	local items = cfg.items
	do
		items["label"] = library:create("TextButton", {
			FontFace = fonts.small,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			Parent = self.items["elements"],
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["name"] = library:create("TextLabel", {
			FontFace = fonts.small,
			TextColor3 = rgb(242, 242, 242),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["label"],
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		if cfg.info then
			items["info"] = library:create("TextLabel", {
				FontFace = fonts.small,
				TextColor3 = rgb(130, 130, 130),
				BorderColor3 = rgb(0, 0, 0),
				TextWrapped = true,
				Text = cfg.info,
				Parent = items["label"],
				Name = "\0",
				Position = dim2(0, 5, 0, 17),
				Size = dim2(1, -10, 0, 0),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 16,
				BackgroundColor3 = rgb(255, 255, 255),
			})
		end

		library:create("UIPadding", {
			Parent = items["name"],
			PaddingRight = dim(0, 5),
			PaddingLeft = dim(0, 5),
		})

		items["right_components"] = library:create("Frame", {
			Parent = items["label"],
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = items["right_components"],
			Padding = dim(0, 9),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	end

	return setmetatable(cfg, library)
end

function library:colorpicker(options)
	local cfg = {
		name = options.name or "Color",
		flag = options.flag or library:next_flag(),

		color = options.color or color(1, 1, 1), -- Default to white color if not provided
		alpha = options.alpha and 1 - options.alpha or 0,

		open = false,
		callback = options.callback or function() end,
		items = {},

		seperator = options.seperator or options.Seperator or false,
	}

	local dragging_sat = false
	local dragging_hue = false
	local dragging_alpha = false

	local h, s, v = cfg.color:ToHSV()
	local a = cfg.alpha

	flags[cfg.flag] = { Color = cfg.color, Transparency = cfg.alpha }

	local label
	if not self.items.right_components then
		label = self:label({ name = cfg.name, seperator = cfg.seperator })
	end

	local items = cfg.items
	do
		-- Component
		items["colorpicker"] = library:create("TextButton", {
			FontFace = fonts.small,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AutoButtonColor = false,
			AnchorPoint = vec2(1, 0),
			Parent = label and label.items.right_components or self.items["right_components"],
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			Size = dim2(0, 16, 0, 16),
			BorderSizePixel = 0,
			TextSize = 14,
			BackgroundColor3 = rgb(158, 8, 73),
		})

		library:create("UICorner", {
			Parent = items["colorpicker"],
			CornerRadius = dim(0, 4),
		})

		items["colorpicker_inline"] = library:create("Frame", {
			Parent = items["colorpicker"],
			Size = dim2(1, -2, 1, -2),
			Name = "\0",
			BorderMode = Enum.BorderMode.Inset,
			BorderColor3 = rgb(0, 0, 0),
			Position = dim2(0, 1, 0, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(158, 8, 73),
		})

		library:create("UICorner", {
			Parent = items["colorpicker_inline"],
			CornerRadius = dim(0, 4),
		})

		library:create("UIGradient", {
			Color = rgbseq({ rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211)) }),
			Parent = items["colorpicker_inline"],
		})
		--

		-- Colorpicker
		items["colorpicker_holder"] = library:create("Frame", {
			Parent = library["other"],
			Name = "\0",
			Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 166, 0, 197),
			BorderSizePixel = 0,
			Visible = true,
			BackgroundColor3 = rgb(26, 26, 26),
		})

		items["colorpicker_fade"] = library:create("Frame", {
			Parent = items["colorpicker_holder"],
			Name = "\0",
			BackgroundTransparency = 0,
			Position = dim2(0, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			ZIndex = 100,
			BackgroundColor3 = rgb(26, 26, 26),
		})

		items["colorpicker_components"] = library:create("Frame", {
			Parent = items["colorpicker_holder"],
			Name = "\0",
			Position = dim2(0, 1, 0, 1),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -2, 1, -2),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(19, 19, 19),
		})

		library:create("UICorner", {
			Parent = items["colorpicker_components"],
			CornerRadius = dim(0, 6),
		})

		items["saturation_holder"] = library:create("Frame", {
			Parent = items["colorpicker_components"],
			Name = "\0",
			Position = dim2(0, 7, 0, 7),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -14, 1, -80),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 39, 39),
		})

		items["sat"] = library:create("TextButton", {
			Parent = items["saturation_holder"],
			Name = "\0",
			Size = dim2(1, 0, 1, 0),
			Text = "",
			AutoButtonColor = false,
			BorderColor3 = rgb(0, 0, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UICorner", {
			Parent = items["sat"],
			CornerRadius = dim(0, 4),
		})

		library:create("UIGradient", {
			Rotation = 270,
			Transparency = numseq({ numkey(0, 0), numkey(1, 1) }),
			Parent = items["sat"],
			Color = rgbseq({ rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0)) }),
		})

		items["val"] = library:create("Frame", {
			Name = "\0",
			Parent = items["saturation_holder"],
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIGradient", {
			Parent = items["val"],
			Transparency = numseq({ numkey(0, 0), numkey(1, 1) }),
		})

		library:create("UICorner", {
			Parent = items["val"],
			CornerRadius = dim(0, 4),
		})

		library:create("UICorner", {
			Parent = items["saturation_holder"],
			CornerRadius = dim(0, 4),
		})

		items["satvalpicker"] = library:create("TextButton", {
			BorderColor3 = rgb(0, 0, 0),
			AutoButtonColor = false,
			Text = "",
			AnchorPoint = vec2(0, 1),
			Parent = items["saturation_holder"],
			Name = "\0",
			Position = dim2(0, 0, 4, 0),
			Size = dim2(0, 8, 0, 8),
			ZIndex = 5,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 0, 0),
		})

		library:create("UICorner", {
			Parent = items["satvalpicker"],
			CornerRadius = dim(0, 9999),
		})

		library:create("UIStroke", {
			Color = rgb(255, 255, 255),
			Parent = items["satvalpicker"],
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		items["hue_gradient"] = library:create("TextButton", {
			Parent = items["colorpicker_components"],
			Name = "\0",
			Position = dim2(0, 10, 1, -64),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -20, 0, 8),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
			AutoButtonColor = false,
			Text = "",
		})

		library:create("UIGradient", {
			Color = rgbseq({
				rgbkey(0, rgb(255, 0, 0)),
				rgbkey(0.17, rgb(255, 255, 0)),
				rgbkey(0.33, rgb(0, 255, 0)),
				rgbkey(0.5, rgb(0, 255, 255)),
				rgbkey(0.67, rgb(0, 0, 255)),
				rgbkey(0.83, rgb(255, 0, 255)),
				rgbkey(1, rgb(255, 0, 0)),
			}),
			Parent = items["hue_gradient"],
		})

		library:create("UICorner", {
			Parent = items["hue_gradient"],
			CornerRadius = dim(0, 6),
		})

		items["hue_picker"] = library:create("TextButton", {
			BorderColor3 = rgb(0, 0, 0),
			AutoButtonColor = false,
			Text = "",
			AnchorPoint = vec2(0, 0.5),
			Parent = items["hue_gradient"],
			Name = "\0",
			Position = dim2(0, 0, 0.5, 0),
			Size = dim2(0, 8, 0, 8),
			ZIndex = 5,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 0, 0),
		})

		library:create("UICorner", {
			Parent = items["hue_picker"],
			CornerRadius = dim(0, 9999),
		})

		library:create("UIStroke", {
			Color = rgb(255, 255, 255),
			Parent = items["hue_picker"],
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		items["alpha_gradient"] = library:create("TextButton", {
			Parent = items["colorpicker_components"],
			Name = "\0",
			Position = dim2(0, 10, 1, -46),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -20, 0, 8),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(26, 26, 26),
			AutoButtonColor = false,
			Text = "",
		})

		library:create("UICorner", {
			Parent = items["alpha_gradient"],
			CornerRadius = dim(0, 6),
		})

		items["alpha_picker"] = library:create("TextButton", {
			BorderColor3 = rgb(0, 0, 0),
			AutoButtonColor = false,
			Text = "",
			AnchorPoint = vec2(0, 0.5),
			Parent = items["alpha_gradient"],
			Name = "\0",
			Position = dim2(1, 0, 0.5, 0),
			Size = dim2(0, 8, 0, 8),
			ZIndex = 5,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 0, 0),
		})

		library:create("UICorner", {
			Parent = items["alpha_picker"],
			CornerRadius = dim(0, 9999),
		})

		library:create("UIStroke", {
			Color = rgb(255, 255, 255),
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = items["alpha_picker"],
		})

		library:create("UIGradient", {
			Color = rgbseq({ rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255)) }),
			Parent = items["alpha_gradient"],
		})

		items["alpha_indicator"] = library:create("ImageLabel", {
			ScaleType = Enum.ScaleType.Tile,
			BorderColor3 = rgb(0, 0, 0),
			Parent = items["alpha_gradient"],
			Image = "rbxassetid://18274452449",
			BackgroundTransparency = 1,
			Name = "\0",
			Size = dim2(1, 0, 1, 0),
			TileSize = dim2(0, 6, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(0, 0, 0),
		})

		library:create("UIGradient", {
			Color = rgbseq({ rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0)) }),
			Transparency = numseq({ numkey(0, 0.8062499761581421), numkey(1, 0) }),
			Parent = items["alpha_indicator"],
		})

		library:create("UICorner", {
			Parent = items["alpha_indicator"],
			CornerRadius = dim(0, 6),
		})

		library:create("UIGradient", {
			Rotation = 90,
			Parent = items["colorpicker_components"],
			Color = rgbseq({ rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66)) }),
		})

		items["input"] = library:create("TextBox", {
			FontFace = fonts.font,
			AnchorPoint = vec2(1, 1),
			Text = "",
			Parent = items["colorpicker_components"],
			Name = "\0",
			TextTruncate = Enum.TextTruncate.AtEnd,
			BorderSizePixel = 0,
			PlaceholderColor3 = rgb(255, 255, 255),
			CursorPosition = -1,
			ClearTextOnFocus = false,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
			TextColor3 = rgb(122, 122, 122),
			BorderColor3 = rgb(0, 0, 0),
			Position = dim2(1, -8, 1, -11),
			Size = dim2(1, -16, 0, 18),
			BackgroundColor3 = rgb(34, 34, 34),
		})

		library:create("UICorner", {
			Parent = items["input"],
			CornerRadius = dim(0, 3),
		})

		items["UICorenr"] = library:create("UICorner", { -- fire misstypo (im not fixing this RAWR)
			Parent = items["colorpicker_holder"],
			Name = "\0",
			CornerRadius = dim(0, 4),
		})
		--
	end

	function cfg.set_visible(bool)
		items["colorpicker_fade"].BackgroundTransparency = 0
		items["colorpicker_holder"].Parent = bool and library["items"] or library["other"]
		items["colorpicker_holder"].Position = dim_offset(
			items["colorpicker"].AbsolutePosition.X,
			items["colorpicker"].AbsolutePosition.Y + items["colorpicker"].AbsoluteSize.Y + 45
		)

		library:tween(items["colorpicker_fade"], { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, 0.4)
		library:tween(
			items["colorpicker_holder"],
			{ Position = items["colorpicker_holder"].Position + dim_offset(0, 20) }
		) -- p100 check

		if not (self.sanity and library.current_open == self and self.open) then
			library:close_element(cfg)
		end
	end

	function cfg.set(color, alpha)
		if type(color) == "boolean" then
			return
		end

		if color then
			h, s, v = color:ToHSV()
		end

		if alpha then
			a = alpha
		end

		local Color = hsv(h, s, v)

		-- Ok so quick story, should I cache any of this? no...?? anyways I know this code is very bad but its your fault for buying a ui with animations (on a serious note im too lazy to make this look nice)
		-- Also further note, yeah I kind of did this scale_factor * size-valuesize.plane because then I would have to do tomfoolery to make it clip properly.
		library:tween(items["hue_picker"], {
			Position = dim2(0, (items["hue_gradient"].AbsoluteSize.X - items["hue_picker"].AbsoluteSize.X) * h, 0.5, 0),
		}, Enum.EasingStyle.Linear, 0.05)
		library:tween(items["alpha_picker"], {
			Position = dim2(
				0,
				(items["alpha_gradient"].AbsoluteSize.X - items["alpha_picker"].AbsoluteSize.X) * (1 - a),
				0.5,
				0
			),
		}, Enum.EasingStyle.Linear, 0.05)
		library:tween(items["satvalpicker"], {
			Position = dim2(
				0,
				s * (items["saturation_holder"].AbsoluteSize.X - items["satvalpicker"].AbsoluteSize.X),
				1,
				1 - v * (items["saturation_holder"].AbsoluteSize.Y - items["satvalpicker"].AbsoluteSize.Y)
			),
		}, Enum.EasingStyle.Linear, 0.05)

		items["alpha_indicator"]:FindFirstChildOfClass("UIGradient").Color =
			rgbseq({ rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1)) }) -- shit code

		items["colorpicker"].BackgroundColor3 = Color
		items["colorpicker_inline"].BackgroundColor3 = Color
		items["saturation_holder"].BackgroundColor3 = hsv(h, 1, 1)

		items["hue_picker"].BackgroundColor3 = hsv(h, 1, 1)
		items["alpha_picker"].BackgroundColor3 = hsv(h, 1, 1 - a)
		items["satvalpicker"].BackgroundColor3 = hsv(h, s, v)

		flags[cfg.flag] = {
			Color = Color,
			Transparency = a,
		}

		local color = items["colorpicker"].BackgroundColor3
		items["input"].Text = string.format(
			"%s, %s, %s, ",
			library:round(color.R * 255),
			library:round(color.G * 255),
			library:round(color.B * 255)
		)
		items["input"].Text ..= library:round(1 - a, 0.01)

		cfg.callback(Color, a)
	end

	function cfg.update_color()
		local mouse = uis:GetMouseLocation()
		local offset = vec2(mouse.X, mouse.Y - gui_offset)

		if dragging_sat then
			s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
		elseif dragging_hue then
			h = math.clamp(
				(offset - items["hue_gradient"].AbsolutePosition).X / items["hue_gradient"].AbsoluteSize.X,
				0,
				1
			)
		elseif dragging_alpha then
			a = 1
				- math.clamp(
					(offset - items["alpha_gradient"].AbsolutePosition).X / items["alpha_gradient"].AbsoluteSize.X,
					0,
					1
				)
		end

		cfg.set()
	end

	items["colorpicker"].MouseButton1Click:Connect(function()
		cfg.open = not cfg.open

		cfg.set_visible(cfg.open)
	end)

	uis.InputChanged:Connect(function(input)
		if
			(dragging_sat or dragging_hue or dragging_alpha)
			and input.UserInputType == Enum.UserInputType.MouseMovement
		then
			cfg.update_color()
		end
	end)

	library:connection(uis.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging_sat = false
			dragging_hue = false
			dragging_alpha = false
		end
	end)

	items["alpha_gradient"].MouseButton1Down:Connect(function()
		dragging_alpha = true
	end)

	items["hue_gradient"].MouseButton1Down:Connect(function()
		dragging_hue = true
	end)

	items["sat"].MouseButton1Down:Connect(function()
		dragging_sat = true
	end)

	items["input"].FocusLost:Connect(function()
		local text = items["input"].Text
		local r, g, b, a = library:convert(text)

		if r and g and b and a then
			cfg.set(rgb(r, g, b), 1 - a)
		end
	end)

	items["input"].Focused:Connect(function()
		library:tween(items["input"], { TextColor3 = rgb(242, 242, 242) })
	end)

	items["input"].FocusLost:Connect(function()
		library:tween(items["input"], { TextColor3 = rgb(122, 122, 122) })
	end)

	cfg.set(cfg.color, cfg.alpha)
	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:textbox(options)
	local cfg = {
		name = options.name or "TextBox",
		placeholder = options.placeholder
			or options.placeholdertext
			or options.holder
			or options.holdertext
			or "type here...",
		default = options.default or "",
		flag = options.flag or library:next_flag(),
		callback = options.callback or function() end,
		visible = options.visible or true,
		items = {},
	}

	flags[cfg.flag] = cfg.default

	local items = cfg.items
	do
		items["textbox"] = library:create("TextButton", {
			LayoutOrder = -1,
			FontFace = fonts.font,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			Parent = self.items["elements"],
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["name"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(242, 242, 242),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["textbox"],
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIPadding", {
			Parent = items["name"],
			PaddingRight = dim(0, 5),
			PaddingLeft = dim(0, 5),
		})

		items["right_components"] = library:create("Frame", {
			Parent = items["textbox"],
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 4, 0, 19),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 0, 12),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			Parent = items["right_components"],
			Padding = dim(0, 7),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
		})

		items["input"] = library:create("TextBox", {
			FontFace = fonts.font,
			Text = "",
			Parent = items["right_components"],
			Name = "\0",
			TextTruncate = Enum.TextTruncate.AtEnd,
			BorderSizePixel = 0,
			PlaceholderColor3 = rgb(255, 255, 255),
			CursorPosition = -1,
			ClearTextOnFocus = false,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
			TextColor3 = rgb(122, 122, 122),
			BorderColor3 = rgb(0, 0, 0),
			Position = dim2(1, 0, 0, 0),
			Size = dim2(1, -4, 0, 30),
			BackgroundColor3 = rgb(34, 34, 34),
		})

		library:create("UICorner", {
			Parent = items["input"],
			CornerRadius = dim(0, 3),
		})

		library:create("UIPadding", {
			Parent = items["right_components"],
			PaddingTop = dim(0, 4),
			PaddingRight = dim(0, 4),
		})
	end

	function cfg.set(text)
		flags[cfg.flag] = text

		items["input"].Text = text

		cfg.callback(text)
	end

	items["input"]:GetPropertyChangedSignal("Text"):Connect(function()
		cfg.set(items["input"].Text)
	end)

	items["input"].Focused:Connect(function()
		library:tween(items["input"], { TextColor3 = rgb(242, 242, 242) })
	end)

	items["input"].FocusLost:Connect(function()
		library:tween(items["input"], { TextColor3 = rgb(122, 122, 122) })
	end)

	if cfg.default then
		cfg.set(cfg.default)
	end

	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:keybind(options)
	local cfg = {
		flag = options.flag or library:next_flag(),
		callback = options.callback or function() end,
		name = options.name or nil,
		ignore_key = options.ignore or false,

		key = options.key or nil,
		mode = options.mode or "Toggle",
		active = options.default or false,

		open = false,
		binding = nil,

		hold_instances = {},
		items = {},
	}

	flags[cfg.flag] = {
		mode = cfg.mode,
		key = cfg.key,
		active = cfg.active,
	}

	local items = cfg.items
	do
		-- Component
		items["keybind_element"] = library:create("TextButton", {
			FontFace = fonts.font,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			Parent = self.items["elements"],
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		items["name"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(242, 242, 242),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["keybind_element"],
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIPadding", {
			Parent = items["name"],
			PaddingRight = dim(0, 5),
			PaddingLeft = dim(0, 5),
		})

		items["right_components"] = library:create("Frame", {
			Parent = items["keybind_element"],
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = items["right_components"],
			Padding = dim(0, 7),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		items["keybind_holder"] = library:create("TextButton", {
			FontFace = fonts.font,
			TextColor3 = rgb(0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			Parent = items["right_components"],
			AutoButtonColor = false,
			AnchorPoint = vec2(1, 0),
			Size = dim2(0, 0, 0, 16),
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 14,
			BackgroundColor3 = rgb(34, 34, 34),
		})

		library:create("UICorner", {
			Parent = items["keybind_holder"],
			CornerRadius = dim(0, 4),
		})

		items["key"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(110, 110, 110),
			BorderColor3 = rgb(0, 0, 0),
			Text = "LSHIFT",
			Parent = items["keybind_holder"],
			Name = "\0",
			Size = dim2(1, -12, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIPadding", {
			Parent = items["key"],
			PaddingTop = dim(0, 1),
			PaddingRight = dim(0, 5),
			PaddingLeft = dim(0, 5),
		})
		--

		-- Mode Holder
		items["dropdown"] = library:create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = library.items,
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 0, 0, 0),
			Size = dim2(0, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = rgb(0, 0, 0),
		})

		items["inline"] = library:create("Frame", {
			Parent = items["dropdown"],
			Size = dim2(1, 0, 1, 0),
			Name = "\0",
			ClipsDescendants = true,
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(19, 19, 19),
		})

		library:create("UIPadding", {
			PaddingBottom = dim(0, 6),
			PaddingTop = dim(0, 3),
			PaddingLeft = dim(0, 3),
			Parent = items["inline"],
		})

		library:create("UIListLayout", {
			Parent = items["inline"],
			Padding = dim(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		library:create("UICorner", {
			Parent = items["inline"],
			CornerRadius = dim(0, 4),
		})

		local options = { "Hold", "Toggle", "Always" }

		cfg.y_size = 20
		for _, option in options do
			local name = library:create("TextButton", {
				FontFace = fonts.font,
				TextColor3 = rgb(122, 122, 122),
				BorderColor3 = rgb(0, 0, 0),
				Text = option,
				Parent = items["inline"],
				Name = "\0",
				Size = dim2(0, 0, 0, 0),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 14,
				BackgroundColor3 = rgb(255, 255, 255),
			})
			cfg.hold_instances[option] = name
			library:apply_theme(name, "accent", "TextColor3")

			cfg.y_size += name.AbsoluteSize.Y

			library:create("UIPadding", {
				Parent = name,
				PaddingTop = dim(0, 1),
				PaddingRight = dim(0, 5),
				PaddingLeft = dim(0, 5),
			})

			name.MouseButton1Click:Connect(function()
				cfg.set(option)

				cfg.set_visible(false)

				cfg.open = false
			end)
		end
		--
	end

	function cfg.modify_mode_color(path) -- ts so frikin tuff 💀
		for _, v in cfg.hold_instances do
			v.TextColor3 = rgb(122, 122, 122)
		end

		cfg.hold_instances[path].TextColor3 = themes.preset.accent
	end

	function cfg.set_mode(mode)
		cfg.mode = mode

		if mode == "Always" then
			cfg.set(true)
		elseif mode == "Hold" then
			cfg.set(false)
		end

		flags[cfg.flag]["mode"] = mode
		cfg.modify_mode_color(mode)
	end

	function cfg.set(input)
		if type(input) == "boolean" then
			cfg.active = input

			if cfg.mode == "Always" then
				cfg.active = true
			end
		elseif tostring(input):find("Enum") then
			input = input.Name == "Escape" and "NONE" or input

			cfg.key = input or "NONE"
		elseif find({ "Toggle", "Hold", "Always" }, input) then
			if input == "Always" then
				cfg.active = true
			end

			cfg.mode = input
			cfg.set_mode(cfg.mode)
		elseif type(input) == "table" then
			input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key)
				or input.key
			input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

			cfg.key = input.key or "NONE"
			cfg.mode = input.mode or "Toggle"

			if input.active then
				cfg.active = input.active
			end

			cfg.set_mode(cfg.mode)
		end

		cfg.callback(cfg.active)

		local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
		local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

		items["key"].Text = __text

		flags[cfg.flag] = {
			mode = cfg.mode,
			key = cfg.key,
			active = cfg.active,
		}
	end

	function cfg.set_visible(bool)
		local size = bool and cfg.y_size or 0
		library:tween(items["dropdown"], { Size = dim_offset(items["keybind_holder"].AbsoluteSize.X, size) })

		items["dropdown"].Position = dim_offset(
			items["keybind_holder"].AbsolutePosition.X,
			items["keybind_holder"].AbsolutePosition.Y + items["keybind_holder"].AbsoluteSize.Y + 60
		)
	end

	items["keybind_holder"].MouseButton1Down:Connect(function()
		task.wait()
		items["key"].Text = "..."

		cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)
			cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)

			cfg.binding:Disconnect()
			cfg.binding = nil
		end)
	end)

	items["keybind_holder"].MouseButton2Down:Connect(function()
		cfg.open = not cfg.open

		cfg.set_visible(cfg.open)
	end)

	library:connection(uis.InputBegan, function(input, game_event)
		if not game_event then
			local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
				or input.UserInputType

			if selected_key == cfg.key then
				if cfg.mode == "Toggle" then
					cfg.active = not cfg.active
					cfg.set(cfg.active)
				elseif cfg.mode == "Hold" then
					cfg.set(true)
				end
			end
		end
	end)

	library:connection(uis.InputEnded, function(input, game_event)
		if game_event then
			return
		end

		local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

		if selected_key == cfg.key then
			if cfg.mode == "Hold" then
				cfg.set(false)
			end
		end
	end)

	cfg.set({ mode = cfg.mode, active = cfg.active, key = cfg.key })
	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:button(options)
	local cfg = {
		name = options.name or "Button",
		callback = options.callback or function() end,
		new_row = options.new_row or options.NewRow or false,
		items = {},
	}

	local items = cfg.items
	do
		local parent = self.items["elements"]
		local row = library.current_button_row

		if row and (row.count >= 2 or row.frame.Parent ~= parent or cfg.new_row) then
			row = nil
		end

		if row then
			local children = {}
			for _, child in parent:GetChildren() do
				if child:IsA("GuiObject") then
					children[#children + 1] = child
				end
			end

			if children[#children] ~= row.frame then
				row = nil
			end
		end

		if not row then
			row = { count = 0 }
			row.frame = library:create("Frame", {
				Parent = parent,
				Name = "\0",
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 0, 26),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
			})

			library.current_button_row = row
		end

		row.count += 1
		local right = row.count == 2

		items["button"] = library:create("TextButton", {
			FontFace = fonts.font,
			TextColor3 = rgb(242, 242, 242),
			Text = "",
			AutoButtonColor = false,
			ClipsDescendants = true,
			Parent = row.frame,
			Name = "\0",
			Position = right and dim2(0.5, 3, 0, 0) or dim2(0, 5, 0, 0),
			Size = dim2(0.5, -8, 1, 0),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			TextSize = 15,
			BackgroundColor3 = rgb(28, 28, 28),
			ZIndex = 1,
		})

		library:create("UICorner", {
			Parent = items["button"],
			CornerRadius = dim(0, 5),
		})

		library:create("UIStroke", {
			Parent = items["button"],
			Color = rgb(42, 42, 42),
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		items["ripple"] = library:create("Frame", {
			Parent = items["button"],
			Name = "\0",
			AnchorPoint = vec2(0.5, 0.5),
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(0, 0, 1, 0),
			BackgroundColor3 = themes.preset.accent,
			BackgroundTransparency = 1,
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 1,
		})

		library:create("UICorner", {
			Parent = items["ripple"],
			CornerRadius = dim(0, 5),
		})

		items["name"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(242, 242, 242),
			Text = cfg.name,
			Parent = items["button"],
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 1, 0),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			TextSize = 15,
			BackgroundColor3 = rgb(255, 255, 255),
			ZIndex = 2,
		})
	end

	local idle_color = rgb(28, 28, 28)
	local hover_color = rgb(38, 38, 38)
	local press_color = rgb(46, 46, 46)

	local hovered = false

	items["button"].MouseEnter:Connect(function()
		hovered = true

		library:tween(items["button"], { BackgroundColor3 = hover_color }, Enum.EasingStyle.Quad, 0.15)
		library:tween(items["name"], { TextColor3 = themes.preset.accent }, Enum.EasingStyle.Quad, 0.15)
	end)

	items["button"].MouseLeave:Connect(function()
		hovered = false

		library:tween(items["button"], { BackgroundColor3 = idle_color }, Enum.EasingStyle.Quad, 0.15)
		library:tween(items["name"], { TextColor3 = rgb(242, 242, 242) }, Enum.EasingStyle.Quad, 0.15)
	end)

	items["button"].MouseButton1Down:Connect(function()
		library:tween(items["button"], { BackgroundColor3 = press_color }, Enum.EasingStyle.Quad, 0.08)
		library:tween(items["name"], { TextColor3 = rgb(255, 255, 255) }, Enum.EasingStyle.Quad, 0.08)
	end)

	items["button"].MouseButton1Up:Connect(function()
		library:tween(
			items["button"],
			{ BackgroundColor3 = hovered and hover_color or idle_color },
			Enum.EasingStyle.Quad,
			0.12
		)
	end)

	items["button"].MouseButton1Click:Connect(function()
		local ripple = items["ripple"]

		ripple.Size = dim2(0, 0, 1, 0)
		ripple.BackgroundTransparency = 0.15

		library:tween(ripple, { Size = dim2(1, 0, 1, 0) }, Enum.EasingStyle.Quad, 0.34)
		library:tween(ripple, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, 0.55)

		items["name"].TextColor3 = themes.preset.accent
		library:tween(items["name"], { TextColor3 = rgb(242, 242, 242) })

		cfg.callback()
	end)

	return setmetatable(cfg, library)
end

function library:settings(options)
	local cfg = {
		open = false,
		items = {},
		sanity = true, -- made this for my own sanity.
	}

	local items = cfg.items
	do
		items["outline"] = library:create("Frame", {
			Name = "\0",
			Visible = true,
			Parent = library["items"],
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, 0, 0),
			ClipsDescendants = true,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = rgb(26, 26, 26),
		})

		items["inline"] = library:create("Frame", {
			Parent = items["outline"],
			Name = "\0",
			Position = dim2(0, 1, 0, 1),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -2, 1, -2),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(19, 19, 19),
		})

		library:create("UICorner", {
			Parent = items["inline"],
			CornerRadius = dim(0, 7),
		})

		items["elements"] = library:create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = items["inline"],
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 10, 0, 10),
			Size = dim2(1, -20, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			Parent = items["elements"],
			Padding = dim(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		library:create("UIPadding", {
			PaddingBottom = dim(0, 15),
			Parent = items["elements"],
		})

		library:create("UICorner", {
			Parent = items["outline"],
			CornerRadius = dim(0, 7),
		})

		library:create("UICorner", {
			Parent = items["fade"],
			CornerRadius = dim(0, 7),
		})

		items["tick"] = library:create("ImageButton", {
			Image = "rbxassetid://128797200442698",
			Name = "\0",
			AutoButtonColor = false,
			Parent = self.items["right_components"],
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 16, 0, 16),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})
	end

	function cfg.set_visible(bool)
		library:tween(items["outline"], { Size = dim_offset(bool and 240 or 0, 0) })
		items["outline"].Position = dim_offset(items["tick"].AbsolutePosition.X, items["tick"].AbsolutePosition.Y + 90)
		library:close_element(cfg)
	end

	items["tick"].MouseButton1Click:Connect(function()
		cfg.open = not cfg.open

		cfg.set_visible(cfg.open)
	end)

	return setmetatable(cfg, library)
end

function library:list(properties)
	local cfg = {
		items = {},
		options = properties.options or { "1", "2", "3" },
		flag = properties.flag or library:next_flag(),
		callback = properties.callback or function() end,
		data_store = {},
		current_element,
	}

	local items = cfg.items
	do
		items["list"] = library:create("Frame", {
			Parent = self.items["elements"],
			BackgroundTransparency = 1,
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIListLayout", {
			Parent = items["list"],
			Padding = dim(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		library:create("UIPadding", {
			Parent = items["list"],
			PaddingRight = dim(0, 4),
			PaddingLeft = dim(0, 4),
		})
	end

	function cfg.refresh_options(options_to_refresh) -- ignore goofy parameter
		for _, option in cfg.data_store do
			option:Destroy()
		end

		for _, option_data in options_to_refresh do -- haha u skids no next >_<
			local button = library:create("TextButton", {
				FontFace = fonts.small,
				TextColor3 = rgb(0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				AutoButtonColor = false,
				AnchorPoint = vec2(1, 0),
				Parent = items["list"],
				Name = "\0",
				Position = dim2(1, 0, 0, 0),
				Size = dim2(1, 0, 0, 30),
				BorderSizePixel = 0,
				TextSize = 14,
				BackgroundColor3 = rgb(34, 34, 34),
			})
			cfg.data_store[#cfg.data_store + 1] = button

			local name = library:create("TextLabel", {
				FontFace = fonts.font,
				TextColor3 = rgb(122, 122, 122),
				BorderColor3 = rgb(0, 0, 0),
				Text = option_data,
				Parent = button,
				Name = "\0",
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 14,
				BackgroundColor3 = rgb(255, 255, 255),
			})

			library:create("UICorner", {
				Parent = button,
				CornerRadius = dim(0, 3),
			})

			button.MouseButton1Click:Connect(function()
				local current = cfg.current_element
				if current and current ~= name then
					library:tween(current, { TextColor3 = rgb(122, 122, 122) })
				end

				flags[cfg.flag] = option_data
				cfg.callback(option_data)
				library:tween(name, { TextColor3 = rgb(242, 242, 242) })
				cfg.current_element = name
			end)

			name.MouseEnter:Connect(function()
				if cfg.current_element == name then
					return
				end

				library:tween(name, { TextColor3 = rgb(140, 140, 140) })
			end)

			name.MouseLeave:Connect(function()
				if cfg.current_element == name then
					return
				end

				library:tween(name, { TextColor3 = rgb(122, 122, 122) })
			end)
		end
	end

	cfg.refresh_options(cfg.options)

	return setmetatable(cfg, library)
end

function library:init_config(window)
	window:seperator({ name = "Settings" })
	local main = window:tab({ name = "Configs", tabs = { "Main" } })

	local column = main:column({})
	local section =
		column:section({ name = "Configs", size = 1, default = true, icon = "rbxassetid://139628202576511" })
	config_holder = section:list({
		options = { "Report", "This", "Error", "To", "Finobe" },
		callback = function(option) end,
		flag = "config_name_list",
	})
	library:update_config_list()

	local column = main:column({})
	local section = column:section({
		name = "Settings",
		side = "right",
		size = 1,
		default = true,
		icon = "rbxassetid://129380150574313",
	})
	section:textbox({ name = "Config name:", flag = "config_name_text" })
	section:button({
		name = "Save",
		callback = function()
			writefile(
				library.directory .. "/configs/" .. flags["config_name_text"] or flags["config_name_list"] .. ".cfg",
				library:get_config()
			)
			library:update_config_list()
			notifications:create_notification({
				name = "Configs",
				info = "Saved config to:\n" .. flags["config_name_list"] or flags["config_name_text"],
			})
		end,
	})
	section:button({
		name = "Load",
		callback = function()
			library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))
			library:update_config_list()
			notifications:create_notification({
				name = "Configs",
				info = "Loaded config:\n" .. flags["config_name_list"],
			})
		end,
	})
	section:button({
		name = "Delete",
		callback = function()
			delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
			library:update_config_list()
			notifications:create_notification({
				name = "Configs",
				info = "Deleted config:\n" .. flags["config_name_list"],
			})
		end,
	})
	section:colorpicker({
		name = "Menu Accent",
		callback = function(color, alpha)
			library:update_theme("accent", color)
		end,
		color = themes.preset.accent,
	})
	section:keybind({
		name = "Menu Bind",
		callback = function(bool)
			window.toggle_menu(bool)
		end,
		default = true,
	})
end
--

-- Notification Library
function notifications:refresh_notifs()
	local offset = 50

	for i, v in notifications.notifs do
		local Position = vec2(20, offset)
		library:tween(v, { Position = dim_offset(Position.X, Position.Y) }, Enum.EasingStyle.Quad, 0.4)
		offset += (v.AbsoluteSize.Y + 10)
	end

	return offset
end

function notifications:fade(path, is_fading)
	local fading = is_fading and 1 or 0

	library:tween(path, { BackgroundTransparency = fading }, Enum.EasingStyle.Quad, 1)

	for _, instance in path:GetDescendants() do
		if not instance:IsA("GuiObject") then
			if instance:IsA("UIStroke") then
				library:tween(instance, { Transparency = fading }, Enum.EasingStyle.Quad, 1)
			end

			continue
		end

		if instance:IsA("TextLabel") then
			library:tween(instance, { TextTransparency = fading })
		elseif instance:IsA("Frame") then
			library:tween(
				instance,
				{ BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6 },
				Enum.EasingStyle.Quad,
				1
			)
		end
	end
end

function notifications:create_notification(options)
	local cfg = {
		name = options.name or "This is a title!",
		info = options.info or "This is extra info!",
		lifetime = options.lifetime or 3,
		items = {},
		outline,
	}

	local items = cfg.items
	do
		items["notification"] = library:create("Frame", {
			Parent = library["items"],
			Size = dim2(0, 210, 0, 53),
			Name = "\0",
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AnchorPoint = vec2(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = rgb(15, 15, 15),
		})

		library:create("UIStroke", {
			Color = rgb(32, 32, 32),
			Parent = items["notification"],
			Transparency = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		items["title"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.name,
			Parent = items["notification"],
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 7, 0, 6),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UICorner", {
			Parent = items["notification"],
			CornerRadius = dim(0, 3),
		})

		items["info"] = library:create("TextLabel", {
			FontFace = fonts.font,
			TextColor3 = rgb(145, 145, 145),
			BorderColor3 = rgb(0, 0, 0),
			Text = cfg.info,
			Parent = items["notification"],
			Name = "\0",
			Position = dim2(0, 9, 0, 22),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		library:create("UIPadding", {
			PaddingBottom = dim(0, 17),
			PaddingRight = dim(0, 8),
			Parent = items["info"],
		})

		items["bar"] = library:create("Frame", {
			AnchorPoint = vec2(0, 1),
			Parent = items["notification"],
			Name = "\0",
			Position = dim2(0, 8, 1, -6),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, 0, 5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			BackgroundColor3 = themes.preset.accent,
		})

		library:create("UICorner", {
			Parent = items["bar"],
			CornerRadius = dim(0, 999),
		})

		library:create("UIPadding", {
			PaddingRight = dim(0, 8),
			Parent = items["notification"],
		})
	end

	local index = #notifications.notifs + 1
	notifications.notifs[index] = items["notification"]

	notifications:fade(items["notification"], false)

	local offset = notifications:refresh_notifs()

	items["notification"].Position = dim_offset(20, offset)

	library:tween(items["notification"], { AnchorPoint = vec2(0, 0) }, Enum.EasingStyle.Quad, 1)
	library:tween(items["bar"], { Size = dim2(1, -8, 0, 5) }, Enum.EasingStyle.Quad, cfg.lifetime)

	task.spawn(function()
		task.wait(cfg.lifetime)

		notifications.notifs[index] = nil

		notifications:fade(items["notification"], true)

		library:tween(items["notification"], { AnchorPoint = vec2(1, 0) }, Enum.EasingStyle.Quad, 1)

		task.wait(1)

		items["notification"]:Destroy()
	end)
end
--
--

return library
