extends CharacterBody2D

@export var gravity := 980.0

func _physics_process(delta: float) -> void:
	velocity.y += (gravity * delta)
	move_and_slide()
