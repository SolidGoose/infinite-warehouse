extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered the hitbox area")
		# GameManager.can_move = false
		GameManager.start_game()
