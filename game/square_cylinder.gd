@tool
extends RigidBody3D

@export var lifetime: float = 10

@onready var in_editor := Engine.is_editor_hint()

func die() -> void:
	# If we free a Node in the editor, bad things happen :(
	if not in_editor:
		print("I'm dead = ", randi())
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(die)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
