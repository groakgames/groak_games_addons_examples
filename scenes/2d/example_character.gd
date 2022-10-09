extends Node2D

const SPEED: float = 100.0

var player_id


var _move_input: Vector2



func _ready()->void:
#	Gin.create_player(player_id, load("res://test_profile.inputprofile"), [Gin.DEVICE_KEYBOARD, Gin.DEVICE_MOUSE])
	Gin.connect_input(player_id, "gameplay_move", self, "_on_gameplay_move")


func _physics_process(delta:float)->void:
	translate(delta * SPEED * _move_input)


func _on_gameplay_move(input:Vector2)->void:
	_move_input = input
