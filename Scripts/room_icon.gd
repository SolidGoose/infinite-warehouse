extends Control

@export var background_color: Color = Color(0.1, 0.1, 0.1, 1.0)

@export var left_border_visible: bool = true
@export var right_border_visible: bool = true
@export var top_border_visible: bool = true
@export var bottom_border_visible: bool = true
@export var left_bottom_angle_visible: bool = true
@export var right_bottom_angle_visible: bool = true
@export var left_top_angle_visible: bool = true
@export var right_top_angle_visible: bool = true

@onready var background = $Background

@onready var left_border = $Background/LeftBorder
@onready var right_border = $Background/RightBorder
@onready var top_border = $Background/TopBorder
@onready var bottom_border = $Background/BottomBorder
@onready var left_bottom_angle = $Background/LeftBottomAngle
@onready var right_bottom_angle = $Background/RightBottomAngle
@onready var left_top_angle = $Background/LeftTopAngle
@onready var right_top_angle = $Background/RightTopAngle

@onready var red_dot_sprite = $RedDotSprite

func _ready() -> void:
	background.color = background_color

	left_border.visible = left_border_visible
	right_border.visible = right_border_visible
	top_border.visible = top_border_visible
	bottom_border.visible = bottom_border_visible
	left_bottom_angle.visible = left_bottom_angle_visible
	right_bottom_angle.visible = right_bottom_angle_visible
	left_top_angle.visible = left_top_angle_visible
	right_top_angle.visible = right_top_angle_visible

	var room_icon_name = self.name
	if GameManager.explored_rooms.has(room_icon_name):
		visible = true
	else:
		visible = false

	var scene_name = get_tree().current_scene.name
	print("Current scene name: ", scene_name)
	if room_icon_name == scene_name:
		red_dot_sprite.visible = true
