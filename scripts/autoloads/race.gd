extends Node

var checkpoints
var laps

var players = []
var player_positions = {}
var final_positions = {}
var n_players_finished
var race_started
var countdown = 5

func init(_checkpoints, _laps):
  checkpoints = _checkpoints
  laps = _laps
  final_positions = {}
  n_players_finished = 0
  race_started = false
  start_race()

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
  var player_progress = []
  for player in players:
    if not final_positions.has(player) and player.lap > laps:
      n_players_finished += 1
      final_positions[player] = n_players_finished
      player.finish_race()
    player_progress.append({
      player = player,
      lap = player.lap,
      checkpoint = checkpoints.find(player.next_checkpoint),
      next_distance = player.global_position.distance_squared_to(player.next_checkpoint.global_position),
    })
  player_progress.sort_custom(wrapped_progress_sort)
  for index in range(len(player_progress)):
    player_positions[player_progress[index].player] = index + 1 + n_players_finished

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
  if final_positions.has(player):
    return final_positions[player]
  if player_positions.has(player):
    return player_positions[player]
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
