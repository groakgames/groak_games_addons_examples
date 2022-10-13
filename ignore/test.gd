extends Sprite

const GIN_ACTION_PREFIX: String = "__gin_"

const SCALAR_SIGNAL_ARGS =[
	{name= "input",type= TYPE_REAL},
	{name= "event",type= TYPE_OBJECT}
]

const VECTOR_SIGNAL_ARGS =[
	{name= "input",type= TYPE_VECTOR2},
	{name= "event",type= TYPE_OBJECT}
]

var input: Vector2
var q: Array

func _physics_process(delta):
	position += input * delta * 100

var input_count: int





func _ready():
	var iek := InputEventKey.new()
	var ie_int: int
	var up_inputs: PoolIntArray = []
	var down_inputs: PoolIntArray = []
	var left_inputs: PoolIntArray = []
	var right_inputs: PoolIntArray = []

	var gameplay_move_va := VectorAction.new()
	# UP
	iek.scancode = KEY_W
	ie_int = Action.input_event_int(iek)
	up_inputs.push_back(ie_int)
	map[ie_int] = [gameplay_move_va]

	# DOWN
	iek.scancode = KEY_S
	ie_int = Action.input_event_int(iek)
	down_inputs.push_back(ie_int)
	map[ie_int] = [gameplay_move_va]

	# LEFT
	iek.scancode = KEY_A
	ie_int = Action.input_event_int(iek)
	left_inputs.push_back(ie_int)
	map[ie_int] = [gameplay_move_va]

	# RIGHT
	iek.scancode = KEY_D
	ie_int = Action.input_event_int(iek)
	right_inputs.push_back(ie_int)
	map[ie_int] = [gameplay_move_va]

	gameplay_move_va.init("gameplay_move", up_inputs, down_inputs, left_inputs, right_inputs)
	gameplay_move_va.connect("triggered", self, "_on_vector_action_triggered")
	add_user_signal(GIN_ACTION_PREFIX+"gameplay_move", VECTOR_SIGNAL_ARGS)


func add_action(action:Action)->void:

	var signal_args := []
	if action is VectorAction:
		signal_args = VECTOR_SIGNAL_ARGS
	add_user_signal(GIN_ACTION_PREFIX+action.name, signal_args)

func _add_vector_action(action:VectorAction)->void:
	pass


func connect_input(action: String, target: Object, method:String, binds: Array = [], flags: int = 0)->int:
	return connect(GIN_ACTION_PREFIX+action, target, method, binds, flags)


func disconnect_input(action:String, target:Object, method:String)->void:
	disconnect(GIN_ACTION_PREFIX+action, target, method)


func _on_vector_action_triggered(action_name:String, input:Vector2, event:InputEvent)->void:
	emit_signal(GIN_ACTION_PREFIX+action_name, input, event)



var map: Dictionary = {}



func _input(event:InputEvent)->void:
	var ie_int := Action.input_event_int(event)
	for i in map.get(ie_int, []):
		i.parse_input(event)


func _notification(what:int)->void:
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		# go through all actions and clear them.
#		xq.clear()
#		yq.clear()
#		prev_values.clear()
#		input = Vector2.ZERO
		pass

