extends Control

var rng = RandomNumberGenerator.new()
var priceHelp = false

var day = 1
var space = 100
var cash = 2000
var debt = 5500
var guns = 0
var damage = 0
var health = 100
var vigorish = 1.1
var length = 30

const bronx = {"id": 0, "name": "Bronx", "officer": "Jackass", "police": 15}
const ghetto = {"id": 1, "name": "Ghetto", "officer": "Jackass", "police": 10}
const central_park = {"id": 2, "name": "Central Park", "officer": "Kavass", "police": 15}
const staten_island = {"id": 3, "name": "Staten Island", "officer": "Kavass", "police": 20}
const coney_island = {"id": 4, "name": "Coney Island", "officer": "Kavass", "police": 25}
const queens = {"id": 5, "name": "Queens", "officer": "Hardass", "police": 30}
const brooklyn = {"id": 6, "name": "Brooklyn", "officer": "Hardass", "police": 35}
const manhattan = {"id": 7, "name": "Manhattan", "officer": "Hardass", "police": 40}
const shark = {"id": 8, "name": "Loan Shark", "officer": null, "police": 0}
const gun_shop = {"id": 9, "name": "Gun Shop", "officer": null, "police": 0}

var location = bronx

var location_list = [bronx, ghetto, central_park, staten_island, coney_island, queens, brooklyn, manhattan, shark, gun_shop]

var he
var ap
var op
var co
var cr
var me
var we
var ec
var ac
var sh
var ha
var be
var pe
var sp
var lu

var dplist = [he, ap, op, co, cr, me, we, ec, ac, sh, ha, be, pe, sp, lu]

var heroin = {"id": 0, "owned": 0, "name": "Heroin", "cheap": null, "expensive": null, "rarity": 1, "min": 60000, "max": 155000}
var apache = {"id": 1, "owned": 0, "name": "Apache", "cheap": null, "expensive": true, "rarity": 2, "min": 30500, "max": 60000}
var opium = {"id": 2, "owned": 0, "name": "Opium", "cheap": null, "expensive": null, "rarity": 2, "min": 15000, "max": 50000}
var cocaine = {"id": 3, "owned": 0, "name": "Coke", "cheap": "Rivals are competing to sell Coke!", "expensive": null, "rarity": 3, "min": 25000, "max": 45000}
var crack =  {"id": 4, "owned": 0, "name": "Crack", "cheap": null, "expensive": null, "rarity": 3, "min": 10000, "max": 35000}
var meth = {"id": 5, "owned": 0, "name": "Meth", "cheap": null, "expensive": true, "rarity": 3, "min": 13000, "max": 32000}
var weed = {"id": 6, "owned": 0, "name": "Weed", "cheap": "Columbian freighter dusted the Coast Guard! Weed prices have bottomed out!", "expensive": null, "rarity": 4, "min": 5000, "max": 18000}
var ecstasy = {"id": 7, "owned": 0, "name": "Ecstasy", "cheap": null, "expensive": null, "rarity": 4, "min": 2300, "max": 7000}
var acid = {"id": 8, "owned": 0, "name": "Acid", "cheap": "The market is flooded with cheap home-made acid!", "expensive": null, "rarity": 4, "min": 1500, "max": 4500}
var shrooms = {"id": 9, "owned": 0, "name": "Shrooms", "cheap": null, "expensive": true, "rarity": 4, "min": 800, "max": 2100}
var hashish = {"id": 10, "owned": 0, "name": "Hash", "cheap": "The Marrakesh Express has arrived!", "expensive": null, "rarity": 5, "min": 480, "max": 1280}
var benzos = {"id": 11, "owned": 0, "name": "Benzos",  "cheap": null, "expensive": null, "rarity": 5, "min": 220, "max": 1200}
var peyote = {"id": 12, "owned": 0, "name": "Peyote", "cheap": null, "expensive": true, "rarity": 5, "min": 150, "max": 850}
var speed = {"id": 13, "owned": 0, "name": "Speed", "cheap": null, "expensive": true, "rarity": 5, "min": 70, "max": 400}
var ludes = {"id": 14, "owned": 0, "name": "Ludes", "cheap": "Rival drug dealers raided a pharmacy and are selling cheap ludes!", "expensive": null, "rarity": 5, "min": 10, "max": 60}

