extends Node3D
class_name Weapon
#References
var weapon_manager = null
var player = null
var ray = null

#Weapon States
var is_equipped = false

#Weapon Param
@export var weapon_name = "Weapon"
@export var weapon_image = null



#Eq/UnEq Cycle
func equip():
	pass

func unequip():
	pass

func is_equip_finished():
	return true

func is_unequip_finished():
	return true
	
func reload():
	return false

# Update Ammo
func update_ammo(action = "Refresh"):
	
	var weapon_data = {
		"Name" : weapon_name
	}
	
	weapon_manager.update_hud(weapon_data)

