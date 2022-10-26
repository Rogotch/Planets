extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (NodePath) var _GravitationShape
export (NodePath) var _PlanetShape

onready var GravitationShape = get_node(_GravitationShape)
onready var PlanetShape = get_node(_PlanetShape)

export (int) var radius
export (float, 0.1, 5, 0.1) var gravity_strength
var planet_radius
var planet_particles

var type = Global.obj_type.PLANET
var grav_circle
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_circle = GravitationShape.shape
	grav_circle.radius = radius
	planet_radius = PlanetShape.shape.radius
	
	planet_particles = Planet_particles.new()
	add_child(planet_particles)
	planet_particles.amount = planet_radius
	planet_particles.radius = radius
	planet_particles.inner_radius = planet_radius
	rng.randomize()
	var _sign_id = rng.randi()%2
	var tang_accel = 0.1 * radius * gravity_strength * (-1 if _sign_id == 0 else 1) 
	print(tang_accel)
	planet_particles.radial_accel = -100 * gravity_strength
	planet_particles.tangential_accel = tang_accel
	planet_particles.orbit_velocity   = tang_accel / 200
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Planet_body_entered(body):
	print("Entered!", body.name)
	pass # Replace with function body.
