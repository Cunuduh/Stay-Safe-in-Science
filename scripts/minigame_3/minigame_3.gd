extends Node2D
@onready var t_pose = $TPose
@onready var timer_label = $TimerLabel
@onready var timer = $Timer
var correct_clothing = 0
var incorrect_clothing = 0

func _ready():
  timer.start(10 - (10 * (Autoload.difficulty - 1)))
  timer_label.text = str(roundi(timer.time_left))
  var clothes = get_tree().get_nodes_in_group("Sprite2D")
  for clothing in clothes:
    set_random_position(clothing)

    for i in range(clothes.size()):
      var clothing_1 = clothes[i]
      for j in range(i + 1, clothes.size()):
        var clothing_2 = clothes[j]
        while clothing_1.global_position.distance_to(clothing_2.global_position) < 30:
          set_random_position(clothing_1)

func set_random_position(body: Node2D):
  var x = randi_range(0, get_viewport_rect().size.x / 2)
  var y = randi_range(0, get_viewport_rect().size.y)
  body.global_position = Vector2(x, y)

func _on_area_2d_area_entered(area:Area2D):
  match area.get_parent().name:
    "Shirt":
      if $Underwear.global_position == $ShirtPos.global_position:
        return
      $Shirt.global_position = $ShirtPos.global_position
      $Shirt.drop()
      correct_clothing += 1
    "Underwear":
      if $Shirt.global_position == $ShirtPos.global_position:
        return
      $Underwear.global_position = $ShirtPos.global_position
      $Underwear.drop()
      incorrect_clothing += 1
    "Shoes":
      $Shoes.global_position = $FeetPos.global_position
      $Shoes.drop()
      correct_clothing += 1
    "SafetyGoggles":
      if $GrouchoGlasses.global_position == $EyePos.global_position:
        return
      $SafetyGoggles.global_position = $EyePos.global_position
      $SafetyGoggles.drop()
      correct_clothing += 1
    "GrouchoGlasses":
      if $SafetyGoggles.global_position == $EyePos.global_position:
        return
      $GrouchoGlasses.global_position = $EyePos.global_position
      $GrouchoGlasses.drop()
      incorrect_clothing += 1

func _on_area_2d_area_exited(area:Area2D):
  match area.get_parent().name:
    "Shirt":
      correct_clothing -= 1
    "Underwear":
      incorrect_clothing -= 1
    "Shoes":
      correct_clothing -= 1
    "SafetyGoggles":
      correct_clothing -= 1
    "GrouchoGlasses":
      incorrect_clothing -= 1

func _on_timer_timeout():
  if correct_clothing < 3 or incorrect_clothing > 0:
    Autoload.losses += 1
  else:
    Autoload.wins += 1
  Autoload.previous_scene = 2
  get_tree().change_scene_to_file("res://scenes/after_screen.tscn")

func _on_one_second_timer_timeout():
  timer_label.text = str(roundi(timer.time_left))

