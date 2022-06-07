
extends KinematicBody2D

const max_speed = 400

var target = null
onready var _animated_sprite = $AnimatedSprite
var velocity = Vector2(0,-1)
var trust = 50
var jump = 400
var gravity = 10
var rightarea = []
var leftarea = []
var last_attack_time = 0

var moving = false
var attack_playing = false
var crouch = false

var attack_cooldown_time = 1000
var next_attack_time = 0
var combo_time = 1000
var combo = 1
var max_combo = 2
var attack_damage = 30
var max_crouch_speed = 200

var health = 100
var health_max = 100


func _process(delta):
	
	if _animated_sprite.animation != "attack" and _animated_sprite.animation != "attack2" and _animated_sprite.animation != "crouch_attack":
		attack_playing = false
		
	velocity.y += gravity
	
	var max_sped = 0
	$stay_shape.disabled = crouch
	$crouch_shape.disabled = !crouch
	if crouch:
		max_sped = max_crouch_speed
	else:
		max_sped = max_speed
	
	if velocity.x > max_sped:
		velocity.x = max_sped
	elif velocity.x < -max_sped:
		velocity.x = -max_sped
		
	if is_on_floor() and !moving:
		velocity.x -= velocity.x*0.2
	
	#print(combo)
	
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.normal)
	velocity = move_and_slide(velocity, Vector2.UP) 
	
	get_input()
	

func get_input():
	if Input.is_action_pressed("right"):
		
		if is_on_floor():
			if !attack_playing:
				if crouch:
					_animated_sprite.play("crouch_walk")
				else:
					_animated_sprite.play("run")
				velocity.x += trust
		else:
			if !attack_playing:
				_animated_sprite.play("jump")
				velocity.x += trust*0.1
		moving = true
		_animated_sprite.flip_h = false
		
	elif Input.is_action_pressed("left"):
		
		if is_on_floor():
			if !attack_playing:
				if crouch:
					_animated_sprite.play("crouch_walk")
				else:
					_animated_sprite.play("run")
				velocity.x -= trust
		else:
			if !attack_playing:
				_animated_sprite.play("jump")
				velocity.x -= trust*0.1
		moving = true
		_animated_sprite.flip_h = true
		
	elif is_on_floor(): 
		if !attack_playing:
			if crouch:
				_animated_sprite.play("crouch_idle")
			else:
				_animated_sprite.play("stay")
		moving = false
	elif !is_on_floor() and !attack_playing: 
		_animated_sprite.play("jump")
	
	if Input.is_action_pressed("mouse_left") and _animated_sprite.animation != "attack" and _animated_sprite.animation != "attack2" and _animated_sprite.animation != "crouch_attack":
		attack()
		
	if Input.is_action_pressed("space") and is_on_floor():
		if !attack_playing:
			_animated_sprite.play("jump")
			velocity.y -= jump
	
	if Input.is_action_just_pressed("ctrl"):
		if crouch:
			crouch = false
		else:
			crouch = true


func attack():
		var now = OS.get_ticks_msec()
		if !attack_playing:
			if crouch:
				if _animated_sprite.flip_h:
					for target in leftarea:
						if target != null:
							target.hit(attack_damage)
				else:
					for target in rightarea:
						if target != null:
							target.hit(attack_damage)
				_animated_sprite.play("crouch_attack")
			else:
				if now < last_attack_time + combo_time:
					combo += 1
				else:
					combo = 1
				
				if combo > max_combo:
					combo = 1
				
				if combo == 2:
					if _animated_sprite.flip_h:
						for target in leftarea:
							if target != null:
								target.hit(attack_damage+attack_damage*0.1*combo)
					else:
						for target in rightarea:
							if target != null:
								target.hit(attack_damage+attack_damage*0.1*combo)
					_animated_sprite.play("attack2")
				else: 
					if _animated_sprite.flip_h:
						for target in leftarea:
							if target != null:
								target.hit(attack_damage)
					else:
						for target in rightarea:
							if target != null:
								target.hit(attack_damage)
					_animated_sprite.play("attack")
			
			attack_playing = true
			last_attack_time = now


	
func hit(damage):
	health -= damage
	if health > 0:
		$AnimationPlayer.play("hit")
		$AnimatedSprite.play("hit")
	else:
		set_process(false)
		$AnimatedSprite.play("death")
		emit_signal("death")
		$stay_shape.disabled = true
		$crouch_shape.disabled = true
	


func _on_Area2D2_body_entered(body):
	if body.name != "TileMap" and body.name != "player":
		leftarea.append(body)


func _on_Area2D2_body_exited(body):
	var e = 0
	for obj in leftarea:
		if obj.name == body.name:
			leftarea.remove(e)
		e += 1

func _on_Area2D_body_entered(body):
	if body.name != "TileMap" and body.name != "player":
		rightarea.append(body)


func _on_Area2D_body_exited(body):
	var e = 0
	for obj in rightarea:
		if obj.name == body.name:
			rightarea.remove(e)
		e += 1


func _on_AnimatedSprite_animation_finished():
	if _animated_sprite.animation == "attack":
		attack_playing = false
	elif _animated_sprite.animation == "attack2":
		attack_playing = false
	if _animated_sprite.animation == "crouch_attack":
		attack_playing = false
		


func _on_Area2D3_body_entered(body):
	#print(body.name)
	if body.name == "skeleton" or body.name == "skeleton1" or body.name == "skeleton2" or body.name == "skeleton3" or body.name == "skeleton4"or body.name == "skeleton5":
		if true:
			velocity.x -= trust
			velocity.y += 30
		else:
			velocity.x += trust
			velocity.y -= 10
			
		var collision = move_and_collide(velocity * 1)
		if collision:
			velocity = velocity.slide(collision.normal)
		velocity = move_and_slide(velocity, Vector2.UP) 
		hit(30)
		