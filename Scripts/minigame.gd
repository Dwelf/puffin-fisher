extends Control

@onready var reelBar = $ReelBar
@onready var progress = $ProgressBar
@onready var fish = $Fish

var capturing = false
var caught = false
var escaped = false
var time = 0.0

var random = RandomNumberGenerator.new()
var fish_rapidity = 100
var fishes = ["res://Assets/fish1.png","res://Assets/fish2.png","res://Assets/fish3.png"]
var difficulties = [100,200,400]
var fishChoice

# PICK RANDOM FISH
func _ready():
	fishChoice = randi_range(0,2)
	fish.get_node("Sprite2D").texture = load(fishes[fishChoice])
	fish_rapidity = difficulties[fishChoice]

func _process(_delta):
	if Input.is_action_pressed("up"):
		reelBar.apply_central_force(Vector2(0,-300))
	elif reelBar.linear_velocity == Vector2.ZERO and !Input.is_action_pressed("up"):
		reelBar.apply_central_force(Vector2(0,300))
	
	if capturing:
		progress.value += 4
	else:
		progress.value -= 3
	
	if progress.value == progress.max_value:
		caught = true
	elif progress.value == progress.min_value:
		escaped = true


	#FISH MOVEMENT
	time += _delta
	if int(time) % 3: #how often should the fish have a force applied to it
		
		fish.apply_central_force(Vector2(0.0,random.randf_range(-1,1)*fish_rapidity))


func _on_area_2d_body_entered(body):
	capturing = true


func _on_area_2d_body_exited(body):
	capturing = false
