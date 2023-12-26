--[[
    Created by Monnapse

    Get Average FPS, Ping, and Mememory or the exact at the current time
--]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")

--// Local functions
local function getSum(table: {})
    local sum = 0
    for index, value in pairs(table) do
        sum += value
    end
    return sum
end

local function getAverage(table: {})
    return getSum(table)/#table
end

local Stats = {
    framesTask = true,
    pingTask = true,
    memoryTask = true
}

--// Frames
local TimeFunction = RunService:IsRunning() and time or os.clock
local currentFrames = 0
--local framesTable = {}
local LastIteration, Start
local FrameUpdateTable = {}

--// Pings
local pingTable = {}

--// Memory
local memoryTable = {}

Start = TimeFunction()
RunService.RenderStepped:Connect(function(deltaTime)
    --// Frames
    --currentFrames = math.ceil(1/deltaTime)
    --table.insert(framesTable, currentFrame)

    LastIteration = TimeFunction()
	for Index = #FrameUpdateTable, 1, -1 do
		FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
	end

	FrameUpdateTable[1] = LastIteration
	currentFrames = math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start))

    --// Ping
    table.insert(pingTable, Players.LocalPlayer:GetNetworkPing()*1000)

    --// Memory
    table.insert(memoryTable, StatsService:GetTotalMemoryUsageMb())
end)

--// Package functions

--// FPS
function Stats.getCurrentFrames(): number
    return currentFrames
end
--function Stats.getAverageFrames(resetAverages: boolean): number
--    resetAverages = resetAverages or true
--
--    local averageFrames = getAverage(framesTable)
--
--    if resetAverages then
--        framesTable = {}
--    end
--
--    return math.round(averageFrames)
--end

--// Ping
function Stats.getPing()
    return Players.LocalPlayer:GetNetworkPing()*1000
end
function Stats.getAveragePing(resetAverages: boolean)
    resetAverages = resetAverages or true

    local averagePing = getAverage(pingTable)

    if resetAverages then
        pingTable = {}
    end

    return math.round(averagePing)
end

--// Memory
function Stats.getMemory()
    return StatsService:GetTotalMemoryUsageMb()
end
function Stats.getAverageMemory(resetAverages: boolean)
    resetAverages = resetAverages or true

    local averageMemory = getAverage(memoryTable)

    if resetAverages then
        memoryTable = {}
    end

    return math.round(averageMemory)
end


return Stats