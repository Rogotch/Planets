tool
extends Particles2D
class_name Planet_particles

var particles_material

var radius             setget set_radius
var inner_radius       setget set_inner_radius
var tangential_accel   setget set_tangential_accel
var orbit_velocity     setget set_orbit_velocity
var radial_accel       setget set_radial_accel
var color              setget set_color

func _init():
#	amount = 100
	particles_material = ParticlesMaterial.new()
	particles_material.flag_disable_z = true
	particles_material.emission_shape = ParticlesMaterial.EMISSION_SHAPE_RING
	particles_material.emission_ring_radius = 300
	particles_material.emission_ring_inner_radius = 130
	particles_material.gravity = Vector3.ZERO
#	particles_material.orbit_velocity = -0.2
#	particles_material.color_ramp = 
	particles_material.color_ramp = preload("res://Project/Images/PlanetParticlesGradient.res")
	process_material = particles_material
	self.tangential_accel = 0
	self.radial_accel = -100
	self.color = Color.yellow
	pass
#func set_(value):

func set_radius(value):
	particles_material.emission_ring_radius = value
	radius = value
	pass

func set_inner_radius(value):
	particles_material.emission_ring_inner_radius = value
	inner_radius = value
	pass

func set_tangential_accel(value):
	tangential_accel = value
	particles_material.tangential_accel = value
	pass

func set_orbit_velocity(value):
	orbit_velocity = value
	particles_material.orbit_velocity = value
	pass

func set_radial_accel(value):
	radial_accel = value
	particles_material.radial_accel = value
	pass

func set_color(value):
	color = value
	particles_material.color = value
	pass
