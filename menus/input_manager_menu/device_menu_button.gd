extends MenuButton


func get_selected_device_ids()->PoolIntArray:
	var rv := PoolIntArray()
	var popup_menu := get_popup()
	for i in popup_menu.get_item_count():
		if popup_menu.is_item_checked(i):
			rv.append(int(popup_menu.get_item_metadata(i)))
	return rv

func _ready()->void:
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	var popup := get_popup()
	popup.connect("index_pressed", self, "_on_index_pressed")
	popup.hide_on_checkable_item_selection = false
	update_options()


func _on_joy_connection_changed(_d:int, _c:bool)->void:
	update_options()


func update_options()->void:
	var popup_menu: PopupMenu = get_popup()
	popup_menu.clear()
	# add non-joypad first
	for id in GGInput.get_non_joypad_devices():
		var idx: int = popup_menu.get_item_count()
		popup_menu.add_check_item(GGInput.NON_JOYPAD_DEVICE_NAMES[id])
		popup_menu.set_item_metadata(idx, id) # set metadata as device id
	# add joypads
	for id in Input.get_connected_joypads():
		var idx: int = popup_menu.get_item_count()
		popup_menu.add_check_item('joypad %d "%s"' % [id, Input.get_joy_name(id)])
		popup_menu.set_item_metadata(idx, id) # set metadata as device id

func _on_index_pressed(idx:int)->void:
	var popup: PopupMenu = get_popup()
	var checked: bool = not popup.is_item_checked(idx)
	popup.set_item_checked(idx, checked)



