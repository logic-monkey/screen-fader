extends CanvasLayer
## Simple, bone-easy screen fader. Fades to black, fades in. 

@export
var time_to_fade := 0.25

func _ready():
	FadeIn()
	
signal faded_out
signal faded_in

## Call when the screen is black to fade in.
func FadeIn():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "modulate", Color.TRANSPARENT, time_to_fade)\
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	visible = false
	emit_signal("faded_in")
	
## Call when the screen is not black to fade to black
func FadeOut():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "modulate", Color.TRANSPARENT, time_to_fade)\
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	emit_signal("faded_out")

## The scene has finished changing.
signal scene_changed
## Call to fade to black, load a scene, then fade back in.
func FadeTo(scene):
	var tree = get_tree()
	# IMP Mode
	FadeOut()
	await faded_out
	tree.change_scene_to_file(scene)
	await tree.process_frame
	emit_signal("scene_changed")
	FadeIn()
	await faded_in
	# IMP Mode
	
