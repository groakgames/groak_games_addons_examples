extends OptionButton

func get_selected_player_id():
	if selected >= 0:
		return get_item_metadata(selected)
	return null

func update_players()->void:
	clear()
	for id in PlayerManager.get_player_ids():
		var i: int = get_item_count()
		add_item(str(id))
		set_item_metadata(i, id)

func update_after_remove(player_id)->void:
	for i in get_item_count():
		if get_item_metadata(i) == player_id:
			remove_item(i)
			return

func _ready()->void:
	PlayerManager.player_added.connect(_on_players_modified)
	PlayerManager.player_removed.connect(_on_players_modified)
	update_players()

func _on_players_modified(_id)->void:
	update_players()
