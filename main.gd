extends Node2D

# --- 1. MİNİ OYUN: KUPA BULMA ---
var dogru_kupa_no : int # Bilgisayarın gizlediği doğru kutu numarası

# --- 2. MİNİ OYUN: HIZ İBRESİ (Yatay Bar) ---
var move_speed: float = 5.0 # İbrenin gidiş geliş hızı
var max_distance: float = 2450.0 # İbrenin merkezden sağa/sola maksimum kaç piksel gideceği
var green_zone_limit: float = 460.0 # Yeşil alanın piksel sınırı (Merkezden sağa sola hata payı)

var time_passed: float = 0.0
var is_playing_meter: bool = true
var meter_attempts: int = 3

# İbreyi eklediğinde bu yorum satırını aç:
@onready var needle_sprite = $BackGroundSpeedoMeter/Needle
# İbrenin sıfır (0) noktasına, yani yatay barın tam orta merkezine yerleştirildiğini varsayıyoruz.

#When the game start this code will execute
func _ready() -> void:
	#randomly select a true box 
	dogru_kupa_no = randi_range(1, 5) 
	print("Doğru kutu: ", dogru_kupa_no)
	
	#Speed game begins
	start_meter_round()

# --- İBRE OYUNUNUN ÇALIŞMA MANTIĞI ---

# Her karede (frame) çalışır
func _process(delta: float) -> void:
	if is_playing_meter:
		time_passed += delta
		
		# -cos() fonksiyonu 0. saniyede -1 (en sol) değerini verir.
		# Sonra 0'a (orta), sonra 1'e (en sağ) gider ve tekrar geri döner.
		# Bu sayede tam istediğin gibi uçlarda yavaş, ortada çok hızlı bir hareket yakalanır.
		# Represent the ration of the needle according to background
		# -1 leftmost, 0 middle, 1 rightmost
		var current_swing = -cos(time_passed * move_speed) 

		
		# Currently needle position x value holds -2450 to 2450
		var current_x = current_swing * max_distance
		
		# Eğer sahnene ibre eklediysen yorumu aç:
		needle_sprite.position.x = current_x # Y eksenini sabit tut, sadece X'i değiştir
		
		# Konsola yazdırma: 
		# print("İbre X Pozisyonu: ", current_x)

# Herhangi bir tuşa basıldığında çalışır
func _input(event: InputEvent) -> void:
	if is_playing_meter and event.is_action_pressed("ui_accept"): 
		stop_needle()

# İbreyi durduran ve kazanma/kaybetme kontrolünü yapan fonksiyon
func stop_needle() -> void:
	is_playing_meter = false
	
	# Durduğu andaki net pozisyonu bul
	var stopped_x = -cos(time_passed * move_speed) * max_distance
	print("İbre durduruldu! Merkezden Uzaklık: ", stopped_x)
	
	# Yeşil alan kontrolü (X pozisyonu merkeze +/- green_zone_limit kadar yakın mı?)
	if abs(stopped_x) <= green_zone_limit:
		print("TEBRİKLER KAZANDIN! İbre tam yeşil alanda.")
		# Burada ödül verebilir, "Kazandın" UI'i çıkarabilirsin.
	else:
		meter_attempts -= 1
		print("Başarısız! Kırmızı veya Turuncuda durdun. Kalan Hakkın: ", meter_attempts)
		
		if meter_attempts > 0:
			print("1 saniye sonra tekrar başlayacak...")
			await get_tree().create_timer(1.0).timeout 
			start_meter_round()
		else:
			print("İBRE OYUNU BİTTİ. Deneme hakların tükendi.")

func start_meter_round() -> void:
	is_playing_meter = true
	time_passed = 0.0 # Zaman sıfırlandığında -cos(0) = -1 olur, yani en soldan (kırmızıdan) başlar.
	print("İbre Oyunu Başladı! SPACE tuşuna basarak tam yeşildeyken durdur.")

# --- KUPA OYUNUNUN ÇALIŞMA MANTIĞI KISMI ---
func kutu_kontrol(secilen_no: int):
	var secilen_box = get_node("Box"+str(secilen_no))
	if secilen_no == dogru_kupa_no:
		secilen_box.modulate=Color.GREEN
		$Label.text = "TEBRİKLER! Antikayı buldun!"
		$Label.modulate = Color.GREEN 
		
		$Sprite2D.visible=true
		$Sprite2D.global_position = secilen_box.global_position + (secilen_box.size / 2)
	else:
		secilen_box.modulate=Color.GRAY
		secilen_box.disabled=true
		$Label.text = "Bu kutu yanlış"
		$Label.modulate = Color.RED 

func _on_box_1_pressed() -> void:
	kutu_kontrol(1)

func _on_box_2_pressed() -> void:
	kutu_kontrol(2)

func _on_box_3_pressed() -> void:
	kutu_kontrol(3)

func _on_box_4_pressed() -> void:
	kutu_kontrol(4)

func _on_box_5_pressed() -> void:
	kutu_kontrol(5)
