extends Node2D

@export var speed := 600.0
@export var max_distance := 100.0

@export var gravity := 980.0

@export var cowpoke: CharacterBody2D
@export var lasso_point: Node2D
@export var rope_point: Node2D
@export var lasso_timer: Timer
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
#var is_lassoing := false
var is_lassoed := false

func _ready() -> void:
	$LassoLoop.position = lasso_point.global_position
	visible = false

func _physics_process(delta: float) -> void:
	#var is_throw_ready := not is_throwing and not is_returning and not is_lassoing and not is_lassoed
	var is_throw_ready := not is_throwing and not is_returning and not is_lassoed
	var is_throw_beginning := Input.is_action_just_pressed(&"lasso") and is_throw_ready

	if is_throw_beginning:
		lasso_timer.start()
		$LassoSfx.play()
		visible = true
		if not is_flipped:
			$LassoLoop.velocity.x = speed
		elif is_flipped:
			$LassoLoop.velocity.x = speed * -1.0
		is_throwing = true

	elif is_throwing:
		if $LassoLoop.velocity.x >= 0.0 and not is_flipped:
			$LassoLoop.velocity.x -= (60.0 * delta)
		elif $LassoLoop.velocity.x <= 0.0 and is_flipped:
			$LassoLoop.velocity.x += (60.0 * delta)
		$LassoLoop.velocity.y += gravity * delta
		$LassoLoop.move_and_slide()

	elif is_returning:
		#var is_almost_returned: bool = ($LassoLoop.position.distance_to(lasso_point.global_position) < 12.0 and not is_flipped) or ($LassoLoop.position.distance_to(lasso_point.global_position- Vector2(32.0, 0.0)) < 12.0 and is_flipped)
		var is_returned: bool = ($LassoLoop.position.distance_to(lasso_point.global_position) < 12.0 and not is_flipped) or ($LassoLoop.position.distance_to(lasso_point.global_position- Vector2(32.0, 0.0)) < 12.0 and is_flipped)
		if is_returned:
			$LassoLoop.position = lasso_point.global_position
			$LassoLoop.velocity = Vector2.ZERO
			is_returning = false
			visible = false
		#elif is_almost_returned:
			#var return_velocity: Vector2
			#if is_flipped:
				#return_velocity = ((lasso_point.global_position - Vector2(32.0, 0.0)) - $LassoLoop.position)
			#else:
				#return_velocity = (lasso_point.global_position - $LassoLoop.position)
			#$LassoLoop.velocity = (return_velocity.normalized() * speed * delta)
			#$LassoLoop.move_and_slide()
		else:
			var return_velocity: Vector2
			if is_flipped:
				return_velocity = ((lasso_point.global_position - Vector2(32.0, 0.0)) - $LassoLoop.position)
			else:
				return_velocity = (lasso_point.global_position - $LassoLoop.position)
			$LassoLoop.velocity = (return_velocity.normalized() * 50.0 * speed * delta)
			$LassoLoop.move_and_slide()

	#elif is_lassoing:
		#if $LassoLoop.position.distance_to(connected_critter.global_position) < 3.0:
			#$LassoLoop.position = connected_critter.position
			#$LassoLoop.velocity = Vector2.ZERO
			#is_lassoed = true
			#visible = false
		#else:
			#var connecting_velocity : Vector2 = (connected_critter.global_position - $LassoLoop.position)
			#$LassoLoop.velocity = (connecting_velocity.normalized() * 100.0 * speed * delta)
			#$LassoLoop.move_and_slide()

	elif is_lassoed:
		$LassoLoop.position = connected_critter.position

	else:
		is_flipped = cowpoke.is_flipped
		if is_flipped:
			$LassoLoop.position = lasso_point.global_position - Vector2(32.0, 0.0)
		else:
			$LassoLoop.position = lasso_point.global_position

	$RopeLine.position = lasso_point.position + Vector2(0.0, 32.0)
	var rope_array := PackedVector2Array([lasso_point.global_position + Vector2(0.0, 20.0), rope_point.global_position])
	$RopeLine.points = rope_array

func flip_left() -> void:
	$LassoLoop/LassoSprite.scale = Vector2(-1.0, 1.0)
	rope_point.position = Vector2(29.0, -3.0)

func flip_right() -> void:
	$LassoLoop/LassoSprite.scale = Vector2(1.0, 1.0)
	rope_point.position = Vector2(3.0, -3.0)

func _on_wall_collision_body_entered(_body: Node2D) -> void:
	if is_throwing:
		is_throwing = false
		is_returning = true

func _on_lasso_timer_timeout() -> void:
	if is_throwing:
		is_throwing = false
		is_returning = true
