extends Node3D

#All weapons in the game
var all_weapons = {}

#Weapons carried
var weapons = {}

#HUD
var hud

var current_weapon
var current_weapon_slot = "Empty"

var changing_weapon = false
var unequipped_weapon = false

# For switching weapons through mouse wheel
var weapon_index = 0 

func _ready():
	
	hud = owner.get_node("Hud")
	#get_parent_node_3d().get_node("Head/RayCast3d").add_exception(owner)
	
	all_weapons = {
		"Unarmed" : preload("res://Weapons/Unarmed/Unarmed.tscn"),
		"AR" : preload("res://Weapons/Armed/Assualt Rifle/AR.tscn")
	}
	
	weapons = {
		"Empty" : $Unarmed,
		"Primary" : $AR
	}
	# Initialize references for each weapons
	for w in weapons:
		if weapons[w] != null:
			weapons[w].weapon_manager = self
			weapons[w].player = owner
			#weapons[w].ray = get_parent_node_3d().get_node("Head/RayCast3d")
			weapons[w].visible = false
	
	# Set current weapon to unarmed
	current_weapon = weapons["Empty"]
	change_weapon("Empty")
	
	# Disable process
	set_process(false)



# Process will be called when changing weapons
func _process(delta):
	
	if unequipped_weapon == false:
		if current_weapon.is_unequip_finished() == false:
			return
		
		unequipped_weapon = true
		
		current_weapon = weapons[current_weapon_slot]
		current_weapon.equip()
	
	if current_weapon.is_equip_finished() == false:
		return
	
	changing_weapon = false
	set_process(false)



func change_weapon(new_weapon_slot):
	
	if new_weapon_slot == current_weapon_slot:
		current_weapon.update_ammo() # Refresh
		return
	
	if weapons[new_weapon_slot] == null:
		return
	
	current_weapon_slot = new_weapon_slot
	changing_weapon = true
	
	weapons[current_weapon_slot].update_ammo() # Updates the weapon data on UI, as soon as we change a weapon
	update_weapon_index()
	
	# Change Weapons
	if current_weapon != null:
		unequipped_weapon = false
		current_weapon.unequip()
	
	set_process(true)




# Scroll weapon change
func update_weapon_index():
	match current_weapon_slot:
		"Empty":
			weapon_index = 0
		"Primary":
			weapon_index = 1


func next_weapon():
	weapon_index += 1
	
	if weapon_index >= weapons.size():
		weapon_index = 0
	
	change_weapon(weapons.keys()[weapon_index])

func previous_weapon():
	weapon_index -= 1
	
	if weapon_index < 0:
		weapon_index = weapons.size() - 1
	
	change_weapon(weapons.keys()[weapon_index])

func fire():
	print("Firing")
	if not changing_weapon:
		current_weapon.fire()
		
func fire_stop():
	current_weapon.fire_stop()

func reload():
	if not changing_weapon:
		current_weapon.gun_reload()


# Update HUD
func update_hud(weapon_data):
	var weapon_slot = "1"
	
	match current_weapon_slot:
		"Empty":
			weapon_slot = "1"
		"Primary":
			weapon_slot = "2"

	
	hud.update_weapon_ui(weapon_data, weapon_slot)



