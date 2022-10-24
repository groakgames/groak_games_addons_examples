extends Node


@export var player_select_option_button: Button
@export var device_select_drop_down: Button
@export var edit_profile_button: Button
@export var remove_player_button: Button


func update_enabled_buttons()->void:
	var current_player_id = player_select_option_button.get_selected_player_id()
	var dis: bool = current_player_id == null
	device_select_drop_down.disabled = dis
	edit_profile_button.disabled = dis
	remove_player_button.disabled = dis


func _ready()->void:
	player_select_option_button.item_selected.connect(_on_player_select)
	PlayerManager.player_removed.connect(_on_player_removed)
	PlayerManager.player_added.connect(_on_player_added, CONNECT_DEFERRED)
	update_enabled_buttons()



func _on_player_removed(player_id)->void:
	player_select_option_button.update_after_remove(player_id)
	update_enabled_buttons()

func _on_player_added(_id)->void:
	update_enabled_buttons()
	device_select_drop_down.set_current_player(player_select_option_button.get_selected_player_id())


func _on_player_select(idx:int)->void:
	update_enabled_buttons()
	device_select_drop_down.set_current_player(player_select_option_button.get_selected_player_id())



