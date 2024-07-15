extends Node
@onready var points_label = %PointsLabel
@onready var time_label = %TimeLabel
@onready var jumps_label = %JumpsLabel
@onready var bumps_label = %BumpsLabel
@onready var percentage_label = %PercentageLabel
@onready var waypoints = [%checkpoint2, %checkpoint3, %checkpoint4
, %checkpoint5, %checkpoint6, %checkpoint7, %checkpoint8, %checkpoint9, %checkpoint10, %checkpoint11, %checkpoint12
, %checkpoint13, %checkpoint14, %checkpoint15, %checkpoint16, %checkpoint17, %checkpoint18, %checkpoint19, %checkpoint20]
@onready var player = %player
@onready var start_position = %start_position
@onready var end_position = %end_position



var points = 0
var jumps = 0
var bumps = 0
var time = 0.0
var total_distance = 0

func _ready():
	calculate_total_distance()

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
	var mins = int(time) / 60
	var hour = int(time) / 3600
	time_label.text = "Time: " + str(hour) + ":" + str(mins) + ":" + str(sec)

func calculate_total_distance():
	total_distance = 0
	var previous_position = start_position.global_position
	for waypoint in waypoints:
		total_distance += previous_position.distance_to(waypoint.global_position)
		previous_position = waypoint.global_position
	total_distance += previous_position.distance_to(end_position.global_position)

func update_percentage():
	var current_distance = calculate_current_distance()
	var progress = (current_distance / total_distance) * 100
	progress = clamp(progress, 0, 100)
	percentage_label.text = "Percentage: " + str("%.2f" % float(progress)) + "%"

func calculate_current_distance():
	var current_distance = 0
	var previous_position = start_position.global_position

	for waypoint in waypoints:
		if player.global_position.distance_to(previous_position) < waypoint.global_position.distance_to(previous_position):
			current_distance += previous_position.distance_to(player.global_position)
			return current_distance
		else:
			current_distance += previous_position.distance_to(waypoint.global_position)
			previous_position = waypoint.global_position

	current_distance += previous_position.distance_to(player.global_position)
	return current_distance
