class_name MapLoader
extends Object

const TILE_WIDTH = 32
const TILE_HEIGHT = 32

func load_map(map_path, texture_path):
  var data = get_json(map_path)
  var texture = load(texture_path)
  var layers = {
    visual = []
  }
  for layer in data['layers']:
    if layer['type'] == 'tilelayer':
      layers.visual.append(layer)
    elif layer['name'] == 'start_spots':
      layers.start_spots = layer
    elif layer['name'] == 'walls':
      layers.walls = layer
    elif layer['name'] == 'checkpoints':
      layers.checkpoints = layer
  return [transform_layers(layers, texture), texture]

func get_json(path):
  var file = FileAccess.open(path, FileAccess.READ)
  var content = file.get_as_text()
  return JSON.parse_string(content)

func transform_layers(layers, texture):
  var transformed_layers = {
    visual = [],
    directions = [],
  }
  
  var texture_size = texture.get_size()
  
  var last_tile = (texture_size.x/TILE_WIDTH)*(texture_size.y/TILE_HEIGHT) - 1
  
  for layer in layers.visual:
    var transformed_layer = { data = [], z = 0.0 }
    for x in range(layer['width']):
      for y in range(layer['height']):
        var tile_index = layer['data'][y * layer['width'] + x] - 1
        if tile_index < 0: continue
        if tile_index > last_tile:
          transformed_layers.directions.append({
            position = Vector2(x * 2.0, y * 2.0),
            direction = Angles.get_angle_from_index(tile_index-last_tile-1),
          })
          continue
        var tile_x = tile_index * TILE_WIDTH
        var tile_y = 0
        while (tile_x >= texture_size.x):
          tile_x -= texture_size.x
          tile_y += TILE_HEIGHT
        transformed_layer.data.append({
          position = Vector2(x * 2.0, y * 2.0),
          tile_uv = Vector2(tile_x, tile_y)
        })
    if layer.has('properties'):
      for param in layer['properties']:
        if param['name'] == 'z':
          transformed_layer.z = param['value']
    transformed_layers.visual.append(transformed_layer)
  
  var start_spots = []
  for i in range(len(layers.start_spots['objects'])):
    for point in layers.start_spots['objects']:
      if point['name'] == str(i+1):
        start_spots.append(Vector2(point['x']/16.0 - 1.0, point['y']/16.0 - 1.0))
  transformed_layers.start_spots = start_spots
  
  var walls = []
  for wall in layers.walls['objects']:
    var transformed_wall = []
    for point in wall['polygon']:
      transformed_wall.append(Vector2((wall['x'] + point['x'])/16.0 - 1.0, (wall['y'] + point['y'])/16.0 - 1.0))
    walls.append(transformed_wall)
  transformed_layers.walls = walls
  
  var checkpoints = []
  for i in range(len(layers.checkpoints)):
    var transformed_checkpoint = {
      shape = []
    }
    for polygon in layers.checkpoints['objects']:
      if polygon['name'] == str(i+1):
        transformed_checkpoint.position = Vector2(polygon['x']/16.0 - 1.0, polygon['y']/16.0 - 1.0)
        for point in polygon['polygon']:
          transformed_checkpoint.shape.append(Vector2(point['x']/16.0, point['y']/16.0))
    if len(transformed_checkpoint.shape) > 0: checkpoints.append(transformed_checkpoint)
  transformed_layers.checkpoints = checkpoints
  
  return transformed_layers
