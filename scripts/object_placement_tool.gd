tool
extends Spatial

const ray_length = 1000
var object_type = "rock1"
var rock1 = preload("res://scenes/static_objects/rock1.tscn")
var rock2 = preload("res://scenes/static_objects/rock2.tscn")
var rock3 = preload("res://scenes/static_objects/rock3.tscn")
var rocks_arr = [rock1, rock2, rock3]

func _input(event):

	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var UI = get_node("/root/level_editor/UI")
		var terrain = get_node("/root/level_editor/terrain")
		var mode = UI.mode

		if mode == "edit":
			var space_state = get_world().direct_space_state
			var camera = get_node("/root/level_editor/camera_scene")
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
					terrain.add_child(new_meshinstance)
					new_meshinstance.set_owner(terrain)
					
	if event is InputEventMouseButton and event.pressed and event.button_index == 2:
		var UI = get_node("/root/level_editor/UI")
		var mode = UI.mode
		if mode == "edit":
			var space_state = get_world().direct_space_state
			var camera = get_node("/root/level_editor/camera_scene")
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * ray_length
			var intersection = space_state.intersect_ray(from, to)
			if intersection:
				var object_hit = intersection['collider']
				
				if object_hit.get_parent().name != "world_map":
					object_hit.get_parent().queue_free()
				 