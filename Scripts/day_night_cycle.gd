extends CanvasModulate


var time = 0.0
var value = 0.0
var gradient = load("res://Assets/daynightcycle-gradient-texture.tres")

func _process(delta):
	time += delta/20
	value = (sin(time - PI/2) + 1.0) /2.0
	
	color = gradient.gradient.sample(value)