class Action:
	var name: String
	func init(action_name):
		name = action_name

	enum VECTOR_INPUT_TYPE {
		UP
		RIGHT
		DOWN
		LEFT
		NATIVE_INPUT_START
		ABSOLUTE # absolute native input
		RELATIVE # relative native input
	}

	enum INPUT_EVENT_ID {
		InputEventKey            = 0
		InputEventMagnifyGesture = 1 << 63
		InputEventPanGesture     = 2 << 63
		InputEventMouseButton    = 3 << 63
		InputEventMouseMotion    = 4 << 63
		InputEventJoypadButton   = 5 << 63
		InputEventJoypadMotion   = 6 << 63
		InputEventMIDI           = 7 << 63
		InputEventScreenDrag     = 8 << 63
		InputEventScreenTouch    = 9 << 63
	}

	static func input_event_int(ie:InputEvent)->int:
		if ie is InputEventKey:
			return INPUT_EVENT_ID.InputEventKey | (((int(ie.alt) << 4) | (int(ie.shift) << 3) | (int(ie.control) << 2) | (int(ie.meta) << 1) | int(ie.command)) << 62) | ie.scancode
		elif ie is InputEventJoypadButton:
			return INPUT_EVENT_ID.InputEventJoypadButton | ie.button_index
		elif ie is InputEventJoypadMotion:
			return INPUT_EVENT_ID.InputEventJoypadMotion | ie.axis
		elif ie is InputEventMouseButton:
			return INPUT_EVENT_ID.InputEventMouseButton | ie.button_index | (((int(ie.alt) << 4) | (int(ie.shift) << 3) | (int(ie.control) << 2) | (int(ie.meta) << 1) | int(ie.command)) << 62)
		elif ie is InputEventMouseMotion:
			return INPUT_EVENT_ID.InputEventMouseMotion | (((int(ie.alt) << 4) | (int(ie.shift) << 3) | (int(ie.control) << 2) | (int(ie.meta) << 1) | int(ie.command)) << 62)
		elif ie is InputEventMagnifyGesture:
			return INPUT_EVENT_ID.InputEventMagnifyGesture | ie.mouse_button | (((int(ie.alt) << 4) | (int(ie.shift) << 3) | (int(ie.control) << 2) | (int(ie.meta) << 1) | int(ie.command)) << 62)
		elif ie is InputEventPanGesture:
			return INPUT_EVENT_ID.InputEventPanGesture | ie.mouse_button | (((int(ie.alt) << 4) | (int(ie.shift) << 3) | (int(ie.control) << 2) | (int(ie.meta) << 1) | int(ie.command)) << 62)
		else:
			return INPUT_EVENT_ID.get(ie.get_class(), 0)


class VectorAction:
	extends Action
	func get_inputs()->PoolIntArray:
		var rv := PoolIntArray()
		rv.append_array(px_inputs)
		rv.append_array(nx_inputs)
		rv.append_array(py_inputs)
		rv.append_array(ny_inputs)
		return rv

	func init(action_name:String, up_inputs:PoolIntArray=[], down_inputs:PoolIntArray=[], left_inputs:PoolIntArray=[], right_inputs:PoolIntArray=[])->void:
		name = action_name
		ny_inputs = up_inputs
		ny_inputs.sort()
		for i in ny_inputs:
			input_direction_map[i] = VECTOR_INPUT_TYPE.UP
		py_inputs = down_inputs
		py_inputs.sort()
		for i in py_inputs:
			input_direction_map[i] = VECTOR_INPUT_TYPE.DOWN
		nx_inputs = left_inputs
		nx_inputs.sort()
		for i in nx_inputs:
			input_direction_map[i] = VECTOR_INPUT_TYPE.LEFT
		px_inputs = right_inputs
		px_inputs.sort()
		for i in px_inputs:
			input_direction_map[i] = VECTOR_INPUT_TYPE.RIGHT

	export var px_inputs: PoolIntArray
	export var nx_inputs: PoolIntArray
	export var py_inputs: PoolIntArray
	export var ny_inputs: PoolIntArray
	var native_inputs:    PoolIntArray
	var input_direction_map: Dictionary

	var prev_values := {}
	var xq: Array
	var yq: Array
	var deadzone: float = 0.01

	signal triggered(input, event)

	func parse_input(event:InputEvent)->void:
		var ie_int: int = input_event_int(event)
		var direction = input_direction_map.get(ie_int, null)
		if direction == null: return
		var direction_queue:Array = yq if direction == VECTOR_INPUT_TYPE.UP or direction == VECTOR_INPUT_TYPE.DOWN else xq
		var dir_coef: int = int(direction == VECTOR_INPUT_TYPE.RIGHT or direction == VECTOR_INPUT_TYPE.DOWN)*2-1
		var absolute: bool = false
		if direction < VECTOR_INPUT_TYPE.NATIVE_INPUT_START:
			if event is InputEventJoypadMotion:
				if abs(event.axis_value) > deadzone:
					if prev_values.get(ie_int, 0.0) != 0.0:
						direction_queue.erase([ie_int, prev_values[ie_int]])
					var value:float = event.axis_value*dir_coef
					direction_queue.push_back([ie_int, value])
					prev_values[ie_int] = value
				else:
					if prev_values.has(ie_int):
						direction_queue.erase([ie_int, prev_values[ie_int]])
						prev_values[ie_int] = 0.0
			elif event is InputEventKey and not event.is_echo():
				if event.is_pressed():
					direction_queue.push_back([ie_int, dir_coef])
				else:
					direction_queue.erase([ie_int, dir_coef])
			else:
				return
			emit_signal("triggered", name, calc_input(), false, event)
		else:
			var is_absolute: bool = direction == VECTOR_INPUT_TYPE.ABSOLUTE
			var absolute_val: Vector2
			if event is InputEventMouseMotion:
				absolute_val = event.position if is_absolute else event.relative

			emit_signal("triggered", name, calc_input(), direction == VECTOR_INPUT_TYPE.ABSOLUTE, event)



	func calc_input()->Vector2:
		return Vector2(xq.back()[1] if xq else 0.0, yq.back()[1] if yq else 0.0).clamped(1.0)



