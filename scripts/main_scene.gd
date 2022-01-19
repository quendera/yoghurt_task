extends Node2D


# Declare member variables here. Examples:
var RQ = 1
var LQ = 1
var LP = 0.8
var list = ["A","A"]

var data = []

var trialStartTime = float(0)
var choiceTime = float(0)
var taskStartTime = float(0)
var choiceMaxTime = float(3500)
var trialMaxTime = float(4000)



var trialTimer
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	taskStartTime = OS.get_unix_time()
	start_trial()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(trialTimer.get_time_left()) 



func start_trial():
	trialStartTime = OS.get_ticks_msec()
	
	print("trial_start: ",trialStartTime)
	$ITI.visible = false
	randomize()
	var random = randf()
	
	if random >= LP:
		$buttonL/option.set_animation("B")
	elif random < LP:
		$buttonL/option.set_animation("A")
	
	trialTimer = Timer.new()
	# Set timer interval
	trialTimer.set_wait_time(choiceMaxTime/1000)
	print(choiceMaxTime/1000)
	# Connect its timeout signal to the function you want to repeat
	trialTimer.connect("timeout", self, "_on_choice")
	# Add to the tree as child of the current node
	add_child(trialTimer)
	# set choice time to max
	choiceTime = choiceMaxTime
	
	trialTimer.one_shot = true
	trialTimer.start()


func iti():
	var endITI = (trialMaxTime - (choiceTime - trialStartTime))/1000
	print("enditi ",endITI)
	$ITI.visible = true
	
	var timer = Timer.new()
	# Set timer interval
	timer.set_wait_time(endITI)
	# Connect its timeout signal to the function you want to repeat
	timer.connect("timeout", self, "start_trial")
	# Add to the tree as child of the current node
	timer.one_shot = true
	add_child(timer)
	timer.start()



func _on_choice():
	choiceTime = OS.get_ticks_msec()
	print("choicetime ", choiceTime)
	iti()


func _on_Button_pressed():
	_on_choice()




func log_data():
	#logic to save data
	pass
