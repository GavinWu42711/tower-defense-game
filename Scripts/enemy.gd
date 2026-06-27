#Enemy class

extends PathFollow2D

class_name Enemy

#Usually enemies can be assumed to be spawning at the start of the track
var start_pos:float = 0
@export var end_offset:float = 0
@export var health:int
@export var damage:int
@export var speed:float
@export var hitbox:Area2D
var is_alive:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Initialize the enemy
	progress = start_pos
	loop = false
	cubic_interp = false
	rotates = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Enemy dies when health falls below 0
	if health <= 0 and !is_alive:
		is_alive = false
		die()
	#Move enemy along the track
	elif is_alive:
		#Check if the enemy is already at the end of the track
		if (is_path_finished(end_offset)):
			#Stop the enemy from moving or doing other checks
			is_alive = false
		
			#Deal damage to the player
			deal_damage()
			
			die()
			
		else:
			move(delta)

#Take damage from a projectile/tower
func take_damage(damage:int) -> void:
	health -= damage
	
	#Prevent potential edge cases
	if (health < 0):
		health = 0

#Deals damage to the player
func deal_damage() -> void:
	Global.lose_hp.emit(damage)

#Check if the enemy is at the end of the track
func is_path_finished(offset: float) -> bool:
	if progress_ratio >= 1 - offset:
		return true
	else:
		return false
	
#Moves the enemy along the path
func move(delta: float) -> void:
	progress += speed * delta
	
#What happens when the enemy dies (typically only needs to dequeue itself)
func die() -> void:
	self.queue_free()
	
