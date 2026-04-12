extends Node2D

var dogru_kupa_no : int # Bilgisayarın gizlediği doğru kutu numarası

# Oyun ilk açıldığında çalışacak kısım
func _ready() -> void:
	# 1 ile 5 arasında rastgele bir sayı seçiyoruz
	dogru_kupa_no = randi_range(1, 5)
	
	# Test amaçlı: Doğru kutuyu konsola yazar (Aşağıdaki Output kısmında görürsün)
	print("Doğru kutu: ", dogru_kupa_no)

# Kutulara basıldığında çalışacak ana kontrol fonksiyonumuz
func kutu_kontrol(secilen_no: int):
	var secilen_box = get_node("Box"+str(secilen_no))
	if secilen_no == dogru_kupa_no:
		secilen_box.modulate=Color.GREEN
		$Label.text = "TEBRİKLER! Antikayı buldun!"
		$Label.modulate = Color.GREEN # Yazıyı yeşil yapar
		
		$Sprite2D.visible=true
		$Sprite2D.global_position = secilen_box.global_position + (secilen_box.size / 2)
	else:
		secilen_box.modulate=Color.GRAY
		secilen_box.disabled=true
		$Label.text = "Bu kutu yanlış"
		$Label.modulate = Color.RED # Yazıyı kırmızı yapar


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
