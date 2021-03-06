# Created by Freeknight
# 2021/12/10
# 说明：类别名称按钮
# @category: UI元素
#--------------------------------------------------------------------------------------------------
tool
extends Button

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
#--- private variables - order: export > normal var > onready -------------------------------------
onready var _collapsible: Collapsible = $Collapsible
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
func set_category_name(p_text) -> void:
	text = p_text
	_collapsible.handle_text()
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------
