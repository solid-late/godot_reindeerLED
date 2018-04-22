extends Sprite

#init 
onready var timer = get_node("Timer") # get node reference

# modi
var count = 0
var nbr_modi = 8
var repeat = 2
var multimode = true
var mod = 0

# led
var whitelist = [0]
var redlist = [0]
var M = 4
var N = 6
var leds = [0][0]

#init mod 0
var b = true
var maxcount = 2 * repeat

var colors = {
	"black": Color(0,0,0),
	"white": Color(255,255,255),
	"red": Color(255,0,0)
	}

var groups = {
	"white": "gr_white",
	"red": "gr_red"
	}


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	whitelist = [$led_w1, $led_w2, $led_w3, $led_w4,$led_w5, $led_w6, $led_w7, $led_w8, $led_w9, $led_w10]
	redlist = [$led_r1, $led_r2, $led_r3, $led_r4,$led_r5, $led_r6, $led_r7, $led_r8, $led_r9, $led_r10]
	leds = [[$led_w1, $led_w3, $led_w5, $led_w7, $led_w9, $led_w10], [$led_r1, $led_r3, $led_r5, $led_r7, $led_r9, $led_r10], [$led_w2, $led_w4, $led_w6, $led_w8, $led_dummy, $led_dummy], [$led_r2, $led_r4, $led_r6, $led_r8, $led_dummy, $led_dummy]]
	
func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass


func _on_Timer_timeout():
	if count < maxcount:
		if mod == 0:
			timer.set_wait_time(0.5)
			mod_onlyredwhite(b)
			b = not b
		if mod == 1:
			mod_wave1()
		if mod == 2:
			timer.set_wait_time(0.5)
			mod_random1()
		if mod == 3:
			timer.set_wait_time(0.5)
			mod_random2(b)
			b = not b
		if mod == 4:
			timer.set_wait_time(0.2)
			mod_snake1()
		if mod == 5:
			timer.set_wait_time(0.2)
			mod_wave2()
		if mod == 6:
			timer.set_wait_time(0.1)
			mod_snake2()
		if mod == 7:
			timer.set_wait_time(0.5)
			mod_wave3()
		if mod == 8:
			timer.set_wait_time(0.2)
			mod_wave4()
		count += 1
	else:
		# start from the first mode or use next one
		if multimode:
			if mod == nbr_modi-1: 
				mod = 0
			else:
				mod += 1
		count = 0				
		reset()
		
		
func mod_onlyredwhite(var b):
	maxcount = 2 * repeat
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

		
func mod_wave1():
	maxcount = 4 * repeat
	reset()	
	for led in leds[count%M]:
		setColor(led)

func mod_random1():
	maxcount = 6 * repeat
	for m in range(0,M):
		for n in range(0, N):
			if round(rand_range(0, 1)):
				setColor(leds[m][n])
			else:
				 setBlack(leds[m][n])
				
func mod_random2(var b):
	maxcount = 6 * repeat
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

func mod_snake1():
	maxcount = 24
	reset()
	if count < N: 
		setColor(leds[0][count%N])
	elif count < 2*N:
		 setColor(leds[1][count%N])
	elif count < 3*N:
		for led in leds[2]:
			setColor(led)
	elif count < 4*N:
		for led in leds[3]:
			setColor(led)
			
func mod_wave2():
	maxcount = 24
	if count < N: 
		setColor(leds[0][count%N])
	elif count < 2*N:
		 setColor(leds[1][count%N])
	elif count < 3*N:
		setColor(leds[2][count%N])
	elif count < 4*N:
		setColor(leds[3][count%N])

func mod_wave3():
	maxcount = 24
	if count < M: 
		setColor(leds[count%M][0])
	elif count < 2*M:
		 setColor(leds[count%M][1])
	elif count < 3*M:
		setColor(leds[count%M][2])
	elif count < 4*M:
		setColor(leds[count%M][3])
	elif count < 5*M:
		setColor(leds[count%M][4])
	elif count < 6*M:
		setColor(leds[count%M][5])
		
func mod_wave4():
	maxcount = 24
	reset()
	if count < M: 
		setColor(leds[count%M][0])
	elif count < 2*M:
		 setColor(leds[count%M][1])
	elif count < 3*M:
		setColor(leds[count%M][2])
	elif count < 4*M:
		setColor(leds[count%M][3])
		

func mod_snake2():
	maxcount = 24
	reset()
	if count < N: 
		setColor(leds[0][count%N])
	elif count < 2*N:
		 setColor(leds[1][count%N])
	elif count < 3*N:
		setColor(leds[2][count%N])
	elif count < 4*N:
		setColor(leds[3][count%N])


		
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