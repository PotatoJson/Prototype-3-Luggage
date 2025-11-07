# Item.gd
extends Area2D

class_name Item

var is_contraband: bool = false

# Static variables 
static var item_currently_dragged = null
static var current_top_z = 1

var is_being_dragged = false

func _ready():
	z_index = current_top_z
	current_top_z += 1

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if event.is_pressed():
			# PICK UP LOGIC 
			if item_currently_dragged == null:
				is_being_dragged = true
				item_currently_dragged = self
				
				current_top_z += 1
				z_index = current_top_z
		
		else:
			# DROP LOGIC
			if is_being_dragged:
				is_being_dragged = false
				item_currently_dragged = null
				
				var overlapping_areas = get_overlapping_areas()
				for area in overlapping_areas:
					# Check if the area is a Trashcan
					if area.is_in_group("Trashcan"):
						# Tell the trashcan what we are before we die
						if area.has_method("item_was_trashed"):
							area.item_was_trashed(is_contraband)
						
						queue_free() # Delete the item
						break # Stop checking

func _process(delta):
	if is_being_dragged:
		global_position = get_global_mouse_position()
