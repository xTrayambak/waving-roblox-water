local GRID_SIZE_X = 16
local GRID_SIZE_Z = 16

local RunService = game:GetService("RunService")

local grid = {}

local function startGrid()
	for X = 1, GRID_SIZE_X do
		for Z = 1, GRID_SIZE_Z do
			grid[X] = {
				Z = nil
			}
		end
	end
end

local function initColor(part, X, Z)
	if X == 1 or Z == 1 then
		local clone = part:Clone()
		clone.Position = Vector3.new(clone.Position.X, clone.Position.Y, clone.Position.Z-4)
		clone.Transparency = .9
		clone.Name = "FOAM"
		clone.Parent = workspace.WaterGrid
		clone.Size = Vector3.new(1, 4, 1)
	elseif X == GRID_SIZE_X or Z == GRID_SIZE_Z then
		local clone = part:Clone()
		clone.Position = Vector3.new(clone.Position.X-4, clone.Position.Y, clone.Position.Z)
		clone.Transparency = .9
		clone.Name = "FOAM"
		clone.Size = Vector3.new(1, 4, 1)
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
			part.Name = "("..X..", "..Z..")"
			initColor(part, X, Z)
			grid[X][Z] = part
		end
	end
end

local function updateColors(X, Z, part)
	if X == 1 and Z == 1 or X == GRID_SIZE_X and Z == GRID_SIZE_Z then
		part.Transparency = .7
		part.Color = Color3.fromRGB(121, 255, 251)
	elseif X > 1 and X < GRID_SIZE_X/2 or Z > 1 and Z < GRID_SIZE_Z/2 then
		part.Transparency = .6
		part.Color = Color3.fromRGB(82, 255, 244)
	else
		part.Transparency = .6
		part.Color = Color3.fromRGB(52, 255, 249)
	end
end

local function moveGrid()
	for X = 1, GRID_SIZE_X do
		for Z = 1, GRID_SIZE_Z do
			local part = grid[X][Z]
			
			local wave_speed = X+Z
			
			part.Position = Vector3.new(part.Position.X, 
				math.sin(tick()+wave_speed),
				part.Position.Z
			)
			
			updateColors(X, Z, part)
		end
	end
end

local function main()
	-- Init grid
	startGrid()
	-- Generate the grid
	generateGrid()
	
	-- move the grid every frame
	RunService.Heartbeat:Connect(moveGrid)
end

main()
