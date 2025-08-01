extends CharacterBody2D

@export var speed := 10000.0

@export var jump_strength := 490.0
@export var gravity := 980.0

var is_sliding := false
var _slide_velocity := 0.0

func _physics_process(delta: float) -> void:
	var _horizontal_direction = Input.get_axis(&"left", &"right")

	velocity.x = (_horizontal_direction * speed * delta)
	velocity.y += (gravity * delta)

	var is_crouching := is_on_floor() and Input.get_action_strength("down")
	var is_jump_starting := Input.is_action_just_pressed(&"jump") and is_on_floor() and not is_crouching
	var is_slide_starting := Input.is_action_just_pressed(&"jump") and is_crouching
	var is_jumping := velocity.y < 0.0 and not is_on_floor()
	var is_falling := velocity.y >= 0.0 and not is_on_floor()
	var is_walking := is_on_floor() and not is_zero_approx(velocity.x)
	var is_idling := is_on_floor() and velocity.x < 1.0

	if is_jump_starting:
		velocity.y -= jump_strength

	if not is_crouching and not is_sliding:
		move_and_slide()
		if is_walking:
			$CowpokeSprite.play("walk")
		elif is_idling:
			$CowpokeSprite.play("idle")
		elif is_jumping:
			$CowpokeSprite.play("idle")
		elif is_falling:
			$CowpokeSprite.play("idle")

	elif is_crouching and not is_sliding:
		$CowpokeSprite.play("crouch")
		if is_slide_starting:
			_slide_velocity = 1000.0
			is_sliding = true

	elif is_sliding:
		$CowpokeSprite.play("slide")
		if _slide_velocity <= 0.0:
			_slide_velocity = 0.0
			is_sliding = false
		else:
			velocity.x = _slide_velocity
			move_and_slide()
			_slide_velocity -= 4000.0 * delta
