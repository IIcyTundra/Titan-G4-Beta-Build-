extends Weapon
class_name Armed 


#References
var animation_player 

#Weapon States
var is_firing = false
var is_reloading = false

#Weapon Parameters
@export var ammo_in_mag = 40
@export var extra_ammo = 240
@onready var mag_size = ammo_in_mag

@export var damage = 30
@export var fire_rate = 1.0

#Equip/Unequip Speed
@export var equip_speed = 1.5
@export var unequip_speed = 1.5
@export var reload_speed = 1.5



# Fire Cycle
func gun_fire():
	print("Is Firing")
	if not is_reloading:
		if ammo_in_mag > 0:
			if not is_firing:
				is_firing = true
				animation_player.get_animation("Fire").loop = true
				animation_player.play("Fire", -1.0, fire_rate)
			
			return
		
		elif is_firing:
			fire_stop()

func fire_stop():
	#animation_player.get_animation("Fire").loop = false
	is_firing = false
	


func fire_bullet(): # Will be called from the animation track
	update_ammo("consume")


func gun_reload():
	if ammo_in_mag < mag_size and extra_ammo > 0:
		is_firing = false
		
		animation_player.play("Reload", -1.0, reload_speed)
		is_reloading = true



#Eq/UnEq Cycle
func equip():
	animation_player.play("Equip", -1.0, equip_speed)
	is_reloading = false 

func unequip():
	animation_player.play("Unequip", -1.0, unequip_speed)

func is_equip_finished():
	if is_equipped:
		return true
	else:
		return false

func is_unequip_finished():
	if is_equipped:
		return false
	else:
		return true



# Show/Hide Weapon
func show_weapon():
	visible = true

func hide_weapon():
	visible = false



# Animation Finished
func on_animation_finish(anim_name):
	match anim_name:
		"Unequip":
			is_equipped = false
		"Equip":
			is_equipped = true
		"Reload" :
			is_reloading = false
			update_ammo("reload")



# Update Ammo
func update_ammo(action = "Refresh", additional_ammo = 0):
	
	match action:
		"consume":
			ammo_in_mag -= 1
		"reload":
			var ammo_needed = mag_size - ammo_in_mag
			
			if extra_ammo > ammo_needed:
				ammo_in_mag = mag_size
				extra_ammo -= ammo_needed
			else:
				ammo_in_mag += extra_ammo
				extra_ammo = 0
		"add":
			extra_ammo += additional_ammo
	
	var weapon_data = {
		"Name" : weapon_name,
		"Ammo" : str(ammo_in_mag),
		"ExtraAmmo" : str(extra_ammo)
	}
	
	weapon_manager.update_hud(weapon_data)
