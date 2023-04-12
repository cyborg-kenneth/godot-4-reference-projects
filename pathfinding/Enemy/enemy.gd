extends CharacterBody2D

@export var speed = 180

var target_position: Vector2

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

var player = null

func _ready():
	navigation_agent.path_desired_distance = 4
	navigation_agent.target_desired_distance = 4
	call_deferred("actor_setup")
	
func actor_setup(): 
	await  get_tree().physics_frame
	set_movement_target(global_position)
	
func set_movement_target(value): 
	navigation_agent.target_position = value

func _physics_process(delta):
	if player == null: 
		var game = get_tree().current_scene
		player = game.player
		return
	#if navigation_agent.is_navigation_finished(): 
	#	print("Navigation Finished")
	#	return
	#set_movement_target(player.global_position)
	var current_agent_position: Vector2 = global_transform.origin
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized()
	velocity = speed * new_velocity
	move_and_slide()


func _on_timer_timeout():
	print("HI")
	if player != null: 
		set_movement_target(player.global_position)
