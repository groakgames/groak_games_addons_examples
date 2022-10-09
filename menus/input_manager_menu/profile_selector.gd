extends Node

export(NodePath) onready var load_file_dialog = get_node(load_file_dialog) as FileDialog
export(NodePath) onready var file_path_line_edit = get_node(file_path_line_edit) as LineEdit

func get_selected_file_path()->String:
	return file_path_line_edit.text

func _ready()->void:
	load_file_dialog.set_as_toplevel(true)


func _on_file_selected(path:String)->void:
	file_path_line_edit.text = path


func _on_load_file_button_pressed()->void:
	load_file_dialog.show()

