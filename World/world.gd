extends Control

@export var main_level_path:String
@export var level_2_path:String
@export var level_3_path:String
@export var level_paths:Array[String]

@onready var loading_display:CanvasLayer = $Loading_Screen/LoadingDisplay

const LEFT_NAV_ARROW_CLICKED:String = "LEFT_NAV_ARROW_CLICKED"
const RIGHT_NAV_ARROW_CLICKED:String = "RIGHT_NAV_ARROW_CLICKED"
const NEXT_SCENE:int = 1
const PREVIOUS_SCENE:int = -1
const BEGINNING_SCENE:int = 0
const SCENE_INCREMENT:int = 1
const ADD_ONE_TO_ZERO_BASED_INDEX = 1
const SUBTRACT_ONE_FROM_ARRAY_SIZE = 1

var async_loading_path:String
var current_map_path:String
var current_level:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_level()
	var navigation = get_node("Navigation_Arrows")
	navigation.navigation_arrow_clicked.connect(_on_navigation_action)
	loading_display.visible = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loading_display:
		# advance to the next map
		change_current_map()


func load_main_level() -> void:
	async_loading_path = level_paths[BEGINNING_SCENE]
	current_map_path = async_loading_path
	print(ResourceLoader.load_threaded_get_status(async_loading_path))
	ResourceLoader.load_threaded_request(async_loading_path)
	current_level = ResourceLoader.load_threaded_get(async_loading_path).instantiate()
	#await get_tree().create_timer(1.0).timeout
	add_child(current_level)


func _on_navigation_action(direction:String):
	print("Click Signal Detected")
	print(direction)
	if direction == LEFT_NAV_ARROW_CLICKED:
		animated_scene_swap_loader(get_level_path(PREVIOUS_SCENE))
	if direction == RIGHT_NAV_ARROW_CLICKED:
		animated_scene_swap_loader(get_level_path(NEXT_SCENE))


func animated_scene_swap_loader(scene_path:String) -> void:
	async_loading_path = scene_path		
	var timestamp:String = Time.get_datetime_string_from_system()
	print("[%s] current set path: %s" % [timestamp, async_loading_path])
	var tween = create_tween().tween_property(current_level, "modulate:a", 0, 0.5)
	await tween.finished
	loading_display.visible = true
	
	remove_child(current_level)
	ResourceLoader.load_threaded_request(async_loading_path)
	

func change_current_map() -> void:
	if (ResourceLoader.load_threaded_get_status(async_loading_path) == ResourceLoader.THREAD_LOAD_LOADED):
			var timestamp:String = Time.get_datetime_string_from_system()
			print("[%s]Next map to load: %s" % [timestamp,async_loading_path])
			current_level = ResourceLoader.load_threaded_get(async_loading_path).instantiate()
			await get_tree().create_timer(1.0).timeout
			add_child(current_level)
			current_level.modulate.a = 0
			#spinner.stop()
			loading_display.visible = false
			var tween = create_tween().tween_property(current_level, "modulate:a", 1, 0.5)
			await tween.finished


func get_level_path(direction:int) -> String:
	var number_of_levels = level_paths.size()
	var current_level_index = level_paths.find(async_loading_path)
	if direction > 0:
		print("Current level Index: %s" % [current_level_index])
		if current_level_index + ADD_ONE_TO_ZERO_BASED_INDEX < number_of_levels:
			print("We can advance")
			current_level_index += SCENE_INCREMENT
		elif current_level_index + ADD_ONE_TO_ZERO_BASED_INDEX == number_of_levels:
			print("We must wrap around back to the beginning.")
			current_level_index = 0
	if direction < 0:
		print("Current level Index: %s" % [current_level_index])
		if current_level_index + ADD_ONE_TO_ZERO_BASED_INDEX > 1:
			print("We can go backward")
			current_level_index -= SCENE_INCREMENT
		elif current_level_index + ADD_ONE_TO_ZERO_BASED_INDEX == number_of_levels - level_paths.size() + 1:
			print("We must wrap around to the end.")
			current_level_index = level_paths.size() - SCENE_INCREMENT
	return level_paths[current_level_index]
