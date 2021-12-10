# Created by Freeknight
# Date: 2021/12/08
# Desc：PathLineEdit类的基类。它负责数据持久化以及和其他模块数据共享。
# @category: UI元素
#--------------------------------------------------------------------------------------------------
tool
class_name FilePathLineEdit
extends HBoxContainer
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
signal remove_string_variable(string_variable)
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
# 文件浏览器Filter
export var file_dialog_filter: = ""
# 开启/关闭 删除字段按钮
export var is_removable: = false setget _set_is_removable
#--- private variables - order: export > normal var > onready -------------------------------------
var _path_variable: StringVariable = null

onready var _line_edit: LineEdit = $PathLineEdit
onready var _file_dialog: FileDialog = $FileExplorerButton/FileDialog
onready var _delete_button: Button = $DeleteButton
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
func _ready() -> void:
	if file_dialog_filter != "":
		_file_dialog.add_filter(file_dialog_filter)
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
# 设置 StringVariable 到 LineEdit 中
func set_string_variable(resource: StringVariable) -> void:
	_path_variable = resource
	_line_edit.set_text(_path_variable.value)
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _set_is_removable(value: bool) -> void:
	is_removable = value
	_delete_button.visible = value
# ------------------------------------------------------------------------------
func _update_path_variable(path: String) -> void:
	_path_variable.value = path
# ------------------------------------------------------------------------------
func _on_LineEdit_text_changed(new_text: String) -> void:
	_update_path_variable(new_text)
# ------------------------------------------------------------------------------
func _on_LineEdit_text_entered(new_text: String) -> void:
	_update_path_variable(new_text)
# ------------------------------------------------------------------------------
func _on_FileDialog_dir_selected(dir: String) -> void:
	_update_path_variable(dir)
# ------------------------------------------------------------------------------
func _on_FileDialog_file_selected(path: String) -> void:
	_update_path_variable(path)
# ------------------------------------------------------------------------------
func _on_DeleteButton_pressed():
	emit_signal("remove_string_variable", _path_variable)
### -----------------------------------------------------------------------------------------------
