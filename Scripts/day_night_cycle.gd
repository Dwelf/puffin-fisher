extends CanvasModulate

@export var gradient: GradientTexture1D

var time = 0.0

func _process(delta):
	time += delta/20
	var value = (sin(time ) + 1.0) /2.0
	color = gradient.gradient.sample(value)
