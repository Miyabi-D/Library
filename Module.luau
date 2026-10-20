local _ENV = (getgenv or getrenv or getfenv)()

local Host = "https://miyabi-d.vercel.app"
local LibraryUrl = `{Host}/Library.lua`

local Module, Settings = {}, {}
local Errors = _ENV.Errors or {}

local Session = os.clock() do
    _ENV.Errors = Errors
    _ENV.Session = Session
    _ENV.Settings = Settings
end

local UserInputService = game:GetService('UserInputService')
local TeleportService = game:GetService('TeleportService')
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local RunService = game:GetService('RunService')
local Lighting = game:GetService('Lighting')
local Players = game:GetService('Players')

local PlaceId = game.PlaceId
local JobId = game.JobId

local RenderStepped = RunService.RenderStepped
local Heartbeat = RunService.Heartbeat
local Stepped = RunService.Stepped
local Player = Players.LocalPlayer

function Module:NewModule(Name, Function)
    do Module[Name] = Function()
        return Module[Name]
    end
end

function Module:Import(Path)
    local Success, Result = pcall(function()
        return game:HttpGet(`{Host}/{Path}.luau`)
    end)

    return loadstring(Result)
end 

function Module:Framework(Packet)
    return self:Import(`Framework/{Packet}`)(self)
end

function Module:Color(Text, Color)
    if type(Text) ~= "string" or typeof(Color) ~= "Color3" then
        return Text
    end

    local R = math.floor(Color.R * 255)
    local G = math.floor(Color.G * 255)
    local B = math.floor(Color.B * 255)

    return string.format(
        '<font color="rgb(%d, %d, %d)">%s</font>',
        R, G, B, Text
    )
end

function Module:TableToString(Value, Indent, Seen)
    Indent = Indent or 0
    Seen = Seen or {}

    if type(Value) ~= "table" then
        if typeof(Value) == "Instance" then
            return Value:GetFullName()
        elseif type(Value) == "string" then
            return string.format("%q", Value)
        end

        return tostring(Value)
    end

    if Seen[Value] then
        return "<recursive>"
    end

    Seen[Value] = true

    local Space = string.rep("    ", Indent)
    local Result = {"{\n"}

    for Key, Object in next, Value do
        table.insert(Result,
            string.format(
                "%s    [%s] = %s,\n",
                Space,
                self:TableToString(Key, 0, Seen),
                self:TableToString(Object, Indent + 1, Seen)
            )
        )
    end

    table.insert(Result, Space .. "}")
    return table.concat(Result)
end

Module:NewModule("Loader", function()
    return ([[
        License = %q
        loadstring(game:HttpGet("%s/main.luau"))()
    ]]):format(_ENV.SCRIPT_KEY or "None", Host)
end)

Module:NewModule("Connections", function()
    local Connectors = {}

    local Connections = _ENV.Connections or {} do
        _ENV.Connections = Connections

        for i = 1, #Connections do
            Connections[i]:Disconnect()
        end

        table.clear(Connections)
    end

    function Connections.Connect(Instance, Callback)
        local Connection = Instance:Connect(Callback)
        table.insert(Connections, Connection) do
            return Connection 
        end
    end

    return Connections
end)

