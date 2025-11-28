extends CharacterBody2D

const SPEED = 125.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#Exemplo TIMEOUT / await
	#await get_tree().create_timer(3.0).timeout
	var direction := Input.get_vector("left", "right", "up", "down")
	if !Input.is_action_pressed("left") && !Input.is_action_pressed("right") && !Input.is_action_pressed("up") && !Input.is_action_pressed("down"):
		direction = Vector2.ZERO
		$AnimatedSprite2D.play("idle")

	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
	
	if Input.is_action_pressed("left"):
		$AnimatedSprite2D.play("walk_left")
	elif Input.is_action_pressed("right"):
		$AnimatedSprite2D.play("walk_right")
	elif Input.is_action_pressed("up"):
		$AnimatedSprite2D.play("walk_up")
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.play("walk_down")

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if (body.name == "farmer_main"):
		get_tree().change_scene_to_file.bind("res://scenes/house_interior.tscn").call_deferred()
	elif (body.name == "farmer_interior"):
		get_tree().change_scene_to_file.bind("res://scenes/main_scene.tscn").call_deferred()
