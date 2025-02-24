@tool
extends EditorPlugin

#-------------------------------------------------------------------------------

func _print(message: String) -> void:
	if OS.has_feature("editor"):
		print_rich("🧩 [u]", _get_plugin_name(), "[/u]: ", message)

func _get_plugin_name() -> String:
	return "XDUT Big Integer"

func _enter_tree() -> void:
	_print("Activated.")
