extends Control

func _physics_process(delta):
  var selection = Misc.get_value('track_', 0)
  if AnyPlayer.just_pressed('_left'):
    selection = 0
  if AnyPlayer.just_pressed('_right'):
    selection = 1
  if AnyPlayer.just_pressed('_handbrake'):
    get_tree().change_scene_to_file("res://scenes/scenes/players_selection.tscn")
  var accepted = AnyPlayer.just_pressed('_power_up')
  match selection:
    0:
      $ui/track1.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0))
      $ui/track2.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
      if accepted:
        Tournament.start([['res://maps/test_map/map.json', 'res://maps/test_map/set.png']], Misc.get_value('race_settings', {}))
    1:
      $ui/track1.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
      $ui/track2.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0))
      if accepted:
        Tournament.start([['res://maps/track2/track2.json', 'res://maps/track2/tiles_carpet.png']], Misc.get_value('race_settings', {}))
  Misc.set_value('track_', selection)
