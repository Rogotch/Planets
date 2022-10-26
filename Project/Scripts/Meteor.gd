extends RigidBody2D

var type = Global.obj_type.UNIT

var stopped = false
var planets = []

func _ready():
#	add_force(Vector2.ZERO, Vector2(-100, 0))
#	myfunc([4, 4, 2, 3, 3, 3])
#	myfunc([1, 2, 3, 1, 1, 1])
#	myfunc([3, 3, 1, 2, 0, 3, 4, 3, 2, 1])
	pass

func _physics_process(delta):
#	final_velocity += grav_dir * gravitation + get_input()
#		final_velocity *= 0.98
	var grav_dir = GetGravDirection()
	$Node2D.global_rotation = grav_dir.angle()
	if planets.size() != 0 && !stopped:
		add_force(Vector2.ZERO, grav_dir*10)
		applied_force = lerp(applied_force, grav_dir * 100, 0.1)
#		linear_velocity = lerp(linear_velocity, grav_dir*10, 0.01)
##		prints(applied_force, grav_dir)
#		linear_velocity = lerp(linear_velocity, grav_dir, 0.01)
#		print(global_rotation)
#		applied_force = lerp(applied_force, grav_dir, 0.01)
#		applied_force = applied_force.rotated(lerp_angle(applied_force.angle(), grav_dir.angle(), 0.1))
	pass

func _on_Meteor_body_entered(body):
#	prints("Body entered", body, applied_force, applied_torque, inertia, friction, linear_velocity)
	if body.has_method("asteroid_push"):
		body.asteroid_push(linear_velocity)
#	stopped = true
#	applied_force = Vector2.ZERO
#	linear_velocity = Vector2.ZERO
	
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
