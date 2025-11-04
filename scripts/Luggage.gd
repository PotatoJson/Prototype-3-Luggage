# Luggage.gd
extends Area2D

# --- Node References ---
# Make sure your node names in the Scene tree match these variables!
@onready var sprite_closed = $SpriteClosed
@onready var sprite_open = $SpriteOpen
@onready var item_container = $ItemContainer
@onready var collision_shape = $CollisionShape # The main collision for the luggage

# --- State Variable ---
# This tracks if the luggage is open or closed.
var is_open = false

# _ready() runs once when the game starts.
func _ready():
	# Set the initial "closed" state.
	sprite_closed.visible = true
	sprite_open.visible = false
	
	# Hide all items by hiding their parent container.
	item_container.visible = false
	
	# Make sure the main collision is ON, so we can click the luggage.
	collision_shape.disabled = false

# This function runs when the Luggage's own CollisionShape is clicked.
func _input_event(viewport, event, shape_idx):
	# Check if we're not already open AND if the mouse was just clicked.
	if not is_open and event is InputEventMouseButton and event.is_pressed():
		# Call the function to open the suitcase.
		open_luggage()

# This function handles the switch from "closed" to "open".
func open_luggage():
	is_open = true
	
	# Swap the sprites.
	sprite_closed.visible = false
	sprite_open.visible = true
	
	# Show all the items by making their parent container visible.
	item_container.visible = true
	
	# Disable the luggage's main collision shape.
	collision_shape.disabled = true
