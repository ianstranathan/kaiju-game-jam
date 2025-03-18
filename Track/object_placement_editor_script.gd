@tool
extends EditorScript


# TODO:
# It's not clear where the generated noise image is starting
# printing out values -> 
# if I offset by 10. I get the average value to be about zero: 0.03842154132629

# -- parent_global_position is here to allow this to work during runtime
func pos(parent_global_position: Vector3, _grid_indices: Vector2, grid_size: Vector2) -> Vector3:
	# -- offset is so we are cleanly populating from one side of square on base
	var offset := Vector3(-grid_size.x / 2, 0., +grid_size.y / 2)
	var ret := parent_global_position + offset
	return ret + Vector3(_grid_indices.y, 0.0, _grid_indices.x)


func _run() -> void:
	var noise: FastNoiseLite = FastNoiseLite.new()
	
	# -- need to set owner
	var track_nodes = get_editor_interface().get_selection().get_selected_nodes()[0]
	var base      = track_nodes.get_child(0)#get_aabb()
	var container = track_nodes.get_child(3)
	var base_mesh = base.get_children().filter( func(c): if c is MeshInstance3D: return c)[0]
	
	# -- the grid for keiths stuff will use building instead actually
	var mesh_grid = Vector2(base_mesh.get_aabb().size.x, base_mesh.get_aabb().size.z)
	print(mesh_grid)
	
	#var box = CSGBox3D.new()
	#box.set_owner(container.get_tree().get_edited_scene_tree_root())
	#container.add_child(box)
	#box.global_position = pos(Vector3.ZERO, Vector2(0, 0))
	#box.scale /= 

	#for i in range(grid_size.x):
		#for j in range(grid_size.y):
			#var noise_sample = noise.get_noise_2d(10. * i, 10. * j)
			#if noise_sample > 0:
				#var box = CSGBox3D.new() # -- should default to right params
				#box.set_owner( track )
				#base.add_child( box )
				#box.global_position = pos( base.global_position, Vector2(i, j))
	#var base = get_editor_interface().get_selection().
