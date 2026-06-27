#tower class

extends Node2D

var can_attack:bool = true

@export var damage:int
@export var attack_speed:float
@export var targeting:String = "DEFAULT"
@export var attack_hitbox:Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Target at an enemy in range if possible
	target_enemy()
	
	#Attack the enemy if possible
	
#Function responsible for instantiating bullets or any other attack processes. 
#Should be overwritten by the child class
func attack() -> void:
	pass

#Try to attack the enemy
func attack_enemy() -> void:
	#Check if attack cooldown is done
	if can_attack:
		can_attack = false
		
		attack()
	
		#Start timer to reset attack cooldown
		await get_tree().create_timer(attack_speed).timeout
		
		can_attack = true
	
"""
Rotates the tower towards the enemy
Targeting options:
	Default -> the enemy furthest along the path (in range)
	Close -> the enemy closest to the tower (in range)
	Far -> the enemy farthest to the tower (in range)
"""
func target_enemy() -> void:
	#List of possible enemies to target
	var enemies:Array[Enemy] 
	
	#Enemy to target
	var targeted_enemy:Enemy
	
	#Populate list with all the enemies in range
	for area:Area2D in attack_hitbox.get_overlapping_areas():
		if area.get_parent() is Enemy:
			enemies.append(area)
	
	#Check if there are any enemies
	if enemies:
		match targeting:
			"DEFAULT":
				#Iterate through the enemies, looking for the one with the highest progress in the paths
				var highest_progress:float = 0
				for enemy:Enemy in enemies:
					if enemy.progress_ratio > highest_progress:
						targeted_enemy = enemy
						highest_progress = enemy.progress_ratio
						
				#Rotate towards the enemy
				look_at(targeted_enemy.global_position)
				
			"CLOSE":
				#Iterate through the enemies, looking for the one with the lowest distance to the tower
				var lowest_dist:float = -1
				for enemy:Enemy in enemies:
					if global_position.distance_to(enemy.global_position) < lowest_dist or lowest_dist == -1:
						targeted_enemy = enemy
						lowest_dist = global_position.distance_to(enemy.global_position) 
				
				#Rotate towards the enemy
				look_at(targeted_enemy.global_position)
						
			"FAR":
				#Iterate through the enemies, looking for the one with the farthest distance to the tower
				var highest_dist:float = -1
				for enemy:Enemy in enemies:
					if global_position.distance_to(enemy.global_position) > highest_dist:
						targeted_enemy = enemy
						highest_dist = global_position.distance_to(enemy.global_position)
				
				#Rotate towards the enemy
				look_at(targeted_enemy.global_position)
						
		
	
