extends Node2D
class_name BattleScene

@onready var attack_button: Button = %AttackButton
@onready var defend_button: Button = %DefendButton

@onready var characters: Node = %Characters

@onready var hero: Character = $Characters/Hero
@onready var slime: Character = $Characters/Slime

var current_character: Character
var turn_list:Array[Character] = []

var isPlayerSide: bool = false:
	set(v):
		isPlayerSide = v
		if isPlayerSide:
			attack_button.disabled = false
			defend_button.disabled = false
		else:
			attack_button.disabled = true
			defend_button.disabled = true

func _ready() -> void:
	_round_start()
	
	attack_button.pressed.connect(_attack)
	defend_button.pressed.connect(_defend)

func _next_round() -> void:
	await get_tree().create_timer(1.0).timeout
	print("Next Round")
	print("---------------------------------------------------------------------")
	_round_start()

func _next_turn() -> void:
	current_character = turn_list.pop_front()
	if current_character:
		if current_character.isPlayer:
			if current_character.isAlive:
				isPlayerSide = true
			else:
				print("Lose!")
		else:
			isPlayerSide = false
			if current_character.isAlive:
				await get_tree().create_timer(1.0).timeout
				print("Slime Attacked U!")
				hero._get_hurt(10)
				_next_turn()
			else:
				print("Victory!")
	else:
		_next_round()
	
func _round_start() -> void:
	for i:Character in characters.get_children():
		if i.isAlive:
			turn_list.append(i)
			
	for i:Character in turn_list:
		i._reset_defend_state()
		
	_next_turn()

func _attack() -> void:
	await get_tree().create_timer(1.0).timeout
	print_rich("[color=green][Player][/color] Attack!")
	slime._get_hurt(hero.cd.attack)
	_next_turn()
	
func _defend() -> void:
	await get_tree().create_timer(1.0).timeout
	hero.isDefending = true
	print_rich("Player Defend!")
	_next_turn()
	
	
