extends Node2D

const SPEED: float = 100.0

var player_id


var _move_input: Vector2



func _ready()->void:
	Gin.connect_input_unhandled(player_id, "gameplay_move", self, "_on_gameplay_move")
	Gin.connect_input(player_id, "gameplay_move", self, "_on_gameplay_move_")

func _physics_process(delta:float)->void:
	translate(delta * SPEED * _move_input)


func _on_gameplay_move_(input:Vector2, event:InputEvent, is_absoulute:bool)->void:
	if is_absoulute:
		position = input
	else:
		translate(input)

func _on_gameplay_move(input:Vector2, event:InputEvent, is_absoulute:bool)->void:
	if not is_absoulute:
		_move_input = input

