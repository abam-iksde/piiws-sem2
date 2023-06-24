extends Control

const lap_text = '''LAP
  %s/%s'''

const pos_text = '''%s/%s
   POS'''

const verdict_text = [
  'this is crunch code for you',
  'CONGRATULATIONS',
  'GREAT',
  'NICE',
  'UNLUCKY',
  'TOO BAD',
  'OOF',
  'dickhead',
]

const position_number_text = [
  'dicc',
  '1st',
  '2nd',
  '3rd',
  '4th',
  '5th',
  '6th',
  'kurwa'
]

var _size = null
var _pos = null

func set_bounds(pos, size_):
  if pos == null or size_ == null:
    return
  var parent_size = get_node('..').size
  position = pos * parent_size
  size = size_ * parent_size
  _size = size_
  _pos = pos

var player = null

func on_resize():
  set_bounds(_pos, _size)

func _ready():
  get_node('/root').connect('size_changed', on_resize)

func _physics_process(delta):
  if player == null:
    return
  
  $position_label.text = pos_text.format([Race.player_positions[player.id], len(Race.players)], '%s')
  if player.lap > Race.laps:
    $lap_label.text = ''
    $verdict_label.text = verdict_text[Race.final_positions[player.id]] + '\n' + position_number_text[Race.final_positions[player.id]]
    $verdict_label.visible = true
  else:
    $lap_label.text = lap_text.format([player.lap, Race.laps], '%s')
