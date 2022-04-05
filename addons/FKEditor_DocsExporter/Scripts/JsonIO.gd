# Created by Freeknight
# Date: 2021/12/04
# Desc：JSON格式读写辅助类
# @category: 辅助类
#--------------------------------------------------------------------------------------------------
class_name JsonIO
extends Reference
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
# 当读取文件失败时，向Godot调试器种添加错误信息
func push_reading_file_error(error, p_file_path) -> String:
	var msg: = "加载文件 %s 时出错: %s" % [p_file_path, error]
	push_error(msg)
	assert(false)
	return msg
# ------------------------------------------------------------------------------
# 当解析文件失败时，向Godot调试器种添加错误信息
func push_parsing_file_error(error, p_file_path) -> String:
	var msg: = "解析文件 %s 时出错: %s" % [p_file_path, error]
	push_error(msg)
	assert(false)
	return msg
# ------------------------------------------------------------------------------
# 读取JSON文件，返回解析后的字典数据
func get_dictionary_from_file(p_file_path) -> Dictionary:
	var dictionary: = {}
	var string_content: String = ""
	
	var file := File.new()
	var error = file.open(p_file_path, File.READ)
	if error != OK:
		dictionary["error"] = push_reading_file_error(error, p_file_path)
	else:
		string_content = file.get_as_text()
		file.close()
		
		var parsed_json : = JSON.parse(string_content)
		if parsed_json.error != OK:
			dictionary["error"] = push_parsing_file_error(error, p_file_path)
		else:
			dictionary = parsed_json.result
	
	return dictionary
# ------------------------------------------------------------------------------
# 保存字典数据到json格式文件
func write_dictionary_to_file(content: Dictionary, p_file_path: String) -> void:
	var formatted_file := File.new()
	var error = formatted_file.open(p_file_path, File.WRITE)
	if error != OK:
		push_reading_file_error(error, p_file_path)
		return
	formatted_file.store_string(JSON.print(content, "  "))
	formatted_file.close()
	print("保存json格式文件到: %s"%[p_file_path])
### -----------------------------------------------------------------------------------------------

### Private Methods -------------------------------------------------------------------------------
### -----------------------------------------------------------------------------------------------
