extends RigidBody2D

@onready var timer = $Timer
@onready var waterCheck = $WaterCheck

var force
var in_water = false
var fish_caught = false
var minigame_loaded = false
var minigame_finished = false
var minigame_scene

var goal_number = randi_range(0, 1500)
var guessed_number
var instance


# Throw the bobber based on input direction
func throw(power, direction):
	gravity_scale = 0.2
	
	force = Vector2(direction[0]*power/1.5, direction[1]*power - 80)
	
	if direction[0] == 0 and direction[1] != 0:
		if direction[1] > 0:
			gravity_scale = 0.02
		else:
			gravity_scale = 0.1
		force = Vector2(direction[0], direction[1]*power)
	timer.start()
	apply_central_impulse(force)
	
# After 1 second freeze the bobber in place imitating it hitting water
func _process(_delta):
	if timer.is_stopped():
		if !fish_caught:
			catching_fish()
		elif minigame_loaded == false:
			minigame_scene = load("res://Scenes/minigame.tscn")
			minigame_loaded = true
			instance = minigame_scene.instantiate()
			add_child(instance)
			print('minigame loaded')
		freeze = FREEZE_MODE_KINEMATIC
	
	if minigame_loaded:
		if instance.caught or instance.escaped:
			minigame_finished = true
	
	

		
			
		
		

# If area collides with water tile, bobber in water variable is set to true
func _on_water_check_area_entered(area):
	if area.name == "Water" or area.name == "StillWater" or area.name == "Test Water":
		in_water = true

# if area exits water tile, bobber in water variable is set to false
func _on_water_check_area_exited(area):
	if area.name == "Water" or area.name == "StillWater" or area.name == "Test Water":
		in_water = false

func catching_fish():
	guessed_number = randi_range(0, 1500)
	
	if guessed_number == goal_number or true:
		print('fish on line')
		fish_caught = true
