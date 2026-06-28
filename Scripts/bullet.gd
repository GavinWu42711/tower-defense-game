#Base class for bullets

extends Node2D

class_name Bullet

@export var damage:int 
@export var lifespan:float
@export var pierce:int = 1
@export var speed:int
@export var hitbox:Area2D

var upgrades:Array[BulletUpgrade] = []

#Each enemy can only be hit once by each bullet
var enemies_hit:Array[Area2D] = []

#Prevent possible race conditions with when the bullet queue free's
var alive:bool = true
signal start_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_upgrades()
	start_timer.connect(despawn_timer)
	start_timer.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		move(delta)
		enemy_hit()
	else:
		die()

#Applies the upgrades the bullet has to the bullet
func apply_upgrades() -> void:
	for upgrade:BulletUpgrade in upgrades:
		damage += upgrade.damage
		lifespan += upgrade.lifespan
		pierce += upgrade.pierce
		speed += upgrade.speed

#Despawns the bullet
func die() -> void:
	death_effect()
	self.queue_free()
	
#Any special effects that should happen when the bullet will despawn
func death_effect() -> void:
	pass
	
#Timer for when the bullet should despawn
func despawn_timer() -> void:
	await get_tree().create_timer(lifespan).timeout	
	alive = false
	
#Moves the bullet
func move(delta: float) -> void:
	#Translation to happen
	var translation:Vector2 = Vector2.RIGHT
	
	#Scale the translation by the speed of the bullet
	translation.x *= speed
	translation.y *= speed
	
	#Rotate the translation to where the bullet is "looking"
	translation.rotated(rotation)
	
	#Apply the translation
	global_position.slide(translation)
	
#Check if the bullet has hit a new enemy
func enemy_hit() -> void:
	for area:Area2D in hitbox.get_overlapping_areas():
		#Look for hitboxes of enemies
		if area.get_parent() is Enemy:
			#Check if the enemy has been hit before
			if enemies_hit.has(area):
				continue
			else:
				#Check if the bullet has enough pierce
				if pierce > 0:
					enemies_hit.append(area)
					pierce -= 1
					attack_enemy(area)
				else:
					break

#Deals damage to an enemy
func attack_enemy(enemy_hitbox:Area2D) -> void:
	var enemy:Enemy = enemy_hitbox.get_parent()
	enemy.take_damage(damage)
	bullet_effects(enemy)
	
#Any special effects that should happen after the enemy is hit
func bullet_effects(enemy:Enemy) -> void:
	pass
