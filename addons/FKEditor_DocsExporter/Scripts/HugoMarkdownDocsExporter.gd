# Created by Freeknight
# Date: 2022/04/05
# Desc：导出数据为 hugo 支持的 md 格式文件中，你可可以将这个文件放置到 hugo 的 “content” 文件夹下，尽量不要
#		有子目录。另外，如果你使用 @category 标签，可以创建一个子目录（并带有自己的 _index.md 文件），你可以
#		在本插件的配置项中进行 category 的设置
# @category: 基本变量类型
#--------------------------------------------------------------------------------------------------
tool
class_name HugoMarkdownDocsExporter
extends MarkdownDocsExporter

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------
#--- enums ----------------------------------------------------------------------------------------
#--- constants ------------------------------------------------------------------------------------

# HUGO默认主页格式
const HUGO_DEFAULT_FRONT_MATTER = ""\
		+"---  \n"\
		+"title: {title}  \n"\
		+"author: {author}  \n"\
		+"date: {datetime}  \n"\
		+"weight: 1  \n"\
		+"---  \n"  

# HUGO默认category页
const HUGO_CHAPTER_FRONT_MATTER = ""\
		+"---  \n"\
		+"title: {title}  \n"\
		+"author: {author}  \n"\
		+"date: {datetime}  \n"\
		+"weight: {weight}  \n"\
		+"---  \n"  

#--- public variables - order: export > normal var > onready --------------------------------------

# 作者名
var author: String = "FreeKnight"
# 是否开启category页的主体列表项
var should_create_toc_on_category_pages: = true

#--- private variables - order: export > normal var > onready -------------------------------------

var _date: String = ""

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init():
	key_to_use_for_link = "full_path"

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

# 根据 json 文件生成 hugo 依赖的 md 文件
func export_hugo_site_pages(reference_json_path: String, export_path: String) -> void:
	build_category_db(reference_json_path, export_path)
	
	var reference_dict : = get_dictionary_from_file(reference_json_path)
	if reference_dict.has("error"):
		push_error(reference_dict.error)
		return
	for entry in reference_dict.classes:
		_update_links_db(entry, export_path)
	for entry in reference_dict.classes:
		_update_signatures_db(entry)
	for entry in reference_dict.classes:
		_build_and_save_md(entry, export_path)
	_build_root_index(export_path)
	
	# 生成 category 子页面
	for category in _category_db.value:
		var md_filename = "_index.md"
		var md_file_path =  _get_md_filepath(export_path, md_filename, category.to_lower())
		var name = (category as String).replace(category.get_base_dir()+"/", "")
		var md_content: = _get_hugo_front_matter(name, true, _category_db.value[category].weight)
		md_content += "%s  \n"%[_category_db.value[category].description]
		md_content += _get_toc(_category_db.value[category])

		_write_documentation_file(md_content, md_file_path)
	
	print("生成 Hugo 页面完成!")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _build_and_save_md(docs_entry: Dictionary, export_path: String) -> void:
	var category: String = docs_entry.category if docs_entry.has("category") else ""
	_add_to_category_db(category, docs_entry.name, export_path)
	
	var md_filename: = "%s.md" % [docs_entry.name.to_lower()]
	var md_file_path: = _get_md_filepath(export_path, md_filename, category.to_lower())
	
	var md_content: = _get_md_content(docs_entry)
	
	_write_documentation_file(md_content, md_file_path)

# ------------------------------------------------------------------------------
func _build_root_index(export_path: String) -> void:
	if export_path.ends_with("/"):
			export_path = export_path.left(export_path.length()-1)
	
	var root_export_md_filename = "_index.md"
	var root_export_md_path = _get_md_filepath(export_path, root_export_md_filename, "")
	var name = export_path.get_file().capitalize()
	
	var toc_dict = _get_export_full_toc_dict()
	var md_content: = _get_hugo_front_matter(name, true)
	md_content += _get_toc(toc_dict)
	
	_write_documentation_file(md_content, root_export_md_path)

