extends Control

var increment = 0
var opening = true

func _ready():
	$UITimer.start()
	await $UITimer.timeout
	var tween = get_tree().create_tween()
	tween.tween_property($GitHubGameOffLogo2, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
	if !opening:
		var tween2 = get_tree().create_tween()
		tween2.tween_property($OpeningIntro/Label, "visible_ratio", 1, 30)
		await tween2.finished
		$UITimer.wait_time = 4.0
		$UITimer.start()
		await $UITimer.timeout
	else:
		$OpeningPlayback/VideoStreamPlayer.play()
		await $OpeningPlayback/VideoStreamPlayer.finished
		$UITimer.wait_time = 1.0
		$UITimer.start()
		await $UITimer.timeout
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		$SkipButton.visible = true
		increment = 1
	else:
		increment = -1
	
func _physics_process(delta):
	var progressBarValue = $SkipButton/ProgressBar.value
	if increment == 1 and progressBarValue <= 100:
		progressBarValue += 50*delta
	elif increment == -1 and progressBarValue >= 0:
		progressBarValue -= 50*delta
	$SkipButton/ProgressBar.value = roundi(progressBarValue)
	
	if progressBarValue >= 100:
		get_tree().change_scene_to_file("res://MainMenu.tscn")
	elif $SkipButton/ProgressBar.value <= 0 and increment == -1 and $SkipButtonTimer.time_left <= 0 and $SkipButton.visible == true:
		$SkipButtonTimer.start()

func _on_skip_button_timer_timeout() -> void:
	if increment == -1:
		$SkipButton.visible = false
