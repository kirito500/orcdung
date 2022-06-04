extends KinematicBody2D

export var move_speed := 100
export var gravity := 2000
export var jump_speed := 550

var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# reset horizontal velocity
	velocity.x = 0

	# set horizontal velocity
	if Input.is_action_pressed("right"):
		velocity.x += move_speed
	if Input.is_action_pressed("left"):
		velocity.x -= move_speed
		
		

	# apply gravity
	# player always has downward velocity
	velocity.y += gravity * delta

	# actually move the player
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("space"):
		if is_on_floor():
			velocity.y = -jump_speed # negative Y is up in Godot
