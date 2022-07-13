extends Control

var t = Timer.new()

#var difficulty = 1 #difficulty multiplier of the game
const letters = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm" #letters to remove drug names
const chars = "0123456789: $*"
var listname = "" 
var oldprice = 0 #price that is paid for a certain drug in average (needed to calculate the next average)
var oldquantity = 0 #quantity of a certain drug you have (needed to calculate the next average)
var average = 0 #new average price of a certain drug
var bought
var cop
var dis = []
var fight = false
var picked = ""
var color = Color(1, 1, 1) #white (for text)
var player_name = "Player"
var score_txt = ""
var score = []
const score_file = "user://score.save"
const save_file = "user://save.save"
var price_store = []
var drug_store = []
var disabled_store = []
var owned_store = []
var market_list = []

var jackass = {"name": "Officer Jackass", "aim": 8, "hp": 100, "bounty": 150000, "alive": true}
var kavass = {"name": "Officer Kavass", "aim": 11, "hp": 175, "bounty": 400000, "alive": true}
var hardass = {"name": "Officer Hardass", "aim": 14, "hp": 300, "bounty": 1000000, "alive": true}
var cops = [jackass, kavass, hardass]

onready var Game = $Game #gets the Game script (to get values from it)

func _ready():
	self.add_child(t)
	
# Real time text and button states are controlled here
func _process(_delta):
	if Game.location["id"] < 8:
		$Game/Labels/LocationLabel.set_text("Location: " + Game.location["name"])
	$Game/Labels/DayLabel.set_text("Day: " + str(Game.day))
	$Game/Labels/SpaceLabel.set_text(str(100 - Game.space) + "/100")
	if Game.space == 0:
		$Game/Labels/SpaceLabel.add_color_override("font_color", Color(0.9, 0, 0))
	else:
		$Game/Labels/SpaceLabel.add_color_override("font_color", Color(1, 1, 1))
	$Game/Labels/CashLabel.set_text("Cash: " + str(Game.cash))
	$Game/Labels/DebtLabel.set_text("Debt: " + str(stepify(Game.debt, 1)))
	$Game/Labels/GunsLabel.set_text("Damage: " + str(Game.damage))
	$Game/Labels/HealthLabel.set_text("Health: " + str(Game.health))
	if fight == true:
		$Game/Cops/Cop.set_text(cop["name"])
		$Game/Cops/YourDamage.set_text("Damage: " + str(Game.damage))
		$Game/Cops/YourHealth.set_text("HP: " + str(Game.health))
		$Game/Cops/CopHealth.set_text("HP: " + str(cop["hp"]))
	
	if $Game/Inventory.is_anything_selected():
		$Game/Buttons/TradeButton2.show()
		$Game/Buttons/TradeButton2.disabled = false
	else:
		$Game/Buttons/TradeButton2.disabled = true
	if $Game/Market.is_anything_selected():
		$Game/Buttons/TradeButton2.hide()
		$Game/Buttons/TradeButton.disabled = false
	else:
		$Game/Buttons/TradeButton.disabled = true
	if !$Game/Inventory.is_anything_selected():
		$Game/SellPopup.hide()
	if !$Game/Market.is_anything_selected():
		$Game/BuyPopup.hide()

# Starts a new game
func _on_StartButton_pressed():
	$Menu.hide()
	Game.init()
	$Game.show()
	$Game/Market.clear()
	$Game/Inventory.clear()
	Game.loadMarket()


# Quits the game
func _on_QuitButton_pressed():
	get_tree().quit()

# Shows the BuyPopup
func _on_TradeButton_pressed():
	$Game/BuyPopup.show()
	$Game/SellPopup.hide()

# Shows the SellPopup
func _on_TradeButton2_pressed():
	$Game/SellPopup.show()
	$Game/BuyPopup.hide()
	var sell_max = Game.drugs[picked]["owned"]
	if int($Game/SellPopup/SellQuantity.get_text()) > int(sell_max):
		$Game/SellPopup/SellQuantity.set_text(sell_max)

