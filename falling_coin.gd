extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()
var direction = 1

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 0), 3.0)
	tween.tween_callback($Sprite2D.queue_free)
	direction = 1 if rng.randi_range(0,1) == 1 else -1


func _physics_process(delta):
	velocity.y += (gravity - 400) * delta
	velocity.x = 0

	rotation += deg_to_rad(2.0) * direction


	move_and_slide()	
