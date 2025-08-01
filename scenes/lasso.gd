extends CharacterBody2D

@export var speed := 600.0
@export var max_distance := 100.0

@export var gravity := 980.0

@export var cowpoke: CharacterBody2D
@export var lasso_pin: Node2D
@export var connected_critter: CharacterBody2D

var is_flipped := false:
	set(value):
		if value:
			flip_left()
		elif not value:
			flip_right()
		is_flipped = value
var is_throwing := false
var is_returning := false
var is_connecting := false
var is_lassoed := false

#func _ready() -> void:
	#visible = false

func _physics_process(delta: float) -> void:
	var is_throw_beginning := Input.is_action_just_pressed(&"lasso") and not is_throwing and not is_returning

	if is_throw_beginning:
		#visible = true
		if not is_flipped:
			velocity.x = speed
		elif is_flipped:
			velocity.x = speed * -1.0
		is_throwing = true

	elif is_throwing:
		if velocity.x >= 0.0 and not is_flipped:
			velocity.x -= (60.0 * delta)
		elif velocity.x <= 0.0 and is_flipped:
			velocity.x += (60.0 * delta)
		velocity.y += gravity * delta
		move_and_slide()

	elif is_returning:
		if position - lasso_pin.global_position < Vector2(1.0, 1.0):
			position = lasso_pin.global_position
			velocity = Vector2.ZERO
			is_returning = false
			#visible = false
		else:
			var return_velocity : Vector2 = (lasso_pin.global_position - position)
			velocity = (return_velocity.normalized() * 100.0 * speed * delta)
			move_and_slide()

	elif is_connecting:
		if position - connected_critter.position < Vector2(1.0, 1.0):
			position = connected_critter.position
			velocity = Vector2.ZERO
			is_lassoed = true
			#visible = false
		else:
			var connecting_velocity : Vector2 = (lasso_pin.global_position - position)
			velocity = (connecting_velocity.normalized() * 100.0 * speed * delta)
			move_and_slide()

	elif is_lassoed:
		position = connected_critter.position

	else:
		is_flipped = cowpoke.is_flipped
		position = lasso_pin.global_position

func flip_left() -> void:
	$LassoSprite.scale = Vector2(-1.0, 1.0)
	$RopePin.position = Vector2(-3.0, -3.0)

func flip_right() -> void:
	$LassoSprite.scale = Vector2(1.0, 1.0)
	$RopePin.position = Vector2(3.0, -3.0)

func _on_critter_collision_body_entered(body: Node2D) -> void:
	connected_critter = body
	is_connecting = true

func _on_wall_collision_body_entered(_body: Node2D) -> void:
	if is_throwing:
		is_throwing = false
		is_returning = true
