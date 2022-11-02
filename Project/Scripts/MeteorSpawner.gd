tool
extends Node2D

class_name AsteroidSpawner

export (bool) var spawn_flag = false
export (float, 1.0, 500, 0.1) var Radius = 1.0 setget set_radius
export (float, -360.0, 360.0, 0.1) var Direction = 0.0 setget set_direction
export (Global.SpawnerShape) var _Shape setget set_shape
export (int, 0, 200, 1) var speed_modify_min = 1
export (int, 0, 200, 1) var speed_modify_max = 100
export (float, 0.0, 100.0, 0.1) var life_time = 10.0
export (int) var spawn_count = 10
export (float, 0.0, 10.0, 0.1) var spawn_yield_time = 1.0
export (bool) var group_spawn = false
export (float, 0.0, 20.0, 0.1) var group_spawn_yield_time = 1.0
export (int, 1, 100, 1) var group_size = 1

onready var asteroid_class = preload("res://Project/Entities/Meteor.tscn")
onready var rng = RandomNumberGenerator.new()
onready var spawn_timer = Timer.new()

#export (Color) var Shape_Color setget set_color
var line_color = Color(1, 0.5, 0.5, 1)
var shape_color = Color(0.3, 0.5, 1, 0.5)
var spawned_counter = 0

func _ready():
	add_child(spawn_timer)
	spawn_timer.one_shot = true
	spawn_timer.autostart = false
	spawn_timer.connect("timeout", self, "spawn")
	if !Engine.editor_hint && spawn_flag:
		spawn()
#	yield(get_tree().create_timer(1), "timeout")
#	for i in spawn_count:
#		yield(get_tree().create_timer(0.3), "timeout")
#		spawn_asteroid()
	pass

func _draw():
	if Engine.editor_hint:
		match _Shape:
			Global.SpawnerShape.Circle:
				draw_circle(Vector2.ZERO, Radius, shape_color)
				pass
			Global.SpawnerShape.Rect:
				var side = sqrt(pow((Radius * 2), 2))
				draw_rect(Rect2(Vector2(-Radius, -Radius), Vector2(side, side)), shape_color)
				pass
		var angle = deg2rad(Direction)
		var direction = Vector2(cos(angle), sin(angle))
		direction *= (Radius)
		draw_line(Vector2.ZERO, direction, line_color, Radius/50, true)
		draw_circle(Vector2.ZERO, Radius/40, line_color)
		draw_circle(direction, Radius/30, line_color)
	pass

func set_radius(value):
	Radius = value
	update()
	pass

func set_shape(value):
	_Shape = value
	update()
	pass

func set_color(value):
#	Shape_Color = value
	update()
	pass

func set_direction(value):
	Direction = value
	update()
	pass

func spawn_asteroid():
	if !spawn_flag:
		return
	var spawn_position = Vector2.ZERO
	
	var new_asteroid = asteroid_class.instance()
	add_child(new_asteroid)
	
	var rand_position = Vector2.ZERO
	var has_position = false
	while !has_position:
		rng.randomize()
		rand_position = Vector2(rng.randi_range(-Radius, Radius), rng.randi_range(-Radius, Radius))
		match _Shape:
			Global.SpawnerShape.Circle:
				has_position = Vector2.ZERO.distance_to(rand_position) <= Radius
#				draw_circle(Vector2.ZERO, Radius, shape_color)
				pass
			Global.SpawnerShape.Rect:
#				var side = sqrt(pow((Radius * 2), 2))
#				has_position = Rect2(Vector2(-Radius, -Radius), Vector2(side, side)).has_point(rand_position)
				has_position = true
				pass
	
	new_asteroid.position = rand_position
	
	var angle = deg2rad(Direction)
	var direction = Vector2(cos(angle), sin(angle))
	
	var speed_modify = rng.randi_range(speed_modify_min, speed_modify_max)
#	prints("speed_modify", speed_modify)
	
	new_asteroid.add_force(Vector2.ZERO, direction*(speed_modify))
	rng.randomize()
	new_asteroid.add_torque(rng.randi_range(-100, 100))
	new_asteroid.life_timer.start(life_time)
	spawned_counter += 1
	pass

func spawn():
	if group_spawn:
		for i in group_size:
			if spawn_count == 0 || spawn_count > spawned_counter:
				spawn_asteroid()
				yield(get_tree().create_timer(spawn_yield_time), "timeout")
			else:
				break
		if spawn_count == 0 || spawn_count > spawned_counter:
			spawn_timer.start(group_spawn_yield_time)
		pass
	else:
		spawn_asteroid()
		if spawn_count == 0 || spawn_count > spawned_counter:
			spawn_timer.start(spawn_yield_time)
	pass
