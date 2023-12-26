extends CharacterBody2D


const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()
var tween = null

func _ready():
	velocity.y = JUMP_VELOCITY
	var x = rng.randf_range(-200,200)
	velocity.x = x
	tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 0), 1.0)
	tween.tween_callback(queue_free)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
