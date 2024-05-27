extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var animated_sprite = $AnimatedSprite2D
@onready var cast_timer = $Timer

var casting = false
var fishing = false

func _ready():
	animated_sprite.play("Idle")
	

func _physics_process(_delta):
	
	# get user input for movement
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	
	# CASTING LOGIC
	var cast = Input.get_action_strength("cast")
	
	if cast > 0 and cast_timer.is_stopped() and !casting and !fishing:
		casting = true
		cast_timer.start()     #when pressing cast, the casting animation plays for 1 second before moving to the fishing animation
	elif cast > 0 and fishing:
		fishing = false
		cast_timer.start()     #when coming out of fishing animation, you cannot cas
	
	if casting and cast_timer.is_stopped():
		casting = false
		fishing = true
		
	
	update_animation_parameters(input_direction)
	
	
	velocity = input_direction.normalized() * move_speed
	
	if !casting and !fishing:  #cannot move while fishing or casting
		move_and_slide()
	
	pick_new_state()
	


func update_animation_parameters(move_input : Vector2):
	# cannot change direction while fishing or casting
	if !casting and !fishing:
		
		#flips sprite left or right based on input direction
		if(move_input[0] < 0):
			animated_sprite.scale.x = -1
		elif(move_input[0] > 0):
			animated_sprite.scale.x = 1
			

# picks the animation state based on certain circumstances
func pick_new_state():
	if !fishing and !casting:
		if(velocity != Vector2.ZERO):
			animated_sprite.play("Run")

		else:
			animated_sprite.play("Idle")
	elif casting:
		animated_sprite.play("Casting")
	elif fishing:
		animated_sprite.play("Fishing")
	

