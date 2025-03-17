extends Node3D


func get_track_width() -> float:
	# -- children are Node3D
	# -- child of children have a mesh instance & a static body
	# -- pick any child => child(0)
	# -- filter the children for a mesh instance (name can vary by model import)
	var array_mesh_aabb = get_child(0).get_children().filter( func(child):
		if child is MeshInstance3D:
			return child)[0].get_aabb()
	
	return array_mesh_aabb.size.x if array_mesh_aabb else 0.0