#enum DIRECTION {
#	UP
#	RIGHT
#	DOWN
#	LEFT
#}
#var direction_q: Array
#
#func _input(event:InputEvent)->void:
#	if event is InputEventKey and not event.is_echo():
#		var val := float(event.is_pressed())
#
#		if event.is_pressed():
#			if event.scancode == KEY_W:
#				direction_q.push_front(DIRECTION.UP)
#				input.y = 1
#			elif event.scancode == KEY_A:
#				direction_q.push_front(DIRECTION.LEFT)
#				input.x = -1
#			elif event.scancode == KEY_S:
#				direction_q.push_front(DIRECTION.DOWN)
#				input.y = -1
#			elif event.scancode == KEY_D:
#				direction_q.push_front(DIRECTION.RIGHT)
#				input.x = 1
#			else:
#				return
#			input_count += 1
#		else:
#			if event.scancode == KEY_W:
#				direction_q.erase(DIRECTION.UP)
#			elif event.scancode == KEY_A:
#				direction_q.erase(DIRECTION.LEFT)
#			elif event.scancode == KEY_S:
#				direction_q.erase(DIRECTION.DOWN)
#			elif event.scancode == KEY_D:
#				direction_q.erase(DIRECTION.RIGHT)
#			else:
#				return
#			input_count -= 1
#			input = calc_input()
#
#
#func calc_input()->Vector2:
#	var y: float = 0.0
#	var x: float = 0.0
#
#	for input in direction_q:
#		if y == 0:
#			if input == DIRECTION.UP:
#				y = 1.0
#			elif input == DIRECTION.DOWN:
#				y = -1.0
#		if x == 0:
#			if input == DIRECTION.RIGHT:
#				x = 1.0
#			elif input == DIRECTION.LEFT:
#				x = -1.0
#		if x != 0.0 and y != 0.0:
#			break
#	return Vector2(x,y)

#var state_u: Dictionary
#var state_d: Dictionary
#var state_l: Dictionary
#var state_r: Dictionary
#func __input(event:InputEvent)->void:
#	if event is InputEventKey and not event.is_echo():
#		var val := float(event.is_pressed())
#
#		if event.is_pressed():
#			if event.scancode == KEY_W:
#				state_u[KEY_W] = true
#				input.y = 1
#
#			elif event.scancode == KEY_A:
#				state_l[KEY_A] = true
#				input.x = -1
#			elif event.scancode == KEY_S:
#				state_d[KEY_S] = true
#				input.y = -1
#			elif event.scancode == KEY_D:
#				state_r[KEY_D] = true
#				input.x = 1
#			else:
#				return
#		else:
#			if event.scancode == KEY_W:
#				state_u.erase(KEY_W)
#			elif event.scancode == KEY_A:
#				state_l.erase(KEY_A)
#			elif event.scancode == KEY_S:
#				state_d.erase(KEY_S)
#			elif event.scancode == KEY_D:
#				state_r.erase(KEY_D)
#			else:
#				return
#			input = Vector2(
#				sign(state_r.size()-state_l.size()),
#				sign(state_u.size()-state_d.size())
#			)
