extends Camera2D

export (bool) var follow_to_player = true
#var tween

func _physics_process(delta):
	if (follow_to_player && Global.player != null):
#	&&  global_position.distance_to(Global.player.global_position) > 50):
		global_position = lerp(global_position, Global.player.global_position, global_position.distance_to(Global.player.global_position)/500)
#		move_to_player()
		pass
	pass

#func move_to_player():
#	tween = create_tween()
#	tween.tween_property(self, "global_position", Global.player.global_position, 0.3)
##	tween_active = true
#	tween.connect("finished", self, "tween_end")
#	tween.play()
#	pass
#
#func tween_end():
#	tween_active = false
#	pass
