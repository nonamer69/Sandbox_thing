extends CharacterBody2D

@onready var animationSprite = $Animation
@onready var healthBar = $GUI/Health/HealthBar
@onready var healthLabel = $GUI/Health/HealthLabel
@onready var inventory_ui = $GUI/Inv_UI

@export var inv: Inv = preload("res://Inventory/playerinv.tres")

var SPEED = 0.0
const MAX_SPEED = 75.0
const ACCEL = [900.0,200.0]
const DECEL = [600.0,125.0]
const JUMP_VELOCITY = -225.0
const GRAVITY = 980.0
var DEAD = false
var facing_right := true

const SPAWN = Vector2.ZERO

func _physics_process(delta):
	#Movement
	
	var direction = Input.get_axis("left", "right")
	
	if direction == 1:
		facing_right = true
	elif direction == -1:
		facing_right = false
	
	if not DEAD:
		if !is_on_floor():
			velocity.y += GRAVITY * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if is_on_floor():
			if direction != 0:
				velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCEL[0] * delta)
			else:
				velocity.x = move_toward(velocity.x, 0.0, DECEL[0] * delta)
		else:
			if direction != 0:
				velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCEL[1] * delta)
			else:
				velocity.x = move_toward(velocity.x, 0.0, DECEL[1] * delta)
		
		if direction != 0:
			animationSprite.flip_h = direction < 0
			
			if animationSprite.animation != "fall" and not is_on_floor():
				animationSprite.play("fall")
			elif animationSprite.animation != "walk" and is_on_floor():
				animationSprite.play("walk")
		else:
			animationSprite.play("idle")
		
		move_and_slide()
	
	#Health
	
	healthLabel.text = 'Health: ' + str(int(healthBar.value))
	
	var fill_style = healthBar.get_theme_stylebox('fill')
	
	if position.y >= 512:
		healthBar.value = 0.0
	
	if healthBar.value >= 75:
		fill_style.bg_color = Color.GREEN
		
	elif healthBar.value >= 50 and healthBar.value < 75:
		fill_style.bg_color = Color.YELLOW
		
	elif healthBar.value >= 25 and healthBar.value < 50:
		fill_style.bg_color = Color.ORANGE
		
	else:
		fill_style.bg_color = Color.RED
		
	if healthBar.value <= 0 and not DEAD:
		DEAD = true
		animationSprite.visible = false

		await get_tree().create_timer(3.0).timeout
		
		position = SPAWN
		velocity = Vector2.ZERO
		healthBar.value = 100

		animationSprite.visible = true
		DEAD = false

	#Inventory
	
	var slots = inventory_ui.get_children()
	var selectors := []
	
	for slot in slots:
		selectors.append(slot.get_child(1))

	if Input.is_action_just_pressed("slot1"):
		inv.hovered = 0
	elif Input.is_action_just_pressed("slot2"):
		inv.hovered = 1
		
	for i in selectors.size():
		selectors[i].visible = (i == inv.hovered)
		
	if Input.is_action_just_pressed("drop") and inv.items[inv.hovered] != null:
		var path = load(inv.items[inv.hovered].path)
		var item = path.instantiate()

		get_tree().current_scene.add_child(item)
		if facing_right:
			item.position = position - Vector2(-7,10)
			item.linear_velocity = Vector2(75,-75)
		else:
			item.position = position - Vector2(7,10)
			item.linear_velocity = Vector2(-75,-75)
			
		inv.items[inv.hovered] = null
		inventory_ui.update_slots()