Module:NewModule("GoodQueue", function()
    local Queueable = {}
    Queueable.__index = Queueable

    function Queueable:Error(Message)
        _ENV.OnFarm = false

        local Option = _ENV.RunningOption or "Unknown"
        local Text = (`error [ {Option} ] {Message}`)

        Errors[Option] = Errors[Option] or {}
        table.insert(Errors[Option], Message)

        local Error = _ENV.Error

        if Error and Error.Parent then
            Error.Text ..= `\n\n{Text}`
            return
        end

        Error = Instance.new("Message")
        Error.Parent = workspace
        Error.Text = Text

        _ENV.Error = Error
    end

    function Queueable:ResetQueue()
        if self.Resetting then
            return
        end

        self.Resetting = true

        local Error = _ENV.Error
        local Option = _ENV.RunningOption
        local Fallback = self.Fallback

        if Error and Error.Parent then
            Error.Text = "Start Refresh Options."

            task.wait(2)

            local Value = Option and Fallback[Option]

            if Value then
                pcall(Value.Set, Value, false)
                Error.Text = `Disabled : {Option}`
            end

            task.wait(2)

            if Error.Parent then
                Error:Destroy()
            end

            if _ENV.Error == Error then
                _ENV.Error = nil
            end
        end

        self.Resetting = false

        if _ENV.Session == Session then
            self:RunQueue()
        end
    end

    function Queueable:GetQueue()
        for _, Option in ipairs(self.FarmFunctions) do
            if type(Option) ~= "table" or type(Option.Function) ~= "function" then
                continue
            end

            local Name = Option.Name or "Unknown"
            _ENV.RunningOption = Name

            local Success, Result = pcall(Option.Function)

            if not Success then
                error(Result, 0)
            end

            if Result then
                _ENV.RunningMethod = type(Result) == "string" and Result or nil
                return Result
            end
        end

        _ENV.RunningOption = nil
        _ENV.RunningMethod = nil

        return nil
    end

    function Queueable:RunQueue()
        if self.Running then
            return
        end

        self.Running = true

        task.spawn(function()
            local Success, Error = xpcall(function()
                while _ENV.Session == Session do
                    local Result = self:GetQueue()
                    _ENV.OnFarm = Result ~= nil

                    RunService.Heartbeat:Wait()
                end

                _ENV.RunningOption = nil
                _ENV.RunningMethod = nil
                _ENV.OnFarm = false
            end, debug.traceback)

            self.Running = false

            if not Success and _ENV.Session == Session then
                self:Error(Error)

                task.delay(3, function()
                    if _ENV.Session == Session then
                        self:ResetQueue()
                    end
                end)
            end
        end)
    end

    function Queueable:UpdateOptions()
        table.clear(self.FarmFunctions)

        for Index, Value in pairs(self.NewValues) do
            self.Cloneables[Index] = Value or nil
            self.NewValues[Index] = nil
        end

        for _, Function in ipairs(self.Functions) do
            if self.Cloneables[Function.Name] then
                table.insert(self.FarmFunctions, Function)
            end
        end
    end

    function Queueable:While(Value, Interval, Callback, Break)
        Interval = Interval or 0.1

        while Value and _ENV.Session == Session do
            local Start = os.clock()

            if Callback then
                local Success, Error = pcall(Callback)

                if not Success then
                    error(Error, 0)
                end
            end

            if Break and Break() then
                break
            end

            repeat
                RunService.Heartbeat:Wait()
            until os.clock() - Start >= Interval or _ENV.Session ~= Session
        end
    end

    function Queueable:NewOption(Flag, Function, Interval)
        if type(Flag) ~= "string" or type(Function) ~= "function" then
            return
        end

        if Interval then
            self.Threads[Flag] = function(Value)
                self:While(Value, Interval, Function, function()
                    return not Value or _ENV.Session ~= Session
                end)
            end
        else
            self.Indexable[Flag] = Function

            table.insert(self.Functions, {
                Name = Flag,
                Function = Function
            })
        end
    end

    function Queueable.Build(Running)
        local self = setmetatable({}, Queueable)

        self.Fallback = {}
        self.NewValues = {}
        self.Cloneables = {}
        self.Threads = {}
        self.Indexable = {}
        self.Running = false
        self.Resetting = false

        self.Functions = _ENV.Functions or {}
        self.FarmFunctions = _ENV.FarmFunctions or {}

        self.Enableds = _ENV.Enableds or setmetatable({}, {
            __newindex = function(_, Index, Value)
                self.NewValues[Index] = Value or false
                self:UpdateOptions()
            end,

            __index = self.Cloneables
        })

        _ENV.Functions = self.Functions
        _ENV.FarmFunctions = self.FarmFunctions
        _ENV.Enableds = self.Enableds

        if Running then
            self:RunQueue()
        end

        table.clear(self.Functions)

        return self
    end

    return Queueable
end)

Module:NewModule("EachOthers", function()
    local EachOthers = {}

    function EachOthers:Join(Id)
        return TeleportService:TeleportToPlaceInstance(PlaceId, Id, Player)
    end

    function EachOthers:Reversed(Cursor)
        local Url = `https://games.roblox.com/v1/games/{PlaceId}/servers/Public?sortOrder=Asc&limit=100`

        if Cursor then Url ..= `&cursor={Cursor}` end

        local Result = game:HttpGet(Url)

        return HttpService:JSONDecode(Result)
    end

    function EachOthers:Rejoin()
        if _ENV.NVL_CUSTOM_REJOIN then
            return _ENV.NVL_CUSTOM_REJOIN()
        end
        
        if #Players:GetPlayers() <= 1 then
            Player:Kick("\nRejoining");wait()

            return TeleportService:Teleport(PlaceId, Player)
        end

        return self:Join(JobId)
    end

    function EachOthers:Change()
        local Server, Next

        repeat
            local Servers = self:Reversed(Next)

            Server = Servers and Servers.data and Servers.data[1]
            Next = Servers and Servers.nextPageCursor
        until Server

        if not Server or not Server.id then return end
        return self:Join(Server.id)
    end

    function EachOthers:Set3d(value)
        RunService:Set3dRenderingEnabled(if value then false else true)
    end

    function EachOthers:Low()
        local Terrain = workspace:FindFirstChildOfClass('Terrain') do
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0

            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9

            settings().Rendering.QualityLevel = 1
        end
    end

    return EachOthers
end)

