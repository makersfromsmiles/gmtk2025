extends CharacterBody2D

@export var speed := 10000.0

@export var jump_strength := 490.0
@export var gravity := 980.0

func _physics_process(delta: float) -> void:
	var _horizontal_direction = Input.get_axis(&"left", &"right")

	velocity.x = (_horizontal_direction * speed * delta)
	velocity.y += (gravity * delta)

	var is_falling := velocity.y > 0.0 and not is_on_floor()
	var is_jumping := Input.is_action_just_pressed(&"jump") and is_on_floor()
	var is_idling := is_on_floor() and is_zero_approx(velocity.x)
	var is_moving := is_on_floor() and not is_zero_approx(velocity.x)

	if is_jumping:
		velocity.y -= jump_strength

	move_and_slide()
