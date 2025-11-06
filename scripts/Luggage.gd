# Luggage.gd
extends Area2D
class_name Luggage

const ITEM_SCENE = preload("res://scenes/item.tscn")

var common_items = [
	"res://assets/pants.png",
	"res://assets/sock.png",
	"res://assets/shirt.png",
	"res://assets/WaterEmpty.png"
]
var rare_items = [
	"res://assets/Laptop.png"
]
var contraband = [
	"res://assets/Lighter.png",
	"res://assets/Water.png",
	"res://assets/Knife.png"
]

@onready var sprite_closed = $SpriteClosed
@onready var sprite_open = $SpriteOpen
@onready var item_container = $ItemContainer
@onready var collision_shape = $CollisionShape

var is_open = false

# --- CORE FUNCTIONS ---

func _ready():
	print("--- LUGGAGE SCRIPT: _ready() has started. ---")
	
	sprite_closed.visible = true
	sprite_open.visible = false
	item_container.visible = false
	collision_shape.disabled = false
	populate_luggage()

func _input_event(viewport, event, shape_idx):
	# This click event is for the LUGGAGE ONLY.
	if not is_open and event is InputEventMouseButton and event.is_pressed():
		open_luggage()

func open_luggage():
	is_open = true
	sprite_closed.visible = false
	sprite_open.visible = true
	item_container.visible = true
	collision_shape.disabled = true # Disables the luggage's *own* shape
	
func get_all_remaining_items():
	return item_container.get_children()

# --- ITEM SPAWNING ---

func populate_luggage():
	var common_amount = randi_range(20, 30)
	for i in common_amount:
		var random_texture_path = common_items.pick_random()
		spawn_item(random_texture_path, false)

	if randf() < 1:
		var random_texture_path = rare_items.pick_random()
		spawn_item(random_texture_path, false)
		
	var contraband_amount = randi_range(0, 3)
	for i in contraband_amount:
		var random_texture_path = contraband.pick_random()
		spawn_item(random_texture_path, true)

func spawn_item(texture_path: String, is_contraband_item: bool):
	var item_instance = ITEM_SCENE.instantiate()
	
	item_instance.is_contraband = is_contraband_item
	
	var sprite = item_instance.get_node("ItemSprite")
	sprite.texture = load(texture_path)
	
	var texture_size = sprite.texture.get_size()
	var new_shape = RectangleShape2D.new()
	new_shape.size = texture_size * 0.75
	
	var collision_shape_node = item_instance.get_node("CollisionShape")
	collision_shape_node.shape = new_shape
	collision_shape_node.disabled = false # Make sure hitbox is on
	
	var random_x = randf_range(-50, 50)
	var random_y = randf_range(-30, 30)
	item_instance.position = Vector2(random_x, random_y)
	
	var start_z = randi_range(1, 5)
	item_instance.z_index = start_z
	
	item_container.add_child(item_instance)
