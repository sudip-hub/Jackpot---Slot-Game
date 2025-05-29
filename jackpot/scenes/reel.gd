extends Node2D
@export var slotItemCount : int = 10
@export var spriteSize  : int = 16
@onready var reel1 = $reel1
@onready var reel2 = $reel2
var TWN
var MS = 50
var state 
enum {ROLL,STOP,ROLLBACK}
var rollDuration = 3
var rollBackDuration =0.5
@export var reelID:int

var item_mapping = ["Apple", "Grape", "Banana", "Strawberry", "Orange", "Diamond", "Bar", "Coins", "777", "Watermelon"]

# Called when the node enters the scene tree for the first time.
func _ready():
	SigBank.startRoll.connect(Callable(self,"_startRoll"))
	reel1.position.y = -1250
	reel2.position.y = 0
	#state = ROLLBACK
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		ROLLBACK:
			gradual_roll = 300 * delta
			print(gradual_roll)
			if gradual_roll <= 15:
				_roll(reel1,-gradual_roll)
				_roll(reel2,-gradual_roll)
			
			rollBackDuration -= delta
			if rollBackDuration <= 0:
				state = ROLL
		ROLL:
			_roll(reel1,MS)
			_roll(reel2,MS)
			
			rollDuration -= delta
			if rollDuration <= 0:
				state = STOP
				_stopRoll()
		STOP:
			pass
	
var gradual_roll = 15

func _startRoll(reelNumber,dur, rollback_dur):
	if reelNumber!= reelID : return
	
	#reel1.position.y = -1250
	#reel2.position.y = 0
	state = ROLLBACK
	rollDuration = dur
	print(reelID,reelNumber,dur)
	rollBackDuration = rollback_dur
	

func _roll(slot,MSpeed):
	var newPOS2 = slot.position.y + MSpeed
	if newPOS2 >= 1250:
		newPOS2 =-1250
	slot.position.y = newPOS2

func _stopRoll():
	TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	var rng = randi_range(0,9)
	var dur = 1.5

	var finalPos = -125*rng
	
	var finalSlot
	var anotherSlot
	if reel1.position.y < reel2.position.y:
		finalSlot = reel1
		anotherSlot = reel2
	else:
		finalSlot = reel2
		anotherSlot = reel1
	
	finalSlot.z_index = 1
	anotherSlot.z_index = 0
	TWN.tween_property(finalSlot,"position:y",finalPos,dur)
	TWN.tween_property(anotherSlot,"position:y",finalPos+1250,dur)
	await TWN.finished
	print("Reeel ID",reelID," reel Image ", finalSlot.name ," POS : ",finalPos, " RNJESUS :",rng, "Item : ", item_mapping[rng])
	SigBank.rollFinished.emit(reelID,rng)
