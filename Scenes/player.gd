extends CharacterBody2D


const SPEED = 40000.0

@onready var interaction_box = $InteractionBox


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")

	# var can_move = GameManager.can_move

	if direction and GameManager.can_move:
		velocity = direction * SPEED * delta
	else:
		# velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		# velocity.y = move_toward(velocity.y, 0, SPEED * delta)
		velocity = Vector2.ZERO

	move_and_slide()

	if Input.is_action_just_released("use") and GameManager.can_move:
		print("Looking for NPCs to interact with...")
		var bodies = interaction_box.get_overlapping_bodies()
		if bodies.size() == 1:
			var body_name = bodies[0].name.to_lower()
			print("Interacting with \"", body_name, "\" body")
			GameManager.start_dialogue(body_name, "start")


# func _on_interaction_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
# 	var name = body.name

# 	if name != "Player":
# 		print("Interaction box body shape entered: %s" % body.name)
