extends CharacterBody2D

@export var gravity := 980.0
@export var lassoed_label: Label

func _ready() -> void:
	lassoed_label.visible = false

func _physics_process(delta: float) -> void:
	velocity.y += (gravity * delta)
	move_and_slide()

func _on_lasso_detector_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.name == &"LassoLoop":
		body.connected_critter = self
		body.is_throwing = false
		body.is_lassoed = true
		body.visible = false
		lassoed_label.visible = true
