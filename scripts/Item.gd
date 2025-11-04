# Item.gd
extends Area2D

class_name Item

var is_being_dragged = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Toggle the drag state when the left mouse button is pressed or released.
		is_being_dragged = event.is_pressed()
		
		# When we pick up an item, bring it to the front so it renders
		# on top of other items.
		if is_being_dragged:
			z_index = 10
		else:
			z_index = 1 # Set it back to a normal layer

# _process runs on every frame.
func _process(delta):
	# If the item is being dragged, update its position to the mouse's position.
	if is_being_dragged:
		global_position = get_global_mouse_position()
