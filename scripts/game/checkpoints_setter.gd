extends Node3D

func _ready():
  Race.init.call_deferred(get_children())
