# Created by Freeknight
# Date: XXXX/XX/XX
# Desc：
# @category: 插件入口
#-------------------------------------------------
tool
extends EditorPlugin
#-------------------------------------------------
const DOCS_EXPORTER_TAB = "./UI/DocsExporterProjectSettingsTab.tscn"
#-------------------------------------------------
var docs_exporter_tab: Control
#-------------------------------------------------
func _enter_tree():
	_create_shared_db("./Aseets/Themes/dict_custom_class_db.tres")
	_create_shared_db("./Aseets/Themes/dict_custom_inheritance_db.tres")
	_create_shared_db("./Aseets/Themes/dict_category_db.tres")
	
	docs_exporter_tab = load(DOCS_EXPORTER_TAB).instance()
	add_control_to_container(
			EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_RIGHT, 
			docs_exporter_tab
	)
#-------------------------------------------------
func _exit_tree():
	remove_control_from_container(
			EditorPlugin.CONTAINER_PROJECT_SETTING_TAB_RIGHT, 
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
