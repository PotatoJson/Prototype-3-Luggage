# Main.gd (Simplified Reloading Version)
extends Node2D

# We only need a reference to the button and the luggage
@onready var approve_button = $CanvasLayer/ApproveButton
@onready var current_luggage = $Luggage as Luggage # Find the luggage in the scene

func _ready():
	print("Main.gd: _ready() called.")
	
	# Check if we found the luggage
	if not is_instance_valid(current_luggage):
		print("ERROR: Can't find the 'Luggage' node in Main.tscn!")
		return
	
	# Connect the button
	approve_button.pressed.connect(_on_approve_pressed)
	print("Main.gd: Ready. Waiting for approve press.")

func _on_approve_pressed():
	print("Main.gd: Approve button pressed.")
	
	if not is_instance_valid(current_luggage):
		print("Main.gd: ERROR! current_luggage is not valid.")
		return

	# --- Check for Contraband ---
	var remaining_contraband = 0
	for item in current_luggage.get_all_remaining_items():
		if item is Item and item.is_contraband:
			remaining_contraband += 1
	
	print("Main.gd: Found %s remaining contraband." % remaining_contraband)
	
	if remaining_contraband == 0:
		print("Main.gd: Correct! Reloading scene.")
		# This is the only line we need to restart!
		get_tree().reload_current_scene()
	else:
		print("Main.gd: Incorrect! You missed %s contraband." % remaining_contraband)
