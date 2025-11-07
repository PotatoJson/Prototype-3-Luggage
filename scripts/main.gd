# main.gd
extends Node2D

@onready var approve_button = $CanvasLayer/ApproveButton
@onready var round_label = $CanvasLayer/RoundLabel
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var current_luggage = $Luggage as Luggage
@onready var trashcan = $Trashcan

func _ready():
	if not is_instance_valid(current_luggage):
		print("ERROR: Can't find the 'Luggage' node in main.tscn!")
		return
	if not is_instance_valid(trashcan):
		print("ERROR: Can't find the 'Trashcan' node in main.tscn!")
		return
	
	approve_button.pressed.connect(_on_approve_pressed)
	
	GameManager.start_new_round() 
	round_label.text = "Round: %s / %s" % [GameManager.current_round, GameManager.MAX_ROUNDS]
	score_label.text = "Score: %s" % GameManager.total_score

func _on_approve_pressed():
	if not is_instance_valid(current_luggage):
		print("ERROR: current_luggage is not valid.")
		return

	# Check for missed contraband
	var contraband_missed = 0
	for item in current_luggage.get_all_remaining_items():
		if item is Item and item.is_contraband:
			contraband_missed += 1
	
	# Get mistake count from trashcan
	var good_items_trashed = 0
	if trashcan.has_method("get_mistake_count"):
		good_items_trashed = trashcan.get_mistake_count()
	
	print("Main.gd: Mistakes: %s contraband missed, %s good items trashed." % [contraband_missed, good_items_trashed])
	
	# Report BOTH mistake types to GameManager
	approve_button.disabled = true
	GameManager.process_luggage_result(contraband_missed, good_items_trashed)
