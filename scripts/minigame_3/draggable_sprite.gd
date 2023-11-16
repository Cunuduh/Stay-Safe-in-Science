extends Sprite2D

@onready var area = $Area2D
var hovering = false
var held = false
func _physics_process(delta):
  if Input.is_action_just_pressed("left_mouse_button") and hovering:
    # if overlapping with another item and z-index is lower, do nothing
    if area.get_overlapping_areas().size() > 0:
      for overlapping_area in area.get_overlapping_areas():
        if overlapping_area.get_parent().z_index > z_index:
          return
    pickup()
  elif Input.is_action_just_released("left_mouse_button"):
    drop()
  if held:
    global_position = get_viewport().get_mouse_position()
func _on_mouse_entered():
  hovering = true
func _on_mouse_exited():
  await get_tree().create_timer(0.1).timeout
  hovering = false
func pickup():
  if held:
    return
  held = true
func drop():
  if not held:
    return
  held = false
