extends Control

@onready var reelBar = $ReelBar
@onready var progress = $ProgressBar
@onready var fish = $Fish/TextureRect

var capturing = false
var caught = false
var escaped = false

var fishes = ["res://Assets/fish1.png","res://Assets/fish2.png","res://Assets/fish3.png"]

func _ready():
	fish.texture = load("res://Assets/fish1.png")
	

func _process(_delta):
	if Input.is_action_pressed("up"):
		reelBar.apply_central_force(Vector2(0,-1000))
	
	if capturing:
		progress.value += 4
	else:
		progress.value -= 3
	
	if progress.value == progress.max_value:
		caught = true
	elif progress.value == progress.min_value:
		escaped = true
		

func _on_area_2d_body_entered(body):
	capturing = true


func _on_area_2d_body_exited(body):
	capturing = false
