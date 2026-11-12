extends RigidBody2D

@onready var inv: Inv = preload("res://Inventory/playerinv.tres")
@onready var stone: InvItem = preload("res://Inventory/items/Stone/stone.tres")
@onready var inserted := false
@onready var inventory_ui = $"../Player/GUI/Inv_UI"
@onready var player = $"../Player"

signal update_slots

func _ready():
	input_pickable = true

func _input_event(_viewport,event,_shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if inv.items[inv.hovered] == null:
				var distance = player.global_position.distance_to(position)
				if distance <= 25:
					inv.items[inv.hovered] = stone
					inventory_ui.update_slots()
					queue_free()
					
func _physics_process(delta):
	if position.y >= 512:
		queue_free()
