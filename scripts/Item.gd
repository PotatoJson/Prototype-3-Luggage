# Item.gd
extends Area2D

class_name Item

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
		
		else:
			# --- DROP LOGIC ---
			if is_being_dragged:
				is_being_dragged = false
				item_currently_dragged = null

func _process(delta):
	if is_being_dragged:
		global_position = get_global_mouse_position()