# Unselects Inventory selection when Market is clicked on
func _on_Market_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			$Game/Inventory.unselect_all()
			$Game/BuyPopup/BuyQuantity.set_text("")
			if $Game/Market.get_selected_items():
				picked = $Game/Market.get_selected_items()[0]

# Unselects Market selection when Inventory is clicked on
func _on_Inventory_gui_input(event): #when inventory itemlist clicked
	if event is InputEventMouseButton: #if mouse is used
		if event.button_index == BUTTON_LEFT and event.pressed: #if action is LMB
			$Game/Market.unselect_all() #unselect all from the market
			$Game/SellPopup/SellQuantity.set_text("")
			t.set_wait_time(0.001)
			t.set_one_shot(true)
			t.start()
			yield(t, "timeout")
			if $Game/Inventory.get_selected_items():
				for i in Game.drugs:
					if i["name"].substr(0,2) == $Game/Inventory.get_item_text($Game/Inventory.get_selected_items()[0]).substr(0,2):
						picked = i["id"]

# Opens Settings
func _on_SettingsButton_pressed():
	$Settings.show()
	$Menu.hide()

# Activates the colour help
func _on_PriceHelpToggle_toggled(button_pressed):
	Game.priceHelp = button_pressed

# Returns to Menu from Settings
func _on_Back_pressed():
	$Menu.show()
	$Settings.hide()

# Restarts the game
func _on_RestartButton_pressed():
	$Game/RestartDialog.show()

# Goes to Menu and resets game data
func _on_MenuButton_pressed():
	$Game/MenuDialog.show()

# Opens TravelMenu
func _on_TravelButton_pressed():
	$Game/TravelMenu.show()
	$Game/BuyPopup.hide()
	$Game/SellPopup.hide()


func disable_list():
	for i in range($Game/Inventory.get_item_count()):
		if $Game/Inventory.get_item_text(i).rstrip(chars) in Game.disabled:
			$Game/Inventory.set_item_disabled(i, true)
		else:
			$Game/Inventory.set_item_disabled(i, false)

# Sets the new location and cop data with a chance to find drugs
func _on_Travel_pressed():
	$Game/BuyPopup.hide()
	$Game/SellPopup.hide()
	if $Game/TravelMenu/LocationList.is_anything_selected():
		Game.location = Game.location_list[$Game/TravelMenu/LocationList.get_selected_items()[0]] # Set the selected location as the current location
		Game.disabled = []
		$Game/TravelMenu.hide()
		if Game.day == Game.length - 3:
			$Game/Warning.show()
		if Game.day == Game.length: # Game over
			game_over()
		if Game.location["id"] < 8: # If normal location
			Game.day += 1
			Game.debt *= Game.vigorish
			var x = Game.rng.randi_range(0, 5) # Cop chance 1/6 (0, 5)
			if !x and cops.size():
				$Game/Cops.show()
				$Game/Buttons.hide()
				fight = true
				cop = cops[Game.rng.randi() % cops.size()]
				$Game/Cops/Cop.set_text(cop["name"])
				$Game/Cops/YourDamage.set_text("Damage: " + str(Game.damage))
				$Game/Cops/YourHealth.set_text("HP: " + str(Game.health))
				$Game/Cops/CopHealth.set_text("HP: " + str(cop["hp"]))
			$Game/Info.clear()
			$Game/Market.clear()
			Game.loadMarket()
			var r = Game.rng.randi() % 15 # Find drug
			if Game.drugs[r]["rarity"] > Game.rng.randi() % 25 && Game.space: #25
				var q = Game.rng.randi() % 10 + 1
				if q > 5:
					q = Game.rng.randi() % 10 + 1
				if Game.space < q:
					q = Game.space
				$Game/Info.append_bbcode("[color=#1E90FF]" + "You have found " + str(q) + " " + str(Game.drugs[r]["name"]) + "." + "[/color]\n")
				Game.drugs[r]["owned"] += q
				drug_increase(Game.drugs[r]["name"], q)
		elif Game.location["id"] == 8: # If loan shark
			$Game/Shark.show()
			$Game/Shark/OwedLabel.set_text("Owed: " + str(Game.debt))
		elif Game.location["id"] == 9:
			$Game/GunShop.show()
		disable_list()

