extends Node
class_name BattleStateManager

enum BattleStates{
	IDLE,
	PLAYERSIDE,
	ENEMYSIDE,
	GAMEVICTORY,
	GAMEOVER,
	BATTLEEND,
}

@onready var current_state:BattleStates = BattleStates.IDLE
@onready var battle_manager:BattleManager

func _ready() -> void:
	battle_manager = get_parent()
	if battle_manager == null:
		printerr("This node need to be a child of BattleManager.")

func _change_state_to(s: BattleStates) -> void:
	current_state = s
	print_rich("[color=blue][State][color=green]State changed to [color=red] %s" % _display_state(s))
	if current_state != BattleStates.BATTLEEND:
		battle_manager._execute()

func _display_state(s: BattleStates) -> String:
	match s:
		BattleStates.IDLE:
			return "IDLE"
		BattleStates.PLAYERSIDE:
			return "PLAYERSIDE"
		BattleStates.ENEMYSIDE:
			return "ENEMYSIDE"
		BattleStates.GAMEVICTORY:
			return "GAMEVICTORY"
		BattleStates.GAMEOVER:
			return "GAMEOVER"
		BattleStates.BATTLEEND:
			return "BATTLEEND"
		_:
			return ""
