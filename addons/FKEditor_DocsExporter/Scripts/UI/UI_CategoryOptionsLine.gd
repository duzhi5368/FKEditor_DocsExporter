# Created by Freeknight
# 2021/12/10
# 说明：文件导出参数，可以指定Hugo导出权重和描述信息
# @category: UI元素
#--------------------------------------------------------------------------------------------------
tool
class_name CategoryOptions
extends VBoxContainer
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
#--- private variables - order: export > normal var > onready -------------------------------------
onready var _data: CategoryOptionalData
onready var _category_name: Button = $CategoryName
onready var _weight_spin_box: SpinBox = $OptionsContent/MainColumn/WeightLine/SpinBox
onready var _description_text: TextEdit = $OptionsContent/MainColumn/DescriptionContent/ResizableTextEdit
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
func populate_category_entry(p_name: String, p_data: CategoryOptionalData) -> void:
	name = "%sOptions"%[p_name]
	_category_name.set_category_name(p_name)
	_data = p_data
	_weight_spin_box.value = _data.weight
	_description_text.text = _data.description
	
	_weight_spin_box.connect("value_changed", self, "_on_weight_spin_box_value_changed")
	_description_text.connect("text_changed", self, "_on_description_text_text_changed")
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _on_weight_spin_box_value_changed(value):
	_data.weight = value
# ------------------------------------------------------------------------------
func _on_description_text_text_changed():
	_data.description = _description_text.text
### -----------------------------------------------------------------------------------------------