# Hides TravelMenu
func _on_Cancel_pressed():
	$Game/TravelMenu.hide()

# Gets game duration data from Settings
func setLength(l, n):
	Game.length = l
	$Settings/Check20.pressed = false
	$Settings/Check30.pressed = false
	$Settings/Check45.pressed = false
	$Settings/Check60.pressed = false
	n.pressed = true

# Makes the game duration 20 days
func _on_Check20_pressed():
	setLength(20, $Settings/Check20)

# Makes the game duration 30 days
func _on_Check30_pressed():
	setLength(30, $Settings/Check30)

# Makes the game duration 45 days
func _on_Check45_pressed():
	setLength(45, $Settings/Check45)

# Makes the game duration 60 days
func _on_Check60_pressed():
	setLength(60, $Settings/Check60)

# Buys a drug if conditions are met
func _on_ConfirmBuy_pressed():
	picked = $Game/Market.get_selected_items()[0] # Selected item id
	var cost = Game.dplist[picked]
	var situation = false
	var quantity = $Game/BuyPopup/BuyQuantity.get_text()
	if (int(quantity) > 0) && (int(quantity) <= Game.space):
		var spent = cost * int(quantity)
		bought = $Game/Market.get_item_text(picked)
		var dname = bought.rstrip(chars)
		oldprice = 0
		oldquantity = 0
		if $Game/Inventory.get_item_count(): # If buying an owned drug get current drug information
			for i in $Game/Inventory.get_item_count():
				if $Game/Inventory.get_item_text(i).substr(0,2) == Game.drugs[picked]["name"].substr(0,2):
					oldprice = $Game/Inventory.get_item_text(i).rstrip("0123456789")
					oldprice = int(oldprice.lstrip(letters + " $:").rstrip(" *"))
					#oldprice = int(listname.lstrip(letters + " $:"))
					oldquantity = $Game/Inventory.get_item_text(i).lstrip(letters + " :$0123456789")
					oldquantity = int(oldquantity.lstrip(" *"))
		if Game.cash < spent:
			quantity = int(Game.cash / cost)
			spent = quantity * cost
		if spent:
			for i in Game.drugs:
				if i["name"] == dname:
					average = (oldprice * oldquantity + int(quantity) * cost) / (oldquantity + int(quantity))
					i["owned"] += int(quantity)
					listname = (dname + ": $" + str(stepify(average, 0.1)) + " * " + str(i["owned"]))
	#					oldprice = average
					break
			for i in range($Game/Inventory.get_item_count()):
				if $Game/Inventory.get_item_text(i).substr(0,3) == bought.substr(0,3):
					$Game/Inventory.set_item_text(i, (listname))
					situation = true
					break
			if !situation:
				$Game/Inventory.add_item(listname)
				situation = false
		average = 0 #avereage reset
		oldprice = 0 #average reset
		oldquantity = 0 #average reset
		Game.cash -= spent
		Game.space -= int(quantity)
		if !Game.owned.has(bought.rstrip(chars)):
			Game.owned.append(bought.rstrip(chars))
	disable_list()

# Sell a drug if conditions are met
func _on_ConfirmSell_pressed():
	var sale = 0
	var quantity = int($Game/SellPopup/SellQuantity.get_text())
	var l = $Game/Inventory.get_selected_items()
	if l && quantity:
		var v = $Game/Inventory.get_item_text(l[0]) #get selected item text
		var dname = v.rstrip(chars) #get selected drug name
		var dquantity = v.lstrip(dname + " :$0123456789")
		dquantity = int(dquantity.lstrip(" *"))
		for i in Game.drugs:
			if i["name"] == dname: #find the drug in drug list
				var price = Game.dplist[i["id"]] #get the drug price
				quantity = min(quantity, dquantity)
				sale = price * quantity #total sale price
				drug_reduce(dname, quantity, i["id"])
		$Game/Buttons/TradeButton2.disabled = true
		Game.cash += int(sale)


