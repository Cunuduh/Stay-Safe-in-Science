extends RigidBody2D

var hovering = false
var held = false
func _ready():
  gravity_scale *= Autoload.difficulty
func _physics_process(delta):
  if Input.is_action_just_pressed("left_mouse_button") and hovering:
    pickup()
  elif Input.is_action_just_released("left_mouse_button"):
    drop(Input.get_last_mouse_velocity() * gravity_scale * 0.1)
  if held:
    apply_central_force(((get_global_mouse_position() - global_position) * 75 - linear_velocity * 10) * gravity_scale)
func _on_mouse_entered():
  hovering = true
func _on_mouse_exited():
  await get_tree().create_timer(0.1).timeout
  hovering = false
func pickup():
  if held:
    return
  held = true
func drop(impulse=Vector2.ZERO):
  if not held:
    return
  held = false
  apply_central_impulse(impulse)
