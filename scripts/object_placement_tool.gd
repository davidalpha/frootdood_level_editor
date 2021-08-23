extends Spatial

const ray_length = 1000
var object_type = ""
var TIME = 0
var rock1 = preload("res://scenes/static_objects/rock1.tscn")
var rock2 = preload("res://scenes/static_objects/rock2.tscn")
var rock3 = preload("res://scenes/static_objects/rock3.tscn")
var grass = preload("res://scenes/static_objects/grass.tscn")
var cube3x3 = preload("res://scenes/static_objects/cube3.tscn")
var palm_tree_straight = preload("res://scenes/static_objects/palmtree_straight.tscn")
var palm_tree_curly = preload("res://scenes/static_objects/palmtree_curly.tscn")
var statue_lanky = preload("res://scenes/static_objects/statue_lanky_diamond.tscn")
var banana = preload("res://scenes/static_objects/banana_long.tscn")
var brush_sprite_scene = preload("res://scenes/Brush.tscn")

var rocks_arr = [rock1, rock2, rock3]
var brush_sprite
var brush_basis_transform
var terrain_normal
var intersect_pos

#onready var UI = get_node("/root/level_editor/UI")
onready var camera = get_node("/root/level_editor/camera_scene")
onready var terrain = get_node("/root/level_editor/terrain")

func _ready():
	brush_sprite = brush_sprite_scene.instance()
	add_child(brush_sprite)
	brush_basis_transform = brush_sprite.transform.basis

# places object and modifies the object randomly based on the options. scaling_min set to 0 disables all scaling, other values set to 0 will also disable them.
# object, scaling_min, scaling_max, rotating_y, rotating_z, height, match_terrain

func place(object, scaling_min, scaling_max, rotating_y, rotating_z, height, match_terrain):
	var object_instance = object.instance()
	var object_norm = object_instance.transform.basis.y
	object_instance.transform.origin = Vector3(intersect_pos)
	
	# calculate cross between object and terrain normal
	var cosa = object_norm.dot(terrain_normal)
	var alpha = acos(cosa)
	var axis = object_norm.cross(terrain_normal)
	axis = axis.normalized()
	
	# rotate along Y axis randomly
	if rotating_y:
		object_instance.transform.basis = object_instance.transform.basis.rotated(Vector3(0.0,1.0,0.0), (PI*rand_range(0,2)))
		
	if rotating_z:
		object_instance.rotate_z(rand_range(-PI/8, PI/8))
	
	# Rotate object to match terrain
	if match_terrain:
		if !is_nan(alpha) and axis.is_normalized():
			object_instance.transform.basis = object_instance.transform.basis.rotated(axis, alpha)
	
	# scale randomly
	if scaling_min:
		object_instance.transform.basis = object_instance.transform.basis.scaled(Vector3(rand_range((scaling_min), (scaling_max)),rand_range((scaling_min), (scaling_max)),rand_range((scaling_min), (scaling_max))))
	
	if height:
		object_instance.transform.origin.y = object_instance.transform.origin.y + height
	
	terrain = get_node("/root/level_editor/terrain")
	terrain.add_child(object_instance)
	object_instance.set_owner(terrain)

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
				intersect_pos = intersection['position']
				terrain_normal = intersection['normal']
				terrain_normal = terrain_normal.normalized()
				
			#placable objects. parameters are object, scaling_min, scaling_max, rotating_y, rotating_z, height, match_terrain
				
				object_type = UI.object_selected
				if object_type == "rocks":
					rocks_arr.shuffle()
					var rock = rocks_arr[0]
					place(rock, 0.5,1.5,1,0,0,1)
					
					
				if object_type == "grass":
					place(grass, 0.5,1.5,1,0,0,1)
				
				if object_type == "cube3x3":
					place(cube3x3, 0,2,0,0,0,0)
					
				if object_type == "palm_tree_straight":
					place(palm_tree_straight, 1,2,1,0,0,0)
					
				if object_type == "palm_tree_curly":
					place(palm_tree_curly, 1,1.2,1,0,0,0)
					
				if object_type == "banana":
					place(banana, 0,0,1,0,0,0)
					
				if object_type == "statue_lanky":
					place(statue_lanky, 1,3,1,1,-2,1)
					
# RMB is delete. Delete the collided object and its parent if its not terrain.
				
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
				var parent_node = object_hit.owner
				print(parent_node)
				print(object_hit.name)
				
				if object_hit.get_parent().name != "world_map":
					parent_node.queue_free()
				 
func _process(delta):
	TIME += delta
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_world().get_direct_space_state()
	# use global coordinates, not local to node
	var intersection = space_state.intersect_ray( from, to )
	if intersection:
		
		var brush_position = intersection["position"]

		brush_sprite.transform.basis = brush_basis_transform
		brush_sprite.transform.origin = Vector3(brush_position)
		
		var object_normal = brush_sprite.transform.basis.y
		var intersect_normal = intersection['normal']
		intersect_normal = intersect_normal.normalized()
		
		var cosa = object_normal.dot(intersect_normal)

		var alpha = acos(cosa)

		var axis = object_normal.cross(intersect_normal)
		axis = axis.normalized()

		if !is_nan(alpha) and axis.is_normalized():
			brush_sprite.transform.basis = brush_sprite.transform.basis.rotated(axis, alpha)


		
