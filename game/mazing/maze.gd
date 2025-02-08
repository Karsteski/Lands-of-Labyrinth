class_name Maze

var current_grid: Grid

func _init(dimensions: Vector2i) -> void:
	current_grid = generate_random_grid(dimensions)

## Advances the Game of Life
func game_of_life() -> void:
	current_grid.data = next_iteration(current_grid.data)

class Grid:
	var size := Vector2i()
	var data := []

	func _init(size: Vector2i) -> void:
		self.size = size
		data.resize(size.x * size.y)

		for x in size.x:
			data[x] = []
			data[x].resize(size.y)
			for y in size.y:
				data[x][y] = false

static func generate_random_grid(size: Vector2i) -> Grid:
	var grid := Grid.new(size)

	for x in size.x:
		for y in size.y:
			grid.data[x][y] = randi() % 2 as bool

	return grid

func count_living_neighbours(cell: Vector2i, cells: Array) -> int:
	var num_alive_neighbour_cells = 0

	# Check the cell's neighbours to determine its new state		
	for i in range(-1, 2):
		for j in range(-1, 2):
			# Don't check neighbour [0, 0] as that's the current cell
			if i == 0 and j == 0:
				continue

			var neighbour :Vector2i = Vector2i(cell.x + i, cell.y + j)
			# Efficient Bounds checking
			if 0 < neighbour.x and neighbour.x < cells.size() and \
				0 < neighbour.y and neighbour.y < cells[neighbour.x].size():
	
				# Finally, count neighbour cell if it's alive
				if cells[neighbour.x][neighbour.y] == true:
					num_alive_neighbour_cells += 1
	
	return num_alive_neighbour_cells

func next_iteration(current_cells: Array) -> Array:
	# Must reset living cell count

	var new_cells = []
	new_cells.resize(current_cells.size())

	for x in current_cells.size():
		new_cells[x] = []
		new_cells[x].resize(current_cells[x].size())

		for y in current_cells[x].size():
			var num_alive_neighbours = count_living_neighbours(Vector2i(x,y), current_cells)
			
			# Game of Life
			if current_cells[x][y]: # Cell is alive
				if num_alive_neighbours < 2 or 3 < num_alive_neighbours:
					# Cell dies
					new_cells[x][y] = false
				elif num_alive_neighbours == 2 or num_alive_neighbours == 3:
					# Cell is happy and remains alive
					new_cells[x][y] = true
			else: # Cell is dead
				if num_alive_neighbours == 3:
					# Cells reproduce to create a living cell
					new_cells[x][y] = true

	return new_cells
