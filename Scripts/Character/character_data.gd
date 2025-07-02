extends Resource
class_name CharacterData

enum CHARACTER_TYPE{
	PLAYER,
	ENEMY,
	OTHER
}

@export_group("Display")
@export var display_name:String

@export_group("Core")
@export var health:int = 100
@export var speed:int = 10
@export var attack:int = 20
@export var character_type:CHARACTER_TYPE = CHARACTER_TYPE.OTHER

@export_group("Skills")
@export var skills:Array[SkillData]
