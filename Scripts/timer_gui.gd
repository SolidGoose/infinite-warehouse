extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $TimerLabelControl/TimerLabel
@onready var sprite: AnimatedSprite2D = $SpriteControl/AnimatedSprite2D

var sprite_default_scale: Vector2 = Vector2(0.8, 0.8)
var level_time: float = GameManager.time


func start_timer() -> void:
	visible = true

	timer.wait_time = level_time
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_left: float = timer.time_left
	var minutes: int = int(time_left / 60)
	var seconds: int = int(time_left) % 60
	var milliseconds: int = int((time_left - floor(time_left)) * 100)
	timer_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	var progress = level_time / time_left * 3
	if progress < 100.0:
		var sprite_scale: float = (progress / 100) * 0.8
		sprite.scale = Vector2(sprite_scale, sprite_scale)


func _on_timer_timeout() -> void:
	GameManager.end_game()
	visible = false
