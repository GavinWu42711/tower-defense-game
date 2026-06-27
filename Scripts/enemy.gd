#Enemy class

extends Node

class_name Enemy

@export var health:int
@export var damage:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#What happens when the enemy dies (typically only needs to dequeue itself)
func die() -> void:
	self.queue_free()
	
