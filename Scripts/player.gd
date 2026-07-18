extends CharacterBody2D

const SPEED = 30000.0

@onready var interaction_box = $InteractionBox


func _ready() -> void:
	var scene_name = get_tree().current_scene.name
	print("Current scene name: ", scene_name)
	if GameManager.explored_rooms.has(scene_name):
		print("Room already explored: ", scene_name)
	else:
		print("Adding room to explored rooms: ", scene_name)
		GameManager.explored_rooms.append(scene_name)


func handle_room_transition() -> void:
	var current_scene_name = get_tree().current_scene.name
	var screen_width: float = get_viewport().get_visible_rect().size.x - 5
	var screen_height: float = get_viewport().get_visible_rect().size.y - 5

	var player_x: float = position.x
	var player_y: float = position.y

	if current_scene_name != "Shop":
		if player_x > screen_width:
			global_position.x = player_x
			player_x -= 5
			GameManager.change_room(Vector2(player_x, player_y))
		elif player_x < 0:
			global_position.x = player_x
			player_x += 5
			GameManager.change_room(Vector2(player_x, player_y))
		elif player_y > screen_height:
			global_position.y = player_y
			player_y -= 5
			GameManager.change_room(Vector2(player_x, player_y))
		elif player_y < 0:
			global_position.y = player_y
			player_y += 5
			GameManager.change_room(Vector2(player_x, player_y))

func handle_interact() -> void:
	if Input.is_action_just_released("use") and GameManager.can_move:
		print("Looking for NPCs to interact with...")
		var bodies = interaction_box.get_overlapping_bodies()
		if bodies.size() == 1:
			var body_name = bodies[0].name.to_lower()
			print("Interacting with \"", body_name, "\" body")
			GameManager.start_dialogue(body_name, "start")

	

func _physics_process(delta: float) -> void:
	var direction_vector = Input.get_vector("left", "right", "up", "down")

	# var can_move = GameManager.can_move

	if direction_vector and GameManager.can_move:
		velocity = direction_vector * SPEED * delta
		rotation = direction_vector.angle()
		# print("Moving in direction: ", direction_vector, " with velocity: ", velocity)
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	handle_interact()

	handle_room_transition()

	GameManager.show_hide_map()
	

	

