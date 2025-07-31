extends CharacterBody2D

@export var speed := 600.0
@export var max_distance := 100.0

@export var gravity := 980.0

@export var lasso_pin = CharacterBody2D
@export var connected_critter = CharacterBody2D

var is_throwing := false
var is_returning := false
var is_connecting := false
var is_lassoed := false

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	var is_throw_beginning := Input.is_action_just_pressed(&"lasso") and not is_throwing and not is_returning

	if is_throw_beginning:
		visible = true
		velocity.x = speed
		is_throwing = true

	elif is_throwing:
		if velocity.x > 0.0:
			velocity.x -= (60.0 * delta)
		velocity.y += gravity * delta
		move_and_slide()

	elif is_returning:
		if position - lasso_pin.global_position < Vector2(1.0, 1.0):
			position = lasso_pin.global_position
			velocity = Vector2.ZERO
			is_returning = false
			visible = false
		else:
			var return_velocity : Vector2 = (lasso_pin.global_position - position)
			velocity = (return_velocity.normalized() * 100.0 * speed * delta)
			move_and_slide()

	elif is_connecting:
		if position - connected_critter.position < Vector2(1.0, 1.0):
			position = connected_critter.position
			velocity = Vector2.ZERO
			is_lassoed = true
			visible = false
		else:
			var connecting_velocity : Vector2 = (lasso_pin.global_position - position)
			velocity = (connecting_velocity.normalized() * 100.0 * speed * delta)
			move_and_slide()

	elif is_lassoed:
		position = connected_critter.position

	else:
		position = lasso_pin.global_position

func _on_critter_collision_body_entered(body: Node2D) -> void:
	connected_critter = body
	is_connecting = true

func _on_wall_collision_body_entered(_body: Node2D) -> void:
	if is_throwing:
		is_throwing = false
		is_returning = true
