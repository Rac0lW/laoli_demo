extends Control
class_name TargetSelectionPanel

@onready var item_list: ItemList = %ItemList
@onready var select_button: Button = %SelectButton
@onready var cancel_button: Button = %CancelButton

var current_targets:Array[Character] = []

var current_index_of_target:int = -1

signal target_selected(t: Character)

func _ready() -> void:
	load_targets()
	
	cancel_button.pressed.connect(func():
		current_index_of_target = -1
		item_list.deselect_all()
		)
	
	select_button.pressed.connect(func():
		target_selected.emit(current_targets[current_index_of_target])
		)
	
func load_targets() -> void:
	var targets = get_tree().get_first_node_in_group("EnemySides").get_children()
	for i:Character in targets:
		current_targets.append(i)
	
	for i:Character in current_targets:
		item_list.add_item("%s" % i.name)


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	current_index_of_target = index
