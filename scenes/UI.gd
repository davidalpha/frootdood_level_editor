extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mode = "UI"
var object_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Hide_editor_pressed():
	$Objects.visible = !$Objects.visible
	$Tools.visible = !$Tools.visible
		

func _on_edit_pressed():
	if mode == "edit":
		mode = "UI"
		$Objects.visible = true
		$Tools.visible = true
		$Hide_editor.visible = true
		$Mode_container/Mode_label.text = ""
	else:
		mode = "edit"
		$Objects.visible = false
		$Tools.visible = false
		$Hide_editor.visible = false
		$Mode_container/Mode_label.text = mode + " mode (press B to disable)"

func _process(delta: float) -> void:
	if Input.is_action_just_released("edit_toggle"):
		_on_edit_pressed()


func _on_Rocks_pressed():
	object_selected = "rocks"


