extends Node

const race_default_settings = {
  'players': [
    {
      texture = preload('res://textures/vehicles/car_red.png'),
      viewport = ['singleplayer'],
      input = ['human', 'p1'],
      start_spot = 0,
      is_main = true,
    },
    {
      texture = preload('res://textures/vehicles/car_blue.png'),
      viewport = null,
      input = ['npc', ''],
      start_spot = 1,
      is_main = false,
    },
  ],
  'laps': 4,
}

var race_settings = {}

func get_setting(key):
  if race_settings.has(key):
    return race_settings[key]
  return race_default_settings[key]