#func drug_add(dname, l, i):
#	$Game/Inventory.remove_item(l[0])
#	Game.drugs[Game.drugs.find(i)]["owned"] = 0
#	Game.owned.erase(dname)
#	average = 0 #avereage reset
#	oldprice = 0 #average reset
#	oldquantity = 0 #average reset
#	disable_list()


func drug_reduce(dname, quantity, id):
	if $Game/Inventory.get_item_count():
		for i in $Game/Inventory.get_item_count(): #for size of inventory
			var v = $Game/Inventory.get_item_text(i) #get text
			if v.substr(0,3) == dname.substr(0,3): #if same drug
				var dquantity = v.lstrip(dname + " :$0123456789")
				var dprice = v.lstrip(dname + ": $").rstrip("0123456789")
				dprice = dprice.rstrip(" *")
				dquantity = int(dquantity.lstrip(" *"))
				quantity = min(quantity, dquantity) #minimize to owned
				Game.space += int(quantity)
				Game.drugs[id]["owned"] -= quantity
				dquantity -= quantity
				if !dquantity:
					Game.owned.erase(dname) #remove drug from owned
					$Game/Inventory.remove_item(i) #remove drug from inventory
					break
				else:
					$Game/Inventory.set_item_text(i, dname + ": $" + dprice + " * " + str(dquantity))
					oldprice = dprice #average fix
					oldquantity = dquantity #average fix
					break
		disable_list()

# Increase drug (when found / not bought)
func drug_increase(dname, quantity):
	var case = false
	Game.space -= quantity
	for i in $Game/Inventory.get_item_count():
		var v = $Game/Inventory.get_item_text(i)
		if v.substr(0,2) == dname.substr(0,2):
			var dquantity = v.lstrip(dname + ": $0123456789")
			var dprice = v.lstrip(dname + ": $").rstrip("0123456789")
			dprice = dprice.rstrip(" *")
			dquantity = int(dquantity.lstrip(" *"))
			var avg = int(dprice) * dquantity / (quantity + dquantity)
			dquantity += quantity
			$Game/Inventory.set_item_text(i, dname + ": $" + str(avg) + " * " + str(dquantity))
			case = true
	if !case:
		$Game/Inventory.add_item(dname + ": $0 * " + str(quantity))
		Game.owned.append(dname)
	disable_list()

# Unselect all drugs when an empty place is clicked
func _on_Game_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			$Game/Market.unselect_all()
			$Game/Inventory.unselect_all()

# Decides if a cop attacks successfully
func cop_attack(copx):
	if Game.rng.randi_range(0, 19) < copx["aim"]: #cop attack chance
		Game.health -= 5 #cop damage is 5
		if Game.health <= 0: #death
			game_over()
	else:
		return false


# Fight with cops menu opens
func _on_Fight_pressed():
	cop_attack(cop)
	cop["hp"] -= Game.damage
	if cop["hp"] <= 0:
		$Game/Cops.hide()
		$Game/Buttons.show()
		Game.cash += cop["bounty"]
		cop["alive"] = false
		cops.erase(cop)

# Attemps to flee with a chance to drop drugs
func _on_Run_pressed():
	if !Game.rng.randi_range(0, 2):
		$Game/Cops.hide()
		$Game/Buttons.show()
		$Game/Info.add_text("You have fleed succesfully!")
		if Game.owned.size():
			var did = Game.rng.randi() % 15
			var lost_d = Game.drugs[did]
			for _i in range(0,10):
				if !lost_d["owned"]:
					did = Game.rng.randi() % 15
					lost_d = Game.drugs[did]
			if lost_d["owned"]:
				var lost_q = Game.rng.randi() % min(lost_d["owned"], 10)
				if lost_q:
					$Game/Info.append_bbcode("[color=#FF901E]" + "\nYou have dropped " + str(lost_q) + " " + str(lost_d["name"]) + "." + "[/color]\n")
					drug_reduce(lost_d["name"], lost_q, did)
	else:
		cop_attack(cop)

