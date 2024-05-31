extends ProgressBar

var start = false
var increment = 2
var finished = false

func cast():
	start = true
	increment = 2
	
func release_cast():
	start = false
	return value

func reset_cast():
	finished = false
	value = 0
	
func _process(_delta):
	if start:
		value += increment
		if value == max_value:
			increment *= -1
			
		if value == 0:
			finished = true
			start = false
		
