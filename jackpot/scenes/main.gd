extends Control

var reelResult1
var reelResult2
var reelResult3

var receivedHowManyTimes = 0

var betValue
var betResult
var winningMultiplier = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Result.visible = false
	SigBank.rollFinished.connect(Callable(self,"_receiveNumber"))
	pass # Replace with function body.

func _receiveNumber(reelID,rngResult):
	receivedHowManyTimes +=1
	match reelID:
		1:
			reelResult1 = rngResult
		2:
			reelResult2 = rngResult
		3:
			reelResult3 = rngResult
	if receivedHowManyTimes <3:
		print(receivedHowManyTimes)
		
	else:
		receivedHowManyTimes = 0
		_calculateWinning()

func _calculateWinning():
	betValue = int($HBoxContainerBet/Bet.text)
	
	$Result.visible = true
	if reelResult1 == reelResult2 || reelResult2 == reelResult3:
		winningMultiplier = 5
		$Result.text = "x5"
		
	elif  reelResult1 == reelResult2 && reelResult2 == reelResult3:
		winningMultiplier = 100
		$Result.text = "x100"
	else :
		winningMultiplier = -1
		$Result.text = "Loss!"
	
	betResult = betValue * winningMultiplier
	var total_sum = int($HBoxContainerCredit/Credit.text) + betResult
	$HBoxContainerCredit/Credit.text = str(total_sum)
	
	await get_tree().create_tween().tween_property($Result, "scale", Vector2(1.1, 1.1), 1).finished
	$Result.visible = false
	
	
func _on_spin_pressed() -> void:
	SigBank.startRoll.emit(1,2, 0.4)
	SigBank.startRoll.emit(2,2.5, 0.6)
	SigBank.startRoll.emit(3,3, 0.2)
	pass # Replace with function body.
