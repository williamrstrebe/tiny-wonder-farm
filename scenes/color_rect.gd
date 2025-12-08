extends ColorRect


# Hour-based gradient stops (24h clock, minutes included)
const GRADIENT := [
	{ "time":  4*60,  "color": Color("#000000") },
	{ "time":  5*60,  "color": Color("#1f3c88") },
	{ "time":  6*60,  "color": Color("#ff8c33") },
	{ "time":  8*60,  "color": Color("#ffd966") },
	{ "time": 10*60,  "color": Color.WHITE },
	{ "time": 14*60,  "color": Color.WHITE },
	{ "time": 16*60,  "color": Color("#ffd966") },
	{ "time": 18*60,  "color": Color("#ff8c33") },
	{ "time": 20*60,  "color": Color("#1f3c88") },
	{ "time": 22*60,  "color": Color("#000000") },
	{ "time": 28*60,  "color": Color("#000000") } # 04:00 next day = 24*60 + 240
]

@export_range(0,1,0.01)
var target_opacity := 0.5
@export var opacity := 0.25
@export var hours: int
@export var minute: int

func _ready() -> void:
	hours = 12
	minute = 0

func _process(_delta):
	update_overlay(hours, minute)

func update_overlay(h:int, m:int):
	var t := h * 60 + m
	if t < 4*60:
		t += 24*60

	var col := get_time_color(t)
	col.a = get_time_opacity(t)
	color = col


func get_time_opacity(minutes:int) -> float:
	const HOUR := 60

	# FULL TRANSPARENT
	if minutes >= 10*HOUR and minutes <= 14*HOUR:
		return 0.0

	# FADE OUT 05 -> 10
	if minutes >= 5*HOUR and minutes < 10*HOUR:
		return lerp(target_opacity, 0.0, float(minutes - 5*HOUR) / (5*HOUR))

	# FADE IN 14 -> 19
	if minutes > 14*HOUR and minutes <= 19*HOUR:
		return lerp(0.0, target_opacity, float(minutes - 14*HOUR) / (5*HOUR))

	# FULL DARK
	return target_opacity


func get_time_color(minutes:int) -> Color:
	for i in range(GRADIENT.size() - 1):
		var a = GRADIENT[i]
		var b = GRADIENT[i + 1]

		if minutes >= a.time and minutes <= b.time:
			var t = inverse_lerp(a.time, b.time, minutes)
			return a.color.lerp(b.color, t)

	return Color.BLACK
