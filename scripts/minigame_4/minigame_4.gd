extends Node2D

@onready var timer_label = $TimerLabel
@onready var timer = $Timer
func _on_area_2d_area_entered(area:Area2D):
  Autoload.losses += 1
  Autoload.previous_scene = 3
  get_tree().change_scene_to_file("res://scenes/after_screen.tscn")

func _on_timer_timeout():
  Autoload.wins += 1
  Autoload.previous_scene = 3
  get_tree().change_scene_to_file("res://scenes/after_screen.tscn")

func _on_one_second_timer_timeout():
  timer_label.text = str(roundi(timer.time_left))

