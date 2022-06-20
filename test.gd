extends Node2D


var skeletons_deaths = 0
var skeletons = 8
export var gravity = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if skeletons == skeletons_deaths:
		print("you win")

func _on_skeleton_death():
	skeletons_deaths += 1


func _on_skeleton2_death():
	skeletons_deaths += 1


func _on_skeleton3_death():
	skeletons_deaths += 1


func _on_skeleton4_death():
	skeletons_deaths += 1


func _on_skeleton5_death():
	skeletons_deaths += 1


func _on_skeleton6_death():
	skeletons_deaths += 1


func _on_skeleton7_death():
	skeletons_deaths += 1

func _on_skeleton8_death():
	skeletons_deaths += 1
