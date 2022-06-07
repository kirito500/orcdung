extends KinematicBody2D

signal death

var velocity = Vector2(0,0)
var gravity = 1000
var trust = 50
var jump = 400
var max_speed = 400

var health = 50
var health_max = 50


func _ready():
	pass


func _process(delta):
	velocity.y += gravity
	
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < -max_speed:
		velocity.x = -max_speed
	
	if is_on_floor():
		velocity.x -= 0
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.normal)
	velocity = move_and_slide(velocity, Vector2.UP) 


func hit(damage):
	health -= damage
	if health > 0:
		$AnimationPlayer.play("hit")
	else:
		set_process(false)
		$AnimatedSprite.play("death")
		emit_signal("death")
		$CollisionShape2D.disabled = true
