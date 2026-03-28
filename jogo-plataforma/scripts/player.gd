extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

const SPEED = 130
const JUMP_VELOCITY = -300
var direction = 0

# POSSIVEIS ESTADOS DO PLAYER
enum PlayerState {
	idle,
	walk,
	jump,
	fall,
	duck
}

# DEFINIÇÃO DO STATUS DO PLAYER
var status: PlayerState

# DEFINIÇÃO DO STATUS INICIAL AO INICIAR O JOGO
func _ready() -> void:
	go_to_idle_state()

# PROCESSO CONTÍNUO DO JOGO
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
		PlayerState.fall:
			fall_state()
		PlayerState.duck:
			duck_state()
			
	move_and_slide()

# ================================================================
# TROCA DE COMPORTAMENTOS -> STATUS (go_to)

# GO_TO IDLE STATE
func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")
	
# GO_TO WALK STATE
func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")
	
# GO_TO JUMP STATE
func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	
# GO_TO FALL STATE
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")
	
# GO_TO DUCK STATE
func go_to_duck_state():
	status = PlayerState.duck
	anim.play("duck")
	# MODIFICA AS MEDIDAS DO COLISOR PARA CORRESPONDER AO PLAYER AGACHADO
	collision_shape.shape.radius = 5
	collision_shape.shape.height = 10
	collision_shape.position.y = 3

# ================================================================
# SAIDA DE COMPORTAMENTOS

# EXIT DUCK STATE (MEDIDAS DO COLISOR VOLTAM AO ORIGINAL DEFINIDO NO NODE PLAYER)
func exit_from_duck_state():
	collision_shape.shape.radius = 10
	collision_shape.shape.height = 16
	collision_shape.position.y = 0

# ================================================================
# ESTADOS DO PLAYER (MODIFICAÇÃO CONFORME AS AÇÕES NO JOGO)

# IDLE STATE
func idle_state():
	jump()
	move()
	
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if not is_on_floor():
		go_to_fall_state()
		return
		
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return

# WALK STATE
func walk_state():
	jump()
	move()
	
	if not is_on_floor():
		go_to_fall_state()
		return
	
	if velocity.x == 0:
		go_to_idle_state()
		return
	
# JUMP STATE
func jump_state():
	move()
	
	if velocity.y > 0.1:
		go_to_fall_state()
		return

	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return

# FALL STATE
func fall_state():
	move()
	
	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return

# DUCK STATE
func duck_state():
	update_direction()
	
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return

# ================================================================
# FUNÇÕES AUXILIARES

# ATUALIZA DIREÇÃO E REALIZA O MOVIMENTO BASEADO NA VARIAVEL SPEED
func move():
	update_direction()

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
# ATUALIZAR DIREÇÃO (DIREITA / ESQUERDA)
func update_direction():
	direction = Input.get_axis("left", "right")

	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false
	
# VERIFICA E CHAMA A FUNÇÃO DE TROCA DE COMPORTAMENTO JUMP
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_state()
		
# VERIFICA E CHAMA A FUNÇÃO DE TROCA DE COMPORTAMENTO FALL
func fall():
	if not is_on_floor() and status != PlayerState.jump and status != PlayerState.fall:
		go_to_fall_state()
