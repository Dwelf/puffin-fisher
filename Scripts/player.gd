extends CharacterBody2D

@export var move_speed : float = 75
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var animated_sprite = $AnimatedSprite2D
@onready var cast_timer = $Timer
@onready var power_bar = $Power
@onready var fishingLine = $AnimatedSprite2D/FishingPole/FishingLine
@onready var castingPole = $AnimatedSprite2D/CastingPole
@onready var fishingPole = $AnimatedSprite2D/FishingPole
@onready var light = $PointLight2D
@onready var fish_particle = $FishParticle

var casting = false
var released = false
var waiting = false
var input_direction
var bobberInstance
var bobber_dir

var captured_fish = []
var fishes = ["res://Assets/fish1.png","res://Assets/fish2.png","res://Assets/fish3.png"]

func _ready():
	animated_sprite.play("Idle")

func _physics_process(_delta):
	light.color.a = max(0.0,1-DayNightCycle.value*2)
	

		
	# get user input for movement
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# CASTING LOGIC
	if !released and Input.is_action_just_pressed("cast"):  #start cast power animation if not fishing yet and they pressed cast
		casting = true
		power_bar.visible = true
		power_bar.cast()
	elif waiting and Input.is_action_just_pressed("cast"): #stop fishing if cast pressed while waiting for fish to bite
		waiting = false
		released = false
		power_bar.reset_cast()
		remove_child(bobberInstance)
	

	if (casting and Input.is_action_just_released("cast")) or power_bar.finished: #if power bar state ended:
		casting = false
		cast_timer.start()
		var power = power_bar.release_cast()
		
		
		if !power_bar.finished: #if the user set a cast strength that isnt 0 then throw the bobber
			released = true
			var scene = load("res://Scenes/bobber.tscn")
			bobberInstance = scene.instantiate()
			if animated_sprite.scale.x == -1:
				bobberInstance.position = Vector2(-20,-20)
			else:
				bobberInstance.position = Vector2(+20,-20)
				
			add_child(bobberInstance)
			bobber_dir = (get_global_mouse_position() - global_position).normalized()
			#get_node("Bobber").throw(power,velocity/move_speed)
			get_node("Bobber").throw(power, bobber_dir)
		else:  #else reset the power bar state
			power_bar.visible = false
			power_bar.reset_cast()
		
	
	if bobberInstance in get_children():  #draw fishing line if the bobber is on screen
		fishingLine.points = PackedVector2Array([ Vector2(bobberInstance.position[0]*animated_sprite.scale.x,bobberInstance.position[1]), Vector2(fishingPole.position[0]+5, fishingPole.position[1]-14)])
	
	
	if !casting and cast_timer.is_stopped():  #if the bobber has frozen in place, check if it is in water or not
		if bobberInstance in get_children():
			if !bobberInstance.in_water:
				released = false
				remove_child(bobberInstance)
			else:
				waiting = true
			power_bar.visible = false
			power_bar.reset_cast()
		
		
	if waiting and bobberInstance.minigame_loaded:
		if bobberInstance.minigame_finished:
			if bobberInstance.instance.caught:
				captured_fish.append(bobberInstance.instance.fishChoice)
			remove_child(bobberInstance)
			waiting = false
			released = false
			fish_particle.texture = load(fishes[captured_fish[len(captured_fish)-1]])
			fish_particle.emitting = true
			print(captured_fish)
	
			
			
		
	update_animation_parameters(input_direction)
	
	if input_direction != Vector2.ZERO:
		velocity = input_direction.normalized() * move_speed
	
	if !casting and !released:  #cannot move while fishing or casting
		if input_direction != Vector2.ZERO:
			move_and_slide()
	
	pick_new_state()
	


func update_animation_parameters(move_input : Vector2):
	# cannot change direction while fishing or casting
	if !casting and !released:
		
		#flips sprite left or right based on input direction
		if(move_input[0] < 0):
			animated_sprite.scale.x = -1
		elif(move_input[0] > 0):
			animated_sprite.scale.x = 1
			

# picks the animation state based on certain circumstances
func pick_new_state():
	castingPole.visible = false
	fishingPole.visible = false
	if !released and !casting:
		if(input_direction != Vector2.ZERO):
			animated_sprite.play("Run")

		else:
			animated_sprite.play("Idle")
	elif casting:
		animated_sprite.play("Casting")
		castingPole.visible = true
	elif released:
		animated_sprite.play("Fishing")
		fishingPole.visible = true
	

