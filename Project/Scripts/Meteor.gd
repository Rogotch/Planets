extends RigidBody2D

var type = Global.obj_type.UNIT

export (Array, NodePath) var _trail_particles
export (Array, NodePath) var _explosion_particles
export (NodePath) var _Face
export (NodePath) var _VisibilityNotifier

var trail_particles = []
var explosion_particles = []
onready var Face = get_node(_Face)
onready var VisibilityChecker = get_node(_VisibilityNotifier)

var stopped = false
var planets = []
var life_timer = Timer.new()
var life_count = 1
var rng = RandomNumberGenerator.new()

func _ready():
	add_child(life_timer)
	
	life_timer.connect("timeout", self, "immidiatly_death_check")
	
	for trail in _trail_particles:
		trail_particles.append(get_node(trail))
	
	for explosion in _explosion_particles:
		explosion_particles.append(get_node(explosion))
	
	rng.randomize()
	Face.scale += Vector2.ONE * rng.randf_range(-0.05, 0.05)
#	add_force(Vector2.ZERO, Vector2(-100, 0))
#	myfunc([4, 4, 2, 3, 3, 3])
#	myfunc([1, 2, 3, 1, 1, 1])
#	myfunc([3, 3, 1, 2, 0, 3, 4, 3, 2, 1])
	pass

func immidiatly_death_check():
	var visibility_check = VisibilityChecker.is_on_screen()
	life_count -= 1
	if life_count == 0:
		if visibility_check:
			Death()
		else:
			queue_free()
	else:
		if visibility_check:
			life_timer.start()
		else:
			queue_free()
	pass

func _physics_process(delta):
#	final_velocity += grav_dir * gravitation + get_input()
#		final_velocity *= 0.98
	var grav_dir = GetGravDirection()
	$Node2D.global_rotation = grav_dir.angle()
	if planets.size() != 0 && !stopped:
		add_force(Vector2.ZERO, grav_dir*10)
#		applied_force = lerp(applied_force, grav_dir * 100, 0.1)
		linear_velocity = lerp(linear_velocity, grav_dir*100, 0.01)
##		prints(applied_force, grav_dir)
#		linear_velocity = lerp(linear_velocity, grav_dir, 0.01)
#		print(global_rotation)
#		applied_force = lerp(applied_force, grav_dir, 0.01)
#		applied_force = applied_force.rotated(lerp_angle(applied_force.angle(), grav_dir.angle(), 0.1))
	pass

func _on_Meteor_body_entered(body):
#	prints("Body entered", body, applied_force, applied_torque, inertia, friction, linear_velocity)
	
	Death()
	if body.has_method("asteroid_push"):
		var force_to_body = linear_velocity.direction_to(body.global_position)
		
		body.asteroid_push(linear_velocity.rotated(linear_velocity.angle_to(force_to_body)/2))
#	stopped = true
#	applied_force = Vector2.ZERO
#	linear_velocity = Vector2.ZERO
	
	pass


func Death():
	for trail in trail_particles:
		trail.emitting = false
	
	for explosion in explosion_particles:
		explosion.emitting = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(Face, "modulate:a", 0.0, 0.3)
	tween.tween_callback(self, "queue_free").set_delay(3)
	tween.play()
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


func _on_VisibilityNotifier2D_screen_exited():
	if life_timer != null && life_timer.is_inside_tree():
		life_timer.start(3.0)
	pass # Replace with function body.
