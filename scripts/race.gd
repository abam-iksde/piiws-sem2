extends Node

var checkpoints
var laps

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
