# Screen Fader
Simple fader to go from screen to screen in Godot 4.

Enabling the addon adds `_FADE` to your autoloads. Call `_FADE.FadeOut()` to fade to black and `_FADE.FadeIn()` to fade back in again. Call `_FADE.FadeTo()` with the filename of a scene to fade out, unload the current scene, load the scene you have indicated, and fade back in. When the scene is loaded, it emits `_FADE.scene_changed`, and when it finishes fading in it emits `_FADE.faded_in`. 

This is the most straightforward, uncomplicated scene transition system imaginable. Fancier transitions may be added later.