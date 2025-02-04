@tool
extends Node3D

@export var cylinder: PackedScene = null
@export var enable_physics := false
@export var toggle := false

@onready var map_floor: StaticBody3D = $floor


func spawn_cylinder(location: Vector2) -> void:
	var cylinder_instance = cylinder.instantiate()
	map_floor.add_child(cylinder_instance)
	cylinder_instance.position = Vector3(0, 12, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		PhysicsServer3D.set_active(enable_physics)

	if toggle:
		spawn_cylinder(Vector2.ZERO)
		toggle = false
