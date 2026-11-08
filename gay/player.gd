extends CharacterBody2D
@onready var sprite = $Animation

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 980.0
var ON_AIR = null

func _physics_process(delta):
	if not is_on_floor():
		ON_AIR = true
		velocity.y += GRAVITY * delta
	else:
		ON_AIR = false

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	velocity.x = direction * SPEED

	move_and_slide()
	
	if direction != 0:
		sprite.flip_h = direction < 0
		
		if sprite.animation != "fall" and ON_AIR:
			sprite.play("fall")
		elif sprite.animation != "walk" and not ON_AIR:
			sprite.play("walk")
	else:
		sprite.play("idle")
