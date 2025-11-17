extends Node2D


var strawberry = preload("res://scenes/strawberry.tscn")

var time

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time = Time.get_datetime_dict_from_system()
	$farmer/Label.text = str("%02d"%time.hour, ":", "%02d"%time.minute)
	
	if Input.is_key_pressed(KEY_E):
		var instance = strawberry.instantiate()
		instance.position = get_global_mouse_position()
		add_child(instance)
