extends CharacterBody2D

@export var SPEED = 200

func _physics_process(delta):
	var input_vector: Vector2 = get_input_vector()
	velocity = SPEED * input_vector
	move_and_slide()
	
func get_input_vector() -> Vector2: 
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	return input_vector.normalized()