# Keeps the buy quantity in its maximum possible limit (not enough cash or space)
func _on_BuyQuantity_text_changed(new_text):
	var minimize = 100 #maximum possible limit
	if !new_text.is_valid_integer(): #if a non digit character entered
		$Game/BuyPopup/BuyQuantity.set_text("") #clears buy quantity
	else: #if a digit entered
		for i in Game.drugs:
			if $Game/Market.get_item_text($Game/Market.get_selected_items()[0]).substr(0,2) == i["name"].substr(0,2):
				if Game.cash < Game.dplist[i["id"]] * int(new_text):
					minimize = int(Game.cash / Game.dplist[$Game/Market.get_selected_items()[0]])
				break
		if minimize < int(new_text):
			$Game/BuyPopup/BuyQuantity.set_text(str(min(minimize, Game.space)))

# Limits the sell quantity to owned amount
func _on_SellQuantity_text_changed(new_text):
	var sell_max = Game.drugs[int(picked)]["owned"] #quantity of picked drug (picked is in _on_Inventory_gui_input())
	if !new_text.is_valid_integer():
		$Game/SellPopup/SellQuantity.set_text("")
	if int($Game/SellPopup/SellQuantity.get_text()) > sell_max:
		$Game/SellPopup/SellQuantity.set_text(str(sell_max))


func _on_SharkClose_pressed():
	$Game/Shark.hide()


func _on_BorrowMax_toggled(button_pressed):
	if button_pressed:
		$Game/Shark/BorrowEdit.set_text(str(99999 - Game.debt))
	else:
		$Game/Shark/BorrowEdit.set_text("")


func _on_BorrowEdit_text_changed(new_text):
	if new_text.is_valid_integer():
		if int(new_text) >= 99999 - Game.debt:
			$Game/Shark/BorrowEdit.set_text(str(99999 - Game.debt))
	else:
		$Game/Shark/BorrowEdit.set_text("")


func _on_PayMax_toggled(button_pressed):
	if button_pressed:
		$Game/Shark/PayEdit.set_text(str(min(Game.debt, Game.cash)))
	else:
		$Game/Shark/PayEdit.set_text("")


func _on_PayEdit_text_changed(new_text):
	if new_text.is_valid_integer():
		if int(new_text) >= min(Game.debt, Game.cash):
			$Game/Shark/PayEdit.set_text(str(min(Game.debt, Game.cash)))
	else:
		$Game/Shark/PayEdit.set_text("")


func _on_BorrowButton_pressed():
	Game.cash += min(int($Game/Shark/BorrowEdit.get_text()), 99999 - Game.debt)
	Game.debt += min(int($Game/Shark/BorrowEdit.get_text()), 99999 - Game.debt)
	$Game/Shark/OwedLabel.set_text("Owed: " + str(Game.debt))
	$Game/Shark/BorrowMax.pressed = false


func _on_PayButton_pressed():
	Game.cash -= min(int($Game/Shark/PayEdit.get_text()), Game.debt)
	Game.debt -= min(int($Game/Shark/PayEdit.get_text()), Game.debt)
	$Game/Shark/OwedLabel.set_text("Owed: " + str(Game.debt))
	$Game/Shark/PayMax.pressed = false


func _on_PistolBtn_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Game.cash >= 3500:
				Game.cash -= 3500
				Game.damage += 2


func _on_RevolverBtn_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Game.cash >= 6500:
				Game.cash -= 6500
				Game.damage += 4


func _on_SmgBtn_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Game.cash >= 10000:
				Game.cash -= 10000
				Game.damage += 7


func _on_ShotgunBtn_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Game.cash >= 12000:
				Game.cash -= 12000
				Game.damage += 9


func _on_Button_pressed():
	$Game/GunShop.hide()

# Pistol button zoom in when hovered
func _on_PistolBtn_mouse_entered():
	$Game/GunShop/PistolBtn.set_scale(Vector2(0.32, 0.32))
	$Game/GunShop/PistolBtn.set_position(Vector2(-10, -6))

