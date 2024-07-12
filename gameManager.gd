extends Node
@onready var points_label = %PointsLabel
@onready var time_label = %TimeLabel
@onready var jumps_label = %JumpsLabel
@onready var bumps_label = %BumpsLabel
@onready var percentage_label = %PercentageLabel
@onready var start_position = %startPosition
@onready var end_position = %endPosition
@onready var player = %player


var points = 0
var jumps = 0
var bumps = 0
var time = 0.0
var total_distance = 0

func _ready():
	total_distance = start_position.global_position.distance_to(end_position.global_position)

func _physics_process(delta):
	time = float(time) + delta
	update_time()
	update_percentage()

func add_point():
	points += 1
	points_label.text = "Collectables: " + str(points) + "/ 5" 

func add_jumps():
	jumps += 1
	jumps_label.text = "Jumps: " + str(jumps)

func add_bumps():
	bumps += 1
	bumps_label.text = "Bumps: " + str(bumps)

func update_time():
	var sec = int(time) % 60
	var min = int(time) / 60
	var hour = int(time) / 3600
	time_label.text = "Time: " + str(hour) + ":" + str(min) + ":" + str(sec)

func update_percentage():
	var current_distance = start_position.global_position.distance_to(player.global_position)
	var progress = (current_distance / total_distance) * 100
	progress = clamp(progress, 0, 100)
	percentage_label.text = "Percentage: " + str("%.2f" % float(progress)) + "%"
