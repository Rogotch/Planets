extends KinematicBody2D

export (float, 0.1, 5, 0.1) var jump_force
export (float, 0.1, 5, 0.1) var ground_force

var gravitation = 9.8

var grav_velocity = Vector2(0, 1)
var grav_direction = Vector2.ZERO

var final_velocity = Vector2(0, 0)

var planets = []

var on_ground = false
var type = Global.obj_type.UNIT

func _ready():
	pass

func _physics_process(delta):
#	grav_velocity = position.direction_to(Vector2(200, 200))
#	final_velocity *= 0.7
#	print(final_velocity)
	on_ground = false
	var collision = move_and_collide(final_velocity * delta)
	var grav_dir = GetGravDirection()
	if collision:
		if collision.collider_shape.get_parent().type == Global.obj_type.PLANET:
			on_ground = true
		final_velocity = grav_dir + get_input().rotated(grav_dir.angle() - 90 * PI/180) * 10
		rotation = grav_dir.angle()
#		print(grav_dir.angle())
	else:
		final_velocity += grav_dir * gravitation + get_input()
		final_velocity *= 0.98
		rotation = lerp_angle(rotation, final_velocity.angle(), 0.04)
	pass


func get_input() -> Vector2:
	var velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if on_ground:
		if Input.is_action_pressed("jump"):
			velocity.x = 0
			velocity.y = -jump_force * 10
		else:
			velocity.y = 0.03
			velocity.x *= ground_force
		velocity.rotated(grav_direction.angle())
	else:
		if Input.is_action_pressed("jump"):
			velocity *= 10
	return velocity
	pass

func _on_GravArea_area_entered(area):
	if area.Type == Global.AreaType.GRAV:
		planets.append(area.Owner)
	pass # Replace with function body.


func _on_GravArea_area_exited(area):
	if planets.has(area.Owner):
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
