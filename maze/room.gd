extends Node2D

class_name Room

@onready var north = get_node("NorthWall")
@onready var south = get_node("SouthWall")
@onready var east = get_node("EastWall")
@onready var west = get_node("WestWall")
