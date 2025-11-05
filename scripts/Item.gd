# Item.gd 
extends Area2D

class_name Item

var is_being_dragged = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_being_dragged = event.is_pressed()
		
		if is_being_dragged:
			# When picked up, set z_index high so it draws on top.
			z_index = 10
		else:
			# When dropped, set z_index back to normal.
			z_index = 1 # Note: This doesn't remember its original z-index

func _process(delta):
	# If the item is being dragged, make it follow the mouse cursor.
	if is_being_dragged:
		global_position = get_global_mouse_position()
