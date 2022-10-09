extends Node

# autoload PlayerManager

signal player_added(player_id)
signal player_removed(player_id)


## Adds a player into the player manager.
## Also registeres to the input manager.
## returns Error
func add_player(player_id, profile:GinProfile, devices:PoolIntArray)->int:
	if player_id in _players: return ERR_ALREADY_EXISTS
	var data := PlayerData.new()
	data.player_id = player_id
	_players[player_id] = data
	Gin.create_player(player_id, profile, devices)
	emit_signal("player_added", player_id)
	return OK


func remove_player(player_id)->int:
	var player_data: PlayerData = _players.get(player_id)
	if not player_data: return ERR_DOES_NOT_EXIST


	emit_signal("player_removed", player_id)
	return OK

func set_instance(player_id, instance:Node)->int:
	var player_data: PlayerData = _players.get(player_id)
	if not player_data: return ERR_DOES_NOT_EXIST
	return OK

func get_player_count()->int:
	return _players.size()

func get_player_ids()->Array:
	return _players.keys()

func get_player_data(player_id)->PlayerData:
	return _players.get(player_id)

var _players: Dictionary = {}


class PlayerData:
	var player_id
	## nodes blonging to this player
	var instances: Array = []
