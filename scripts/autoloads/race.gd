extends Node

var checkpoints
var laps

var players = []
var player_positions = {}

func init(_checkpoints, _laps):
  checkpoints = _checkpoints
  laps = _laps

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
    player_progress.append({
      player = player,
      lap = player.lap,
      checkpoint = checkpoints.find(player.next_checkpoint),
      next_distance = player.global_position.distance_squared_to(player.next_checkpoint.global_position),
    })
  player_progress.sort_custom(wrapped_progress_sort)
  for index in range(len(player_progress)):
    player_positions[player_progress[index].player] = index+1

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
  if player_positions.has(player):
    return player_positions[player]
  return 1
