GDPC                                                                                        "   T   res://.godot/exported/133200997/export-20422a58ddd5d8733654ee9d638981f7-Bullet.scn   
      C      U+|�E�z��TZ�q    T   res://.godot/exported/133200997/export-22233b09be71ed3fb1e266ab8f0e558b-Enemy.scn   @'      =      9͕B����ro��    T   res://.godot/exported/133200997/export-26d25227a53607047bb2c93ff57a73be-TopWall.scn �p      �      �4�tk��>��+v    X   res://.godot/exported/133200997/export-42001c8e0b4c6076ff7654178325fac3-CameraWall.scn         �      ~u�QP��CB�ʕP�O    T   res://.godot/exported/133200997/export-68579111cee3364e2480ce3d461adbec-EndScene.scn0u      '      �?�����,��-��    P   res://.godot/exported/133200997/export-aaeece3389ef5e96ebdf70440d3216a4-Main.scn�;      �      E7��b-<r�5�a�A    X   res://.godot/exported/133200997/export-d9a2ed331d6de6612de809c6cd74cdf3-SideWalls.scn   �k      �      �X�52:�����شh\    P   res://.godot/exported/133200997/export-efc710f71cc67b1c92c5451511245266-Menu.scn�]     �      t�6��V�w#9;��&f    T   res://.godot/exported/133200997/export-f74bd447042ac109e409101e4a478b53-Player.scn  �]            D4�M�z��~��E����    ,   res://.godot/global_script_class_cache.cfg          �      Y����N�<ּ���_S    H   res://.godot/imported/Hurt.wav-fa669c5cd596766b67f3681b8253515a.sample  �x      F�      "gjዉ��	�$=4�    H   res://.godot/imported/Shot.mp3-b232c1625da8e313e7c431a1d0950141.mp3str  pu     ��      &!�Ab� �]j�a�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�L     ^      2��r3��MgB�[79       res://.godot/uid_cache.bin  P     �      ��Ǖ���ӓq�1�@
       res://EndScene.tscn.remap   p     e       �X�F�(1Ҕ9�f��u       res://HighScore.gd  `w      ;      ��[
b�ß8���G�       res://Hurt.wav.import   �J     �      �͠JSwa;`���f��Y       res://MainScene/Bullet.gd   �      S      $�U�WQ���Wx���r    $   res://MainScene/Bullet.tscn.remap   `     c       �^�d������\��~       res://MainScene/Camera3D.gd P      �      ���`5>+߹�@�5v    (   res://MainScene/CameraWall.tscn.remap   �     g       �Ы.	����xe       res://MainScene/Enemy.gd !            �}7ሼ�(,�+��        res://MainScene/Enemy.tscn.remap@     b       ��p�V���j9/��=�       res://MainScene/Main.gd �5      P      ���8��eZ�[}�AT        res://MainScene/Main.tscn.remap �     a       �J�MXf&Mc%��x��       res://MainScene/Player.gd   `R      d      -[� �c���z�$�4�B    $   res://MainScene/Player.tscn.remap         c       ��j�>	\$em/�Y2    $   res://MainScene/SideWalls.tscn.remap�     f       �W4yp�"Rd���6�    $   res://MainScene/TopWall.tscn.remap        d       fB�Ö��Ԃ�j��       res://Menu.tscn.remap   �     a       �MV�^l��/f�|�       res://PlayBtn.gdPt           ��t���r0��m�       res://Shot.mp3.import         W      ra6���?����K=��       res://icon.svg.import   0Z     K      	PF_�2}E���Č       res://project.binary      �      F�i�������:&�    �G��v��!�F�list=Array[Dictionary]([{
"base": &"CharacterBody3D",
"class": &"Bullet",
"icon": "",
"language": &"GDScript",
"path": "res://MainScene/Bullet.gd"
}, {
"base": &"CharacterBody3D",
"class": &"Enemy",
"icon": "",
"language": &"GDScript",
"path": "res://MainScene/Enemy.gd"
}, {
"base": &"CharacterBody3D",
"class": &"Player",
"icon": "",
"language": &"GDScript",
"path": "res://MainScene/Player.gd"
}])
��]K�2 <,�class_name Bullet
extends CharacterBody3D


var shoot_direction = null
var speed = null
var damage = null
var t = Timer.new()
var target = null
var source = null
var origin = null
var shot = null
var hurtnoise = null

#initialize the bullet
func init(src, playerpos, shoot_input, spd, dmg):
	target = playerpos
	shoot_direction = (transform.basis * Vector3(shoot_input.x, 0, shoot_input.y)).normalized()
	damage = dmg
	speed = spd;
	origin = src
	source = src.name.replace("@", "").rstrip("0123456789")
	self.position =  Vector3(target.x + shoot_input.x, target.y, target.z + shoot_input.y)
	self.rotation = (transform.basis * Vector3(shoot_input.x, 0, shoot_input.y)).normalized()
	
	
#make the bullet disappear after a 5 seconds so it doesn't lag the shit out of the game
func _ready():
	#shot = $ShotNoise
	#hurtnoise = $Player/HurtNoise
	self.look_at(target)
	t.wait_time = 5
	t.one_shot = true
	t.timeout.connect(func() : queue_free())
	get_tree().get_root().add_child(t)
	t.start()
	
# processes the collisions
# if the bullet collides with a wall, it should just disappear
func process_collision():
	var collideCount = get_slide_collision_count()
	
	if collideCount >= 1:
		var collision = get_slide_collision(collideCount-1)
		var collider = collision.get_collider()
		
		if(collider == null): return
		var collideName = collider.name
		collideName = collideName.replace("@", "").rstrip("0123456789")
		
		if(collideName.contains("Wall")): queue_free()
		if(source != collideName):
			match collideName:
				"Player":
					if(collider.iFrame.is_stopped()):
						collider.health -= self.damage
						collider.iFrame.start()
						queue_free()
						return
				"Enemy":
					collider.health -= self.damage
					if(collider.health <= 0): origin.score += collider.value
					#shot.play()
					queue_free()
					return


func process_move(delta):
	self.position = Vector3(self.position.x + (delta * shoot_direction.x) * speed , self.position.y + (delta*shoot_direction.y) * speed, self.position.z + (delta * shoot_direction.z) * speed)

func _physics_process(delta):
	process_move(delta)
	process_collision()
	move_and_slide()
