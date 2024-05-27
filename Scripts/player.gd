extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)


@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("Idle")
	

func _physics_process(_delta):
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	
	velocity = input_direction.normalized() * move_speed
	
	move_and_slide()
	
	pick_new_state()
	


func update_animation_parameters(move_input : Vector2):
	if(move_input[0] < 0):
		animated_sprite.scale.x = -1
	elif(move_input[0] > 0):
		animated_sprite.scale.x = 1
		

func pick_new_state():
	if(velocity != Vector2.ZERO):
		animated_sprite.play("Run")

	else:
		animated_sprite.play("Idle")

