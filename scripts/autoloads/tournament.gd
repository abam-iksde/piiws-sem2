extends Node

var current_race = 0
var races = []

var scores = {}

func start(races_, settings):
  current_race = 0
  races = races_
  scores = {}
  RaceSettings.race_settings = settings
  for player in RaceSettings.get_setting('players'):
    scores[player.id] = 0
  Misc.set_value('track', races[0][0])
  Misc.set_value('tileset', races[0][1])
  get_tree().change_scene_to_file('res://scenes/scenes/race.tscn')

func summarize_race():
  for player in RaceSettings.get_setting('players'):
    scores[player.id] += max(5 - Race.final_positions[player.id], 0)
  if len(races) > 1:
    get_tree().change_scene_to_file('res://scenes/scenes/race_summary.tscn')
    return
  get_tree().change_scene_to_file('res://scenes/scenes/single_race_summary.tscn')

func advance():
  current_race += 1
  if current_race >= len(races):
    get_tree().change_scene_to_file('res://scenes/scenes/temp_menu.tscn')
    return
  Misc.set_value('track', races[current_race][0])
  Misc.set_value('tileset', races[current_race][1])
  get_tree().change_scene_to_file('res://scenes/scenes/race.tscn')
