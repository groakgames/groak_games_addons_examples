extends FileDialog


func _ready()->void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed()->void:
	if visible:
		size = get_tree().root.size * 0.75
		position = get_tree().root.size * 0.125
