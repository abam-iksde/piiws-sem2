extends Node

var values = {}

func get_value(key, default):
  return values.get(key, default)

func set_value(key, value):
  values[key] = value
