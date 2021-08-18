local GRID_SIZE_X = 12
local GRID_SIZE_Z = 12

local RunService = game:GetService("RunService")

local wave_size = 0

local grid = {}

local firstRun = true

local waveOffset = math.random(workspace.Config.minWaveSpeed_scale.Value, workspace.Config.maxWaveSpeed_scale.Value)

local function startGrid()
	for X = 1, GRID_SIZE_X do
		for Z = 1, GRID_SIZE_Z do
			grid[X] = {
				Z = nil
			}
		end
	end
end

local function generateGrid()
	for X = 1, GRID_SIZE_X do
		for Z = 1, GRID_SIZE_Z do
			local part = Instance.new("Part", workspace.WaterGrid)
			part.Anchored = true
			part.Size = Vector3.new(4, 4, 4)
			part.Color = Color3.fromRGB(56+math.sin(tick()), 252+math.sin(tick()), 255+math.sin(tick()))
			part.Material = Enum.Material.SmoothPlastic
			part.Position = Vector3.new(X*4, 0, Z*4)
			part.Transparency = .6
			part.CanCollide = false
			part.CastShadow = false
			part.CanTouch = false
			part.CanQuery = false
			if workspace.Config.shape.Value == "cube" then
				part.Shape = Enum.PartType.Block
			elseif workspace.Config.shape.Value == "circle" then
				part.Shape = Enum.PartType.Ball
				part.Size = Vector3.new(.4, .4, .4)
			elseif workspace.Config.shape.Value == "cylinder" then
				part.Shape = Enum.PartType.Cylinder
			else
				part.Shape = Enum.PartType.Block
			end
			part.Name = "("..X..", "..Z..")"
			
			grid[X][Z] = part
			if not firstRun then wait() end
		end
	end
end

local function updateColors(X, Z, part, wave_speed)
	part.Color = Color3.fromRGB(111+math.sin(tick()+(X+Z)+wave_speed), 254+math.sin(tick()+(X+Z)+wave_speed), 244+math.sin(tick()+(X+Z)+wave_speed))
	part.Transparency = .7
end

local function updatePart(part, wave_speed)
	part.Position = Vector3.new(part.Position.X, 
		math.sin(tick()+wave_speed),
		part.Position.Z
	)
end

local function destroyGrid()
	for X = 1, GRID_SIZE_X do
		for Z = 1, GRID_SIZE_Z do
			local part = grid[X][Z]
			
			if part then print("Destroying part "..part.Name) part:Destroy() wait() end
		end
	end
end

local function moveGrid()
	for X = 1, GRID_SIZE_X do
		for Z = 1, GRID_SIZE_Z do
			local part = grid[X][Z]
			
			local wave_speed = (X+Z+wave_size)
			

			wave_size = wave_speed-(wave_speed/waveOffset)
			wave_size = wave_size - math.random(0.08, 0.1)
			
			updatePart(part, wave_speed)

			--print("Wave speed is "..wave_speed)
			--print("Wave size is "..wave_size)
			updateColors(X, Z, part, wave_speed)
		end
	end	
	wait()
end

local heartbeatEvent

local function main()
	-- Init grid
	print("Making grid.")
	startGrid()
	print("Grid of ("..GRID_SIZE_X.."x"..GRID_SIZE_Z..") constructed!")
	-- Generate the grid
	print("Now generating grid of shape '"..workspace.Config.shape.Value.."'.")
	generateGrid()	
	print("Generated grid!")
	firstRun = false
	print("First run boolean is now false, meaning that objects will now load in slow mode.")
	
	-- move the grid every frame
	if heartbeatEvent then warn("Disconnecting previous heartbeat.") heartbeatEvent:Disconnect() print("Successfully disconnected previous heartbeat.") end
	print("Connecting new heartbeat.")
	heartbeatEvent = RunService.Heartbeat:Connect(moveGrid)
	print("Connected heartbeat event.")
end

main()

workspace.Config.shape.Changed:Connect(function()
	print("Attempting to destroy any previous grid objects.")
	destroyGrid()
	print("Done searching any previous grid objects.")
	main()
end)

workspace.Config.minWaveSpeed_scale.Changed:Connect(function()
	waveOffset = math.random(workspace.Config.minWaveSpeed_scale.Value, workspace.Config.maxWaveSpeed_scale.Value)
end)

workspace.Config.maxWaveSpeed_scale.Changed:Connect(function()
	waveOffset = math.random(workspace.Config.minWaveSpeed_scale.Value, workspace.Config.maxWaveSpeed_scale.Value)
end)
