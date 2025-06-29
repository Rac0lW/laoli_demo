extends Node2D
class_name Character

@export var cd:CharacterData

@onready var name_label: RichTextLabel = %NameLabel
@onready var health_label: RichTextLabel = %HealthLabel

@onready var isAlive:bool = true
@onready var isPlayer:bool = true

var isDefending:bool = false:
	set(v):
		isDefending = v
		if isDefending:
			_show_shield()
		else:
			_hide_shield()
			

		
@onready var shield: Sprite2D = $Shield

@onready var icon: Sprite2D = $Icon

@onready var damage_taken_label: AnimatedDamageTakenLabel = $DamageTakenLabel


func _show_shield() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(shield, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)
	
func _hide_shield() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(shield, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.3)

func _ready() -> void:
	_update()


func _update() -> void:
	#Core
	if cd.character_type == CharacterData.CHARACTER_TYPE.PLAYER:
		isPlayer = true
	else:
		isPlayer = false
	
	#Engine
	name = cd.display_name
	
	#Display
	name_label.text = "%s" % cd.display_name
	health_label.text = "Health: %s" % str(cd.health)

func _get_hurt(v: int) -> void:
	if isAlive:
		if isDefending:
			v = v / 2
			
		cd.health -= v
		
		_update()
		print_rich("[color=Green][%s][/color] has taken [color=red]%d[/color] damage." % [name, v])
		
		_get_hurt_animation(v)
		
		if cd.health <= 0:
			isAlive = false
			print_rich("[color=Green][%s][/color] has dead" % name)
			_die()

func _get_hurt_animation(v: int = 0) -> void:
	damage_taken_label.text = "[color=red] %s" % str(v)
	damage_taken_label._bounce_once()
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(icon, "scale", Vector2(1.1, 1.1), 0.1)
	tween.chain().tween_property(icon, "modulate", Color(1.0, 0.7 ,0.7), 0.1)
	tween.tween_property(icon, "scale", Vector2(1.0, 1.0), 0.1)
	tween.chain().tween_property(icon, "modulate", Color(1.0, 1.0 ,1.0), 0.1)


func _die() -> void:
	icon.modulate = Color(0.7, 0.0, 0.0)
	
func _reset_defend_state() -> void:
	isDefending = false
	print_rich("[color=Green][%s][/color] has reset the defend state." % name)
