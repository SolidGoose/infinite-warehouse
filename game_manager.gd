extends Node

var player_scene = preload("res://Scenes/player.tscn")

var player: Node2D = null
var player_spawn_position: Vector2 = Vector2.ZERO

var can_move: bool = true
var start_game_level_path: String = "res://Scenes/room_1_11.tscn"
var shop_level_path: String = "res://Scenes/shop.tscn"


func _ready() -> void:
	var test = DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
	print(test)


func start_dialogue(dialogue_name: String, dialogue_cue: String) -> void:
	can_move = false
	
	var dialogue_path = "res://Assets/Dialogue/Texts/%s.dialogue" % dialogue_name
	var dialogue_resource = load(dialogue_path)
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_cue)


func _on_dialogue_ended(resource: DialogueResource) -> void:
	print("Dialogue finished!")
	can_move = true


func start_game() -> void:
	change_room(Vector2(750, 300), start_game_level_path)
	# get_tree().change_scene(start_game_level_path)


func change_room(position: Vector2, room_path: String = '') -> void:
	print("Changing room to: ", room_path, " with player position: ", position)
	var screen_width: float = get_viewport().get_visible_rect().size.x
	var screen_height: float = get_viewport().get_visible_rect().size.y


	var player_x: float = position.x
	var player_y: float = position.y
	var transition_player_to: String = ''

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
		print("No room path provided, determining room path based on current scene name...")
		var current_scene_name = get_tree().current_scene.name
		print("Current scene name: ", current_scene_name)
		var regex = RegEx.create_from_string(r"Room_(\d+)_(\d+)")
		var result = regex.search(current_scene_name)
		print('result: ', result)
		if result:
			var room_column: String = result.get_string(1)
			var room_row: String = result.get_string(2)
			print("room_column: ", room_column)
			print("room_row: ", room_row)

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

			if room_path != shop_level_path:
				room_path = "res://Scenes/room_%s_%s.tscn" % [room_column, room_row]
				print("Determined room path: ", room_path)
		else:
			print("Could not find room coordinates in main scene name.")
	
		


	# get_tree().change_scene(room_path)
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