var drugs = [heroin, apache, opium, cocaine, crack, meth, weed, ecstasy, acid, shrooms, hashish, benzos, peyote, speed, ludes]
var disabled = []
var owned = []
var gunlist = [pistol, revolver, rifle, shotgun]

const expensive = ["Cops made a big %s bust! Prices are outrageous!", "Addicts are buying %s at ridiculous prices!"]

const pistol = ["Pistol", 3500, 2]
const revolver = ["Revolver", 6500, 4]
const rifle = ["Rifle", 10000, 7]
const shotgun = ["Shotgun", 12000, 9]

var jackass = {"name": "Officer Jackass", "aim": 8, "hp": 100, "bounty": 15000, "alive": true}
var kavass = {"name": "Officer Kavass", "aim": 12, "hp": 175, "bounty": 40000, "alive": true}
var hardass = {"name": "Officer Hardass", "aim": 16, "hp": 300, "bounty": 100000, "alive": true}
#avg damage needed to kill all is approximately 32

var saved = {
	"day": day, 
	"space": space, 
	"cash": cash, 
	"debt": debt, 
	"guns": guns, 
	"damage": damage, 
	"health": health, 
	"vigorish": vigorish, 
	"length": length, 
	"location": location, 
	"dplist": dplist, 
	"drugs": drugs, 
	"owned": owned,
	"market": []}

# Initialises the game data
func init():
	day = 1
	space = 100
	cash = 2000
	debt = 5500
	guns = 0
	damage = 0
	health = 100
	vigorish = 1.1
	length = 30
	location = bronx

	heroin = {"owned": 0, "name": "Heroin", "cheap": null, "expensive": null, "min": 60000, "max": 155000}
	apache = {"owned": 0, "name": "Apache", "cheap": null, "expensive": true, "min": 30500, "max": 60000}
	opium = {"owned": 0, "name": "Opium", "cheap": null, "expensive": null, "min": 15000, "max": 50000}
	cocaine = {"owned": 0, "name": "Coke", "cheap": "Rivals are competing to sell Coke!", "expensive": null, "min": 25000, "max": 45000}
	crack =  {"owned": 0, "name": "Crack", "cheap": null, "expensive": null, "min": 10000, "max": 35000}
	meth = {"owned": 0, "name": "Meth", "cheap": null, "expensive": true, "min": 13000, "max": 32000}
	weed = {"owned": 0, "name": "Weed", "cheap": "Columbian freighter dusted the Coast Guard! Weed prices have bottomed out!", "expensive": null, "min": 5000, "max": 18000}
	ecstasy = {"owned": 0, "name": "Ecstasy", "cheap": null, "expensive": null, "min": 2300, "max": 7000}
	acid = {"owned": 0, "name": "Acid", "cheap": "The market is flooded with cheap home-made acid!", "expensive": null, "min": 1500, "max": 4500}
	shrooms = {"owned": 0, "name": "Shrooms", "cheap": null, "expensive": true, "min": 800, "max": 2100}
	hashish = {"owned": 0, "name": "Hash", "cheap": "The Marrakesh Express has arrived!", "expensive": null, "min": 480, "max": 1280}
	benzos = {"owned": 0, "name": "Benzos",  "cheap": null, "expensive": null, "min": 220, "max": 1200}
	peyote = {"owned": 0, "name": "Peyote", "cheap": null, "expensive": true, "min": 150, "max": 850}
	speed = {"owned": 0, "name": "Speed", "cheap": null, "expensive": true, "min": 70, "max": 400}
	ludes = {"owned": 0, "name": "Ludes", "cheap": "Rival drug dealers raided a pharmacy and are selling cheap ludes!", "expensive": null, "min": 10, "max": 60}

	disabled = []
	owned = []

