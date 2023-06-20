extends Node3D

func activate():
  var rocket = preload('res://scenes/prefabs/game/rocket.tscn').instantiate()
  rocket.shooter = get_node('../..')
  get_node('../../..').add_child(rocket)
  rocket.global_position = global_position
  rocket.global_rotation = get_node('../../sprite').global_rotation
