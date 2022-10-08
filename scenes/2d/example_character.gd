extends Node2D

const SPEED: float = 100.0

var player_id


var _move_input: Vector2



func _ready()->void:
#	GGInput.create_player(player_id, load("res://test_profile.inputprofile"), [GGInput.DEVICE_KEYBOARD, GGInput.DEVICE_MOUSE])
	GGInput.connect_input(player_id, "gameplay_move", self, "_on_gameplay_move")


func _physics_process(delta:float)->void:
	translate(delta * SPEED * _move_input)


func _on_gameplay_move(input:Vector2)->void:
	_move_input = input
