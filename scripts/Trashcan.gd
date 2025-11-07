# Trashcan.gd
extends Area2D

var good_items_trashed_this_round: int = 0

func _ready():
	# Make sure this node is in the "Trashcan" group!
	# You did this in Step 2 from our previous conversation.
	pass

# This function will be called by the Item.gd script
func item_was_trashed(was_contraband: bool):
	if not was_contraband:
		good_items_trashed_this_round += 1
		print("Trashcan: A good item was trashed! (Mistake)")
	else:
		print("Trashcan: Contraband was trashed. Good job.")

# This lets the main.gd script get the mistake count
func get_mistake_count() -> int:
	return good_items_trashed_this_round
