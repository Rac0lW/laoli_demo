extends Sprite2D
class_name Player

@export var stats: CharacterData

@onready var health: RichTextLabel = $Health
@onready var player_name: RichTextLabel = $PlayerName


func _ready() -> void:
	name = stats.display_name
	
