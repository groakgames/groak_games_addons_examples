extends CenterContainer

export var _2d_scene: PackedScene
export var _3d_scene: PackedScene

export var _2d_button_path: NodePath
onready var _2d_button: Button = get_node(_2d_button_path)
export var _3d_button_path: NodePath
onready var _3d_button: Button = get_node(_3d_button_path)

func _ready()->void:
	_2d_button.connect("pressed", self, "_on_scene_button_pressed", [_2d_scene])
	_3d_button.connect("pressed", self, "_on_scene_button_pressed", [_3d_scene])

func _on_scene_button_pressed(scene:PackedScene)->void:
	get_tree().change_scene_to(scene)
