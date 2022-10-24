extends Control


## Packed scene for instancing player
@export var player_instance_scene: PackedScene

## Maps player ids to node instances
var _player_instances: Dictionary = {}


func _ready()->void:
	PlayerManager.player_added.connect(_on_player_added)
	PlayerManager.player_removed.connect(_on_player_removed)


func _on_player_added(player_id)->void:
	# create a new player instance, set player_id, and add to scene
	var new_instance: Node = player_instance_scene.instantiate()
	new_instance.set("player_id", player_id)
	_player_instances[player_id] = new_instance
	add_child(new_instance)


func _on_player_removed(player_id)->void:
	# get player's instance and remove it
	var player_instance: Node = _player_instances.get(player_id)
	if player_instance:
		player_instance.get_parent().remove_child(player_instance)
		player_instance.queue_free()
	_player_instances.erase(player_id)
