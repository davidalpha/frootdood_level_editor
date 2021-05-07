extends Spatial

export var noise_period = 20
export var noise_octaves = 6


func _ready():

	var noise = OpenSimplexNoise.new()
	noise.period = noise_period
	noise.octaves = noise_octaves
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(400,400)
	plane_mesh.subdivide_depth = 400
	plane_mesh.subdivide_width = 400
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh, 0)	
	
	var array_plane = surface_tool.commit()
	
	var data_tool = MeshDataTool.new()
	
	data_tool.create_from_surface(array_plane, 0)
	
	for i in range (data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x, vertex.y, vertex.z) * 20
		
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
	mesh_instance.set_surface_material(0, load("res://terrain_spatial.tres"))
	
	add_child(mesh_instance)
			
