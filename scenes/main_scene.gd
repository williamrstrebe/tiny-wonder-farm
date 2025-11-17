extends Node2D


var strawberry = preload("res://scenes/strawberry.tscn")


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_E):
		var instance = strawberry.instantiate()
		instance.position = get_global_mouse_position()
		add_child(instance)
