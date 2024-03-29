extends Node

const race_default_settings = {
  'players': [
    {
      texture = preload('res://textures/vehicles/car_red.png'),
      viewport = ['singleplayer', null, null, Vector2(0.0, 0.0), Vector2(1.0, 1.0)],
      input = ['human', 'p1'],
      start_spot = 0,
      is_main = true,
      id = 'RED',
    },
    {
      texture = preload('res://textures/vehicles/car_blue.png'),
      viewport = null,
      input = ['npc', ''],
      start_spot = 1,
      is_main = false,
      id = 'BLUE',
    },
    {
      texture = preload('res://textures/vehicles/car_green.png'),
      viewport = null,
      input = ['npc', ''],
      start_spot = 2,
      is_main = false,
      id = 'JIM',
    },
    {
      texture = preload('res://textures/vehicles/car_green.png'),
      viewport = null,
      input = ['npc', ''],
      start_spot = 3,
      is_main = false,
      id = 'GREG',
    },
  ],
  'laps': 1,
}

var race_settings = {}

func get_setting(key):
  if race_settings.has(key):
    return race_settings[key]
  return race_default_settings[key]

var player_id = 0
func generate_player_id():
  player_id += 1
  return player_id
