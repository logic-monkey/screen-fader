extends CanvasLayer
## Simple, bone-easy screen fader. Fades to black, fades in. 

## How long a single fade takes.
@export
var time_to_fade := 0.25

## If the fader is running.
var is_fading := false

func _ready():
	FadeIn()
	
## Emitted when fading out is complete.
signal faded_out
## Emitted when fading in is complete.
signal faded_in

## Call when the screen is black to fade in.
func FadeIn():
	is_fading = true
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "modulate", Color.TRANSPARENT, time_to_fade)\
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	visible = false
	is_fading = false
	emit_signal("faded_in")
	
## Call when the screen is not black to fade to black
func FadeOut():
	is_fading = true
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "modulate", Color.WHITE, time_to_fade)\
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	is_fading = false
	emit_signal("faded_out")

## Emitted when the scene has finished changing.
signal scene_changed
## Call to fade to black, load a scene, then fade back in.
func FadeTo(scene):
	#print("fading to %s" % scene)
	var tree = get_tree()
	if has_node("//root/_IMP"):
		_IMP.mode = _IMP.TRANSITION
	FadeOut()
	await faded_out
	is_fading = true
	await tree.process_frame
	if scene is String:
		tree.change_scene_to_file(scene)
	elif scene is PackedScene:
		tree.change_scene_to_packed(scene)
	else:
		print("Scene switch failed; scene was not path or pack.")
		FadeIn()
		await faded_in
		return
	await tree.process_frame
	emit_signal("scene_changed")
	is_fading = false
	FadeIn()
	await faded_in
	await tree.process_frame
	if has_node("//root/_IMP"):
		_IMP.mode = _IMP.WAITING
	
