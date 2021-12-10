# Created by Freeknight
# Date: 2021/12/10
# Desc：CategoryOptionalData的字典，可以保存到硬盘种
# @category: 自定义资源
#--------------------------------------------------------------------------------------------------
tool
class_name CategoryOptionalDataDict
extends Resource
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
# 当变量值发生更变，则发送本消息.
signal value_updated
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
# 仅接受 CategoryOptionalData 为成员值的字典
export var value: Dictionary = {} setget _set_value, _get_value
#--- private variables - order: export > normal var > onready -------------------------------------
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _set_value(p_value: Dictionary) -> void:
	var keys_to_delete = value.keys()
	for key in p_value:
		var category_data: CategoryOptionalData = p_value[key]
		if category_data != null:
			value[key] = category_data
			if not category_data.is_connected("struct_updated", self, "_on_key_struct_updated"):
				category_data.connect("struct_updated", self, "_on_key_struct_updated")
			
			if keys_to_delete.has(key):
				keys_to_delete.erase(key)
	
	if keys_to_delete.size() > 0:
		for key in keys_to_delete:
			value.erase(key)
	
	_save_and_notify()
# ------------------------------------------------------------------------------
func _get_value() -> Dictionary:
	for element in value.keys():
		var category_data: CategoryOptionalData = value[element]
		if not category_data.is_connected("struct_updated", self, "_on_key_struct_updated"):
			category_data.connect("struct_updated", self, "_on_key_struct_updated")
	
	return value
# ------------------------------------------------------------------------------
func _save_and_notify():
	ResourceSaver.save(resource_path, self)
	emit_signal("value_updated")
# ------------------------------------------------------------------------------
func _on_key_struct_updated():
	_save_and_notify()
### -----------------------------------------------------------------------------------------------
