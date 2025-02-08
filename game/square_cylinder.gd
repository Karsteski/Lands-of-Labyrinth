@tool
extends RigidBody3D

@onready var active := false

@export var lifetime: float = 10

@onready var in_editor := Engine.is_editor_hint()

func die() -> void:
	# If we free a Node in the editor, bad things happen :(
	if not in_editor:
		# print("I'm dead = ", randi())
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(die)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# TODO: Hardcoded height, needs to scale with the length of the cylinder
	if position.y > 5 and active:
		# Collide with floor
		# TODO: Rename these layers please lol
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		
