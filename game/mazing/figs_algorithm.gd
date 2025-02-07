class_name FigsAlgorithm

# Figs' Reddit Response:
# https://www.reddit.com/r/gamedev/comments/5ecr87/what_maze_generation_algorithm_can_fill_a_maze/

const nDirections = 4

enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST,
}

class Cell:
	var position: Vector2i = Vector2i(0,0)
	var _active: bool = false

	## Prevent passing through the same cell twice during maze generation
	var visited := false

	func _init(position: Vector2i) -> void:
		self.position = position

	## Can we move into a neighbouring cell? By default, allow consideration of passage to neighbours
	var can_join = {
		Direction.NORTH : true,
		Direction.SOUTH: true,
		Direction.EAST: true,
		Direction.WEST: true,
	}


	## Is there a path in this direction? By default, paths in all directions are blocked
	var has_path = {
		Direction.NORTH : false,
		Direction.SOUTH: false,
		Direction.EAST : false,
		Direction.WEST : false,
	}

class Maze:
	var size: Vector2i
	var cells: Array[Cell]

	func _init(size: Vector2i = Vector2i(0, 0)) -> void:
		self.size = size
		cells.resize(size.x * size.y)

		for i in cells.size():
			cells[i] = Cell.new(_convert_1D_to_2D(i))

			# TODO: Testing that I can access the cells properly
			cells[i].active = randi() % 2 as bool
			
	func _convert_1D_to_2D(index: int) -> Vector2i:
		@warning_ignore("integer_division")
		var x: int = index / size.x
		var y: int  = index % size.y

		var position := Vector2i(x, y)
		return position

	func _convert_2D_to_1D(position: Vector2i) -> int:
		var index: int = (position.x * size.x) + position.y
		return index

	func get_cell(position: Vector2i) -> Cell:
		var index: int = _convert_2D_to_1D(position)
		return cells[index]

	func is_in_bounds(cell: Cell) -> bool:
		if (cell.position.x >= size.x or cell.position.x < 0 or
			cell.position.y >= size.y or cell.position.y < 0):
			return false

		return true

	## Returns the opposite direction from the input
	func mirror(direction: Direction) -> Direction:
		match direction:
			Direction.NORTH:
				return Direction.SOUTH
			Direction.SOUTH:
				return Direction.NORTH
			Direction.EAST:
				return Direction.WEST
			Direction.WEST:
				return Direction.EAST
			_:
				return direction

	## Returns the neighbouring point in the specified direction
	func get_neighbouring_cell(current_cell: Cell, direction: Direction) -> Cell:
		match direction:
			Direction.NORTH:
				return get_cell(Vector2i(current_cell.position.x, current_cell.position.y + 1))
			Direction.SOUTH:
				return get_cell(Vector2i(current_cell.position.x, current_cell.position.y - 1))
			Direction.EAST:
				return get_cell(Vector2i(current_cell.position.x + 1, current_cell.position.y))
			Direction.WEST:
				return get_cell(Vector2i(current_cell.position.x - 1, current_cell.position.y))
			_:
				return current_cell

	## Marks a path through the current cell and its neighbour in the indicated direction
	func make_path(current_cell: Cell, direction: Direction) -> void:
		if not is_in_bounds(current_cell):
			return

		# I dislike output params, but this is simpler
		current_cell.has_path[direction] = true

		var opposite_direction := mirror(direction)
		var neighbour_cell := get_neighbouring_cell(current_cell, direction)

		if not is_in_bounds(neighbour_cell):
			return
		
		neighbour_cell.has_path[opposite_direction] = true

	# Blocks a path through the current cell and its neighbour in the indicated direction.
	func break_path(current_cell: Cell, direction: Direction) -> void:
		if not is_in_bounds(current_cell):
			return

		current_cell.can_join[direction] = false
		current_cell.has_path[direction] = false

		var opposite_direction := mirror(direction)
		var neighbour_cell := get_neighbouring_cell(current_cell, direction)

		if not is_in_bounds(neighbour_cell):
			return

		neighbour_cell.can_join[opposite_direction] = false
		neighbour_cell.has_path[opposite_direction] = false
	
	func get_random_direction() -> Direction:
		var direction_index := randi() % Direction.size() 
		return direction_index as Direction


			
	func generate_maze(size: Vector2i, maze_seed: int = 0) -> void:
		const starting_position := Vector2i.ZERO
		var stack: Array[Cell] = []
		stack.resize(size.x * size.y)

		var starting_point := Cell.new(starting_position)
		stack.push_front(starting_point)













	
