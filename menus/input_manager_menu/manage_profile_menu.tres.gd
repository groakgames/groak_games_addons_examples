extends Node

const ERROR_MESSAGE_DISPLAY_TIME: float = 2.0

@export var profile_path_selector: Node
@export var load_profile_button:  Button

@export var profile_drop_down: Node
@export var new_profile_button: Button

@export var edit_button: Button
@export var save_button: Button
@export var unload_button: Button

@export var error_display: Label

@export var save_profile_file_dialog: Node

func update_enabled_buttons()->void:
	var dis: bool = profile_drop_down.get_selected_profile() == null
	edit_button.disabled = dis
	save_button.disabled = dis
	unload_button.disabled = dis


var _error_coroutine_timer: SceneTreeTimer


func _ready()->void:
	load_profile_button.pressed.connect(_on_load_profile_pressed)

	edit_button.pressed.connect(_on_edit_pressed)
	save_button.pressed.connect(_on_save_pressed)
	unload_button.pressed.connect(_on_unload_pressed)

	profile_drop_down.item_selected.connect(_on_profile_selected)
	new_profile_button.pressed.connect(_on_new_profile_pressed)

	save_profile_file_dialog.file_selected.connect(_on_file_selected)
	update_enabled_buttons()


func _on_load_profile_pressed()->void:
	profile_drop_down.select_latest_load = true
	var profile: GinProfile = load(profile_path_selector.get_selected_file_path())
	if profile:
		var err: int = Gin.load_profile(profile)
		profile_drop_down.select_latest_load = false
		if err == ERR_ALREADY_EXISTS:
			_error_coroutine("Error: Profile With Same Name Already Exists!")
	else:
		_error_coroutine("Error: Invalid or Malformed Profile!")


func _on_profile_selected(idx:int)->void:
	update_enabled_buttons()


func _on_new_profile_pressed()->void:
	pass


func _on_edit_pressed()->void:
	# show edit profile menu
	pass


func _on_save_pressed()->void:
	var profile: GinProfile = profile_drop_down.get_selected_profile()
	if profile:
		save_profile_file_dialog.show()


func _on_file_selected(file_path:String)->void:
	var profile: GinProfile = profile_drop_down.get_selected_profile()
	if not profile:
		_error_coroutine("Error: Failed to Save")
		return
	ResourceSaver.save(profile, file_path)


func _on_unload_pressed()->void:
	var profile: GinProfile = profile_drop_down.get_selected_profile()
	if profile:
		Gin.unload_profile(profile.resource_name)


func _error_coroutine(error_text:String)->void:
	# Set text to display error
	error_display.text = error_text
	error_display.visible = true
	# If there is an error being displayed already, set the timer to zero
	if _error_coroutine_timer:
		_error_coroutine_timer.time_left = 0
	# Keep error text for atleast ERROR_MESSAGE_DISPLAY_TIME second
	var timer := get_tree().create_timer(ERROR_MESSAGE_DISPLAY_TIME)
	_error_coroutine_timer = timer
	await _error_coroutine_timer.timeout
	# Reset text if the error being displayed was the latest one.
	if _error_coroutine_timer == timer:
		_error_coroutine_timer = null
		error_display.text = ""
		error_display.visible = false
