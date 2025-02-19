extends Node

@export var mob_scene: PackedScene
@onready var hud = $CanvasLayer  # Acessa a HUD

var score = 0
var lives = 3
var time_left = 60

# Chamado quando o nó entra na árvore de cena pela primeira vez
func _ready() -> void:
	new_game()

# Chamado a cada frame. 'delta' é o tempo decorrido desde o frame anterior
func _process(delta: float) -> void:
	pass

# Função para encerrar o jogo
func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()

# Inicia um novo jogo
func new_game():
	time_left = 60
	hud.update_score(score)
	hud.update_lives(lives)
	hud.update_time(time_left)
	
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

# Atualiza a pontuação a cada segundo
func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)

# Atualiza o tempo restante e verifica se o jogo acabou
func _on_start_timer_timeout() -> void:
	time_left -= 1
	hud.update_time(time_left)
	
	if time_left <= 0:
		game_over()
	
	$MobTimer.start()
	$ScoreTimer.start()

# Reduz o número de vidas quando o jogador for atingido
func _on_player_hit():
	lives -= 1
	hud.update_lives(lives)
	
	if lives <= 0:
		game_over()

# Gera inimigos aleatórios no mapa
func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_location = $MobPath/LocalMobGeneration
	mob_location.progress_ratio = randf()
	
	var direction = mob_location.rotation + PI / 2
	mob.position = mob_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
