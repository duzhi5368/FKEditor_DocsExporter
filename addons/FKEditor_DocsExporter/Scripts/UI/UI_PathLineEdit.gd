# Created by Freeknight
# Date: 2021/12/10
# Desc：用来接受 文件 或 文件夹 的LineEdit
# @category: UI元素
#--------------------------------------------------------------------------------------------------
tool
class_name PathLineEdit
extends LineEdit
#--------------------------------------------------------------------------------------------------
### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------
#--- public variables - order: export > normal var > onready --------------------------------------
#--- private variables - order: export > normal var > onready -------------------------------------
### -----------------------------------------------------------------------------------------------

### Built in Engine Methods -----------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------

### Public Methods --------------------------------------------------------------------------------
func set_text(string: String) -> void:
	text = string
	var total_chars = text.length()
	caret_position = total_chars-1
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
func _on_FileDialog_file_selected(path):
	set_text(path)
# ------------------------------------------------------------------------------
func _on_FileDialog_dir_selected(dir):
	set_text(dir)
### -----------------------------------------------------------------------------------------------

