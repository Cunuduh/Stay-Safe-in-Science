extends Control

var minigame_1 = preload("res://scenes/minigame_1.tscn")
var minigame_2 = preload("res://scenes/minigame_2.tscn")
var minigame_3 = preload("res://scenes/minigame_3.tscn")
var minigame_4 = preload("res://scenes/minigame_4.tscn")
var minigame_5 = preload("res://scenes/minigame_5.tscn")
var arr_scenes = [minigame_1, minigame_2, minigame_3, minigame_4, minigame_5]

func _on_start_pressed():
  Autoload.losses = 0
  Autoload.wins = 0
  Autoload.prev_losses = 0
  Autoload.previous_scene = null
  Autoload.difficulty = 1.0
  load_random_scene()

func load_random_scene():
  var random_scene = randi() % arr_scenes.size()
  get_tree().change_scene_to_packed(arr_scenes[random_scene])
