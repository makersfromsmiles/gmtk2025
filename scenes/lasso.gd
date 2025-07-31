extends CharacterBody2D

@export var speed := 600.0
@export var max_distance := 100.0
#@export var return_duration := 30.0

@export var gravity := 980.0

@export var rancher = CharacterBody2D

var is_throwing := false
var is_returning := false

func _physics_process(delta: float) -> void:
	var is_throw_beginning := Input.is_action_just_pressed(&"lasso") and not is_throwing and not is_returning
	if is_throw_beginning:
		velocity.x = speed
		is_throwing = true

	elif is_throwing:
		if velocity.x > 0.0:
			velocity.x -= (60.0 * delta)
		velocity.y += gravity * delta
		move_and_slide()

	elif is_returning:
		#testtest()

		#position = position.lerp(rancher.position, 6.0 * delta)
		#if position - rancher.position < Vector2(1.0, 1.0):
			#position = rancher.position
			#is_returning = false

		#if is_equal_approx(position.x, rancher.position.x) and is_equal_approx(position.y, rancher.position.y):
			#position = rancher.position
			#is_returning = false
		#else:
			#position.lerp(rancher.position, 0.5)

		if position - rancher.position < Vector2(1.0, 1.0):
			position = rancher.position
			velocity = Vector2.ZERO
			is_returning = false
		else:
			var return_velocity : Vector2 = (rancher.position - position)
			velocity = (return_velocity.normalized() * 100.0 * speed * delta)
			move_and_slide()

	else:
		position = rancher.position

func testtest() -> void:
	var icon = Sprite2D.new()
	$LassoSprite.texture = icon

#func return_to_rancher() -> void:
		#var tween := create_tween()
		#tween.set_trans(Tween.TRANS_CUBIC)
		#tween.tween_property(self, ^":position", rancher.position, return_duration)
		#await tween.finished
		#is_returning = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if is_throwing:
		is_throwing = false
		is_returning = true
