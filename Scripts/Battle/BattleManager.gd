extends Node
class_name BattleManager

@onready var attack_button: Button = %AttackButton
@onready var defend_button: Button = %DefendButton


@onready var enemy_sides: Node = %EnemySides
@onready var player_sides: Node = %PlayerSides


@onready var hero: Character = $"../PlayerSides/Hero"
@onready var slime: Character = $"../EnemySides/Slime"

@onready var skill_selection_panel: SkillSelectionPanel = %SkillSelectionPanel
@onready var target_selection_panel: TargetSelectionPanel = %TargetSelectionPanel



@onready var battle_state_manager: BattleStateManager = $BattleStateManager

signal strategy_made

var current_character: Character
var turn_list:Array[Character] = []

var current_skill: SkillData
var current_targets: Array[Character] = []

func _ready() -> void:
	_execute()
	attack_button.pressed.connect(_attack)
	defend_button.pressed.connect(_defend)
	skill_selection_panel.skill_selected.connect(func(sd):
		current_skill = sd
		)
	
	target_selection_panel.target_selected.connect(func(t):
		current_targets.append(t)
		_skill_execute()
		)
	
func _disable_buttons() -> void:
	print("Button Deactived")
	attack_button.disabled = true
	defend_button.disabled = true

func _active_buttons() -> void:
	print("Button Actived")
	attack_button.disabled = false
	defend_button.disabled = false


func _execute() -> void:
	match battle_state_manager.current_state:
		BattleStateManager.BattleStates.IDLE:
			turn_list.clear()
			var player_list:Array[Character]
			for c:Character in player_sides.get_children():
				if c.isAlive:
					player_list.append(c)
					
			if player_list.is_empty():
				battle_state_manager._change_state_to(BattleStateManager.BattleStates.GAMEOVER)
				return
			
			var enemy_list:Array[Character]
			for c:Character in enemy_sides.get_children():
				if c.isAlive:
					enemy_list.append(c)
					
			if enemy_list.is_empty():
				battle_state_manager._change_state_to(BattleStateManager.BattleStates.GAMEVICTORY)
				return
			
			
			turn_list.append_array(player_list)
			turn_list.append_array(enemy_list)
			
			battle_state_manager._change_state_to(BattleStateManager.BattleStates.PLAYERSIDE)
			
		BattleStateManager.BattleStates.PLAYERSIDE:
			var player:Character = turn_list.pop_front()
			_active_buttons()
			await strategy_made
			_disable_buttons()
			await get_tree().create_timer(1.0).timeout
			battle_state_manager._change_state_to(BattleStateManager.BattleStates.ENEMYSIDE)
				
			if turn_list.is_empty():
				battle_state_manager._change_state_to(BattleStateManager.BattleStates.IDLE)
			
			
		BattleStateManager.BattleStates.ENEMYSIDE:
			var enemy:Character = turn_list.pop_front()
			print_rich("%s attack [color=green]%s. [/color]by using the SpikeStrike!" % [enemy.name,hero.name])
			hero._get_hurt(10)
			hero._reset_defend_state()
			if turn_list.is_empty():
				battle_state_manager._change_state_to(BattleStateManager.BattleStates.IDLE)
			
		BattleStateManager.BattleStates.GAMEVICTORY:
			print_rich("[rainbow]Victory")
			battle_state_manager._change_state_to(BattleStateManager.BattleStates.BATTLEEND)
			
		BattleStateManager.BattleStates.GAMEOVER:
			print_rich("[b]Game Over.")
			battle_state_manager._change_state_to(BattleStateManager.BattleStates.BATTLEEND)
			
		_:
			pass



func _attack() -> void:
	slime._get_hurt(20)
	print_rich("%s attack [color=green]%s. [/color]by using the LongSword!" % [hero.name, slime.name])
	strategy_made.emit()
	
func _defend() -> void:
	print_rich("%s defend by using the Shield." % [hero.name])
	hero.isDefending = true
	strategy_made.emit()
	
func _skill_execute() -> void:
	var value:int = 0
	
	if !current_skill:
		print("[Debug]Skill didn't being seleted.")
		return
		
	if current_targets.is_empty():
		print("[Debug]Target didn't being seleted.")
		return
	
	match current_skill.skill_type:
		SkillData.SKILL_TYPE.HEAL:
			value = current_skill.power
			for i:Character in current_targets:
				i._get_heal(value)
		SkillData.SKILL_TYPE.ATTACK:
			value = -current_skill.power
			for i:Character in current_targets:
				i._get_hurt(value)

		_:
			printerr("Unexpected SKILL_TYPE. %s %s" % [current_skill.skill_type, current_skill.SKILL_TYPE])
			
	
	strategy_made.emit()
	
	current_targets.clear()
	current_skill = null
	
	
