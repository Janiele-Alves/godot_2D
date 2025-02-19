extends Node

@export var mob_scene: PackedScene
var score
var lives = 3
var time_left = 0 
@onready var hud = $HUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	lives = 3
	time_left = 0
	hud.update_score(score)
	hud.update_lives(lives)
	hud.update_time(time_left)
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)

func _on_start_timer_timeout() -> void:
	time_left += 1
	hud.update_time(time_left)
	$MobTimer.start()
	$ScoreTimer.start()

func _on_player_hit():
	lives -= 1
	hud.update_lives(lives)

	if lives > 0:
		$Player.start($StartPosition.position)  # Reposiciona o jogador
		$Player.show()  # Mostra o jogador novamente
		$Player.get_node("CollisionShape2D").set_deferred("disabled", false)  # Reativa a colisão
	else:
		game_over()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_location = $MobPath/LocalMobGeneration
	mob_location.progress_ratio = randf()
	
	var direction = mob_location.rotation + PI / 2
	
	mob.position = mob_location.position
	
	direction += randf_range(-PI /4, PI /4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
