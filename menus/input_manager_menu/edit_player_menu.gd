extends Node


export(NodePath) onready var player_select_option_button = get_node(player_select_option_button)

export(NodePath) onready var device_select_drop_down = get_node(device_select_drop_down)

export(NodePath) onready var edit_profile_button = get_node(edit_profile_button)

export(NodePath) onready var remove_player_button = get_node(remove_player_button)


func update_enabled_buttons()->void:
	var current_player_id = player_select_option_button.get_selected_player_id()
	var dis: bool = current_player_id == null
	device_select_drop_down.disabled = dis
	edit_profile_button.disabled = dis
	remove_player_button.disabled = dis


func _ready()->void:
	player_select_option_button.connect("item_selected", self, "_on_player_select")
	PlayerManager.connect("player_removed", self, "_on_player_removed")
	PlayerManager.connect("player_added", self, "_on_player_added", [], CONNECT_DEFERRED)
	update_enabled_buttons()



func _on_player_removed(player_id)->void:
	player_select_option_button.update_after_remove(player_id)
	update_enabled_buttons()

func _on_player_added(_id)->void:
	update_enabled_buttons()
	device_select_drop_down.set_current_player(player_select_option_button.get_selected_player_id())

#	if player_id ==

func _on_player_select(idx:int)->void:
	update_enabled_buttons()
	device_select_drop_down.set_current_player(player_select_option_button.get_selected_player_id())



