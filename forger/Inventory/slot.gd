extends Sprite2D

@onready var item_visual: Sprite2D = $item_display

func update(item: InvItem):
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
		if item.size.x != 0 or item.size.y != 0:
			item_visual.scale = Vector2.ONE/item_visual.get_rect().size*item.size
