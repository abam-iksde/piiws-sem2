extends Control

enum Selection {
  SINGLE,
  MULTI,
}

var single_race = [
  'res://scenes/scenes/race.tscn',
]

var test_tournament = [
  'res://scenes/scenes/race.tscn',
  'res://scenes/scenes/race.tscn',
]

func get_singleplayer_settings(player):
  var settings = {
    'players': RaceSettings.race_default_settings['players'].map(func (p): return p.duplicate()),
    'laps': 3,
  }
  settings['players'][0].input = ['human', player]
  return settings

var two_player_settings = {
  'players': [
    {
      texture = preload('res://textures/vehicles/car_red.png'),
      viewport = ['splitscreen', preload('res://textures/splitscreen/player1.png'), Vector2(0.25, 0.0), Vector2(0.0, 0.0), Vector2(0.5, 1.0)],
      input = ['human', 'p1'],
      start_spot = 0,
      is_main = true,
      id = 'RED',
    },
    {
      texture = preload('res://textures/vehicles/car_blue.png'),
      viewport = ['splitscreen', preload('res://textures/splitscreen/player2.png'), Vector2(-0.25, 0.0), Vector2(0.5, 0.0), Vector2(0.5, 1.0)],
      input = ['human', 'p2'],
      start_spot = 1,
      is_main = false,
      id = 'BLUE',
    },
  ],
  'laps': 3,
}

func _physics_process(delta):
  var selection = Misc.get_value('players_selection', Selection.SINGLE)
  if AnyPlayer.just_pressed('_handbrake'):
    get_tree().change_scene_to_file('res://scenes/scenes/temp_menu.tscn')
  if AnyPlayer.just_pressed('_left'):
    selection = Selection.SINGLE
  elif AnyPlayer.just_pressed('_right'):
    selection = Selection.MULTI
  Misc.set_value('players_selection', selection)
  var accepted = AnyPlayer.just_pressed('_power_up')
  match selection:
    Selection.SINGLE:
      $ui/single_selection.visible = true
      $ui/multi_selection.visible = false
      if accepted:
        Tournament.start(single_race if Misc.get_value('game_mode', 'single_race') == 'single_race' else test_tournament, get_singleplayer_settings(accepted))
    Selection.MULTI:
      $ui/single_selection.visible = false
      $ui/multi_selection.visible = true
      if accepted:
        Tournament.start(single_race if Misc.get_value('game_mode', 'single_race') == 'single_race' else test_tournament, two_player_settings)
