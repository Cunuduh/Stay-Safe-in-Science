extends Node2D

@onready var timer_label: Label = $TimerLabel
@onready var timer: Timer = $Timer
@onready var mask: Sprite2D = $Mask
@onready var mask_area: Area2D = $Mask/Area2D
var found = false
func _ready():
  timer.start(10 - (10 * (Autoload.difficulty - 1)))
  timer_label.text = str(roundi(timer.time_left))
  mask.global_transform.origin = get_global_mouse_position()
  for sprite in get_tree().get_nodes_in_group("Sprite2D"):
    set_random_position(sprite)

func _physics_process(delta):
  if not found:
    follow_mouse_slowly()

func _on_one_second_timer_timeout():
  timer_label.text = str(roundi(timer.time_left))

func follow_mouse_slowly():
  var mouse_pos = get_global_mouse_position()
  var new_pos = mask.global_transform.origin.lerp(mouse_pos, 0.01)
  mask.global_transform.origin = new_pos

func set_random_position(body: Node2D):
  var x = randi_range(0, get_viewport_rect().size.x)
  var y = randi_range(0, get_viewport_rect().size.y)
  body.global_position = Vector2(x, y)
  if body.global_position.distance_to(mask.global_transform.origin) < 30:
    set_random_position(body)

func _on_area_2d_area_entered(area:Area2D):
  found = true
  Autoload.wins += 1
  Autoload.previous_scene = 1
  var tween = get_tree().create_tween()
  tween.tween_property(mask, "position", area.global_transform.origin, 0.5).set_trans(Tween.TRANS_QUAD)
  await get_tree().create_timer(2).timeout
  get_tree().change_scene_to_file("res://scenes/after_screen.tscn")

func _on_timer_timeout():
  if not found:
    Autoload.losses += 1
    Autoload.previous_scene = 1
    get_tree().change_scene_to_file("res://scenes/after_screen.tscn")
