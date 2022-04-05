# Created by Freeknight
# Date: 2021/12/08
# Desc：从GDScript中查找代码引用
# @category: Category Unknown
#--------------------------------------------------------------------------------------------------
tool
extends SceneTree
#--------------------------------------------------------------------------------------------------
# 返回工作目录下的文件路径列表
# **Arguments**
#
# - dirpath: 需要查询的根目录
# - patterns: 一个字符串匹配数组。其中"*" 表示0至无穷个字符，"?"可表示除'.'外的单个字符
#   例如，仅查找 GDScript 文件可传入 ["*.gd"]
# - is_recursive: 是否遍历子目录
func find_files(
	dirpath := "", patterns := PoolStringArray(), is_recursive := false, do_skip_hidden := true
) -> PoolStringArray:
	var file_paths := PoolStringArray()
	var directory := Directory.new()

	if not directory.dir_exists(dirpath):
		printerr("文件夹不存在 %s" % dirpath)
		return file_paths
	if not directory.open(dirpath) == OK:
		printerr("无法打开指定指定目录，可能权限不足: %s" % dirpath)
		return file_paths

	directory.list_dir_begin(true, do_skip_hidden)
	var file_name := directory.get_next()
	var subdirectories := PoolStringArray()
	while file_name != "":
		if directory.current_is_dir() and is_recursive:
			var subdirectory := dirpath.plus_file(file_name)
			file_paths.append_array(find_files(subdirectory, patterns, is_recursive))
		else:
			for pattern in patterns:
				if file_name.match(pattern):
					file_paths.append(dirpath.plus_file(file_name))
		file_name = directory.get_next()

	directory.list_dir_end()
	return file_paths
# ------------------------------------------------------------------------------
# 保存数据到文件中
func save_text(path := "", content := "") -> void:
	var dirpath := path.get_base_dir()
	var basename := path.get_file()
	if not dirpath:
		printerr("保存失败，文件夹 %s 不存在" % path)
		return
	if not basename.is_valid_filename():
		printerr("保存失败,文件名 %s 包含非法字符" % basename)
		return

	var directory := Directory.new()
	if not directory.dir_exists(dirpath):
		directory.make_dir(dirpath)

	var file := File.new()

	file.open(path, File.WRITE)
	file.store_string(content)
	file.close()
	print("Saved data to %s" % path)
# ------------------------------------------------------------------------------
# 解析文件列表，并返回字符串匹配的数据字典
# 如果 `refresh_cache` 为 true, 则刷新 godot 缓存.
func get_reference(files := PoolStringArray(), refresh_cache := false) -> Dictionary:
	var data := {
		name = ProjectSettings.get_setting("application/config/name"),
		description = ProjectSettings.get_setting("application/config/description"),
		# version = ProjectSettings.get_setting("application/config/version"),
		classes = []
	}
	var workspace = Engine.get_singleton('GDScriptLanguageProtocol').get_workspace()
	for file in files:
		if not file.ends_with(".gd"):
			continue
		if refresh_cache:
			#print("can't support refresh cache.")
			# workspace.parse_local_script(file)
			pass
		var symbols: Dictionary = workspace.generate_script_api(file)
		data["classes"].append(symbols)
	return data
# ------------------------------------------------------------------------------
# 以JSON格式输出字典，并给与合适的缩进
func print_pretty_json(reference: Dictionary) -> String:
	return JSON.print(reference, "  ")
# ------------------------------------------------------------------------------
