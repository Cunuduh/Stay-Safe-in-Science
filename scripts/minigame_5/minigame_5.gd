extends Node2D

var clicks = 0
@onready var click_counter = $ClickCounter
@onready var person = $Person
@onready var timer = $Timer
@onready var timer_label = $TimerLabel
func _ready():
  timer.start(10 - (10 * (Autoload.difficulty - 1)))
  timer_label.text = str(roundi(timer.time_left))
func _process(delta):
  if Input.is_action_just_pressed("left_mouse_button") and clicks < 50:
    clicks += 1
    click_counter.text = str(50 - clicks)
    if clicks >= 50:
      Autoload.wins += 1
      Autoload.previous_scene = 4
      person.frame = 1
      timer.paused = true
      await get_tree().create_timer(1.0).timeout
      get_tree().change_scene_to_file("res://scenes/after_screen.tscn")

func _on_one_second_timer_timeout():
  timer_label.text = str(roundi(timer.time_left))

func _on_timer_timeout():
  Autoload.losses += 1
  Autoload.previous_scene = 4
  get_tree().change_scene_to_file("res://scenes/after_screen.tscn")

