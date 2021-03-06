extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mode = "UI"
var object_selected = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Hide_editor_pressed():
	$Objects.visible = !$Objects.visible
	$Tools.visible = !$Tools.visible	

func _on_edit_pressed():
	if mode == "edit":
		mode = "UI"
		$Objects.visible = true
		$Tools.visible = true
		$Mode_container/Mode_label.text = ""
	else:
		mode = "edit"
		$Objects.visible = false
		$Tools.visible = false
		$Mode_container/Mode_label.text = mode + " mode (press B to disable) - Object selected: " + object_selected

func _process(_delta: float) -> void:
	if Input.is_action_just_released("edit_toggle"):
		_on_edit_pressed()


func _on_Rocks_pressed():
	object_selected = "rocks"
	
func _on_Grass_pressed():
	object_selected = "grass"
	
func _on_Cube3x3_pressed():
	object_selected = "cube3x3"
	
func _on_palmtree_straight_pressed():
	object_selected = "palm_tree_straight"
	
func _on_palmtree_curly_pressed():
	object_selected = "palm_tree_curly"
	
func _on_Banana_pressed():
	object_selected = "banana"

func _on_Statue_lanky_pressed():
	object_selected = "statue_lanky"

func _on_save_pressed():
	var terrain = get_node("/root/level_editor/")
	terrain.save_scene()

func _on_load_pressed():
	$Levels.popup()

func _on_Levels_file_selected(path):
	var terrain = get_node("/root/level_editor/terrain")
	terrain.free()
	print(path)
	var loaded_level = load(path);
	var level = loaded_level.instance();
	print(loaded_level)
	get_node("/root/level_editor/").add_child(level);
	print(level)










