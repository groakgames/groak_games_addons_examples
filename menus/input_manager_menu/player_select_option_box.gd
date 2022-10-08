extends OptionButton



func update_players()->void:
	clear()
	for id in PlayerManager.get_player_ids():
		var i: int = get_item_count()
		add_item(str(id))
		set_item_metadata(i, id)

func _ready()->void:
	PlayerManager.connect("player_added", self, "_on_players_modified")
	PlayerManager.connect("player_removed", self, "_on_players_modified")
	update_players()

func _on_players_modified(_id)->void:
	update_players()

func _on_item_selected(idx:int)->void:
	var player_id = get_item_metadata(idx)