�.�)�����dDRSRC                     PackedScene            ��������                                            {      resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    custom_solver_bias    margin 	   _bundled       Script    res://MainScene/Bullet.gd ��������   AudioStream    res://Shot.mp3 �ʊV%�    !   local://StandardMaterial3D_yx2pf �         local://CapsuleMesh_gjspb �         local://CapsuleShape3D_hh0ue �         local://PackedScene_t2rw1          StandardMaterial3D          ���>	�|>��H?  �?m         CapsuleMesh    o             m         CapsuleShape3D    m         PackedScene    z      	         names "         Bullet    process_mode 
   transform    script    CharacterBody3D    MeshInstance3D    mesh    CollisionShape3D    shape 
   ShotNoise    stream 
   volume_db    AudioStreamPlayer    	   variants                  �?              �?              �?��9�H;�+�             "�����    �>"���            ��>                                            �@      node_count             nodes     .   ��������       ����                                        ����                                 ����                              	   ����   
                      conn_count              conns               node_paths              editable_instances              version       m      RSRC�mO���2�a(�extends Camera3D

var gameManager = null

var player = null
var healthLabel = null
var scoreLabel = null
var waveLabel = null

var currentHP = 0
var currentScore = 0
var currentWave = 0

var timer = Timer.new()

func _ready():
	gameManager = get_tree().get_root().get_node("GameManager")
	
	player = $"../Player"
	healthLabel = get_child(0)
	scoreLabel = get_child(1)
	waveLabel = get_child(2)
	
	healthLabel.text = "Health: " + str(player.health)
	scoreLabel.text = "Score: " + str(player.score)
	waveLabel.text = "Wave: " + str(gameManager.wave)
	currentScore = player.score
	currentHP = player.health
	
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func() : waveLabel.visible = false )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(currentHP > player.health): healthLabel.text = "Health: " + str(player.health)
	if(currentScore < player.score): scoreLabel.text = "Score: " + str(player.score)
	
	if(currentWave < gameManager.wave): 
		waveLabel.text = "Wave: " + str(gameManager.wave)
		waveLabel.visible = true
		currentWave = gameManager.wave
		timer.start()
	
	self.position = Vector3(player.position.x, 6, player.position.z+2)
�uRSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    margin    size    script 	   _bundled           local://BoxShape3D_kltog 0         local://PackedScene_tp55m _         BoxShape3D            �?��uA��_B         PackedScene          	         names "         CameraWall    StaticBody3D    CollisionShape3D    shape    	   variants                       node_count             nodes        ��������       ����                      ����                    conn_count              conns               node_paths              editable_instances              version             RSRC�H�class_name Enemy
extends CharacterBody3D

var health = null
var speed = null
var damage = null
var can_shoot = null
var type = null
var target = null
var value = null
var shoot_cooldown = Timer.new()
var colorMatches = {Color.RED : "Red", Color.BLUE : "Blue", Color.GREEN : "Green", Color.PURPLE : "Purple", Color.BLACK : "Black"}

func init(hp, spd, dmg, val, shoot, color, player):
	health = hp
	speed = spd
	damage = dmg
	type = color
	can_shoot = shoot
	target = player
	value = val
	
	# change color
	var material = $MeshInstance3D.get_active_material(0)
	material.albedo_color = color
	
	match colorMatches[type]:
		&"Purple":
			shoot_cooldown.wait_time = 2
		&"Black":
			shoot_cooldown.wait_time = .5
	shoot_cooldown.one_shot = true
	add_child(shoot_cooldown)
	
# process the shooting if possible
func process_move():
	if can_shoot and shoot_cooldown.is_stopped():
		var bullet = preload("res://MainScene/Bullet.tscn").instantiate()
		
		var tempFix = (Vector2(target.position.x - self.position.x, target.position.z - self.position.z)).normalized()
		
		# place the bullet at the correct starting position
		bullet.init(self, self.position, tempFix, 3, damage-2)
		bullet.set_collision_layer_value(1, false)
		bullet.set_collision_layer_value(2, true)
		get_tree().get_root().add_child(bullet)
		shoot_cooldown.start()

func _physics_process(delta):
	if health <= 0: 
		get_tree().get_root().get_node("GameManager").enemyCount -= 1
		self.queue_free()
	
	process_move()
	self.position = self.position.move_toward(target.position, delta * speed)
�XQ5s"-��Nr'�RSRC                     PackedScene            ��������                                            |      resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    is_hemisphere    custom_solver_bias    margin 	   _bundled       Script    res://MainScene/Enemy.gd ��������   !   local://StandardMaterial3D_prsh6 m         local://SphereMesh_cghhn �         local://SphereShape3D_f2sau �         local://PackedScene_vlbwg          StandardMaterial3D                      �?��`>��>  �?m         SphereMesh              o             m         SphereShape3D    t      &�?m         PackedScene    {      	         names "         Enemy    process_mode    script    CharacterBody3D    MeshInstance3D    mesh    CollisionShape3D    shape    	   variants                                               node_count             nodes        ��������       ����                                  ����                           ����                   conn_count              conns               node_paths              editable_instances              version       m      RSRC��xextends Node3D

# health, speed, damage, shoot
var enemyTypes = {
	Color.RED : [2, 2, 2, 50, false], 
	Color.BLUE : [3, 2, 3, 100, false], 
	Color.GREEN : [2, 3, 2, 150, false], 
	Color.PURPLE : [4, 1, 4, 200, true],
	Color.BLACK : [6, 0, 3, 250, true]
	#Color.BROWN :[
}
var enemyColors = [Color.RED, Color.BLUE, Color.GREEN, Color.PURPLE, Color.BLACK]
var powerUps = []
var wave = 1
var enemyCount = 0
var player
var rng
var camera

signal pause()

# Called when the node enters the scene tree or the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_time_string_from_system())
	player = get_child(2)
	spawnWave()

func spawnWave():
	for n in range(wave*4):
		var enemyVariety = rng.randf_range(0, wave)
		enemyVariety = clamp(enemyVariety, 0, enemyColors.size()-1)
		var enemy_x = rng.randf_range(-27, 27)
		var enemy_z = rng.randf_range(-20, 20)
		
		while(pow((enemy_x - player.position.x), 2) + pow((enemy_z - player.position.z), 2) < pow(10, 2)):
			enemy_x = rng.randf_range(-27, 27)
			enemy_z = rng.randf_range(-20, 20) 
		
		var enemyColor = enemyColors[enemyVariety]
		var enemy = preload("res://MainScene/Enemy.tscn").instantiate()
		enemy.position = Vector3(enemy_x, .6, enemy_z)
		enemy.init(enemyTypes[enemyColor][0], enemyTypes[enemyColor][1], enemyTypes[enemyColor][2], enemyTypes[enemyColor][3], enemyTypes[enemyColor][4], enemyColor, player)
		add_child(enemy)
		enemyCount += 1
		
func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = not (get_tree().paused)

func _process(_delta):
	if(enemyCount == 0):
		wave += 1
		spawnWave()
RSRC                     PackedScene            ��������                                            {      resource_local_to_scene    resource_name    custom_solver_bias    margin    size    script    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    subdivide_width    subdivide_height    subdivide_depth 	   _bundled       Script    res://MainScene/Main.gd ��������   PackedScene    res://MainScene/Player.tscn @�V�t�y   AudioStream    res://Hurt.wav �׋g�0   Script    res://MainScene/Camera3D.gd ��������   PackedScene    res://MainScene/SideWalls.tscn �TR�=qU   PackedScene    res://MainScene/TopWall.tscn �fd���q   PackedScene     res://MainScene/CameraWall.tscn {C#�!�e      local://BoxShape3D_rl20v �      !   local://StandardMaterial3D_i2oc3 �         local://BoxMesh_b8n83          local://PackedScene_y0hds R         BoxShape3D          ��YB<	?�B         StandardMaterial3D          ��*?��?�� ?  �?         BoxMesh    r                  ff&@  �?33�?         PackedScene    z      	         names "   '      GameManager    process_mode    script    Node3D    Floor    StaticBody3D    CollisionShape3D 
   transform    shape    MeshInstance3D    mesh    DirectionalLight3D    Player 
   HurtNoise    stream 
   volume_db    AudioStreamPlayer 	   Camera3D    fov    Health Text    offset_right    offset_bottom    text    Label    Score    anchors_preset    anchor_left    anchor_right    offset_left    grow_horizontal    Wave    visible    offset_top    Walls    Node 	   LeftWall 
   RightWall    TopWall    CameraWall    	   variants    $                              �?              �?              �?3O����                   �A            ff?              �A5zu�    ��              �?             qs?8e�>    8e�� qs?    s�#@��@              �?              �?              �?    ��l?                  �@     �?            ��$?��C?    ��C���$?    G�A��A   b��B               B     �A   	   Health:              ?     ��     @B            Score:               C     �A     7C      Wave:                �?              �?              �?�����?�ѻ     �?              �?              �?D��Aσ�?��f>            �-��ue;���7�5���?��e;T�?��\9�-����8VA	y��            1�;�      ��      �?      �?    1�;�    F%�@|�A      node_count             nodes     �   ��������       ����                                  ����                          ����                          	   	   ����         
                        ����                           ���                  	                    ����      
                           ����                                            ����                                      ����                                                                    ����
                                                                            "   !   ����                    ���#                          ���$                          ���%             !              ���&   "         #             conn_count              conns               node_paths              editable_instances              version             RSRC[�{��class_name Player
extends CharacterBody3D


var speed = 6
var bullet_speed = 5
var shoot_cooldown = Timer.new()
var iFrame = Timer.new()
var health = 6
var maxHealth = 6
var damage = 1
var score = 0
var save_path = "user://score.save"
var hurt = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	
	hurt = $HurtNoise
	
	# iFrame cooldown 
	iFrame.wait_time = 1
	iFrame.one_shot = true
	add_child(iFrame)
	
	# shooting cooldown
	shoot_cooldown.wait_time = .5
	shoot_cooldown.one_shot = true
	add_child(shoot_cooldown)
	

# processing player shooting
func process_shoot():
	# get shooting direction
	var shoot_input = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down" )
	
	# trying to shoot and there's no cooldown
	if shoot_input and shoot_cooldown.is_stopped():	
		# load and instantiate the bullet
		var bullet = preload("res://MainScene/Bullet.tscn").instantiate()
		
		#initialize bullet, add to tree, start shoot cooldown
		bullet.init(self ,self.position, shoot_input, bullet_speed, damage)
		get_tree().get_root().add_child(bullet)
		shoot_cooldown.start()

# processing player movement
func process_move(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

# will handle colliding with enemies
func process_collision():
	# gets number of collisions
	var collideCount = get_slide_collision_count()
	
	if collideCount >= 1:
		var collision = get_slide_collision(collideCount-1)
		var collider = collision.get_collider()
		
		# if collider is null don't proceed
		if(collider == null): return
		var collideName = collider.name
		collideName = collideName.replace("@", "").rstrip("0123456789")
		
		# parse collider name
		match collideName:
			"Enemy":
				if(iFrame.is_stopped()):
					health -= collider.damage
					iFrame.start()
					hurt.play()
					
func game_over():
	var highscore = 0
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		highscore = file.get_var()
	
	if(highscore < score): highscore = score
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(highscore)
	#var savegame = File.new()
	#var same_path = "res://savegame.save"
	get_tree().change_scene_to_file("res://Menu.tscn")	

func _physics_process(delta):
	process_collision()
	process_move(delta)
	process_shoot()
	move_and_slide()
	if(health <= 0): game_over()
~�8ID_u�Þ?�RSRC                     PackedScene            ��������                                            |      resource_local_to_scene    resource_name    custom_solver_bias    margin    radius    script    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    height    radial_segments    rings    is_hemisphere 	   _bundled       Script    res://MainScene/Player.gd ��������      local://SphereShape3D_figho n      !   local://StandardMaterial3D_vkgkl �         local://SphereMesh_cibx0 �         local://PackedScene_oo7fp 
         SphereShape3D          1?         StandardMaterial3D          �{?��T?���=  �?        �?         SphereMesh    r                     PackedScene    {      	         names "         Player    script    CharacterBody3D    CollisionShape3D    shape    MeshInstance3D    mesh    	   variants                                          node_count             nodes        ��������       ����                            ����                           ����                   conn_count              conns               node_paths              editable_instances              version             RSRCMsȤ'�{"��RSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    size    subdivide_width    subdivide_height    subdivide_depth    script    custom_solver_bias    margin 	   _bundled           local://BoxMesh_2yv08 �         local://BoxShape3D_gc0y2          local://PackedScene_w4yps 5         BoxMesh             BoxShape3D            �?Zd�@H�B         PackedScene          	         names "         Wall    StaticBody3D    MeshInstance3D 
   transform    mesh    CollisionShape3D    shape    	   variants            �?              �A               B    �N�@                   �?              �?              �?    �ru?                   node_count             nodes        ��������       ����                      ����                                  ����                         conn_count              conns               node_paths              editable_instances              version             RSRCYRSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    size    subdivide_width    subdivide_height    subdivide_depth    script    custom_solver_bias    margin 	   _bundled           local://BoxMesh_2yv08 �         local://BoxShape3D_gc0y2          local://PackedScene_mh7g6 5         BoxMesh             BoxShape3D            �?�|A�[/B         PackedScene          	         names "         Wall    StaticBody3D    MeshInstance3D 
   transform    mesh    CollisionShape3D    shape    	   variants            �?              �A              \B                           �?              �?              �?    [�Ǽ                   node_count             nodes        ��������       ����                      ����                                  ����                         conn_count              conns               node_paths              editable_instances              version             RSRCRSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script           local://PackedScene_ueolc �          PackedScene          	         names "      	   EndScene    Node3D    	   variants              node_count             nodes        ��������       ����              conn_count              conns               node_paths              editable_instances              version             RSRC|&{_���extends Label
var save_path = "user://score.save"
var highscore = null

func load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		highscore = file.get_var()
	else:
		highscore = 0
		
func _ready():
	load_score()
	self.text = "Highscore: " + str(highscore)
}�F�!RSRC                     AudioStreamWAV            ��������                                            
      resource_local_to_scene    resource_name    data    format 
   loop_mode    loop_begin 	   loop_end 	   mix_rate    stereo    script           local://AudioStreamWAV_ffhe7 /         AudioStreamWAV          ��  ����L � y ;  � ; ��L���/ ��m����]� Z � � � f ������M � t � � � � � , ��7�3�b�
���, �  L - ����������#��F�? � � ����a��e �  M Z � � � � I 5 ����������� � � " ����i��������s�Z���E �� . ��C S �  ����" �  ���� � � � �������� *�;�� �2� o ��:���) ~���S����#�q�]�f ��� 6 e a U � ��/ �  u�H� ������ ���� 	 D ) ,�����:�s���# t��q�����p�E  ��� |   ��>�!�����u )KF ��6 ����� � � N ,�����t � � � �  _�:�n�< �7����? � F� V���i C&R ��4�L�����( ��� A 64� � k  ��m ��
�O | �9������ +"�V���'��O���%���?�k��`�[����������b���	�%��$�, A�0�)c��
�=����m���^�cJ�l�
�I��d����m�:�4կ����8�tvruHY��b�ؔ.�
�e��_�>�ء)�(�;�Z�Dv�����V���L�
���E�&�'+=$NOL�DwL�\�d�g2Mn<��U�P�t�&�����K�+F(� W:MJ5>�1W/�G�jV]�*-��n����}������.=I>�.�0 .�#����Ӄʹ���ɼ`��������G�5�;�)9�3]']��L1�;!� �'#!�8a�x�k0v��X������".:�:���)�����@Х��CB\� zzpi랑���Ϯ��Fĵ�;�+�����X�ޕr�z,�>9[���� ����2�� �̟�"�\� �I;_a I�ܕ���Ҧ+�گZ�d=���<�3

@�>b(1a?/�Ah@bG=����;֣������O������[�]�d�c,��0�{��#p$�(5E�E�S˗�	����Ê�!�3����+Q7�%�� �����)!�;"�1*9Kh������7�1��d������N�����ӯ����Q+�c�yozsr`3
�?�N�ч�h��n�������
tl0bD�`�L�2�-�2��ù&�5�H��~�F���9.�]�a�b6Z�5 ��í��h,� k٣�ق	�j�)�0s�E7�������u��O�y�w�wRj�$���A�̢�+�mlG��;�n�z�jT:��{����!�_����J���������Z��;�ȷ��*���4VPw�w)[�>�7�A�@�r���ׇ�r�C��I��"�e^*�uk ���o�U�;������=�)�2@2+*'� �����N�������|�M��� � d'���n���
�c��"�R�������_�-R.B.,(a�+���T�F�:�L�d�x�K�iPrtiLM&���H��I�C�8K	T��{���ǲǅ���<��̙���0T�M�Ja?�����`����* z��&	Gf2fE�.������S�o���*Fr	lmLPG��ҋ���������n�<*Md9	\���<Ϥ����'������s��&@�!�c]���c���s�d�V� #�
O ���)�]����� �����!-(.*l'�g���$��� z�'�����G%�/�2T�C��kݻ������	�/+� �����_�	��m߯�7��f	���L#;#�O���0	���@{���N�l�_���_��B�����_�Y���������;��v�q�S�92/b�����������[�t���������p�����;����������#n��W�v�E���d��
�"����7���~ ��	� ��J���y�E���!����z�����6��	I
���
e�O�X��Y�����	�	���&}
�	&	N�z
�
��D�����jqC��_���:�0����|�%� �,��o�We��
����P�&��E ��
:"����0��U�*�)���<�������
H������v���|������������:�-�"=k���o�b���� B���k�e�����(�a�;���
(����z���I��W���&��� e����Vx��3���U
_�������Z�������.�-$#���3�?��|����=A�o���<����M�����Z�������#>J0��?� �����G�J��z�����m��
:�"�"k;�����R����C�����@B��t"je��1�w�����w�d��������8���� �����{�1��wC��V�j�����W ���-
5g~���������������T����r�����	T	D

��P�*��������k��������@
m���
������������I�2�701� ���)j !�H�S�D���?�>���� ��~���Z��x	��K���a���q	��
�) ��(j��)�I�H�a���b��������JsNb�e �`�@��������/
 ��
�z ��Q���Y�R���^���c�����������������	M�	T2 ������E������T � � R���C����= M�d�)��������2�z��������> 8�� w@e��I�_�d ������2�$���4 ���������/ BT+�������:�������%��r�"�)�������'<��^��^�������d	�	WM5���S\F������W�n�(�T =��	�� ������R��>������ ��o���[ & ��-  {%�� xK���{��K	�cZ����
�c��Z���� [����f�PB��1���d���U��������2�*���
�
��L���n��
�e� &�����F�����a�+�m����6�Y��; >�������������> �� ���0���������4%V���
`/UQ�]�g�:��!�>�E���������c lM )^ �	s�T�7�$��b�z������w� �%������2�&�����
 �t��	>2
e�����'���������n����OW�����g�L�-	a�
^�	��+w7��"�d�"�(�e�M|	������#�@�r�5� �s�������������F���(�5�~������ ��f��`s
�
�TZ��,�>�������z����L��� �� G�y
�� U�� �#
�

P6_���U�A�&��&4�����[
�	���{����?������ 	 ���	�(	w'����������Z �����������V�:������������O�%;�� O � 1<s�����������hj����$ ��)Y�����u�Y��$�m���{�e�o�_�����.�*�h�����o���X�����=���F�	D
�
�����u���� 4 � ����������3���X�R
-������^��������Fv�`��g�_������ � .�g���e N*�f��{	�����2�~����T�����{��������t�o���>��P ��������G����������TGz��B"����As�� ��v�����/ L d��?����<�f��_��S� ��5�U�r �3^c������������������>��q��+2p�K���J������!���U� �I�T� N��P������+ ��> �� ���d ��s���R( o���J�����������4'�+,0���o�[�������N��������*@E�N�� �� >�����D��z � ��������������%���'���������*��� o�p�+��������.��������z�D� � o�@�\�� J�P�����w�[����������[D�/]:��� 
��%	V�b K���r�O�����/) Q�h�[T)?� ��i ������P��X�� �P�c u����_�� �
 ;�� � �$A ; 4�����Tc��2 a�6�r�� c)�F�]�������n�	�'� �����.�c Q�v�H�������� < �����������:�f�������� KZ�;����y ��}�����o����� ��U����������� �E�
E%��>���W����s����
����s�� ����s������J a���S�D�L��r�-���*��-K� ��u�:��X74_���f���7�����{������������� ��l�z�� �;��(rk#������ �f�"�gG����D�f���&�����K��*������Q���Q�a��� ��* � ����6Ops�L��������f��@UHJ��
�����2�a�����X���a���O������*ue: z�4�$���R�&�+ 5=���������������v � �==B#� ����� �K� 6���|��C�Y�g��������0��� � � �8�# �������� �x	���G� ����I�������S���?���/ B�Y���#�������V�c����_��L�v������ o���Z���� Z  �L�	�6�{���U��u���CTs� ��4�.�Q��� X � �+J6_ ��� � v�� ��B�7�k���= ��P����J������7���������p�B�( c#��s� ��z� ����� �|�������n���g�����:�-��� �fK�  ����������-�U \�<�q�����5����	�m�"�y�%���� �	1���pF��� ����� ����?�����������	���r���������K�����O�����6�"���/���c�F���b�m $n���� ����F����������l ��� y�j *��~��_�l�Q�u���r�<�8 �>���K�Bl }���[�������� � Ws��v� N���B���A�"������k� �b� �%�(������� �t ��Q������ � � j����� ���'���������������ZU�kt� � �����1���;������t �a�7������  U�����������}�C���������+��I��%�1�`��4 ,l��o���^ ���M����������~ �1��{�������m����\ +� ��- `��i��/$�:�~�������v��u ^��Q^>*�������:�p��������������^�D�?�� ��b���������5�	��R �������9�&�����	�,�����"�����w��#�\�I�s�#�?���-�����1�? %������������ ��h�������K�����Ren}��u��0�j�S�b�?����'��o���j0D.����������#� )�P ��_�r������ C�{�� e�����#�1���'�; � &�u�` a�� �� � � �������|��{�_�������������:d���m�|��������������p�����&�	�?@H�	��m�q�c������� �?�eM�G]9��?�����u�[�/�! 2����� � 
C�3������ � 8 g���G�r�gm%����� M���� ����d�� �� ^ �������3�A���s��d0 �^�E�(�����V���^0&����������������;�l���b��������B�������q����*p�	j	�S��p������d����&ttx* ���: �����m����.�
���I���G��d�s�������� -�����# ?�2�. � @ ����L���:�������}���4�����'�U�f4%�"u6� � |�L�� ����i�=��������`�62 ��{���6�:���v���� ������"�}�y���Z � � � 6�u x������_�E�}��a�H�� 5pd  ���S�i L���}���f�BE� 2�Iz � � b�����e���y r��j(E�M ���������8�������e�V��S���, ����1F
������-�I�_�$��e�K��&�7�
9	��&b���� C ��������������:���� xZ��{� -�j����� �����Z � "e��M�G� �� �����?�������% 7 � _�_�gQ 2� ���, ����W�g�����3����������� ����[i%� Q  ' � � � D �� � Y �����7 Eq� �� { ��%������������R  	 $r�R� ������1�c�:�j ����� ����� �������' ; � �  	 ��t � � j ��~���Z Q 7 ; ����v���p�������v�`�����>� 1�����>�6C� & �#,�� � v ������_������N�o���B����������� W���+D� � s � "7 ������e���� I��&� ��������p���W�� ��2 � ��c�,�c����N�(�������K��� �B �({�CP	w4)�5�d�k��>�����������H�.������ Wg�:D�NC��`���V�������R�B������%�����@�����J�=���T�p�� ��v��R� ����O ;���  d�|��pT������$����:�~���Q��G���������^�@vw�
\c��,������]����\���p�l��k�pzO��*�������A�r����U�=�; ������� A%�n��&�������g���e�!� � �+�N�������p���V���m ���Ht�k�e� %�&�2���y�����.��w 9b ��g���|���f�/ ����+ X e���������a ���������� ����������k���� -!����� ��:�� ��N���vp���c�� ~�(�i�_�����v���u�� H 3��� e� ������������A�����
KT 5  � ��43^i ������1����y�����B � � w�S� ����+ o��� ��� �����������\ ��������������s���� i ��^�@���� � ��(	������!�������f����� Oo�� ��k���Y� f � MU ��_ u � ���4��������������� $q�&� <�����-��������a���n�n�r ��RQ��%�������a � 8 3 � ��G�%� �� 7 . y���Z u@�R�qJa ����O��	�����R�R�����?�+����= 4��DJMj���o�7��������h � BH< ����'��������X��.���{��� / 6 �����������" � k����� �E�a � �l�G�N; � L����b�o�����-�����L�� g6s��k�����������
�n /z,6��%�-����P k �  Q�����>�c�J�*(� ��/���*���?�������B� :� xz `�` �b �n�]�����i �� F� ������m������+�ZA��x   H ���S����	�������� � � ��h���. ����� � � ��� � Z ��9�������
���d������j�$j�}|D�N��u�M�������}���������J-S�	�x�����v����3 � �  ����������W��y����W+�
����������d��"��\�� ��(�����������W�O���� � '� J � � � � ��`�Z������� ��� � ! ��� � z�0OR�_����I�����p�������)�a�}�j v � K G � � � � � ����6�������  � V� ` � � � �  & < & � �  =  3���s <Z���h o���4�W�'�8��U�6��n�����W�B %;���|f�  ������,�Q�U�b�B�����^ x�.W� [>� ��m���a�������P���|�h��� � Pb���>c|B� � x  ��@ � :�LL �4� H�,�K�w��� �x$HW$�  ������G�K���V���e���7�����O�q�D J �  ��S !�SW�� 5��� '������t�J�)�8�f�U;�c-���� f �������ja=���j�T�D���u� &�������{������{���m ������ �� � � ��8 � ��`� ��� O ����������[� � )���' r�l � ��1���]�- ���������A
�Q	?� ��[���V�Z���q_����� %A��o -�k���j�A�����-�� ������.���>�A � �u��s ;�������� l� 2 i m �������3�����4��%������l����k�� w�� ������������h�;�q���U ��������k���h���#}���z� � � �����4 a����$�h�K��g���
�(��.����������k�
���j �� ��u���������Q ) ��b d�2A� �����[���� 8��� ; � (A ������f�f ��,� K�����`���!���^��-�1���2�	���[t0�����*��1�!6���������o��F� �����5� Iyd ��������"������5� �Ua��� a������8���� ���� I���w�� � ����6��� �����v�������. l�*P �,�d���W���F�>�� ���"��'���W���n����*��N� �8R��@S� � � � 
��% ��������������� � $   � � l  ��z � o q���@�H�Q�O�������� $��b� G ���� _ � � � � � = B ��E���k�� �!���q�~������ � � ���  ����N`c�- o����h�t  ��	���X / �����S��3�)���y�Ds�iM�XULl���*- )�a�����X���:��,������r�����K����H�����������b � �4��p ����������������6�$� ON����9��;��>9 )=� � �  /��������z f�������q�J�7�%�����?��� �h�S�f�����M���K��� �������\����T�B �X9 7�����S�7�8�� �Q>�����Y� z � N���H
 ��������� � � XFe �� r i ��K����� ��������D�=&�O�� ��(�������� L����3���a������ �9 ����Z�o�y�������������: � <(w 0�;����� �����l ��b� ���� ��������������������������������3�o�e�� 38�����7�}�����	H
�
 	��"���������`�����0�\�z�
��<Hk��7����N��������������k���6U6�������	����\���������^�����/���� ���?l� j ? ����������������*���������b�����I�? � � � ]5#�����^~� ����  , p��� � ��>�r�A�m�����'�2 ��=�����D�o���� �  �������� � 7 � v�m�[. ����� "��u��� �t�E�����`�I�"�v�i��r�`���^���'�����(�B���� �?�� � � � 9l?:�v� t Z � # ���n������ �\u l���1��� ���������-�w���U���9���9 � � � 6V'�1-  R he �T�{������; � h  ������- 9 t�,���_ � c ~���x���n�x�����<�����s�������*�O�f &��Ij"K[� ���t�b���/����)��M�V���� � ����H��������%���v�4����� 0 ����w�������f�����Y�`Q�����q�g�f�������6X����������jw�����|���	�������X�Hy`���������k����-�� ��"���|�|���$���� ����4� ����Q�%����� ��; �T� �7|G��������p�� q�%�)�:��������,���������@�e�c���v i	����\�u ��2��/�i���6�� V�>b�J�9 � . ��� �x� ;������ �:� Ag�1�!�s ��G���Q �34���B�����b T ��Q����t�6�� O���3���� $K S���~p� ����� �m� N�W��:N ���2�[���X�V�P�\���'���c  ��_$��	�<��������q�2a��� o�� �n����E�����(�,� t�h�N������� �"[�h�_���O���� �0M ��.�E ^� ( q , ��O����������B������8���e������ ���7��e���1 ��� �- G�E�K��9�������Z���� �Z� }�G�J��� p�=�V � ����@��"<J�
N	x����������L��������	� v�l��d�j ��)������ ��Q�����(�����j�������!�!����-�S ��	�	3]����
���!rW����U��*���%�����U����Rr����+�����1�%�Q��rz  ��p�6��_8Z�? ��� � m��������^�������������������� 4Z� S ��a���� ��5a�`4� l�g�����9����������`����� �"h��S���(�g > ���������������Q�p�n�]�J�d�����k�	�	n�Lq e�Z���������� e ���������4�j�A��}* )��������w�����-�u�������F���q�U�� .�p�f� �� ����.�K�S�`��	7
�9�H�#=�_H�������������9�� �W�����������������g�76� e� ` � �� ������l��2 -�+�����������Ve)�	,  ���������U�X�f���� � m�����f.(�� d0����������9�f/��BKV 7���b�{���e���/�� ��'���0����������B��8��] 7���	 �.�+����� �R �uOb<� ����J�������U�K�Y�� _ � N �  ����������5���'} * ~�����b���3�5���������������j�I�t����+ ;�L����:�m�Gg����������������# A�����
������l���C���w���i�8��� � K���v�n�����5�s�" � Z �#�����k����;������\�� �� w i� 9 N�������� �� ���z�] ����[����M�I���E��t�6��������"��aOH���g��.�m���������� y'�����#�+�
���< ��gc 9 ^�G�����h�������m�C���h���G���y�\��`e� +[|^w��Z����������_�����z�J ���8������M��{
 ,!/���V��-��(��H� �}e J�k�$��y�K�9�T��uk���������D�<���C���I ��E�F�
i��������W�5�-�C�8����:�H��/�2�����\ � 5�q��_�� � T?�K���)��������������&- ���������a���C���������(��	�r�����^������ ��t����P�t�5��� 
�� � �{  ���G��������G�.P����*V | � v�t���^�����` N ��2��f������� ������}�3 �&����r���v���t���� �)������g�!��?<���������k����������
�t�/m�� E�"����	 :� ��0� ��������Q��������������������& 0��&�u ��������� �������������M���7 ���U�v���=
|+�*�� �� ���������W�,�V�[�c�<Z����a��[.� k������3��N ��>���BaC}��~� ����	�	�x G f���� �^�������a�L ]� ������+�������	���, X���5�m � s�prEd�����}�������lx� ����l�8�� ��-�������k���������=Lg	�q��u'�Z�a�� ���M����a ������������������������#����t�/������������*�' � , ��?���B������������S�����w ���| ���| /`��������k�x���j�� W�������������� �%  � ��\������\� 4������Y�o�� v[u f7\Y_R�J� ����#������� :�Y�=��� 2����� Z���S���M�]���u���i�����@�l��������:�{����� ���\	,v6�s���v�r���SP�,d h�������Y����q������/�)�P������ \�4�p�y �j0�@��~��g�����J�r���� `���%�� � � ��$�S�����.�����������; � � � c���D�O�\���5��{�*���$�����K���9�X�����p�5 ��F�M�\�{����*#��6���K�� S�G�=9�S���%�'WY�\V�^����������������5�2�M�'�����a���`�� �����a#%� i�������F�g �9� ;�� �c�������Q��%{�����&������������O���T����{������9�t ��?�I�j�m�*�+����������/���:�
���
L�
��j����ݴ� �-�1�+�����������Y!N���������]��0��������{���;� ��v�'�#��f��l���%���������������� � � UI	�����D���+���S�J�*�����2ރ�/� '�
({$�'�>��������V���cp��.�t�n��c�#�r�����������������T�G gK+D�L�������[�N���� !A��
N~��G	
��������� �;�������y���s������6���	����������������@4� )���B � ���-1[���������� ����=!���C����������7� ��V��� ��8 ����N� /�������7������q /���� &��o| }����e�������i�����y�d���O�#������D^����x�� 1���r�Z�����w �O	��d�<�L K�l�~����J��2	;
C��W�����-�� � �Q�����)�������z��d������������J|��~� I���%������������L �9�k���{�/���	��l�`���� Td���k�-��������%��Kz#4��P��������K4�	��Q�����+�� L<�C�T�����-��q�ASq	/�$���������l�� �������j�`�"	`	�5��������23��� 3�����:�� ��<�#�����z�X�t��)���{�S_g����I���, ���� � �^xi�g��q���������w�s���j�����,���@���{�� 5��i�������6���3���*���T B)	]��)P
�	
I�sM	���)������ ����w���0����������������_2 ����	u
�
�>���� �������1���� � ��l�%23�'5� n��Z�y����.�z�����h�'���������_ �� f �  �� } � " ������: ��������������X�Z�B y � Zw�� ��� ���� ����� J
� ��]�������������R |Aboc�1�FGf�E�;��X�z����}�� � 5� � �'Tb � V C � /  J  C �v$����������)���1���~���1�# � P���\�����v � ������H���.�F���������<�/��� l � � ?�u� F������ m�� � I[< � ���Z27��f�_hy� , V���X�=�=���.�J�)���������s�W�����F�  ]�;�����h�����e � 8 f���"2�} �����.������X�V�9 j� r�kxsr
O� ����7�������	�	�,#�����^�����"�����T���2����uL:�� o�P�����h�����P � j h�����'��������W���� ������3  ��������b���������������~�! ��� D����/�����E! ����Z���� �Of�H�[����Y�gF�H�Q� @ � �� m�v�L � � � � � ����&���Y���y���N�U����������D�� � � g ��� �<��b��d�K�5��0�����������2��� � ���b�����������<�������������������\�� k�s������������Z���Az1�6���"�ި�������	[���#ߚ���0��Lp5��Hf�� ��Y�������� R�p�� e�v���������F������"a��zN�B���f���V�E���l�p���v /��)TB������m�wL���T��ov 6�1����b�������a���� @� ��j�H�������J ��������3�<l� ����x���!W�>���f������<�U V}$K���p�\�� S���/�����'�Z���d������ s�a�/�# � '� ��WH{ a�� ������L�����	�����G`	�
�:����������� d�B2��������	�s�"`s�����X�@�>���t���4�f�]����������q	���� ���I���3v�i��M ����2���������c�o���#�5 ��p����g������;�2�������S<t���*�J1 ��� * MF�������\�����������/������:pM�rS:�  � �  ������������> r
r� ��C�����������"U������F ������� E5 H�d �t� �z����u��O���O ��������r � ����(�'����6�6�<���� ��� J� a "��r��YC�w���H�B���/�#�����]�����e cH����� ����;����8 ��QZ���u�.�2 ������ ����������X ���������7 ��=���%}.� i � �s ��r�n�q� I ��+ � ��`�� ��������o��a�2����f�x���\�,���! n���������������e�P�����i�������X���m&� a ��W�o����  }�v�T����� V F � ��E� � �  ����	�����#  � �, ���������������������������> $M� O�� <�j�� � � � ����G���^���# � ��/��� t H�v� �������Y���c�����y L ��o � p Z � � ���_�& � � � $�X�~��_ ^�E����3���	���c�c � H 1 ^ � � } � �  ������/ � v��v��������m� �t� �������S�^�B�V1�� ��Z����������(� � � ��� � c  ����N�l�|�����c�j�o������ w����j���1� t 8p�� ��~� ��H�t�H � � � 
y n�z�����P 4 ; ��2�3�q�z�������9j� ����* �z������XG  � ������� ? ��������M������f�+ 5 & � s� 2&� ��e���������c�e� G - + ������� Q5eX� � � V � �Z� � o e  J�d�Q P ��x�Y�_�����M e q � 6 8 � R/� !M S�,�G��� ] 7 ��������������_��� � k�S� �� � � ����H����� B���������O ~ 4 < � � ��q���������������� .� ������ �C� � ,� � p ����������� *� Q �� �  �����C���W ��� m�E %� M+| � -g� �����c�����7 � =  ����� 	q� ��X�s�� g ��n�+���� � � ������� O ��������������  ���������Y L � o�uN ��G  ��������u������)� � � 6mk ������0���C���;���z�Q����` � � ��8 - ��9������ x M ����J����������K O  ��}���<���b���- � [ ����= R$�,� � iY)r ��)������v�f�~���g���������t�O���P�2� d   6 � � C  ��r����������k�����R�����I���}���y��[��_ap� ( � RX����P'�����)������n���:�T~� ��������������x�[�.���- �� � � u � � � %n �������2����� � � ;y�i���?���  ���������A�6�����)���p���U�� � � A  < � � T � � ' + 1 ��b���� ,� ��7�8��������� cI� ��( � X  8 � o ����>��t���N�b���T � � � t  ��K�,��}� � ��� � | Q >  4 � x   ��7 O  ������������ ����4 4 ��(���� `  �� � � ; ��W�x�������������v�`���G c 6  �������� ] � t
 ������������K�������H � $� � w { � C ������$����� � ��&���������`�����8   H���h�; 'a ����� LO� � 7 W U ; u k � y ��i�������|  ��J � � d������`�� }�� � c�0������o�����b�e���  ��C�w�$ � � Tf ��@�]��� f 
 ���k����� �� q hY2� V U T ������S�������� 7� t + ��   ������j � 9 ��]���: � � ��O�^�3�6������� T ���-���������������A�4� ���? � }Z h � � � 0 } �   ��7�-�`�  ���� ����  ��. � � & q�U����������������� �����9���� &� � 2 ����_���T � � K ������ ����������. � � ;� ����e��� 1  ���� ��<�@���������M�x����� D 3 & W � � = ��"���@����� 0fm5� z ��������. Z \ ����|�~�1 ) ��h�$������ ��"�T�h�"�7���� �  �N����� ��������) B ����� � � h � � � � ; 0 ����D�!����V������� ��}�`�8 (~ } � �  ����o���������m � � � � � @�� 	 ���������[�# � x����Kn B�������Q � � � ������* V�' d�q����� ��5�������� /;`���   A [ ��D�P�3�O����0�_���) Q ��}���(��� ' U � � X   ��]�|���! J ��x�F � FN� # { � )/0� k � � � ���(�V�������W V ���������� ) _ � � �  �H�a�9����������� ������5 \ � � � i � � 7  �F�����7 � r v e � � ������z�D�r���]���R � ��x��� ��Q�������� � C  ��$ ����N�+�������x���  ��x���/ � ��� [�����b�����!�z�� x�������W����}1o
!	�E�A�*���,��������@�E�t��z���� ����C�����������XF�8[M<��� �����,����#���i���C�D���7���9�*���H�p�����T��� ����O � _�;�{���X=�� ��r���4���������7���7������  ����������� � � � � � u } � � i =  ( � � - ��6���������|���$�����u���������# : � � "� K 5�8�����.���7����  � q � F��� �������� p � �G�V�5� � 0S���O@ ��J����������� o � � ��U� \ ������O�����������
��a����� � o * ��������a����K���b�����T�����7 <  , ��h������z�����!����� X ` � �s� h ��v�h��������� ���� ������������< � � � � ��:�l���! z � � � � � c ��G���4�����] ^ D 1 ������C  o�"�Q�<��� ��A�����8 e L � � k ��-�;�d�@�v�����? c � � � . ������R�I�Y�������m�E���# � � � � : \ v * ��{�n�{�Z�[���# � q� � s v 2 ������ ��O��� q � � � ��Mt ����{���>���m�G���#��B�/�X���0 � � � ������������^�����{����������������� x � � � � � ~  ������~�?�c�L�+�:�5�H�j�������������������������f��� J � � � � � � � � > ��Y � � � � � � ������?�8�g���? P � � � } � � � � � o ������ ��~�[�V�t�����S j j � � Y ? T � �  ��^�����w�d��� ������a��������� ����F�!�J�K�_�����v�������
 ������������( � � � \ Z j < � � � � � � � � � G &  ������5 @ a � � ^  ? t r � ; = # ��������������f�*�D�}�����e�x��� ���������V���J � � ? 3 �  � > ������- O <   M � � I � � � b _ � Y ] � � ^ , ������ ������
 E  ���������� 8 + ����V��/�w������� ��F�~�����j � � I V � � � � ] ����a�M�O���, n l R ������������B v � � � N  ������k�6�`���" Q � � 0   ��������[�\���* 0 D � u ����U�A�g�r��� 3   ����( 7  ��������  ���� 6 ; - + [ < A P   ���i�j���B � � � � � � � � " ��Q�������������� `  ������D � � S ,    h e 0  ����������������^ x � 8 ����������������V | % ��������	 " ^ l ;  ����w���������������) O i b ��������< (   ���������������������������������������������� ����$ � � � M  �������������� ������$ = ��������F���{���A ������
b� ^����X�n������J���;$��p}p 2�����b����5�������� Z}� � ������@�Y�o ���,������� ��g���B � T]� l � � 9 0�j������_����� � I{��o:��&���7�#���W������� TF1Sc��� ����������D�S���f � � � �f�N�!q ������r���F������ fB� j � � � � g F ����������l��������������3 \g���F�����y�t�� HZO���J )���8�o�i���7���T� G��;R>u ��^���5��� e�o��D& ��������� � � � fK�1� ��}�d�m�?���w���+ � ��7� ����B��G����� ��������� J ��.�����k���
  k � 6ub+.9$Cx : 9 ������� � � � � H ������������ ���� V � a  ��L�����o�{�����������Z���7 e j s C $ ��������~�������= s � � � :� L ��[�\�-�_����� " ` � 	 � ������������X���	 � � � � y j / ����j�Q������V��� S � � � � C ��'��0�W������� ����������������G � � �  ��f���������������y�c������q��J��� ' ��Zl����1����:�/�"�����b��u	<}Z���������OP��u�����V�	N%�M���c�������?�'|
�8L���L*����������q � ����������� I�� ~�V�8���2�[������ �  ��R�����w < ��p��� � � _��w���m 
������������ : ��. E Y � . b t g�'�f��f�Y�y�>�����������������EF������>�m@�  � b ����c z � ��� ��+�,�������!�J����� ��B��� �� ��M g����%���� �+��������6<L��:���}���1 FG�]�T�����e�,Is��G�����k{��C�t�� �|���� � j������ ��v h � Q $�}���ag� q����R���[ ����B ����J  D�����O��� ��K W c � �r�d }? ����e���(  d � ���(���- ��� � � E ������������k @ ��� i � � ������^���#�����/�y�8�����T�� b	��C��� `���u�E���6��Y�R���Q��b������U������ �4�
�

����	|��A�������������0N�����u��5; ?�����A���6��@���Y�� J��S���x�aR *��j��m� ��� �  � �  P��S�& � � j����r���A�=� ��� � 6 <���,�a:7" �� [� " ������� � � U  �X��� F�N������ �� �� ���� ��k� �& m F�
���`������ ��������[�����m�� ^�(0 �9��� �B����8��������� �C��� > ��_�����#�,!�B�������������������4�����U�;��  �C H�����X� 3���� � ������� �o�^ t���*�4���I �������� �H�U���?�S���I������q���> h % Z�1�Q���|�A�2 �\Cu?E�� -���{�d���K�@�������0���
����� ]�|���; 0 ����� L� O�� ������ �� e,*G�r Z�3���������������6�������y���P1�� ��j���������� � ����z��g ?�'� G ����������� � X b�6���Y / 1 � � H h�I����� [  ������ � | ������ ��$ � =ey + t ! d � � � ��<���C�|����� � ������Z�Y� � M���f0z�R-� >�� ��he ���� �  
�x����������	V�(�c� n�����������K�K��������������	� O�G�r�U�����������a����� H������V�&�c��������������������B�J���@�� ������x�����1zVQ� #� � � �������������� I�N� g  r��������?����l������i�}����������|�_�����e�s�w � � ���������8���f MFQ ����� L@� _����WR�S ���� � ���R�  r���o 1 d��N�����G�	�v�������|�����	�z 1�v� � Y39Z��\���>�- � �����K�a�#
�������}�
�H���$ U ��$ ��v^�D����=�S����>�����A`�V�����r��������Q�� d  ����������$ � � ��H��9��.��j�����n�4����f�G�F�*���U�~ ��4�� �9���P�
�=���3�V
p9��y���& I�������lo	�	q��U] C�����'��������. ������s����~J =���e���%���=�e��������� ,�� ������jc_$������� z�l�A�0���4���L��� �-�]S�L�d�|���o �� Q 0 � /�@2mW�w�����w�f�N�"� ����
m������`����S�
2j;�����s�^�{����i� ����������u�l�� )&���]�I���9�V_S���	�� ����{�����S�������>�D�U� �A M���m�_�����D 5 ��|��� �����������D���=������� �3�N ��G�j�{�����d���Z���� Q� 7��  � Q�?� p y�1��2�u�q�) ������ ��*�\��  ��{���S ^^]�R�  ��i�! h��� ��M�w�������a�����>�\�~���w�y � � �� �c�����% � � � � � `h ��f�����@�*��pP9 � v�5���\����|��g�� ��W�s��� �i�) ��i6�Q �������F�s�O������m���K � ����}AN�y���8 �m��. � @ ������E���t�_���v��F�����d�����F � 2 : � � � Y�:�E����X�����t���G � s ����< � � ) ���� } ' ����z���F ) ��v�����e �g&��/���i � :"�'_WXe��q�!P�	�E��������������H��	�����R�	3
T��&	�	����C��� ������R�����	<��@z�[���k��������y�r������ ���t�^�����+��������h���~��+�/<�����K�d�)���Y���T������ O��V�����5���R���p������������q �!$�P"��������h�~�-�Z�������r��q���������C[�	�
9����`5����n"Kh��,�X�)	,	�����	��f�`�DW	����y���)�]� ��
�:���1���;  Q��g���� :/� z� ���43 ����H���q�K���1�Y�� �c%a � ������������ � m)���V��lj� ��;�i�S������* � v����[�g���������X�� ����� ���� �3�����T��x ������C�. � �  p���d�����H�_ 8����/On � 9����o �� ;�c�8����>���X ����  ��@�"����� ���9��qA��� �� ��8���n�S��� ��l � # �-���1�yk:t ��������(��������<�� S �� ���� �
:� ��|��� ;�%���f7���9���V�u�Q�����{�[�S������ ��~[ �������* > 4�\������ #�X ���f��������� i `�}�/�� )���� P���| &rC) l ��o ��� d� n  @ 1 �]�Z U* ����8 :: �� ~ op ��IY3��8�V���w�J��>�v�����0�_�*�o�� � � N� & b�f� ���q���! ����������� C ��������b�2 O�lI  �>�����d � � �  ��B ��.��*� � �������  o���� �;m ��6���� � [ c � � ��_�H�0����� ���|���� �  ��3 E � � 
 1 Z ��O � � ��������p�p�\ r ������8� � � � k ����C��X�C�m���0 \ ������ �� ��p� ^� �e� � � � / ����r�I S �������'����%� � � y ; ����� � -� ��g�c���
  ��  P�0�x����  � � � 
� �� � � � U <  ����c�-��� ������Y�����K�������3 y � � � � * ������ � 2 �� ����z��� ����W E @ @ ��R � � � � � ; ����B�������������Z���I���> � h ����s l ��y�h���Y����=����������{ � � V . t � � r � � � ! ��R��������� I� m   ��� � � ~ : G � i p�k�}�!���������H  ��Q�,�K�������m�~���� E�h�    ��7����s P ������, ����A � � ����������� �����= l D . 
 ����d������� &    <  * X 9 0 % r �  J� �	�P�����������{ � � ( ��' � V  ��������( H h 1  ��' � R ����5 � = ��1�
���   X � v 9 ���� 0 q � X  ����������Y����������� l r j � � % x�m� � � g ��"�s�����K � � � C ������ ����|������������� $ " R F  �������� ����������������������" o R ����������
 � 4-� ,  g � � j 9 L M / ����L�������   ��+�+���
    ��  e z 0 ��A � � ��N�[�������q�Z�����������v � k  ������/ 1 � � > ' ����2 � � Z # ������q���������������; � � ��T ��.�7�����>������0�y����� ��������������  Z e q � � <  ~ w ��������u��� p � _ ��9���
�	�%�V�����������4 � m ������ ����\�\�g�Z��� Y / 3 $ ������" � � � � #X� H 0 ? ��) � � ) ��V��L�������m�O����������� 
 ������������  / "  ��������;���& � ) ������������ _ � BR� I % E n 2 �� ) S U ��������q���  ! C F T < ��z� �|���	 	 ����������������I � � �  ~�x���j � +� W y���j���!�J�Q�R�\����� � $+� 2 ������T � � k @  ����f��J���# � � � � � ~ � � � � F ` z V I / ��n�b�����������*  ������    ��������S�;�v���) H ����������m�@�=�p��������� ^ u i J T 	 ������������������ $ ��B���! G P � z V ��x���J � � � � < ��������Z � � �   ������ &  ' � � 
 u�������e���������������O q L   . M ! ��(�Y���
  ����  b p E  ����M � X ,  ����6 G  ��u�m���������S�������X���������* � � $ ���� � � (� � ������  ���� . * <  ����������  ���� K ^ 2  A N 
 ���� ;  ������Q M  ��[��������� 3  ������; y F ��l�n���  ����'������3 � � � � � N 4 ����3 3 <  �� 2 J ] 0   �������� ����������������; Y � � Y I o � ��g� %� p ������~ � d N�� � �  �� ; + ��;� �����k������:�J�d�M�����p���� � U p � ��M4��� ����Y��������g������������ +F� m K l � � � � � � � � � � y ��C���#�����$���j�k���H�f u��K� � � � � N   ( 9  ����������l�����q�����N�=���3 � p3� � � R ' E � � � � � � ��������������g�S������� r o > S p { � u 8 ����# ����W����������9�X���- [ s 2  I a | � � � ^  ��  2 D ] x ~ : ��t�p�L�I�{�h�E�?����� + !  ��y���@ � � � Z 0 7 % ����������+ 0 &   ����������������J m � � � � 6 ������% O S  ���� ��������> C : $ ������������������� g a ' ����]�}��� ������ R � � i K b � � B� C   	 7 G I f S ' ����
 ����g Y 2 -  ��������V � �  ����x����w�������������P�;�j���, R 4 ������������b�g�`�>�W�k���j�G�i�U�:�O�����? t D ��Y�R����� .   �������� = a C   2 F Z ` % �� ` � k S \ x P $ E y � � � x / ������������������������ $ ��������  1 ������? � m Z H Q � � � � > �������������������� e L      �� X G     @ g B   ��4������� ������������ v � N  ����^�3���! { d : M H  ����H � ( �������� ��o����� �� ! ���� \ � c j k � � a 5 b � � �  �� I d    ����������"  ������= \ c Z K  ����G 0 ��������������������������  C ] D  
 ���� = ����"  �������� ���������� P ; ����  ��b���������������������= b =  ��x���
 ��  ������  ����D r � K ����������  ��  %    ����4 o p . ������" . D \ ) �������� F b > ����b � M u�\��B�6�����i���|	�
�?��������T�8�!?� &���n�����8 ������,�R ��M��������}�^�~���)�(�DO��z�j����/�~  �y7 e�=������ �=lX�� ����� & ^�S� %k� M 8   ������j�����C���G�s���+ j #  ��b�������s���� �  ����� � � G � Yv J�����s Or� $ ��\ ���  ��y���m �������w g!� x � � ��������� � � � ��5�����������5�X�d�f�4 � vn: 4�I���� *� � 0� /��������� T���g � s 0�D��� 	G� �� �]�O�	�������� �S�e�3�����G�\ �������X�< � � � ( !���f�S M	k ����E�?���E{O� d��������� � � � � ��M���B O �����U�������"��ig����h������"�� ���t������ �����R���d������z���] (u ��c :�e��  ~�M�Q�����V���� h�\�� ��������m����K�a � � � � @o^��Q� ����, o � 0� :Z/� ������������� " ��J��u�H � � � � % ��8��|�U � � � �s � 	T� ��G��'�����y�W 9U� g  
 � � ��A�������g� � � � ;  d � c  ������-�6���=ID K�Y���& ���� ��<��R�J�C�[���������. � � ' ��� �<}�� _���y �  ����) � � $ ��6�����������9 I ������i����^����� a ��g�*�%�k���= � � $ 2��������i���; 1 �������X��������� ��n�����_�x��� � � � 0P� � I  ���F�/�4�"��)�C�H� ����������W��T���������5 � ` ����S � :    �� ����q������n�i�����B ] ,    ����  ��������  ����� (G	� 1 ����a � P ��  d � i , . i n / ��������������������������  ��������� � � � � K   = ? \ � L   ������ 7  ������ y � W   ����h � � � 9 ����\ � � x  ����-  ��������8 7 / ��t�����������������������   ����. � � s '  ��������	 s {  ����T � I + 9  + K o � � � � _ ��g���
 � (M�  ��~��� W � � � � Z  �� ��/ + 	 �������������� ��k�������L O +  I s 1 ����l�������������|�k�t����� F a L 0  ��������k����������� ���� ���������� . ! C C    2 2 0 - (  ( R h 3 ������ m K  ��������������  " N j N U � h &  ��������  ��  ��������
 ) K _ =  �������������������������� 	 ��������- .  ��u��� G ? ������     �� - O � _ ���� | � { z J >  �� - W i H  ��  $ \ v P Y 8 �������� ) 5  �� N c o i /  /  ������  �������� T u s j  ������ +  ����������X�e�����������������������a�G����������� ����U  ��	 W��������B  ����Q d  ����j�q���% 4 
 ������ ��������������}�Y��� 7  *   0  ���� / ` l V   	 ��     	 ���������� " H u s \ 1 5 2   ( 8 ��������  	   D ������a�K�B�f�����������	 # ������ 	 ������������ �������������� ? � 9 ������2 m � H ������! F M E = 1 &   �� - / * 6 1 +    �� D ? & ������? [ C  ��  " G k g   ! 0 & 7 >  ��������    ��������	 " 4 - $ E Z f <      0 ����k�����$ � [ ������������+ � �  ��`�s���` � � c �������� ��������������������2 L 2  ��     ���������� ; <   ������^ � P  ��   ����0 C < +   ��5 >  ��������   �������� C : * �������������� J , ������- : @ < ����������   �������� & /   ������   ,  	  ��  % F . " / ������������	 8 C  ������ , /  �� ���������������������������������������������� ���� @ F / @ U h f ? ! 
 ������������������������ ����������������������������
 ������������ ���������������� ��������   ���������������������� ����4 P W 9 
  ����) / - G V U 5 ��   B y � v Z " 
 ����5 W j z d Y L 6 % 8 m � U U ?  ������$   - ���� 7  ������J R 3 ���������������� ] T / K U  ����}�����!  ������ L 6  �� ` < ��g�=� �I�r�������l�X�m�E�b�����������C � J \ � � x  �� k X ������������������������* Y p � � � � � � � � m ���� 
 ���� ? y p o � :��i6� � � � � X ������s�{�d������"�P����� G G  ��������������������  5  ������& M V c w � � � � � � x � z O  �������� . B 4   �������������������������������������������������� $  ����l����������������k����������� R 9 ��������  �� ��    ����������������? D ������ m � � \ F  ��  ����, B *  ��������������2 A  �������� , ; Z 0  ������& D 8  ��������������A � G	� . ��������p�������i�t�w�7����q���������������     E f M > f s { � � S I 1 8 R > ' H Y b a  ������$ A  4 f q Q ������t�a������������� %  & 2 & 9 4  5 _ C 9  ���� I T Z F  ������������o�����������u������������� B M P P H E ? #  6 ] � f P Q %  $ 7 (   	 ���� �� �������� ����  ������ )  ���� * U f K 9 & ���� > O 0 ���������� " (   ������������   ������������������������ �� ��     �� 2 B H 9  & 1 E  ��������   ����������������������  
 ������0 = <        Y i O ,  ����   ��   2 G S N 9 1 0  6 P !  ��������������������������  ������% + '  ���� % * < N  �������� 	 ����������  J G B 3  ��    ��������
 �������� 
 �������� ��������������/ (   ���������� 8  ������������ ������7 V ^ G  ���� ( 3 ? F P B $  0 1 7 D B R ] Z B =  ��   ������  ��  ���.������ �+�d
�A������������� � ������w�w����(�����n���  d#�� ������S�)��8���t���? 	rt o # ]�������k�����i�j���] � � a ��x���S � *`u\uX� � l & ��A�Z���6  ~��5�������������������������* o � � � I  ������������9 ^  ������ & 6 D (    ' � � � � Y ������������������������C y � � � l ����M�(�'�&�Y��������� } � � ~ H e � � + �������� ������	�Y���i���y� � 7^ =���������j���  4 ; - # = e � � � � � � y V E  ��  ' '  �� ` � ou� � � � � y 7 ��������j�~���u � � � � ��)�����}� ( I 5 �������� = ] c - �������� 	    5 5 T g � � g o n ����� �,x����s�� � ��� ����� ��w�� �(��_����� �[����X���\����������F�0�97]�k�j������z���k � � � � < �������� k J�� ��	���3  G���s�����)���% f t � � 
�  d�;���- � � � � � 6 ��\�(�=�������f�<�E�{�����) i � � � ��H����l������������������ /� G ��i�����- R Y x k D 2 ������& 3  ���������� 8 m W   ��������u�\�S�E�!���������/ � � � � � � � � =   ����{���H � � ~ ( o � :7+� � � � � A`N ��7�5�u��������������D�<���� � �  ���� �������� ����[�V�������U��P���
  ����������������  ^ } � � d  ����������|�{�_�Z�|���������  �������� 5 D S = (  ������������������������x�d�����   1 > u ~ � n A 3 ; S U < ) 
 �� �������� ����������������   ] / ������ & ���� $ T o K  ����������
 A L 7 �������������������������������� # N � � 8 �������������������� G _ O T c ^ ;    N G 8 1 ! = U L M : ) % ��������  ��     8 3 ���������� (     $ 1     ) " �� ����  ������$ 7 .   ����
          ! 0  
   , (       ����) 7 8   �������������������������������� B Z o I  ���������� ��   ���� 3 M : & 
    + 0 ? E C 0 + 4 3 J 6 0 ����) ! ���������������� 6 ( ��������������   " ����	  
     ����������  0 O ,  8 1 . A F 2  ��������������������  �������� 1  ����������w�����������  ��������0 K ;  ������r�~���������������������������	 ( 7 !  ��������������	  ) :  ������������      ��   " ) 3 1 $  ��  �� ������������ �������� '    ! P T B ,    ������������������������������ 1    ���������������������������������������������������� ! ;  ������������������������������������ ' N Y D - + 5  . @ : 0 = \ p L / < < D F D f w f ;  + ,       / . +   
    �� 	  ��������������������  ��������) G c X -  ������    
      �� ����������  ����������������������������������������    ������  ����������������f���b���`� A�.�[����J � ��� P�u�D�_���I U ����� �r� �������������+����� ����t -� x ������Y���c � � z ���������I���  O � t����(�  �������������� ����������    . Z Z @  ����������������i�7���2�����l � � � � 	3� � � & ������������������  �� C H g � � Z C ? F V  ��x�u�������n�}�����1 Q > 8 1 D N G  ������������������������������   ( B \ w x g $ ������ - A R 6     ���� \ � � � R ������}������� ��������������������" 4  ������   �������������� 8 
 ����������   ������ '  	 ������ ����������������������������  ������������������  "  ��������
 % : > 2   ������������8 6 I K C X C    ����������   ������	  ��������     '  % & 2 6 ������������������  ������������	       ������������������������  !  
   . A  ������
 
 ����������     ������	   "  ) ! 6 U =   (    ��   (   +  ������������������   )    ������������������������    #  + 0 B @ 4        $ .  # % ����������   �� ! 1  1 2 %   ������������ 
  
 ����������   	  	      > 6      & 3       ���������� 5 "       *         ��������  ��������������   ������               ������������������ ������������������ ����������������������������������u�������������������������������������  ����������   
    ��������* )    ��������������  �� 8 = )     ' : F ^ b /  
 �� ? E ( @ T . % 2 G X f Z F D D S [ L T � � �������� �������T�� �5 @$LsG ������_�4�I�f������{���e�j�V ����)������$��� � m8� s � ��� pm)@� � # �����l���9�*�������Q�F�����"�y� �P�� �����������x�����L � Mg� h  + � � � � � C   G { | u x k I ��������Y�S�����������������H�>���������� } � � � @ �� 6 ��  , ��������������v�����3 4 ������ C D  �������� = 6  ������������& -  ������������, u { 1 ���� e � $ ������������k���������k�L�1�U��� $ * 3  ��w�2�X����� | � 3  �������� < E 2  
   ��h���� AZ� C ��X���������� �]�y�� w�+�W�V�,�_�= � � `p+�  ��k�q���# � )K� z � � � � � � � : ����Y���<�����J�������+���H ] n � � � 4  ����������u�W���h� H h � � n I F A  ��|�������= P ,  N n < ����q���+ w � � � � g N ? : - * * , ! -  ���������l���������������������������� / A B %  �������������������������� ��������  < X Y 5  ������������ * 3 8     	    @ J R Q d e K L =  ���������� ) 9 K D +  ������������������ F K 7 7    ����$  ������������z�n������� E <    ! + , ' &  - 1 5 - ' / . ; K L *    �������� (  	  ��    �� >   ��	 ����  & \ e _ v c , ������������������������ / - A c D &  ���������� 2 9 * !  ��������  ����   ) 4 '  - E :  ������   �� ! # ( . "  �������������� 7 = L :    ������������������������������������������  ��    ������������������������������������������	  	 ������   
     �� %  - C  ���������� 1 B X V 8  ��������������������  ����������������  , &   ������������������������������������������   ������������������������������  $       	 ��  
   ��������  ������    ������������                '  ������    ������������������������ 	     �������������������������������� ������   ��������          ��  ��
     �� * . %      # * '   ����    &  	 ��������
     !  
    #      ����������    ��������������  ������   	  ��
  	   �� '  ! $    ������  	        # % % +       ��   
        #   ������������ -  ���������������� ��������        ��������      ������������������������������     ����   ��  ���������� ��      ��������   ��������        �������� I � � �  Y * ����������x�E�!��3�f�����% 5 6 > E X Z U G (  &      ������ 0 @ < 7 / / '     ������   ����������������������	 / 8 - 7 #   ����������������������������������������  ������������������������������  #     . * ' ( !    �� 
  $ / & 3 ; < J b W I P N < 1 #   
 & (       #    
 	        ! > @ V Q H j � � � � � � 7 Q���7�����b�%�M�������v � � � J ����N�4��*�C�E�W����� 9 | � � 2i��=� O ���������������������( e � � s T 1 / > +  ����m�J�L�F�[�}����� /   < N U c u n D  ��������{�o�k�b�V�i������� : b v a ` M ; 5 C 5 ; = 5          ����  ! 3 $ " ( +   & - ; ? $  ���������������������� # , B ] Y O D ) ? H 7      ����      ����������������������������������������������    4 5 	 ����������������   4 9 7 > ; > ,   '  ������������������  7 : E < 8 -    ������������������ 4 5 "       ������������������  ��������������������������    ������    ������������   ������������                  !      " &  !    ��������
    #  ����������	  �� ��    ������������������������    ��������������������������      ��       & %        	  �� ������          ������ ����  *         ������������������ ����   " #  ����������i�D�K�~�����Q���������Q�K1~�Q� 4 ����=���(� �����-���,�v�����V�y +TTb��w�{, �g�� ���Za������������h����B�T ���� � { � 2 ��������������K�R�
��������l���;�4���h���.���������j���/������� z � :} ���������� � <wv}��@� D ����   	 . t � � � � o e � � � � 9  B } � � _  ����	 +   @ 1 ������ /  ����6 � � � { 3  
  &  ����g�g�u���������_�+�U�����t���������N��� 6 : 2 ������ ! ��J�^���" z � X  ������ 1 $ ��������( 5 _ � � ] E J e y [ < ? d � � � h A ���������� _ x ` 7 # E � � � y ) ��������K � |  ����������~�m�����������������; O ?  ����    ���� ��������������������t�����������������  ������������ . G $ ������ 4     # G W X U %     ! : A : E ; %     ���������� ? a j U $  ����������  ����	   
 	  �������������� 1 J J W T E  ������������ $ !  ������  	  ������������������������������������������������ ' 9 (  
  ��          ����������  , 6 < 1 (  !  ����
 . > 6   + < =  ������  
 & "  ����������������  ����  ��������������   �� 
  ��  ��    ����   ���������������� " + %  ����������   
  ������������     ����       ���� #   
 ����         ���� ���������� * ) #  ������     ��������   ��������      ������ 	    ����������  ������������������������    ���� ������    ��  ������     ������ ��������������  ���� 	     �� ��������  $    ����������������	  ��������������     
     ��   ! & , .  ��    	    ����  	 ����������  ���������������� ������������  ������    ������        ��  "      ��             ��  ���������� ������������������������������������������������������       
 ��     "  "  $ "                ����         ����������������  ����������������������     ��������������������   	   ��������������������   	  
    % ( !      ��   ����������������     ����      ������  ��  ������     
       �� �� ������������������������������������������������     
 ��������      	 
 
  ��  ������������            ������  ���� ���������������� 
     
     ��������������������   ����	  ��  ����     ������������������    �� ���� ����   
      ��          ��   ����������     ��   ������������    ����������  ��  ��
 
                ���������� ����������������    ����������      ���� 	    ������������  �������� �� ����   ��  ������������       ������     ��������	  
     ����   ����            ��          ���������������������������������� ��        
   ��������������������    ���� 
            ����   ����������    
     ��    ������     ��     ����������     ��     	  ��    �������������������� 
 	  ������������������������������������������������     ��      ��������  
      	        	       �� ����������    ������     ��     ��                  	       ������������������������������ ���������� ������    ! # 6 I H F H 8 8 %  ����������������       ��  ����������������������������������  ��   �� ��  
     ������������������ 
    #  "   ��������������������������   ����          ����������������������     ����������
      ��           
 	    ���� �������������������� �� ����������  	   ������������ 	 	    	     ��������  ����������    ����������	   ������������    ����������������������   ������     ��         �� 	        ������ �� ��    ������   
          ����������    ��   	     ��      	 ��   ��   ��	   ��   ����������    ����     
   ����       ��  ��������     �������� ����       ��������������      ����       ������  	  ����������    ���� �� ��     ��  ��  ���� ��������    ��      ���� 
       ��������������     �������������������� ������  �� ��  ����     �� ��������          ��������������������  �� ����������           �� �� ��
           �� �� ��   ��     �� ������  ������������   ������������������   �� 
  	    ����     
  	 ������ ���������� �� ��   	  ��������������  ����������������������   
                 ��  �� �� �� ��������������������������������  ������  ��   ������������������������ ��     ��������      	    ����������       
   	  ������������  �� ��   ����   ��������      	 �������� ������������ ������ ������������������������������������                      
           	  
  ������������������������������������������   ��
  	 
    ��       ���� 	           
     
 ���������������������������� 	   ������ ��    ��   ��      	     	     ��    	      ����������     ��������  ����������������  ��  �� ��   ����������������������    ������������    ��       ����     ������  ���� ����������  ������ ��  �� ��     ��   	    ��   
            ��       ������������  ������������   ��   ������������ ����������������	 ��    �� ���� ��  �� ��
    ��      �� ����������   �� ������������    ��          �� ���� ������ ��        ��   ��	       �������� �� ��������  �� ��  ��������  �� �������������� ��    ������  ��    ����������   �� ��     ����������  �� �������� �� ������          �� �� ��	 �� ������������ ��        �� ������ ��         �� ������    �� �� ��  ������ �� �� ��          ��     ��������  �� ��         ����   ��    �� �� �� ��          ��     ����   ������     �� ��  �� �� ��        ������ �� ���� �� ��   �������� ��  �� ��  �� �� ��������       ��         ��������  �� ���� �� ����    �� ���� ���������� ��           ����  ��     �� ��        �� �� ��  ���� ���� �� ��  ��  ���������������� �� �� ������ �� �� �� ��  ������ ��               ���� ��   �� ��  ���� �� ��      �� ������������ �� �� ������   ��     �� ����  ���� �� �� ��  ����  ��������  ����  ������������     ��     ��     ����������   ����������        �� �� �� �� ��  �� �� ��  ��    �� ����  ������������  �� �� ��������   ��     �� �� ��  ��      �� �� ��       �� ��    ��       ����      �� ��       ���������� ��         �� �� ��  ��   �� ������ ��  ���� �� ��  ��   ������ �� �� ��     �� �� �� �� �� ��         ��      �� �� ��   ��   ��    ��       �� ����     ��          �� ����  ��  ��������  ��   �� �� �� �� �� �� ��   ����  �� �� ��      ��      �� �� ��   �� ����������         �� �� �� �� �� ��       �� �� ��       ��     �� �� ��           ��     ��  �� ��   �� ������������������  ��   �� ��  �� �� �� �� �� ������   ����������  ��  �� ��  ���� ��      ��   ��������    �� ����  �� ��  ��   �� �� �� �� �� ������        ��       ��  ��    �� �� ����  �� ��  �� �� ��  ��        ���� �� �� �� �� �� ����  ��   �� ���� ��  �� �� ����      ��    �� �� �� �� ��   ��  �� �� �� ��    �� �� �� �� ����  �� �� ���� �� �� �� �� ��          �� �� ��  ����   �� ��       ��     �� �� �� �� �� ��  ���� �� ������������ �� ��         �� �� ��            ���������� ��   �� ����  �� ��  �� �� ��  �� ��           �� �� �� �� �� ��  �� ��  �� ��   �� ��   �� ��  ��        �� ��   �� �� �� �� ��         �� �� �� ��         �� ��      �� �� �� ��          �� ��   ��   �� �� �� �� ����  ��   �� �� �� �� �� �� ��   �� �� �� ��     �� ��   ��   �� �� ��   ��  �� �� �� �� �� ��       ��  ��   �� �� ��   �� ��   �� ��   �� �� �� ��  �� ���� �� �� �� �� �� �� �� �� �� �� ��     �� ���� ��   ��   �� �� ��  �� ��   �� �� ��  �� �� ���� �� ��              �� �� �� �� �� �� �� ��   �� �� �� �� ��   �� ��         ��   �� �� ��   �� �� �� �� ��   �� �� ��   �� �� �� �� ��   �� ��   �� �� �� ��   ��   �� �� ��   �� ��           	      RSRC��!F�T[�[remap]

importer="wav"
type="AudioStreamWAV"
uid="uid://bp86baaa7jbmm"
path="res://.godot/imported/Hurt.wav-fa669c5cd596766b67f3681b8253515a.sample"

[deps]

source_file="res://Hurt.wav"
dest_files=["res://.godot/imported/Hurt.wav-fa669c5cd596766b67f3681b8253515a.sample"]

[params]

force/8_bit=false
force/mono=false
force/max_rate=false
force/max_rate_hz=44100
edit/trim=false
edit/normalize=false
edit/loop_mode=0
edit/loop_begin=0
edit/loop_end=-1
compress/mode=0
� ��cB-�GST2   �   �      ����               � �        &  RIFF  WEBPVP8L  /������!"2�H�l�m�l�H�Q/H^��޷������d��g�(9�$E�Z��ߓ���'3���ض�U�j��$�՜ʝI۶c��3� [���5v�ɶ�=�Ԯ�m���mG�����j�m�m�_�XV����r*snZ'eS�����]n�w�Z:G9�>B�m�It��R#�^�6��($Ɓm+q�h��6�4mb�h3O���$E�s����A*DV�:#�)��)�X/�x�>@\�0|�q��m֋�d�0ψ�t�!&����P2Z�z��QF+9ʿ�d0��VɬF�F� ���A�����j4BUHp�AI�r��ِ���27ݵ<�=g��9�1�e"e�{�(�(m�`Ec\]�%��nkFC��d���7<�
V�Lĩ>���Qo�<`�M�$x���jD�BfY3�37�W��%�ݠ�5�Au����WpeU+.v�mj��%' ��ħp�6S�� q��M�׌F�n��w�$$�VI��o�l��m)��Du!SZ��V@9ד]��b=�P3�D��bSU�9�B���zQmY�M~�M<��Er�8��F)�?@`�:7�=��1I]�������3�٭!'��Jn�GS���0&��;�bE�
�
5[I��=i�/��%�̘@�YYL���J�kKvX���S���	�ڊW_�溶�R���S��I��`��?֩�Z�T^]1��VsU#f���i��1�Ivh!9+�VZ�Mr�טP�~|"/���IK
g`��MK�����|CҴ�ZQs���fvƄ0e�NN�F-���FNG)��W�2�JN	��������ܕ����2
�~�y#cB���1�YϮ�h�9����m������v��`g����]1�)�F�^^]Rץ�f��Tk� s�SP�7L�_Y�x�ŤiC�X]��r�>e:	{Sm�ĒT��ubN����k�Yb�;��Eߝ�m�Us�q��1�(\�����Ӈ�b(�7�"�Yme�WY!-)�L���L�6ie��@�Z3D\?��\W�c"e���4��AǘH���L�`L�M��G$𩫅�W���FY�gL$NI�'������I]�r��ܜ��`W<ߛe6ߛ�I>v���W�!a��������M3���IV��]�yhBҴFlr�!8Մ�^Ҷ�㒸5����I#�I�ڦ���P2R���(�r�a߰z����G~����w�=C�2������C��{�hWl%��и���O������;0*��`��U��R��vw�� (7�T#�Ƨ�o7�
�xk͍\dq3a��	x p�ȥ�3>Wc�� �	��7�kI��9F}�ID
�B���
��v<�vjQ�:a�J�5L&�F�{l��Rh����I��F�鳁P�Nc�w:17��f}u}�Κu@��`� @�������8@`�
�1 ��j#`[�)�8`���vh�p� P���׷�>����"@<�����sv� ����"�Q@,�A��P8��dp{�B��r��X��3��n$�^ ��������^B9��n����0T�m�2�ka9!�2!���]
?p ZA$\S��~B�O ��;��-|��
{�V��:���o��D��D0\R��k����8��!�I�-���-<��/<JhN��W�1���(�#2:E(*�H���{��>��&!��$| �~�+\#��8�> �H??�	E#��VY���t7���> 6�"�&ZJ��p�C_j����	P:�~�G0 �J��$�M���@�Q��Yz��i��~q�1?�c��Bߝϟ�n�*������8j������p���ox���"w���r�yvz U\F8��<E��xz�i���qi����ȴ�ݷ-r`\�6����Y��q^�Lx�9���#���m����-F�F.-�a�;6��lE�Q��)�P�x�:-�_E�4~v��Z�����䷳�:�n��,㛵��m�=wz�Ξ;2-��[k~v��Ӹ_G�%*�i� ����{�%;����m��g�ez.3���{�����Kv���s �fZ!:� 4W��޵D��U��
(t}�]5�ݫ߉�~|z��أ�#%���ѝ܏x�D4�4^_�1�g���<��!����t�oV�lm�s(EK͕��K�����n���Ӌ���&�̝M�&rs�0��q��Z��GUo�]'G�X�E����;����=Ɲ�f��_0�ߝfw�!E����A[;���ڕ�^�W"���s5֚?�=�+9@��j������b���VZ^�ltp��f+����Z�6��j�`�L��Za�I��N�0W���Z����:g��WWjs�#�Y��"�k5m�_���sh\���F%p䬵�6������\h2lNs�V��#�t�� }�K���Kvzs�>9>�l�+�>��^�n����~Ěg���e~%�w6ɓ������y��h�DC���b�KG-�d��__'0�{�7����&��yFD�2j~�����ټ�_��0�#��y�9��P�?���������f�fj6͙��r�V�K�{[ͮ�;4)O/��az{�<><__����G����[�0���v��G?e��������:���١I���z�M�Wۋ�x���������u�/��]1=��s��E&�q�l�-P3�{�vI�}��f��}�~��r�r�k�8�{���υ����O�֌ӹ�/�>�}�t	��|���Úq&���ݟW����ᓟwk�9���c̊l��Ui�̸z��f��i���_�j�S-|��w�J�<LծT��-9�����I�®�6 *3��y�[�.Ԗ�K��J���<�ݿ��-t�J���E�63���1R��}Ғbꨝט�l?�#���ӴQ��.�S���U
v�&�3�&O���0�9-�O�kK��V_gn��k��U_k˂�4�9�v�I�:;�w&��Q�ҍ�
��fG��B��-����ÇpNk�sZM�s���*��g8��-���V`b����H���
3cU'0hR
�w�XŁ�K݊�MV]�} o�w�tJJ���$꜁x$��l$>�F�EF�޺�G�j�#�G�t�bjj�F�б��q:�`O�4�y�8`Av<�x`��&I[��'A�˚�5��KAn��jx ��=Kn@��t����)�9��=�ݷ�tI��d\�M�j�B�${��G����VX�V6��f�#��V�wk ��W�8�	����lCDZ���ϖ@���X��x�W�Utq�ii�D($�X��Z'8Ay@�s�<�x͡�PU"rB�Q�_�Q6  ^[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://b4g72j3wbotr0"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.svg"
dest_files=["res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"]

[params]

compress/mode=0
compress/high_quality=false
compress/lossy_quality=0.7
compress/hdr_compression=1
compress/normal_map=0
compress/channel_pack=0
mipmaps/generate=false
mipmaps/limit=-1
roughness/mode=0
roughness/src_normal=""
process/fix_alpha_border=true
process/premult_alpha=false
process/normal_map_invert_y=false
process/hdr_as_srgb=false
process/hdr_clamp_exposure=false
process/size_limit=0
detect_3d/compress_to=1
svg/scale=1.0
editor/scale_with_editor_scale=false
editor/convert_colors_with_editor_theme=false
-]W2
RSRC                     PackedScene            ��������                                            {      resource_local_to_scene    resource_name    custom_solver_bias    margin    size    script    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    subdivide_width    subdivide_height    subdivide_depth 	   _bundled       PackedScene    res://MainScene/Player.tscn @�V�t�y   Script    res://PlayBtn.gd ��������   Script    res://HighScore.gd ��������   PackedScene    res://MainScene/SideWalls.tscn �TR�=qU   PackedScene    res://MainScene/TopWall.tscn �fd���q   PackedScene     res://MainScene/CameraWall.tscn {C#�!�e      local://BoxShape3D_rl20v q      !   local://StandardMaterial3D_i2oc3 �         local://BoxMesh_b8n83 �         local://PackedScene_pomwd          BoxShape3D          ��YB<	?�B         StandardMaterial3D          ��*?��?�� ?  �?         BoxMesh    r                  ff&@  �?33�?         PackedScene    z      	         names "   &      MenuManager    Node3D    Floor    StaticBody3D    CollisionShape3D 
   transform    shape    MeshInstance3D    mesh    DirectionalLight3D    Player    script 	   Camera3D    fov    PlayBtn    anchors_preset    anchor_left    anchor_top    anchor_right    anchor_bottom    offset_left    offset_top    offset_right    offset_bottom    grow_horizontal    grow_vertical    text    Button    RichTextLabel    QuitBtn 
   HighScore    Label    Walls    Node 	   LeftWall 
   RightWall    TopWall    CameraWall    	   variants    *        �?              �?              �?3O����                   �A            ff?              �A5zu�    ��              �?             qs?8e�>    8e�� qs?    s�#@��@               �?              �?              �?    ��l?            �?            ��$?��C?    ��C���$?    G�A��A   b��B            ?     ��     x�     �A     xA            Play
                     p�     @C     pB     hC       Circle Guy 2.0            �?     w�     X�             Quit      �B     �A      Highscore:                         �?              �?              �?�����?�ѻ     �?              �?              �?D��Aσ�?��f>            �-��ue;���7�5���?��e;T�?��\9�-����8VA	y��            1�;�      ��      �?      �?    1�;�    F%�@|�A      node_count             nodes     �   ��������       ����                      ����                     ����                                 ����                           	   	   ����                     ���
                                       ����            	                    ����      
                                                                                            ����	                                                                          ����                                                                                                  ����                   !      "               !       ����               ���"   #         $              ���#   #         %              ���$   &         '              ���%   (         )             conn_count              conns               node_paths              editable_instances              version             RSRC���u,cp΂extends Button

func _ready():
	var button = self
	button.pressed.connect(self._button_pressed)

func _button_pressed():
	var btnName = self.name
	match btnName:
		"PlayBtn":
			get_tree().change_scene_to_file("res://MainScene/Main.tscn")
		"QuitBtn":
			get_tree().quit()
 ���Db��i
��k=RSRC                     AudioStreamMP3            ��������                                            	      resource_local_to_scene    resource_name    data    bpm    beat_count 
   bar_beats    loop    loop_offset    script           local://AudioStreamMP3_qjnxp           AudioStreamMP3          .�  ���d                                Info      &  �. !!!((///555<<CCCJJPPPWWW^^eeekkkrryyy����������������������������������������������������   9LAME3.99r�        4�$�M @  �.;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ���d  RVM=��W��� t:/X� E�� �  �  O���t'��z��_Ð�`j�p!c�!`���!���5\c%X��A�r�z���$   TC�i�"	�N�٦���B�f4<�:�q�@�L�~�!�a�hB��>��7���W�{���x�V2D�>h��>���������B�x����V8CC�dHlj�|z@V!�b������W����YsglC����~��~�=���恠h!�b�X��Ҕ�/������z�^�W����:��C��<x��)J?��  �����J���������������w{����D��DD�]?���G{����DO�����=����=�w���������"���\����� ` ��(��<2�PPPP@h)P�Tǖ�x���2�(Ha�&�n�GX�l
Fl~b�F.&a`i&b�F�N
m�$FXq�Nq���@ĀSd
a1`�ZcD@9�qP�aJ(P���T,��: *0�Q5F�c��&@2���� xA� *���R+�0��``)F4=|����.�x+}�B	�@C�ۀ�U(VEcZ���/P���䑆���0���b���PX�x9�Y�6�}u�fJo���M7�@]gs�d�d�{#f��/������-a��Uw��Ң�D��ԡ`�pL�eJԿe��C��4�m�imq�Y��qL��"�����[�˚��x'2����Y�@Q�Ai���'V�����l->+g+�N�D��W$6��(��������1��
N{��Z�n��؛�V���������}��˧�3*�ȌjU�駹�Q��z�Sʵڿd1�I���j���G���$8���l, ��	Ah.E�/F!@1 ���	�%	���B�*h� �_���4/�U�H�RJ5�bU�m����M��M��C0O �4ʘ��E��fyiH�-�4zh�c��C"�v20������d�
h}�ns  �x}�� ,
/a9���E�� �Ae.kj�	\���p�([y���f��z22��t�>"��!�x%
e�@P�(���n���u0���E�`��)%�[���k;NC���@r�V�u�ð��V�A�w���t�)��:�͓���1|_n��c�>-����il�Y`���$�z�������LRv�Q1*�9-�4��e�el��Y�E�[u�@��-r�of����ô�������T���ۀoRc�z����f��kZ��������Z�9��4�k���ݏ.��
���V �@�`�    �%��e�/������jN�Z�wj�Ԋ
�]hVv���R�[2JU����/�T�_�F�i��b�#}Y��5��&��E%P:��'�����;G �"HK�(�d�g6��r�ӄR�`�X�O����̐'��	t��'a�AD�	��YD�UP8���Dhl`X����i�e��>5��s��:g�G+�,��	��` 8��SL֖ �!
�,�T^$Df���T%�y��ǅ�v5�r2��@� �*�"80�!u�g�b�V�8��,ٔ�S����He�4�m}�4�o�_�6�ɟ����7��7����ªpK��p�t���8��7}�a�nf�n��o�>�bo�b.Х�hn<�2��Ĝ���e���j/==RK�(#r��/RU<��;��._�QՅ��I�՜��ĭF��$��K�[A�c��$V������)ZQR?�E����s�������t�\Z�?�lg%P1ٿ�9�����������~����L�57�F�&�(� ��5�I�F�EkIn�H��iӨ��ڮ��Q�j
�*�N �U�Է5314$IBi0u}u6bT�I��g:4Ph����&$��p��M� �"R���~1�h&�b�R��q�K���Y�X_�pZ�*�T0�sU��x7��50%�C�2�hS6�9X13��7�N5�$2 �
5��Sq��@@�f���d 
��֮o  ��x}�� +^	c���"������ �F�EE2IE�]�pB1�O,�ٓ	R+�5����@��]O���a�D�"b�`��&��3n�fG;��Rk�o���[�s�����%����+�<!f%I�6�Z�_�4bLJ�{�W��)��#һ告��N˻�]���Ծ������K�+�q �"�+>����itf=dP�hV�����y\�^Wv%MH��4�Ffפ0���,#��ʝ�IV��)���Z�6m?�t����������wW�Ԥ�Ib��������u��'"}䲋����A7Zn�mc�Cb(�    yL�g����_��_�_��fG1/CS~�1���S�C�˝�g�sWe�SַO���1BaF�o.@DLiл�hؐ�4�ax*�)
��p44jF2� ��Jq!9���&"C�(	�q�~��Y����W8�D  ����C6�	"�T<�(#M��78��AXF�Y�|b� ����qa
S�<��#Mbl��}�@H� S�@����@�� M�A7G�nO�pq�@�N���m��C���1KTrE *ב�	f��)��V]C�?&Վ"R�6��B��ҕ�"��^��@��׍� s6ZkqDӥ�)�Dd��C6�8ɣ+U��Y�J^�5��2����/{M����u���1�ӯ�=B�S�	��|�݆���mÇ��^�D���[�3�9+� v�Ƽ�2���w�[a8j7An�S�Z�2��z �ZHӻ�K.���MZg�cE59_>c��~�Y���I{�d�Kj�����i�R�4�e�  ���rݻz�W�+���O��L�ԶR��U5��U:�M"�)ke:� ����E�ͣ��mt;�R��I1���>��43Ywd�2"I�1���(.�I���-AI���@�$Q.���|c��Pmq�ca�N�c1D}1�'��О�H�&���=�ye*�D 1��>1`qI�2���Չ�ǗF@&�%%)1�ac10CL@RM��g���d�Á��ydr��  ��*�V�e�ҨB�?؜` � e9I5���p�y5R)3���4��Q�����	<%���^^,|�*�=u�7�n�I2W*���iMյU\i:�Nu�tۄ����ӊ$�ǠY#��@��^G^Wd�0+�%P�n�yv���G�$F��mN�'d�(�[VAi<j`���}�f����iz�jTIJ��*+�		�hb�,��v9�|�[1LY1D�#7B�y0�;6h�Z����ñ/�ؤ�.ue�'����d �|P��B���߾��t��v`m�������?�o��)���,5�/���i�'�T�a'�	�2��(�ݏ����ܽ���ח���e��P�^-[ZӵdT72i�@�����;6?��Q��UTį�6��u>,,)yP�at:��-[Z���ȹC#���˄�\�(��O��� �.䨬+�$� TA��lÝ�5�p��&I��*���:K�Sf`ۚ:���i!�3�)(l�*B���T�#F;��4@02�c���EB�)*u  �B��ʚ�)a	"(S4�h;$����H�������+|Be���#r�4EJ�a�U,�Ӏ�YǑnA4E��P��`4���$Q��V�H�~�u��(S99��o�
�*�W��4��;#Ň�K���*���,�W�lɓ��;CJ"����(v�����gibaC�c�8amm���,�*u;��KP�AEl�W#�Z~�ܬ�.F�r�J.,s��J�?�V�vu���1��:(7�u 9I�ޠ4�2��by�ФC��!sO������/�����LVx\=W��Ӭ�ҟ�s�|�Gi+F��X"�#��d9ď"bkX�K|f�����!���/|>z���V�_6���}3^�{�i����V����.�L�V��3��4�,j�ZRDM���*y#�AB>�"��9c"I���&E�w
�/K��VDHZ@N�1�=� ��(��A��"Nu�&v�,�i�F*c@�&`��"#5*.
L�@BX\AdǑ`�'B]��b����@�A#=(�d�(�X���d,��իy{䟰x��(�Z�a�]A��?���L�rC�"�D���"UK��Q��Ҁ T�V��6P{i���r�
Q��I��,a�&x����	��~sZ\��u'�b�r!���š�R��y�sL���p*ՅAcK�3�uc:�?;k�H�R'j�"�Ԍ�	����Y*��I�W/g��2(S�]�4-GӃ���2"_����r2<�P�4��"�܏1`)a�˕P��	sYThr䕖%�eO�B=V`���[�Bb�M����#�8�J���U3���u% ����>[�����;���Z&�)��k1���~i������hM�,M<��hs�������|��획o3���>����/vǰc�N��ʙbgL�G�9�����}�u�	6R�$\�!!��I���;B��$I�S�і7M�z�@
��:B� �A�	��X% @=L�ٌq"	BQਲ਼���0�̊,ȅ)�*H"��`��I��_GԵ/��BEd/!wT8X	�IT�0����1��$G�uȺ�3f����.Ti����̚�B���?��)'bh'12S(̳�c,�I�=�9Cb8��V�<P�ޭW6.����M�����:�-(�./\"G�X�����4�R�Kt�&�^�<<5�N����t�*�;+��S��*������ڬW:qnlW/�Yn1X�j����ja����RjG:�D�dcR��N+��qP�)|ʸV+�h�Ndyr=Z0_	)8/��\ڕ:E'(r�`6�Ԏ*�C��0��c�ynF��R̗��?��_���k-Y��v4̊:�GRnŘu02�C�ֲ3�t�]������/�b-c^<�"�`�7@q�:��-o)�\x�le�x�hlU��M"�'�
c����B��e2d5�Ӫ�tO��tbV�>؇�j�j�����BZ�F��  2f����`h)�p'@���cO����#I�Jd��7!98aѥ	*���(�����ʋ�1���C;�`g(a�d�gDٿ(�F����@%�
`������d7�ԃ��Y{���X=O�k�U?���4��R��s�t�PU���al���~���,=�P4�mW�8������@q�(��?��ÀwFT+�2�ma�1I���\��g�	"���"�╝y[�=��ի�	Yv5y��:Q�\�����h�Ll�?vKR�eV�=�
��&������*8��>�S�t�ڌ�B�,�����1}:�˙����m���^[��Yc\"���Đ����A�0�'D ��p4����L�.XG�MG\ə�$�8�q  h�Fa�h�/�������vȷK9'[&�'Gwb�G96�&�S�+Q�G\���O��g9���$������+$Ynݷm0��V�Y��o�̅OKc<%z�x-�Z�wjucjm�R�L�&�E��HU�^MλE��jG� ` `�Af���j� (��2Q� ����A����a�%�8�^3�ՙ/PY�2吆�7���,jQ(s+Ni޻F���c�cB:��H��1 �vdZ�J���_���H����������׊­����� �x� �]LK�	}4��q3��N&(Q/gz,�,ita*/Ѝđ��KO�KpP��~�/�������`IG�h�^@?��&��b�jv����j�u܊#��&��EBN�����[[E�l-Π(˪�&��B�G'b���zۉX�����zx�(^JYȣ�5Q�J]��iqZ��WKN�W%�(RP�͖���r5̤Q1����Q�cr���D&ԉ"R)�(.g"��_*{F._z?����ҲV�_�H)PVjT�� �0AOr���q���
��7�C����p�L͝A�5���Ae��KR�;q;r�DDS�nM�/�Ģ��:�Ub�G�����T�~�d~�Z8zPQ.���[�fᆇ��{XiyG��Q�9[��f���  $���A�fI�e� �s�D5ē1�9�sg0�� {��Zs�� ����D@d�L0�� d#j�I�Mg	�Όhs�(�3@�̥��SG�%��l����H�E����`����d9�d�S+z���ph  o�o�L�+���@?�JL��Ɣh���pͅF�0�0[�#��8P�@ -�u;+� !c�峑�S�~L�nlg3�a#�!�STwPh��\	���]�Z,�.ce�K��Rt]V��s�@j��ެ�?gq)�z�gq�6�ٔ"q�����V"�=pS�����m��\җ�1[I��q�a���@k������׋@��p�WX��m�0����leE��3EX�5�t0�+0�2��/Kw����V�A`���K�J]ޣp��.*���1h3���8��J��
�k�������͍��R���h1:�!�JT�Ec�b��fOg�~�}�kz﫪=y���w�+��*�pY�R�+������B��f#>"y�´��m3��Q�y���R*3EH��9�H�3+F"���Ԅ�F��z�m*U1�a�~50g�	a4� ���!i�CG���Jd�&_1SfXaV�ّ�`��E1�Ft��E+(4��!0�Nb3`l˳2�D���7Y1"����I"[VP���4X�dZ�ʐ�LшU���!���jY��������ȇp�j�f-a�~ $�6�phmB>ɜ����u�)�]��7D�ArGI�~&ePK��$N�nYd:��"	ZP�.k�,*m�<�H�5�!���,�嶡����R/G��C�=������o�������Z低'LB#@ϳ�al��w�~D���<��ˮ�f[9�$}5�HY�����9��;N��� _���Á�`�I$�ģ��&�t����ho�[��h�j��R���L�G@��b�c#�-!
��!��U�mMJ;���M��a�R@��?Q�?.�N��3%�V-ƻsjh��Pt���eS1���tk"��%�� ;���M&Fz)p�cmY��A�N�kq	~c��*� ���2L�l�!�IffR�aZ���G=���`����(`���L(r	Dr.���U�����@}���� z�0'���d(�۹�R���`ohm,�q�GoC��B ����c$�O��SaP�Q��Jʂr�u2�d�R)��"�X��um�f�4z
	yQ�$���^���K�C�"��mÔ�'�Icr��<OR�^�*
Xžwڢ��ˈ�3�6��@֞�m���̆�`J8�9V�Wi�䅍8Qg"��+
���P+���o�:�?˩֗ѻ�U��{���U���4��:?���0V�0̎e��!��6켰�r�3�ˢ��Ec/�H[��IUV&�e3*��<p�B��.+Na�Sr�Fd����="�I���>���؞��5we��2�
�m �K�d^+�ܑQ˥�A��  �r�Zr�_�������������"�r�n�ӫ��3�/��fvs6���o�em~[�4�A��~��>��=ʒ*\�w\i~Ei��X� �됙P�Ix�U����Y����94̤�[@�9��a���"�[I��k�	���Ĥd4���mP,g��QC2/7�Ӎ=5�����c3d�!Q�R��f�L(e��ET��[X0 �A��Z��ŉ��y���Dd�%���!�n^�Z�X8)��vZ)�:N�'P5w�JI0�$F�c�	�]u��=�=�s�iJ,�9.�BgN�F����1_2�D������6�bƕ��S4Q�'��Y�Ğ&��+�9+�q��2Ʈ��8iD����3�� C��DSy�a.�1} 6�^]��LB��:�H$�G~:��+��� �t���یk��N]!��?��e�ف�6��]���!��@���l��XwN���w�x�)��	�$5~3���&�#�G�1x."����l��3Jr���L�B���iL�{�J��R��G�����T���q�Vv9�@��Qdq2�P`(������VA���!9#��U�>�nڂHL���H��)�%#��d3���EC��kT�]�iw�uaև�@�4�&�5$�o+���g�!�9�B���888h�$5�̛�k�5��M��4ٽ@A��H�K��H�$�˧���d+�W��z{�m�hmI�j�Ie������ �؎1!A�Y+Y0�=��Aq��"IL���F��(�#ZP^2ϘP	�Å�i"�|T"�J����0�ۤ�B�$+�
s�#�='F8�dE��1ҫ/�Ky����DD��}���`��-�M�����VB�Y�oW"'r����Y�d��T0�n	�Pu�=��yJe�LҴ�41��68��aJ���Q7�ŽyD�RFC�*��C�ű����&I&XO����KSL�-��2_G���bp�2�	�����9��&2������s*@�[;S�� K%��ǰ�a#�4 H�y�]�Kr���_�K���wGn���K?Tfs+�[��~������\��vtu9�������ٱ>H��	����I�lNe��
�D"�3�2]C��tQ]@L*`��1HLL�P�hkK�1�
&X��Ze��`4c �3R>z�u^>a'�h�p�o�*����ˀ.AÅ��(�nf�T�����(mC�Ŷ3"d&4aw�n`喢C?�>�)�C+E�Z��y�H��-�g0�Bpb�YN�~��{+1xBT� �L.(Z��!��p�.�؛���E�2�Ch�V�F�l�Iu8�sMa�̘��ۂ��n1Z�G�S�6�]��U:J#�
����$�'3�"�8��%4l��t��*�|"[����P���*�]g0��9�P�D�*�\�2���v�I~O ��1C�r� &�+ d�
[�S$��Q  Da��d�!l�ٌb01B�F0M�EC]\��~�������4�x���ԅM�*��+.QJ�b����#r�����1ʱ:���T�PFq|��ڝ�p�EH�q�ui�I`�N��F4j�b� � "���o�E��i��aJ'ƙ��(�5P�r�vd}A0�* u�$�4E�F�^1D�a�F8��_��k���&�Y@�s��`�Ȅf������ϫ.`P��Lִ�����:חSr��n��<�݉�%(+�ѳ��DO�E��s^X��_�K���������dP���R�Yc�0�  o�$"Km=������3ڞ�J_TM<�A|�b��'�j�U�T�a�_Wb�I#Xb�Seg��2��,��W6wrsm�z.F�L�4��q�&Rgh�f��jK�֎�ZzI�ǖ,FY�Bz���Uh�@L4'PFX��M�Zzb���	(�9/�����枰�Y��7z��w���o3hOp.�CsC���������|��j�������x+�9]���Q15ފF��3�8�6��+]	���r�6K�)K��R�����r�1@:(\��/U�|^��އ)G;�-���l`���*�W��U&ĩ�	H`$(d8!���(#&Xӟ
�c��2V <D�� r�B�|�8pU���Q�x��Z �%��;�
��6��\��R�?P�C*<�s8�FJ�<Iʴ��(��&�J�u���';ն��o��m�ج�[g&�{9�7\bD ���LL�ì����y\���imy��uvPu;1>�??#���W���.�]؟|�����Iξ�0�l���PP��i�f���+.g2'Q!Ь���u� p�]SӨ�ȥ�JE0�$\B���������������uml}S���"�	�V�=���Ȭeb^BQrH�%��݉�ɿ��՗>&�\}E�Yw1V�c�8䰡��bp}���rp�H����,�e�ĥ�R'���M0�i7�
�#������8�U�zLAME3.99.3����1�  �5���2� y�Xb����ɞ<�����F0���K���T����G ���CŶ�.��&٤���	kV^����n��0��*f�gUk{[����M��@�7j`M9�C�6�L��Q��G"�(j�A0�� �AP�{=*�252���aPP}5-�"B�'>�Xz>*Y�$5�o��'����T�g?H���M�=D�\���KT/m;<VP�Z�E��L1��
!��a��R���j���x�������1K�@09{��/B镎����4���U��EDʊ�H̄R�T�n�C-��Y�S�bPr�W�b���d����[Yc��P�  L�"fGm=7
��4���uV_��y���Z)�s,�io�c:�Qb�:yh䌢@V��a,`�r!BJ2vt�S�$ő(�X�Q�'��a�zń���a(Z�a�����b A`Wp���F��HhԘ����|��)f�ʓ0B��P}7�xրB�l$�bR�`�AZ���O�8s���j1�s*�h)Qr3L�>��[��Ty+J��[˹�CNwKk��Ѓ:̍�ÍLZ��T3!��d9�oٱ�k2*h���*""Cؑu�rS�Q�"o)P6_�)rS�&Dm"0��u"VD�!74��v_�m�3�EG�I�' ^>P@m鲒1�R}5��IBY��C�!D�\��ǘnew�J�"Q��m�i7�T)f~��I?g�������2�p*:�z����J²J$L&G��:��{]�߭zd�}�����1��l_$�$5EJ
���O�.�-mQ�h�NEH��K�����C�����t�` ����jLAM  I2�3�3G"15Z2��H|4@`q���p�{ ��D�h�b`E# ����r�
0  ) (3tNv��Q췪����I��W LfK�&���x�HR;1(R4�T� ��H>�X%�
�e�18pV�p�*��.�Ճ�g�����%Aچ%H*
H	�3�1B5����A!
Ql�#�94c��R��ƵSA�]K��ԅO�j�?�&���L��}�(P�!�%�ىi&;R�3!�i�ڇPipW�H�q��bV>eu�U^�523%�hw+�C�wyP�3ڴ�E*�D����tXӑ��<�!)&���v-.��Y��#a�B�����y�ǉ��_��ܾ����d���7nn9�W��8�u��}51nW&y��;���I�q�͸1z��<D��c����K�L?1�|B�d����6_��u.���F���г����|�O����`�狉o+X�%�j�h���2�:�H
r�N���	!�B���AN�4��}����d����N�y|��p����(�=��
wB  ��.����>���b�f�Df�Ta�rVp�E`�#�=\�D<2 M+%NCC0q341��  2�?6�<UP񅬀h$*1���Kˀh��pe I%�I�[0��eXP���	��!����s��
���;�!�;�J!�� �)�l��8���,(%�6��AX	b���jTP�?�t�DxluV��+���T���L��d5AֺV"��(z�;��J�Ծ�X�8n�,6.�Z=�e_dVk.ݠ5��~9� ����3V�U����I���1��	Nr���!Vԫh0��1vq�(��#բ���S�Cj:
40�Gέ�D)�������������0�X���J�܄�B<5�((�A�!N(c
�+Di�2����e�Ⱦq��[��(���b�WlIǓ�m�;֤��r��q���#�{�=�� \�) U�3��k/ƣ)?$�%����8�@j�T��[���)p(w�b�^ǁ	C�3LAME3.99.3UUU�  3S��*�
�BC	Y)� ���� p�$�J�|@�H�_6Va9�F��s iC/-P�jh[�E �hN(�
8��Q�3�EĶK�Y�{�ۚ���`��)0�Y(�B!����&����;�;�^wr!�:Rca�-&!��(}Hr� �)3�u�C�0p��*�C��V\���U�R��ֶX�h*'��zj"���L, �Ģey��mVQ �C��z���������c7'}�IZ^5�yՙK�OJ�S�a:~��y��.�ܪ9fpX�X�Z2Y���
:�w����J��ζ�F��U�Imt�h ���1�3y00(.�թ]	�J5@ R�W�G��/sYT������=_��p�����J��l�  ��GP�(
d��CȩB�����m���-;��y;<w̰gS9�TY��XR3�mWo;�*�i%R}�p�>�F/�X���C����BE��X��Fp�&���,*S,�8���9:S�3`}����d�z�N�y{��xo�)�9��{B t��z}/7 �D�K���� �f4
gH&h` �s'1�`p ����0����>b� X��؉e��IYH8����"2A  �r����G���x���}�a�R�dN�hh<e�L����I��-�, ��Q�������p��:�)��_O�(LC��V!�
�)��d!��̒>kV�P��u��:qv[�%l�R�S�ɷm-ϥq_kL���ʖ3�4�� �7���ٮ��.������)��P�ƹnR���g�Gj�5ґ�W#���T>B�w(U��fV$W賥b����5��(�i���x���2|�v�C�r@�!b�x�?���E+��&�)�2��j���������o�k��vE-��:e��Q� CV!
a�J� �� :d�˓�XQ~�a�QN����Jĥ"�Й�R�q��M�pu#�t1�U���_�284���k9$�#U��1��9O���Fl�U+�h�$���T�kF��y4�`�d���e��'zLAME3.99.3UUUU � 
���	�D�	A���A��t�fD�`b�ņbc�&(ba �:$gAF8�
{4��RsM'h̀�ڂ[�y����P0$�ł[5�dX�hԋ<��ӝŬ+$5�Qm������*���N���WʍK 8B}��gK�(��$�m>]�������9�`pC,G��Ȁ����^A�8�Lj3ݜ�.��]���:І����W.��p�?Q����Z�a�y�tv����5�z��Rܝg�%wǒ&ھ2���Ek:�mY�JCK��Q��$�ϙM����?���|�?��Ě�n���?���8�V�~� �y��>�y�\��8B}?�B���D�<��� ;�U��_�g=����b���ټ�Ǩ��%w1E\�	�k�v�I�YQ,Qg=�Ϛ�i����z��_���=[�i�ӹpC����fDz���*��#�)ݸ�)x�0L�g�#)��/F�hJ'����@��a�r��5%�F�%���d����ͣy|`�px	��(�	6�a�w� t��J=D|d�C��ҍ� 	  �S�F7�(F���1�,`G+
1��'��P �q�2S��4��Oǡ^k������%dyL�/Vl[e�����c��ZN�)����e`��o��,ICpI�a��l4��Q�.��(�з�`�Y[W0��̨/�L3�T���Q>A��9�~��ޓ%
��9N������>S�Φ�j��;�eڜ�|���e���D �Q����Ds�I�5ݍ��ηpNEB�t�5z]z9q2[K��:e���;kU�.ߟ��Iq��ev|��8�dg�R�̢��Ж�Q��L��z�B�bD�#�04�J���ʡ��6SIs4�����+�sX$�(�����,�VU�?^����y��8gM��6}�8=�X�]m�����L�������Q[Hz}2�
ꙏO_w:Z��-�޽��B����e�*yyz��koi/��}AS�a�ڈ�-�Hw#��;���i���v��b��SiD�N�ɶ%9�\ȹ����-�:�= �  2�I7Y�K�9��0jXÖ3"A���0���,EQ��1� eC�n|�A;��pQ&AMO��Ft&^`ZAӜ�'198��p��Β
.0hEFУBE4"4�s=�RlQ	d)�B]�a~������W M��i+�_��8�� ,d@IA��V�D���`��r����L�M\���,�sm�.��Wu���M���β��8��V0�Ā�Kz���%�D ��j�r��Wp�gOh~�.(�D��7x��U��NwU�x�*Δ7 C*��1eme:h�C��Dj���𷑦�%v��֙��yU�.�&�뤃�K/�;�j��X6h������ݤL?��1�;����n��e��/m"�)�;(A��G�ԥȪ�VLUL�7�9),@��X���  ��ћ�9H�	L�>w���w犾r����:�K�r݆��K�]�Z��T�E��Op�ݿS]��s�o7#&�z�+EAQC��*hxBa�C�DDY��\U���^p2��k����U���d��0�KCz��0h-�k3e��DA��حe�`���*��D�R�4�1�N$崶��g⸚"Eɛ�eZ�3ix���:�L����(:h�:7#D��1�M��P�4qp�KGՔxfH�M<s&z6yDʇ y(�2pa��*Ec�M=��D� ��uD+�� `��$�3U0b�b�J�.y�i�
I[m,Ȣt��l���,
�H��Y}#��zt<΀K#��� �n�^ J���ԇ,T�$o���nU�ӡ���D.c�su,�,Xf��ø�RU,����<^*��e|:ѧ�\R���)�R���T�e��^�̸@$�)̌����4'�4� �Qf:蚥V��k�oH�sQ���)v0M�b�v�n?L
]�K#\YHX�!�*_�+����Ћ>��P���I>���J���K}��\�g����}��Mφ�u��9�^a$2RRR�iK�<��)ԝ���8_����I�j���׏��]���w؏�\����ڝ�ՙ��ڟ'��1�h4�nufM�!)CqD��sP�#a�o*����eԝxL���sU:CDa?���u;��R#0�b��<�*��MN����j �T�͍Δ��@���(/���"gә�%�1nLC�\��9�ULmD<�3IK6^� �2*L��#����#.��>n�� O(�%�
84�ńKc )>MU�a2'�P  �I`ώ�.�p� �� ^U� 1������ `b̶0@����:��$�C�M�;ࢱ��T��!i�Q*�
"�d�BYy)G�#��J�8�
��LT	b��ɚ����  �%�k�MV?���i�lZ0�5�����l��}��4�� T�IJ� ]FB<'Y�/T�f�*�l�����Yj,����=��m<Hb�I�@�AVR�ȭ	����2F̞@�Vĕ�xZ֌��ʘ��Б,��	�=J�L�J��dmMt�iP���ɕ�y��!4e��=��`�E��??�������~��ZX�f\�z`�h`�!�z(�D���(ˍ\���/?���d���Iz�r�px%o��:.�e���Aa����=s3����0��k�p_�6`R؝8���h��Ƽ�h�ٯ�#�4��.ȘH��ק1-6�o1��E&鲒 � ��~Q4BT�b1TL�iel%r-ΥA� nz�F�	�e��_�s&�:n�#9U� pj��K#
�6Ŗ	.\4h2L�S((x(�04��aG�,"\���/���.6�/�� ��I� �hl��NF�@ŤА��(HD�ٰXb�2T�S�آ.��H%QL���h+���:�`�H�J�ā��,MIJ��,������T#�y�4�9
t���*M"����Y��	a:NSؕucU5�쇒�	�s�G!�x-��(N
ut�V�J��3�N�CQ��S���r�uǩy��,�ܔ�Z������`.%�Hi+���Q�'��L��6���A֡ʆ��3������� ��g���$�!q�*�tN��K$��-JW"��f/��������/����ڞ]i��uE�ڟ����j�K��UK�N1E��*�t���,���l�S���ڋ�Ľ���I��+X���	&����0�hՍ����`�4�2
1������Jg2c��Bm!����?�e�HPC��Bd� j�]��&2�{�*u� Ƀ�L9e�+kH!{f2�i���HpIr�g�&i��W(�c������G��� % �Č8�a�>45Đi#@��PB�6q|�KD�k�`v�����٥�+L
P^�ʅ�l�E�٪v`̘e�d��/�4Ł�(L�F�� r�He�k"D���7�Om�V�h�QѵAa�Ha�)��S0�HPu����������&
� �MZ�+�� `k�[��K�!��4��bI��A �F�&]1w����\��ƀ�4�M���
& �)��QvKɐь�Ұ�h �jM��f�
.��D4`XcU�"\brC >4���[v}ܐR�T���!	$F� 
+�*Un`��E���d��G���o0xmL�4
"���A�����I�4�p�a2ZB��%�Z!  �f�����|�������首���>ce��h�W�{i�����5Jә���x�@�HC�}%{�\�Q�WVA�i�!�2�����-��(w@|Mh@K�z�(a�gf|mN�,�h�Fv\4" ��i���	�����A�:ٷ���(�(@�����H���̪̈́@Q��mbk���N��~�8A��?L�x� D�!��Au51�6�3�J� � �΁��e����U��XU1 \���Q���J���`��a�J�`���I��8�1W��`)J�&(��@Yx9�
KU!��]�����+-���p�9��j)���9h�66��A��Z�~ �jt"
�"�.�3kL��1��"`̵��X�Ti^�H�P��h��1v��ou��%F��i�ݗ/�Z���M�n��QDX�b,2�.E2rؓ��	�߆H���e����s�8���*a��Q)S]P�s�-r:��I}S�k �*@!(HQEF�sHz��]��:��:
"�\���,��<4��m��S�/������_��U�/��̟����������R���J�FDer"�l'H6��o��3,Y*eO.���9��M� 0��_N�6��gU   8���! �1v�d���c0!�8$,_��y�&��b@���k*F&Q�,D07;5�6u)�5��G2*���f�YcZ�x���'���#� �!�Vg��0�@� PH �( �@�7HA���M��Ѧj@�$�@���$Ò$^iU�E���A�2f�
-����4���`ɘ� c�BZ��� h!Dkc$< �A@���FH���d .�6T��bG�F, �X(`A����6tJ,J$�-���0�A�ʑ2A�����a)q�tv�M���]]D��7�B\�D$)���D�QW�"�`	 )�,0 �-�3����rmdT`��������bXBަ��/�[Q���d�x�GCz�`ePH})�8��Q�A!��q��@�l�*�W4M���a(�Do���#h�.Rh.����
��S�h T:.�*u��4%npSD��
�
(� W,vm(k��"�E�F�˂�fS�Z�{�q��  [U��w��_�����O���ΧO9|�I�_������{��������&��K��IA�Br+,��{�R�h�9�r��+.0H�CgIB�.T�p�Z���CMx�C�riA!�hfA,6`���<=�3c6���.�ә��A����F����.6npf'X�5S1����53e�!����o��@"�kD�'7�qP'R�l�Ā�
2c��@&���TpJҎf�
,lP	T	1�p��`��51��A.@�&R��`��2`�S!�
#$*2%�$Bj(H�ń
0����@����J���X*���JB��K�����\r��f���N렘�¥B����غc�z?����2�O*U��Er�WM����G׌Bт1)a�D�@�@�p��;AK��A
G?mU��U�*"
�+�B��^G�/Q�������&1}��2�^L���J�1q�b����ң�ʔ�r��xR���%bT��j���E�V�5�:�Q�@Mi�� �]�Ԑ
�.�9+�5��'��-#0P���[��n Dʎ��7�Y�������O��]:S?'Wm.�Ӻ}~���������=�T�lơ�cށBEi���� ��Ȑ��G�
��3���Y8�4A���Ua��2$� �f	���$��qٛ9���t:�볙������y��������( �6a�0�fe&̤k23FCfX3��@1��15#(l8U0WB��3E܀ф%t�2	
���n���3Ǆ"���h�i0І���,P~��@9�+�*��x3X�ŲDu�~�]�Ƅa�� ���N95Ԭ�1	��dik�Tc����0�a]	."\��ӓ]�����d~�݄ūz�m�XoI�z�k�����'�XB��]�
H
q�b���j<>�n�%�`&�� 9��KF�/��$̖M0�E�IT,(hb�"�?���ėl�K�=
@��%dErߴ4�=����/�aAƄC���
�F�FP� QT`4���В�-&e�-��$92 R�"��]�jܴ����A&%�Fj��ʈEw�"��$c���"�AG]aP��A 0���X��2:� � �Է�������D���������g�9;~�����������˩��2�MV'cȹil�S"ef�{	�h��$yg�"��F�%�
�qs ڣ���3aF�ɱ�R:�gb��JF

�H|d���P�&<e�雏f/T�D$M1��ȇ��4L1�l��/��.�h(�c����z�(,5��_�\�$1�L.����0˂��`�@��WѠ�0�q�*a��.8�p�B�F��0�X���N*(Q)��
2 ��L0r���ra�X:d� �0B{HZ� �CJ�h(a�:<��`�"�-`�I}E@N� B �Ƅ �,�@�U�2�(Z�L	1�)޲�NQN2��"z��h�@��`
�а� 覊6n:�ʀD�%�����b;XQ�$9.�w�Q�H<VZe/.��W���m�Gi�'�U DIDYM`0l�!)��4�0	u$��F�S���D�\�慔�X<e�c�q5&b<6^Y��01D�DZ��@t�z,��5ִ�нªȸŬP��"��+�?,Mu.,�h2Gn�ml�" �S�L˟2��������{y��ӵ��:�b��k���VT���v����1���L��R�����J+�~WIBhi�(�oK�H�B��#D�
���V_   5ES �f��BP��0��@1�@H3ĴŮ3��J�xICh����c�d(0���8k0�� q70.)Z���qR���d�6%�U�Q(x!�&i���d2�g��CZ��r�x])�/��g��A�t��L���8�E��2b�2���e�܄�2�ļw�Jb��ܲ[ZB@"��P��,�.��-����0�E����i���e�o��C:	p��d+q��Q1.J�e�Ѷ���p�,8����c��>�F���bK�C�v�g��a��r\�?�a�1E��2& �)��f�,�x	6�3�F�誦U����*�8-Fi`��{1��i��#��ֆ�2�/��2�
Yj\�]�r��,����
����)h	�|
��P���wb?l�J�-�b�Y�QD�Z��4~�JZtE��ܒ� Y霝o�}�z�/����E��/Ԍ�5;���s�l̍y����?��J�/��l���*�k3O�b���?s�/����|����0,�j�#R(�c�UV��#��M���I�2S�)��'hҷ7���w8A�b((ב1��D�(�p�ca"cr>%Rbs(b��Ph�A�88bÙX@�H,�Y)~��h�f�$�'8��Y��z"���W���" �^B(����ST5�C1Ť��C��al=:�ԩ�X�FwS�&��N�P��B��Ï8�o�=���֓E�R���86X�?j�
P޷s@���R��WӬ���ҭ�A*�`ϻ`���"JX;��]��F�5h�q��ҷ�du�;�XV|���J�/�NZ�ep���P�B�K���FF��|��$M�S6gax���2W��ZjQ��r�	��a���DX���<��R8����s�Ě�U��%�
�fz��W�V^ֽ�������TG�f~�rg3u ͞�����y��mF;�j�9)T��B���{w�(�cj��5���,�NP*�́n+�ր6&����K���#�r{!P  ':�!�lnV1QEf�H��Y� $�ɖb	�'0΂�.���CHƄ4gA#H��6��2��� Qá��U��8��X0x@!c+XP)��ƼQ��H9�`���d5O�ƣY� p�hm��1��g��A�t��X,g��D S<Fx�X��E�Cx� �)B4�0�;�Y�	� S] �e�-X��~˛г\����CAb��36SzJK��L,�����a5�u`���q�'K�du%ۭ�lR��^��G�_u9s�U8��F�t~u�)���ժK�H�2��ie�q.�і�LD�/�3�L9sO��a� �����ʑZ�9���i���=�z�:��jiS�ȝ�� �0�3e~���o���_8�^���,��[���f@���w`h�vOQ�5�	�N8۫Jv�Ŕ���  �տ��L��}����9O�����֥*Z��ꈭ������}5����/%�yl���AT�%0�HzϬ<,�o����q��Zb1<�ʵma���U^��	H�3,^�Π�@  jY�&f ���T��Ppt5�
N qQ��|�-�L� Ѐ#(,=�2���ȗtlDp0�8 `p�0�W)e�q�x" 8,bB�˩z7(�We@���Ar3�%���b#����FQ�c8S$�4�+DX4QBkTuK�id��YJ��T� ����P-�zB;OP�n�̱X�,#�.��C��ʚ�w ���Y��ge�J�6�Tu�нk�l�"�fʦ��,����f�=vǛf�����?��PR��iCөOK��%�ɒ�!D@U��Ve��kpR�L�V��<�\v�-CP4%�'��5���;HIb�6�騜���Y�CծHm����nbl�O&K��@�5{�NT䶗��KAuZ4��U�>�tQn�@ k)9w���][����������*j��\��vTG#��~JvM�����y2F�!<��
�G*���sZ���4���Ҩ�ٷTX��3����$]�����_�GO_\�u"B  s�T�2xD&L�ha
��l��R��@J������P��Y�tN@��]	�B�VuLa��d�  48�c�������l�5[R���d/����#Y�pr�Xm)�o�gѶA���%`8"د&Ć�1F&I�m@�n
*4[��2�h L#I�j��4f�� �M�lA=E\���-�[/(���S����X���r�(jaO�6j�e�A2m�+�ګk�.^.�DN��
�F/?�0�8��*���8���S���~�JJEH�R���Щ`�G[�ɓ�E�S����%%^���`���V��*��7�J�һ�g������D&3X$d,��reQ2�4�w2�ZCh��0���#�b2נ_�ċ�s����Uw#� SHM;�K.����I%� iU9�K���[7#���Ό��mz�"#��Lr����ˮ�������RʍCw�ue�R�B|�22DCX��ؠ�rt'tP|�6!=�Ĳ2HV�"+dĄ-l�@,�!r� � �f�!��$ bPB�����-0q���t��+h ��t,�  B����kAF/���C3�@4ǀ/0t�A��_��/�`��1�F�r�c"_DKT�b)$?1B�B�X�I��{��x���!]h��S��@�	"��A�������Nt�Wrǹ�Y􏋞��]aÂY����m��^���p
�+kKsV�4h����$����J�Z4���&��x�y�4��R ��7'q�ơNT]2�8"��VȌ��1�6���V^������`O��h΋_Id�ߞp-R3��6-�A��n�ԘJ��ՁQ$���8�y�q�0ú�����
\�h��%M\&0�R>����>
��o��
�!�e��G6���l��g�3��_��Ͼ�9�y�Q�X�Y���_������3�?����us��o&�P��/�2����@�jć����&���s8Q�þxȼ����`_8Z]|��]@  5	�59��c�a����̸�ŀ�@����P!�`����8��,ea�P2�0��H@8U{�90�NY(�S�N"  ¢��j1�`O��=�`�F�<�UT ����d9����D�yŰqph])�0Bg�����3��ԾHT�PQ��
!�.��Fb�:/4	 EGALq��Z�(�D5,0
#����qP "���q�,Ug\m�>����-ʸa�l������#�(���Ft2oVar�s 	B��X
�*�#�^J���F�L�qm�NcFrV��l��Xf�t'KA��n��� �X*���<� ���/��,�$�-g퍸��!:��}I�dE����f��yrK��V���i&�	�>�mX��n�7�PH֥���i��pdF��e[�Y3=��!�b���D�g*� ��Q�7#���",F��r�U 8�  ������������?)e9�F:H� ����S�-_������1�F¶�M��D�	�o�,$��c���AC����	!�y!�TJ�ע��P�<���\lsdb��@16ϲT--hab)��hu�Ph�P�)��$�s^CAF�A
Ax(3*]���bKw$ǱMx�H&���aA ��5�6 �h��FM�0�`�dP�T2�;�u3Z�T.��D�0�9��T4i"Ɛ���	�5$Β*�<��(�%�WDS�o&��ē��
+ͤ3.��N�عP�L�N�����s�9pS�JD���aLJPʡy�e$H��;�E���X��1����[b0�:R�kK�������*�Tvm;���+�ʑ0���z�>K|`����5AR��ik�>�,��sj�)j����r2�HNM�BVHk̾v��L�K(@j�/�3�F�@�D��WMf0�X.z�6��Q'��?�!�De�i��r�z�-�˝1b���[d�/}ʬ�A�	�9Տ�"3"�'D�z������ٷ��dW���ݭ�Tܶ�FՐ��N"-X�%�������	)HF(eT��4V�le�p�gSphGC3(��O�� �{�U*@  "�-��&0�G�"��ɣ�h��w3i�����,�@ ȣ1%�>#}�� (p`���Uא�`ʚ$�!�@� ��a�r=B���$آ`@�%$
�����d3�5���YŠl0Xo)�rfgA��a�'�*�!/�c�x7N_mjD�+ F ��<������ 1T�8��Y0���N`鵠��+�A�`�#1MՈ$e5R�)Q���@�uy�*�)�`
�^6��XRC��Ҧ�-�\���Qg�Q�*C�fV�-���s���2�f-�U��1r�E��`[SL>e�SCa�������6h�#�(gM%�D��m���ҾY�IkJ�4'�}�1za���S}�p�%N˃&��p�؀��u�0�s�U�>�s�˫�!��Ek�o��ٱ�u@����NK$���aZ�(;��N��#�B���  �VsY.~�/����������ԥU>z2�J~L��W�������܆���S�A�פ�+D�m�s&���BHL[:VbLq�u9���B8�����54ET#��r<�9C�΁%�!����w� nހ�&q�SF��2(,�9�bt��C>��SFTY�2gʛ�©���j��&884 �(�S@� �s�ɖxPWƥg2i�B6!�q�X��5D#=b�ZHA��iM�5?��^���FK:1���V���I��Th�C0�K�i����Yz���h�Q�d9���=�Tq�YD��Pq�G�D�*G�(k��ә�����]8(ؘp�!�@��)�K���#{�S��j0<��o-gɠ�Ѷ:���`-#��P�e�2YQY#n�R��G"�u$s)K'��fK��.e������1Z6*��T@Iu���`�WžH�������HT�h���^��Ն�vE�����ԩی�[���Ah��FFR�{���������u��DdR�V|�;5V��%�����dԖ���K��e3)���8P,dœZ3)��L�f&Z�E7($��M�tZt �mp٘�:@\\�N9*�0 ���q�4�AF�j#6X�1sC��2�Q�b�p�h91�����r�����Á5�S:8Ύ1,<czX�!1�N)������c��!��H5ep�hA���d2���C+YŠn�hm,�ofe���������q5X1��Dj��[�I"$�NJu
°j�k44"%i��ׂ67 �6��"C�T�A�/H��d.��,�Ԓ��̠�H��$����d�L��aE�(*
�ll�|�@ �>Ӂ��Z:�d+��$b4	�vgejܶWkv~WsW2���OT'�eM9�7����,�!�o�ǾR��G����e-("R�J�oR�X��4ץ�z�ԃ������|Y{���E%�$񸩮У�
ܠv{ZSX������m�w"�n�#�O�R{m,����:����R�YX�)�N�v[c�+`� ��S=S����/���������]�oa�f�;z�?�����ɝ������g�-6�.��D�)�헷�یY�.�6�c�p��_�)��T�,�D��F��T/��B��@ Pɥ���ؙ�$�M$�%��[TkX0Fe����&0]�(����`H��)����
@Z�Q��	�i "�D@B2�,�Q�F�� `hZ4+�(KO����E�50���C3XXJ�K�%#gg%��Nd�h(�DX�kmUZz_��J�m��"$�)uk���-��p� ���a���4х�XL!��HX�췗��2�NB�(M�XA��F��N~�d`oB�l���)�="*Ne�n�;:�C���*K��.�Ȓ����u�	 �'q��貆3��ҩ��
ü��.i��At��/�Lr�Z	Q�gBgG\�AAx��e��f<���D�<VRZ�E�T�N	19N*%;ĄJ�rZ�8���@"�I������S�������������*���F���Oz���L�Ͷ���߳3f.��#f�g�|6���hc��ǉ�"��Ʌ���Ȫ��k�2��XS��O��ZAZ�8� ��" n���@$B�Ma�1�4q�\x�W�(�ȑ6�N�bkg,�QzD/�t+pM�F&my� �f�
�c�hԩ(j,L�P�C�p�q�"�%f���d5��B+Y�@m�hm)�0Z
�g�Aa�3�4i @�8&�+��s1� ��=���$�@ua P!���"=8�6@� �P�A$���`�i�D|xUF�L�B�@Ɍ(0('�}�PFg��*�fV�O�_H���T5����*�H�!j+@v-5�YXWt��`{wd�������'EsF��0�Yx�q@��c�����t:=4�mZ�w��N�ш��3��˂����mj�Psƣ���A4�2߇9�L�T��J��J`�K�i{$BIJĿd,�C%o����(	�o_m���:e�"F��D��7tׂ����*~�+`A:�!�ؖ=��t�,Ѐ �a��_�dS/�������ֿ��ؽ��)�����������܍ju)��#�I�Mi��{<���s��D4��"T@:H�,H
����R �r7b���`b��� �Lbsj���0대�$� ��f8�`lL��!Qg���e`��Tc8-�%�[�f��bc "�͌%[��f��=6؀�Q	�b$j�\(adV�4g�U�A-:I�4vd�
�B1ѡY�&:H�ET6�҉����
�2��L��!1��e��af[��
<f�Ly��+)@����O�#f��2�՝c5��ęc�đcB��籩�e�	�����j-���5>��2����+����i�u�2�7F"�e�t�Y��uQg�<��k�tˌ��LLVO1"�iL��G���9���� ����<��?��u4�ӝY�V���Fh�b��ţLŵm��4�D��C&3!n[s9fѷv"��9��w29O��K �.J#Z��?%������4���(��9��&��U�5[k̖���t���e�!j���w)NS��NJ?dz�Tyl^g��2��t��1�\=�������)!�d��F\yD�+�� �  ;v����'#��8@XŸ0p���&�RF�Cȉ1��	�Hy1�2��� �I&%�jf��qQ��l[0�R��Qu��#�����d/�BCX�sxm)�/��c4��A��3�?�5���p
�º"�CB�8�3 �/�*^!0Đrᦰ�@(%�h�P�`F�h'���"-�q˞P}w1�d��ZV��V�5Bԃ6]�s�ߕN��s��7��]!�P��i-����͐>,5�F곈!#�����Ge�;\t��>�T�yc��l=�F�Z�>��l�=�ձ��M}�M5��|1����b����v���g��Ĭ0�Y�r(�*S�ԙ
��(�����n�Nȡ�=��Ы_6��(��V�;�[�'Kh�UU.�<�m�~����k]�m>zQl�	;  ��ɟ�*�^��O������vz�2��7[�Y��nU���_����P݄��/�qrs����2ĩ�0�'*HQD�&B&BB��d��b��pV8�K�D��a`��3@�Ё��J��0��G�� ��ǖ2ҘȊDÎ�Ǆnsr�y�5b�d� 6�P�c��g4�(�ӎ.�dU��7, �RyXu������4�52HdK�j�k3�c��B�RD;� i��V��.��߸�k�Y刅쭚��Z�NL����}[�x8jorW=�5��m?��>nE����׫�6閉�7WM�����/� W�8ˑ���,#P�RU����c�F)"�4Я����m�`{o�J�ŝ�S��<<�����X�d*�)�Z�A����\��s��W!YB�D���Ke�fF��!$Y��(�;3IXa�^��M�KT�/�6}��#��4%��ɠ�B��= v��f�0�X0�(�-�5Z۠�Yn�����;�ޜ��K|e��e�g��^�kԳ��{�UKn�s�������ls�UJ�*2�8�c��--dK�q����h|��&|�bsc���U*�������q0���w�3x�BT"-r�R�h0��Ш2��!�`F�ٶi��%�q�n��&��,A�&0��yPX�3^ ��]ઃ�t�����k�p"=I�P�/�]���d2��@�z��pPXm)�n��e���A���A AH�HEθ��`Pq`�À�]7m�Eh�-��p`r"������d�Z�ۭΈMq"��[rE��4*�	h	2�w���׭��,U��nYjW+arDA	��rTNCP�f���~������y}L^���\��25A��zv�W�[�'e�'fL寿�P�a�Q�{ܤR�ֻ%r�;,i0++~ӌ�*\�ܔ�Ug�N���Q��`�7rV���#.��hsmu���&�r*��O`,b	���w��e�'OP�I0��!���2qS� X+�ɚ+?.��j�o�+mԃ.J��#�,�H��R ̜���r�?1��?���{��y�r'�/�4�~D��������j��g���jt_Kv�h��e&bC��e��*N@�٩IC�����"AH�T<%	�V���.e&@vA�&���&��lcC{2#�\���qB�!	�!nRT8)�Fh�
wKN`-� �pF�E��Df����<�P&�b\@S����5V�f"eR�w�HSwL�XPI�QD3R�T.��AÚ`� ��ܹ�:4X1��_m��2��?ˡ�gQ�$��0��� "&���K5*���,=�3R���o|&�#!d�*IA�언Y���Av<	z��.�)�o��,�V��AyBܨ���U.d1�#oK��] ����4���Sj�YE��\IX(��N��Ƴ� �e� e�t/K�\������+�>��L�!b�+G^���� �)�&­�x��<}� ���.jh�BZ��`�/��Q%U�
me�M����Y)9�r��<����9~~k�߻o�r�~�^]���K���fw?g�m����,��ڂ�:���Z�QC�L��C)�?a��&i�!u�b��R�?`��VH>�e�yih}F$)i�1�s)2qq�4��1��4`���6� j<��3� ]��lc���) u@K����Y�HJ��.�f����Θ�SPǁLd	%X"VF(a�>
�a���x�@����d5��?�z�pnphm)�02 g�B!�3�́1�&((����pbj (oY`0.0�D_p�3�a�`�QA��i��,b*ɖ)}�\p&�,3�1+�F�RǠ��'�p�A�)�]�wt��^�0��΅�����IȄ���ҧ�G������1.ѡ�e�n��51���a�Zz,���o�~$z�S�WF6ߧR�[.ò������T����$�BC~_��ꮃݰ3��G��"i"/�*Q)����Jj��]�-��AK��,j�\���a�:�C��Y	b�-e4j�1 H9Mi�+4/F"/Z��Q=D(2�$JKraR"�t5�{��g  9�}��e������o�/����%S?�����������9�f�Ռ�yYF��R���� YB�u�e؉		;	T'C�8\�X%l�F*H�d=3�0Ȣ�4dր��Q`!�����jA���8Il�E.1�*SQ0�!�~��p,  ��K5p>.�B	���@��CΩH�a��{�`@�x��&P����"�X�I5�;bP�z�.(� tK� ڰ!.��K��#�,XF��ص!Z��8V����ϻ���\8E|̒>f�({L�K�*C�TJ��6�t��T�+���/��L&�/�.�\��r���6����^��Y]R�倮�TY�d͊0�?�}�����k;�m�*�\u7ź4��*n�]u�5T�.BL�普���E�ٙ
�Z+�����1玱��,��
�c�q��6MY\��qc��,݆#Tp�
��.c�G�X��|�/#���	Hz0�GY����	�Ug�*]��!�������/|������]�����]s��KUu-R�R��K��s�>����M󝔆U�`�9��!�j��/��=�Q����<�*�%+�%�Pk�'ǋ�*��+e�A(6)E*)�*kć2@D�q���:�\�S�0��,�5���F��<V$4��B��i��ƈQ��"�y�F��[�E���C��y��q���d/:�?�Z��t�xo,�0��g��A�t��C�q���F�F�	+Y4�΁��IԋL"���!\�K��$��ĺ�|�p랢�w�ɪbEn�ⴙ���*bb�b���`�!z��Vq��b�7TY �튭x�S,�'�U��3�`��j-�%�L*�ʂ˙�B�d �r�Q5�2Y@w�[ uTI��iI�%9��@��lK�|�V,����j���"�����I
��9ڇ��c"|�X�Mȼn35�3�y�9�h(�)[K��@lm�����45X�狿zS��3�$"ssc��&;o�C#CE��Dƚ��G�y5��ScW.�] 
��F�~/�^�����]�������g9�������K�{����6z�O����{{��b���Z�a��8�+�/n�k�'�|��br��N��Ե��y`����5t���<t\?`Ѩ4����M�T�.8l`��G�� �Ha�\$4�C��8�`BNT����r�B� E�`\(�pC@��DGف�6h��S�k$3M2�3�2ԱMg0.餉2���� <hՐ�	l+ P	�rB�O��NG��z*�H^���������4h��ao�s���GYl�^�$��?����H����,HQ]���������x�o�FqWҸ)t��V��UK�賝T��?��.�i)jǦ�QE�qz\�l��E!�yq�U�y�{���B�I:,I�'[V6 �dP#���uTl��2�uR�BK`���|��1w��FEjm���x8M)X��NBÀN�;�����)9���`��5��Ơxy�XF��չ�}a����c��l��+�e�����g��������td�
�c08IdD������)����S+i���_`�SI���.j�F��+�4��V&�*�	h�V�)��.D%�7ZrWZ��v,.W)d��4U9�TTҪ0"��j� e��kqF�X��ɤH�\H�	B���Sj��1�آ���!�������	˲��8F�LƩ�^@�����=���d+��?Y�p}0�M,�/^�k	��A�4����49���B���D�$^Q�����ح�|���$��s�1`��+(+T5[m��JQ��B�

[��wd,�`��y[���"���Z� ��=�6��߇�lH>���R物���i�d����;�S��3�Ī.�nMb]�����Vj�-H��b���-Af.(I�}Ѓ&�r}�h�H{����XC��U_�f���HX�?j�/k-���Y���&�P�[��*,�Թ/S���El@+.[sA$qs�&R�+�`)���rY0�e'
�uث2C�\PfsI{�``&�` g�y������˪���T��0�V3`)A��>s�32�.��s�O�l�z�0e>���U�M3
*���~�N[eT%#�g'\%��b��%((BOI��C��!�����g��7 ��d^rS�%j�|�ƨ@1��4<\1y1T��3!��9P(�2�� �QQ�B��F��( 0�Vz��
�L�M`�0�����!j�	� -���F�BS� (n*���=�Ke._���$7q���:#C����V64�v�5��
�Al�:PJ�!Rȁ��� ��U��EgRw�:[���EĶ��D�:��M�5� `n�ǝ�.o}��k V)����6}�ݤ�{�UiF���Zľ�]�e�3�A��F�[��2�*]���e�Ufq���%R��C1T�Al������$�{̸���nip
� !K�&'��2�ʱT��4�@��[fr�F�*6�L����{Q�0 �h�m�!�B�Eb�!4n$Aߛ2�ֿ/����������ZlRfX378JXEA�)�!���[�$���?6g���2�M�v���|*Y���U�8DN�P���Y�Ьt��x�ų��匑�C,i�	\�'�lO�J5e��'��r�� �HX�
���A����w�-9��2Zl����'+�Ӎ�m ��xI3�0��!B;����`� �-�/�	EД�o���Av���d-��@K8|p��� o�.^�,��A�t�����A3x�z�R�݊��S'��EP�xci��z��zh�'}���-)ٖH�kTdN���G�+�@�O�*���/$�H��Jbz!(���!�o$�J^]D�	0��a�v������H�)\Ȭ�><�P�,��m.�d[)�!�9��\��B�HP/�+`;Q-�$ -��Fd��	�S��B�R=gU�L+�(����f�v~c�H�1�>K�cz[�Z��D'!P qñ.��h������0��1|m��R	����=�_���9[w�MTRhc�f�Ֆ�V�^��,j��Q�DDw�����.<8��؝w���5\j�z���Y��z+��Rrё������Hz�-	gfs����t�7���OM�ReC���� !ĩ���/K�@L�6͂�h ʀ��Q�\*f�aci��`q��g��K�;�9�1�( �b'�OBL�U0�7��b�Q@�;i8����D��zTh���LP_Q�D`���w@���`�ս��ݖէG�8� ���nvVāXUg'sc�X)��J=QHוQ{�՞�
R�j��Ӝ�#�x��x�3W,��L��d��S(걩FsԬ-�&Ix2����djm ��M�AL��S&Z�6�,2ȕ�-UY�;]���}D��3H�B��%����5֬��Ĺ�JaPm�.ZL���p�2���qL`���ny���?�L^4ζjA^�m��e�,�n�H��Cl�B�u�;UN�^E�i��c�\���S8������Z�J�#�&$|�Y��I�^e�+�>���]��������KyL�?XHۀ��Sjᚆ�����̿399��̵gc���8��Ot���i�	�0P�9�F���%bzRؾ�t�l���S�����F��M2'"� � >!��S�~�'LΝ�W��	
H$T6 A0̫�",ޅt��)p�����Hu������#`�X1�������@�Ci�`P�]�P�`�k�'���V4�ki�,b�'Q"CT-F /���d<�=�YĐ�P�ML�-��g� $?��M8��q���deG�`[�޹�S�X��k���q���u7I¦K�R6d�=j*��&n�L��K����D�_�
�/i�c���	���kLVnU(�aeSOh�{��[�Z�x!�x���10eT��Y�?δu�H�峂�PW����2��;L����Ri�݌?��턴�KF��VR^���C%�ݠQ�*G�v'���GA�����kR�+NӲ�A�"�2��A�T�[&B�L%O�|�i,�Ҵ1Z(����e�90��P�	��ʻ�q��@ NE��U�$j�����������j�*��Y��y���!�ř���w]�����͝�[k�M5��ʯn:;�1އ4�Z�a�Y��,�%F����>�b��W��}������UCS�]:Tfp ��Ӂ%	�;c���Xhb�I�BJ,���C�%8)ԥj�`����ʶ����g$X1�S��u3cy�E	3<�]RҔ5�YjY)��)��O� �@"`1�j���Q����*�1%"�--@��Ϟ�`� ���g3|��C�'Ue��P+�wʡ�=1֒�d�'�Y��R�i�����k0L6��X�L����P��d�~]����*�V6"��*X�]�`�n�-�݁��o<�	��&~�4(�;cR�È�3oz��*���Ǯ����6�i
�3�^)r��Z���}�\J4�Q�'*�B#rc�'J�anRb> Rr5����3%�nʼ0
�����~���z/t�-������d��;+-+`�*R5�#�����Z��ԡ���L_EƱ�=@�M�t�Vx��~.F!)$�7"6$�X����e��_3^���`�"X;0��(!�1��B�ШF�x>�!�y�#�y���L��.�Ubx�?Z�NP�A�>��������K!��mbZ.A!P�S�l���z<��B�)h ux�5���X�H|9�����lO�,]F���e$��G���7�!:�.�����	V�4��K��L���u�]6T��M^����d*���>Y� �p�*��)�,���A߀cؐ2�(!k�M�-�0Ptr@<�!����`-��m�P[��4i��N��!��F%����t��oY�Q�t�8��a�}ɓF��+:`�s��bP%VC,e����PGd2���Pt� ��^q�	v��j��"�Ծk,�5Kw�o�3s�fO��0��RgJT��K�Ϣ�uGG��W^h�l�_@�T�Ve��YS̡��Kk
�&����@j�gޜ�8�Ԝ4�)����BQII�TF��E����/�	R�=!�BB$�/j�{1:�H �����r�Ȳ�����.�̈fbEHJ2̵)n�s�& ��2��V(���WY.�����[Z�*͍f�1��b[�se^AlRv�'#孪�RmH�����EM\�y?fDc�>�'��.ЄY��P��a��kT�`��*=$�XO"��@H�����"HĀE4E�w� 83^�f4�Z��~7M 40(����ڊN�fa���N�4�d��퐅�~�+Ɇn,Et��Ac�� 	��#Y�"�. �N�E���'�V,��O� �R�*��a~׫�x�v�4�p�?�1�E�(�A�����(����I�r	�Z�Xf�x
�W.�J��^,������i�Z�1A[K�XQV�,e�	���D�**e���R��I���J����WX�.]p�q,IBX\�ZA��r��k��1��vՕ��=x)7][s"w�wn�\ʇ�m?�E*C��R�W�"@���ށ� s����R�e�y���|������Q�A��VI�*}J7]�2i(��2� `O-#KH��88V$'E�B�o��X����m�Vv3��is���)ƫ���0u��%��Xnm��mK��t���6X*g��ğ�q�Î��졒�q�~+�&2�9��l��a@]e�8�n�ߧz���[ˈ�k��MkX�j (jb���zy���N5���`5v���{
�� �b �V\֋ڊ��%�٥�Z�en��^���̲�-L�f4ͳ�AD`���s$���W���d+	����/�p�pw���)��­���?ٜ$�<&&�5$h��p?�dt��1��!"y�rDC,H��ژ�f|2�g�V�3�����b�1y(��z�!�J�mv�1s���z��V(�[I��eBՎ�yN�>UQ�z=^�u]�'gmdO'4��C����8�^P��ԋ��܊�&�1"aD��*�$�$�C��X�#/n��E_G�ln���X�Sx-�-�8p[�!-��!)��'���\�.C�k����QF��D�&P��"!C@D�',
Tt 
���|�Z|��?�?����GM��]�;:�t-�Y{���jP���(%iE-�j�z��F'�ׄ���9Rlo)��ܻsb�}���>nzĬ��J���E�Z=Y֧D����2.�e�d��ؙ����&b�v"M�%E���8O��
G5!�@E��H�NH0��P��LR�J��|���9������IDe{�H�!4���U D���Ѡ=Z�p0aYS���>_��/ccg�T��5�w�*¹j�=�%:xB�d
0�'�t��?�f��BK҈o���G�'�0�Ł0K��RE�ț1�tX�c#����rڹ-�6���x�3��[��#i��,���`�n��]���<�i8iEr�G?�I�vY�.!��Οg9���l.e�:�L	��-�6&E�k
5I~G81*�����șs#� �6�B�,���ʁB�֌�=l
��+�J������E�/̛�R����#V�dYhOl	J�{5F�"iWn���i���,�1�Ȩ�x�q(�	�Ŷ��ys�C��k���?H�I�f7ߙj��T�Q'�Uu��3$y̏ U ��xm�[k6�����}C�����F&�~ߨ�mP�Dd�YŅ��ނ�M�V�2��',j �K7�$)�<�FSq)����%�ᨛ
��m�gY%HP�V��J�A�H�P����U�|�,#��<K^�@����=f�Z�+�D�2 ű�"��O��r�d�i�2��!��]�&[I���=���ѧ��Jħ+M�&%��`.�����9K���d-	��>��⻐����*N����v� d�ؘ�&������Q��P��ɢX�ʁ���N'I�~M�ڍ%aĸpbU!�/��������gp���9�[���]��K��h��:�p��*A��V��+b%�fm����+z�$8��T����O�`bs]��(JV�q/�c$�Z���&�w`P�NC<��h	�n��rQ%���T֑�Aj�h�eʫ�	'�J[�;�-ax3��V���!UчV��u(�m�^�X�&�YJ���������Th� O���a�u6�T1dF'̑)F�T@HÐ"�"a8r]�1�Ӝ�o1��Smn>]���J�ښ���^��K,���-
8
$�f��b]�r�q��_և�����/$Q8,0o�$B�z��=���rb0F2\|�\�8��t>��`�&�8q�A�#X$"�sr[�W�xA�Hd�i�� �a�� R� ��"�рR�nl]$��А�H����Q���g���2 ��l%�&c�u��(�
1� Ѹw�qF�\��j�b0e��L(}*Շ�$��q)W��VK�s�;`�j48��KT��Ey f@��[Ĕ��M�ЖF(��M�3��:�cV!����i�U��lP���I����R}���e�L���I��8���21+o,F��H���.�y
>��s��c��L��l&d�w���\���,�[�-a�e0BH;2�����N.�}F��a�F�)}T>2���){@D� @Wq�c�0��r��Y�&��e������W�FD�hS�[$Y��fϯ���^��ٓ�?���3!���M�AFv���:����f��'��e�����c�����m�m�\g�cA�<s�@��\."9 M��K
#�Rt���W��	��*���,E���ٶ2K�$��*��)`6S� �Z	�pY��Ğd�%@!��[yZ3&M�΢A����`z`d	Gu Bk�O�XD�M[����e�Ք�T�{��
��˒p�%)�#:�*R�� �%lI��q�	�%Z���d4W�=��p�Ї�8�#��'��bB]�chd1¨���S��h�V�$�2z�O\T�}��v�W*��>C�G�ur.da�d��(�͈IrbO����p�G�rҐx�G�*t��]
1�ߧṰh|��Ņ��}T�T���
ɜ{�X($)��av~b�OP��sh@�fR�Usx��r�����O��yK���gp��+#gq�@�T93��"C�~�I��*5%2k&�"Kx���DPU�LU�Ƌd�
 �iU��nJ�/?����Y�`����>V_F�N.N�F�]M����6���7
ܥ��U&�ֶSLNN�E5�t�,����߻t�i��bj���QZ�UL�T��Zz&gʻ���j_E.pwz���߾�T��b�o���LB>��u���\��řK�V�ZEL�%�ʎ)�o��BX�þ���t�z���_�	��K��x)��'�O��*�+`1!ʦ�j�IL���'"��1e/���'B�cY[��r.J&"�=J�K�	:U�i���I�9 �j&�K+�ѭ+ץ���Ba��.\J�
�զ"��4��I�LLVٖ��I�|�p� @	�r�V����%�1k�aȔzr �Zy0�dIXd�r��%� ���Nb��4J>�ӑ�J���c�V�B��0�^6Q_��eé�[1�u7��WjC���MO�)J��WI.Kk"|й��=����c�LA��ɷ���� �g*��0��W0�HAB|�!9�"p�*AqOUU^f���j��ʪ�Tq"D�$rF�j,J��"E�8��E�@ �N�V�E��D��

��$J��"D�{ϩ�bD�ߏ�KK)��e9eڰ��8�0��Y�亖H���R�Tt�"�t��V�USV�d��VR�YIKj��T�ġ�ԺJ�)���^Ί¦+kR��5@T���@r[�]���mp9�9E�t�LAME3.99.3UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU���d �              �      4�  LAME3.99.3UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUULAME3.99.3UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU                 RSRCu� 2�[remap]

importer="mp3"
type="AudioStreamMP3"
uid="uid://xu7fhga8f2i4"
path="res://.godot/imported/Shot.mp3-b232c1625da8e313e7c431a1d0950141.mp3str"

[deps]

source_file="res://Shot.mp3"
dest_files=["res://.godot/imported/Shot.mp3-b232c1625da8e313e7c431a1d0950141.mp3str"]

[params]

loop=true
loop_offset=0.0
bpm=0.0
beat_count=0
bar_beats=4
<H��r�]�F[remap]

path="res://.godot/exported/133200997/export-20422a58ddd5d8733654ee9d638981f7-Bullet.scn"
�s��l�<.$:,[remap]

path="res://.godot/exported/133200997/export-42001c8e0b4c6076ff7654178325fac3-CameraWall.scn"
}�ֆ�i��T[remap]

path="res://.godot/exported/133200997/export-22233b09be71ed3fb1e266ab8f0e558b-Enemy.scn"
J��W����2��[remap]

path="res://.godot/exported/133200997/export-aaeece3389ef5e96ebdf70440d3216a4-Main.scn"
ǿ
~�J<�"=�p[remap]

path="res://.godot/exported/133200997/export-f74bd447042ac109e409101e4a478b53-Player.scn"
�U,�e'.d7�$Z[remap]

path="res://.godot/exported/133200997/export-d9a2ed331d6de6612de809c6cd74cdf3-SideWalls.scn"
_{ZOuMw�[remap]

path="res://.godot/exported/133200997/export-26d25227a53607047bb2c93ff57a73be-TopWall.scn"
�Fg�W���h�[remap]

path="res://.godot/exported/133200997/export-68579111cee3364e2480ce3d461adbec-EndScene.scn"
0$�t1n��'-[remap]

path="res://.godot/exported/133200997/export-efc710f71cc67b1c92c5451511245266-Menu.scn"
j���@̠���,o�   ��-K�   res://MainScene/Bullet.tscn{C#�!�e   res://MainScene/CameraWall.tscnFu��90   res://MainScene/Enemy.tscn����H�a   res://MainScene/Main.tscn@�V�t�y   res://MainScene/Player.tscn�TR�=qU   res://MainScene/SideWalls.tscn�fd���q   res://MainScene/TopWall.tscn��6}m��"   res://EndScene.tscn�׋g�0   res://Hurt.wav��M�А=   res://icon.svg��@���n   res://Menu.tscn�ʊV%�    res://Shot.mp3��+��Z�Aې(�_ECFG      application/config/name         CircleGuy 2.0      application/run/main_scene         res://Menu.tscn    application/config/features$   "         4.0    Forward Plus       input/move_left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         input/move_right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script         input/move_up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script         input/move_down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script         input/shoot_left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/shoot_right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/shoot_up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/shoot_down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/pause�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script      �0 ��rDc$C�~m