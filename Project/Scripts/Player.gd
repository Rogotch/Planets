extends KinematicBody2D

export (NodePath) var _Mark
export (float, 0.1, 5, 0.1) var jump_force
export (float, 0.1, 5, 0.1) var ground_force

onready var Mark = get_node(_Mark)
var gravitation = 9.8

var grav_velocity = Vector2(0, 1)
var grav_direction = Vector2.ZERO

var final_velocity = Vector2(0, 0)

var planets = []

var on_ground = false
var type = Global.obj_type.UNIT
var landed_planet = null

func _ready():
	pass

func _physics_process(delta):
	add_to_group("player")
	Global.player = self
#	grav_velocity = position.direction_to(Vector2(200, 200))
#	final_velocity *= 0.7
#	print(final_velocity)
#	on_ground = false
	var collision = null
	if !on_ground:
		collision = move_and_collide(final_velocity * delta)
#	var collision = false
#	move_and_slide(final_velocity, Vector2.UP)
	var grav_dir = GetGravDirection()
#	for i in get_slide_count():
#		print("", get_slide_collision(i))
	if collision:
		if collision.collider_shape.get_parent().type == Global.obj_type.PLANET:
			on_ground = true
			landed_planet = collision.collider_shape.get_parent()
		final_velocity = grav_dir + get_input().rotated(grav_dir.angle() - 90 * PI/180) * 10
		
#		else:
#			print("Collision with meteor")
#			final_velocity = grav_dir * gravitation + get_input() + (position - collision.collider_shape.get_parent().global_position)
#		print(grav_dir.angle())
	else:
		final_velocity += grav_dir * gravitation + get_input()
#		final_velocity *= 0.98
		if on_ground:
			rotation = grav_dir.angle() - 180 * PI/180
		else:
			rotation = lerp_angle(rotation, final_velocity.angle(), 0.04)
	$Node2D.global_rotation = grav_dir.angle()
	$Node2D2.global_rotation = lerp($Node2D2.global_rotation, 0, 0.2)
	pass





func get_input() -> Vector2:
	var velocity = Vector2()
	if on_ground:
		
		var angle = landed_planet.global_position.angle_to_point(global_position)
		if Input.is_action_pressed("right"):
			angle += 0.05
		if Input.is_action_pressed("left"):
			angle -= 0.05
#		var direction = Vector2.ONE
		var direction = -Vector2(cos(angle), sin(angle))
		direction *= (landed_planet.radius)/2.7
		direction +=  landed_planet.global_position
#		prints("direction", direction, "global_position", global_position)
		Mark.global_position = direction
		
#		velocity.x = 0
		global_position = direction
#		Mark.global_position = landed_planet.global_position
		if Input.is_action_pressed("jump"):
			on_ground = false
			velocity.y = -jump_force * 10
#		else:
#			velocity.y = 0.03
#			velocity.x *= ground_force
		velocity.rotated(grav_direction.angle())
	else:
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("jump"):
			velocity *= 10
	return velocity
	pass

func asteroid_push(force):
	if !on_ground:
		final_velocity -= force
	pass

func _on_GravArea_area_entered(area):
	if area.get("Type") != null && area.Type == Global.AreaType.GRAV:
		planets.append(area.Owner)
	pass # Replace with function body.


func _on_GravArea_area_exited(area):
	if area.get("Type") != null && planets.has(area.Owner):
		planets.erase(area.Owner)
	pass # Replace with function body.

func GetGravDirection():
	var final_directoion = Vector2.ZERO
	for planet in planets:
		var direction_to_planet = global_position.direction_to(planet.global_position)
		var distance = global_position.distance_to(planet.global_position)
		var percents = 0 if planet.radius < distance else 1.0 - distance / planet.radius
#		var percents = 0 if planet.radius < distance else 1.0 - distance / planet.radius + planet.planet_radius / planet.radius
		direction_to_planet *= percents
#		prints("percents", percents)
		final_directoion += direction_to_planet * planet.gravity_strength
		
	return final_directoion
	pass


func _on_Player_input_event(viewport, event, shape_idx):
	print("event&")
	pass # Replace with function body.
