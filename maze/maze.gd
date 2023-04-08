extends Node2D

const HEIGHT = 6
const WIDTH = 8

var rooms = []
var visited = []
var unvisited_count = 0
var stack = []

var start_room: Vector2

var max_depth = 0: set = set_max_depth
var deepest_room = Vector2.ZERO

var current_x: int
var current_y: int

func set_max_depth(value): 
	max_depth = clamp(value, 0, HEIGHT * WIDTH)
	deepest_room = Vector2(current_x, current_y)

func _ready():
	for i in range(HEIGHT): 
		rooms.append([])
		visited.append([])
		for j in range(WIDTH): 
			rooms[i].append(get_node("Room" + str(i * WIDTH + j + 1)))
			visited[i].append(false)
			unvisited_count += 1

func find_neighbors() -> Array: 
	var neighbors = []
	if current_x > 0 and not visited[current_y][current_x - 1]: 
		neighbors.append(Vector2(current_x - 1, current_y))
	if current_x < WIDTH - 1 and not visited[current_y][current_x + 1]: 
		neighbors.append(Vector2(current_x + 1, current_y))
	if current_y > 0 and not visited[current_y - 1][current_x]: 
		neighbors.append(Vector2(current_x, current_y - 1))
	if current_y < HEIGHT - 1 and not visited[current_y + 1][current_x]: 
		neighbors.append(Vector2(current_x, current_y + 1))
	return neighbors
	
func update_room(next_room: Vector2): 
	if next_room.x < current_x: 
		rooms[current_y][current_x].west.visible = false
		rooms[next_room.y][next_room.x].east.visible = false
	if next_room.x > current_x: 
		rooms[current_y][current_x].east.visible = false
		rooms[next_room.y][next_room.x].west.visible = false
	if next_room.y < current_y: 
		rooms[current_y][current_x].north.visible = false
		rooms[next_room.y][next_room.x].south.visible = false
	if next_room.y > current_y: 
		rooms[current_y][current_x].south.visible = false
		rooms[next_room.y][next_room.x].north.visible = false

func walk(): 
	print("Walk")
	start_room = Vector2(randi_range(0, WIDTH - 1), randi_range(0, HEIGHT - 1))
	current_x = start_room.x
	current_y = start_room.y
	var current_depth = 0
	while unvisited_count > 0: 
		await get_tree().create_timer(0.2).timeout
		if not visited[current_y][current_x]: 
			if current_depth > max_depth: 
				self.max_depth = current_depth
			visited[current_y][current_x] = true
			rooms[current_y][current_x].visible = true
			unvisited_count -= 1
			stack.append(Vector2(current_x, current_y))
		var neighbors = find_neighbors()
		if neighbors.size() > 0: 
			current_depth += 1
			var n = randi_range(0, neighbors.size() - 1)
			var next_room = neighbors[n]
			update_room(next_room)
			current_x = next_room.x
			current_y = next_room.y
		else: 
			current_depth -= 1
			var prev = stack.pop_back()
			current_x = prev.x
			current_y = prev.y
	
func _on_ready():
	walk()
