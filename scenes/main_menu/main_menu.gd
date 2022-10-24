extends CenterContainer

@export var _2d_scene: PackedScene
@export var _3d_scene: PackedScene

@export var _2d_button: Button
@export var _3d_button: Button

func _ready()->void:
	_2d_button.pressed.connect(_on_scene_button_pressed.bind(_2d_scene))
	_3d_button.pressed.connect(_on_scene_button_pressed.bind(_3d_scene))

func _on_scene_button_pressed(scene:PackedScene)->void:
	get_tree().change_scene_to_packed(scene)
