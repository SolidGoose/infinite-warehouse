extends Node

var can_move: bool = true


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


func _process(delta: float) -> void:
	pass
