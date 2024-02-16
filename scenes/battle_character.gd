extends Area2D

var stat_display

@onready var mouse_area = $"/root/Battle/MouseArea"

signal mouse_exit

func init(disp):
	stat_display = disp

func _on_area_entered(area):
	if area == mouse_area:
		stat_display.start_hover()
		await mouse_exit
		stat_display.stop_hover()

func _on_area_exited(area):
	if area == mouse_area:
		emit_signal("mouse_exit")
