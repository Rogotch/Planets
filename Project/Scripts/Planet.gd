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

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_circle = GravitationShape.shape
	grav_circle.radius = radius
	planet_radius = PlanetShape.shape.radius
	planet_particles = Planet_particles.new()
	add_child(planet_particles)
	planet_particles.amount = planet_radius/2
	planet_particles.radius = radius
	planet_particles.inner_radius = planet_radius
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Planet_body_entered(body):
	print("Entered!", body.name)
	pass # Replace with function body.
