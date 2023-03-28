extends TextureProgressBar

func _physics_process(delta):
  if Race.countdown <= 0:
    queue_free()
    return
  var countdown = 5 - Race.countdown
  value = countdown
