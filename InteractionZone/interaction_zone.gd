class_name InteractionZone
extends Area2D


@export var zone_name: String = "Взаимодействие"

var player_in_zone: bool = false
var in_interaction: bool = false
var player: Player

@onready var label: Label = $Label


func _ready() -> void:
	label.text = zone_name


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interaction") and player_in_zone and not in_interaction:
		interaction()


func _on_body_entered(body: Player) -> void:
	player = body
	player_in_zone = true
	label.show()
	print("Player IN")


func _on_body_exited(body: Player) -> void:
	player_in_zone = false
	label.hide()
	label.text = zone_name
	print("Player OUT")


func interaction():
	pass
