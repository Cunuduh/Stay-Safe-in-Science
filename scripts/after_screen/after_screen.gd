extends Control

@onready var lives: AnimatedSprite2D = $Lives
@onready var safety_tip: AnimatedSprite2D = $SafetyTip
@onready var safety_tip_label: Label = $SafetyTip/Label
@onready var win_counter: Label = $WinCounter
var minigame_1 = preload("res://scenes/minigame_1.tscn")
var minigame_2 = preload("res://scenes/minigame_2.tscn")
var minigame_3 = preload("res://scenes/minigame_3.tscn")
var minigame_4 = preload("res://scenes/minigame_4.tscn")
var minigame_5 = preload("res://scenes/minigame_5.tscn")
var arr_scenes = [minigame_1, minigame_2, minigame_3, minigame_4, minigame_5]
var p_l = Autoload.prev_losses

func _ready():
  win_counter.text = str(Autoload.wins) + " wins" if Autoload.wins != 1 else str(Autoload.wins) + " win"
  lives.frame = Autoload.prev_losses
  if Autoload.previous_scene == null:
    safety_tip.visible = false
    safety_tip_label.visible = false
  else:
    safety_tip.visible = true
    safety_tip_label.visible = true
    safety_tip.frame = Autoload.previous_scene
    safety_tip_label.text = label_text(Autoload.previous_scene)
  await get_tree().create_timer(1.0).timeout
  if Autoload.losses > p_l:
    shake_lives()
    lives.frame = Autoload.losses
    Audio.get_node("Shatter").play()
func load_random_scene():
  Autoload.prev_losses = Autoload.losses
  var random_scene = randi() % arr_scenes.size()
  while random_scene == Autoload.previous_scene:
    random_scene = randi() % arr_scenes.size()
  get_tree().change_scene_to_packed(arr_scenes[random_scene])

func shake_lives(shake_count=10, shake=2):
  for i in shake_count:
    var tween = get_tree().create_tween()
    tween.tween_property(lives, "offset", Vector2(randi_range(-shake, shake), randi_range(-shake, shake)), 0.03)
    await get_tree().create_timer(0.03).timeout
  lives.offset = Vector2.ZERO
func _on_button_pressed():
  if Autoload.losses == 3:
    get_tree().change_scene_to_file("res://scenes/main.tscn")
  else:
    Autoload.difficulty += 0.1 if Autoload.wins % 3 == 0 and Autoload.losses == p_l and Autoload.difficulty < 1.5 else 0.0
    load_random_scene()

func label_text(scene):
  match scene:
    0:
      return "Don't be that guy who has to clean up/call the custodian!"
    1:
      return "Know where the safety equipment is!"
    2:
      return "Your safety goggles might be dirty but at least your eyes won't blow up. Wear proper clothing in the lab!"
    3:
      return "Read the labels on the chemicals you're using. Also know what you're doing with them!"
    4:
      return "Tie long hair back. You don't want to set your hair on fire!"
    _: return ""