# ------------------------------------------------------------------------------
func _get_md_content(docs_entry: Dictionary) -> String:
	var md_content = _get_hugo_front_matter(docs_entry.name)
	md_content += ._get_md_content(docs_entry)
	
	return md_content

# ------------------------------------------------------------------------------
func _get_hugo_front_matter(title: String, is_category: = false, weight: = 0) -> String:
	var formated_date = _date
	if formated_date == "":
		var datetime: = OS.get_datetime()
		var timezone: String = OS.get_time_zone_info().name
		if timezone.find(":") == -1:
			timezone += ":00"
		formated_date = "{year}-{month}-{day}T{hour}:{minute}:{second}{timezone}".format({
				year = datetime.year,
				month = "%02d" % [datetime.month],
				day = "%02d" % [datetime.day],
				hour = "%02d" % [datetime.hour],
				minute = "%02d" % [datetime.minute],
				second = "%02d" % [datetime.second],
				timezone = timezone,
		})
	
	var front_matter: = ""
	if is_category:
		front_matter = HUGO_CHAPTER_FRONT_MATTER.format({
				author = author,
				datetime = formated_date,
				title = title,
				weight = weight
		})
	else:
		front_matter = HUGO_DEFAULT_FRONT_MATTER.format({
				author = author,
				datetime = formated_date,
				title = title,
		})
	
	return front_matter

# ------------------------------------------------------------------------------
func _get_toc(starting_category: Dictionary, identation = "") -> String:
	var content = ""
	content += _get_link_tree(starting_category, identation)
	
	if starting_category.has("children") and not starting_category.children.empty():
		for category_name in starting_category.children:
			var category: Dictionary = _category_db.value[category_name]
			content += "%s- [%s]({{< ref \"%s\" >}})  \n"%[
					identation, 
					category_name.get_file(), 
					category.full_path
			]
			content += _get_toc(category, identation + "  ")
	
	return content

# ------------------------------------------------------------------------------
func _get_link_tree(dict : Dictionary, identation: = "") -> String:
	var link_tree: = ""
	
	if dict.has("page_titles"):
		for page in dict.page_titles:
			var link_path = links_db[page].full_path
			link_tree += "%s- [%s]({{< ref \"%s\" >}})  \n"%[identation, page, link_path]
	
	return link_tree

# ------------------------------------------------------------------------------
func _add_link_to_keyword(text: String, split_index: int, link: String) -> String:
	var left = text.left(split_index)
	var right = text.right(split_index)
	text = "%s({{< ref \"%s\" >}})%s"%[left, link, right]
	return text

# ------------------------------------------------------------------------------
func _add_link_to_keyword_section(text: String, split_index: int, 
		link: String, hash_link: String, keyword: String = "") -> String:
	var left = text.left(split_index)
	var right = text.right(split_index)
	
	if keyword != "":
		left = left.replace(keyword, hash_link)
	
	text = "%s({{< ref \"%s#%s\" >}})%s"%[left, link, hash_link, right]
	return text

# ------------------------------------------------------------------------------
func _get_property_details_table(property: Dictionary) -> String:
	var table = "| | |  \n"
	table +=    "| - |:-:|  \n"
	
	if property.default_value != null:
		var default_value = property.default_value
		if typeof(default_value) == TYPE_STRING:
			default_value = "\"%s\""%[default_value]
		table += "| _Default_ | ` %s ` |  \n"%[default_value]
	
	if property.setter != "":
		table += "| _Setter_ | %s |  \n"%[property.setter]
	
	if property.getter != "":
		table += "| _Getter_ | %s |  \n"%[property.getter]
	
	table += "\n"
	
	if table == "| | |  \n| - |:-:|  \n\n":
		table = ""
	
	return table

### -----------------------------------------------------------------------------------------------
