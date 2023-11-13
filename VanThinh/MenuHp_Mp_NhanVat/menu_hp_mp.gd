extends Control

@export var statistics:StatisticsComponent

var MAX_MAU = 100
var MAX_MP = 500
var MAX_PHONG_THU = 120
var mau = MAX_MAU
var mp = MAX_MP
var phong_thu = MAX_PHONG_THU


func _ready():
	MAX_MAU=statistics.max_health
	mau=MAX_MAU
	#mau = 60
	set_mau_label()
	set_mau_bar()
	#mp=400
	set_mp_label()
	set_mp_bar()
	#phong_thu = 120
	set_phong_thu_label()
	set_phong_thu_bar()
	
func _process(delta):
	mau=statistics.health
	set_mau_bar()
	set_mau_label()
	
	
	
func set_mau_label():
	$BackgroudBang/hp/ChiSoHP.text = "%s" %mau + "/%s" %MAX_MAU

func set_mau_bar():
	$BackgroudBang/hp.value = mau

func set_mp_label():
	$BackgroudBang/mana/ChiSoMP.text = "%s" %mp + "/%s" %MAX_MP
	
func set_mp_bar():
	$BackgroudBang/mana.value = mp
	
	
func set_phong_thu_label():
	$BackgroudBang/phongthu/ChiSoPhongThu.text = "%s" %phong_thu + "/%s" %MAX_PHONG_THU
	
func set_phong_thu_bar():
	$BackgroudBang/phongthu.value = phong_thu
