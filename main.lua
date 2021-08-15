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

local function generateGrid()
	for X = 1, GRID_SIZE_X do
		for Z = 1, GRID_SIZE_Z do
			local part = Instance.new("Part", workspace.WaterGrid)
			part.Anchored = true
			part.Size = Vector3.new(4, 4, 4)
			part.Color = Color3.fromRGB(56, 252, 255)
			part.Material = Enum.Material.SmoothPlastic
			part.Position = Vector3.new(X*4, 0, Z*4)
			part.Transparency = .6
			grid[X][Z] = part
		end
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
