# EndScreen.gd
extends Control

@onready var score_label = $ScoreLabel
@onready var missed_label = $MissedLabel
@onready var trashed_label = $TrashedLabel
@onready var play_again_button = $PlayAgainButton

func _ready():
	# Get final stats from our GameManager
	score_label.text = "Final Score: %s" % GameManager.total_score
	missed_label.text = "Contraband Missed: %s" % GameManager.total_contraband_missed
	trashed_label.text = "Good Items Trashed: %s" % GameManager.total_good_items_trashed
	
	play_again_button.pressed.connect(_on_play_again_pressed)

func _on_play_again_pressed():
	# Reset the GameManager
	GameManager.total_score = 0
	GameManager.current_round = 1
	GameManager.total_contraband_missed = 0
	GameManager.total_good_items_trashed = 0
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")
