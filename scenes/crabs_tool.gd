tool
extends Spatial

var amount_trees = 100
const ray_length = 1000
var object_type = "rock1"
var rock1 = preload("res://game_objects/rock1.tscn")
var rock2 = preload("res://game_objects/rock2.tscn")
var rock3 = preload("res://game_objects/rock3.tscn")
var ball  = preload("res://game_objects/ball.tscn")
var rocks_arr = [rock1, rock2, rock3]

func _input(event):

	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var UI = get_node("/root/World/UI")
		var mode = UI.mode

		if mode == "edit":
			var space_state = get_world().direct_space_state
			var camera = get_node("/root/World/CameraScene")
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * ray_length
			var intersection = space_state.intersect_ray(from, to)
			if intersection:
				var placement = intersection['position']
				
				
				object_type = UI.object_selected
				if object_type == "rocks":
					rocks_arr.shuffle()
					var item = rocks_arr[0]
					var new_meshinstance = item.instance()
					new_meshinstance.transform.origin = Vector3(placement)
					new_meshinstance.transform.basis = new_meshinstance.transform.basis.rotated(Vector3(0.0,1.0,0.0), (PI*rand_range(0,2)))
					new_meshinstance.transform.basis = new_meshinstance.transform.basis.scaled(Vector3(rand_range(.5, 1.5),rand_range(.5, 1.5),rand_range(.5, 1.5)))
					add_child(new_meshinstance)
					
				if object_type == "balls":
					var ball_instance = ball.instance()
					camera.add_child(ball_instance)
					ball_instance.look_at(intersection['position'], Vector3.UP)
			
