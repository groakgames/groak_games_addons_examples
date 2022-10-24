extends Node

@export var load_file_dialog: FileDialog
@export var file_path_line_edit: LineEdit

func get_selected_file_path()->String:
	return file_path_line_edit.text

func _on_file_selected(path:String)->void:
	file_path_line_edit.text = path

func _on_load_file_button_pressed()->void:
	load_file_dialog.show()

