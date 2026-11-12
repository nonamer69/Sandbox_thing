extends CanvasLayer

@onready var player = $".."

func _process(_delta):
	offset = player.get_global_transform_with_canvas().origin.round()
