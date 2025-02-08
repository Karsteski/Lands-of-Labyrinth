extends Node3D

# TODO: Hardcoded size, need to derive from dimensions of the map_floor
const grid_size :=  Vector2i(50, 50)

const max_iterations := 10

@export var cylinder: PackedScene = null
@export var enable_physics := false
@export var toggle := false
@export var initial_force_on_cylinder := Vector3(0, 1250, 0)

@onready var map_floor: StaticBody3D = $floor
@onready var maze: Maze = load("res://game/mazing/maze.gd").new(grid_size)

@onready var game_of_life_iterations := 0

func spawn_cylinder(location: Vector2) -> void:
	var cylinder_instance: RigidBody3D = cylinder.instantiate()
	map_floor.add_child(cylinder_instance)

	# Must undo the offset. This could be better structured...
	var grid_location := Vector2i(location - Vector2(0.5, 0.5))

	# Coordinate space transform to make (0, 0) the bottom left of the floor
	location += Vector2(grid_size / -2.0) 

	cylinder_instance.lock_rotation = true
	cylinder_instance.position = Vector3(location.x, 0.0, location.y)
	cylinder_instance.apply_central_force(initial_force_on_cylinder * Vector3(0.0, randf_range(0.5, 1.0), 0.0))
	cylinder_instance.active = maze.current_grid.data[grid_location.x][grid_location.y] 
	# print("coords = ", grid_location, " - ", maze.current_grid.data[grid_location.x][grid_location.y])

func generate_cylinder_grid() -> void:
	const cell_center_offset := Vector2(0.5, 0.5)

	for i in range(grid_size.x):
		for j in range(grid_size.y):
			var spawn_point := Vector2(i, j) + cell_center_offset
			spawn_cylinder(spawn_point)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		PhysicsServer3D.set_active(enable_physics)

	if game_of_life_iterations < max_iterations:
		maze.game_of_life()
		game_of_life_iterations += 1
		# print("iteration #", game_of_life_iterations)
		
	if toggle and game_of_life_iterations == max_iterations:
		print("generating cylinder grid, please wait...")
		generate_cylinder_grid()
		toggle = false