# Function to add drugs
func add_drug(d, _dp, r, id):
	var slice = (d["max"] - d["min"]) / 4
	var lo = d["min"] + slice
	var hi = d["max"] - slice
	var price = rng.randi_range(d["min"], d["max"])
	var n = rng.randi_range(0, r)
	var low = int(price / 2)
	var high = int(price * 1.5)
	var event = rng.randi_range(0, 9)
	dplist[id] = price
	if n:
		if event == 7:
			if d["cheap"]:
				price = low
				dplist[id] = price
				if price == d["min"]:
					$Info.append_bbcode("[color=#87CEEB]" + d["cheap"] + "[/color]\n")
			elif d["expensive"]:
				price = high
				dplist[id] = price
				if price == d["max"]:
					$Info.append_bbcode("[color=#F08080]" + expensive[rng.randi_range(0, 1)] % d["name"] + "[/color]\n")
		$Market.add_item(d["name"] + ": $" + str(price))
		if priceHelp:
			if price > hi:
				$Market.set_item_custom_fg_color(id, Color(0.7, 0.3, 0, 1)) #reddish
				if price > d["max"]:
					$Market.set_item_custom_fg_color(id, Color(0.7, 0, 0, 1)) #red
			elif price < lo:
				$Market.set_item_custom_fg_color(id, Color(0.5, 0.8, 0, 1)) #greenish
				if price < d["min"]:
					$Market.set_item_custom_fg_color(id, Color(0, 0.9, 0, 1)) #green
			else:
				$Market.set_item_custom_fg_color(id, Color(0.6, 0.6, 0, 1)) #golden
		else:
			$Market.set_item_custom_fg_color(id, Color(0.8, 0.8, 0.8, 1)) #light gray
	else:
		$Market.add_item(d["name"] + ": N/A")
		$Market.set_item_custom_fg_color(id, Color(0.0, 0.0, 0.0, 1)) #black
		if !disabled.has(d["name"]):
			disabled.append(d["name"])
	$Market.set_item_disabled(id, !n)

