extends Node

const player_inputs = ['p1', 'p2']

func just_pressed(action):
  for player in player_inputs:
    if Input.is_action_just_pressed(player + action):
      return player
  return false
