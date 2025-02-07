@tool
extends Node2D

var figs_algorithm: FigsAlgorithm = preload("res://game/mazing/figs_algorithm.gd").new()

const CELL_SIZE := 10
var maze: FigsAlgorithm.Maze



func generate_cells(num_x: int, num_y: int) -> Array:
	var cells = []

	for x in range(num_x):
		cells.append([])
		cells[x].resize(num_y)

		for y in range(num_y):
			# Randomly set cells to white or black
			cells[x][y] = (randi() % 2) as bool

	return cells


func _ready():
	var dimensions: Vector2 = get_viewport().get_visible_rect().size

	# Massive assumption here that dimensions are equally divisible by CELL_SIZE
	@warning_ignore("integer_division")
	var num_x: int = int(dimensions.x) / CELL_SIZE
	@warning_ignore("integer_division")
	var num_y: int = int(dimensions.y) / CELL_SIZE

	var size := Vector2i(5, 5)

	var figgy = FigsAlgorithm.new()
	maze = figgy.generate_maze(size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw():
	for x in maze.size.x:
		for y in maze.size.y:
			draw_rect(Rect2(x * CELL_SIZE, y * CELL_SIZE,
				CELL_SIZE, CELL_SIZE),
				Color.WHITE if maze.get_cell(Vector2i(x,y))._active else Color.BLACK)
