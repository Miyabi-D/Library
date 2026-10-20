--!strict
local cloneref = (cloneref or clonereference or function(instance: any)
	return instance
end)
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))
local Workspace: Workspace = cloneref(game:GetService("Workspace"))
local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local MarketplaceService: MarketplaceService = cloneref(game:GetService("MarketplaceService"))
local StatsService: Stats = cloneref(game:GetService("Stats"))
local Lighting: Lighting = cloneref(game:GetService("Lighting"))

local getgenv = getgenv or function()
	return shared
end
local gethui = gethui or function()
	return CoreGui
end

local ExistingLibrary = getgenv().Library
if ExistingLibrary and ExistingLibrary.Unload then
	pcall(function()
		ExistingLibrary:Unload()
	end)

	for _, Holder in { ExistingLibrary.Holder, ExistingLibrary.UnusedHolder } do
		if Holder then
			pcall(function()
				Holder:Clean()
			end)
		end
	end

	getgenv().Library = nil
end

local Library
do
	local LocalPlayer = Players.LocalPlayer
	local Camera = Workspace.CurrentCamera
	local Mouse = LocalPlayer:GetMouse()

	local FromRGB = Color3.fromRGB
	local FromHSV = Color3.fromHSV
	local FromHex = Color3.fromHex

	local RGBSequence = ColorSequence.new
	local RGBSequenceKeypoint = ColorSequenceKeypoint.new
	local NumSequence = NumberSequence.new
	local NumSequenceKeypoint = NumberSequenceKeypoint.new

	local UDim2New = UDim2.new
	local UDimNew = UDim.new
	local UDim2FromOffset = UDim2.fromOffset
	local Vector2New = Vector2.new
	local Vector3New = Vector3.new

	local InstanceNew = Instance.new

	local RectNew = Rect.new

	local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
	local CreateIcon

	local MoltoSource = "https://raw.githubusercontent.com/notpoiu/Molto/refs/heads/main/source.lua"
	local LucideSource = "https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/refs/heads/main/source.lua"

	Library = {
		Version = "1.0.0",
		Theme = {},

		MenuKeybind = Enum.KeyCode.RightControl,

		Flags = {},

		Tween = {
			Time = 0.25,
			Style = Enum.EasingStyle.Quart,
			Direction = Enum.EasingDirection.Out,
		},

		FadeSpeed = 0.2,

		Folders = {
			Directory = "lds13",
			Configs = "lds13/Configs",
			Assets = "lds13/Assets",
		},

		SetFolders = function(self, Custom)
			if type(Custom) ~= "table" then
				return self.Folders
			end
			for Key, Value in pairs(Custom) do
				self.Folders[Key] = Value
			end
			if Custom.Directory and not Custom.Configs then
				self.Folders.Configs = Custom.Directory .. "/Configs"
			end
			if Custom.Directory and not Custom.Assets then
				self.Folders.Assets = Custom.Directory .. "/Assets"
			end
			for _, Path in pairs(self.Folders) do
				if not isfolder(Path) then
					makefolder(Path)
				end
			end
			return self.Folders
		end,

		ToggleMenu = function(self)
			if self.MainWindow then
				self.MainWindow:SetOpen(not self.MainWindow.IsOpen)
			end
		end,

		SetMenuVisible = function(self, Visible)
			if self.MainWindow then
				self.MainWindow:SetOpen(not not Visible)
			end
		end,

		-- 忽略以下内容
		Pages = {},
		Sections = {},

		Connections = {},
		Threads = {},

		ThemeMap = {},
		ThemeItems = {},

		OpenFrames = {},

		SetFlags = {},

		SearchItems = {},
		Keybinds = {},
		HotkeyInstances = {},
		CurrentPage = nil,

		UnnamedConnections = 0,
		UnnamedFlags = 0,

		MainWindow = nil,

		NotifOrder = {},

		Holder = nil,
		NotifHolder = nil,
		UnusedHolder = nil,

		NotifySide = "Right",
		NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

		Font = nil,
		BoldFont = nil,
		RegularFont = nil,
		WatermarkInstance = nil,
		KeysystemInstance = nil,
		CreditsInstance = nil,
		BackgroundEffects = nil,
		BackgroundEffectsEnabled = true,
		BackgroundEffectsUserEnabled = true,
		UserScale = 1,
		UIScale = nil,
	}

	Library.__index = Library
	Library.Sections.__index = Library.Sections
	Library.Pages.__index = Library.Pages

	local Keys = {
		["Unknown"] = "Unknown",
		["Backspace"] = "Back",
		["Tab"] = "Tab",
		["Clear"] = "Clear",
		["Return"] = "Return",
		["Pause"] = "Pause",
		["Escape"] = "Escape",
		["Space"] = "Space",
		["QuotedDouble"] = '"',
		["Hash"] = "#",
		["Dollar"] = "$",
		["Percent"] = "%",
		["Ampersand"] = "&",
		["Quote"] = "'",
		["LeftParenthesis"] = "(",
		["RightParenthesis"] = " )",
		["Asterisk"] = "*",
		["Plus"] = "+",
		["Comma"] = ",",
		["Minus"] = "-",
		["Period"] = ".",
		["Slash"] = "`",
		["Three"] = "3",
		["Seven"] = "7",
		["Eight"] = "8",
		["Colon"] = ":",
		["Semicolon"] = ";",
		["LessThan"] = "<",
		["GreaterThan"] = ">",
		["Question"] = "?",
		["Equals"] = "=",
		["At"] = "@",
		["LeftBracket"] = "LeftBracket",
		["RightBracket"] = "RightBracked",
		["BackSlash"] = "BackSlash",
		["Caret"] = "^",
		["Underscore"] = "_",
		["Backquote"] = "`",
		["LeftCurly"] = "{",
		["Pipe"] = "|",
		["RightCurly"] = "}",
		["Tilde"] = "~",
		["Delete"] = "Delete",
		["End"] = "End",
		["KeypadZero"] = "Keypad0",
		["KeypadOne"] = "Keypad1",
		["KeypadTwo"] = "Keypad2",
		["KeypadThree"] = "Keypad3",
		["KeypadFour"] = "Keypad4",
		["KeypadFive"] = "Keypad5",
		["KeypadSix"] = "Keypad6",
		["KeypadSeven"] = "Keypad7",
		["KeypadEight"] = "Keypad8",
		["KeypadNine"] = "Keypad9",
		["KeypadPeriod"] = "KeypadP",
		["KeypadDivide"] = "KeypadD",
		["KeypadMultiply"] = "KeypadM",
		["KeypadMinus"] = "KeypadM",
		["KeypadPlus"] = "KeypadP",
		["KeypadEnter"] = "KeypadE",
		["KeypadEquals"] = "KeypadE",
		["Insert"] = "Insert",
		["Home"] = "Home",
		["PageUp"] = "PageUp",
		["PageDown"] = "PageDown",
		["RightShift"] = "RightShift",
		["LeftShift"] = "LeftShift",
		["RightControl"] = "RightControl",
		["LeftControl"] = "LeftControl",
		["LeftAlt"] = "LeftAlt",
		["RightAlt"] = "RightAlt",
	}

	local Themes = {
		["Preset"] = {
			["Background"] = FromHex("#0A0A0A"),
			["Inline"] = FromHex("#0C0C0C"),
			["Outline"] = FromRGB(30, 30, 30),
			["Text"] = FromRGB(225, 225, 225),
			["Dark Text"] = FromRGB(125, 125, 125),
			["Element"] = FromHex("#161616"),
			["Accent"] = FromHex("#FFFFFF"),
		},
	}

	Library.Theme = table.clone(Themes["Preset"])

	if getgenv().LDS13_FOLDERS and type(getgenv().LDS13_FOLDERS) == "table" then
		Library:SetFolders(getgenv().LDS13_FOLDERS)
	end
	local Folders = Library.Folders

	for Index, Value in pairs(Folders) do
		if not isfolder(Value) then
			makefolder(Value)
		end
	end

	-- 激活图标背后的光晕需要平滑的径向透明度渐变，而 Roblox 自带的贴图都没有这种效果
	-- （候选要么是不透明的黑色星芒，要么是硬边圆盘）。这里自行生成该渐变并通过 getcustomasset 提供，
	-- 因此不需要任何外部资源 id。字节是刻意手工拼装的：string.pack
	-- 并非每个执行器都保证提供，缺一个内建函数就会让整个
	-- 光晕失效。

	Library.GlowTexture = nil
	do --// 光晕贴图
		local Resolution = 64
		local Core = 0.45 -- 到此为止完全不透明，所以光晕从可见区域才开始
		local GlowPath = Folders.Assets .. "/MiyabiGlow.png"

		local Byte = string.char

		local BigEndian = function(Value)
			return Byte(
				math.floor(Value / 16777216) % 256,
				math.floor(Value / 65536) % 256,
				math.floor(Value / 256) % 256,
				Value % 256
			)
		end

		local LittleEndian = function(Value)
			return Byte(Value % 256, math.floor(Value / 256) % 256)
		end

		-- bit32 随 Luau 提供，但光晕不能依赖它：退回到普通
		-- 运算，这样没有该库的沙箱也能得到贴图。
		local Bit = bit32
		local Xor = if Bit then Bit.bxor else function(A, B)
			local Result, Step = 0, 1
			for _ = 1, 32 do
				local Left, Right = A % 2, B % 2
				if Left ~= Right then
					Result += Step
				end
				A, B, Step = (A - Left) / 2, (B - Right) / 2, Step * 2
			end
			return Result
		end
		local BitAnd = if Bit then Bit.band else function(A, B)
			local Result, Step = 0, 1
			for _ = 1, 32 do
				local Left, Right = A % 2, B % 2
				if Left == 1 and Right == 1 then
					Result += Step
				end
				A, B, Step = (A - Left) / 2, (B - Right) / 2, Step * 2
			end
			return Result
		end
		local Complement = if Bit then Bit.bnot else function(Value)
			return 0xFFFFFFFF - Value
		end

		local CrcTable = {}
		for Index = 0, 255 do
			local Value = Index
			for _ = 1, 8 do
				if Value % 2 == 1 then
					Value = Xor(0xEDB88320, (Value - Value % 2) / 2)
				else
					Value = Value / 2
				end
			end
			CrcTable[Index] = Value
		end

		local Crc32 = function(Data)
			local Crc = 0xFFFFFFFF
			for Index = 1, #Data do
				Crc = Xor(CrcTable[BitAnd(Xor(Crc, string.byte(Data, Index)), 0xFF)], (Crc - Crc % 256) / 256)
			end
			return Xor(Crc, 0xFFFFFFFF)
		end

		local Chunk = function(Kind, Data)
			return BigEndian(#Data) .. Kind .. Data .. BigEndian(Crc32(Kind .. Data))
		end

		-- 未压缩的 deflate：5 字节的存储块头，随后最多 65535 字节。
		local StoredDeflate = function(Data)
			local Out = {}
			local Offset = 1
			local Total = #Data

			while Offset <= Total do
				local Length = math.min(65535, Total - Offset + 1)
				local Final = (Offset + Length > Total) and 1 or 0
				table.insert(
					Out,
					Byte(Final) .. LittleEndian(Length) .. LittleEndian(BitAnd(Complement(Length), 0xFFFF))
				)
				table.insert(Out, string.sub(Data, Offset, Offset + Length - 1))
				Offset += Length
			end

			return table.concat(Out)
		end

		local BuildGlow = function()
			local Rows = {}
			local Center = (Resolution - 1) / 2

			-- 核心区域在 Core 之前保持完全不透明，因为字形把它完全
			-- 遮住：从圆心测量的渐变峰值落在没人看得见的地方，
			-- 光晕看起来就像不存在。可见光只从图标之外开始。
			for Y = 0, Resolution - 1 do
				local Row = { Byte(0) } -- 过滤类型 0（None）
				for X = 0, Resolution - 1 do
					local Dx = (X - Center) / Center
					local Dy = (Y - Center) / Center
					local Distance = math.min(1, math.sqrt(Dx * Dx + Dy * Dy))
					local Alpha
					if Distance <= Core then
						Alpha = 255
					else
						Alpha = math.floor(255 * (((1 - Distance) / (1 - Core)) ^ 1.5) + 0.5)
					end
					Row[#Row + 1] = Byte(255, 255, 255, Alpha)
				end
				Rows[#Rows + 1] = table.concat(Row)
			end

			local Header = BigEndian(Resolution) .. BigEndian(Resolution) .. Byte(8, 6, 0, 0, 0)

			return "\137PNG\13\10\26\10"
				.. Chunk("IHDR", Header)
				.. Chunk("IDAT", StoredDeflate(table.concat(Rows)))
				.. Chunk("IEND", "")
		end

		-- 总是重写。之前的版本可能在这里留下损坏的文件，
		-- 而复用它看起来会和光晕从未渲染一模一样。
		local Ok, Result = pcall(function()
			writefile(GlowPath, BuildGlow())
			return getcustomasset(GlowPath)
		end)

		if Ok then
			Library.GlowTexture = Result
		else
			warn("[Library] Glow texture failed: " .. tostring(Result))
		end
	end

	-- 补间
	local Tween = {}
	do
		Tween.__index = Tween

		Tween.Create = function(self, Item, Info, Goal, IsRawItem)
			Item = IsRawItem and Item or Item.Instance
			Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

			local NewTween = {
				Tween = TweenService:Create(Item, Info, Goal),
				Info = Info,
				Goal = Goal,
				Item = Item,
			}

			NewTween.Tween:Play()

			setmetatable(NewTween, Tween)

			return NewTween
		end

		Tween.GetProperty = function(self, Item)
			Item = Item or self.Item

			if Item:IsA("Frame") then
				return { "BackgroundTransparency" }
			elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
				return { "TextTransparency", "BackgroundTransparency" }
			elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
				return { "BackgroundTransparency", "ImageTransparency" }
			elseif Item:IsA("ScrollingFrame") then
				return { "BackgroundTransparency", "ScrollBarImageTransparency" }
			elseif Item:IsA("TextBox") then
				return { "TextTransparency", "BackgroundTransparency" }
			elseif Item:IsA("UIStroke") then
				return { "Transparency" }
			end
		end

		Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
			local Item = Item or self.Item

			local OldTransparency = Item[Property]
			Item[Property] = Visibility and 1 or OldTransparency

			local NewTween = Tween:Create(
				Item,
				TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction),
				{
					[Property] = Visibility and OldTransparency or 1,
				},
				true
			)

			Library:Connect(NewTween.Tween.Completed, function()
				if not Visibility then
					RunService.Heartbeat:Wait()
					Item[Property] = OldTransparency
				end
			end)

			return NewTween
		end

		Tween.Get = function(self)
			if not self.Tween then
				return
			end

			return self.Tween, self.Info, self.Goal
		end

		Tween.Pause = function(self)
			if not self.Tween then
				return
			end

			self.Tween:Pause()
		end

		Tween.Play = function(self)
			if not self.Tween then
				return
			end

			self.Tween:Play()
		end

		Tween.Clean = function(self)
			if not self.Tween then
				return
			end

			Tween:Pause()
			self = nil
		end
	end

	-- 实例
	local Instances = {}
	do
		Instances.__index = Instances

		Instances.Create = function(self, Class, Properties)
			if Class == "ImageLabel" and Properties and Properties.Icon and CreateIcon then
				return CreateIcon(Properties.Icon, Properties, Properties.Colors)
			end

			local NewItem = {
				Instance = InstanceNew(Class),
				Properties = Properties,
				Class = Class,
			}

			setmetatable(NewItem, Instances)

			for Property, Value in NewItem.Properties do
				NewItem.Instance[Property] = Value
			end

			NewItem.Instance.Name = "\0"

			if Library.SeedBaseline then
				Library:SeedBaseline(NewItem.Instance)
			end

			return NewItem
		end

		Instances.FadeItem = function(self, Visibility, Speed)
			local Item = self.Instance

			if Visibility then
				Item.Visible = true
			end

			local Descendants = Item:GetDescendants()
			table.insert(Descendants, Item)

			local NewTween

			for Index, Value in Descendants do
				local TransparencyProperty = Tween:GetProperty(Value)

				if not TransparencyProperty then
					continue
				end

				if type(TransparencyProperty) == "table" then
					for _, Property in TransparencyProperty do
						NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
					end
				else
					NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
				end
			end
		end

		Instances.AddToTheme = function(self, Properties)
			if not self.Instance then
				return
			end

			Library:AddToTheme(self, Properties)
		end

		Instances.ChangeItemTheme = function(self, Properties)
			if not self.Instance then
				return
			end

			Library:ChangeItemTheme(self, Properties)
		end

		Instances.Connect = function(self, Event, Callback, Name)
			if not self.Instance then
				return
			end

			if not self.Instance[Event] then
				return
			end

			if IsMobile then
				if Event == "MouseButton1Down" or Event == "MouseButton1Click" then
					Event = "TouchTap"
				elseif Event == "MouseButton2Down" or Event == "MouseButton2Click" then
					Event = "TouchLongPress"
				end
			end

			return Library:Connect(self.Instance[Event], Callback, Name)
		end

		Instances.Tween = function(self, Info, Goal)
			if not self.Instance then
				return
			end

			return Tween:Create(self, Info, Goal)
		end

		Instances.Disconnect = function(self, Name)
			if not self.Instance then
				return
			end

			return Library:Disconnect(Name)
		end

		Instances.Clean = function(self)
			if not self.Instance then
				return
			end

			self.Instance:Destroy()
			self = nil
		end

		Instances.MakeDraggable = function(self, Handle)
			if not self.Instance then
				return
			end

			local Gui = self.Instance
			Handle = (Handle and (Handle.Instance or Handle)) or Gui
			Handle.Active = true

			local Dragging = false
			local DragStart
			local StartPosition
			local InputChanged

			local Set = function(Input)
				local Scale = Library:GetScreenScale()
				local DragDelta = (Input.Position - DragStart) / Scale
				local NewX = StartPosition.X + DragDelta.X
				local NewY = StartPosition.Y + DragDelta.Y

				local ScreenSize = Gui.Parent.AbsoluteSize / Scale
				local GuiSize = Gui.AbsoluteSize / Scale
				local Anchor = Gui.AnchorPoint

				NewX = math.clamp(NewX, GuiSize.X * Anchor.X, ScreenSize.X - GuiSize.X * (1 - Anchor.X))
				NewY = math.clamp(NewY, GuiSize.Y * Anchor.Y, ScreenSize.Y - GuiSize.Y * (1 - Anchor.Y))

				local Info = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				self:Tween(Info, { Position = UDim2New(0, NewX, 0, NewY) })
			end

			Library:Connect(Handle.InputBegan, function(Input)
				local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
				local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

				if not IsClick and not IsTouch then
					return
				end

				Dragging = true
				DragStart = Input.Position

				local Scale = Library:GetScreenScale()
				local ParentSize = Gui.Parent.AbsoluteSize / Scale
				StartPosition = Vector2New(
					Gui.Position.X.Scale * ParentSize.X + Gui.Position.X.Offset,
					Gui.Position.Y.Scale * ParentSize.Y + Gui.Position.Y.Offset
				)

				if InputChanged then
					return
				end

				InputChanged = Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
						InputChanged:Disconnect()
						InputChanged = nil
					end
				end)
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if
					(
						Input.UserInputType == Enum.UserInputType.MouseMovement
						or Input.UserInputType == Enum.UserInputType.Touch
					) and Dragging
				then
					Set(Input)
				end
			end)
		end

		Instances.MakeResizeable = function(self, Minimum, Maximum)
			if not self.Instance then
				return
			end

			local Gui = self.Instance

			local Resizing = false
			local CurrentSide = nil

			local StartMouse = nil
			local StartPosition = nil
			local StartSize = nil

			local EdgeThickness = 2

			local MakeEdge = function(Name, Position, Size)
				local Button = Instances:Create("TextButton", {
					Name = "\0",
					Size = Size,
					Position = Position,
					BackgroundColor3 = FromRGB(166, 147, 243),
					BackgroundTransparency = 1,
					Text = "",
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Parent = Gui,
					ZIndex = 99999,
				})
				Button:AddToTheme({ BackgroundColor3 = "Accent" })

				return Button
			end

			local Edges = {
				{
					Button = MakeEdge("Left", UDim2New(0, 0, 0, 0), UDim2New(0, EdgeThickness, 1, 0)),
					Side = "L",
				},

				{
					Button = MakeEdge("Right", UDim2New(1, -EdgeThickness, 0, 0), UDim2New(0, EdgeThickness, 1, 0)),
					Side = "R",
				},

				{
					Button = MakeEdge("Top", UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, EdgeThickness)),
					Side = "T",
				},

				{
					Button = MakeEdge("Bottom", UDim2New(0, 0, 1, -EdgeThickness), UDim2New(1, 0, 0, EdgeThickness)),
					Side = "B",
				},
			}

			local BeginResizing = function(Side)
				Resizing = true
				CurrentSide = Side

				StartMouse = UserInputService:GetMouseLocation()

				StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
				StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)

				for Index, Value in Edges do
					Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
				end
			end

			local EndResizing = function()
				Resizing = false
				CurrentSide = nil

				for Index, Value in Edges do
					Value.Button.Instance.BackgroundTransparency = 1
				end
			end

			for Index, Value in Edges do
				Value.Button:Connect("InputBegan", function(Input)
					if
						Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch
					then
						BeginResizing(Value.Side)
					end
				end)
			end

			Library:Connect(UserInputService.InputEnded, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					if Resizing then
						EndResizing()
					end
				end
			end)

			Library:Connect(RunService.RenderStepped, function()
				if not Resizing or not CurrentSide then
					return
				end

				local MouseLocation = UserInputService:GetMouseLocation()
				local dx = MouseLocation.X - StartMouse.X
				local dy = MouseLocation.Y - StartMouse.Y

				local x, y = StartPosition.X, StartPosition.Y
				local w, h = StartSize.X, StartSize.Y

				if CurrentSide == "L" then
					x = StartPosition.X + dx
					w = StartSize.X - dx
				elseif CurrentSide == "R" then
					w = StartSize.X + dx
				elseif CurrentSide == "T" then
					y = StartPosition.Y + dy
					h = StartSize.Y - dy
				elseif CurrentSide == "B" then
					h = StartSize.Y + dy
				end

				if w < Minimum.X then
					if CurrentSide == "L" then
						x = x - (Minimum.X - w)
					end
					w = Minimum.X
				end
				if h < Minimum.Y then
					if CurrentSide == "T" then
						y = y - (Minimum.Y - h)
					end
					h = Minimum.Y
				end

				self:Tween(
					TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2FromOffset(x, y) }
				)
				self:Tween(
					TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Size = UDim2FromOffset(w, h) }
				)
			end)
		end

		Instances.OnHover = function(self, Function)
			if not self.Instance then
				return
			end

			return Library:Connect(self.Instance.MouseEnter, Function)
		end

		Instances.OnHoverLeave = function(self, Function)
			if not self.Instance then
				return
			end

			return Library:Connect(self.Instance.MouseLeave, Function)
		end
	end

	local Icons
	do --// 图标
		local Success, Result = pcall(function()
			return loadstring(game:HttpGetAsync(MoltoSource))()
		end)

		if Success and Result then
			pcall(Result.SetProvider, "lucide")
			Icons = Result
		else
			local FallbackSuccess, FallbackResult = pcall(function()
				return loadstring(game:HttpGetAsync(LucideSource))()
			end)

			if FallbackSuccess and FallbackResult then
				Icons = FallbackResult
			end
		end
	end

	local CreatorNew = function(Class, Properties)
		local ThemeTag = Properties.ThemeTag
		Properties.ThemeTag = nil

		local Item = Instances:Create(Class, Properties)
		if ThemeTag then
			Item:AddToTheme(ThemeTag)
		end

		return Item.Instance
	end

	-- 原始资源字符串直接放到标签上；其余的都是
	-- 由图标提供器解析的图集矩形。
	local IsRawAsset = function(Icon)
		if type(Icon) == "number" then
			return true
		end

		if type(Icon) ~= "string" then
			return false
		end

		return string.find(Icon, "rbxasset", 1, true) == 1
			or string.find(Icon, "rbxthumb", 1, true) == 1
			or string.find(Icon, "http", 1, true) == 1
	end

	CreateIcon = function(Icon, Properties, Colors)
		Properties = Properties or {}

		local Asset
		if Icons and not IsRawAsset(Icon) then
			local Success, Result = pcall(Icons.GetAsset, Icon)
			Asset = if Success then Result else nil
		end

		local RawImage
		if IsRawAsset(Icon) then
			RawImage = if type(Icon) == "number" then "rbxassetid://" .. tostring(Icon) else Icon
		end

		local FirstColor = Colors and Colors[1]

		local IconFrame = CreatorNew("ImageLabel", {
			Parent = Properties.Parent,
			Size = Properties.Size or UDim2New(0, 24, 0, 24),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = Asset and Asset.Url or RawImage or "",
			ImageRectSize = if Asset then Asset.ImageRectSize else Vector2New(0, 0),
			ImageRectOffset = if Asset then Asset.ImageRectOffset else Vector2New(0, 0),
			ImageColor3 = if type(FirstColor) == "Color3" then FirstColor else nil,
			ThemeTag = if type(FirstColor) == "string" then { ImageColor3 = FirstColor } else nil,
		})

		for Property, Value in Properties do
			if Property ~= "Size" and Property ~= "Icon" and Property ~= "Colors" and Property ~= "ThemeTag" then
				IconFrame[Property] = Value
			end
		end

		local Item = {
			Instance = IconFrame,
			Properties = Properties,
			Class = "ImageLabel",
		}

		return setmetatable(Item, Instances)
	end

	local ReplaceIcon = function(Item, Icon, Colors)
		local OldIcon = Item.Instance
		local NewIcon = CreateIcon(Icon, {
			Parent = OldIcon.Parent,
			Name = "\0",
			Size = OldIcon.Size,
			Position = OldIcon.Position,
			AnchorPoint = OldIcon.AnchorPoint,
			LayoutOrder = OldIcon.LayoutOrder,
			BackgroundTransparency = OldIcon.BackgroundTransparency,
			BorderSizePixel = OldIcon.BorderSizePixel,
			ZIndex = OldIcon.ZIndex,
		}, Colors)

		OldIcon:Destroy()
		Item.Instance = NewIcon.Instance
	end

	Library.Scheme = Library.Scheme
		or {
			Font = (function()
				local ok, f = pcall(Font.new, "rbxasset://fonts/families/Inter.json", Enum.FontWeight.Regular)
				return ok and f or Font.fromEnum(Enum.Font.Gotham)
			end)(),
		}
	Library.Font = (function()
		local ok, f = pcall(Font.new, "rbxasset://fonts/families/Inter.json", Enum.FontWeight.SemiBold)
		return ok and f or Font.fromEnum(Enum.Font.GothamBold)
	end)()
	Library.BoldFont = (function()
		local ok, f = pcall(Font.new, "rbxasset://fonts/families/Inter.json", Enum.FontWeight.Bold)
		return ok and f or Font.fromEnum(Enum.Font.GothamBold)
	end)()
	Library.MediumFont = (function()
		local ok, f = pcall(Font.new, "rbxasset://fonts/families/Inter.json", Enum.FontWeight.Medium)
		return ok and f or Font.fromEnum(Enum.Font.Gotham)
	end)()
	Library.RegularFont = (function()
		local ok, f = pcall(Font.new, "rbxasset://fonts/families/Inter.json", Enum.FontWeight.Regular)
		return ok and f or Font.fromEnum(Enum.Font.Gotham)
	end)()
	Library.Scheme.Font = Library.Font

	local SametFontUrls = {
		["Bubblegum-Sans"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Bubblegum-Sans.ttf",
		["Comfortaa-Regular"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Comfortaa-Regular.ttf",
		["Figtree-Medium"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Figtree-Medium.ttf",
		["Figtree-SemiBold"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Figtree-SemiBold.ttf",
		["GoogleSansFlex_24pt-SemiBold"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/GoogleSansFlex_24pt-SemiBold.ttf",
		["HankenGrotesk-SemiBold"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/HankenGrotesk-SemiBold.ttf",
		["Inter"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Inter.ttf",
		["InterBold"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/InterBold.ttf",
		["InterMedium"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/InterMedium.ttf",
		["InterSemibold"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/InterSemibold.ttf",
		["Lato-Bold"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Lato-Bold.ttf",
		["Lexend-Medium"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Lexend-Medium.ttf",
		["MinecraftStandard"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/MinecraftStandard.ttf",
		["Monaco"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Monaco.ttf",
		["NDS12"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/NDS12.ttf",
		["Outfit-Medium"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Outfit-Medium.ttf",
		["PIXEARG_"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/PIXEARG_.TTF",
		["PixelOperator"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/PixelOperator.ttf",
		["Poppins-Medium"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Poppins-Medium.ttf",
		["ProggyClean"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/ProggyClean.ttf",
		["Prompt-Medium"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Prompt-Medium.ttf",
		["Prompt-Regular"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Prompt-Regular.ttf",
		["Reactor7"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/Reactor7.ttf",
		["RobotoMono-Regular"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/RobotoMono-Regular.ttf",
		["SGK075"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/SGK075.ttf",
		["TAHOMA-8PT-BOLD-WINDOWS-XP"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/TAHOMA-8PT-BOLD-WINDOWS-XP.TTF",
		["basis33"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/basis33.ttf",
		["cozette-vector"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/cozette-vector.ttf",
		["fs Tahoma 8px"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/fs%20Tahoma%208px.ttf",
		["lucida-console"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/lucida-console.ttf",
		["minecraftia-regular"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/minecraftia-regular.ttf",
		["minecraftia"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/minecraftia.ttf",
		["open-sans-px"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/open-sans-px.ttf",
		["proggy-clean"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/proggy-clean.ttf",
		["proggy-square"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/proggy-square.ttf",
		["proggy-tiny"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/proggy-tiny.ttf",
		["smallest_pixel-7"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/smallest_pixel-7.ttf",
		["tahoma"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/tahoma.ttf",
		["tahomabd"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/tahomabd.ttf",
		["teachers-pet"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/teachers-pet.ttf",
		["verdana-bold"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/verdana-bold.ttf",
		["verdana"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/verdana.ttf",
		["windows-xp-tahoma"] = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/windows-xp-tahoma.ttf",
	}
	Library.SametFonts = SametFontUrls
	local FontMagics = { "\0\1\0\0", "OTTO", "true", "ttcf", "wOFF" }
	local function IsValidFontBody(Body)
		if type(Body) ~= "string" or #Body < 4096 then
			return false
		end
		local Head = string.sub(Body, 1, 4)
		for _, Magic in FontMagics do
			if Head == Magic then
				return true
			end
		end
		return false
	end
	local function LoadSametFont(Name)
		local Url = SametFontUrls[Name]
		if not Url then
			return nil
		end
		local Id = Library.Folders.Assets .. "/" .. Name .. ".ttf"
		if isfile(Id) then
			local Existing = readfile(Id)
			if not IsValidFontBody(Existing) then
				pcall(delfile, Id)
			end
		end
		if not isfile(Id) then
			local Body = game:HttpGet(Url)
			if not IsValidFontBody(Body) then
				warn("[Library] Samet font download invalid: " .. Name)
				return nil
			end
			writefile(Id, Body)
		end
		local JsonPath = Library.Folders.Assets .. "/" .. Name .. ".font"
		local FontData = {
			name = Name,
			faces = { { name = "Regular", weight = 400, style = "Normal", assetId = getcustomasset(Id) } },
		}
		writefile(JsonPath, HttpService:JSONEncode(FontData))
		return Font.new(getcustomasset(JsonPath))
	end

	local SchemeReplaceAlias = {
		RedColor = "Red",
		WhiteColor = "White",
		DarkColor = "Dark",
	}
	local SchemeAlias = {
		Red = "RedColor",
		White = "WhiteColor",
		Dark = "DarkColor",
	}
	local function GetSchemeValue(Index)
		if not Index then
			return nil
		end
		local ReplaceAliasIndex = SchemeReplaceAlias[Index]
		if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
			Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
			Library.Scheme[ReplaceAliasIndex] = nil
			return Library.Scheme[Index]
		end
		local AliasIndex = SchemeAlias[Index]
		if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
			warn(string.format("Scheme Value %q is deprecated, please use %q instead.", Index, AliasIndex))
			return Library.Scheme[AliasIndex]
		end
		return Library.Scheme[Index]
	end

	Library.Registry = Library.Registry or {}

	function Library:AddToRegistry(Instance, Properties)
		Library.Registry[Instance] = Properties
	end
	function Library:RemoveFromRegistry(Instance)
		Library.Registry[Instance] = nil
	end
	function Library:UpdateColorsUsingRegistry()
		for Instance, Properties in Library.Registry do
			for Property, Index in Properties do
				local SchemeValue = GetSchemeValue(Index)
				if SchemeValue or typeof(Index) == "function" then
					Instance[Property] = SchemeValue or Index()
				end
			end
		end
	end
	function Library:GetTextBounds(Text, FontFace, Size, Width)
		local Params = Instance.new("GetTextBoundsParams")
		Params.Text = Text
		Params.RichText = true
		Params.Font = FontFace
		Params.Size = Size
		Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32
		local Bounds = game:GetService("TextService"):GetTextBoundsAsync(Params)
		return Bounds.X, Bounds.Y
	end
	function Library:SetFont(FontFace)
		if typeof(FontFace) == "EnumItem" then
			FontFace = Font.fromEnum(FontFace :: any)
		elseif typeof(FontFace) == "string" then
			if SametFontUrls[FontFace] then
				local Loaded = LoadSametFont(FontFace)
				if Loaded then
					FontFace = Loaded
				else
					warn("[Library] Failed to load samet font: " .. tostring(FontFace))
					return
				end
			else
				local EnumVal = Enum.Font[FontFace]
				if EnumVal then
					FontFace = Font.fromEnum(EnumVal)
				elseif FontFace == "Inter" then
					FontFace = Font.fromEnum(Enum.Font.Gotham)
				else
					warn("[Library] Unknown font: " .. tostring(FontFace))
					return
				end
			end
		elseif typeof(FontFace) ~= "Font" then
			warn("[Library] SetFont expects EnumItem/string/Font, got " .. typeof(FontFace))
			return
		end
		Library.Scheme.Font = FontFace
		Library.Font = FontFace
		Library.BoldFont = FontFace
		Library.RegularFont = FontFace
		Library:UpdateColorsUsingRegistry()
		for _, Holder in { Library.Holder, Library.UnusedHolder } do
			if Holder and Holder.Instance then
				for _, Desc in Holder.Instance:GetDescendants() do
					if Desc:IsA("TextLabel") or Desc:IsA("TextButton") or Desc:IsA("TextBox") then
						pcall(function()
							Desc.FontFace = FontFace
						end)
					end
				end
			end
		end
	end

	Library.Holder = Instances:Create("ScreenGui", {
		Parent = gethui(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 2,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
	})

	Library.UIScale = Instances:Create("UIScale", {
		Parent = Library.Holder.Instance,
		Name = "\0",
		Scale = IsMobile and 0.7 or 1,
	})

	Library.GetScreenScale = function(self)
		return (Library.UIScale and Library.UIScale.Instance and Library.UIScale.Instance.Scale) or 1
	end

	Library.SetUIScale = function(self, Multiplier)
		Library.UserScale = math.clamp(Multiplier, 0.5, 1.5)
		Library.UIScale.Instance.Scale = Library.UserScale * (IsMobile and 0.7 or 1)
	end

	Library.UnusedHolder = Instances:Create("ScreenGui", {
		Parent = gethui(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		Enabled = false,
		ResetOnSpawn = false,
	})

	Library.NotifHolder = Instances:Create("Frame", {
		Parent = Library.Holder.Instance,
		Name = "\0",
		BackgroundTransparency = 1,
		Size = UDim2New(0, 0, 1, 0),
		BorderColor3 = FromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = FromRGB(255, 255, 255),
	})

	Instances:Create("UIListLayout", {
		Parent = Library.NotifHolder.Instance,
		Name = "\0",
		Padding = UDimNew(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	Instances:Create("UIPadding", {
		Parent = Library.NotifHolder.Instance,
		Name = "\0",
		Name = "\0",
		PaddingTop = UDimNew(0, 12),
		PaddingBottom = UDimNew(0, 12),
		PaddingRight = UDimNew(0, 12),
		PaddingLeft = UDimNew(0, 12),
	})

	Library.Unload = function(self)
		Library.Unloaded = true

		if self.BackgroundEffects and self.BackgroundEffects.BlurEffect then
			pcall(function()
				self.BackgroundEffects.BlurEffect:Destroy()
			end)
			self.BackgroundEffects = nil
		end

		for _, Value in self.Connections do
			if Value.Connection then
				pcall(function()
					Value.Connection:Disconnect()
				end)
			end
		end

		for _, Thread in self.Threads do
			pcall(coroutine.close, Thread)
		end

		for _, Holder in { self.Holder, self.UnusedHolder } do
			if Holder then
				pcall(function()
					Holder:Clean()
				end)
			end
		end

		getgenv().Library = nil
	end

	Library.GetImage = function(self, Image)
		local ImageData = self.Images[Image]

		if not ImageData then
			return
		end

		return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
	end

	Library.Round = function(self, Number, Float)
		if type(Float) ~= "number" or Float == 0 or Float ~= Float then
			Float = 1
		end
		local Multiplier = 1 / Float
		return math.floor(Number * Multiplier) / Multiplier
	end

	Library.Thread = function(self, Function)
		local NewThread = coroutine.create(Function)

		coroutine.wrap(function()
			coroutine.resume(NewThread)
		end)()

		table.insert(self.Threads, NewThread)
		return NewThread
	end

	Library.Utility = {
		CreateThread = function(Func, ...)
			local Args = { ... }
			local Thread = coroutine.create(function()
				Func(table.unpack(Args))
			end)
			coroutine.resume(Thread)
			return Thread
		end,
	}

	Library.SafeCall = function(self, Func: (...any) -> ...any, ...: any)
		if not (Func and typeof(Func) == "function") then
			return
		end
		local Result = table.pack(xpcall(Func, function(Error)
			task.defer(error, debug.traceback(Error, 2))
			return Error
		end, ...))
		if not Result[1] then
			return nil
		end
		return table.unpack(Result, 2, Result.n)
	end

	Library.SafeCallback = Library.SafeCall

	Library.Connect = function(self, Event, Callback, Name)
		Name = Name
			or string.format("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

		local NewConnection = {
			Event = Event,
			Callback = Callback,
			Name = Name,
			Connection = nil,
		}

		Library:Thread(function()
			NewConnection.Connection = Event:Connect(Callback)
		end)

		table.insert(self.Connections, NewConnection)
		return NewConnection
	end

	Library.SetBackgroundEffects = function(self)
		if self.BackgroundEffects then
			return self.BackgroundEffects
		end

		local Background = Instances:Create("Frame", {
			Parent = self.Holder.Instance,
			Name = "\0",
			BackgroundColor3 = FromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2New(0, 0, 0, 0),
			Size = UDim2New(1, 0, 1, 0),
			Visible = false,
			ZIndex = 0,
		})

		local SnowHolder = Instances:Create("Frame", {
			Parent = Background.Instance,
			Name = "\0",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2New(0, 0, 0, 0),
			Size = UDim2New(1, 0, 1, 0),
			ZIndex = 0,
		})

		local BlurEffect = InstanceNew("BlurEffect")
		BlurEffect.Size = 0
		BlurEffect.Parent = Camera

		self.BackgroundEffects = {
			Background = Background.Instance,
			SnowHolder = SnowHolder.Instance,
			BlurEffect = BlurEffect,
			SnowAsset = "http://www.roblox.com/asset/?id=6871196088",
			IsSnowing = false,
		}

		self:Thread(function()
			while Library and Library.BackgroundEffects do
				local Effects = Library.BackgroundEffects

				if not Effects.IsSnowing then
					task.wait(0.1)
					continue
				end

				local Holder = Effects.SnowHolder
				if not Holder or not Holder.Parent then
					task.wait(0.1)
					continue
				end

				local Width = Holder.AbsoluteSize.X
				local Height = Holder.AbsoluteSize.Y
				if Width <= 0 or Height <= 0 then
					task.wait(0.1)
					continue
				end

				local Image = InstanceNew("ImageLabel")
				Image.Name = "\0"
				Image.Parent = Holder
				Image.BackgroundTransparency = 1
				Image.Image = Effects.SnowAsset
				Image.ZIndex = 0

				local RandomSize = math.random(5, 8)
				local SpawnX = math.random(0, math.max(0, Width - RandomSize))
				Image.Size = UDim2New(0, RandomSize, 0, RandomSize)
				Image.Position = UDim2New(0, SpawnX, 0, -10)

				local FallDuration = math.random(20, 40) / 10
				local SwayX = math.random(-18, 18)
				local GoalPosition = UDim2New(0, SpawnX + SwayX, 0, Height + 10)
				local FallTween = TweenService:Create(
					Image,
					TweenInfo.new(FallDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
					{ Position = GoalPosition, ImageTransparency = 1 }
				)

				FallTween:Play()
				FallTween.Completed:Once(function()
					if Image.Parent then
						Image:Destroy()
					end
				end)

				task.wait(0.1)
			end
		end)

		return self.BackgroundEffects
	end

	Library.SetBackgroundEffectsEnabled = function(self, Enabled)
		self.BackgroundEffectsUserEnabled = Enabled ~= false
		self:ApplyBackgroundEffects()
	end

	Library.ApplyBackgroundEffects = function(self, MenuOpen)
		if MenuOpen == nil then
			MenuOpen = (self.MainWindow and self.MainWindow.IsOpen) or false
		end

		local Effects = self:SetBackgroundEffects()
		local IsEnabled = (self.BackgroundEffectsUserEnabled ~= false) and MenuOpen

		self.BackgroundEffectsEnabled = IsEnabled
		Effects.IsSnowing = IsEnabled

		if IsEnabled then
			Effects.Background.Visible = true
		end

		TweenService:Create(
			Effects.Background,
			TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ BackgroundTransparency = IsEnabled and 0.5 or 1 }
		):Play()
		TweenService:Create(
			Effects.BlurEffect,
			TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ Size = IsEnabled and 20 or 0 }
		):Play()

		if not IsEnabled then
			task.delay(0.35, function()
				if self.BackgroundEffectsEnabled or not Effects.Background.Parent then
					return
				end

				Effects.Background.Visible = false
				for _, Child in Effects.SnowHolder:GetChildren() do
					if Child:IsA("ImageLabel") then
						Child:Destroy()
					end
				end
			end)
		end
	end

	Library:SetBackgroundEffectsEnabled(Library.BackgroundEffectsEnabled)

	Library.Disconnect = function(self, Name)
		for _, Connection in self.Connections do
			if Connection.Name == Name then
				Connection.Connection:Disconnect()
				break
			end
		end
	end

	local RestingValues = setmetatable({}, { __mode = "k" })
	local Baselines = setmetatable({}, { __mode = "k" })
	local FadeTokens = setmetatable({}, { __mode = "k" })

	local RootOf = function(Item)
		if type(Item) == "table" then
			return Item.Instance or Item
		end

		return Item
	end

	local BumpFadeToken = function(Root)
		local Next = (FadeTokens[Root] or 0) + 1
		FadeTokens[Root] = Next
		return Next
	end

	local CollectFadeable = function(Root)
		local Children = Root:GetDescendants()
		table.insert(Children, Root)
		return Children
	end

	local ForEachFadeable = function(Children, Callback)
		for _, Child in Children do
			local Properties = Tween:GetProperty(Child)
			if not Properties then
				continue
			end

			for _, Property in Properties do
				Callback(Child, Property)
			end
		end
	end

	Library.SetBaseline = function(self, Object, Property, Value)
		local Store = Baselines[Object]
		if not Store then
			Store = {}
			Baselines[Object] = Store
		end

		Store[Property] = Value
	end

	Library.SeedBaseline = function(self, Object)
		local Properties = Tween:GetProperty(Object)
		if not Properties then
			return
		end

		for _, Property in Properties do
			local Store = Baselines[Object]
			if not Store or Store[Property] == nil then
				Library:SetBaseline(Object, Property, Object[Property])
			end
		end
	end

	local CaptureResting = function(Object, Property)
		local Store = RestingValues[Object]
		if not Store then
			Store = {}
			RestingValues[Object] = Store
		end

		if Store[Property] == nil then
			local Base = Baselines[Object]
			local Known = Base and Base[Property]
			Store[Property] = Known ~= nil and Known or Object[Property]

			if Known == nil then
				Library:SetBaseline(Object, Property, Store[Property])
			end
		end

		return Store[Property]
	end

	local ReleaseResting = function(Object, Property)
		local Store = RestingValues[Object]
		if not Store then
			return nil
		end

		local Value = Store[Property]
		Store[Property] = nil
		return Value
	end

	local RestoreResting = function(Children)
		ForEachFadeable(Children, function(Child, Property)
			local Resting = ReleaseResting(Child, Property)
			if Resting ~= nil then
				Child[Property] = Resting
			end
		end)
	end

	Library.HardRestore = function(self)
		local Root = RootOf(self)
		BumpFadeToken(Root)

		ForEachFadeable(CollectFadeable(Root), function(Child, Property)
			local Base = Baselines[Child]
			ReleaseResting(Child, Property)

			if Base and Base[Property] ~= nil then
				Child[Property] = Base[Property]
			end
		end)
	end

	Library.Fade = function(self, Property, Visibility, RawItem)
		local Object = RawItem or RootOf(self)
		local Resting = CaptureResting(Object, Property)
		local Target = Visibility and Resting or 1

		if Visibility then
			Object[Property] = 1
		end

		local Success = pcall(function()
			Tween:Create(Object, nil, { [Property] = Target }, true)
		end)

		if not Success then
			Object[Property] = Target
		end
	end

	Library.FadeDescendants = function(self, Visibility, Callback)
		local Root = RootOf(self)
		local Token = BumpFadeToken(Root)

		if Visibility then
			Root.Visible = true
		end

		local Children = CollectFadeable(Root)
		ForEachFadeable(Children, function(Child, Property)
			Library:Fade(Property, Visibility, Child)
		end)

		task.delay(Library.Tween.Time + 0.03, function()
			if FadeTokens[Root] == Token then
				Root.Visible = Visibility
				RestoreResting(Children)
			end

			if Callback then
				Callback()
			end
		end)
	end

	Library.CancelFade = function(self)
		BumpFadeToken(RootOf(self))
	end

	Library.ResetFade = function(self)
		local Root = RootOf(self)
		BumpFadeToken(Root)
		RestoreResting(CollectFadeable(Root))
	end

	-- 淡入会先把每个元素的当前值记作静止值，补间结束后再恢复。在控件改动之前
	-- 记录的捕获比改动更旧，却会在下一次显示时胜出，于是窗口看起来毫无变化，
	-- 直到离开并重新进入该页面。释放这些捕获并重新应用
	-- 基线，就能立即显示新状态。

	Library.RefreshVisuals = function(self)
		local Window = self.MainWindow

		if not Window then
			return
		end

		for _, Page in Window.Pages do
			local PageFrame = Page.Items and Page.Items["Page"]

			if not (PageFrame and PageFrame.Instance) then
				continue
			end

			pcall(function()
				Library.HardRestore(PageFrame)
			end)
		end
	end

	Library.NextFlag = function(self)
		local FlagNumber = self.UnnamedFlags + 1
		return string.format("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
	end

	Library.AddToTheme = function(self, Item, Properties)
		Item = Item.Instance or Item

		local ThemeData = {
			Item = Item,
			Properties = Properties,
		}

		for Property, Value in ThemeData.Properties do
			if type(Value) == "string" then
				Item[Property] = self.Theme[Value]
			else
				Item[Property] = Value()
			end
		end

		table.insert(self.ThemeItems, ThemeData)
		self.ThemeMap[Item] = ThemeData
	end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({math.floor(Color.R * 255)}, {math.floor(Color.G * 255)}, {math.floor(Color.B * 255)})">{Text}</font>`
	end

	Library.GetConfig = function(self)
		local Config = {}

		local Success, Result = Library:SafeCall(function()
			for Index, Value in Library.Flags do
				if type(Value) == "table" and Value.Key then
					Config[Index] = { Key = tostring(Value.Key), Mode = Value.Mode }
				elseif type(Value) == "table" and Value.Color then
					Config[Index] = { Color = "#" .. Value.HexValue, Alpha = Value.Alpha }
				else
					Config[Index] = Value
				end
			end
		end)

		return HttpService:JSONEncode(Config)
	end

	Library.LoadConfig = function(self, Config)
		local Decoded = HttpService:JSONDecode(Config)

		local Success, Result = Library:SafeCall(function()
			for Index, Value in Decoded do
				local SetFunction = Library.SetFlags[Index]

				if not SetFunction then
					continue
				end

				-- 一个控件抛错不能吞掉它之后的每一个键，那会
				-- 让文件的其余部分被静默地丢弃。
				Library:SafeCall(function()
					if type(Value) == "table" and Value.Key then
						SetFunction(Value)
					elseif type(Value) == "table" and Value.Color then
						SetFunction(Value.Color, Value.Alpha)
					else
						SetFunction(Value)
					end
				end)
			end
		end)

		-- 控件会把新状态写入淡入基线，但已经准备好显示效果的页面
		-- 仍持有加载前捕获的静止值。这些值会在下一次显示时胜出，于是窗口
		-- 看起来毫无变化，直到再次访问该页面。
		-- 丢弃过期的捕获，现在就把新的基线推送到实例上。
		-- 这样新状态无需等到下一次显示就生效。
		Library:RefreshVisuals()

		return Success, Result
	end

	Library.DeleteConfig = function(self, Config)
		if isfile(Library.Folders.Configs .. "/" .. Config) then
			delfile(Library.Folders.Configs .. "/" .. Config)
		end
	end

	-- 这个库运行的每个游戏共用同一个 Configs 文件夹，所以自动加载的
	-- 选择必须标明属于哪个游戏。GameId 还能在游戏的
	-- 大厅和地图之间保持有效，而 PlaceId 会变化。
	Library.AutoloadPath = function(self)
		return Library.Folders.Configs .. "/" .. tostring(game.GameId) .. "/autoload.txt"
	end

	Library.WriteAutoload = function(self, Config)
		local Folder = Library.Folders.Configs .. "/" .. tostring(game.GameId)

		if not isfolder(Folder) then
			makefolder(Folder)
		end

		return pcall(writefile, Library:AutoloadPath(), Config)
	end

	Library.GetAutoloadConfig = function(self)
		local Path = Library:AutoloadPath()

		if not isfile(Path) then
			-- 在自动加载按游戏区分之前做出的选择存放在共享
			-- 文件夹里；读取它，而不是在更新时丢失配置。
			Path = Library.Folders.Configs .. "/autoload.txt"
		end

		if not isfile(Path) then
			return nil
		end

		local Success, Name = pcall(readfile, Path)

		if not Success or type(Name) ~= "string" then
			return nil
		end

		Name = Name:match("^%s*(.-)%s*$")

		if Name == "" or not isfile(Library.Folders.Configs .. "/" .. Name .. ".json") then
			return nil
		end

		return Name
	end

	Library.SaveAutoloadConfig = function(self, Config)
		if type(Config) ~= "string" or Config == "" then
			return false
		end

		if not isfile(Library.Folders.Configs .. "/" .. Config .. ".json") then
			return false
		end

		local Success = Library:WriteAutoload(Config)

		return Success
	end

	Library.DeleteAutoloadConfig = function(self)
		-- 清空意味着空，而不是缺失：缺失的单游戏文件会回退到
		-- 共享选择，那样会把已清空的自动加载又带回来。
		Library:WriteAutoload("")
	end

	Library.LoadAutoloadConfig = function(self)
		local Name = Library:GetAutoloadConfig()

		if not Name then
			return false
		end

		local Success, Content = pcall(readfile, Library.Folders.Configs .. "/" .. Name .. ".json")

		if not Success then
			return false
		end

		local Loaded = Library:LoadConfig(Content)

		if Loaded then
			Library:Notification("Autoloaded config: " .. Name, "bell", 5)
		end

		return Loaded
	end

	Library.RefreshConfigsList = function(self, Element)
		local List = {}
		local ReturnList = {}

		List = listfiles(Library.Folders.Configs)

		for Index = 1, #List do
			local File = List[Index]

			if File:sub(-5) == ".json" then
				local Position = File:find(".json", 1, true)
				local StartPosition = Position

				local Character = File:sub(Position, Position)
				while Character ~= "/" and Character ~= "\\" and Character ~= "" do
					Position = Position - 1
					Character = File:sub(Position, Position)
				end

				if Character == "/" or Character == "\\" then
					table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
				end
			end
		end

		Element:Refresh(ReturnList)
	end

	Library.ChangeItemTheme = function(self, Item, Properties)
		Item = Item.Instance or Item

		if not self.ThemeMap[Item] then
			return
		end

		self.ThemeMap[Item].Properties = Properties
		self.ThemeMap[Item] = self.ThemeMap[Item]
	end

	Library.ChangeTheme = function(self, Theme, Color)
		self.Theme[Theme] = Color

		for _, Item in self.ThemeItems do
			for Property, Value in Item.Properties do
				if type(Value) == "string" and Value == Theme then
					Item.Item[Property] = Color
				elseif type(Value) == "function" then
					Item.Item[Property] = Value()
				end
			end
		end
	end

	Library.MouseIsOverFrame = function(self, Frame: GuiObject, MousePos: Vector2): boolean
		local Object = Frame.Instance or Frame
		local MousePosition: Vector2 = MousePos or Vector2.new(Mouse.X, Mouse.Y)
		local AbsPos, AbsSize = Object.AbsolutePosition, Object.AbsoluteSize
		return MousePosition.X >= AbsPos.X
			and MousePosition.X <= AbsPos.X + AbsSize.X
			and MousePosition.Y >= AbsPos.Y
			and MousePosition.Y <= AbsPos.Y + AbsSize.Y
	end

	Library.IsMouseOverFrame = Library.MouseIsOverFrame

	Library.Lerp = function(self, Start, Finish, Time)
		return Start + (Finish - Start) * Time
	end

	Library.IsInsideFrame = function(self, ParentFrame: GuiObject, Frame: GuiObject): boolean
		local GuiPos, GuiSize = Frame.AbsolutePosition, Frame.AbsoluteSize
		local FramePos, FrameSize = ParentFrame.AbsolutePosition, ParentFrame.AbsoluteSize
		return GuiPos.X >= FramePos.X
			and GuiPos.X + GuiSize.X <= FramePos.X + FrameSize.X
			and GuiPos.Y >= FramePos.Y
			and GuiPos.Y + GuiSize.Y <= FramePos.Y + FrameSize.Y
	end

	Library.GetOverlappingDraggable = function(self, UI: GuiObject, TargetPos: Vector2?): GuiObject?
		local Pos1 = TargetPos or UI.AbsolutePosition
		local Size1 = UI.AbsoluteSize
		for _, Other in ipairs(self.DraggableElements) do
			if Other == UI or not Other.Visible or not Other.Parent then
				continue
			end
			local Pos2 = Other.AbsolutePosition
			local Size2 = Other.AbsoluteSize
			if
				Pos1.X < Pos2.X + Size2.X
				and Pos1.X + Size1.X > Pos2.X
				and Pos1.Y < Pos2.Y + Size2.Y
				and Pos1.Y + Size1.Y > Pos2.Y
			then
				return Other
			end
		end
		return nil
	end

	Library.GetNonOverlappingPosition = function(self, UI: GuiObject, StartPos: UDim2?): UDim2
		local ScreenSize = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080))
			- Vector2.new(100, 100)
		local Start = StartPos and Vector2.new(StartPos.X.Offset, StartPos.Y.Offset) or Vector2.new(6, 6)
		local Padding = 6
		local CurrentX = Start.X
		local CurrentY = Start.Y
		local Size = UI.AbsoluteSize
		if Size.X == 0 and Size.Y == 0 then
			RunService.RenderStepped:Wait()
			Size = UI.AbsoluteSize
		end
		if Size.X == 0 then
			Size = Vector2.new(480, 360)
		end
		local MaxXInColumn = Size.X
		while true do
			local Overlapping = self:GetOverlappingDraggable(UI, Vector2.new(CurrentX, CurrentY))
			if not Overlapping then
				if CurrentX + Size.X <= ScreenSize.X and CurrentY + Size.Y <= ScreenSize.Y then
					return UDim2.fromOffset(CurrentX, CurrentY)
				end
			end
			CurrentY += (Overlapping and Overlapping.AbsoluteSize.Y or Size.Y) + Padding
			if CurrentY + Size.Y > ScreenSize.Y then
				CurrentY = Start.Y
				CurrentX += MaxXInColumn + Padding
				MaxXInColumn = Size.X
				if CurrentX + Size.X > ScreenSize.X then
					return UDim2.fromOffset(Start.X, Start.Y)
				end
			end
			if Overlapping and Overlapping.AbsoluteSize.X > MaxXInColumn then
				MaxXInColumn = Overlapping.AbsoluteSize.X
			end
		end
	end

	Library.PositionDraggable = function(self, UI: GuiObject, StartPos: UDim2?)
		UI.Position = self:GetNonOverlappingPosition(UI, StartPos)
	end

	Library.CompareVectors = function(self, PointA, PointB)
		return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
	end

	Library.IsClipped = function(self, Object, Column)
		local Parent = Column

		local BoundryTop = Parent.AbsolutePosition
		local BoundryBottom = BoundryTop + Parent.AbsoluteSize

		local Top = Object.AbsolutePosition
		local Bottom = Top + Object.AbsoluteSize

		return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
	end

	do
		Library.CreateColorpicker = function(self, Data)
			local Colorpicker = {
				Flag = Data.Flag,

				Hue = 0,
				Saturation = 0,
				Value = 0,

				Color = Color3.fromRGB(0, 0, 0),
				HexValue = "",

				IsOpen = false,
			}

			local Items = {}
			do
				Items["ColorpickerButton"] = Instances:Create("TextButton", {
					Parent = Data.Parent.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					Size = UDim2New(0, 16, 0, 16),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 193, 249),
				})

				Instances:Create("UICorner", {
					Parent = Items["ColorpickerButton"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				Instances:Create("UIGradient", {
					Parent = Items["ColorpickerButton"].Instance,
					Name = "\0",
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(209, 209, 209)),
					}),
				})

				Items["ColorpickerWindow"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Visible = false,
					Position = UDim2New(0, 44, 0, 169),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 180, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(13, 15, 18),
				})
				Items["ColorpickerWindow"]:AddToTheme({ BackgroundColor3 = "Background" })

				Instances:Create("UIStroke", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					Color = FromRGB(26, 30, 36),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Outline" })

				Items["Palette"] = Instances:Create("TextButton", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					Position = UDim2New(0, 8, 0, 8),
					Size = UDim2New(1, -36, 0, 128),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 193, 249),
				})

				Instances:Create("UICorner", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Items["Saturation"] = Instances:Create("Frame", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 1, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Saturation"].Instance,
					Name = "\0",
					Transparency = NumSequence({ NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0) }),
				})

				Instances:Create("UICorner", {
					Parent = Items["Saturation"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				Items["Value"] = Instances:Create("Frame", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 1, 1, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(0, 0, 0),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Value"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence({ NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0) }),
				})

				Instances:Create("UICorner", {
					Parent = Items["Value"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				Items["PaletteDragger"] = Instances:Create("Frame", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 15, 0, 15),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 8, 0, 8),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["PaletteDragger"].Instance,
					Name = "\0",
					Color = FromRGB(255, 255, 255),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				})

				Instances:Create("UICorner", {
					Parent = Items["PaletteDragger"].Instance,
					Name = "\0",
				})

				Instances:Create("UICorner", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Items["Hue"] = Instances:Create("TextButton", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(1, 0),
					Position = UDim2New(1, -8, 0, 8),
					Size = UDim2New(0, 12, 0, 128),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UICorner", {
					Parent = Items["Hue"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 4),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Hue"].Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 0, 0)),
						RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)),
						RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)),
						RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)),
						RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)),
						RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)),
						RGBSequenceKeypoint(1, FromRGB(255, 0, 0)),
					}),
				})

				Items["HueDragger"] = Instances:Create("Frame", {
					Parent = Items["Hue"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 12, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIStroke", {
					Parent = Items["HueDragger"].Instance,
					Name = "\0",
					Color = FromRGB(255, 255, 255),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				})

				Instances:Create("UICorner", {
					Parent = Items["HueDragger"].Instance,
					Name = "\0",
				})

				Items["HexInput"] = Instances:Create("TextBox", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					Position = UDim2New(0, 8, 0, 145),
					Size = UDim2New(1, -16, 0, 26),
					BackgroundColor3 = FromRGB(22, 22, 22),
					BorderSizePixel = 0,
					ClearTextOnFocus = false,
					FontFace = Library.Font,
					PlaceholderText = "#RRGGBB",
					PlaceholderColor3 = FromRGB(125, 125, 125),
					Text = "",
					TextColor3 = FromRGB(225, 225, 225),
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Center,
				})
				Items["HexInput"]:AddToTheme({
					BackgroundColor3 = "Inline",
					PlaceholderColor3 = "Dark Text",
					TextColor3 = "Text",
				})

				Instances:Create("UICorner", {
					Parent = Items["HexInput"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})
			end

			function Colorpicker:Get()
				return Colorpicker.Color
			end

			function Colorpicker:Update(IsFromAlpha)
				local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
				Colorpicker.Color = FromHSV(Hue, Saturation, Value)
				Colorpicker.HexValue = Colorpicker.Color:ToHex()

				Library.Flags[Colorpicker.Flag] = {
					Color = Colorpicker.Color,
					HexValue = Colorpicker.HexValue,
				}

				Items["ColorpickerButton"]:Tween(nil, { BackgroundColor3 = Colorpicker.Color })
				Items["Palette"]:Tween(nil, { BackgroundColor3 = FromHSV(Hue, 1, 1) })

				if not Items["HexInput"].Instance:IsFocused() then
					Items["HexInput"].Instance.Text = "#" .. string.upper(Colorpicker.HexValue)
				end

				if Data.Callback then
					Library:SafeCall(Data.Callback, Colorpicker.Color)
				end
			end

			local SlidingPalette = false
			local PaletteChanged

			function Colorpicker:SlidePalette(Input)
				if not Input or not SlidingPalette then
					return
				end

				local ValueX = math.clamp(
					1
						- (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X)
							/ Items["Palette"].Instance.AbsoluteSize.X,
					0,
					1
				)
				local ValueY = math.clamp(
					1
						- (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y)
							/ Items["Palette"].Instance.AbsoluteSize.Y,
					0,
					1
				)

				Colorpicker.Saturation = ValueX
				Colorpicker.Value = ValueY

				local SlideX = math.clamp(
					(Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X)
						/ Items["Palette"].Instance.AbsoluteSize.X,
					0,
					0.955
				)
				local SlideY = math.clamp(
					(Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y)
						/ Items["Palette"].Instance.AbsoluteSize.Y,
					0,
					0.955
				)

				Items["PaletteDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(SlideX, 0, SlideY, 0) }
				)
				Colorpicker:Update()
			end

			local SlidingHue = false
			local HueChanged

			function Colorpicker:SlideHue(Input)
				if not Input or not SlidingHue then
					return
				end

				local ValueY = math.clamp(
					(Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
					0,
					1
				)

				Colorpicker.Hue = ValueY

				local SlideY = math.clamp(
					(Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
					0,
					0.955
				)

				Items["HueDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(0, 0, SlideY, 0) }
				)
				Colorpicker:Update()
			end

			local Debounce = false
			local RenderStepped

			function Colorpicker:SetOpen(Bool)
				if Debounce then
					return
				end

				Colorpicker.IsOpen = Bool

				Debounce = true

				if Colorpicker.IsOpen then
					Items["ColorpickerWindow"].Instance.Visible = true
					Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance

					RenderStepped = RunService.RenderStepped:Connect(function()
						local Scale = Library:GetScreenScale()
						Items["ColorpickerWindow"].Instance.Position = UDim2New(
							0,
							Items["ColorpickerButton"].Instance.AbsolutePosition.X / Scale,
							0,
							(
								Items["ColorpickerButton"].Instance.AbsolutePosition.Y
								+ Items["ColorpickerButton"].Instance.AbsoluteSize.Y
								+ 5
							) / Scale
						)
					end)

					Items["ColorpickerWindow"]:Tween(nil, { Size = UDim2New(0, 180, 0, 179) })

					if not Data.Section.IsSettings then
						for Index, Value in Library.OpenFrames do
							if Value ~= Colorpicker then
								Value:SetOpen(false)
							end
						end
					end

					Library.OpenFrames[Colorpicker] = Colorpicker
				else
					if not Data.Section.IsSettings then
						if Library.OpenFrames[Colorpicker] then
							Library.OpenFrames[Colorpicker] = nil
						end
					end

					if RenderStepped then
						RenderStepped:Disconnect()
						RenderStepped = nil
					end

					Items["ColorpickerWindow"]:Tween(nil, { Size = UDim2New(0, 180, 0, 0) })
				end

				local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
				table.insert(Descendants, Items["ColorpickerWindow"].Instance)

				local NewTween

				for Index, Value in Descendants do
					local TransparencyProperty = Tween:GetProperty(Value)

					if not TransparencyProperty then
						continue
					end

					if not Value.ClassName:find("UI") then
						Value.ZIndex = (Colorpicker.IsOpen and Data.Section.IsSettings and 9)
							or (Colorpicker.IsOpen and not Data.Section.IsSettings and 3)
							or 1
					end

					if type(TransparencyProperty) == "table" then
						for _, Property in TransparencyProperty do
							NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
						end
					else
						NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
					end
				end

				NewTween.Tween.Completed:Connect(function()
					Debounce = false
					Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
					task.wait(0.2)
					Items["ColorpickerWindow"].Instance.Parent = Colorpicker.IsOpen and Library.Holder.Instance
						or Library.UnusedHolder.Instance and Library.UnusedHolder.Instance
						or Library.Holder.Instance
				end)
			end

			function Colorpicker:Set(Color)
				if type(Color) == "table" then
					if Color.Color then
						Color = Color.Color
					elseif Color[1] and Color[2] and Color[3] then
						local r, g, b = Color[1], Color[2], Color[3]
						if r > 1 or g > 1 or b > 1 then
							Color = FromRGB(r, g, b)
						else
							Color = Color3.new(r, g, b)
						end
					end
				elseif type(Color) == "string" then
					local Hex = Color:gsub("#", ""):gsub("0x", ""):gsub("0X", ""):gsub("%s", "")
					if Hex:match("^%x+$") then
						if #Hex == 3 then
							Hex = Hex:sub(1, 1):rep(2) .. Hex:sub(2, 2):rep(2) .. Hex:sub(3, 3):rep(2)
						end
						if #Hex == 8 then
							Hex = Hex:sub(1, 6)
						end
						if #Hex == 6 then
							Color = FromHex(Hex)
						end
					elseif Hex:match("^%d+,%s*%d+,%s*%d+$") then
						local r, g, b = Hex:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
						Color = FromRGB(tonumber(r), tonumber(g), tonumber(b))
					else
						Color = FromHex(Hex)
					end
				end

				Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()

				local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.955)
				local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.955)

				local HuePositionY = math.clamp(Colorpicker.Hue, 0, 0.955)

				Items["PaletteDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0) }
				)
				Items["HueDragger"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(0, 0, HuePositionY, 0) }
				)
				Colorpicker:Update()
			end

			Items["HexInput"]:Connect("FocusLost", function()
				local Hex = string.gsub(Items["HexInput"].Instance.Text, "#", "")
				Hex = string.gsub(Hex, "%s", "")

				if #Hex == 6 and string.match(Hex, "^%x+$") then
					local Ok, Color = pcall(FromHex, Hex)

					if Ok then
						Colorpicker:Set(Color)
						return
					end
				end

				Items["HexInput"].Instance.Text = "#" .. string.upper(Colorpicker.HexValue)
			end)

			Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
				Colorpicker:SetOpen(not Colorpicker.IsOpen)
			end)

			Items["Palette"]:Connect("InputBegan", function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					SlidingPalette = true

					Colorpicker:SlidePalette(Input)

					if PaletteChanged then
						return
					end

					PaletteChanged = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							SlidingPalette = false

							PaletteChanged:Disconnect()
							PaletteChanged = nil
						end
					end)
				end
			end)

			Items["Hue"]:Connect("InputBegan", function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					SlidingHue = true

					Colorpicker:SlideHue(Input)

					if HueChanged then
						return
					end

					HueChanged = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							SlidingHue = false

							HueChanged:Disconnect()
							HueChanged = nil
						end
					end)
				end
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseMovement
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					if SlidingPalette then
						Colorpicker:SlidePalette(Input)
					end

					if SlidingHue then
						Colorpicker:SlideHue(Input)
					end
				end
			end)

			Library:Connect(UserInputService.InputBegan, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					if not Colorpicker.IsOpen then
						return
					end

					if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
						return
					end

					Colorpicker:SetOpen(false)
				end
			end)

			if Data.Default then
				Colorpicker:Set(Data.Default)
			end

			Library.SetFlags[Colorpicker.Flag] = function(Value)
				Colorpicker:Set(Value)
			end

			return Colorpicker, Items
		end

		Library.CreateKeybind = function(self, Data)
			local Keybind = {
				Flag = Data.Flag,
				Name = Data.Name or Data.Flag or "Keybind",

				Mode = "",
				Value = "",
				Key = "",
				KeyEnum = nil,
				ShowInHotkeys = Data.ShowInHotkeys ~= false and Data.showInHotkeys ~= false,

				Picking = false,
				Toggled = false,
				IsOpen = false,
			}

			local Items = {}
			do
				Items["KeyButton"] = Instances:Create("TextButton", {
					Parent = Data.Parent.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "mb2",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 1, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["KeyButton"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["KeybindWindow"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Visible = false,
					Position = UDim2New(0, 904, 0, 179),
					ClipsDescendants = true,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 67, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(13, 15, 18),
				})
				Items["KeybindWindow"]:AddToTheme({ BackgroundColor3 = "Background" })

				Instances:Create("UICorner", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Instances:Create("UIStroke", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					Color = FromRGB(26, 30, 36),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Outline" })

				Instances:Create("UIListLayout", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["Toggle"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(200, 200, 200),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "Toggle",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Toggle"]:AddToTheme({ TextColor3 = "Dark Text" })

				Instances:Create("UIPadding", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 6),
					PaddingLeft = UDimNew(0, 8),
				})

				Items["Hold"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "Hold",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Hold"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["Always"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "Always",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Always"]:AddToTheme({ TextColor3 = "Dark Text" })
			end

			local Modes = {
				Toggle = Items["Toggle"],
				Hold = Items["Hold"],
				Always = Items["Always"],
			}

			local Debounce = false
			local RenderStepped

			function Keybind:SetOpen(Bool)
				if Debounce then
					return
				end

				Keybind.IsOpen = Bool

				Debounce = true

				if Keybind.IsOpen then
					Items["KeybindWindow"].Instance.Visible = true
					Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance

					RenderStepped = RunService.RenderStepped:Connect(function()
						local Scale = Library:GetScreenScale()
						Items["KeybindWindow"].Instance.Position = UDim2New(
							0,
							Items["KeyButton"].Instance.AbsolutePosition.X / Scale,
							0,
							(
								Items["KeyButton"].Instance.AbsolutePosition.Y
								+ Items["KeyButton"].Instance.AbsoluteSize.Y
								+ 5
							) / Scale
						)
					end)

					Items["KeybindWindow"]:Tween(nil, { Size = UDim2New(0, 67, 0, 80) })

					if not Data.Section.IsSettings then
						for Index, Value in Library.OpenFrames do
							if Value ~= Keybind then
								Value:SetOpen(false)
							end
						end
					end

					Library.OpenFrames[Keybind] = Keybind
				else
					if not Data.Section.IsSettings then
						if Library.OpenFrames[Keybind] then
							Library.OpenFrames[Keybind] = nil
						end
					end

					if RenderStepped then
						RenderStepped:Disconnect()
						RenderStepped = nil
					end

					Items["KeybindWindow"]:Tween(nil, { Size = UDim2New(0, 67, 0, 0) })
				end

				local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
				table.insert(Descendants, Items["KeybindWindow"].Instance)

				local NewTween

				for Index, Value in Descendants do
					local TransparencyProperty = Tween:GetProperty(Value)

					if not TransparencyProperty then
						continue
					end

					if not Value.ClassName:find("UI") then
						Value.ZIndex = Keybind.IsOpen and 4 or 1
					end

					if type(TransparencyProperty) == "table" then
						for _, Property in TransparencyProperty do
							NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
						end
					else
						NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
					end
				end

				NewTween.Tween.Completed:Connect(function()
					Debounce = false
					Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
					task.wait(0.2)
					Items["KeybindWindow"].Instance.Parent = Keybind.IsOpen and Library.Holder.Instance
						or Library.UnusedHolder.Instance
						or Library.Holder.Instance
				end)
			end

			function Keybind:SetMode(Mode)
				for Index, Value in Modes do
					if Index == Mode then
						Value:ChangeItemTheme({ TextColor3 = "Text" })
						Value:Tween(nil, { TextColor3 = Library.Theme.Text })
					else
						Value:ChangeItemTheme({ TextColor3 = "Dark Text" })
						Value:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
					end
				end

				Library.Flags[Keybind.Flag] = {
					Mode = Keybind.Mode,
					Key = Keybind.Key,
					Toggled = Keybind.Toggled,
				}

				if Data.Callback then
					Library:SafeCall(Data.Callback, Keybind.Toggled)
				end
			end

			function Keybind:Press(Bool)
				if Keybind.Mode == "Toggle" then
					Keybind.Toggled = not Keybind.Toggled
				elseif Keybind.Mode == "Hold" then
					Keybind.Toggled = Bool
				elseif Keybind.Mode == "Always" then
					Keybind.Toggled = true
				end

				Library.Flags[Keybind.Flag] = {
					Mode = Keybind.Mode,
					Key = Keybind.Key,
					Toggled = Keybind.Toggled,
				}

				if Library.HotkeyInstance and Library.HotkeyInstance.Visible then
					Library.HotkeyInstance:Refresh()
				end

				if Data.Callback then
					Library:SafeCall(Data.Callback, Keybind.Toggled)
				end
			end

			function Keybind:Get()
				return Keybind.Key, Keybind.Mode, Keybind.Toggled
			end

			function Keybind:Set(Key)
				if string.find(tostring(Key), "Enum") then
					Keybind.Key = tostring(Key)
					Keybind.KeyEnum = Key

					Key = Key.Name == "Backspace" and "None" or Key.Name

					local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
					local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")
						or "None"

					Keybind.Value = TextToDisplay
					Items["KeyButton"].Instance.Text = TextToDisplay

					Library.Flags[Keybind.Flag] = {
						Mode = Keybind.Mode,
						Key = Keybind.Key,
						KeyEnum = Keybind.KeyEnum,
						Toggled = Keybind.Toggled,
					}

					if Data.Callback then
						Library:SafeCall(Data.Callback, Keybind.Toggled)
					end
				elseif type(Key) == "table" then
					local RealKey = Key.Key == "Backspace" and "None" or Key.Key
					Keybind.Key = tostring(Key.Key)
					local Short = tostring(RealKey):match("%.([^%.]+)$") or tostring(RealKey)
					Keybind.KeyEnum = Enum.KeyCode[Short] or Enum.UserInputType[Short]

					if Key.Mode then
						Keybind.Mode = Key.Mode
						Keybind:SetMode(Key.Mode)
					else
						Keybind.Mode = "Toggle"
						Keybind:SetMode("Toggle")
					end

					local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
					local TextToDisplay = KeyString
							and string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")
						or "None"

					TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")

					Keybind.Value = TextToDisplay
					Items["KeyButton"].Instance.Text = TextToDisplay

					Library.Flags[Keybind.Flag] = {
						Mode = Keybind.Mode,
						Key = Keybind.Key,
						KeyEnum = Keybind.KeyEnum,
						Toggled = Keybind.Toggled,
					}

					if Data.Callback then
						Library:SafeCall(Data.Callback, Keybind.Toggled)
					end
				elseif table.find({ "Toggle", "Hold", "Always" }, Key) then
					Keybind.Mode = Key
					Keybind:SetMode(Key)

					if Data.Callback then
						Library:SafeCall(Data.Callback, Keybind.Toggled)
					end
				end

				if Library.HotkeyInstance and Library.HotkeyInstance.Visible then
					Library.HotkeyInstance:Refresh()
				end

				Keybind.Picking = false
			end

			Items["KeyButton"]:Connect("MouseButton1Click", function()
				Keybind.Picking = true

				Items["KeyButton"].Instance.Text = "Press a key"

				local InputBegan
				InputBegan = UserInputService.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.Keyboard then
						Keybind:Set(Input.KeyCode)
					else
						Keybind:Set(Input.UserInputType)
					end

					InputBegan:Disconnect()
					InputBegan = nil
				end)
			end)

			Library:Connect(UserInputService.InputBegan, function(Input)
				if Keybind.Value == "None" then
					return
				end

				if Input.KeyCode == Keybind.KeyEnum or Input.UserInputType == Keybind.KeyEnum then
					if Keybind.Mode == "Toggle" then
						Keybind:Press()
					elseif Keybind.Mode == "Hold" then
						Keybind:Press(true)
					elseif Keybind.Mode == "Always" then
						Keybind:Press(true)
					end
				end

				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Keybind.IsOpen then
						return
					end

					if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
						return
					end

					Keybind:SetOpen(false)
				end
			end)

			Library:Connect(UserInputService.InputEnded, function(Input)
				if Keybind.Value == "None" then
					return
				end

				if Input.KeyCode == Keybind.KeyEnum or Input.UserInputType == Keybind.KeyEnum then
					if Keybind.Mode == "Hold" then
						Keybind:Press(false)
					elseif Keybind.Mode == "Always" then
						Keybind:Press(true)
					end
				end
			end)

			Items["KeyButton"]:Connect("MouseButton2Down", function()
				Keybind:SetOpen(not Keybind.IsOpen)
			end)

			Items["Toggle"]:Connect("MouseButton1Down", function()
				Keybind.Mode = "Toggle"
				Keybind:SetMode("Toggle")
			end)

			Items["Hold"]:Connect("MouseButton1Down", function()
				Keybind.Mode = "Hold"
				Keybind:SetMode("Hold")
			end)

			Items["Always"]:Connect("MouseButton1Down", function()
				Keybind.Mode = "Always"
				Keybind:SetMode("Always")
			end)

			if Data.Default then
				Keybind:Set({
					Mode = Data.Mode or "Toggle",
					Key = Data.Default,
				})
			end

			Library.SetFlags[Keybind.Flag] = function(Value)
				Keybind:Set(Value)
			end

			table.insert(Library.Keybinds, Keybind)
			if Library.HotkeyInstance and Library.HotkeyInstance.Visible then
				Library.HotkeyInstance:Refresh()
			end

			return Keybind, Items
		end

		Library.Hotkeys = function(self, Data)
			Data = Data or {}

			if Library.HotkeyInstance then
				return Library.HotkeyInstance
			end

			local Hotkeys = {
				Items = {},
				Rows = {},
				Visible = false,
			}
			local Items = Hotkeys.Items
			local PanelZIndex = Data.ZIndex or 10
			local ContentZIndex = PanelZIndex + 1
			local RowZIndex = ContentZIndex + 1

			Items["Panel"] = Instances:Create("Frame", {
				Parent = Library.UnusedHolder.Instance,
				Name = "\0",
				Visible = false,
				Position = Data.Position or UDim2New(0, 12, 0, 512),
				Size = UDim2New(0, 190, 0, 118),
				BackgroundColor3 = FromHex("#0A0A0A"),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = PanelZIndex,
			})
			Items["Panel"]:AddToTheme({ BackgroundColor3 = "Background" })
			Items["Panel"]:MakeDraggable()

			Instances:Create("UICorner", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 8),
			})

			local Stroke = Instances:Create("UIStroke", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 2,
				LineJoinMode = Enum.LineJoinMode.Round,
				Color = FromRGB(255, 255, 255),
			})
			Instances:Create("UIGradient", {
				Parent = Stroke.Instance,
				Name = "\0",
				Rotation = 90,
				Color = RGBSequence({
					RGBSequenceKeypoint(0, Library.Theme.Accent),
					RGBSequenceKeypoint(1, Library.Theme.Accent:Lerp(Library.Theme.Background, 0.75)),
				}),
			}):AddToTheme({
				Color = function()
					return RGBSequence({
						RGBSequenceKeypoint(0, Library.Theme.Accent),
						RGBSequenceKeypoint(1, Library.Theme.Accent:Lerp(Library.Theme.Background, 0.75)),
					})
				end,
			})

			Items["Icon"] = CreateIcon(Data.Icon or "keyboard", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, 14, 0, 15),
				Size = UDim2New(0, 16, 0, 14),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			}, { "Accent" })

			Items["Title"] = Instances:Create("TextLabel", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, 39, 0, 14),
				Size = UDim2New(0, 70, 0, 16),
				FontFace = Library.BoldFont,
				Text = Data.Title or "Hotkeys",
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Library.Theme.Accent,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			})
			Items["Title"]:AddToTheme({ TextColor3 = "Accent" })

			Items["Divider"] = Instances:Create("Frame", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, 14, 0, 39),
				Size = UDim2New(1, -28, 0, 1),
				BackgroundColor3 = FromRGB(30, 30, 30),
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			})
			Items["Divider"]:AddToTheme({ BackgroundColor3 = "Outline" })

			Items["List"] = Instances:Create("ScrollingFrame", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, 14, 0, 52),
				Size = UDim2New(1, -28, 1, -62),
				Active = true,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2New(0, 0, 0, 0),
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			})
			Instances:Create("UIListLayout", {
				Parent = Items["List"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 7),
				SortOrder = Enum.SortOrder.LayoutOrder,
			})

			local FormatKey = function(Keybind)
				return "[" .. (Keybind.Value ~= "" and Keybind.Value or "?") .. "]"
			end

			function Hotkeys:Refresh()
				for _, Row in Hotkeys.Rows do
					Row:Clean()
				end
				table.clear(Hotkeys.Rows)

				for Index, Keybind in Library.Keybinds do
					if Keybind.ShowInHotkeys ~= false and Keybind.Value ~= "None" and Keybind.Value ~= "" then
						local Row = Instances:Create("Frame", {
							Parent = Items["List"].Instance,
							Name = "\0",
							LayoutOrder = Index,
							Size = UDim2New(1, 0, 0, 14),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ZIndex = RowZIndex,
						})
						local Key = Instances:Create("TextLabel", {
							Parent = Row.Instance,
							Name = "\0",
							Size = UDim2New(0, 34, 1, 0),
							FontFace = Library.BoldFont,
							Text = FormatKey(Keybind),
							TextSize = 12,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextColor3 = Keybind.Toggled and Library.Theme.Accent or FromRGB(175, 175, 175),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ZIndex = RowZIndex,
						})
						Key:AddToTheme({
							TextColor3 = function()
								return Keybind.Toggled and Library.Theme.Accent or FromRGB(175, 175, 175)
							end,
						})
						local Action = Instances:Create("TextLabel", {
							Parent = Row.Instance,
							Name = "\0",
							Position = UDim2New(0, 35, 0, 0),
							Size = UDim2New(1, -35, 1, 0),
							FontFace = Library.Font,
							Text = Keybind.Name .. " - " .. (Keybind.Toggled and "Active" or "Inactive"),
							TextSize = 12,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextColor3 = Keybind.Toggled and Library.Theme.Accent or FromRGB(175, 175, 175),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ZIndex = RowZIndex,
						})
						Action:AddToTheme({
							TextColor3 = function()
								return Keybind.Toggled and Library.Theme.Accent or FromRGB(175, 175, 175)
							end,
						})
						table.insert(Hotkeys.Rows, Row)
					end
				end
			end

			function Hotkeys:SetVisible(Bool)
				Hotkeys.Visible = Bool
				if Hotkeys.Visible then
					Hotkeys:Refresh()
					Items["Panel"].Instance.Parent = Library.Holder.Instance
				end
				Items["Panel"].Instance.Visible = Hotkeys.Visible
				if not Hotkeys.Visible then
					Items["Panel"].Instance.Parent = Library.UnusedHolder.Instance
				end
			end

			function Hotkeys:Toggle()
				Hotkeys:SetVisible(not Hotkeys.Visible)
			end

			Library.HotkeyInstance = Hotkeys
			return Hotkeys
		end

		Library.Watermark = function(self, Data)
			Data = Data or {}

			if Library.WatermarkInstance then
				return Library.WatermarkInstance
			end

			local Icon = Data.Icon or Data.icon or "sparkles"
			-- IconSize 保留旧的显式写法继续可用；Size 是简写。
			local IconSize = Data.IconSize or Data.iconSize or Data.Size or Data.size or UDim2New(0, 28, 0, 28)

			local Items = {}
			Items["Bar"] = Instances:Create("Frame", {
				Parent = Library.Holder.Instance,
				Name = "\0",
				AnchorPoint = Vector2New(0.5, 0),
				Position = UDim2New(0.5, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2New(0, 0, 0, 32),
				BorderSizePixel = 0,
				BackgroundColor3 = FromHex("#0A0A0A"),
			})
			Items["Bar"]:AddToTheme({
				BackgroundColor3 = function()
					return FromHex("#0A0A0A")
				end,
			})
			Items["Bar"]:MakeDraggable()

			Instances:Create("UICorner", {
				Parent = Items["Bar"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 8),
			})

			Instances:Create("UIStroke", {
				Parent = Items["Bar"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = FromRGB(30, 30, 30),
			}):AddToTheme({ Color = "Outline" })

			Instances:Create("UIPadding", {
				Parent = Items["Bar"].Instance,
				Name = "\0",
				PaddingLeft = UDimNew(0, 12),
				PaddingRight = UDimNew(0, 12),
			})

			Instances:Create("UIListLayout", {
				Parent = Items["Bar"].Instance,
				Name = "\0",
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDimNew(0, 10),
			})

			local Order = 0
			local NextOrder = function()
				Order += 1
				return Order
			end

			Items["Icon"] = CreateIcon(Icon, {
				Parent = Items["Bar"].Instance,
				Name = "\0",
				LayoutOrder = NextOrder(),
				ImageColor3 = FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = IconSize,
				BorderSizePixel = 0,
				BackgroundColor3 = FromRGB(255, 255, 255),
			}, { "Text" })

			local Separator = function()
				local Item = Instances:Create("Frame", {
					Parent = Items["Bar"].Instance,
					Name = "\0",
					LayoutOrder = NextOrder(),
					Size = UDim2New(0, 1, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(38, 38, 38),
				})
				Item:AddToTheme({ BackgroundColor3 = "Element" })
			end

			local Stat = function(Text)
				local Item = Instances:Create("TextLabel", {
					Parent = Items["Bar"].Instance,
					Name = "\0",
					LayoutOrder = NextOrder(),
					FontFace = Library.Font,
					Text = Text,
					TextColor3 = FromRGB(125, 125, 125),
					TextSize = 14,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 16),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Item:AddToTheme({ TextColor3 = "Dark Text" })
				return Item
			end

			Separator()
			local GameStat = Stat("...")
			Separator()
			local FpsStat = Stat("0 fps")
			Separator()
			local PingStat = Stat("0 ms")
			Separator()
			local TimeStat = Stat(os.date("%I:%M %p"))

			Library:Thread(function()
				local Ok, Info = pcall(function()
					return MarketplaceService:GetProductInfo(game.PlaceId)
				end)
				GameStat.Instance.Text = (Ok and Info and Info.Name) or "Unknown"
			end)

			local Frames = 0
			local WatermarkEnabled = true
			Library:Connect(RunService.RenderStepped, function()
				if WatermarkEnabled then
					Frames += 1
				end
			end)

			Library:Thread(function()
				while task.wait(0.5) do
					if not Items["Bar"].Instance.Parent then
						break
					end

					if not WatermarkEnabled then
						continue
					end

					FpsStat.Instance.Text = tostring(Frames * 2) .. " fps"
					Frames = 0

					local Ping = 0
					pcall(function()
						Ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
					end)

					PingStat.Instance.Text = tostring(Ping) .. " ms"
					TimeStat.Instance.Text = os.date("%I:%M %p")
				end
			end)

			local Watermark = {
				Instance = Items["Bar"].Instance,
				Enabled = true,
			}

			function Watermark:SetEnabled(Bool)
				WatermarkEnabled = Bool
				self.Enabled = WatermarkEnabled
				Items["Bar"].Instance.Visible = WatermarkEnabled
				Frames = 0
			end

			function Watermark:SetIcon(NewIcon)
				ReplaceIcon(Items["Icon"], NewIcon, { "Text" })
			end

			function Watermark:SetIconSize(NewSize)
				if typeof(NewSize) ~= "UDim2" then
					return
				end

				-- 只有图标缩放；进度条保持自身高度。
				Items["Icon"].Instance.Size = NewSize
			end

			function Watermark:SetVisible(Bool)
				Items["Bar"].Instance.Visible = Bool
			end

			function Watermark:Destroy()
				Items["Bar"]:Clean()
				Library.WatermarkInstance = nil
			end

			Library.WatermarkInstance = Watermark
			Watermark:SetEnabled(Library.Flags.Watermark ~= false)
			return Watermark
		end

		Library.ESPPreview = function(self, Data)
			Data = Data or {}

			local Preview = {
				Connections = {},
				Destroyed = false,
				Visible = Data.Visible ~= false,
			}
			local Items = {}

			local Connect = function(Signal, Callback)
				local Connection = Signal:Connect(Callback)
				table.insert(Preview.Connections, Connection)
				return Connection
			end
			local PreviewCamera = InstanceNew("Camera")
			PreviewCamera.Name = "\0"
			local World = InstanceNew("WorldModel")
			World.Name = "\0"
			local CharacterModel
			local CharacterCenter
			local CharacterBounds

			Items["Panel"] = Instances:Create("Frame", {
				Parent = Library.Holder.Instance,
				Name = "\0",
				AnchorPoint = Vector2New(1, 0.5),
				Position = Data.Position or UDim2New(1, 0, 0.5, 0),
				Size = Data.Size or UDim2New(0, 260, 0, 365),
				BackgroundColor3 = FromRGB(22, 22, 22),
				BorderSizePixel = 0,
				Visible = Preview.Visible,
			})
			Items["Panel"]:AddToTheme({ BackgroundColor3 = "Background" })

			Instances:Create("UICorner", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
			})
			Instances:Create("UIStroke", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Thickness = 1,
				Transparency = 0.2,
			}):AddToTheme({ Color = "Outline" })

			Items["Title"] = Instances:Create("TextLabel", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				BackgroundTransparency = 1,
				Position = UDim2New(0, 14, 0, 14),
				Size = UDim2New(1, -28, 0, 15),
				FontFace = Library.BoldFont,
				Text = Data.Name or "ESP Preview",
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = FromRGB(255, 255, 255),
				BorderSizePixel = 0,
			})
			Items["Title"]:AddToTheme({ TextColor3 = "Text" })

			Items["Canvas"] = Instances:Create("Frame", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, 14, 0, 38),
				Size = UDim2New(1, -28, 1, -52),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
			})

			Items["Viewport"] = Instances:Create("ViewportFrame", {
				Parent = Items["Canvas"].Instance,
				Name = "\0",
				Position = UDim2New(0, 0, 0, 0),
				Size = UDim2New(1, 0, 1, 0),
				BackgroundColor3 = Library.Theme.Element,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Ambient = FromRGB(185, 185, 185),
				LightColor = FromRGB(255, 255, 255),
				Active = true,
				ZIndex = 1,
			})
			local Viewport = Items["Viewport"].Instance
			Viewport.CurrentCamera = PreviewCamera
			PreviewCamera.Parent = Viewport
			World.Parent = Viewport

			Instances:Create("UICorner", {
				Parent = Items["Canvas"].Instance,
				Name = "\0",
			})

			-- 角括号。把每条臂锚定到各自的角上，能让它们在
			-- 任何面板尺寸下都贴着边缘，这是固定缩放偏移做不到的。
			local Brackets = Instances:Create("Frame", {
				Parent = Items["Canvas"].Instance,
				Name = "\0",
				Position = UDim2New(0, 0, 0, 0),
				Size = UDim2New(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
			})

			local BracketLength = Data.BracketLength or 22
			local BracketThickness = Data.BracketThickness or 2

			local MakeArm = function(Position, Size, AnchorPoint)
				local Arm = Instances:Create("Frame", {
					Parent = Brackets.Instance,
					Name = "\0",
					Position = Position,
					Size = Size,
					AnchorPoint = AnchorPoint,
					BackgroundColor3 = Library.Theme.Text,
					BackgroundTransparency = 0.2,
					BorderSizePixel = 0,
					ZIndex = 2,
				})
				Arm:AddToTheme({ BackgroundColor3 = "Text" })
				return Arm
			end

			-- 每个角各得到一条水平臂和一条垂直臂。
			local Corners = {
				{ UDim2New(0, 0, 0, 0), Vector2New(0, 0) },
				{ UDim2New(1, 0, 0, 0), Vector2New(1, 0) },
				{ UDim2New(0, 0, 1, 0), Vector2New(0, 1) },
				{ UDim2New(1, 0, 1, 0), Vector2New(1, 1) },
			}

			for _, Corner in Corners do
				MakeArm(
					Corner[1],
					UDim2New(0, BracketLength, 0, BracketThickness),
					Corner[2]
				)
				MakeArm(
					Corner[1],
					UDim2New(0, BracketThickness, 0, BracketLength),
					Corner[2]
				)
			end

			local Dragging, Pinching = false, false
			local LastMousePos, LastPinchDist = nil, 0

			local FocusCamera = function()
				if not CharacterCenter or not CharacterBounds then
					return
				end

				local MaxExtent = math.max(CharacterBounds.X, CharacterBounds.Y, CharacterBounds.Z)
				local CameraDistance = MaxExtent * 2
				PreviewCamera.CFrame =
					CFrame.new(CharacterCenter + Vector3New(0, MaxExtent / 2, CameraDistance), CharacterCenter)
			end

			local IsPointerOverViewport = function(Position)
				local PointerPosition = Position or UserInputService:GetMouseLocation()
				local ViewportPosition = Viewport.AbsolutePosition
				local ViewportSize = Viewport.AbsoluteSize
				return PointerPosition.X >= ViewportPosition.X
					and PointerPosition.X <= ViewportPosition.X + ViewportSize.X
					and PointerPosition.Y >= ViewportPosition.Y
					and PointerPosition.Y <= ViewportPosition.Y + ViewportSize.Y
			end

			Connect(Viewport.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton2 then
					Dragging = true
					LastMousePos = Input.Position
				elseif Input.UserInputType == Enum.UserInputType.Touch and not Pinching then
					Dragging = true
					LastMousePos = Input.Position
				end
			end)

			Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton2 then
					Dragging = false
					LastMousePos = nil
				elseif Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
					LastMousePos = nil
				end
			end)

			Connect(UserInputService.InputChanged, function(Input)
				if not Dragging or Pinching or not CharacterCenter or not LastMousePos then
					return
				end

				if
					Input.UserInputType == Enum.UserInputType.MouseMovement
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					local MouseDelta = Input.Position - LastMousePos
					LastMousePos = Input.Position

					local RotationY = CFrame.fromAxisAngle(Vector3New(0, 1, 0), -MouseDelta.X * 0.01)
					PreviewCamera.CFrame = CFrame.new(CharacterCenter)
						* RotationY
						* CFrame.new(-CharacterCenter)
						* PreviewCamera.CFrame

					local RotationX = CFrame.fromAxisAngle(PreviewCamera.CFrame.RightVector, -MouseDelta.Y * 0.01)
					local PitchedCFrame = CFrame.new(CharacterCenter)
						* RotationX
						* CFrame.new(-CharacterCenter)
						* PreviewCamera.CFrame
					if PitchedCFrame.UpVector.Y > 0.1 then
						PreviewCamera.CFrame = PitchedCFrame
					end
				end
			end)

			Connect(Viewport.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseWheel then
					local ZoomAmount = Input.Position.Z * 2
					PreviewCamera.CFrame += PreviewCamera.CFrame.LookVector * ZoomAmount
				end
			end)

			Connect(UserInputService.TouchPinch, function(TouchPositions, Scale, Velocity, State)
				if not CharacterCenter or not IsPointerOverViewport(TouchPositions[1]) then
					return
				end

				if State == Enum.UserInputState.Begin then
					Pinching = true
					Dragging = false
					LastPinchDist = (TouchPositions[1] - TouchPositions[2]).Magnitude
				elseif State == Enum.UserInputState.Change then
					local CurrentDistance = (TouchPositions[1] - TouchPositions[2]).Magnitude
					local Delta = (CurrentDistance - LastPinchDist) * 0.1
					LastPinchDist = CurrentDistance
					PreviewCamera.CFrame += PreviewCamera.CFrame.LookVector * Delta
				elseif State == Enum.UserInputState.End or State == Enum.UserInputState.Cancel then
					Pinching = false
				end
			end)

			local ClearCharacter = function()
				if CharacterModel then
					CharacterModel:Destroy()
					CharacterModel = nil
					CharacterCenter = nil
					CharacterBounds = nil
				end
			end

			function Preview:SetCharacter(Character)
				ClearCharacter()
				if not Character then
					return
				end

				local WasArchivable = Character.Archivable
				Character.Archivable = true
				local Success, Model = pcall(function()
					return Character:Clone()
				end)
				Character.Archivable = WasArchivable
				if not Success or not Model then
					return
				end

				for _, Child in Model:GetDescendants() do
					if Child:IsA("Script") or Child:IsA("LocalScript") then
						Child:Destroy()
					elseif Child:IsA("BasePart") then
						Child.Anchored = true
					end
				end

				Model.Parent = World
				CharacterModel = Model
				local Center, Bounds = Model:GetBoundingBox()
				CharacterCenter = Center.Position
				CharacterBounds = Bounds
				FocusCamera()
			end

			function Preview:SetVisible(Bool)
				Preview.Visible = Bool
				Items["Panel"].Instance.Visible = Preview.Visible
			end

			function Preview:SetText(Text)
				Items["Title"].Instance.Text = tostring(Text)
			end

			function Preview:Destroy()
				if Preview.Destroyed then
					return
				end

				Preview.Destroyed = true
				for _, Connection in Preview.Connections do
					Connection:Disconnect()
				end
				table.clear(Preview.Connections)
				ClearCharacter()
				Items["Panel"]:Clean()
			end

			Items["Panel"]:MakeDraggable(Items["Title"])
			Connect(LocalPlayer.CharacterAdded, function(Character)
				if Preview.Destroyed then
					return
				end

				task.defer(function()
					if not Preview.Destroyed then
						Preview:SetCharacter(Character)
					end
				end)
			end)
			Preview:SetCharacter(Data.Character or LocalPlayer.Character)

			return Preview
		end

		Library.Notification = function(self, Name, Icon, Duration)
			Icon = Icon or "bell"
			Name = Name or "Notification"
			Duration = Duration or 5

			local Items = {}
			do
				Items["Notification"] = Instances:Create("Frame", {
					Parent = Library.NotifHolder.Instance,
					Name = "\0",
					Size = UDim2New(0, 0, 0, 32),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = FromRGB(13, 15, 18),
				})
				Items["Notification"]:AddToTheme({ BackgroundColor3 = "Background" })

				Instances:Create("UICorner", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Items["Stroke"] = Instances:Create("UIStroke", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					Color = FromRGB(26, 30, 36),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				})
				Items["Stroke"]:AddToTheme({ Color = "Outline" })

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(200, 200, 200),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Name,
					AnchorPoint = Vector2New(0, 0.5),
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 24, 0.5, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["Icon"] = CreateIcon(Icon, {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(200, 200, 200),
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0.5, 0),
					Size = UDim2New(0, 16, 0, 16),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				}, { "Text" })

				Instances:Create("UIPadding", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 8),
					PaddingBottom = UDimNew(0, 8),
					PaddingRight = UDimNew(0, 8),
					PaddingLeft = UDimNew(0, 8),
				})
			end
			table.insert(Library.NotifOrder, Items["Notification"].Instance)
			Library:UpdateNotificationPositions(true)

			local Size = Items["Notification"].Instance.AbsoluteSize
			Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)

			for Index, Value in Items do
				if Value.Instance:IsA("Frame") then
					Value.Instance.BackgroundTransparency = 1
				elseif Value.Instance:IsA("TextLabel") then
					Value.Instance.TextTransparency = 1
				elseif Value.Instance:IsA("ImageLabel") then
					Value.Instance.ImageTransparency = 1
				elseif Value.Instance:IsA("UIStroke") then
					Value.Instance.Transparency = 1
				end
			end

			Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.Y
			local Info = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)

			Library:Thread(function()
				for Index, Value in Items do
					if Value.Instance:IsA("Frame") then
						Value:Tween(Info, { BackgroundTransparency = 0 })
					elseif Value.Instance:IsA("TextLabel") then
						Value:Tween(Info, { TextTransparency = 0 })
					elseif Value.Instance:IsA("ImageLabel") then
						Value:Tween(Info, { ImageTransparency = 0 })
					elseif Value.Instance:IsA("UIStroke") then
						Value:Tween(Info, { Transparency = 0 })
					end
				end

				Items["Notification"]:Tween(Info, { Size = UDim2New(0, Size.X, 0, Size.Y) })

				task.delay(Duration + 0.15, function()
					for Index, Value in Items do
						if Value.Instance:IsA("Frame") then
							Value:Tween(nil, { BackgroundTransparency = 1 })
						elseif Value.Instance:IsA("TextLabel") then
							Value:Tween(nil, { TextTransparency = 1 })
						elseif Value.Instance:IsA("ImageLabel") then
							Value:Tween(nil, { ImageTransparency = 1 })
						elseif Value.Instance:IsA("UIStroke") then
							Value:Tween(nil, { Transparency = 1 })
						end
					end

					Items["Notification"]:Tween(Info, { Size = UDim2New(0, 0, 0, 32) })
					task.wait(0.5)
					Items["Notification"]:Clean()
					table.remove(Library.NotifOrder, table.find(Library.NotifOrder, Items["Notification"].Instance))
					Library:UpdateNotificationPositions()
				end)
			end)
		end

		Library.UpdateNotificationPositions = function(self, Snap: boolean?)
			local RunningY = 0
			for _, Frame in ipairs(self.NotifOrder) do
				if not Frame.Parent then
					continue
				end
				local Target = UDim2.fromOffset(0, RunningY)
				if Snap then
					Frame.Position = Target
				elseif Frame.Position ~= Target then
					TweenService:Create(Frame, self.NotifyTweenInfo, { Position = Target }):Play()
				end
				RunningY += Frame.AbsoluteSize.Y + 8
			end
		end

		Library.SetNotifySide = function(self, Side: string)
			self.NotifySide = Side
			local Holder = self.NotifHolder and self.NotifHolder.Instance
			if not Holder then
				return
			end
			local IsRight = string.find(Side, "Right", 1, true) ~= nil
			local IsBottom = string.find(Side, "Bottom", 1, true) ~= nil
			Holder.AnchorPoint = Vector2New(IsRight and 1 or 0, IsBottom and 1 or 0)
			Holder.Position = UDim2New(IsRight and 1 or 0, 0, IsBottom and 1 or 0, 0)
			local Layout = Holder:FindFirstChildOfClass("UIListLayout")
			if Layout then
				Layout.HorizontalAlignment = IsRight and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
				Layout.VerticalAlignment = IsBottom and Enum.VerticalAlignment.Bottom or Enum.VerticalAlignment.Top
			end
			self:UpdateNotificationPositions(true)
		end

		Library.Notify = Library.Notification

		Library.HeaderBar = function(self, Data)
			Data = Data or {}

			if Library.HeaderBarInstance then
				return Library.HeaderBarInstance
			end

			local HeaderBar = {
				Slots = {},
				Items = {},
				Destroyed = false,
				Exclusive = Data.Exclusive,
				ActiveIndex = Data.ActiveIndex or Data.activeIndex or 1,
			}

			local Items = HeaderBar.Items
			local SlotDefinitions = Data.Slots
				or Data.slots
				or Data.Items
				or Data.items
				or Data.Icons
				or Data.icons
				or {}
			local DefaultIcon = Data.Icon or Data.icon or "house"

			local GetSlotDefinition = function(Index)
				local Definition = SlotDefinitions[Index]

				if type(Definition) == "table" then
					return Definition
				elseif Definition ~= nil then
					return { Icon = Definition }
				end

				return {}
			end

			Items["Bar"] = Instances:Create("Frame", {
				Parent = Library.Holder.Instance,
				Name = "\0",
				AnchorPoint = Vector2New(0.5, 0),
				Position = Data.Position or UDim2New(0.5, 0, 0, 40),
				Size = UDim2New(0, 0, 0, 41),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = FromHex("#0A0A0A"),
				BorderSizePixel = 0,
				ZIndex = Data.ZIndex or 10,
			})
			Items["Bar"]:AddToTheme({
				BackgroundColor3 = function()
					return FromHex("#0A0A0A")
				end,
			})
			Items["Bar"]:MakeDraggable()

			Instances:Create("UICorner", {
				Parent = Items["Bar"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 9),
			})

			Items["Stroke"] = Instances:Create("UIStroke", {
				Parent = Items["Bar"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = FromRGB(255, 255, 255),
				Thickness = 2,
				LineJoinMode = Enum.LineJoinMode.Round,
			})

			local StrokeGradient = Instances:Create("UIGradient", {
				Parent = Items["Stroke"].Instance,
				Name = "\0",
				Rotation = 90,
				Color = RGBSequence({
					RGBSequenceKeypoint(0, Library.Theme["Accent"]),
					RGBSequenceKeypoint(1, Library.Theme["Accent"]:Lerp(Library.Theme["Background"], 0.75)),
				}),
			})
			StrokeGradient:AddToTheme({
				Color = function()
					return RGBSequence({
						RGBSequenceKeypoint(0, Library.Theme["Accent"]),
						RGBSequenceKeypoint(1, Library.Theme["Accent"]:Lerp(Library.Theme["Background"], 0.75)),
					})
				end,
			})

			Items["Content"] = Instances:Create("Frame", {
				Parent = Items["Bar"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = (Data.ZIndex or 10) + 1,
			})

			Instances:Create("UIPadding", {
				Parent = Items["Content"].Instance,
				Name = "\0",
				PaddingLeft = UDimNew(0, 6.5),
				PaddingRight = UDimNew(0, 6.5),
			})

			Instances:Create("UIListLayout", {
				Parent = Items["Content"].Instance,
				Name = "\0",
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDimNew(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
			})

			local SlotSize = 28
			local IconSize = 22

			-- 图标后面不加底板：激活状态是字形背后的一层柔和光晕，
			-- 在加载时生成到 Assets 文件夹，因此不需要资源 id。
			local InactiveIconColor = FromRGB(130, 130, 130)
			local IconRestTransparency = 0
			local GlowSize = IconSize + 24
			local GlowLitTransparency = 0.35

			local SetSlotVisual = function(Slot)
				local Active = Slot.Value and true or false
				local Accent = Library.Theme["Accent"]

				Slot.Items["Slot"].Instance.BackgroundTransparency = 1

				local Icon = Slot.Items["Icon"].Instance
				Icon.ImageColor3 = Active and Accent or InactiveIconColor
				Icon.ImageTransparency = IconRestTransparency

				-- 一张预先生成的衰减贴图；用实时的 Accent 给它着色。
				local Glow = Slot.Items["Glow"].Instance
				Glow.ImageColor3 = Accent
				Glow.ImageTransparency = if Active then GlowLitTransparency else 1
				Glow.Visible = Active
			end

			local SetSlotValue = function(Slot, Value, FireCallback)
				Slot.Value = Value

				if Slot.Value then
					HeaderBar.ActiveIndex = Slot.Index
				elseif HeaderBar.ActiveIndex == Slot.Index then
					HeaderBar.ActiveIndex = nil
					for OtherIndex, OtherSlot in HeaderBar.Slots do
						if OtherSlot.Value then
							HeaderBar.ActiveIndex = OtherIndex
							break
						end
					end
				end

				if Slot.Flag then
					Library.Flags[Slot.Flag] = Slot.Value
				end

				SetSlotVisual(Slot)

				if FireCallback and Slot.Callback then
					Library:SafeCall(Slot.Callback, Slot.Value, Slot.Index, HeaderBar)
				end
			end

			for Index = 1, #SlotDefinitions do
				local Definition = GetSlotDefinition(Index)
				local Slot = {
					Index = Index,
					Flag = Definition.Flag or Definition.flag,
					Callback = Definition.Callback or Definition.callback or Data.Callback or Data.callback,
					Value = Definition.Default ~= nil and Definition.Default
						or (Definition.Default == nil and Index == HeaderBar.ActiveIndex),
					Items = {},
				}

				local Icon = Definition.Icon or Definition.icon or DefaultIcon

				Slot.Items["Slot"] = Instances:Create("TextButton", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					LayoutOrder = Index,
					FontFace = Library.Font,
					Text = "",
					AutoButtonColor = false,
					Size = UDim2New(0, SlotSize, 0, SlotSize),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = (Data.ZIndex or 10) + 1,
				})

				Slot.Items["Icon"] = CreateIcon(Icon, {
					Parent = Slot.Items["Slot"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0.5, 0.5),
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, IconSize, 0, IconSize),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = (Data.ZIndex or 10) + 5,
				}, { "Accent" })

				-- 单层柔和光晕；位于字形之下，跟随实时的 Accent。
				Slot.Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Slot.Items["Slot"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0.5, 0.5),
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, GlowSize, 0, GlowSize),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = Library.GlowTexture or "",
					ImageColor3 = Library.Theme["Accent"],
					ImageTransparency = 1,
					Visible = false,
					ZIndex = (Data.ZIndex or 10) + 2,
				})
				Slot.Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				function Slot:Get()
					return Slot.Value
				end

				function Slot:Set(Value, FireCallback)
					if HeaderBar.Exclusive and Value then
						for OtherIndex, OtherSlot in HeaderBar.Slots do
							if OtherSlot ~= Slot and OtherSlot.Value then
								SetSlotValue(OtherSlot, false, false)
							end
						end
					end

					SetSlotValue(Slot, Value, FireCallback ~= false)
				end

				function Slot:SetIcon(NewIcon)
					ReplaceIcon(Slot.Items["Icon"], NewIcon, { "Accent" })
					SetSlotVisual(Slot)
				end

				function Slot:SetCallback(Callback)
					Slot.Callback = Callback
				end

				function Slot:SetVisibility(Bool)
					Slot.Items["Slot"].Instance.Visible = Bool
				end

				Slot.Items["Slot"]:Connect("MouseButton1Down", function()
					Slot:Set(not Slot.Value)
				end)

				HeaderBar.Slots[Index] = Slot
				if Slot.Flag then
					Library.SetFlags[Slot.Flag] = function(Value)
						Slot:Set(Value, false)
					end
				end

				SetSlotValue(Slot, Slot.Value, false)
			end

			function HeaderBar:Get(Index)
				local Slot = HeaderBar.Slots[Index]
				return Slot and Slot:Get()
			end

			function HeaderBar:Set(Index, Value, FireCallback)
				local Slot = HeaderBar.Slots[Index]
				if Slot then
					Slot:Set(Value, FireCallback)
				end
			end

			function HeaderBar:Select(Index, FireCallback)
				local Slot = HeaderBar.Slots[Index]
				if Slot then
					Slot:Set(true, FireCallback)
				end
			end

			function HeaderBar:SetIcon(Index, NewIcon)
				local Slot = HeaderBar.Slots[Index]
				if Slot then
					Slot:SetIcon(NewIcon)
				end
			end

			function HeaderBar:SetCallback(Index, Callback)
				local Slot = HeaderBar.Slots[Index]
				if Slot then
					Slot:SetCallback(Callback)
				end
			end

			function HeaderBar:SetVisible(Bool)
				Items["Bar"].Instance.Visible = Bool
			end

			function HeaderBar:Destroy()
				if HeaderBar.Destroyed then
					return
				end

				HeaderBar.Destroyed = true
				Items["Bar"]:Clean()
				Library.HeaderBarInstance = nil
			end

			Library.HeaderBarInstance = HeaderBar
			return HeaderBar
		end

		Library.Keysystem = function(self, Data)
			Data = Data or {}

			if Library.KeysystemInstance then
				return Library.KeysystemInstance
			end

			local BaseZIndex = Data.ZIndex or 10
			local ContentZIndex = BaseZIndex + 1
			local Keysystem = {
				Items = {},
				Visible = Data.Visible ~= false,
				Value = tostring(Data.Default or Data.default or ""),
				Flag = Data.Flag or Data.flag,
				Destroyed = false,
			}
			local Items = Keysystem.Items
			local GetKeyCallback = Data.GetKeyCallback or Data.getKeyCallback
			local SubmitKeyCallback = Data.SubmitKeyCallback or Data.submitKeyCallback or Data.Callback or Data.callback

			-- 布局由单个 padding 值驱动，让垂直节奏保持
			-- 均匀：标题上方 16，按钮下方 16，左右各 18。
			-- 块与块之间的间距保持 12，这样不会显得拥挤。
			local Padding = 18
			local Gap = 12
			local TitleY = 16
			local DividerY = TitleY + 16 + Gap
			local InputY = DividerY + 1 + Gap
			local InputHeight = 34
			local ButtonY = InputY + InputHeight + Gap
			local ButtonHeight = 32
			local PanelHeight = ButtonY + ButtonHeight + 16

			Items["Panel"] = Instances:Create("Frame", {
				Parent = Keysystem.Visible and Library.Holder.Instance or Library.UnusedHolder.Instance,
				Name = "\0",
				Position = Data.Position or UDim2New(0, 615, 0, 512),
				Size = Data.Size or UDim2New(0, 433, 0, PanelHeight),
				BackgroundColor3 = Library.Theme.Background,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Visible = Keysystem.Visible,
				ZIndex = BaseZIndex,
			})
			Items["Panel"]:AddToTheme({ BackgroundColor3 = "Background" })
			Items["Panel"]:MakeDraggable()

			Instances:Create("UICorner", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 10),
			})

			local PanelStroke = Instances:Create("UIStroke", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = FromRGB(255, 255, 255),
				Thickness = 2,
				LineJoinMode = Enum.LineJoinMode.Round,
			})

			local PanelStrokeGradient = Instances:Create("UIGradient", {
				Parent = PanelStroke.Instance,
				Name = "\0",
				Rotation = 90,
				Color = RGBSequence({
					RGBSequenceKeypoint(0, Library.Theme["Accent"]),
					RGBSequenceKeypoint(1, Library.Theme["Accent"]:Lerp(Library.Theme["Background"], 0.75)),
				}),
			})
			PanelStrokeGradient:AddToTheme({
				Color = function()
					return RGBSequence({
						RGBSequenceKeypoint(0, Library.Theme["Accent"]),
						RGBSequenceKeypoint(1, Library.Theme["Accent"]:Lerp(Library.Theme["Background"], 0.75)),
					})
				end,
			})

			Items["Title"] = Instances:Create("TextLabel", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, Padding, 0, TitleY),
				Size = UDim2New(0, 0, 0, 16),
				FontFace = Library.BoldFont,
				Text = Data.Title or "Key System",
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				AutomaticSize = Enum.AutomaticSize.X,
				TextColor3 = Library.Theme.Accent,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			})
			Items["Title"]:AddToTheme({ TextColor3 = "Accent" })

			Items["Divider"] = Instances:Create("Frame", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, Padding, 0, DividerY),
				Size = UDim2New(1, -(Padding * 2), 0, 1),
				BackgroundColor3 = Library.Theme.Outline,
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			})
			Items["Divider"]:AddToTheme({ BackgroundColor3 = "Outline" })

			Items["InputBackground"] = Instances:Create("Frame", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, Padding, 0, InputY),
				Size = UDim2New(1, -(Padding * 2), 0, InputHeight),
				BackgroundColor3 = Library.Theme.Background,
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			})
			Items["InputBackground"]:AddToTheme({ BackgroundColor3 = "Background" })

			Instances:Create("UICorner", {
				Parent = Items["InputBackground"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5),
			})

			local InputStroke = Instances:Create("UIStroke", {
				Parent = Items["InputBackground"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Library.Theme.Outline,
				Thickness = 1,
			})
			InputStroke:AddToTheme({ Color = "Outline" })

			-- 在其框内居中，所以文字坐在中间线上，
			-- 而不是贴着顶部边缘。
			Items["Input"] = Instances:Create("TextBox", {
				Parent = Items["InputBackground"].Instance,
				Name = "\0",
				Position = UDim2New(0, 12, 0, 0),
				Size = UDim2New(1, -24, 1, 0),
				FontFace = Library.Font,
				Text = Keysystem.Value,
				PlaceholderText = Data.Placeholder or "Luarmor and Pelican Support",
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Library.Theme["Dark Text"],
				PlaceholderColor3 = Library.Theme["Dark Text"],
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClearTextOnFocus = false,
				ZIndex = ContentZIndex + 1,
			})
			Items["Input"]:AddToTheme({ TextColor3 = "Dark Text", PlaceholderColor3 = "Dark Text" })

			-- 按钮共用一行：两个相等的半边，中间留一条间隔，
			-- 与外边缘的面板 padding 保持一致。
			-- 缩放为 0.5 时，宽度偏移是 -(Padding + Gutter/2)，
			-- 第二个按钮从 Gutter/2 开始，这样两条边都能对齐。
			local Gutter = 10
			local HalfWidth = 0.5
			local HalfInset = Padding + Gutter / 2

			local CreateButton = function(Position, Text, Width)
				local Button = Instances:Create("TextButton", {
					Parent = Items["Panel"].Instance,
					Name = "\0",
					Position = Position,
					Size = UDim2New(Width, -HalfInset, 0, ButtonHeight),
					Text = "",
					AutoButtonColor = false,
					BackgroundColor3 = Library.Theme.Accent,
					BorderSizePixel = 0,
					ZIndex = ContentZIndex,
				})
				Button:AddToTheme({ BackgroundColor3 = "Accent" })

				Instances:Create("UICorner", {
					Parent = Button.Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				local ButtonStroke = Instances:Create("UIStroke", {
					Parent = Button.Instance,
					Name = "\0",
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Library.Theme.Outline,
					Thickness = 1,
				})
				ButtonStroke:AddToTheme({ Color = "Outline" })

				local Label = Instances:Create("TextLabel", {
					Parent = Button.Instance,
					Name = "\0",
					Position = UDim2New(0, 0, 0, 0),
					Size = UDim2New(1, 0, 1, 0),
					FontFace = Library.BoldFont,
					Text = Text,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Library.Theme.Background,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = ContentZIndex + 1,
				})
				Label:AddToTheme({ TextColor3 = "Background" })

				return Button
			end

			Items["GetKey"] = CreateButton(UDim2New(0, Padding, 0, ButtonY), "Get Key", HalfWidth)
			Items["SubmitKey"] = CreateButton(
				UDim2New(HalfWidth, Gutter / 2, 0, ButtonY),
				"Submit Key",
				HalfWidth
			)

			function Keysystem:Get()
				return Keysystem.Value
			end

			function Keysystem:Set(Value)
				Keysystem.Value = tostring(Value or "")
				Items["Input"].Instance.Text = Keysystem.Value
				if Keysystem.Flag then
					Library.Flags[Keysystem.Flag] = Keysystem.Value
				end
			end

			function Keysystem:SetPlaceholder(Text)
				Items["Input"].Instance.PlaceholderText = tostring(Text or "")
			end

			function Keysystem:SetVisible(Bool)
				Keysystem.Visible = Bool
				Items["Panel"].Instance.Parent = Keysystem.Visible and Library.Holder.Instance
					or Library.UnusedHolder.Instance
				Items["Panel"].Instance.Visible = Keysystem.Visible
			end

			function Keysystem:Destroy()
				if Keysystem.Destroyed then
					return
				end

				Keysystem.Destroyed = true
				Items["Panel"]:Clean()
				Library.KeysystemInstance = nil
			end

			Items["Input"]:Connect("FocusLost", function()
				Keysystem:Set(Items["Input"].Instance.Text)
			end)
			Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
				Keysystem.Value = Items["Input"].Instance.Text
				if Keysystem.Flag then
					Library.Flags[Keysystem.Flag] = Keysystem.Value
				end
			end)
			Items["GetKey"]:Connect("MouseButton1Click", function()
				if GetKeyCallback then
					Library:SafeCall(GetKeyCallback, Keysystem.Value, Keysystem)
				end
			end)
			Items["SubmitKey"]:Connect("MouseButton1Click", function()
				if SubmitKeyCallback then
					Library:SafeCall(SubmitKeyCallback, Keysystem.Value, Keysystem)
				end
			end)

			if Keysystem.Flag then
				Library.SetFlags[Keysystem.Flag] = function(Value)
					Keysystem:Set(Value)
				end
			end
			Keysystem:Set(Keysystem.Value)
			Library.KeysystemInstance = Keysystem
			return Keysystem
		end
		Library.KeySystem = Library.Keysystem

		Library.Credits = function(self, Data)
			Data = Data or {}

			if Library.CreditsInstance then
				return Library.CreditsInstance
			end

			local DefaultRows = {}

			local BaseZIndex = Data.ZIndex or 10
			local ContentZIndex = BaseZIndex + 1
			local Credits = {
				Items = {},
				Rows = {},
				DataRows = Data.Rows or Data.rows or Data.Credits or Data.credits or DefaultRows,
				Visible = Data.Visible,
				Destroyed = false,
			}
			local Items = Credits.Items

			Items["Panel"] = Instances:Create("Frame", {
				Parent = Credits.Visible and Library.Holder.Instance or Library.UnusedHolder.Instance,
				Name = "\0",
				Position = Data.Position or UDim2New(0, 1064, 0, 364),
				Size = Data.Size or UDim2New(0, 312, 0, 438),
				BackgroundColor3 = Library.Theme.Background,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Visible = Credits.Visible,
				ZIndex = BaseZIndex,
			})
			Items["Panel"]:AddToTheme({ BackgroundColor3 = "Background" })
			Items["Panel"]:MakeDraggable()

			Instances:Create("UICorner", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 14),
			})

			local PanelStroke = Instances:Create("UIStroke", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Library.Theme.Outline,
				Thickness = 2,
			})
			PanelStroke:AddToTheme({ Color = "Outline" })

			Items["Header"] = Instances:Create("Frame", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, 18, 0, 18),
				Size = UDim2New(0, 276, 0, 30),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = ContentZIndex,
			})

			Items["List"] = Instances:Create("Frame", {
				Parent = Items["Panel"].Instance,
				Name = "\0",
				Position = UDim2New(0, 18, 0, 59),
				Size = UDim2New(0, 276, 0, 303),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				ZIndex = ContentZIndex,
			})

			Items["Title"] = Instances:Create("TextLabel", {
				Parent = Items["Header"].Instance,
				Name = "\0",
				Position = UDim2New(0, 0, 0, 0),
				Size = UDim2New(0, 47, 0, 16),
				FontFace = Library.Font,
				Text = Data.Title or "Credits",
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = FromHex("#FFFFFF"),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			})

			Items["Subtitle"] = Instances:Create("TextLabel", {
				Parent = Items["Header"].Instance,
				Name = "\0",
				Position = UDim2New(0, 0, 0, 18),
				Size = UDim2New(0, 157, 0, 12),
				FontFace = Library.RegularFont,
				Text = Data.Subtitle or 'Cool people behind "your" script',
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Library.Theme["Dark Text"],
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = ContentZIndex,
			})
			Items["Subtitle"]:AddToTheme({ TextColor3 = "Dark Text" })

			local CreateRow = function(Index, DataRow)
				DataRow = DataRow or {}
				local Row = Instances:Create("Frame", {
					Parent = Items["List"].Instance,
					Name = "\0",
					Position = UDim2New(0, 0, 0, (Index - 1) * 62),
					Size = UDim2New(0, 276, 0, 55),
					BackgroundColor3 = Library.Theme.Inline,
					BorderSizePixel = 0,
					ClipsDescendants = false,
					ZIndex = ContentZIndex,
				})
				Row:AddToTheme({ BackgroundColor3 = "Inline" })

				Instances:Create("UICorner", {
					Parent = Row.Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				local RowStroke = Instances:Create("UIStroke", {
					Parent = Row.Instance,
					Name = "\0",
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Library.Theme.Outline,
					Thickness = 1,
					ZIndex = ContentZIndex,
				})
				RowStroke:AddToTheme({ Color = "Outline" })

				local TopLine = Instances:Create("Frame", {
					Parent = Row.Instance,
					Name = "\0",
					Position = UDim2New(0, 12, 0, 8),
					Size = UDim2New(1, -24, 0, 17),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = ContentZIndex + 1,
				})

				Instances:Create("UIListLayout", {
					Parent = TopLine.Instance,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDimNew(0, 8),
				})

				local NameLabel = Instances:Create("TextLabel", {
					Parent = TopLine.Instance,
					Name = "\0",
					Size = UDim2New(0, 0, 0, 17),
					AutomaticSize = Enum.AutomaticSize.X,
					FontFace = Library.Font,
					Text = DataRow.Name or "",
					TextSize = 13,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Library.Theme.Text,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ClipsDescendants = false,
					LayoutOrder = 1,
					ZIndex = ContentZIndex + 1,
				})
				NameLabel:AddToTheme({ TextColor3 = "Text" })

				local Description = Instances:Create("TextLabel", {
					Parent = Row.Instance,
					Name = "\0",
					Position = UDim2New(0, 12, 0, 33),
					Size = UDim2New(1, -24, 0, 12),
					AutomaticSize = Enum.AutomaticSize.None,
					FontFace = Library.RegularFont,
					Text = DataRow.Description or "",
					TextSize = 10,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Library.Theme["Dark Text"],
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ClipsDescendants = false,
					ZIndex = ContentZIndex + 1,
				})
				Description:AddToTheme({ TextColor3 = "Dark Text" })

				local Badge = Instances:Create("Frame", {
					Parent = TopLine.Instance,
					Name = "\0",
					Size = UDim2New(0, 0, 0, 17),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = DataRow.BadgeBackground or Library.Theme.Element,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					ZIndex = ContentZIndex + 1,
				})
				if not DataRow.BadgeBackground then
					Badge:AddToTheme({ BackgroundColor3 = "Element" })
				end

				Instances:Create("UIPadding", {
					Parent = Badge.Instance,
					Name = "\0",
					PaddingLeft = UDimNew(0, 9),
					PaddingRight = UDimNew(0, 9),
				})

				Instances:Create("UICorner", {
					Parent = Badge.Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 10),
				})

				local BadgeStroke = Instances:Create("UIStroke", {
					Parent = Badge.Instance,
					Name = "\0",
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = DataRow.BadgeStroke or Library.Theme.Accent,
					Thickness = 1,
				})
				if not DataRow.BadgeStroke then
					BadgeStroke:AddToTheme({ Color = "Accent" })
				end

				local BadgeText = Instances:Create("TextLabel", {
					Parent = Badge.Instance,
					Name = "\0",
					Size = UDim2New(0, 0, 0, 17),
					AutomaticSize = Enum.AutomaticSize.X,
					FontFace = Library.Font,
					Text = DataRow.Badge or "",
					TextSize = 8,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = DataRow.BadgeText or Library.Theme.Accent,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = ContentZIndex + 2,
				})
				if not DataRow.BadgeText then
					BadgeText:AddToTheme({ TextColor3 = "Accent" })
				end

				return Row
			end

			function Credits:Refresh()
				for _, Row in Credits.Rows do
					Row:Clean()
				end
				table.clear(Credits.Rows)
				for Index, DataRow in Credits.DataRows do
					table.insert(Credits.Rows, CreateRow(Index, DataRow))
				end
			end

			function Credits:SetRows(Rows)
				Credits.DataRows = Rows or {}
				if Credits.Visible then
					Credits:Refresh()
				end
			end

			function Credits:SetVisible(Bool)
				Credits.Visible = Bool
				if Credits.Visible then
					Credits:Refresh()
				end
				Items["Panel"].Instance.Parent = Credits.Visible and Library.Holder.Instance
					or Library.UnusedHolder.Instance
				Items["Panel"].Instance.Visible = Credits.Visible
			end

			function Credits:Toggle()
				Credits:SetVisible(not Credits.Visible)
			end

			function Credits:Destroy()
				if Credits.Destroyed then
					return
				end

				Credits.Destroyed = true
				for _, Row in Credits.Rows do
					Row:Clean()
				end
				table.clear(Credits.Rows)
				Items["Panel"]:Clean()
				Library.CreditsInstance = nil
			end

			if Credits.Visible then
				Credits:Refresh()
			end
			Library.CreditsInstance = Credits
			return Credits
		end

		Library.Window = function(self, Data)
			Data = Data or {}

			local Window = {
				Name = Data.Name or Data.name or "Window",
				TimeRemaining = Data.TimeRemaining or 0,
				SubTitle = Data.SubTitle or Data.subtitle or "LDS13",

				Pages = {},
				Items = {},
				IsOpen = false,
			}

			local Items = {}
			do
				Items["MainFrame"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0.5, 0.5),
					Position = UDim2New(0.5, 0, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 550, 0, 502),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(13, 15, 18),
				})
				Items["MainFrame"]:AddToTheme({ BackgroundColor3 = "Background" })

				Items["MainFrame"]:MakeDraggable()

				Items["Shadow"] = Instances:Create("ImageLabel", {
					Name = "\0",
					Parent = Items["MainFrame"].Instance,
					ImageColor3 = Color3.fromRGB(0, 0, 0),
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 0.4,
					Size = UDim2.new(1, 25, 1, 25),
					ZIndex = -1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = "http://www.roblox.com/asset/?id=18245826428",
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BackgroundColor3 = Library.Theme["Accent"],
					BorderSizePixel = 0,
					SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
				})
				Items["Shadow"]:AddToTheme({ ImageColor3 = "Accent" })

				Instances:Create("UICorner", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Items["Top"] = Instances:Create("Frame", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 50),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					BackgroundColor3 = FromRGB(22, 25, 30),
				})
				Items["Top"]:AddToTheme({ BackgroundColor3 = "Inline" })

				Instances:Create("UICorner", {
					Parent = Items["Top"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Instances:Create("Frame", {
					Parent = Items["Top"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 0, 1, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 8),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					BackgroundColor3 = FromRGB(22, 25, 30),
				}):AddToTheme({ BackgroundColor3 = "Inline" })

				Instances:Create("Frame", {
					Parent = Items["Top"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 0, 1, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					BackgroundColor3 = FromRGB(26, 30, 36),
				}):AddToTheme({ BackgroundColor3 = "Outline" })

				Instances:Create("UIGradient", {
					Parent = Items["Top"].Instance,
					Name = "\0",
					Rotation = -90,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(223, 223, 223)),
					}),
				})

				local Content = Players:GetUserThumbnailAsync(
					LocalPlayer.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size420x420
				)

				Items["AvatarIcon"] = Instances:Create("ImageLabel", {
					Parent = Items["Top"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 0.5),
					Image = Content,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 12, 0.5, 0),
					Size = UDim2New(0, 30, 0, 30),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UICorner", {
					Parent = Items["AvatarIcon"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0),
				})

				Instances:Create("UIStroke", {
					Parent = Items["AvatarIcon"].Instance,
					Name = "\0",
					Color = FromRGB(26, 30, 36),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Outline" })

				Items["Username"] = Instances:Create("TextLabel", {
					Parent = Items["Top"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(200, 200, 200),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = LocalPlayer.Name,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 52, 0, 10),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Username"]:AddToTheme({ TextColor3 = "Text" })

				Items["TimeRemaining"] = Instances:Create("TextLabel", {
					Parent = Items["Top"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.5,
					Text = "Time remaining: " .. Window.TimeRemaining,
					Size = UDim2New(0, 0, 0, 15),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 52, 0, 25),
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["TimeRemaining"]:AddToTheme({ TextColor3 = "Text" })

                -- 头像、名字和计时器共用一个点击区域：点击它会打开资料弹窗。
                Items["ProfileTrigger"] = Instances:Create("TextButton", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 6, 0, 6),
                    Size = UDim2New(0, 230, 0, 38),
                    ZIndex = 1,
                });

                -- 弹窗铺满整个窗口，所以点击任何空白区域都会命中背景层并关闭它。
                Items["ProfilePopup"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 40,
                });

                Items["ProfileBackdrop"] = Instances:Create("TextButton", {
                    Parent = Items["ProfilePopup"].Instance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    Active = true,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 40,
                });

                -- 位于菜单（41）之下但高于窗口，所以点击屏幕上任何位置
                -- 都会关闭弹窗，而菜单仍可点击。
                Items["ProfileScreenBackdrop"] = Instances:Create("TextButton", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    Active = true,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Visible = false,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 39,
                });

                -- 锚定在窗口左边缘并向外偏移，让菜单
                -- 挂在窗口外侧，其顶部与打开它的头像齐平。
                Items["ProfileMenu"] = Instances:Create("Frame", {
                    Parent = Items["ProfilePopup"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(0, -8, 0, 10),
                    Size = UDim2New(0, 190, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(22, 22, 22),
                    BorderSizePixel = 0,
                    ZIndex = 41,
                });
                Items["ProfileMenu"]:AddToTheme({ BackgroundColor3 = "Inline" });

                Instances:Create("UICorner", {
                    Parent = Items["ProfileMenu"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6),
                });

                Instances:Create("UIStroke", {
                    Parent = Items["ProfileMenu"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 30, 30),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                }):AddToTheme({ Color = "Outline" });

                Instances:Create("UIListLayout", {
                    Parent = Items["ProfileMenu"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                });

                Instances:Create("UIPadding", {
                    Parent = Items["ProfileMenu"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 4),
                    PaddingBottom = UDimNew(0, 4),
                    PaddingLeft = UDimNew(0, 4),
                    PaddingRight = UDimNew(0, 4),
                });

                -- 选中某一行会隐藏其目标并打勾；再次选中则恢复。
                local function ToggleProfileRow(Row)
                    Row.Selected = not Row.Selected;
                    Row.Checkmark.Instance.Visible = Row.Selected;
                    Row.Target.Instance.Visible = not Row.Selected;
                    Library.Flags[Row.Flag] = Row.Selected or nil;
                end;

                local function CreateProfileRow(Order, Label, Icon, Target, Flag)
                    local Row = {
                        Selected = false,
                        Target = Target,
                        Flag = Flag,
                    };

                    Row.Container = Instances:Create("TextButton", {
                        Parent = Items["ProfileMenu"].Instance,
                        Name = "\0",
                        Size = UDim2New(1, 0, 0, 30),
                        BackgroundColor3 = FromRGB(38, 38, 38),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Text = "",
                        AutoButtonColor = false,
                        LayoutOrder = Order,
                        ZIndex = 41,
                    });
                    Row.Container:AddToTheme({ BackgroundColor3 = "Element" });

                    Instances:Create("UICorner", {
                        Parent = Row.Container.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 5),
                    });

                    Row.Icon = CreateIcon(Icon, {
                        Parent = Row.Container.Instance,
                        Name = "\0",
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 8, 0.5, 0),
                        Size = UDim2New(0, 16, 0, 16),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        ZIndex = 42,
                    }, { "Dark Text" });

                    Row.Label = Instances:Create("TextLabel", {
                        Parent = Row.Container.Instance,
                        Name = "\0",
                        Position = UDim2New(0, 32, 0, 0),
                        Size = UDim2New(1, -64, 1, 0),
                        FontFace = Library.Font,
                        Text = Label,
                        TextColor3 = FromRGB(225, 225, 225),
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        ZIndex = 42,
                    });
                    Row.Label:AddToTheme({ TextColor3 = "Text" });

                    Row.Checkmark = Instances:Create("ImageLabel", {
                        Parent = Row.Container.Instance,
                        Name = "\0",
                        Icon = "check",
                        Colors = { "Accent" },
                        AnchorPoint = Vector2New(1, 0.5),
                        Position = UDim2New(1, -8, 0.5, 0),
                        Size = UDim2New(0, 14, 0, 14),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Visible = false,
                        ZIndex = 42,
                    });

                    Row.Container:OnHover(function()
                        Row.Container:Tween(nil, { BackgroundTransparency = 0.7 });
                    end);

                    Row.Container:OnHoverLeave(function()
                        Row.Container:Tween(nil, { BackgroundTransparency = 1 });
                    end);

                    Row.Container:Connect("MouseButton1Click", function()
                        ToggleProfileRow(Row);
                    end);

                    return Row;
                end;

                CreateProfileRow(1, "Name", "user", Items["Username"], "ProfileHideName");
                CreateProfileRow(2, "Profile", "image", Items["AvatarIcon"], "ProfileHideProfile");

                function Window:SetProfileOpen(Bool)
                    Items["ProfilePopup"].Instance.Visible = Bool;
                    Items["ProfileScreenBackdrop"].Instance.Visible = Bool;
                end;

                -- 在释放时打开，但仅当这次按下不是拖动标题栏。
                local ProfilePressPos;

                Items["ProfileTrigger"]:Connect("MouseButton1Down", function()
                    ProfilePressPos = UserInputService:GetMouseLocation();
                end);

                Items["ProfileTrigger"]:Connect("MouseButton1Click", function()
                    local Pressed = ProfilePressPos;
                    ProfilePressPos = nil;

                    if Pressed and (UserInputService:GetMouseLocation() - Pressed).Magnitude > 4 then
                        return;
                    end;

                    Window:SetProfileOpen(true);
                end);

                Items["ProfileBackdrop"]:Connect("MouseButton1Click", function()
                    Window:SetProfileOpen(false);
                end);

                Items["ProfileScreenBackdrop"]:Connect("MouseButton1Click", function()
                    Window:SetProfileOpen(false);
                end);

				Items["HeaderRight"] = Instances:Create("Frame", {
					Parent = Items["Top"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(1, 0),
					Position = UDim2New(1, -8, 0, 0),
					Size = UDim2New(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
				})

				Instances:Create("UIListLayout", {
					Parent = Items["HeaderRight"].Instance,
					Name = "\0",
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDimNew(0, 12),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["PageInfo"] = Instances:Create("Frame", {
					Parent = Items["HeaderRight"].Instance,
					Name = "\0",
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2New(0, 0, 0, 50),
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["PageInfo"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDimNew(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["PageTitle"] = Instances:Create("TextLabel", {
					Parent = Items["PageInfo"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(200, 200, 200),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["PageTitle"]:AddToTheme({ TextColor3 = "Text" })

				Items["PageDescription"] = Instances:Create("TextLabel", {
					Parent = Items["PageInfo"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.5,
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					TextSize = 12,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["PageDescription"]:AddToTheme({ TextColor3 = "Text" })

				Items["Pages"] = Instances:Create("Frame", {
					Parent = Items["HeaderRight"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 1, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIPadding", {
					Parent = Items["Pages"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 8),
					PaddingBottom = UDimNew(0, 8),
					PaddingRight = UDimNew(0, 8),
					PaddingLeft = UDimNew(0, 8),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Pages"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDimNew(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					ClipsDescendants = true,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 50),
					Size = UDim2New(1, 0, 1, -50),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Page"] = Instances:Create("Frame", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Page"].Instance,
					Name = "\0",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = UDimNew(0, 12),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill,
				})


				if IsMobile then
					Items["FloatingButton"] = Instances:Create("TextButton", {
						Parent = Library.Holder.Instance,
						Text = "",
						AutoButtonColor = false,
						AnchorPoint = Vector2New(0.5, 0),
						Name = "\0",
						Position = UDim2New(0.5, 0, 0, 25),
						BorderColor3 = FromRGB(0, 0, 0),
						Size = UDim2New(0, 50, 0, 50),
						BorderSizePixel = 0,
						ZIndex = 127,
						BackgroundColor3 = Library.Theme.Background,
					})
					Items["FloatingButton"]:AddToTheme({ BackgroundColor3 = "Background" })

					Items["FloatingButton"]:MakeDraggable()

					Items["Textsss"] = Instances:Create("TextLabel", {
						Parent = Items["FloatingButton"].Instance,
						BorderColor3 = FromRGB(0, 0, 0),
						Name = "\0",
						Text = "Close",
						BackgroundTransparency = 1,
						AnchorPoint = Vector2New(0.5, 0.5),
						Position = UDim2New(0.5, 0, 0.5, 0),
						ZIndex = 127,
						Size = UDim2New(1, -10, 1, -10),
						BorderSizePixel = 0,
						TextSize = 14,
						FontFace = Library.Font,
						BackgroundColor3 = FromRGB(255, 255, 255),
					})
					Items["Textsss"]:AddToTheme({ TextColor3 = "Text" })

					Instances:Create("UICorner", {
						Parent = Items["FloatingButton"].Instance,
						Name = "\0",
					})

					Items["FloatingButton"]:Connect("InputBegan", function(Input)
						if
							Input.UserInputType == Enum.UserInputType.MouseButton1
							or Input.UserInputType == Enum.UserInputType.Touch
						then
							Window:SetOpen(not Window.IsOpen)
							Items["Textsss"].Instance.Text = Window.IsOpen and "Close" or "Open"
						end
					end)
				end

				Window.Items = Items
			end

			local Debounce = false

			function Window:SetCenter()
				Items["MainFrame"].Instance.AnchorPoint = Vector2New(0.5, 0.5)
				Items["MainFrame"].Instance.Position = UDim2New(0.5, 0, 0.5, 0)
			end

			function Window:SetOpen(Bool)
				if Debounce then
					return
				end

				Window.IsOpen = Bool
				if Library.HeaderBarInstance then
					pcall(function()
						Library.HeaderBarInstance:Set(1, Bool, false)
					end)
				end

				pcall(function()
					Library:ApplyBackgroundEffects(Bool)
				end)

				Debounce = true

				if Window.IsOpen then
					Items["MainFrame"].Instance.Visible = true
				else
					Window:SetProfileOpen(false)
				end

				local Descendants = Items["MainFrame"].Instance:GetDescendants()
				table.insert(Descendants, Items["MainFrame"].Instance)

				local NewTween

				for Index, Value in Descendants do
					local TransparencyProperty = Tween:GetProperty(Value)

					if not TransparencyProperty then
						continue
					end

					if type(TransparencyProperty) == "table" then
						for _, Property in TransparencyProperty do
							NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
						end
					else
						NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
					end
				end

				NewTween.Tween.Completed:Connect(function()
					Debounce = false
					Items["MainFrame"].Instance.Visible = Window.IsOpen
				end)
			end

			Library:Connect(UserInputService.InputBegan, function(Input)
				if Input.KeyCode == Library.MenuKeybind or Input.UserInputType == Library.MenuKeybind then
					Window:SetOpen(not Window.IsOpen)
				end
			end)

			Window:SetCenter()
			RunService.Heartbeat:Wait()
			Window:SetOpen(true)
			Library.MainWindow = Window
			return setmetatable(Window, Library)
		end

		Library.Page = function(self, Data)
			Data = Data or {}

			local Page = {
				Window = self,

				Icon = Data.Icon or Data.icon or "house",
				Title = Data.Title or Data.title or "Page",
				Description = Data.Description or Data.description or Data.Descs or Data.descs or "",
				Columns = Data.Columns or Data.columns or 2,

				Items = {},
				ColumnsData = {},
				Sections = {},
				Active = false,
			}

			local Items = {}
			do
				Items["Inactive"] = Instances:Create("TextButton", {
					Parent = Page.Window.Items["Pages"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					Size = UDim2New(0, 30, 0, 30),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(13, 15, 18),
				})
				Items["Inactive"]:AddToTheme({ BackgroundColor3 = "Background" })

				Instances:Create("UICorner", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				-- 与标题栏标签相同的生成光晕；选中前隐藏。
				Items["Glow"] = Instances:Create("ImageLabel", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(0.5, 0.5),
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, 36, 0, 36),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = Library.GlowTexture or "",
					ImageColor3 = Library.Theme["Accent"],
					ImageTransparency = 1,
					Visible = false,
					ZIndex = 2,
				})
				Items["Glow"]:AddToTheme({ ImageColor3 = "Accent" })

				Items["Icon"] = Instances:Create("ImageLabel", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					ImageTransparency = 0.5,
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0.5, 0.5),
					Icon = Page.Icon,
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, 16, 0, 16),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Icon"]:AddToTheme({ ImageColor3 = "Text" })

				Items["Inactive"]:OnHover(function()
					if Page.Active then
						return
					end
					Items["Icon"]:Tween(nil, { ImageTransparency = 0 })
				end)

				Items["Inactive"]:OnHoverLeave(function()
					if Page.Active then
						return
					end
					Items["Icon"]:Tween(nil, { ImageTransparency = 0.5 })
				end)

				Items["Page"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Visible = false,
					Position = UDim2New(0, 0, 0, 67), -- 67 哈哈 笑死 真好玩
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Page"].Instance,
					Name = "\0",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = UDimNew(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill,
				})

				Items["LeftColumn"] = Instances:Create("ScrollingFrame", {
					Parent = Items["Page"].Instance,
					Name = "\0",
					ScrollBarImageColor3 = FromRGB(0, 0, 0),
					Active = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 0,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 100, 0, 100),
					BackgroundColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = UDim2New(0, 0, 0, 0),
				})

				Instances:Create("UIPadding", {
					Parent = Items["LeftColumn"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 12),
					PaddingBottom = UDimNew(0, 12),
					PaddingRight = UDimNew(0, 6),
					PaddingLeft = UDimNew(0, 12),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["LeftColumn"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 12),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["RightColumn"] = Instances:Create("ScrollingFrame", {
					Parent = Items["Page"].Instance,
					Name = "\0",
					ScrollBarImageColor3 = FromRGB(0, 0, 0),
					Active = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 0,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 100, 0, 100),
					BackgroundColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = UDim2New(0, 0, 0, 0),
				})

				Instances:Create("UIPadding", {
					Parent = Items["RightColumn"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 12),
					PaddingBottom = UDimNew(0, 12),
					PaddingRight = UDimNew(0, 12),
					PaddingLeft = UDimNew(0, 6),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["RightColumn"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 12),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["Accent"] = Instances:Create("Frame", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 0),
					BorderSizePixel = 0,
					AnchorPoint = Vector2New(0.5, 0.5),
					Position = UDim2New(0.5, 0, 0.5, 0),
					BackgroundColor3 = FromRGB(184, 212, 255),
				})
				Items["Accent"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Instances:Create("UICorner", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Items["Gradient"] = Instances:Create("UIGradient", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					Enabled = false,
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(170, 170, 170)),
					}),
				})

				Page.ColumnsData[1] = Items["LeftColumn"]
				Page.ColumnsData[2] = Items["RightColumn"]

				Page.Items = Items
			end

			local TransitionToken = 0
			local PageTween

			Library.SearchItems[Page] = {}

			local StopPageTween = function()
				if not PageTween then
					return
				end

				pcall(function()
					PageTween.Tween:Cancel()
				end)
				PageTween = nil
			end

			local SectionStep = 0.07
			local RowStep = 0.045

			local PrimeSection = function(Section)
				local Root = Section.Items["Section"].Instance
				Root.Visible = true

				ForEachFadeable(CollectFadeable(Root), function(Child, Property)
					CaptureResting(Child, Property)
					Child[Property] = 1
				end)

				for _, Row in Section.Items["Content"].Instance:GetChildren() do
					if Row:IsA("GuiObject") then
						Row.Visible = false
					end
				end
			end

			local RevealSection = function(Section)
				local Root = Section.Items["Section"].Instance
				ForEachFadeable(CollectFadeable(Root), function(Child, Property)
					local Resting = CaptureResting(Child, Property)
					Tween:Create(Child, nil, { [Property] = Resting }, true)
				end)
			end

			local PlayPageIntro = function(Token)
				for Index, Section in Page.Sections do
					PrimeSection(Section)

					task.delay((Index - 1) * SectionStep, function()
						if not Page.Active or TransitionToken ~= Token then
							return
						end

						RevealSection(Section)

						local RowIndex = 0
						for _, Row in Section.Items["Content"].Instance:GetChildren() do
							if not Row:IsA("GuiObject") then
								continue
							end

							RowIndex += 1
							local CurrentRow = Row
							task.delay(RowIndex * RowStep, function()
								if not Page.Active or TransitionToken ~= Token then
									return
								end

								CurrentRow.Visible = true
								Library.FadeDescendants(CurrentRow, true)
							end)
						end
					end)
				end
			end

			function Page:Turn(Bool)
				TransitionToken += 1
				local Token = TransitionToken
				Page.Active = Bool
				StopPageTween()

				if Page.Active then
					Library.CancelFade(Items["Page"])
					Library.HardRestore(Items["Page"])
					Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
					Items["Page"].Instance.Position = UDim2New(0, 0, 0, 0)
					Items["Page"].Instance.Visible = true

					Items["Icon"]:ChangeItemTheme({ ImageColor3 = "Accent" })
					Items["Accent"]:Tween(
						TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{ Size = UDim2New(0, 0, 0, 0), BackgroundTransparency = 1 }
					)
					Items["Gradient"].Instance.Enabled = false
					Items["Glow"].Instance.Visible = true
					Items["Glow"]:Tween(nil, { ImageTransparency = 0.35, ImageColor3 = Library.Theme.Accent })
					Items["Icon"]:Tween(nil, { ImageColor3 = Library.Theme.Accent, ImageTransparency = 0 })

					Library.CurrentPage = Page
					Page.Window.Items["PageTitle"].Instance.Text = Page.Title
					Page.Window.Items["PageDescription"].Instance.Text = Page.Description

					PlayPageIntro(Token)
					return
				end

				Items["Icon"]:ChangeItemTheme({ ImageColor3 = "Text" })
				Items["Accent"]:Tween(
					TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Size = UDim2New(0, 0, 0, 0), BackgroundTransparency = 1 }
				)
				Items["Gradient"].Instance.Enabled = false
				local GlowTween = TweenService:Create(
					Items["Glow"].Instance,
					TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction),
					{ ImageTransparency = 1 }
				)
				GlowTween:Play()
				Library:Connect(GlowTween.Completed, function()
					if not Page.Active then
						Items["Glow"].Instance.Visible = false
					end
				end)
				Items["Icon"]:Tween(nil, { ImageColor3 = Library.Theme.Text, ImageTransparency = 0.5 })
				PageTween = Items["Page"]:Tween(
					TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Position = UDim2New(0, -22, 0, 0) }
				)

				Library.FadeDescendants(Items["Page"], false, function()
					if Page.Active or TransitionToken ~= Token then
						return
					end

					StopPageTween()
					Library.HardRestore(Items["Page"])
					Items["Page"].Instance.Position = UDim2New(0, 0, 0, 0)
					Items["Page"].Instance.Visible = false
					Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
				end)
			end

			local PageSearchData = Library.SearchItems[Page]

			function Page:InsertElement(Name, Element)
				local SearchData = {
					Element = Element,
					Name = Name,
				}

				table.insert(PageSearchData, SearchData)
			end

			Items["Inactive"]:Connect("MouseButton1Down", function()
				for Index, Value in Page.Window.Pages do
					if Value == Page and Page.Active then
						return
					end

					Value:Turn(Value == Page)
				end
			end)

			table.insert(Page.Window.Pages, Page)

			if #Page.Window.Pages == 1 then
				task.defer(function()
					Page:Turn(true)
				end)
			end

			return setmetatable(Page, Library.Pages)
		end

		Library.Pages.Section = function(self, Data)
			Data = Data or {}

			local Section = {
				Window = self.Window,
				Page = self,

				Name = Data.Name or Data.name or "Section",
				Icon = Data.Icon or Data.icon or "house",
				Side = Data.Side or Data.side or 1,

				Items = {},
			}

			local Items = {}
			do
				Items["Section"] = Instances:Create("Frame", {
					Parent = Section.Page.ColumnsData[Section.Side].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 0, 45),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = FromRGB(22, 25, 30),
				})
				Items["Section"]:AddToTheme({ BackgroundColor3 = "Inline" })

				Instances:Create("UICorner", {
					Parent = Items["Section"].Instance,
					Name = "\0",
				})

				Instances:Create("UIStroke", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					Color = FromRGB(26, 30, 36),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Outline" })

				Items["IconBackground"] = Instances:Create("TextButton", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 8),
					Size = UDim2New(0, 25, 0, 25),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(184, 212, 255),
				})

				Instances:Create("UICorner", {
					Parent = Items["IconBackground"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Items["Icon"] = Instances:Create("ImageLabel", {
					Parent = Items["IconBackground"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(200, 200, 200),
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0.5, 0.5),
					Icon = Section.Icon,
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, 16, 0, 16),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Icon"]:AddToTheme({ ImageColor3 = "Text" })

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(200, 200, 200),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Section.Name,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 38, 0, 12),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Text" })

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 10, 0, 40),
					Size = UDim2New(1, -20, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Instances:Create("UIPadding", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					PaddingBottom = UDimNew(0, 10),
				})

				Section.Items = Items
			end

			table.insert(Section.Page.Sections, Section)
			return setmetatable(Section, Library.Sections)
		end

		Library.Sections.Toggle = function(self, Data)
			Data = Data or {}

			local Toggle = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Toggle",
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or false,
				Callback = Data.Callback or Data.callback or function() end,

				Value = false,
			}

			local Items = {}
			do
				Items["Toggle"] = Instances:Create("TextButton", {
					Parent = Toggle.Section.Items["Content"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, 20),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Indicator"] = Instances:Create("Frame", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 20, 0, 20),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(28, 32, 38),
				})
				Items["Indicator"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UICorner", {
					Parent = Items["Indicator"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Items["Accent"] = Instances:Create("Frame", {
					Parent = Items["Indicator"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2New(0.5, 0.5),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(184, 212, 255),
				})
				Items["Accent"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Instances:Create("UICorner", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(209, 209, 209)),
					}),
				})

				Items["CheckImage"] = Instances:Create("ImageLabel", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(0, 0, 0),
					ImageTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0.5, 0.5),
					Icon = "check",
					Colors = { FromRGB(0, 0, 0) },
					BackgroundTransparency = 1,
					Rotation = 85,
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, 14, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Toggle.Name,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 28, 0, 2),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["SubElements"] = Instances:Create("Frame", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(1, 0, 0, 0),
					Size = UDim2New(0, 0, 1, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["SubElements"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDimNew(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["Toggle"]:OnHover(function()
					if Toggle.Value then
						return
					end
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme.Text })
				end)

				Items["Toggle"]:OnHoverLeave(function()
					if Toggle.Value then
						return
					end
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Dark Text" })
					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
				end)
			end

			function Toggle:Get()
				return Toggle.Value
			end

			function Toggle:Set(Value)
				Toggle.Value = Value
				Library.Flags[Toggle.Flag] = Value

				local Transparency = Toggle.Value and 0 or 1
				Library:SetBaseline(Items["Accent"].Instance, "BackgroundTransparency", Transparency)
				Library:SetBaseline(Items["CheckImage"].Instance, "ImageTransparency", Transparency)

				if Toggle.Value then
					Items["Accent"]:Tween(
						TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 0, Size = UDim2New(1, 0, 1, 0) }
					)
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme.Text })
					Items["CheckImage"]:Tween(nil, { Rotation = 0, ImageTransparency = 0 })
				else
					Items["Accent"]:Tween(
						TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{ BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0) }
					)
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Dark Text" })
					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
					Items["CheckImage"]:Tween(nil, { Rotation = 85, ImageTransparency = 1 })
				end

				if Toggle.Callback then
					Library:SafeCall(Toggle.Callback, Toggle.Value)
				end
			end

			function Toggle:SetVisibility(Bool)
				Items["Toggle"].Instance.Visible = Bool
			end

			function Toggle:Colorpicker(Data)
				Data = Data or {}

				local Colorpicker = {
					Window = Toggle.Window,
					Page = Toggle.Page,
					Section = Toggle.Section,

					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
					Callback = Data.Callback or Data.callback or function() end,
					Alpha = Data.Alpha or Data.alpha or false,
				}

				local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
					Parent = Items["SubElements"],
					Page = Colorpicker.Page,
					Section = Colorpicker.Section,
					Flag = Colorpicker.Flag,
					Default = Colorpicker.Default,
					Callback = Colorpicker.Callback,
					Alpha = Colorpicker.Alpha,
				})

				return NewColorpicker
			end

			function Toggle:Keybind(Data)
				Data = Data or {}

				local Keybind = {
					Window = Toggle.Window,
					Page = Toggle.Page,
					Section = Toggle.Section,

					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Name = Data.Name or Data.name or Toggle.Name,
					Default = Data.Default or Data.default or Enum.KeyCode.E,
					Callback = Data.Callback or Data.callback or function() end,
					Mode = Data.Mode or Data.mode or "Toggle",
					ShowInHotkeys = Data.ShowInHotkeys ~= false and Data.showInHotkeys ~= false,
				}

				local NewKeybind, KeybindItems = Library:CreateKeybind({
					Parent = Items["SubElements"],
					Page = Keybind.Page,
					Section = Keybind.Section,
					Flag = Keybind.Flag,
					Name = Keybind.Name,
					Default = Keybind.Default,
					Mode = Keybind.Mode,
					ShowInHotkeys = Keybind.ShowInHotkeys,
					Callback = Keybind.Callback,
				})

				return NewKeybind
			end

			local PageSearchData = Library.SearchItems[Toggle.Page]

			if PageSearchData then
				local SearchData = {
					Element = Items["Toggle"],
					Name = Toggle.Name,
				}

				table.insert(PageSearchData, SearchData)
			end

			-- 下拉菜单的背景层会吸收打向此按钮的按压；InputBegan 会忽略这一点。
			Items["Toggle"]:Connect("MouseButton1Down", function()
				Toggle:Set(not Toggle.Value)
			end)

			Toggle:Set(Toggle.Default)

			Library.SetFlags[Toggle.Flag] = function(Value)
				Toggle:Set(Value)
			end

			return Toggle
		end

		Library.Sections.Button = function(self, Data)
			Data = Data or {}

			local Button = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Button",
				Callback = Data.Callback or Data.callback or function() end,
			}

			local Items = {}
			do
				Items["Button"] = Instances:Create("TextButton", {
					Parent = Button.Section.Items["Content"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					Size = UDim2New(1, 0, 0, 22),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(28, 32, 38),
				})
				Items["Button"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UICorner", {
					Parent = Items["Button"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Button"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Button.Name,
					ZIndex = 2,
					AnchorPoint = Vector2New(0.5, 0.5),
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["Accent"] = Instances:Create("Frame", {
					Parent = Items["Button"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2New(0.5, 0.5),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(184, 212, 255),
				})
				Items["Accent"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Instances:Create("UICorner", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(209, 209, 209)),
					}),
				})

				Items["Button"]:OnHover(function()
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme.Text })
				end)

				Items["Button"]:OnHoverLeave(function()
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Dark Text" })
					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
				end)
			end

			function Button:SetVisibility(Bool)
				Items["Button"].Instance.Visible = Bool
			end

			function Button:Press()
				Items["Text"]:ChangeItemTheme({
					TextColor3 = function()
						return FromRGB(0, 0, 0)
					end,
				})
				Items["Text"]:Tween(nil, { TextColor3 = FromRGB(0, 0, 0) })
				Items["Accent"]:Tween(nil, { BackgroundTransparency = 0, Size = UDim2New(1, 0, 1, 0) })
				task.wait(0.2)
				Library:SafeCall(Button.Callback)
				Items["Text"]:ChangeItemTheme({ TextColor3 = "Dark Text" })
				Items["Text"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
				Items["Accent"]:Tween(nil, { BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0) })
			end

			local PageSearchData = Library.SearchItems[Button.Page]

			if PageSearchData then
				local SearchData = {
					Element = Items["Button"],
					Name = Button.Name,
				}

				table.insert(PageSearchData, SearchData)
			end

			Items["Button"]:Connect("MouseButton1Down", function()
				Button:Press()
			end)

			return Button
		end

		Library.Sections.Slider = function(self, Data)
			Data = Data or {}

			local Slider = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Slider",
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Min = Data.Min or Data.min or 0,
				Default = Data.Default or Data.default or 0,
				Max = Data.Max or Data.max or 100,
				Suffix = Data.Suffix or Data.suffix or "",
				Decimals = Data.Decimals or Data.decimals or 1,
				Callback = Data.Callback or Data.callback or function() end,
				ReleasedCallback = Data.ReleasedCallback or Data.releasedCallback,

				Value = 0,
				Sliding = false,
			}

			local Items = {}
			do
				Items["Slider"] = Instances:Create("Frame", {
					Parent = Slider.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 36),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Slider.Name,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["RealSlider"] = Instances:Create("TextButton", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 0, 1, 0),
					Size = UDim2New(1, 0, 0, 10),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(28, 32, 38),
				})
				Items["RealSlider"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UICorner", {
					Parent = Items["RealSlider"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0),
				})

				Items["Accent"] = Instances:Create("Frame", {
					Parent = Items["RealSlider"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0.6000000238418579, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(184, 212, 255),
				})
				Items["Accent"]:AddToTheme({ BackgroundColor3 = "Accent" })

				Instances:Create("UICorner", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0),
				})

				Items["Dragger"] = Instances:Create("Frame", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(1, 0.5),
					Position = UDim2New(1, 0, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 10, 0, 10),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UICorner", {
					Parent = Items["Dragger"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Dragger"].Instance,
					Name = "\0",
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(170, 170, 170)),
					}),
				})

				Instances:Create("UIGradient", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					Color = RGBSequence({
						RGBSequenceKeypoint(0, FromRGB(255, 255, 255)),
						RGBSequenceKeypoint(1, FromRGB(170, 170, 170)),
					}),
				})

				Items["Value"] = Instances:Create("TextLabel", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "60%",
					AnchorPoint = Vector2New(1, 0),
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Value"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["RealSlider"]:OnHover(function()
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
					Items["Value"]:ChangeItemTheme({ TextColor3 = "Text" })

					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme.Text })
					Items["Value"]:Tween(nil, { TextColor3 = Library.Theme.Text })
				end)

				Items["RealSlider"]:OnHoverLeave(function()
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Dark Text" })
					Items["Value"]:ChangeItemTheme({ TextColor3 = "Dark Text" })

					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
					Items["Value"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
				end)
			end

			function Slider:Get()
				return Slider.Value
			end

			function Slider:SetVisibility(Bool)
				Items["Slider"].Instance.Visible = Bool
			end

			function Slider:Set(Value)
				Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
				Library.Flags[Slider.Flag] = Slider.Value

				Items["Accent"]:Tween(
					TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0) }
				)
				Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

				if Slider.Value <= Slider.Min then
					Items["Dragger"].Instance.Position = UDim2New(1, 10, 0.5, 0)
				else
					Items["Dragger"].Instance.Position = UDim2New(1, 0, 0.5, 0)
				end

				if Slider.Callback then
					Library:SafeCall(Slider.Callback, Slider.Value)
				end
			end

			local PageSearchData = Library.SearchItems[Slider.Page]

			if PageSearchData then
				local SearchData = {
					Element = Items["Slider"],
					Name = Slider.Name,
				}

				table.insert(PageSearchData, SearchData)
			end

			-- 按下开始拖动；释放从 InputEnded 读取，所以拖动
			-- 在光标离开进度条后仍然会结束。
			Library:Connect(Items["RealSlider"].Instance.MouseButton1Down, function()
				Slider.Sliding = true

				local SizeX = (UserInputService:GetMouseLocation().X - Items["RealSlider"].Instance.AbsolutePosition.X)
					/ Items["RealSlider"].Instance.AbsoluteSize.X
				local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

				Slider:Set(Value)
			end)

			Library:Connect(UserInputService.InputEnded, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					if Slider.Sliding then
						Slider.Sliding = false

						if Slider.ReleasedCallback then
							Library:SafeCall(Slider.ReleasedCallback, Slider.Value)
						end
					end
				end
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseMovement
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					if Slider.Sliding then
						local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X)
							/ Items["RealSlider"].Instance.AbsoluteSize.X
						local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

						Slider:Set(Value)
					end
				end
			end)

			if Slider.Default then
				Slider:Set(Slider.Default)
			end

			Library.SetFlags[Slider.Flag] = function(Value)
				Slider:Set(Value)

				if Slider.ReleasedCallback then
					Library:SafeCall(Slider.ReleasedCallback, Slider.Value)
				end
			end

			return Slider
		end

		Library.Sections.Label = function(self, Name)
			local Label = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Name or "Label",
			}

			local Items = {}
			do
				Items["Label"] = Instances:Create("Frame", {
					Parent = Label.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 16),
					AutomaticSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Label"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Label.Name,
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, 15),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["SubElements"] = Instances:Create("Frame", {
					Parent = Items["Label"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(1, 0, 0, 0),
					Size = UDim2New(0, 0, 0, 16),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Instances:Create("UIListLayout", {
					Parent = Items["SubElements"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDimNew(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Items["Label"]:OnHover(function()
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme.Text })
				end)

				Items["Label"]:OnHoverLeave(function()
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Dark Text" })
					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
				end)
			end

			function Label:SetText(Text)
				Text = tostring(Text)
				Items["Text"].Instance.Text = Text
			end

			function Label:SetVisibility(Bool)
				Items["Label"].Instance.Visible = Bool
			end

			function Label:Colorpicker(Data)
				Data = Data or {}

				local Colorpicker = {
					Window = Label.Window,
					Page = Label.Page,
					Section = Label.Section,

					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
					Callback = Data.Callback or Data.callback or function() end,
					Alpha = Data.Alpha or Data.alpha or false,
				}

				local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
					Parent = Items["SubElements"],
					Page = Colorpicker.Page,
					Section = Colorpicker.Section,
					Flag = Colorpicker.Flag,
					Default = Colorpicker.Default,
					Callback = Colorpicker.Callback,
					Alpha = Colorpicker.Alpha,
				})

				return NewColorpicker
			end

			function Label:Keybind(Data)
				Data = Data or {}

				local Keybind = {
					Window = Label.Window,
					Page = Label.Page,
					Section = Label.Section,

					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Name = Data.Name or Data.name or Label.Name,
					Default = Data.Default or Data.default or Enum.KeyCode.E,
					Callback = Data.Callback or Data.callback or function() end,
					Mode = Data.Mode or Data.mode or "Toggle",
					ShowInHotkeys = Data.ShowInHotkeys ~= false and Data.showInHotkeys ~= false,
				}

				local NewKeybind, KeybindItems = Library:CreateKeybind({
					Parent = Items["SubElements"],
					Page = Keybind.Page,
					Section = Keybind.Section,
					Flag = Keybind.Flag,
					Name = Keybind.Name,
					Default = Keybind.Default,
					Mode = Keybind.Mode,
					ShowInHotkeys = Keybind.ShowInHotkeys,
					Callback = Keybind.Callback,
				})

				return NewKeybind
			end

			local PageSearchData = Library.SearchItems[Label.Page]

			if PageSearchData then
				local SearchData = {
					Element = Items["Label"],
					Name = Label.Name,
				}

				table.insert(PageSearchData, SearchData)
			end

			return Label
		end

		Library.Sections.Textbox = function(self, Data)
			Data = Data or {}

			local Textbox = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Textbox",
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or "",
				Callback = Data.Callback or Data.callback or function() end,
				Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
				Numeric = Data.Numeric or Data.numeric or false,
				Finished = Data.Finished or Data.finished or false,

				Value = "",
			}

			local Items = {}
			do
				Items["Textbox"] = Instances:Create("Frame", {
					Parent = Textbox.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 24),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Background"] = Instances:Create("Frame", {
					Parent = Items["Textbox"].Instance,
					Name = "\0",
					ClipsDescendants = true,
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 1),
					Size = UDim2New(1, 0, 0, 24),
					Position = UDim2New(0, 0, 1, 0),
					Selectable = true,
					Active = true,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(28, 32, 38),
				})
				Items["Background"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UICorner", {
					Parent = Items["Background"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				Items["Input"] = Instances:Create("TextBox", {
					Parent = Items["Background"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					Active = false,
					Selectable = false,
					AnchorPoint = Vector2New(0, 0.5),
					TextTruncate = Enum.TextTruncate.AtEnd,
					PlaceholderText = Textbox.Placeholder,
					TextSize = 14,
					Size = UDim2New(1, -20, 0, 15),
					TextColor3 = FromRGB(200, 200, 200),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					Position = UDim2New(0, 10, 0.5, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					CursorPosition = -1,
					BorderSizePixel = 0,
					PlaceholderColor3 = FromRGB(100, 100, 100),
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Input"]:AddToTheme({ TextColor3 = "Text", PlaceholderColor3 = "Dark Text" })
			end

			function Textbox:Get()
				return Textbox.Value
			end

			function Textbox:SetVisibility(Bool)
				Items["Textbox"].Instance.Visible = Bool
			end

			function Textbox:Set(Value)
				if Textbox.Numeric then
					if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
						Value = Textbox.Value
					end
				end

				Textbox.Value = Value
				Items["Input"].Instance.Text = Value
				Library.Flags[Textbox.Flag] = Value

				if Textbox.Callback then
					Library:SafeCall(Textbox.Callback, Value)
				end
			end

			local PageSearchData = Library.SearchItems[Textbox.Page]

			if PageSearchData then
				local SearchData = {
					Element = Items["Textbox"],
					Name = Textbox.Name,
				}

				table.insert(PageSearchData, SearchData)
			end

			if Textbox.Finished then
				Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
					if PressedEnterQuestionMark then
						Textbox:Set(Items["Input"].Instance.Text)
					end
				end)
			else
				Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
					Textbox:Set(Items["Input"].Instance.Text)
				end)
			end

			if Textbox.Default then
				Textbox:Set(Textbox.Default)
			end

			Library.SetFlags[Textbox.Flag] = function(Value)
				Textbox:Set(Value)
			end

			return Textbox
		end

		Library.Sections.Dropdown = function(self, Data)
			Data = Data or {}

			-- 每一行都可以有自己的上限和起始值；Max/DefaultValue
			-- 作为每一行的后备值。
			local MaxItems = Data.MaxItems or Data.maxItems or {}
			local RowDefaults = Data.RowDefaults or Data.rowDefaults or {}

			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Dropdown",
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Items = Data.Items or Data.items or { "One", "Two", "Three" },
				Default = Data.Default or Data.default or nil,
				Callback = Data.Callback or Data.callback or function() end,
				Multi = Data.Multi or Data.multi or false,

				-- Slider = true 会为每一行提供数值滑块和可输入的值。
				-- 没有它，一行就只是一个勾选框。
				Slider = Data.Slider == true or Data.slider == true,
				Min = Data.Min or Data.min or 1,
				Max = Data.Max or Data.max or 100,
				DefaultValue = Data.DefaultValue or Data.defaultValue or 1,
				MaxItems = MaxItems,
				RowDefaults = RowDefaults,

				-- 单选保存所选名称；多选保存 名称 -> 条目 的映射。
				Value = nil,
				SelectedItems = {},
				IsOpen = false,
			}

			local Items = {}
			do
				Items["Dropdown"] = Instances:Create("Frame", {
					Parent = Dropdown.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 48),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Dropdown"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Dropdown.Name,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Text"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["RealDropdown"] = Instances:Create("TextButton", {
					Parent = Items["Dropdown"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 0, 1, 0),
					Size = UDim2New(1, 0, 0, 24),
					BorderSizePixel = 0,
					TextSize = 14,
					BackgroundColor3 = FromRGB(28, 32, 38),
				})
				Items["RealDropdown"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UICorner", {
					Parent = Items["RealDropdown"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5),
				})

				Items["Value"] = Instances:Create("TextLabel", {
					Parent = Items["RealDropdown"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(100, 100, 100),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "...",
					Size = UDim2New(1, -35, 0, 15),
					AnchorPoint = Vector2New(0, 0.5),
					Position = UDim2New(0, 10, 0.5, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Value"]:AddToTheme({ TextColor3 = "Dark Text" })

				Items["Icon"] = Instances:Create("ImageLabel", {
					Parent = Items["RealDropdown"].Instance,
					Name = "\0",
					ImageTransparency = 0.5,
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0.5),
					Icon = "chevron-down",
					BackgroundTransparency = 1,
					Position = UDim2New(1, -4, 0.5, 0),
					Size = UDim2New(0, 16, 0, 16),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
				})
				Items["Icon"]:AddToTheme({ ImageColor3 = "Text" })

				Items["RealDropdown"]:OnHover(function()
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
					Items["Value"]:ChangeItemTheme({ TextColor3 = "Text" })

					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme.Text })
					Items["Value"]:Tween(nil, { TextColor3 = Library.Theme.Text })
				end)

				Items["RealDropdown"]:OnHoverLeave(function()
					Items["Text"]:ChangeItemTheme({ TextColor3 = "Dark Text" })
					Items["Value"]:ChangeItemTheme({ TextColor3 = "Dark Text" })

					Items["Text"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
					Items["Value"]:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
				end)

				-- 面板铺满整个主窗口，所以永远不需要
				-- 相对触发器定位，也不需要叠加在其他窗口之上。
				Items["DropdownWindow"] = Instances:Create("Frame", {
					Parent = Dropdown.Window.Items["MainFrame"].Instance,
					Name = "\0",
					Visible = false,
					Position = UDim2New(0, 0, 0, 0),
					Size = UDim2New(1, 0, 1, 0),
					BackgroundColor3 = FromRGB(10, 10, 10),
					BorderSizePixel = 0,
					ClipsDescendants = true,
				})
				Items["DropdownWindow"]:AddToTheme({ BackgroundColor3 = "Background" })

				-- GuiButton 会吸收按压，所以面板后面的控件永远收不到它。
				-- 它最先创建，因此面板的每个元素都位于它之上。
				Items["Backdrop"] = Instances:Create("TextButton", {
					Parent = Items["DropdownWindow"].Instance,
					Name = "\0",
					Text = "",
					AutoButtonColor = false,
					Active = true,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2New(1, 0, 1, 0),
				})

				Instances:Create("UICorner", {
					Parent = Items["DropdownWindow"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Instances:Create("UIStroke", {
					Parent = Items["DropdownWindow"].Instance,
					Name = "\0",
					Color = FromRGB(30, 30, 30),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}):AddToTheme({ Color = "Outline" })

				Items["TitleBar"] = Instances:Create("Frame", {
					Parent = Items["DropdownWindow"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 0, 46),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
				})

				Items["TitleText"] = Instances:Create("TextLabel", {
					Parent = Items["TitleBar"].Instance,
					Name = "\0",
					Position = UDim2New(0, 16, 0, 8),
					Size = UDim2New(1, -120, 0, 16),
					FontFace = Library.BoldFont,
					Text = Dropdown.Name,
					TextColor3 = FromRGB(225, 225, 225),
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
				})
				Items["TitleText"]:AddToTheme({ TextColor3 = "Text" })

				if Data.Description or Data.description then
					Items["DescriptionText"] = Instances:Create("TextLabel", {
						Parent = Items["TitleBar"].Instance,
						Name = "\0",
						Position = UDim2New(0, 16, 0, 25),
						Size = UDim2New(1, -120, 0, 14),
						FontFace = Library.Font,
						Text = Data.Description or Data.description,
						TextColor3 = FromRGB(125, 125, 125),
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundTransparency = 1,
					})
					Items["DescriptionText"]:AddToTheme({ TextColor3 = "Dark Text" })
				end

				Items["ReturnButton"] = Instances:Create("TextButton", {
					Parent = Items["TitleBar"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(1, 0.5),
					Position = UDim2New(1, -16, 0.5, 0),
					Size = UDim2New(0, 62, 0, 22),
					FontFace = Library.Font,
					Text = "RETURN",
					TextColor3 = FromRGB(225, 225, 225),
					TextSize = 11,
					BackgroundColor3 = FromRGB(38, 38, 38),
					AutoButtonColor = false,
				})
				Items["ReturnButton"]:AddToTheme({
					BackgroundColor3 = "Element",
					TextColor3 = "Text",
				})

				Instances:Create("UICorner", {
					Parent = Items["ReturnButton"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 4),
				})

				-- ScrollBarThickness = 0：可见的滚动条会在
				-- 框内占用宽度，把右边距撑得比左边宽。
				Items["ScrollingFrame"] = Instances:Create("ScrollingFrame", {
					Parent = Items["DropdownWindow"].Instance,
					Name = "\0",
					Position = UDim2New(0, 0, 0, 46),
					Size = UDim2New(1, 0, 1, -46),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 0,
					ScrollBarImageColor3 = FromRGB(125, 125, 125),
					CanvasSize = UDim2New(0, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
				})

				Instances:Create("UIListLayout", {
					Parent = Items["ScrollingFrame"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 2),
					SortOrder = Enum.SortOrder.LayoutOrder,
				})

				Instances:Create("UIPadding", {
					Parent = Items["ScrollingFrame"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 4),
					PaddingBottom = UDimNew(0, 4),
					PaddingLeft = UDimNew(0, 16),
					PaddingRight = UDimNew(0, 16),
				})
			end

			local Rows = {}

			local function RefreshRowText(Row, Enabled)
				if Enabled then
					Row.NameLabel:ChangeItemTheme({ TextColor3 = "Text" })
					Row.NameLabel:Tween(nil, { TextColor3 = Library.Theme.Text })
				else
					Row.NameLabel:ChangeItemTheme({ TextColor3 = "Dark Text" })
					Row.NameLabel:Tween(nil, { TextColor3 = Library.Theme["Dark Text"] })
				end
			end

			local function CreateRow(ItemName, Index)
				local Row = {}

				local RowMax = tonumber(MaxItems[ItemName]) or Dropdown.Max
				local RowDefault = tonumber(RowDefaults[ItemName]) or Dropdown.DefaultValue

				local ItemData = {
					Name = ItemName,
					Enabled = false,
					Value = math.clamp(RowDefault, Dropdown.Min, RowMax),
					Min = Dropdown.Min,
					Max = RowMax,
				}

				Row.ItemData = ItemData

				Row["Container"] = Instances:Create("TextButton", {
					Parent = Items["ScrollingFrame"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 0, 36),
					BackgroundColor3 = FromRGB(22, 22, 22),
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					LayoutOrder = Index,
				})
				Row["Container"]:AddToTheme({ BackgroundColor3 = "Inline" })

				Instances:Create("UICorner", {
					Parent = Row["Container"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 6),
				})

				Row["Checkbox"] = Instances:Create("TextButton", {
					Parent = Row["Container"].Instance,
					Name = "\0",
					AnchorPoint = Vector2New(1, 0.5),
					Position = UDim2New(1, -10, 0.5, 0),
					Size = UDim2New(0, 18, 0, 18),
					BackgroundColor3 = FromRGB(38, 38, 38),
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
				})
				Row["Checkbox"]:AddToTheme({ BackgroundColor3 = "Element" })

				Instances:Create("UICorner", {
					Parent = Row["Checkbox"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 4),
				})

				Instances:Create("UIStroke", {
					Parent = Row["Checkbox"].Instance,
					Name = "\0",
					Color = FromRGB(50, 50, 50),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Thickness = 1,
				}):AddToTheme({ Color = "Outline" })

				Row["Checkmark"] = Instances:Create("ImageLabel", {
					Parent = Row["Checkbox"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0.5, 0.5),
					Icon = "check",
					Colors = { FromRGB(0, 0, 0) },
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, 14, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255),
					Visible = false,
				})

				Row["NameLabel"] = Instances:Create("TextLabel", {
					Parent = Row["Container"].Instance,
					Name = "\0",
					Position = UDim2New(0, 10, 0, 0),
					Size = Dropdown.Slider and UDim2New(0.45, -10, 1, 0) or UDim2New(1, -48, 1, 0),
					FontFace = Library.Font,
					Text = ItemName,
					TextColor3 = FromRGB(225, 225, 225),
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					BackgroundTransparency = 1,
				})
				Row["NameLabel"]:AddToTheme({ TextColor3 = "Text" })
				RefreshRowText(Row, false)

				if Dropdown.Slider then
					Row["SliderBg"] = Instances:Create("Frame", {
						Parent = Row["Container"].Instance,
						Name = "\0",
						AnchorPoint = Vector2New(1, 0.5),
						Position = UDim2New(1, -42, 0.5, 0),
						Size = UDim2New(0, 96, 0, 6),
						BackgroundColor3 = FromRGB(48, 48, 48),
						BorderSizePixel = 0,
					})
					Row["SliderBg"]:AddToTheme({ BackgroundColor3 = "Element" })

					Instances:Create("UICorner", {
						Parent = Row["SliderBg"].Instance,
						Name = "\0",
						CornerRadius = UDimNew(1, 0),
					})

					Row["SliderFill"] = Instances:Create("Frame", {
						Parent = Row["SliderBg"].Instance,
						Name = "\0",
						Size = UDim2New(0, 0, 1, 0),
						BackgroundColor3 = FromRGB(255, 255, 255),
						BorderSizePixel = 0,
					})
					Row["SliderFill"]:AddToTheme({ BackgroundColor3 = "Accent" })

					Instances:Create("UICorner", {
						Parent = Row["SliderFill"].Instance,
						Name = "\0",
						CornerRadius = UDimNew(1, 0),
					})

					Row["SliderKnob"] = Instances:Create("Frame", {
						Parent = Row["SliderBg"].Instance,
						Name = "\0",
						AnchorPoint = Vector2New(0.5, 0.5),
						Position = UDim2New(0, 0, 0.5, 0),
						Size = UDim2New(0, 6, 0, 12),
						BackgroundColor3 = FromRGB(255, 255, 255),
						BorderSizePixel = 0,
						ZIndex = 2,
					})

					Instances:Create("UICorner", {
						Parent = Row["SliderKnob"].Instance,
						Name = "\0",
						CornerRadius = UDimNew(0, 2),
					})

					-- 比轨道更高，便于抓取拖动。
					Row["SliderHitbox"] = Instances:Create("TextButton", {
						Parent = Row["Container"].Instance,
						Name = "\0",
						AnchorPoint = Vector2New(1, 0.5),
						Position = UDim2New(1, -42, 0.5, 0),
						Size = UDim2New(0, 96, 0, 22),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						BorderSizePixel = 0,
						ZIndex = 3,
					})

					Row["ValueLabel"] = Instances:Create("TextBox", {
						Parent = Row["Container"].Instance,
						Name = "\0",
						AnchorPoint = Vector2New(1, 0.5),
						Position = UDim2New(1, -146, 0.5, 0),
						Size = UDim2New(0, 34, 1, 0),
						FontFace = Library.Font,
						Text = tostring(ItemData.Value),
						TextColor3 = FromRGB(225, 225, 225),
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Right,
						BackgroundTransparency = 1,
						ClearTextOnFocus = false,
					})
					Row["ValueLabel"]:AddToTheme({ TextColor3 = "Text" })

					local InitialPercentage = (ItemData.Value - ItemData.Min) / (ItemData.Max - ItemData.Min)
					Row["SliderFill"].Instance.Size = UDim2New(InitialPercentage, 0, 1, 0)
					Row["SliderKnob"].Instance.Position = UDim2New(InitialPercentage, 0, 0.5, 0)

					local function ApplyValue(NewValue)
						NewValue = math.clamp(math.floor(NewValue), ItemData.Min, ItemData.Max)
						ItemData.Value = NewValue

						local Percentage = (NewValue - ItemData.Min) / (ItemData.Max - ItemData.Min)

						Row["SliderFill"]:Tween(nil, { Size = UDim2New(Percentage, 0, 1, 0) })
						Row["SliderKnob"].Instance.Position = UDim2New(Percentage, 0, 0.5, 0)
						Row["ValueLabel"].Instance.Text = tostring(NewValue)

						if ItemData.Enabled then
							Dropdown.SelectedItems[ItemName].Value = NewValue
							Dropdown:Report()
						end
					end

					local Sliding = false
					local SliderChanged

					local function UpdateSlider(Input)
						if not Input then
							return
						end

						local SliderPos = Row["SliderBg"].Instance.AbsolutePosition.X
						local SliderSize = Row["SliderBg"].Instance.AbsoluteSize.X

						local Percentage = math.clamp((Input.Position.X - SliderPos) / SliderSize, 0, 1)
						ApplyValue(ItemData.Min + (ItemData.Max - ItemData.Min) * Percentage)
					end

					Row["SliderHitbox"]:Connect("InputBegan", function(Input)
						if
							Input.UserInputType == Enum.UserInputType.MouseButton1
							or Input.UserInputType == Enum.UserInputType.Touch
						then
							Sliding = true
							UpdateSlider(Input)

							if SliderChanged then
								return
							end

							SliderChanged = Input.Changed:Connect(function()
								if Input.UserInputState == Enum.UserInputState.End then
									Sliding = false
									SliderChanged:Disconnect()
									SliderChanged = nil
								end
							end)
						end
					end)

					Library:Connect(UserInputService.InputChanged, function(Input)
						if
							(
								Input.UserInputType == Enum.UserInputType.MouseMovement
								or Input.UserInputType == Enum.UserInputType.Touch
							) and Sliding
						then
							UpdateSlider(Input)
						end
					end)

					Row["ValueLabel"]:Connect("FocusLost", function()
						local Typed = tonumber(Row["ValueLabel"].Instance.Text)

						if Typed then
							ApplyValue(Typed)
						end

						Row["ValueLabel"].Instance.Text = tostring(ItemData.Value)
					end)
				end

				local function ToggleSelection()
					ItemData.Enabled = not ItemData.Enabled
					Row["Checkmark"].Instance.Visible = ItemData.Enabled
					RefreshRowText(Row, ItemData.Enabled)

					Row["Checkbox"]:Tween(nil, {
						BackgroundColor3 = ItemData.Enabled and Library.Theme.Accent or Library.Theme.Element,
					})

					if Dropdown.Multi then
						Dropdown.SelectedItems[ItemName] = ItemData.Enabled and {
							Enabled = true,
							Value = ItemData.Value,
						} or nil
						Dropdown:Report()
					else
						-- 单选仍然使用勾选行，但同一时间只能有一个。
						for _, Other in Rows do
							local OtherData = Other.ItemData
							if OtherData ~= ItemData and OtherData.Enabled then
								OtherData.Enabled = false
								Other.Checkmark.Instance.Visible = false
								Other.Checkbox.Instance.BackgroundColor3 = Library.Theme.Element
								RefreshRowText(Other, false)
							end
						end

						Dropdown.Value = ItemData.Enabled and ItemName or nil
						Dropdown:Report()
					end
				end

				Row["Checkbox"]:Connect("MouseButton1Click", ToggleSelection)
				Row["Container"]:Connect("MouseButton1Click", ToggleSelection)

				return Row
			end

			-- 把当前选择推送到 flag 和回调。
			function Dropdown:Report()
				if Dropdown.Multi then
					Library.Flags[Dropdown.Flag] = Dropdown.SelectedItems
					Dropdown:RefreshValueText()
				else
					Library.Flags[Dropdown.Flag] = Dropdown.Value
					-- 有保护：过期的非字符串值不能到达标签。
					Items["Value"].Instance.Text = type(Dropdown.Value) == "string" and Dropdown.Value or "..."
				end

				if Dropdown.Callback then
					Library:SafeCall(Dropdown.Callback, Dropdown:Get())
				end
			end

			function Dropdown:RefreshValueText()
				local Names = {}

				for ItemName, Data in pairs(Dropdown.SelectedItems) do
					if Data then
						table.insert(Names, ItemName)
					end
				end

				table.sort(Names)

				Items["Value"].Instance.Text = #Names > 0 and table.concat(Names, ", ") or "..."
			end

			function Dropdown:Get()
				-- 多选上报 名称 -> { Enabled, Value } 映射；单选上报
				-- 所选名称。
				if Dropdown.Multi then
					return Dropdown.SelectedItems
				end

				return Dropdown.Value
			end

			function Dropdown:SetVisibility(Bool)
				Items["Dropdown"].Instance.Visible = Bool
			end

			-- 当真实上限稍后到达时，重新设定每一行的上限（以及可选的起始值），
			-- 例如在某个 ModuleScript 加载完成之后。
			function Dropdown:SetItemLimits(NewMaxItems, NewDefaults)
				Dropdown.MaxItems = NewMaxItems or Dropdown.MaxItems
				Dropdown.RowDefaults = NewDefaults or Dropdown.RowDefaults

				for _, Row in Rows do
					local ItemData = Row.ItemData
					if not ItemData then
						continue
					end

					ItemData.Max = tonumber(Dropdown.MaxItems[ItemData.Name]) or Dropdown.Max

					local Default = tonumber(Dropdown.RowDefaults[ItemData.Name])
					ItemData.Value = math.clamp(Default or ItemData.Value, ItemData.Min, ItemData.Max)

					if Row.ValueLabel then
						Row.ValueLabel.Instance.Text = tostring(ItemData.Value)

						local Percentage = (ItemData.Value - ItemData.Min) / (ItemData.Max - ItemData.Min)
						Row.SliderFill.Instance.Size = UDim2New(Percentage, 0, 1, 0)
						Row.SliderKnob.Instance.Position = UDim2New(Percentage, 0, 0.5, 0)
					end

					-- 让回调对已勾选行的视图也保持同步。
					if Dropdown.SelectedItems[ItemData.Name] then
						Dropdown.SelectedItems[ItemData.Name].Value = ItemData.Value
					end
				end

				Dropdown:Report()
			end

			-- 将 名称 -> { Enabled, Value } 映射应用到各行。
			function Dropdown:SetSelected(SelectedItems)
				Dropdown.SelectedItems = SelectedItems or {}

				for _, Row in Rows do
					local ItemData = Row.ItemData
					if not ItemData then
						continue
					end

					local Entry = Dropdown.SelectedItems[ItemData.Name]

					ItemData.Enabled = Entry ~= nil and Entry.Enabled ~= false
					Row.Checkmark.Instance.Visible = ItemData.Enabled
					RefreshRowText(Row, ItemData.Enabled)
					Row.Checkbox.Instance.BackgroundColor3 = ItemData.Enabled and Library.Theme.Accent
						or Library.Theme.Element

					if type(Entry) == "table" and Entry.Value and Row.ValueLabel then
						ItemData.Value = math.clamp(Entry.Value, ItemData.Min, ItemData.Max)
					end

					if Row.ValueLabel then
						Row.ValueLabel.Instance.Text = tostring(ItemData.Value)

						local Percentage = (ItemData.Value - ItemData.Min) / (ItemData.Max - ItemData.Min)
						Row.SliderFill.Instance.Size = UDim2New(Percentage, 0, 1, 0)
						Row.SliderKnob.Instance.Position = UDim2New(Percentage, 0, 0.5, 0)
					end
				end

				Dropdown:Report()
			end

			-- 单选：勾选一行并清除其余行。未知名称会被
			-- 忽略，这样过期的配置不会清空触发器。
			function Dropdown:Set(Option)
				local Found = false

				for _, Row in Rows do
					if Row.ItemData.Name == Option then
						Found = true
						break
					end
				end

				if not Found then
					return
				end

				Dropdown.Value = Option

				for _, Row in Rows do
					local Matches = Row.ItemData.Name == Option

					Row.ItemData.Enabled = Matches
					Row.Checkmark.Instance.Visible = Matches
					RefreshRowText(Row, Matches)
					Row.Checkbox.Instance.BackgroundColor3 = Matches and Library.Theme.Accent
						or Library.Theme.Element
				end

				Dropdown:Report()
			end

			function Dropdown:Add(Option)
				local Row = CreateRow(Option, #Rows + 1)
				table.insert(Rows, Row)
				return Row
			end

			function Dropdown:Remove(Option)
				for Index, Row in Rows do
					if Row.ItemData.Name == Option then
						Row.Container:Clean()
						table.remove(Rows, Index)
						return
					end
				end
			end

			function Dropdown:Refresh(List)
				for _, Row in table.clone(Rows) do
					Dropdown:Remove(Row.ItemData.Name)
				end

				for _, Value in List do
					Dropdown:Add(Value)
				end
			end

			local Debounce = false

			function Dropdown:SetOpen(Bool)
				if Debounce then
					return
				end

				Dropdown.IsOpen = Bool
				Debounce = true

				Items["DropdownWindow"].Instance.Visible = Bool

				-- ZIndexBehavior 是 Global，所以整个子树会被一起抬升
				-- 以越过标题栏和窗口的其余内容。
				local Root = Items["DropdownWindow"].Instance
				local PanelZ = Bool and 20 or 1

				Root.ZIndex = PanelZ

				for _, Descendant in Root:GetDescendants() do
					if not Descendant.ClassName:find("UI") then
						Descendant.ZIndex = PanelZ
					end
				end

				for _, Row in Rows do
					if Row.SliderKnob then
						Row.SliderKnob.Instance.ZIndex = PanelZ + 1
					end
				end

				if Bool then
					for _, Value in Library.OpenFrames do
						if Value ~= Dropdown then
							Value:SetOpen(false)
						end
					end

					Library.OpenFrames[Dropdown] = Dropdown
				elseif Library.OpenFrames[Dropdown] then
					Library.OpenFrames[Dropdown] = nil
				end

				task.delay(0.05, function()
					Debounce = false
				end)
			end

			local PageSearchData = Library.SearchItems[Dropdown.Page]

			if PageSearchData then
				table.insert(PageSearchData, {
					Element = Items["Dropdown"],
					Name = Dropdown.Name,
				})
			end

			Items["RealDropdown"]:Connect("MouseButton1Down", function()
				Dropdown:SetOpen(not Dropdown.IsOpen)
			end)

			Items["ReturnButton"]:Connect("MouseButton1Click", function()
				Dropdown:SetOpen(false)
			end)

			for Index, Value in Dropdown.Items do
				Dropdown:Add(Value)
			end

			if Dropdown.Multi then
				-- 多选从 名称 -> { Enabled, Value } 映射开始。
				local DefaultData = Dropdown.Default

				if type(DefaultData) ~= "table" or DefaultData.Enabled ~= nil then
					DefaultData = {}
				end

				Dropdown:SetSelected(DefaultData)
			elseif Dropdown.Default then
				Dropdown:Set(Dropdown.Default)
			else
				Dropdown:Report()
			end

			Library.SetFlags[Dropdown.Flag] = function(Value)
				if Dropdown.Multi then
					if type(Value) == "table" then
						Dropdown:SetSelected(Value)
					end
					return
				end

				if Value ~= nil then
					Dropdown:Set(Value)
				end
			end

			return Dropdown
		end

		-- 保留别名以便现有调用方继续可用；Dropdown 是唯一的
		-- 实现，这里只是把多选行为打开。
		Library.Sections.MultiSelectDropdown = function(self, Data)
			Data = Data or {}
			Data.Multi = true
			return Library.Sections.Dropdown(self, Data)
		end

		Library.Sections.Viewport = function(self, Data)
			Data = Data or {}

			local Section = self
			local ContentParent = Section.Items and Section.Items["Content"] and Section.Items["Content"].Instance
				or Section.Instance

			local Object = Data.Object or Data.object
			local Camera = Data.Camera or Data.camera
			local Clone = Data.Clone ~= false and Data.clone ~= false
			local AutoFocus = Data.AutoFocus ~= false and Data.autoFocus ~= false
			local Interactive = Data.Interactive or Data.interactive or false
			local Height = Data.Height or Data.height or 200
			local Visible = Data.Visible ~= false and Data.visible ~= false

			if Clone and typeof(Object) == "Instance" and Object then
				if Object.Archivable then
					Object = Object:Clone()
				else
					Object.Archivable = true
					Object = Object:Clone()
					Object.Archivable = false
				end
			end

			local Viewport = {
				Window = Section.Window,
				Page = Section.Page,
				Section = Section,
				Connections = {},
				Destroyed = false,
				Object = Object,
				Camera = if not Camera then Instance.new("Camera") else Camera,
				Interactive = Interactive,
				AutoFocus = AutoFocus,
				Visible = Visible,
				Type = "Viewport",
			}

			assert(
				typeof(Viewport.Object) == "Instance"
					and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
				"Instance must be a BasePart or Model."
			)
			assert(
				typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
				"Camera must be a valid Camera instance."
			)

			local Dragging, Pinching = false, false
			local LastMousePos, LastPinchDist = nil, 0

			local function GetModelSize(Model)
				if Model:IsA("BasePart") then
					return Model.Size
				end
				return select(2, Model:GetBoundingBox())
			end

			local function FocusCamera()
				local ModelSize = GetModelSize(Viewport.Object)
				local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
				local CameraDistance = MaxExtent * 2
				local ModelPosition = Viewport.Object:GetPivot().Position
				Viewport.Camera.CFrame =
					CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
			end

			local Holder = Instances:Create("Frame", {
				Parent = ContentParent,
				Name = "\0",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2New(1, 0, 0, Height),
				Visible = Visible,
			})

			local Box = Instances:Create("Frame", {
				Parent = Holder.Instance,
				Name = "\0",
				AnchorPoint = Vector2New(0, 1),
				BackgroundColor3 = Library.Theme.Inline,
				BorderColor3 = Library.Theme.Outline,
				BorderSizePixel = 0,
				Position = UDim2New(0, 0, 1, 0),
				Size = UDim2New(1, 0, 1, 0),
			})
			Box:AddToTheme({ BackgroundColor3 = "Inline", BorderColor3 = "Outline" })

			Instances:Create("UIStroke", {
				Parent = Box.Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Library.Theme.Outline,
				Thickness = 1,
			}):AddToTheme({ Color = "Outline" })

			Instances:Create("UICorner", {
				Parent = Box.Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 6),
			})

			Instances:Create("UIPadding", {
				Parent = Box.Instance,
				Name = "\0",
				PaddingBottom = UDimNew(0, 3),
				PaddingLeft = UDimNew(0, 8),
				PaddingRight = UDimNew(0, 8),
				PaddingTop = UDimNew(0, 4),
			})

			local ViewportFrame = Instances:Create("ViewportFrame", {
				Parent = Box.Instance,
				Name = "\0",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2New(1, 0, 1, 0),
				CurrentCamera = Viewport.Camera,
				ClipsDescendants = true,
				Active = Interactive,
			})

			local function SetScrollingEnabled(Enabled)
				if not Section.Page or not Section.Page.ColumnsData then
					return
				end
				for _, Side in Section.Page.ColumnsData do
					Side.Instance.ScrollingEnabled = Enabled
				end
			end

			table.insert(
				Viewport.Connections,
				Library:Connect(ViewportFrame.Instance.MouseEnter, function()
					if not Viewport.Interactive then
						return
					end
					SetScrollingEnabled(false)
				end)
			)

			table.insert(
				Viewport.Connections,
				Library:Connect(ViewportFrame.Instance.MouseLeave, function()
					if not Viewport.Interactive then
						return
					end
					SetScrollingEnabled(true)
				end)
			)

			table.insert(
				Viewport.Connections,
				Library:Connect(ViewportFrame.Instance.InputBegan, function(Input)
					if not Viewport.Interactive then
						return
					end
					if Input.UserInputType == Enum.UserInputType.MouseButton2 then
						Dragging = true
						LastMousePos = Input.Position
					elseif Input.UserInputType == Enum.UserInputType.Touch and not Pinching then
						Dragging = true
						LastMousePos = Input.Position
					end
				end)
			)

			table.insert(
				Viewport.Connections,
				Library:Connect(UserInputService.InputEnded, function(Input)
					if Library.Unloaded then
						return
					end
					if not Viewport.Interactive then
						return
					end
					if Input.UserInputType == Enum.UserInputType.MouseButton2 then
						Dragging = false
					elseif Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = false
					end
				end)
			)

			table.insert(
				Viewport.Connections,
				Library:Connect(UserInputService.InputChanged, function(Input)
					if Library.Unloaded then
						return
					end
					if not Viewport.Interactive or not Dragging or Pinching then
						return
					end
					if
						Input.UserInputType == Enum.UserInputType.MouseMovement
						or Input.UserInputType == Enum.UserInputType.Touch
					then
						local MouseDelta = Input.Position - LastMousePos
						LastMousePos = Input.Position
						local Position = Viewport.Object:GetPivot().Position
						local Cam = Viewport.Camera
						local RotY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.01)
						Cam.CFrame = CFrame.new(Position) * RotY * CFrame.new(-Position) * Cam.CFrame
						local RotX = CFrame.fromAxisAngle(Cam.CFrame.RightVector, -MouseDelta.Y * 0.01)
						local Pitched = CFrame.new(Position) * RotX * CFrame.new(-Position) * Cam.CFrame
						if Pitched.UpVector.Y > 0.1 then
							Cam.CFrame = Pitched
						end
					end
				end)
			)

			table.insert(
				Viewport.Connections,
				Library:Connect(ViewportFrame.Instance.InputChanged, function(Input)
					if not Viewport.Interactive then
						return
					end
					if Input.UserInputType == Enum.UserInputType.MouseWheel then
						local ZoomAmount = Input.Position.Z * 2
						Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
					end
				end)
			)

			table.insert(
				Viewport.Connections,
				Library:Connect(UserInputService.TouchPinch, function(TouchPositions, Scale, Velocity, State)
					if Library.Unloaded then
						return
					end
					if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame.Instance, TouchPositions[1]) then
						return
					end
					if State == Enum.UserInputState.Begin then
						Pinching = true
						Dragging = false
						LastPinchDist = (TouchPositions[1] - TouchPositions[2]).Magnitude
					elseif State == Enum.UserInputState.Change then
						local CurDist = (TouchPositions[1] - TouchPositions[2]).Magnitude
						local Delta = (CurDist - LastPinchDist) * 0.1
						LastPinchDist = CurDist
						Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * Delta
					elseif State == Enum.UserInputState.End or State == Enum.UserInputState.Cancel then
						Pinching = false
					end
				end)
			)

			Viewport.Object.Parent = ViewportFrame.Instance
			if Viewport.AutoFocus then
				FocusCamera()
			end

			function Viewport:SetObject(NewObject, ShouldClone)
				assert(NewObject, "Object cannot be nil.")
				if ShouldClone then
					NewObject = NewObject:Clone()
				end
				if Viewport.Object then
					pcall(function()
						Viewport.Object:Destroy()
					end)
				end
				Viewport.Object = NewObject
				Viewport.Object.Parent = ViewportFrame.Instance
			end

			function Viewport:SetHeight(NewHeight)
				assert(NewHeight > 0, "Height must be greater than 0.")
				Holder.Instance.Size = UDim2New(1, 0, 0, NewHeight)
			end

			function Viewport:Focus()
				if not Viewport.Object then
					return
				end
				FocusCamera()
			end

			function Viewport:SetCamera(NewCamera)
				assert(
					NewCamera and typeof(NewCamera) == "Instance" and NewCamera:IsA("Camera"),
					"Camera must be a valid Camera instance."
				)
				Viewport.Camera = NewCamera
				ViewportFrame.Instance.CurrentCamera = NewCamera
			end

			function Viewport:SetInteractive(Bool)
				Viewport.Interactive = Bool
				ViewportFrame.Instance.Active = Viewport.Interactive
			end

			function Viewport:SetVisible(Bool)
				Viewport.Visible = Bool
				Holder.Instance.Visible = Viewport.Visible
			end

			function Viewport:Destroy()
				if Viewport.Destroyed then
					return
				end
				Viewport.Destroyed = true
				for _, Conn in Viewport.Connections do
					pcall(function()
						Conn:Disconnect()
					end)
				end
				table.clear(Viewport.Connections)
				if Holder then
					Holder:Clean()
				end
			end

			Viewport.Holder = Holder
			Viewport.ViewportFrame = ViewportFrame
			Viewport.Box = Box

			return Viewport
		end

		Library.Sections.Image = function(self, Data)
			Data = Data or {}

			local Section = self
			local ContentParent = Section.Items and Section.Items["Content"] and Section.Items["Content"].Instance
				or Section.Instance

			local Img = Data.Image or Data.image or ""
			local Color = Data.Color or Data.color or Color3.new(1, 1, 1)
			local RectOffset = Data.RectOffset or Data.rectOffset or Data.Rectoffset or Vector2.zero
			local RectSize = Data.RectSize or Data.rectSize or Data.Rectsize or Vector2.zero
			local ScaleType = Data.ScaleType or Data.scaleType or Enum.ScaleType.Fit
			local Height = Data.Height or Data.height or 200
			local Visible = Data.Visible ~= false and Data.visible ~= false
			local Transparency = Data.Transparency ~= nil and Data.Transparency
				or (Data.transparency ~= nil and Data.transparency or 0)
			local BgTransparency = Data.BackgroundTransparency ~= nil and Data.BackgroundTransparency
				or (Data.backgroundTransparency ~= nil and Data.backgroundTransparency or 0)
			Transparency = math.clamp(Transparency, 0, 1)
			BgTransparency = math.clamp(BgTransparency, 0, 1)

			local Image = {
				Window = Section.Window,
				Page = Section.Page,
				Section = Section,
				Connections = {},
				Destroyed = false,
				Image = Img,
				Color = Color,
				RectOffset = RectOffset,
				RectSize = RectSize,
				ScaleType = ScaleType,
				Transparency = Transparency,
				BackgroundTransparency = BgTransparency,
				Height = Height,
				Visible = Visible,
				Type = "Image",
			}

			local Holder = Instances:Create("Frame", {
				Parent = ContentParent,
				Name = "\0",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2New(1, 0, 0, Height),
				Visible = Visible,
			})

			local Box = Instances:Create("Frame", {
				Parent = Holder.Instance,
				Name = "\0",
				AnchorPoint = Vector2New(0, 1),
				BackgroundColor3 = Library.Theme.Inline,
				BorderColor3 = Library.Theme.Outline,
				BorderSizePixel = 0,
				BackgroundTransparency = BgTransparency,
				Position = UDim2New(0, 0, 1, 0),
				Size = UDim2New(1, 0, 1, 0),
			})
			Box:AddToTheme({ BackgroundColor3 = "Inline", BorderColor3 = "Outline" })

			Instances:Create("UIStroke", {
				Parent = Box.Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Library.Theme.Outline,
				Thickness = 1,
			}):AddToTheme({ Color = "Outline" })

			Instances:Create("UICorner", {
				Parent = Box.Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 6),
			})

			Instances:Create("UIPadding", {
				Parent = Box.Instance,
				Name = "\0",
				PaddingBottom = UDimNew(0, 3),
				PaddingLeft = UDimNew(0, 8),
				PaddingRight = UDimNew(0, 8),
				PaddingTop = UDimNew(0, 4),
			})

			local function ResolveUrl(Str)
				if not Str or Str == "" then
					return Str, Vector2.zero, Vector2.zero
				end
				if tonumber(Str) then
					return "rbxassetid://" .. tostring(Str), Vector2.zero, Vector2.zero
				end
				if string.find(Str, "rbxasset") == 1 or string.find(Str, "http") == 1 then
					return Str, Vector2.zero, Vector2.zero
				end
				if CreateIcon then
					local ok, tmp = pcall(function()
						local inst = CreateIcon(
							Str,
							{ BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2New(0, 0, 0, 0) },
							nil
						)
						if inst and inst.Instance then
							return {
								Url = inst.Instance.Image,
								RectOffset = inst.Instance.ImageRectOffset,
								RectSize = inst.Instance.ImageRectSize,
							}
						end
					end)
					if ok and tmp and tmp.Url then
						return tmp.Url, tmp.RectOffset or Vector2.zero, tmp.RectSize or Vector2.zero
					end
				end
				return Str, Vector2.zero, Vector2.zero
			end

			local ResolvedUrl, ResolvedOffset, ResolvedSize = ResolveUrl(Image.Image)
			-- 如果 RectOffset/RectSize 是被显式设置的，优先使用它们而不是解析后的值
			if RectOffset ~= Vector2.zero then
				ResolvedOffset = RectOffset
			end
			if RectSize ~= Vector2.zero then
				ResolvedSize = RectSize
			end

			local ImageLabel
			-- lucide 名称优先尝试 Icon 路径
			if
				CreateIcon
				and not string.find(Image.Image, "rbxasset")
				and not string.find(Image.Image, "http")
				and not tonumber(Image.Image)
			then
				local ok, res = pcall(function()
					return Instances:Create("ImageLabel", {
						Parent = Box.Instance,
						Name = "\0",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2New(1, 0, 1, 0),
						Icon = Image.Image,
						ImageColor3 = Image.Color,
						ImageTransparency = Image.Transparency,
						ScaleType = Image.ScaleType,
					})
				end)
				if ok and res and res.Instance then
					ImageLabel = res
					ImageLabel.Instance.ImageRectOffset = ResolvedOffset
					ImageLabel.Instance.ImageRectSize = ResolvedSize
				end
			end
			if not ImageLabel then
				ImageLabel = Instances:Create("ImageLabel", {
					Parent = Box.Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2New(1, 0, 1, 0),
					Image = ResolvedUrl,
					ImageColor3 = Image.Color,
					ImageTransparency = Image.Transparency,
					ImageRectOffset = ResolvedOffset,
					ImageRectSize = ResolvedSize,
					ScaleType = Image.ScaleType,
				})
			end

			function Image:SetHeight(NewHeight)
				assert(NewHeight > 0, "Height must be greater than 0.")
				Image.Height = NewHeight
				Holder.Instance.Size = UDim2New(1, 0, 0, NewHeight)
			end

			function Image:SetImage(NewImage)
				assert(typeof(NewImage) == "string", "Image must be a string.")
				local Url, Off, Sz = ResolveUrl(NewImage)
				-- 如果 RectOffset/RectSize 是自定义的，保留当前值
				Image.Image = NewImage
				Image.RectOffset = Off
				Image.RectSize = Sz
				ImageLabel.Instance.Image = Url
				ImageLabel.Instance.ImageRectOffset = Off
				ImageLabel.Instance.ImageRectSize = Sz
				-- 如果原来是 lucide，则通过 Icon 路径重建以获得正确的图集
				if
					CreateIcon
					and not string.find(NewImage, "rbxasset")
					and not string.find(NewImage, "http")
					and not tonumber(NewImage)
				then
					pcall(function()
						local tmp = CreateIcon(NewImage, {}, nil)
						if tmp and tmp.Instance then
							ImageLabel.Instance.Image = tmp.Instance.Image
							ImageLabel.Instance.ImageRectOffset = tmp.Instance.ImageRectOffset
							ImageLabel.Instance.ImageRectSize = tmp.Instance.ImageRectSize
						end
					end)
				end
			end

			function Image:SetColor(NewColor)
				assert(typeof(NewColor) == "Color3", "Color must be a Color3 value.")
				Image.Color = NewColor
				ImageLabel.Instance.ImageColor3 = NewColor
			end

			function Image:SetRectOffset(NewOffset)
				assert(typeof(NewOffset) == "Vector2", "RectOffset must be a Vector2 value.")
				Image.RectOffset = NewOffset
				ImageLabel.Instance.ImageRectOffset = NewOffset
			end

			function Image:SetRectSize(NewSize)
				assert(typeof(NewSize) == "Vector2", "RectSize must be a Vector2 value.")
				Image.RectSize = NewSize
				ImageLabel.Instance.ImageRectSize = NewSize
			end

			function Image:SetScaleType(NewScaleType)
				assert(
					typeof(NewScaleType) == "EnumItem" and NewScaleType:IsA("ScaleType"),
					"ScaleType must be a valid Enum.ScaleType."
				)
				Image.ScaleType = NewScaleType
				ImageLabel.Instance.ScaleType = NewScaleType
			end

			function Image:SetTransparency(NewTransparency)
				assert(typeof(NewTransparency) == "number", "Transparency must be a number between 0 and 1.")
				assert(NewTransparency >= 0 and NewTransparency <= 1, "Transparency must be between 0 and 1.")
				Image.Transparency = NewTransparency
				ImageLabel.Instance.ImageTransparency = NewTransparency
			end

			function Image:SetBackgroundTransparency(NewBg)
				assert(typeof(NewBg) == "number", "BackgroundTransparency must be a number between 0 and 1.")
				Image.BackgroundTransparency = math.clamp(NewBg, 0, 1)
				Box.Instance.BackgroundTransparency = Image.BackgroundTransparency
			end

			function Image:SetVisible(Bool)
				Image.Visible = Bool
				Holder.Instance.Visible = Image.Visible
			end

			function Image:Destroy()
				if Image.Destroyed then
					return
				end
				Image.Destroyed = true
				if Holder then
					Holder:Clean()
				end
			end

			Image.Holder = Holder
			Image.Box = Box
			Image.ImageLabel = ImageLabel

			return Image
		end

		Library.Sections.Video = function(self, Data)
			Data = Data or {}

			local Section = self
			local ContentParent = Section.Items and Section.Items["Content"] and Section.Items["Content"].Instance
				or Section.Instance

			local VideoSrc = Data.Video or Data.video or ""
			local Looped = Data.Looped ~= nil and Data.Looped or (Data.looped ~= nil and Data.looped or false)
			local Playing = Data.Playing ~= nil and Data.Playing or (Data.playing ~= nil and Data.playing or false)
			local Volume = Data.Volume ~= nil and Data.Volume or (Data.volume ~= nil and Data.volume or 1)
			local Height = Data.Height or Data.height or 200
			local Visible = Data.Visible ~= false and Data.visible ~= false

			Volume = math.clamp(Volume, 0, 10)

			local Video = {
				Window = Section.Window,
				Page = Section.Page,
				Section = Section,
				Connections = {},
				Destroyed = false,
				Video = VideoSrc,
				Looped = Looped,
				Playing = Playing,
				Volume = Volume,
				Height = Height,
				Visible = Visible,
				Type = "Video",
			}

			local Holder = Instances:Create("Frame", {
				Parent = ContentParent,
				Name = "\0",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2New(1, 0, 0, Height),
				Visible = Visible,
			})

			local Box = Instances:Create("Frame", {
				Parent = Holder.Instance,
				Name = "\0",
				AnchorPoint = Vector2New(0, 1),
				BackgroundColor3 = Library.Theme.Inline,
				BorderColor3 = Library.Theme.Outline,
				BorderSizePixel = 0,
				Position = UDim2New(0, 0, 1, 0),
				Size = UDim2New(1, 0, 1, 0),
			})
			Box:AddToTheme({ BackgroundColor3 = "Inline", BorderColor3 = "Outline" })

			Instances:Create("UIStroke", {
				Parent = Box.Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Library.Theme.Outline,
				Thickness = 1,
			}):AddToTheme({ Color = "Outline" })

			Instances:Create("UICorner", {
				Parent = Box.Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 6),
			})

			Instances:Create("UIPadding", {
				Parent = Box.Instance,
				Name = "\0",
				PaddingBottom = UDimNew(0, 3),
				PaddingLeft = UDimNew(0, 8),
				PaddingRight = UDimNew(0, 8),
				PaddingTop = UDimNew(0, 4),
			})

			local VideoFrame = Instances:Create("VideoFrame", {
				Parent = Box.Instance,
				Name = "\0",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2New(1, 0, 1, 0),
				Video = Video.Video,
				Looped = Video.Looped,
				Volume = Video.Volume,
			})
			VideoFrame.Instance.Playing = Video.Playing

			function Video:SetHeight(NewHeight)
				assert(NewHeight > 0, "Height must be greater than 0.")
				Video.Height = NewHeight
				Holder.Instance.Size = UDim2New(1, 0, 0, NewHeight)
			end

			function Video:SetVideo(NewVideo)
				assert(typeof(NewVideo) == "string", "Video must be a string.")
				Video.Video = NewVideo
				VideoFrame.Instance.Video = NewVideo
			end

			function Video:SetLooped(Bool)
				assert(typeof(Bool) == "boolean", "Looped must be a boolean.")
				Video.Looped = Bool
				VideoFrame.Instance.Looped = Bool
			end

			function Video:SetVolume(NewVolume)
				assert(typeof(NewVolume) == "number", "Volume must be a number between 0 and 10.")
				Video.Volume = math.clamp(NewVolume, 0, 10)
				VideoFrame.Instance.Volume = Video.Volume
			end

			function Video:SetPlaying(Bool)
				assert(typeof(Bool) == "boolean", "Playing must be a boolean.")
				Video.Playing = Bool
				VideoFrame.Instance.Playing = Bool
			end

			function Video:Play()
				Video.Playing = true
				VideoFrame.Instance.Playing = true
			end

			function Video:Pause()
				Video.Playing = false
				VideoFrame.Instance.Playing = false
			end

			function Video:SetVisible(Bool)
				Video.Visible = Bool
				Holder.Instance.Visible = Video.Visible
			end

			function Video:Destroy()
				if Video.Destroyed then
					return
				end
				Video.Destroyed = true
				for _, Conn in Video.Connections do
					pcall(function()
						Conn:Disconnect()
					end)
				end
				table.clear(Video.Connections)
				if Holder then
					Holder:Clean()
				end
			end

			Video.Holder = Holder
			Video.Box = Box
			Video.VideoFrame = VideoFrame

			return Video
		end
	end

	Library.CreateSettingsPage = function(self, Window)
		local SettingsPage = Window:Page({
			Title = "Settings",
			Description = "Library preferences",
			Icon = "settings",
		})

		local ConfigsSection = SettingsPage:Section({ Name = "Configs", Side = 2 })
		do
			local ConfigName
			local ConfigSelected

			local ConfigsDropdown = ConfigsSection:Dropdown({
				Name = "Configs",
				Flag = "Configs",
				Items = {},
				Callback = function(Value)
					ConfigSelected = Value
				end,
			})

			ConfigsSection:Textbox({
				Name = "Config name",
				Placeholder = "Config name",
				Flag = "ConfigName",
				Callback = function(Value)
					ConfigName = Value
				end,
			})

			ConfigsSection:Button({
				Name = "Create",
				Callback = function()
					if ConfigName and ConfigName ~= "" then
						if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
							writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
							Library:RefreshConfigsList(ConfigsDropdown)
						end
					end
				end,
			})

			ConfigsSection:Button({
				Name = "Load",
				Callback = function()
					if ConfigSelected and ConfigSelected ~= "" then
						Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json"))
					end
				end,
			})

			ConfigsSection:Button({
				Name = "Save",
				Callback = function()
					if ConfigSelected and ConfigSelected ~= "" then
						writefile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json", Library:GetConfig())
					end
				end,
			})

			ConfigsSection:Button({
				Name = "Delete",
				Callback = function()
					if ConfigSelected and ConfigSelected ~= "" then
						delfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json")
						Library:RefreshConfigsList(ConfigsDropdown)
					end
				end,
			})

			ConfigsSection:Button({
				Name = "Refresh",
				Callback = function()
					Library:RefreshConfigsList(ConfigsDropdown)
				end,
			})

			local AutoloadLabel = ConfigsSection:Label("")

			local function RefreshAutoloadLabel()
				local Name = Library:GetAutoloadConfig()
				AutoloadLabel:SetText("Autoload: " .. (Name or "none"))
			end

			ConfigsSection:Button({
				Name = "Set as autoload",
				Callback = function()
					if not ConfigSelected or ConfigSelected == "" then
						Library:Notification("Select a config first", "bell", 4)
						return
					end

					if Library:SaveAutoloadConfig(ConfigSelected) then
						Library:Notification("Autoload set: " .. ConfigSelected, "bell", 4)
						RefreshAutoloadLabel()
					else
						Library:Notification("Failed to set autoload", "bell", 4)
					end
				end,
			})

			ConfigsSection:Button({
				Name = "Reset autoload",
				Callback = function()
					Library:DeleteAutoloadConfig()
					Library:Notification("Autoload cleared", "bell", 4)
					RefreshAutoloadLabel()
				end,
			})

			RefreshAutoloadLabel()
			Library:RefreshConfigsList(ConfigsDropdown)
		end

		local SettingsSection = SettingsPage:Section({ Name = "Settings", Side = 1 })
		do
			SettingsSection:Label("Menu Keybind"):Keybind({
				Name = "Menu Keybind",
				Flag = "Menu Keybind",
				Default = Enum.KeyCode.RightControl,
				Mode = "Toggle",
				ShowInHotkeys = false,
				Callback = function(Value)
					local Stored = Library.Flags["Menu Keybind"]
					local KeyVal = Stored and (Stored.KeyEnum or Stored.Key)
					if typeof(KeyVal) == "EnumItem" then
						Library.MenuKeybind = KeyVal
					else
						local Short = tostring(KeyVal):match("%.([^%.]+)$") or tostring(KeyVal)
						Library.MenuKeybind = Enum.KeyCode[Short]
							or Enum.UserInputType[Short]
							or Enum.KeyCode.RightControl
					end
				end,
			})

			local WatermarkToggle = SettingsSection:Toggle({
				Name = "Watermark",
				Flag = "Watermark",
				Default = true,
				Callback = function(Value)
					if Library.WatermarkInstance then
						Library.WatermarkInstance:SetEnabled(Value)
					end
				end,
			})
			Library.WatermarkInstance:SetEnabled(WatermarkToggle:Get())

			SettingsSection:Toggle({
				Name = "Background Effects",
				Flag = "Background Effects",
				Default = true,
				Callback = function(Value)
					Library:SetBackgroundEffectsEnabled(Value)
				end,
			})

			SettingsSection:Dropdown({
				Name = "Notify Position",
				Flag = "Notify Position",
				Items = { "Top Left", "Top Right", "Bottom Left", "Bottom Right" },
				Default = "Bottom Right",
				Callback = function(Value)
					Library:SetNotifySide(string.gsub(Value, " ", ""))
				end,
			})

			SettingsSection:Slider({
				Name = "Interface Scale",
				Flag = "Interface Scale",
				Default = Library.UserScale * 100,
				Min = 50,
				Max = 150,
				Suffix = "%",
				Decimals = 5,
				ReleasedCallback = function(Value)
					Library:SetUIScale(Value / 100)
				end,
			})

			SettingsSection:Slider({
				Name = "Fade Time",
				Flag = "Fade Time",
				Default = Library.FadeSpeed,
				Min = 0,
				Max = 1,
				Suffix = "s",
				Decimals = 0.01,
				Callback = function(Value)
					Library.FadeSpeed = Value
				end,
			})

			SettingsSection:Slider({
				Name = "Animation Speed",
				Flag = "Animation Speed",
				Default = Library.Tween.Time,
				Min = 0,
				Max = 1,
				Suffix = "s",
				Decimals = 0.01,
				Callback = function(Value)
					Library.Tween.Time = Value
				end,
			})

			SettingsSection:Dropdown({
				Name = "Font Face",
				Flag = "FontFace",
				Items = {
					"InterSemibold",
					"Inter",
					"InterBold",
					"InterMedium",
					"Bubblegum-Sans",
					"Comfortaa-Regular",
					"Figtree-Medium",
					"Figtree-SemiBold",
					"GoogleSansFlex_24pt-SemiBold",
					"HankenGrotesk-SemiBold",
					"Lato-Bold",
					"Lexend-Medium",
					"MinecraftStandard",
					"Monaco",
					"NDS12",
					"Outfit-Medium",
					"PIXEARG_",
					"PixelOperator",
					"Poppins-Medium",
					"ProggyClean",
					"Prompt-Medium",
					"Prompt-Regular",
					"Reactor7",
					"RobotoMono-Regular",
					"SGK075",
					"TAHOMA-8PT-BOLD-WINDOWS-XP",
					"basis33",
					"cozette-vector",
					"fs Tahoma 8px",
					"lucida-console",
					"minecraftia-regular",
					"minecraftia",
					"open-sans-px",
					"proggy-clean",
					"proggy-square",
					"proggy-tiny",
					"smallest_pixel-7",
					"tahoma",
					"tahomabd",
					"teachers-pet",
					"verdana-bold",
					"verdana",
					"windows-xp-tahoma",
				},
				Default = "InterSemibold",
				Callback = function(Value)
					Library:SetFont(Value)
				end,
			})
		end

		local ThemeSection = SettingsPage:Section({ Name = "Theme", Side = 1 })
		do
			for Index, Value in Library.Theme do
				ThemeSection:Label(Index):Colorpicker({
					Flag = Index,
					Default = Value,
					Callback = function(Color)
						Library.Theme[Index] = Color
						Library:ChangeTheme(Index, Color)
					end,
				})
			end
		end
	end
end

getgenv().Library = Library
return Library
