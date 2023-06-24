extends Node

var checkpoints
var laps

var players = []
var player_positions = {}
var final_positions = {}
var n_players_finished
var race_started
var countdown
var initialized = false
var points_disbursed

func init(_checkpoints):
  checkpoints = _checkpoints
  laps = RaceSettings.get_setting('laps')
  spawn_players()
  final_positions = {}
  n_players_finished = 0
  race_started = false
  countdown = 5
  initialized = true
  points_disbursed = false
  start_race()

func spawn_players():
  for player in RaceSettings.get_setting('players'):
    var player_node = preload('res://scenes/prefabs/game/vehicle.tscn').instantiate()
    player_node.texture = player.texture
    var scene_root = get_node('/root/track')
    player_node.control_type = player.input[0]
    player_node.control_metadata = player.input[1]
    scene_root.get_node('world').add_child(player_node)
    player_node.global_position = scene_root.get_node('world/start_spots').get_child(player.start_spot).global_position
    player_node.id = player.id
    if player.viewport != null:
      var viewport
      if player.viewport[0] == 'singleplayer':
        viewport = preload('res://scenes/prefabs/visuals/world_viewport_container_singleplayer.tscn').instantiate()
        viewport.get_node('viewport/camera').parent = player_node
      elif player.viewport[0] == 'splitscreen':
        viewport = preload('res://scenes/prefabs/visuals/world_viewport_container_splitscreen.tscn').instantiate()
        viewport.texture = player.viewport[1]
        viewport.camera_parent = player_node
        viewport.camera_screen_offset = player.viewport[2]
      scene_root.get_node('player_viewports').add_child(viewport)
      spawn_ui(player.viewport[3], player.viewport[4], player_node)

func spawn_ui(position, size, player):
  var ui = get_node('/root/track/ui')
  var player_ui = preload('res://scenes/prefabs/ui/player_ui.tscn').instantiate()
  player_ui.player = player
  ui.add_child(player_ui)
  player_ui.set_bounds(position, size)

func next_checkpoint(checkpoint, lap, change=1):
  var current_index = 0
  if not lap: lap = 0
  if checkpoint != null:
    current_index = checkpoints.find(checkpoint)
  var next_index = wrapi(current_index+change, 0, len(checkpoints))
  if current_index == 0 and change > 0:
    lap += 1
  elif current_index == len(checkpoints)-1 and change < 0:
    lap -= 1
  return {
    lap = lap,
    checkpoint = checkpoints[next_index],
  }

func _physics_process(delta):
  if Input.is_action_just_pressed('ui_accept') and is_race_finished() and not points_disbursed:
    end_race()
    Tournament.summarize_race()
    points_disbursed = true
  var player_progress = []
  for player in players:
    if not final_positions.has(player.id) and player.lap > laps:
      n_players_finished += 1
      final_positions[player.id] = n_players_finished
      player.finish_race()
    if not player.race_done:
      player_progress.append({
        player = player,
        lap = player.lap,
        checkpoint = checkpoints.find(player.next_checkpoint),
        next_distance = player.global_position.distance_squared_to(player.next_checkpoint.global_position),
      })
  player_progress.sort_custom(wrapped_progress_sort)
  for index in range(len(player_progress)):
    player_positions[player_progress[index].player.id] = index + 1 + n_players_finished

func progress_sort(a, b):
  var laps_difference = b.lap - a.lap
  if laps_difference != 0:
    return laps_difference
  var checkpoint_difference = b.checkpoint - a.checkpoint
  if checkpoint_difference != 0:
    if a.checkpoint == 0:
      return -1
    elif b.checkpoint == 0:
      return 1
    return checkpoint_difference
  return a.next_distance - b.next_distance

func wrapped_progress_sort(a, b):
  return progress_sort(a, b) < 0

func get_player_position(player):
  if final_positions.has(player.id):
    return final_positions[player.id]
  if player_positions.has(player.id):
    return player_positions[player.id]
  return 1

func start_race():
  await get_tree().create_timer(2).timeout
  Sounds.get_node('countdown').play()
  countdown = 4
  await get_tree().create_timer(1).timeout
  countdown = 3
  await get_tree().create_timer(1).timeout
  countdown = 2
  await get_tree().create_timer(1).timeout
  race_started = true
  countdown = 1
  await get_tree().create_timer(1).timeout
  countdown = 0

func end_race():
  for player in players:
    if not final_positions.has(player.id):
      final_positions[player.id] = player_positions[player.id]
  players = []

func is_race_finished():
  if len(players) == 0:
    return false
  for player in players:
    if player.is_human:
      if not final_positions.has(player.id):
        return false
  return true
