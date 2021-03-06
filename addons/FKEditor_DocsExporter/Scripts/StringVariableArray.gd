# Created by Freeknight
# Date: 2021/12/08
# Desc：可编辑对象，修改后直接保存变量到配置文件中
# @category: 基本变量类型
#--------------------------------------------------------------------------------------------------
tool
class_name StringVariableArray
extends Resource
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
# 当变量值发生更变，则发送本消息
signal value_updated
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
export(Array, Resource) var value: Array = [] setget _set_value, _get_value
#--- private variables - order: export > normal var > onready -------------------------------------
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
func push(element) -> void:
	var string_variable: StringVariable = null
	if element == null or not (element is String or element is StringVariable):
		push_error("StringVariableArray only accepts StringVariables as elements")
		return
	
	if element is String:
		string_variable = StringVariable.new()
		string_variable.value = element
	elif element is StringVariable:
		string_variable = element
	
	if not string_variable.is_connected("value_updated", self, "_on_array_element_updated"):
		string_variable.connect("value_updated", self, "_on_array_element_updated")
	
	value.push_back(string_variable)
	
	_save()
# ------------------------------------------------------------------------------
func erase(element: StringVariable) -> void:
	if value.has(element):
		value.erase(element)
	
	_save()
# ------------------------------------------------------------------------------
func get_string_array() -> Array:
	var array: = []
	for string_variable in value:
		array.push_back(string_variable.value)
	return array
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _set_value(p_value) -> void:
	var old_array: =  value.duplicate()
	value.clear()
	if p_value is Array:
		for idx in range(old_array.size()-1, -1, -1):
			var element = old_array[idx]
			if p_value.has(element):
				var index = p_value.find(element)
				p_value.remove(index)
			else:
				old_array.remove(idx)
		
		value = old_array.duplicate()
		old_array.clear()
		
		for element in p_value:
			if element is StringVariable or element is String:
				push(element)
	
	_save()
# ------------------------------------------------------------------------------
func _get_value() -> Array:
	for element in value:
		var string_variable: StringVariable = element
		if not string_variable.is_connected("value_updated", self, "_on_array_element_updated"):
			string_variable.connect("value_updated", self, "_on_array_element_updated")
	
	return value
# ------------------------------------------------------------------------------
func _save() -> void:
	ResourceSaver.save(resource_path, self)
	emit_signal("value_updated")
# ------------------------------------------------------------------------------
func _on_array_element_updated() -> void:
	ResourceSaver.save(resource_path, self)
	emit_signal("value_updated")
### -----------------------------------------------------------------------------------------------