# Pistol button zoom out when hovered
func _on_PistolBtn_mouse_exited():
	$Game/GunShop/PistolBtn.set_scale(Vector2(0.3, 0.3))
	$Game/GunShop/PistolBtn.set_position(Vector2(0, 0))

# Revolver button zoom in when hovered
func _on_RevolverBtn_mouse_entered():
	$Game/GunShop/RevolverBtn.set_scale(Vector2(0.32, 0.32))
	$Game/GunShop/RevolverBtn.set_position(Vector2(290, -6))

# Revolver button zoom out when hovered
func _on_RevolverBtn_mouse_exited():
	$Game/GunShop/RevolverBtn.set_scale(Vector2(0.3, 0.3))
	$Game/GunShop/RevolverBtn.set_position(Vector2(300, 0))

# SMG button zoom in when hovered
func _on_SmgBtn_mouse_entered():
	$Game/GunShop/SmgBtn.set_scale(Vector2(0.32, 0.32))
	$Game/GunShop/SmgBtn.set_position(Vector2(-10, 174))

# SMG button zoom out when hovered
func _on_SmgBtn_mouse_exited():
	$Game/GunShop/SmgBtn.set_scale(Vector2(0.3, 0.3))
	$Game/GunShop/SmgBtn.set_position(Vector2(0, 180))

# Shotgun button zoom in when hovered
func _on_ShotgunBtn_mouse_entered():
	$Game/GunShop/ShotgunBtn.set_scale(Vector2(0.32, 0.32))
	$Game/GunShop/ShotgunBtn.set_position(Vector2(290, 174))

# Shotgun button zoom out when hovered
func _on_ShotgunBtn_mouse_exited():
	$Game/GunShop/ShotgunBtn.set_scale(Vector2(0.3, 0.3))
	$Game/GunShop/ShotgunBtn.set_position(Vector2(300, 180))

# Closes death screen when LMB clicked
func _on_Death_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			$Death.hide()

# Save score data
func _on_SaveScore_pressed():
	$GameOver/Score/SaveScore.disabled = true
	var file = File.new() #create new file
	file.open(score_file, File.READ) #read file
	score = file.get_var() #get data into score
	file.close() #close the read-only file
	file.open(score_file, File.WRITE) #open file to write data in it
	if $GameOver/Score/PlayerName.get_text(): #if player name entered
		player_name = $GameOver/Score/PlayerName.get_text() #put player name into player_name
	if score: # Appends score list if score file hasd any data in it
		if Game.length == 20:
			score.append({"tab": $GameOver/Scoreboard20, "name": player_name, "score": Game.cash})
		elif Game.length == 30:
			score.append({"tab": $GameOver/Scoreboard30, "name": player_name, "score": Game.cash})
		elif Game.length == 45:
			score.append({"tab": $GameOver/Scoreboard45, "name": player_name, "score": Game.cash})
		else:
			score.append({"tab": $GameOver/Scoreboard60, "name": player_name, "score": Game.cash})
	else: # Enters first data into score file
		if Game.length == 20:
			score = [{"tab": $GameOver/Scoreboard20, "name": player_name, "score": Game.cash}]
		elif Game.length == 30:
			score = [{"tab": $GameOver/Scoreboard30, "name": player_name, "score": Game.cash}]
		elif Game.length == 45:
			score = [{"tab": $GameOver/Scoreboard45, "name": player_name, "score": Game.cash}]
		else:
			score = [{"tab": $GameOver/Scoreboard60, "name": player_name, "score": Game.cash}]
	var tmp = score[len(score) - 1]
	# Next 8 lines adds final score to the proper table
	if Game.length == 20:
		$GameOver/Scoreboard20.add_item(str(tmp["name"]) + ": " + str(tmp["score"]))
	elif Game.length == 30:
		$GameOver/Scoreboard30.add_item(str(tmp["name"]) + ": " + str(tmp["score"]))
	elif Game.length == 45:
		$GameOver/Scoreboard45.add_item(str(tmp["name"]) + ": " + str(tmp["score"]))
	else:
		$GameOver/Scoreboard60.add_item(str(tmp["name"]) + ": " + str(tmp["score"]))
	file.store_var(score) #puts score data into file
	file.close() #close write file

