extends Node

var player_scene = preload("res://Scenes/player.tscn")
var map_scene = preload("res://Scenes/map.tscn")

var player: Node2D = null

var can_move: bool = true
var start_game_level_path: String = "res://Scenes/room_1_11.tscn"
var shop_level_path: String = "res://Scenes/shop.tscn"
var dialogue_baloon_scene = "res://Scenes/balloon.tscn"

var explored_rooms: Array = []

var time: float = 10.0


func _ready() -> void:
	var test = DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
	print(test)


func start_dialogue(dialogue_name: String, dialogue_cue: String) -> void:
	can_move = false
	
	var dialogue_path = "res://Assets/Dialogue/Texts/%s.dialogue" % dialogue_name
	var dialogue_resource = load(dialogue_path)
	# Uncomment forshow_ the avatar-less version
	# DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_cue)
	DialogueManager.show_dialogue_balloon_scene(dialogue_baloon_scene, dialogue_resource, dialogue_cue)


func _on_dialogue_ended(resource: DialogueResource) -> void:
	print("Dialogue finished!")
	can_move = true


func start_game() -> void:
	await change_room(Vector2(750, 300), start_game_level_path)

	var timer_gui = get_parent().get_node('TimerGui')
	timer_gui.start_timer()


func end_game() -> void:
	await change_room()


func change_room(position: Vector2 = Vector2.ZERO, room_path: String = '') -> void:
	print("Changing room to: ", room_path, " with player position: ", position)
	var screen_width: float = get_viewport().get_visible_rect().size.x
	var screen_height: float = get_viewport().get_visible_rect().size.y
	
	var transition_player_to: String = ''
	var player_spawn_position: Vector2

	if position != Vector2.ZERO:
		var player_x: float = position.x
		var player_y: float = position.y

		if player_x > (screen_width * 0.85):
			player_x = screen_width - player_x
			transition_player_to = 'right'
		elif player_x < (screen_width * 0.15):
			player_x = screen_width - player_x
			transition_player_to = 'left'
		elif player_y > (screen_height * 0.85):
			player_y = screen_height - player_y
			transition_player_to = 'down'
		elif player_y < (screen_height * 0.15):
			player_y = screen_height - player_y
			transition_player_to = 'up'

		player_spawn_position = Vector2(player_x, player_y)

	if room_path == '':
		var room_column: String = ''
		var room_row: String = ''

		print("No room path provided, determining room path based on current scene name...")
		var current_scene_name = get_tree().current_scene.name
		print("Current scene name: ", current_scene_name)
		var regex = RegEx.create_from_string(r"Room_(\d+)_(\d+)")
		var result = regex.search(current_scene_name)
		print('result: ', result)
		if result:
			room_column = result.get_string(1)
			room_row = result.get_string(2)
			print("room_column: ", room_column)
			print("room_row: ", room_row)
		else:
			print("Could not find room coordinates in main scene name.")
		
		match transition_player_to:
			'right':
				room_column = str(int(room_column) + 1)
			'left':
				room_column = str(int(room_column) - 1)
			'up':
				room_row = str(int(room_row) - 1)
			'down':
				room_row = str(int(room_row) + 1)
			_:
				print("No transition direction found, defaulting to shop level")
				room_path = shop_level_path
				player_spawn_position = Vector2(600, 300)

		if room_path != shop_level_path:
			room_path = "res://Scenes/room_%s_%s.tscn" % [room_column, room_row]
			print("Determined room path: ", room_path)
		

	var is_room_exists = ResourceLoader.exists(room_path)
	print("Room path \"" + room_path + "\" exists: ", is_room_exists)
	if is_room_exists:
		get_tree().change_scene_to_file(room_path)
	else:
		print("Room path does not exist: ", room_path)
		return
	await get_tree().process_frame
	await get_tree().process_frame

	var player_instance = player_scene.instantiate()
	player_instance.global_position = player_spawn_position
	get_tree().current_scene.add_child(player_instance)


func show_hide_map() -> void:
	if Input.is_action_just_pressed("show_map"):
		# can_move = not can_move
		print("Showing map...")

		var existing_map_scene = get_tree().current_scene.get_node("Map")
		print("Does map exist: ", existing_map_scene)
		print("scene: ", get_tree().current_scene)
		
		if existing_map_scene:
			print("Map already exists, removing it...")
			existing_map_scene.queue_free()
		else:
			print("Map does not exist, creating it...")
			var map_instance = map_scene.instantiate()
			get_tree().current_scene.add_child(map_instance)