Module:NewModule("Plugins", function()
    local Plugins = {}

    local Novel = loadstring(game:HttpGet(LibraryUrl))()

    local EachOthers = Module.EachOthers

    Plugins.Add = function(En, th)
        return Settings['Select Laugage'] == 'English' and En or th
    end

    Settings['Select Laugage'] = Settings['Select Laugage'] or "English"
    Settings.Success = Settings.Success or true

    function Plugins:Window(Queueable, Args)
        Args = Args or {}

        self.Novel = Novel

        self.Enableds = Queueable.Enableds
        self.Fallback = Queueable.Fallback
        self.Threads = Queueable.Threads

        self.Library = Novel:Window({
            Name = Args[1] or "Window",
            SubTitle = Args[2] or "SubName",
        })

        return self.Library
    end

    function Plugins:MakeTab(Args, Select)
        return self.Library:Page({
            Title = Args[1],
            Description = Args[2] or Plugins.Add("Automatically", "อัตโนมัติ"),
            Icon = Args[3],
        })
    end

    function Plugins:TextLabel(Section, Args, Extens)
        local Label = Section:Label(Args[1])
        if Extens then Label:SetText(Extens) end
        return Label
    end

    function Plugins:Button(Section, Args, Callback)
        return Section:Button({
            Name = Args[1],
            Callback = Callback,
        })
    end

    function Plugins:Toggle(Section, Args, Flag, Callback, Extra)
        local Thread = nil
        local Default = Settings[Flag]

        if Default == nil and type(Extra) == "table" then
            Default = Extra.Default
        end

        Default = Default or false
        local Started = false

        self.Fallback[ Flag ] = Section:Toggle({
            Name = Args[1],
            Flag = Flag,
            Default = Default,
            Callback = function(Value)
                Settings[ Flag ] = Value

                if Started then
                    self.Enableds[ Flag ] = Value

                    if Value and self.Threads[ Flag ] ~= nil then
                        Thread = task.spawn(self.Threads[ Flag ], Value)
                    elseif Thread then
                        task.cancel(Thread)
                    end
                end

                if Callback then Callback(Value) end
            end
        })

        Started = true
        self.Enableds[ Flag ] = Default

        if Default and self.Threads[ Flag ] ~= nil then
            Thread = task.spawn(self.Threads[ Flag ], true)
        end

        return self.Fallback[Flag]
    end

    function Plugins:Slider(Section, Args, Values, Flag, Callback, Extra)
        local Data = {
            Name = Args[1],
            Flag = Flag,
            Min = Values[1],
            Max = Values[2],
            Decimals = Values[3],
            Callback = function(Value)
                Settings[ Flag ] = Value
                if Callback then Callback(Value) end
            end
        }

        if type(Extra) == "table" then
            for Key, Value in Extra do Data[Key] = Value end
        end

        Data.Default = Settings[Flag] or Data.Default or Values[1]

        return Section:Slider(Data)
    end

    function Plugins:Dropdown(Section, Args, List, Flag, Callback, OnRefresh, Extra)
        if type(OnRefresh) == "function" then
            local Ok, Refreshed = pcall(OnRefresh)
            if Ok and type(Refreshed) == "table" then List = Refreshed end
        end

        local Data = {
            Name = Args[1],
            Flag = Flag,
            Items = List,
            Default = Settings[Flag],
            Callback = function(Value)
                Settings[Flag] = Value
                if Callback then Callback(Value) end
            end
        }

        if type(Extra) == "table" then
            for Key, Value in Extra do Data[Key] = Value end
        end

        return Section:Dropdown(Data)
    end

    function Plugins:Textbox(Section, Args, Flag, Callback)
        return Section:Textbox({
            Name = Args[1],
            Flag = Flag,
            Default = Settings[Flag] or "",
            Callback = function(Value)
                Settings[Flag] = Value
                if Callback then Callback(Value) end
            end,
        })
    end

    return Plugins
end)

return Module, Settings