extends Resource
class_name SkillData

enum SKILL_TYPE{
	HEAL,
	ATTACK,
	SPECIAL,
	DEFEND,
	BUFF,
}

enum TARGET_TYPE{
	ALL,
	ALLY_ALL,
	ALLY_SINGLE,
	ENEMY_ALL,
	ENEMY_SINGLE,
	SELF
}


@export_group("Display")
@export var skill_name:String
@export var skill_id:String
@export_multiline var description:String


@export_group("Core")
@export var target_type:TARGET_TYPE
@export var skill_type:SKILL_TYPE
@export var power:int = 1
@export var mp_cost:int = 10
