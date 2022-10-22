extends Node


const ERROR_MESSAGE_DISPLAY_TIME: float = 2.0

export(NodePath) onready var player_id_line_edit = get_node(player_id_line_edit) as LineEdit

export(NodePath) onready var profile_path_selector = get_node(profile_path_selector)

export(NodePath) onready var devices_menu = get_node(devices_menu)

export(NodePath) onready var add_player_button = get_node(add_player_button) as Button

var _add_player_error_coroutine_timer: SceneTreeTimer

func _ready()->void:
	add_player_button.connect("pressed", self, "_on_add_player_pressed")
	add_player_button.set_meta("__base_text", add_player_button.text)


func _on_add_player_pressed()->void:
	var player_id: String = player_id_line_edit.text
	if player_id.empty():
		_add_player_error_coroutine("Error: No Player ID!")
		return
	elif PlayerManager.get_player_data(player_id):
		_add_player_error_coroutine("Error: Player ID Already Exists!")
		return

	var selected_file_path: String = profile_path_selector.get_selected_file_path()
	var profile:GinProfile
	if not selected_file_path.empty():
		if not ResourceLoader.exists(selected_file_path):
			var cfg := ConfigFile.new()
			if cfg.load(selected_file_path) == OK:
				profile = GinProfile.new()
				profile.from_configfile(cfg)
			else:
				_add_player_error_coroutine("Error: Invalid or Malformed Profile!")
				return
		else:
			var profile_res: Resource = load(selected_file_path)
			if profile_res is GinProfile:
				profile = profile_res
			else:
				_add_player_error_coroutine("Error: Resource is not Gin Profile!")
				return
	PlayerManager.add_player(player_id, profile, devices_menu.get_selected_device_ids())


func _add_player_error_coroutine(error_text:String)->void:
	# Set text on button to display error
	add_player_button.text = error_text
	# If there is an error being displayed already, set the timer to zero
	if _add_player_error_coroutine_timer:
		_add_player_error_coroutine_timer.time_left = 0
	# Keep error text for atleast 1 second
	var timer := get_tree().create_timer(ERROR_MESSAGE_DISPLAY_TIME)
	_add_player_error_coroutine_timer = timer
	yield(_add_player_error_coroutine_timer, "timeout")
	# Reset button text if the error being displayed was the latest one.
	if _add_player_error_coroutine_timer == timer:
		_add_player_error_coroutine_timer = null
		add_player_button.text = add_player_button.get_meta("__base_text")
