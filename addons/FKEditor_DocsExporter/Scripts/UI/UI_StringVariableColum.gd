# Created by Freeknight
# 2021/12/04
# 说明：需要填充 StringVariable 字段的列
# @category: UI元素
#--------------------------------------------------------------------------------------------------
tool
extends VBoxContainer
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
#--- private variables - order: export > normal var > onready -------------------------------------
var _editor_field_packed_scene: PackedScene = null
var _fields: StringVariableArray = null

onready var _resource_preloader: ResourcePreloader = $ResourcePreloader
onready var _field_container: VBoxContainer = $Fields
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
func _ready():
	_editor_field_packed_scene = _resource_preloader.get_resource("editor_field")
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
# 填充编辑器字段，使其可接受 StringVariable 类型。
func populate_editor_fields(fields: StringVariableArray) -> void:
	_fields = fields
	for row in _field_container.get_children():
		_field_container.remove_child(row)
		row.queue_free()
	
	var row_count: = 0
	for field in fields.value:
		var string_variable = field as StringVariable
		var editor_field = _editor_field_packed_scene.instance()
		_field_container.add_child(editor_field, true)
		
		if editor_field.has_method("set_string_variable"):
			editor_field.set_string_variable(string_variable)
			
			if row_count == 0 and "is_removable" in editor_field:
				editor_field.is_removable = false
			elif "is_removable" in editor_field:
				editor_field.is_removable = true
				editor_field.connect("remove_string_variable", self, 
						"_on_editor_field_remove_string_variable", [self])
		
		row_count += 1
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _on_AddMore_pressed() -> void:
	_fields.push(StringVariable.new())
	populate_editor_fields(_fields)
# ------------------------------------------------------------------------------
func _on_editor_field_remove_string_variable(
		string_variable: StringVariable, 
		field_node: Control
) -> void:
	_fields.erase(string_variable)
	populate_editor_fields(_fields)
### -----------------------------------------------------------------------------------------------
