extends Node3D

const Tile = preload('res://scenes/prefabs/visuals/tile.tscn')
const DirectionBoxScene = preload('res://scenes/prefabs/game/direction_box.tscn')

func _ready():
  var loader = MapLoader.new()
  var map_data = loader.load_map(
    Misc.get_value('track', 'res://maps/test_map/map.json'),
    Misc.get_value('tileset', 'res://maps/test_map/set.png')
  )
  build_map(map_data)
  Race.init.call_deferred($checkpoints.get_children())

func build_map(map_data):
  build_visuals(map_data)
  build_start_spots(map_data)
  build_path_map(map_data)
  build_walls(map_data)
  build_checkpoints(map_data)

func build_visuals(map_data):
  for layer in map_data[0].visual:
    var layer_node = Node3D.new()
    for tile in layer.data:
      var tile_node = Tile.instantiate()
      tile_node.position = Vector3(tile.position.x, layer.z, tile.position.y)
      var material = tile_node.get_surface_override_material(0).duplicate()
      material.set_shader_parameter('tileset_texture', map_data[1])
      material.set_shader_parameter('tile_offset', tile.tile_uv)
      material.set_shader_parameter('tile_size', Vector2(32, 32))
      tile_node.set_surface_override_material(0, material)
      layer_node.add_child(tile_node)
    $visuals.add_child(layer_node)

func build_start_spots(map_data):
  for start_spot in map_data[0].start_spots:
    var spot_node = Node3D.new()
    spot_node.position = Vector3(start_spot.x, 0, start_spot.y)
    $start_spots.add_child(spot_node)

func build_path_map(map_data):
  for direction in map_data[0].directions:
    var direction_box = DirectionBoxScene.instantiate()
    direction_box.position = Vector3(direction.position.x, 0, direction.position.y)
    direction_box.direction = direction.direction
    $path_map.add_child(direction_box)

func build_walls(map_data):
  for wall in map_data[0].walls:
    var wall_collision = build_wall_collision_shape(wall)
    $walls.add_child(wall_collision)

func build_checkpoints(map_data):
  for checkpoint in map_data[0].checkpoints:
    var checkpoint_node = Checkpoint.new()
    var point_collision = build_wall_collision_shape(checkpoint.shape)
    checkpoint_node.add_child(point_collision)
    checkpoint_node.position = Vector3(checkpoint.position.x, 0, checkpoint.position.y)
    $checkpoints.add_child(checkpoint_node)

func build_wall_collision_shape(polygon):
  var collision_shape = CollisionShape3D.new()
  var shape = ConvexPolygonShape3D.new()
  var points = []
  for point in polygon:
    points.append(Vector3(point.x, -1.0, point.y))
    points.append(Vector3(point.x, 1.0, point.y))
  shape.points = points
  collision_shape.shape = shape
  return collision_shape
