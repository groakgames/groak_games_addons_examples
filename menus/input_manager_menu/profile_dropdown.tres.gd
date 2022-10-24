extends OptionButton

var select_latest_load := false


func get_selected_profile()->GinProfile:
	if selected >= 0:
		return get_item_metadata(selected)
	return null


func update_profiles(select_profile=null)->void:
	clear()
	for profile in Gin.get_profiles():
		var i := get_item_count()
		add_item(profile.resource_name)
		set_item_metadata(i, profile)
		if profile == select_profile:
			selected = i


func _ready()->void:
	Gin.profile_loaded.connect(_on_profile_loaded)
	Gin.profile_unloaded.connect(_on_profile_unloaded)
	update_profiles()


func _on_profile_loaded(profile:GinProfile)->void:
	update_profiles(profile if select_latest_load else null)


func _on_profile_unloaded(profile:GinProfile)->void:
	for i in get_item_count():
		if get_item_metadata(i) == profile:
			remove_item(i)
			return
