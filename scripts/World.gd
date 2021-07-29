extends Spatial

export var noise_period = 64
export var noise_octaves = 3
export var noise_lacunarity = 2.0
export var noise_seed = 1234
export var noise_persistence = 0.5
export var size_depth = 400
export var size_width = 400
export var subdivide = 400
export var steepness = 2
export var height_map : Image


func _ready():
	var height_map = Image.new()
	height_map.load("res://assets/height_map.png")
	height_map.lock()

	var noise = OpenSimplexNoise.new()
	noise.period = noise_period
	noise.octaves = noise_octaves
	noise.lacunarity = noise_lacunarity
	noise.seed = noise_seed
	noise.persistence = noise_persistence
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size_depth,size_width)
	plane_mesh.subdivide_depth = subdivide
	plane_mesh.subdivide_width = subdivide
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh, 0)	
	
	var array_plane = surface_tool.commit()
	
	var data_tool = MeshDataTool.new()
	
	data_tool.create_from_surface(array_plane, 0)
	
	for i in range (data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		var pixel_x = int(vertex.x+ 200)/2 
		var pixel_y = int(vertex.z+ 200)/2
		vertex.y = height_map.get_pixel(pixel_x, pixel_y).r * steepness
		
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
	mesh_instance.set_surface_material(0, load("res://shaders/terrain_shader.tres"))
	
	add_child(mesh_instance)
			
