extends Area2D

export (NodePath) var _Owner
export (Global.AreaType) var Type

onready var Owner = get_node(_Owner)

func _ready():
	pass
