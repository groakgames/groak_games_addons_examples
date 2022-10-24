class_name PlayerDeviceSelectDropDown extends DeviceSelectDropDown

var _current_player_id


func set_current_player(player_id)->void:
	_current_player_id = player_id
	super.update_options()
	var popup_menu: PopupMenu = get_popup()
	var devices: PackedInt32Array = Gin.get_player_devices(player_id)
	for i in popup_menu.get_item_count():
		if popup_menu.get_item_metadata(i) in devices:
			popup_menu.set_item_checked(i, true)


func _on_index_pressed(idx:int)->void:
	super._on_index_pressed(idx)

	var popup_menu := get_popup()

	var is_checked := popup_menu.is_item_checked(idx)
	if is_checked:
		Gin.claim_device(_current_player_id, popup_menu.get_item_metadata(idx))
	else:
		Gin.unclaim_device(_current_player_id, popup_menu.get_item_metadata(idx))
