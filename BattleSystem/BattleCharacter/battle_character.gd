class_name BattleCharacter
extends Node2D


@export var character_name: String = "Name Example"

@export var max_hp: int = 100

var current_hp: int = 100:
	set(value):
		current_hp = clamp(value, 0, max_hp)
		if current_hp == 0:
			print(character_name + " is dead")
			is_dead = true

var is_dead: bool = false

@export var initiative: int = 10
@export var damage: int = 10
@export var defense: int = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Я %s!" % character_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage(amount):
	current_hp -= amount - defense
	print(character_name + " ОЗ: " + str(current_hp))
