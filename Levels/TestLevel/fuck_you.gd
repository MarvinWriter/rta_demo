extends InteractionZone


func interaction():
	in_interaction = true
	
	label.text = "Пошёл нахуй"
	print("Пошёл нахуй")
	
	in_interaction = false
