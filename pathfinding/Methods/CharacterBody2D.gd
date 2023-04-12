extends CharacterBody2D

var movement_speed: float = 200

var movement_target_position: Vector2 = Vector2(580, 50)

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

func _ready():
	navigation_agent.path_desired_distance = 4
	navigation_agent.target_desired_distance = 4
	call_deferred("actor_setup")

func actor_setup(): 
	await  get_tree().physics_frame
	
	set_movement_target(movement_target_position)

func set_movement_target(value: Vector2): 
	navigation_agent.target_position = value
	
func _physics_process(delta):
	print("H")
	if navigation_agent.is_navigation_finished(): 
		return
	print("HO")
	
	var current_agent_position: Vector2 = global_transform.origin
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	velocity = new_velocity * movement_speed
	move_and_slide()
	pass
