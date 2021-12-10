# Created by Freeknight
# 2021/12/04
# 说明：基础 LineEdit
# @category: UI元素
#--------------------------------------------------------------------------------------------------
tool
class_name StringVariableLineEdit
extends LineEdit
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
signal remove_string_variable(string_variable)
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
export var is_removable: = false setget _set_is_removable
#--- private variables - order: export > normal var > onready -------------------------------------
var _string_variable: StringVariable = null
onready var _delete_button: Button = $DeleteButton
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
func set_string_variable(resource: StringVariable) -> void:
	_string_variable = resource
	text = _string_variable.value
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _set_is_removable(value: bool) -> void:
	is_removable = value
	_delete_button.visible = value
# ------------------------------------------------------------------------------
func _update_string_resource(value: String) -> void:
	_string_variable.value = value
# ------------------------------------------------------------------------------
func _on_StringVariableLineEdit_text_changed(new_text: String):
	_update_string_resource(new_text)
# ------------------------------------------------------------------------------
func _on_StringVariableLineEdit_text_entered(new_text: String):
	_update_string_resource(new_text)
# ------------------------------------------------------------------------------
func _on_DeleteButton_pressed():
	emit_signal("remove_string_variable", _string_variable)
### -----------------------------------------------------------------------------------------------
