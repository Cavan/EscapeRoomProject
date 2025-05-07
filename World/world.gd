extends Control

@export var main_level_path:String
@export var level_2_path:String
@export var level_3_path:String
@export var level_paths:Array[String]

@onready var loading_display:CanvasLayer = $Loading_Screen/LoadingDisplay

const LEFT_NAV_ARROW_CLICKED = "LEFT_NAV_ARROW_CLICKED"
const RIGHT_NAV_ARROW_CLICKED = "RIGHT_NAV_ARROW_CLICKED"

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
	async_loading_path = level_paths[0]
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
		navigate_to_previous_map()
	if direction == RIGHT_NAV_ARROW_CLICKED:
		navigate_to_next_map()

func navigate_to_next_map() -> void:
	print("Navigating to next map")
	animated_scene_swap_loader()
	
func navigate_to_previous_map() -> void:
	print("Navigating to previous map")

func animated_scene_swap_loader() -> void:
	var new_map
	var number_of_levels = level_paths.size()
	var current_level_index = level_paths.find(async_loading_path)
	# Refactoring
	if current_level_index + 1 < number_of_levels:
		print("We can advance")
	elif current_level_index + 1 == number_of_levels:
		print("We must wrap around back to the beginning.")
		
	# Refactoring		
		
	var timestamp:String = Time.get_datetime_string_from_system()
	if (async_loading_path == level_paths[0]):
		async_loading_path = level_paths[1]
	elif async_loading_path == level_paths[1]:
		async_loading_path = level_paths[2]
	elif async_loading_path == level_paths[2]:
		async_loading_path = level_paths[0]
	print("[%s] current set path: %s" % [timestamp, async_loading_path])
	var tween = create_tween().tween_property(current_level, "modulate:a", 0, 0.5)
	
	await tween.finished
	
	#animatedLoading.visible = true
	loading_display.visible = true
	#spinner.play("spinner")
	
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





