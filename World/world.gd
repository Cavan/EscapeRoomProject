extends Control

@export var main_level_path:String

var async_loading_path:String
 

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_level()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func load_main_level() -> void:
	async_loading_path = main_level_path
	print(ResourceLoader.load_threaded_get_status(async_loading_path))
	ResourceLoader.load_threaded_request(async_loading_path)
	var current_level = ResourceLoader.load_threaded_get(async_loading_path).instantiate()
	#await get_tree().create_timer(1.0).timeout
	add_child(current_level)

func swap_scenes() -> void:
	pass
	

func mouse_over_ui() -> void:
	pass




