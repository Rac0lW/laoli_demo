extends Control
class_name SkillSelectionPanel

@onready var skill_list: ItemList = %SkillList
@onready var description: RichTextLabel = %Description
@onready var skill_select_button: Button = %Release
@onready var skill_cancel_button: Button = %Cancel


signal skill_selected(skill_data: SkillData)

var current_skills:Array[SkillData] = []
var current_index_of_skill:int = -1

func _ready() -> void:
	load_some_skills_from_player()
	
	skill_select_button.pressed.connect(func():
		if current_index_of_skill == -1:
			return
		var selected_skill:SkillData = current_skills[current_index_of_skill]
		skill_selected.emit(selected_skill)
		print("[Debug] %s selected." % selected_skill.skill_name)
		)
	
	skill_cancel_button.pressed.connect(func():
		skill_list.deselect_all()
		description.text = "Plz select a skill."
		current_index_of_skill = -1
		)
	
func load_some_skills_from_player() -> void:
	var player:Character = get_tree().get_first_node_in_group("Player")
	for i in player.cd.skills:
		current_skills.append(i)
		
	for i in current_skills:
		skill_list.add_item("%s" % i.skill_name)
		

func _on_skill_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	description.text = "%s" % current_skills[index].description
	current_index_of_skill = index
	
