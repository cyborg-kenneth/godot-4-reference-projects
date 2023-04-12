extends Node2D

var room_width: int
var room_height: int

var rooms: Array[Array] = []
var stack: Array[Vector2i] = []

@onready var tilemap: TileMap = get_node("TileMap")

var tiles = {
	"wall": Vector2i.ZERO, 
	"floor": Vector2i(1, 0), 
	"nav": Vector2i(2, 0)
}

enum {
	NORTH, 
	EAST,
	WEST, 
	SOUTH
}

func _ready():
	room_width = ProjectSettings.get("display/window/size/viewport_width")/64
	room_height = ProjectSettings.get("display/window/size/viewport_height")/64
	build_maze()
	
func build_room(room: Vector2i): 
	var xx = room.x
	var yy = room.y
	for i in range(4): 
		for j in range(4): 
			if i == 0 or i == 3 or j == 0 or j == 3:
				tilemap.set_cell(0, Vector2i(xx * 4 + i, yy * 4 + j), 0, tiles["wall"])
			else: 
				tilemap.set_cell(0, Vector2i(xx * 4 + i, yy * 4 + j), 0, tiles["floor"])
	if rooms[xx][yy] % 2 == 0: 
		#Check North
		tilemap.set_cell(0, Vector2(xx * 4 + 1, yy * 4), 0, tiles["floor"])
		tilemap.set_cell(0, Vector2(xx * 4 + 2, yy * 4), 0, tiles["floor"])
	if int(rooms[xx][yy] / 2) % 2 == 0: 
		#Check East
		tilemap.set_cell(0, Vector2(xx * 4 + 3, yy * 4 + 1), 0, tiles["floor"])
		tilemap.set_cell(0, Vector2(xx * 4 + 3, yy * 4 + 2), 0, tiles["floor"])
	if int(rooms[xx][yy] / 4) % 2 == 0: 
		#Check West
		tilemap.set_cell(0, Vector2(xx * 4, yy * 4 + 1), 0, tiles["floor"])
		tilemap.set_cell(0, Vector2(xx * 4, yy * 4 + 2), 0, tiles["floor"])
	if int(rooms[xx][yy] / 8) % 2 == 0: 
		#Check South
		tilemap.set_cell(0, Vector2(xx * 4 + 1, yy * 4 + 3), 0, tiles["floor"])
		tilemap.set_cell(0, Vector2(xx * 4 + 2, yy * 4 + 3), 0, tiles["floor"])
		
func erase_room(side: int, open: bool, valid_rooms: Array) -> Array: 
	for i in range(16): 
		if open: 
			if (int(i / (2 ** side)) % 2 == 1): 
				valid_rooms.erase(i)
		else: 
			if (int(i / (2 ** side)) % 2 == 0): 
				valid_rooms.erase(i)
	return valid_rooms
		
func get_valid_room_number(xx: int, yy: int): 
	var valid_rooms = range(15)
	
	if xx > 0: 
		if rooms[xx - 1][yy] != -1: 
			if int(rooms[xx - 1][yy] / 2) % 2 == 1: 
				print("HI")
				valid_rooms = erase_room(WEST, false, valid_rooms)
			else: 
				print("HO")
				valid_rooms = erase_room(WEST, true, valid_rooms)
	else: 
		print("Hu")
		valid_rooms = erase_room(WEST, false, valid_rooms)
	
	print("After West: " + str(valid_rooms))
	
	if xx < room_width - 1: 
		if rooms[xx + 1][yy] != -1: 
			if int(rooms[xx + 1][yy] / 4) % 2 == 1: 
				print("HI")
				valid_rooms = erase_room(EAST, false, valid_rooms)
			else: 
				print("HO")
				valid_rooms = erase_room(EAST, true, valid_rooms)
	else : 
		print("HA")
		valid_rooms = erase_room(EAST, false, valid_rooms)
	
	print("After East: " + str(valid_rooms))
	
	if yy > 0: 
		if rooms[xx][yy - 1] != -1: 
			if int(rooms[xx][yy - 1] / 8) % 2 == 1: 
				print("HI")
				valid_rooms = erase_room(NORTH, false, valid_rooms)
			else: 
				print("HO")
				valid_rooms = erase_room(NORTH, true, valid_rooms)
	else: 
		print("HA")
		valid_rooms = erase_room(NORTH, false, valid_rooms)
		
	print("After North: " + str(valid_rooms))
	
	if yy < room_height - 1: 
		if rooms[xx][yy + 1] != -1: 
			if int(rooms[xx][yy + 1] / 1) % 2 == 1: 
				print("HI")
				valid_rooms = erase_room(SOUTH, false, valid_rooms)
			else: 
				print("HO")
				valid_rooms = erase_room(SOUTH, true, valid_rooms)
	else: 
		print("HA")
		valid_rooms = erase_room(SOUTH, false, valid_rooms)
	
	print(str(rooms[xx][yy]) + ": " + str(valid_rooms))
	return valid_rooms.pick_random()
	
func get_neighbors(room: Vector2i) -> Array[Vector2i]: 
	var xx = room.x
	var yy = room.y
	
	var neighbors: Array[Vector2i] = []
	print("Room: " + str(room))
	if yy > 0 and rooms[xx][yy] % 2 == 0 and rooms[xx][yy - 1] == -1: 
		neighbors.append(Vector2i(xx, yy - 1))
	if xx < room_width -1 and int(rooms[xx][yy] / 2) % 2 == 0 and rooms[xx + 1][yy] == -1: 
		neighbors.append(Vector2i(xx + 1, yy))
	if xx > 0 and int(rooms[xx][yy] / 4) % 2 == 0 and rooms[xx - 1][yy] == -1: 
		neighbors.append(Vector2i(xx - 1, yy))
	if yy < room_height - 1 and int(rooms[xx][yy] / 8) % 2 == 0 and rooms[xx][yy + 1] == -1: 
		neighbors.append(Vector2i(xx, yy + 1))
	return neighbors

func build_maze(): 
	for i in range(room_width): 
		rooms.append([])
		for j in range(room_height): 
			rooms[i].append(-1)
	var current_room: Vector2i = Vector2i(randi() % room_width, randi() % room_height)
	#current_room = Vector2i.ZERO
	stack.append(current_room)
	var count = 0
	while stack.size() > 0: 
		current_room = stack.back()
		#If room is not visited
		var xx = current_room.x
		var yy = current_room.y
		await  get_tree().create_timer(0.1).timeout
		print("Current room: " + str(current_room))
		count += 1
		if rooms[xx][yy] == -1: 
			rooms[xx][yy] = get_valid_room_number(xx, yy)
			build_room(current_room)
			var neighbors = get_neighbors(current_room)
			if neighbors.size() > 0: 
				stack.append(neighbors.pick_random())
			else: 
				stack.pop_back()
		else: 
			var neighbors = get_neighbors(current_room)
			if neighbors.size() > 0: 
				stack.append(neighbors.pick_random())
			else: 
				stack.pop_back()
			pass
		print(stack)
		print("---")
