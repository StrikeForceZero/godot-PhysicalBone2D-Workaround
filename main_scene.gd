extends Node2D

func _ready()->void:
	$"Skeleton2D/PhysicalBone2D".simulate_physics = true
	
	var modification_stack = $"Skeleton2D".get_modification_stack()
	modification_stack.enabled = true
	
	var modification_physical_bones = modification_stack.get_modification(0)
	modification_physical_bones.enabled = true
	
	modification_physical_bones.fetch_physical_bones()
	modification_physical_bones.start_simulation()
