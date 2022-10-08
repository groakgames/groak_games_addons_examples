extends Node


const ERROR_MESSAGE_DISPLAY_TIME: float = 2.0

export(NodePath) onready var player_id_line_edit = get_node(player_id_line_edit) as LineEdit

export(NodePath) onready var profile_path_line_edit = get_node(profile_path_line_edit) as LineEdit

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

	if PlayerManager.get_player_data(player_id):
		_add_player_error_coroutine("Error: Player ID Already Exists!")
		return

	var profile: InputProfile
	if not profile_path_line_edit.text.empty():
		profile = load(profile_path_line_edit.text) as InputProfile
		if not profile:
			_add_player_error_coroutine("Error: Invalid or Malformed Input Profile!")
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
