extends Node

var minutes_total := 840          # total in-game minutes since start
var hour := 14                  # 0..23
var minute := 0               # 0..59

const REAL_SECONDS_PER_GAME_MINUTE := .025

var _accumulator := 0.0

func _process(delta: float) -> void:
	_accumulator += delta

	while _accumulator >= REAL_SECONDS_PER_GAME_MINUTE:
		_accumulator -= REAL_SECONDS_PER_GAME_MINUTE
		_add_minute()
		print("In-game time: ", hour, "hours, ", minute," minutes")

func _add_minute() -> void:
	minutes_total += 1
	hour = (minutes_total / 60) % 24
	minute = minutes_total % 60
