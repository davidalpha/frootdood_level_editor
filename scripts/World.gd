tool
extends Node

#export var subdivide = 1

var steepness = 30
export var height_map : Image
export var smoothness : float

var image_height
var image_width

func _ready():
	height_map.lock()
	image_height = height_map.get_height()
	image_width = height_map.get_width()
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(image_height, image_width)
	
	plane_mesh.subdivide_depth = (image_height*smoothness)
	plane_mesh.subdivide_width = (image_width*smoothness)
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh, 0)	
	
	var array_plane = surface_tool.commit()
	
	var data_tool = MeshDataTool.new()
	
	data_tool.create_from_surface(array_plane, 0)
	print(data_tool.get_vertex_count())
	for i in range (data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		
#		# DEBUG DRAW
#		var debug_vertex = ImmediateGeometry.new()
#		debug_vertex.begin(Mesh.PRIMITIVE_LINES)
#		debug_vertex.set_color(Color.red)
#		debug_vertex.add_vertex(vertex)
#		# DEBUG
		
		var pixel_x_float = round(vertex.x + (image_width/2))
		var pixel_x = int(pixel_x_float)
		var pixel_y_float = round(vertex.z + (image_height/2))
		var pixel_y = int(pixel_y_float)
		var pixel = height_map.get_pixel(pixel_x, pixel_y)
		vertex.y = pixel.r * steepness
		
#		# DEBUG
#		debug_vertex.add_vertex(vertex)
#		debug_vertex.end()
#		self.add_child(debug_vertex)
#		# DEBUG
		
		data_tool.set_vertex(i, vertex)
		
	for i in range (array_plane.get_surface_count()):
		array_plane.surface_remove(i)
			
	
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	
	var mesh_instance = MeshInstance.new()
	
	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.create_trimesh_collision()
	mesh_instance.set_surface_material(0, load("res://shaders/terrain_spatial.tres"))
	mesh_instance.name = "world_map"
	$terrain.add_child(mesh_instance)
	_recursively_set_owner($terrain, $terrain)
	
	
	
func save_scene():
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_node("/root/level_editor/terrain"))
	#packed_scene.pack(get_tree().get_current_scene())
	var timestamp = str(OS.get_unix_time())
	var response = ResourceSaver.save(("res://saved_levels/level" + timestamp + ".tscn"), packed_scene)
	if response == OK:
		print("Saved level succesfully as level" + timestamp)
	else:
		print("Save failed!")

		
func _recursively_set_owner(root: Node, owner: Node) -> void:
	for child in root.get_children():
		child.owner = owner
		_recursively_set_owner(child, owner)
