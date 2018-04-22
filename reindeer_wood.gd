extends Sprite

#init 
onready var timer = get_node("Timer")

# modi
var steps = 0
var maxsteps = steps + 1
var nbr_modi = 8
var repeat = 2
var multimode = true
var mod = 0
var b = true

# led
var whitelist = [0]
var redlist = [0]
var M = 4
var N = 6
var leds = [0][0]


var colors = {
	"black": Color(0,0,0),
	"white": Color(255,255,255),
	"red": Color(255,0,0)
	}


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	whitelist = [$led_w1, $led_w2, $led_w3, $led_w4,$led_w5, $led_w6, $led_w7, $led_w8, $led_w9, $led_w10]
	redlist = [$led_r1, $led_r2, $led_r3, $led_r4,$led_r5, $led_r6, $led_r7, $led_r8, $led_r9, $led_r10]
	leds = [[$led_w1, $led_w3, $led_w5, $led_w7, $led_w9, $led_w10], [$led_r1, $led_r3, $led_r5, $led_r7, $led_r9, $led_r10], [$led_w2, $led_w4, $led_w6, $led_w8, $led_dummy, $led_dummy], [$led_r2, $led_r4, $led_r6, $led_r8, $led_dummy, $led_dummy]]
	

func _on_Timer_timeout():
	if steps < maxsteps:
		if mod == 0:
			timer.set_wait_time(0.5)
			mod_allRedWhite(b)
			b = not b
		if mod == 1:
			timer.set_wait_time(0.5)
			mod_linesVert()
		if mod == 2:
			timer.set_wait_time(0.5)
			mod_randomAll()
		if mod == 3:
			timer.set_wait_time(0.5)
			mod_randomRedWhite(b)
			b = not b
		if mod == 4:
			timer.set_wait_time(0.2)
			mod_runningHzBelly()
		if mod == 5:
			timer.set_wait_time(0.2)
			mod_filledHz()
		if mod == 6:
			timer.set_wait_time(0.1)
			mod_filledVert()
		if mod == 7:
			timer.set_wait_time(0.2)
			mod_singleVert()
		if mod == 8:
			timer.set_wait_time(0.2)
			mod_singleHz()
		steps += 1
	else:
		if multimode:
			if mod == nbr_modi-1: 
				mod = 0
			else:
				mod += 1
		steps = 0				
		reset()
		
#0 mod
func mod_allRedWhite(var b):
	maxsteps = 2 * repeat
	if b:
		for whiteled in whitelist:
			setWhite(whiteled)
		for redled in redlist:
			setBlack(redled)
	else:
		for whiteled in whitelist:
			setBlack(whiteled)
		for redled in redlist:
			setRed(redled)

#1 mod
func mod_linesVert():
	maxsteps = 4 * repeat
	reset()	
	for led in leds[steps%M]:
		setColor(led)

#2 mod
func mod_randomAll():
	maxsteps = 6 * repeat
	for m in range(0,M):
		for n in range(0, N):
			if round(rand_range(0, 1)):
				setColor(leds[m][n])
			else:
				 setBlack(leds[m][n])

#3 mod
func mod_randomRedWhite(var b):
	maxsteps = 6 * repeat
	reset()
	for m in range(0,M):
		for n in range(0, N):
			if round(rand_range(0, 1)):
				var gr = leds[m][n].get_groups()
				if b:
					if gr[0] == "gr_white":
						setColor(leds[m][n])
				else:
					if gr[0] == "gr_red":
						setColor(leds[m][n])
			else:
				 setBlack(leds[m][n])
				
#4 mod
func mod_runningHzBelly():
	maxsteps = 24
	reset()
	if steps < N: 
		setColor(leds[0][steps%N])
	elif steps < 2*N:
		 setColor(leds[1][steps%N])
	elif steps < 3*N:
		for led in leds[2]:
			setColor(led)
	elif steps < 4*N:
		for led in leds[3]:
			setColor(led)

#5 mod
func mod_filledHz():
	maxsteps = 24
	if steps < N: 
		setColor(leds[0][steps%N])
	elif steps < 2*N:
		 setColor(leds[1][steps%N])
	elif steps < 3*N:
		setColor(leds[2][steps%N])
	elif steps < 4*N:
		setColor(leds[3][steps%N])

#6 mod
func mod_filledVert():
	maxsteps = 24
	if steps < M: 
		setColor(leds[steps%M][0])
	elif steps < 2*M:
		 setColor(leds[steps%M][1])
	elif steps < 3*M:
		setColor(leds[steps%M][2])
	elif steps < 4*M:
		setColor(leds[steps%M][3])
	elif steps < 5*M:
		setColor(leds[steps%M][4])
	elif steps < 6*M:
		setColor(leds[steps%M][5])

#7 mod
func mod_singleVert():
	maxsteps = 24
	reset()
	if steps < M: 
		setColor(leds[steps%M][0])
	elif steps < 2*M:
		 setColor(leds[steps%M][1])
	elif steps < 3*M:
		setColor(leds[steps%M][2])
	elif steps < 4*M:
		setColor(leds[steps%M][3])
		
#8 mod
func mod_singleHz():
	maxsteps = 24
	reset()
	if steps < N: 
		setColor(leds[0][steps%N])
	elif steps < 2*N:
		 setColor(leds[1][steps%N])
	elif steps < 3*N:
		setColor(leds[2][steps%N])
	elif steps < 4*N:
		setColor(leds[3][steps%N])


		
func reset():
	for whiteled in whitelist:
		setBlack(whiteled)
	for redled in redlist:
		setBlack(redled)
		
func setRed(var led):
	led.modulate = colors["red"]
	
func setWhite(var led):
	led.modulate = colors["white"]
		
func setBlack(var led):
	led.modulate = colors["black"]
		
func setColor(var led):
		var gr = led.get_groups()
		if gr[0] == "gr_white":
			led.modulate = colors["white"]
		elif gr[0] == "gr_red":
			led.modulate = colors["red"]
		elif gr[0] == "gr_dummy":
			pass 