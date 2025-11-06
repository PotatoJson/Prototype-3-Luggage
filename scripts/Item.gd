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
			# This part is fine, as we MUST click *on* the item to pick it up.
			if item_currently_dragged == null:
				is_being_dragged = true
				item_currently_dragged = self
				
				# Bring this item to the very top of the pile
				current_top_z += 1
				z_index = current_top_z
		
		# --- WE REMOVE THE "ELSE" (DROP) LOGIC FROM HERE ---

# We move the "DROP" logic to a function that can catch
# a mouse release *anywhere* on the screen.
func _unhandled_input(event):
	# This function runs for *all* items,
	# so we only care about the one *currently* being dragged.
	if not is_being_dragged:
		return

	# Now we check for the mouse release
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.is_pressed():
			
			# --- DROP LOGIC (MOVED HERE) ---
			is_being_dragged = false
			item_currently_dragged = null # Release the drag lock
				
			# --- NEW CODE: Check for Trashcan ---
			# Get a list of all areas this item is overlapping
			var overlapping_areas = get_overlapping_areas()
			for area in overlapping_areas:
				# Check if any of them are in the "Trashcan" group
				if area.is_in_group("Trashcan"):
					queue_free() # Delete the item
					break # Stop checking
			# --- END OF NEW CODE ---

			# We handled this "drop" input, so stop other nodes
			# from processing this mouse release.
			get_viewport().set_input_as_handled()

func _process(delta):
	if is_being_dragged:
		global_position = get_global_mouse_position()
