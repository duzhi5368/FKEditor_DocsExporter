# Created by Freeknight
# Date: 2021/12/04
# Desc： 可编辑对象，修改后直接保存变量到配置文件中
# @category: 基本变量类型
#--------------------------------------------------------------------------------------------------
tool
class_name BoolVariable
extends Resource
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
# 当变量值发生更变，则发送本消息
signal value_updated
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
export var value: bool = true setget _set_value
#--- private variables - order: export > normal var > onready -------------------------------------
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _set_value(p_value: bool) -> void:
	value = p_value
	ResourceSaver.save(resource_path, self)
	emit_signal("value_updated")
### -----------------------------------------------------------------------------------------------