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
	
	var spin_btn = custom_button.new()
	spin_btn.initialize($Spin, $Spin/TextureRect)
	spin_btn.connect("btn_pressed", _on_spin_pressed)
	
	var inc_bet_btn = custom_button.new()
	inc_bet_btn.initialize($Increase, $Increase/TextureRect)
	inc_bet_btn.connect("btn_pressed", _on_increase_bet_pressed)
	
	var dec_bet_btn = custom_button.new()
	dec_bet_btn.initialize($Decrease, $Decrease/TextureRect)
	dec_bet_btn.connect("btn_pressed", _on_decrease_bet_pressed)
	pass # Replace with function body.

func _on_increase_bet_pressed():
	var bet_value = int($HBoxContainerBet/Bet.text)
	var credit = int($HBoxContainerCredit/Credit.text)
	if credit >= bet_value + 10:
		$HBoxContainerBet/Bet.text = str(int($HBoxContainerBet/Bet.text) + 10)
	pass
	
func _on_decrease_bet_pressed():
	var bet_value = int($HBoxContainerBet/Bet.text)
	if bet_value > 10:
		$HBoxContainerBet/Bet.text = str(int($HBoxContainerBet/Bet.text) - 10)
	pass
	
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
	$Spin.disabled = false
	$Increase.disabled = false
	$Decrease.disabled = false
	
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
	
	$Spin.disabled = true
	$Increase.disabled = true
	$Decrease.disabled = true
	pass # Replace with function body.
