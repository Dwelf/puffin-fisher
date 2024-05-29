extends RigidBody2D

@onready var timer = $Timer
@onready var waterCheck = $WaterCheck

var force
var in_water = false


# Throw the bobber based on input direction
func throw(power, direction):
	gravity_scale = 0.2
	force = Vector2(direction[0]*power/1.5, direction[1]*power - 80)
	
	if direction[0] == 0 and direction[1] != 0:
		if direction[1] > 0:
			gravity_scale = 0.02
		else:
			gravity_scale = 0.1
		force = Vector2(0, direction[1]*power)
	timer.start()
	apply_central_impulse(force)
	
# After 1 second freeze the bobber in place imitating it hitting water
func _process(_delta):
	if timer.is_stopped():
		freeze = FREEZE_MODE_KINEMATIC


# If area collides with water tile, bobber in water variable is set to true
func _on_water_check_area_entered(area):
	if area.name == "Water" or area.name == "StillWater":
		in_water = true

# if area exits water tile, bobber in water variable is set to false
func _on_water_check_area_exited(area):
	if area.name == "Water" or area.name == "StillWater":
		in_water = false
