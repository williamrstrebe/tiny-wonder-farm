extends CharacterBody2D


const SPEED = 125.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#Exemplo TIMEOUT / await
	#await get_tree().create_timer(3.0).timeout
	
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")
		
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_left"):
		$AnimatedSprite2D.play("walk_left")
	if Input.is_action_just_pressed("ui_right"):
		$AnimatedSprite2D.play("walk_right")
		
		
