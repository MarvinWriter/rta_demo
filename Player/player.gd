extends CharacterBody2D


enum State {IDLE, WALK, RUN}

const SPEED = 150.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_state := State.IDLE
var facing_direction: Vector2

var run_multiplier := 1.40

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	direction = direction.normalized()
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			facing_direction = Vector2.RIGHT
		elif direction.x < 0:
			facing_direction = Vector2.LEFT
	elif abs(direction.x) < abs(direction.y):
		if direction.y > 0:
			facing_direction = Vector2.DOWN
		elif direction.y < 0:
			facing_direction = Vector2.UP
	
	state_machine(direction)

	move_and_slide()

func state_machine(direction):
	match current_state:
		State.IDLE:
			if direction:
				current_state = State.WALK
			else:
				match facing_direction:
					Vector2.DOWN:
						animation_player.play("idle_down")
					Vector2.UP:
						animation_player.play("idle_up")
					Vector2.LEFT:
						animation_player.play("idle_left")
					Vector2.RIGHT:
						animation_player.play("idle_right")
				
				velocity.y = move_toward(velocity.y, 0, SPEED)
				velocity.x = move_toward(velocity.x, 0, SPEED)
		State.WALK:
			if not direction:
				current_state = State.IDLE
			elif Input.is_action_pressed("sprint"):
				current_state = State.RUN
			else:
				match facing_direction:
					Vector2.DOWN:
						animation_player.play("walk_down")
					Vector2.UP:
						animation_player.play("walk_up")
					Vector2.LEFT:
						animation_player.play("walk_left")
					Vector2.RIGHT:
						animation_player.play("walk_right")
					
				velocity = direction * SPEED
		State.RUN:
			if not Input.is_action_pressed("sprint") or not direction:
				current_state = State.WALK
			else:
				match facing_direction:
					Vector2.DOWN:
						animation_player.play("run_down")
					Vector2.UP:
						animation_player.play("run_up")
					Vector2.LEFT:
						animation_player.play("run_left")
					Vector2.RIGHT:
						animation_player.play("run_right")
				
				velocity = direction * (SPEED * run_multiplier)
