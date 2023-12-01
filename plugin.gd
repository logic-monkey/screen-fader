@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("_FADE", "res://addons/screen-fader/fader.tscn")


func _exit_tree():
	remove_autoload_singleton("_FADE")