# Loads Market
func loadMarket():
	rng.randomize()

	match location:
		bronx:
			add_drug(heroin, he, 1, 0) #drug data, drug price, chance of drug being unavailable, drug id
			add_drug(apache, ap, 1, 1)
			add_drug(opium, op, 2, 2)
			add_drug(cocaine, co, 2, 3)
			add_drug(crack, cr, 3, 4)
			add_drug(meth, me, 3, 5)
			add_drug(weed, we, 4, 6)
			add_drug(ecstasy, ec, 4, 7)
			add_drug(acid, ac, 5, 8)
			add_drug(shrooms, sh, 5, 9)
			add_drug(hashish, ha, 6, 10)
			add_drug(benzos, be, 6, 11)
			add_drug(peyote, pe, 7, 12)
			add_drug(speed, sp, 7, 13)
			add_drug(ludes, lu, 8, 14)
		
		ghetto:
			add_drug(heroin, he, 4, 0)
			add_drug(apache, ap, 4, 1)
			add_drug(opium, op, 4, 2)
			add_drug(cocaine, co, 5, 3)
			add_drug(crack, cr, 5, 4)
			add_drug(meth, me, 5, 5)
			add_drug(weed, we, 5, 6)
			add_drug(ecstasy, ec, 5, 7)
			add_drug(acid, ac, 5, 8)
			add_drug(shrooms, sh, 5, 9)
			add_drug(hashish, ha, 5, 10)
			add_drug(benzos, be, 5, 11)
			add_drug(peyote, pe, 6, 12)
			add_drug(speed, sp, 6, 13)
			add_drug(ludes, lu, 6, 14)
		
		central_park:
			add_drug(heroin, he, 4, 0)
			add_drug(apache, ap, 4, 1)
			add_drug(opium, op, 4, 2)
			add_drug(cocaine, co, 5, 3)
			add_drug(crack, cr, 5, 4)
			add_drug(meth, me, 5, 5)
			add_drug(weed, we, 5, 6)
			add_drug(ecstasy, ec, 5, 7)
			add_drug(acid, ac, 5, 8)
			add_drug(shrooms, sh, 5, 9)
			add_drug(hashish, ha, 5, 10)
			add_drug(benzos, be, 5, 11)
			add_drug(peyote, pe, 5, 12)
			add_drug(speed, sp, 6, 13)
			add_drug(ludes, lu, 6, 14)
			
		manhattan:
			add_drug(heroin, he, 4, 0)
			add_drug(apache, ap, 4, 1)
			add_drug(opium, op, 5, 2)
			add_drug(cocaine, co, 5, 3)
			add_drug(crack, cr, 5, 4)
			add_drug(meth, me, 5, 5)
			add_drug(weed, we, 5, 6)
			add_drug(ecstasy, ec, 5, 7)
			add_drug(acid, ac, 5, 8)
			add_drug(shrooms, sh, 5, 9)
			add_drug(hashish, ha, 5, 10)
			add_drug(benzos, be, 5, 11)
			add_drug(peyote, pe, 5, 12)
			add_drug(speed, sp, 6, 13)
			add_drug(ludes, lu, 6, 14)
			
		coney_island:
			add_drug(heroin, he, 4, 0)
			add_drug(apache, ap, 4, 1)
			add_drug(opium, op, 5, 2)
			add_drug(cocaine, co, 5, 3)
			add_drug(crack, cr, 5, 4)
			add_drug(meth, me, 5, 5)
			add_drug(weed, we, 5, 6)
			add_drug(ecstasy, ec, 5, 7)
			add_drug(acid, ac, 5, 8)
			add_drug(shrooms, sh, 5, 9)
			add_drug(hashish, ha, 5, 10)
			add_drug(benzos, be, 5, 11)
			add_drug(peyote, pe, 5, 12)
			add_drug(speed, sp, 5, 13)
			add_drug(ludes, lu, 6, 14)
			
		brooklyn:
			add_drug(heroin, he, 4, 0)
			add_drug(apache, ap, 5, 1)
			add_drug(opium, op, 5, 2)
			add_drug(cocaine, co, 5, 3)
			add_drug(crack, cr, 5, 4)
			add_drug(meth, me, 5, 5)
			add_drug(weed, we, 5, 6)
			add_drug(ecstasy, ec, 5, 7)
			add_drug(acid, ac, 5, 8)
			add_drug(shrooms, sh, 5, 9)
			add_drug(hashish, ha, 5, 10)
			add_drug(benzos, be, 5, 11)
			add_drug(peyote, pe, 5, 12)
			add_drug(speed, sp, 5, 13)
			add_drug(ludes, lu, 6, 14)
			
		queens:
			add_drug(heroin, he, 4, 0)
			add_drug(apache, ap, 5, 1)
			add_drug(opium, op, 5, 2)
			add_drug(cocaine, co, 5, 3)
			add_drug(crack, cr, 5, 4)
			add_drug(meth, me, 5, 5)
			add_drug(weed, we, 5, 6)
			add_drug(ecstasy, ec, 5, 7)
			add_drug(acid, ac, 5, 8)
			add_drug(shrooms, sh, 5, 9)
			add_drug(hashish, ha, 5, 10)
			add_drug(benzos, be, 5, 11)
			add_drug(peyote, pe, 5, 12)
			add_drug(speed, sp, 5, 13)
			add_drug(ludes, lu, 5, 14)
			
		staten_island:
			add_drug(heroin, he, 5, 0)
			add_drug(apache, ap, 5, 1)
			add_drug(opium, op, 5, 2)
			add_drug(cocaine, co, 5, 3)
			add_drug(crack, cr, 5, 4)
			add_drug(meth, me, 5, 5)
			add_drug(weed, we, 5, 6)
			add_drug(ecstasy, ec, 5, 7)
			add_drug(acid, ac, 5, 8)
			add_drug(shrooms, sh, 5, 9)
			add_drug(hashish, ha, 5, 10)
			add_drug(benzos, be, 5, 11)
			add_drug(peyote, pe, 5, 12)
			add_drug(speed, sp, 5, 13)
			add_drug(ludes, lu, 5, 14)

# Loads TravelMenu
func _ready():
	$TravelMenu/LocationList.add_item(bronx["name"])
	$TravelMenu/LocationList.add_item(ghetto["name"])
	$TravelMenu/LocationList.add_item(central_park["name"])
	$TravelMenu/LocationList.add_item(staten_island["name"])
	$TravelMenu/LocationList.add_item(coney_island["name"])
	$TravelMenu/LocationList.add_item(queens["name"])
	$TravelMenu/LocationList.add_item(brooklyn["name"])
	$TravelMenu/LocationList.add_item(manhattan["name"])
	$TravelMenu/LocationList.add_item(shark["name"])
	$TravelMenu/LocationList.add_item(gun_shop["name"])