# Load score data
func load_score():
	var file = File.new()
	if file.file_exists(score_file):
		file.open(score_file, File.READ)
		score = file.get_var()
		file.close()

# When player dies or day limit reached
func game_over():
	Game.cash -= Game.debt
	if Game.cash < 0 || Game.health <= 0:
		$Death.show()
	else:
		load_score()
		if score:
			for i in score:
				if Game.length == 20:
					$GameOver/Scoreboard20.add_item(str(i["name"]) + ": " + str(i["score"]))
				elif Game.length == 30:
					$GameOver/Scoreboard30.add_item(str(i["name"]) + ": " + str(i["score"]))
				elif Game.length == 45:
					$GameOver/Scoreboard45.add_item(str(i["name"]) + ": " + str(i["score"]))
				else:
					$GameOver/Scoreboard60.add_item(str(i["name"]) + ": " + str(i["score"]))
		$GameOver.show()
		$GameOver/Score.show()
		if Game.cash < 1000000:
			score_txt = str(round(Game.cash))
			color = Color(0.8, 0.8, 0.0)
		elif Game.cash < 100000000:
			score_txt = str(stepify(float(Game.cash) / 1000000, 0.01)) + "M"
			color = Color(0.8, 0.8, 0.0)
		else:
			score_txt = str(round(Game.cash / 1000000)) + "M"
			color = Color(0.8, 0.8, 0.0)
		$GameOver/Score/ScoreLbl.set_text(score_txt)
		$GameOver/Score/ScoreLbl.add_color_override("font_color", color)
		
	$Game.hide()
	$Game/Cops.hide()
	$Menu.show()

# Save game data (only one save slot)
func _on_SaveButton_pressed():
	var file = File.new() #create new file
	file.open(save_file, File.WRITE) #open file to write data in it
	for i in range(15):
		market_list.append($Game/Market.get_item_text(i))
	Game.saved = {"day": Game.day, 
		"space": Game.space, 
		"cash": Game.cash, 
		"debt": Game.debt, 
		"guns": Game.guns, 
		"damage": Game.damage, 
		"health": Game.health, 
		"vigorish": Game.vigorish, 
		"length": Game.length, 
		"location": Game.location, 
		"dplist": Game.dplist, 
		"drugs": Game.drugs, 
		"owned": Game.owned,
		"market": market_list}
	file.store_var(Game.saved)
	file.close()


func _on_LoadButton_pressed():
	$Game/LoadDialog.show()

# Load the latest saved game state
func _on_LoadDialog_confirmed():
	var file = File.new()
	if file.file_exists(save_file):
		file.open(save_file, File.READ)
		var x = file.get_var(true)
		Game.day = x["day"]
		Game.space = x["space"]
		Game.cash = x["cash"]
		Game.debt = x["debt"]
		Game.guns = x["guns"]
		Game.damage = x["damage"]
		Game.health = x["health"]
		Game.vigorish = x["vigorish"]
		Game.length = x["length"]
		Game.location = x["location"]
		Game.dplist = x["dplist"]
		Game.drugs = x["drugs"]
		Game.owned = x["owned"]
		$Game/Market.clear()
		for i in x["market"]:
			$Game/Market.add_item(i)
		file.close()


func _on_RestartDialog_confirmed():
	$Game/Info.clear()
	$Game/BuyPopup.hide()
	$Game/SellPopup.hide()
	Game.init()
	$Game/Market.clear()
	$Game/Inventory.clear()
	Game.loadMarket()


func _on_MenuDialog_confirmed():
	$Menu.show()
	$Game.hide()
	$Game/Cops.hide()
	$Game/Shark.hide()
	$Game/Info.clear()
	$Game/BuyPopup.hide()
	$Game/SellPopup.hide()
	$Game/TravelMenu.hide()
	$Game/BuyPopup/BuyQuantity.clear()
	$Game/SellPopup/SellQuantity.clear()
