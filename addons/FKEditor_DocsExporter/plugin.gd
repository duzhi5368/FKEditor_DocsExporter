# Created by Freeknight
# Date: 2021/12/10
# Desc：
# @category: 插件入口
#-------------------------------------------------
tool
extends EditorPlugin
#-------------------------------------------------
const DOCS_EXPORTER_TAB = "res://addons/FKEditor_DocsExporter/UI/DocsExporterProjectSettingsTab.tscn"
#-------------------------------------------------
# Docs exporter 标签页
var docs_exporter_tab: Control
#-------------------------------------------------
func _enter_tree():
	_create_shared_db("res://addons/FKEditor_DocsExporter/Assets/Themes/dict_custom_class_db.tres")
	_create_shared_db("res://addons/FKEditor_DocsExporter/Assets/Themes/dict_custom_inheritance_db.tres")
	_create_shared_db("res://addons/FKEditor_DocsExporter/Assets/Themes/dict_category_db.tres")
	
	docs_exporter_tab = load(DOCS_EXPORTER_TAB).instance()
	add_control_to_container(
			EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_LEFT, 
			docs_exporter_tab
	)
#-------------------------------------------------
func _exit_tree():
	if docs_exporter_tab == null:
		print("docs_exporter_tab is null")
	else:
		remove_control_from_container(
			EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_LEFT, 
			docs_exporter_tab
		)
		docs_exporter_tab.free()
	pass
#-------------------------------------------------
func _create_shared_db(path: String) -> void:
	var dict_variable: DictionaryVariable = DictionaryVariable.new()
	if not ResourceLoader.exists(path):
		ResourceSaver.save(path, dict_variable)
#-------------------------------------------------
