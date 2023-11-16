extends Node2D

@onready var timer: Timer = $Timer
@onready var label: Label = $Label
@onready var timer_label: Label = $TimerLabel
var lost = false
func _ready():
  var bodies = get_tree().get_nodes_in_group("RigidBody")
  for body in bodies:
    body.gravity_scale *= Autoload.difficulty
    set_random_position(body)
  for i in range(bodies.size()):
    var body1 = bodies[i]
    for j in range(i + 1, bodies.size()):
      var body2 = bodies[j]
      while body1.global_position.distance_to(body2.global_position) < 100:
        set_random_position(body1)

func _physics_process(delta):
  var bodies = get_tree().get_nodes_in_group("RigidBody")
  if not lost:
    for body in bodies:
      if body.global_position.y >= 270:
        on_loss() 
func set_random_position(body: Node2D):
  var x = randi_range(192, 229)
  var y = randi_range(-70, -622)
  body.global_position = Vector2(x, y)

func on_loss():
  lost = true
  Autoload.losses += 1
  Autoload.previous_scene = 0
  Audio.get_node("Shatter").play()
  await get_tree().create_timer(1).timeout
  get_tree().change_scene_to_file("res://scenes/after_screen.tscn")

func _on_timer_timeout():
  Autoload.wins += 1
  Autoload.previous_scene = 0
  get_tree().change_scene_to_file("res://scenes/after_screen.tscn")

func _on_one_second_timer_timeout():
  timer_label.text = str(roundi(timer.time_left))

func _input(event):
  if not label.visible:
    return
  if event is InputEventMouseButton:
    label.visible = false
