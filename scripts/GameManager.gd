# GameManager.gd
extends Node

const MAX_ROUNDS = 5

var total_score: int = 0
var current_round: int = 1
var round_start_time: float = 0.0

var total_contraband_missed: int = 0
var total_good_items_trashed: int = 0

func _ready():
	start_new_round()

func start_new_round():
	round_start_time = Time.get_ticks_msec()

# --- UPDATED FUNCTION ---
func process_luggage_result(contraband_missed: int, good_items_trashed: int):
	# Update total mistake counts
	total_contraband_missed += contraband_missed
	total_good_items_trashed += good_items_trashed
	
	# 2. Calculate score
	var time_taken_sec = (Time.get_ticks_msec() - round_start_time) / 1000.0
	
	var time_penalty = int(time_taken_sec * 200) 
	var contraband_penalty = contraband_missed * 5000 # 2500 points per contraband missed
	var trash_penalty = good_items_trashed * 500     # 500 points per good item trashed
	var mistake_penalty = contraband_penalty + trash_penalty
	
	var round_score = 10000 - time_penalty - mistake_penalty
	
	total_score += round_score
	
	print("Round %s complete. Mistakes: %s missed, %s trashed. Score: %s, Total: %s" % [current_round, contraband_missed, good_items_trashed, round_score, total_score])
	
	if current_round >= MAX_ROUNDS:
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
	else:
		current_round += 1
		get_tree().reload_current_scene()
