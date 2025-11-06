extends Area2D

class_name Item

var is_contraband: bool = false

# --- Static variables (shared by all items) ---
static var item_currently_dragged = null
static var current_top_z = 1 # Tracks the "top" of the pile

# --- This item's variables ---
var is_being_dragged = false

func _ready():
	# Give each item a unique starting layer
	z_index = current_top_z
	current_top_z += 1

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if event.is_pressed():
			# --- PICK UP LOGIC ---
			if item_currently_dragged == null:
				is_being_dragged = true
				item_currently_dragged = self
				
				# Bring this item to the very top of the pile
				current_top_z += 1
				z_index = current_top_z

func _unhandled_input(event):
	if not is_being_dragged:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.is_pressed():
			
			# --- DROP LOGIC ---
			is_being_dragged = false
			item_currently_dragged = null # Release the drag lock
				
			# --- Check for Trashcan ---
			# Get a list of all areas this item is overlapping
			var overlapping_areas = get_overlapping_areas()
			for area in overlapping_areas:
				# Check if any of them are in the "Trashcan" group
				if area.is_in_group("Trashcan"):
					queue_free() # Delete the item
					break # Stop checking

			get_viewport().set_input_as_handled()

func _process(delta):
	if is_being_dragged:
		global_position = get_global_mouse_position()
