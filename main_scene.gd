extends Node2D

func _ready()->void:	
	var modification_stack: SkeletonModificationStack2D = $"Skeleton2D".get_modification_stack()
	# Better to enable it at runtime as it makes it harder to interact with in the editor when on
	modification_stack.enabled = true
	
	var modification_physical_bones = modification_stack.get_modification(0)
	modification_physical_bones.enabled = true
	
	fix_skeleton($Skeleton2D)
	
	modification_physical_bones.fetch_physical_bones()
	# this will enable simulate_physics on all bones
	modification_physical_bones.start_simulation()
	
	# if you call stop_simulation() then start_simulation() again it will break until you freeze and unfreeze each bone
	modification_physical_bones.stop_simulation()
	modification_physical_bones.start_simulation()
	fix_skeleton($Skeleton2D)

func fix_skeleton(target: Skeleton2D):
	for child in target.get_children():
		if child is PhysicalBone2D:
			call_child_recursive(child, update_bone)

func call_child_recursive(node: Node2D, f: Callable):
	f.call(node)
	for child in node.get_children():
		call_child_recursive(child, f)

func update_bone(bone: Node2D):
	if bone is PhysicalBone2D:
		if !bone.simulate_physics:
			# there might be yet another bug regarding the resulting position of bone and its children after enabling simulate_physics
			# recommended to check it in the editor and ensure the position is correct
			print("warning: " + bone.name + " simulate_physics is not checked!")
		# this will undo the cpp constructor
		bone.freeze = true
		bone.freeze = false
