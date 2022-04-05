# Created by Freeknight
# Date: 2021/12/10
# Desc：单组权重以及组内数据对象，可以保存到硬盘中
# @category: 自定义资源
#--------------------------------------------------------------------------------------------------
tool
class_name CategoryOptionalData
extends Resource
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
# 当变量值发生更变，则发送本消息
signal struct_updated
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------
# 数据权重
# 当该值比较大时，将在 HUGO 右边侧显示更靠下部; 该值较小时，则在边侧更靠上部。
# 注意:当该值为 0 时，则表示不显示，请保证最小值为1.
export var weight: int = 0 setget _set_weight

# 每个 category 分类，都将有一个可点击链接页面包含全部子连接。
# 如果我们需要自动生成的页面也有描述信息，可使用这个描述。
export(String, MULTILINE) var description: String = "" setget _set_description
#--- private variables - order: export > normal var > onready -------------------------------------
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
func _to_string() -> String:
	var as_string = {
		weight = weight,
		description = description
	}
	
	return "%s: %s"%[ get_instance_id(), JSON.print(as_string, " ")]
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _set_weight(value: int) -> void:
	weight = value
	_resource_updated()
# ------------------------------------------------------------------------------
func _set_description(value: String) -> void:
	description = value
	_resource_updated()
# ------------------------------------------------------------------------------
func _resource_updated() -> void:
	ResourceSaver.save(resource_path, self)
	emit_signal("struct_updated")
### -----------------------------------------------------------------------------------------------
