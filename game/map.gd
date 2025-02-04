@tool
extends Node3D

@export var cylinder: PackedScene = null
@export var enable_physics := false
@export var toggle := false
@export var initial_force_on_cylinder := Vector3(0, 100, 0)

@onready var map_floor: StaticBody3D = $floor
# @onready var cylinder_collider: StaticBody3D = $cylinder_collider

# TODO: Hardcoded size, need to derive from dimensions of the map_floor
const grid_size :=  Vector2i(10, 10)


func spawn_cylinder(location: Vector2) -> void:
	var cylinder_instance: RigidBody3D = cylinder.instantiate()
	map_floor.add_child(cylinder_instance)

	# Coordinate space transform to make (0, 0) the bottom left of the floor
	location += Vector2(grid_size / -2.0) 

	cylinder_instance.position = Vector3(location.x, 0.0, location.y)
	cylinder_instance.apply_central_force(initial_force_on_cylinder * Vector3(0.0, randf_range(0.5, 1.0), 0.0))


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

	if toggle:
		generate_cylinder_grid()
		toggle = false
