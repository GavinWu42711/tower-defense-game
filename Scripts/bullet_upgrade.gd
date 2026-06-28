#Base class for bullet upgrades

extends Node

class_name BulletUpgrade

@export var damage:int 
@export var lifespan:float
@export var pierce:int = 1
@export var speed:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Merges the stats of two bullet upgrades
static func merge_upgrades(upgrade_1:BulletUpgrade, upgrade_2:BulletUpgrade) -> BulletUpgrade:
	var merge_result:BulletUpgrade = BulletUpgrade.new() 
	merge_result.damage = upgrade_1.damage + upgrade_2.damage
	merge_result.lifespan = upgrade_1.lifespan + upgrade_2.lifespan
	merge_result.pierce = upgrade_1.pierce + upgrade_2.pierce
	merge_result.speed = upgrade_1.speed + upgrade_2.speed
	
	return merge_result
