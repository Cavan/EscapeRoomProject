extends Node2D

@onready var left_nav_arrow:Sprite2D = $Area2D_Left_Arrow/Left_Arrow
@onready var right_nav_arrow:Sprite2D = $Area2D_Right_Arrow/Right_Arrow

const LEFT_NAV_ARROW_CLICKED = "LEFT_NAV_ARROW_CLICKED"
const RIGHT_NAV_ARROW_CLICKED = "RIGHT_NAV_ARROW_CLICKED"

signal navigation_arrow_clicked(arrow_direction)

var is_mouse_over_nav_left_arrow: bool = false
var is_mouse_over_nav_right_arrow: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_left_arrow_mouse_entered():
		print("Left Nav Arrow Entered")
		left_nav_arrow.self_modulate = Color.CHARTREUSE
		is_mouse_over_nav_left_arrow = true


func _on_area_2d_left_arrow_mouse_exited():
		print("Left Nav Arrow Exited")
		left_nav_arrow.self_modulate = Color.WHITE
		is_mouse_over_nav_left_arrow = false


func _on_area_2d_right_arrow_mouse_entered():
	print("Right Nav Arrow Entered")
	right_nav_arrow.self_modulate = Color.CHARTREUSE
	is_mouse_over_nav_right_arrow = true


func _on_area_2d_right_arrow_mouse_exited():
	print("Right Nav Arrow Exited")
	right_nav_arrow.self_modulate = Color.WHITE
	is_mouse_over_nav_right_arrow = false
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_mouse_over_nav_left_arrow:
			print("Left button was clicked at ", event.position)
			navigation_arrow_clicked.emit(LEFT_NAV_ARROW_CLICKED)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_mouse_over_nav_right_arrow:
			print("Right button was clicked at ", event.position)
			navigation_arrow_clicked.emit(RIGHT_NAV_ARROW_CLICKED)
