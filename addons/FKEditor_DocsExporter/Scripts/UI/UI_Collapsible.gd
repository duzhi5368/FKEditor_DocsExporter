# Created by Freeknight
# 2021/12/10
# 说明：可折叠组件
# @category: UI元素
#--------------------------------------------------------------------------------------------------
tool
class_name Collapsible
extends Node
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
export var text_element_path: = NodePath()
export var collapsible_node_path: = NodePath()
export var should_auto_connect: = true
#--- private variables - order: export > normal var > onready -------------------------------------
onready var _text_element: Control = get_node(text_element_path) 
onready var _collapsible: CanvasItem = get_node(collapsible_node_path)
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
func _ready():
	if _collapsible == null or _text_element == null:
		queue_free()
		return
	
	if should_auto_connect:
		if get_parent() is BaseButton:
			if not get_parent().is_connected("pressed", self, "_on_parent_pressed"):
				get_parent().connect("pressed", self, "_on_parent_pressed")
	
	handle_text()
	if not _collapsible.is_connected("ready", self, "_on_collapsible_ready"):
		_collapsible.connect("ready", self, "_on_collapsible_ready")
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
# 折叠/展开目标节点，并且还会触发文本更改作为附加反馈
func toggle_collapse() -> void:
	_collapsible.visible = not _collapsible.visible
	handle_text()
# ------------------------------------------------------------------------------
# 当元素关闭（折叠）时在文本前加上“+”，当元素可见（展开）时在文本前加上“-”。
func handle_text() -> void:
	var is_open = _collapsible.visible
	if "text" in _text_element:
		var text: String = _text_element.text
		if is_open:
			if text.begins_with("+"):
				text = "-" + text.right(1)
			elif not text.begins_with("-"):
				text = "- " + text
		else:
			if text.begins_with("-"):
				text = "+" + text.right(1)
			elif not text.begins_with("+"):
				text = "+ " + text
		
		_text_element.text = text
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _on_collapsible_ready() -> void:
	handle_text()
# ------------------------------------------------------------------------------
func _on_parent_pressed() -> void:
	toggle_collapse()
### -----------------------------------------------------------------------------------------------
