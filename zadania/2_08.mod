option solver cplex;
reset;

# Definicja zestawu danych
set benzyna;  				# Zbiór rodzajów benzyny
param popyt{benzyna};  		# Parametr popytu na poszczególne rodzaje benzyny
param zyski{benzyna};  		# Parametr zysku jednostkowego z produkcji poszczególnych rodzajów benzyny
param minimalna_ON{benzyna};# Parametr minimalnej liczby oktanowej dla poszczególnych rodzajów benzyny
param ropa_na_jednostke;  	# Parametr ilości ropy potrzebnej do produkcji jednostki benzyny
param max_ropa;  			# Parametr maksymalnej ilości dostępnej ropy
param max_krakowanie;  		# Parametr maksymalnej ilości paliwa ON=98 wytwarzanej w module krakowania

# Zmienne decyzyjne
var x1{benzyna} >= 0;  # Ilość benzyny "normalnej" produkowanej dziennie
var x2{benzyna} >= 0;  # Ilość benzyny "premium" produkowanej dziennie
var x3{benzyna} >= 0;  # Ilość benzyny "super" produkowanej dziennie
var y >= 0;            # Ilość paliwa ON=98 wytwarzanego dziennie w module krakowania

# Funkcja celu - maksymalizacja całkowitego zysku
maximize zysk: sum{b in benzyna} zyski[b] * (x1[b] + x2[b] + x3[b]);

# Ograniczenia
subject to 
o_ropa: sum{b in benzyna} (x1[b] + x2[b] + x3[b]) * ropa_na_jednostke <= max_ropa;  	# Ograniczenie ilości zużywanej ropy
o_krakowanie: y <= max_krakowanie;                                                 		# Ograniczenie ilości paliwa ON=98 w module krakowania
o_ON1: (x1["normal"] * 82 + y * 98) / (x1["normal"] + y) >= minimalna_ON["normal"];  	# Ograniczenie minimalnej liczby oktanowej dla benzyny "normalnej"
o_ON2: (x2["premium"] * 82 + y * 98) / (x2["premium"] + y) >= minimalna_ON["premium"];  # Ograniczenie minimalnej liczby oktanowej dla benzyny "premium"
o_ON3: (x3["super"] * 82 + y * 98) / (x3["super"] + y) >= minimalna_ON["super"];  		# Ograniczenie minimalnej liczby oktanowej dla benzyny "super"

# Dane
data;
set benzyna := "normal" "premium" "super";
param popyt := "normal" 50000 "premium" 30000 "super" 40000;
param zyski := "normal" 6.7 "premium" 7.2 "super" 8.1;
param minimalna_ON := "normal" 87 "premium" 89 "super" 92;
param ropa_na_jednostke := 5;
param max_ropa := 1500000;
param max_krakowanie := 200000;

solve;

display x1, x2, x3, zysk;
# Wynik: :        x1  x2  x3    
#		normal    0   0   0
#		premium   0   0   0
#		super     0   0   0
#zysk = 0 - ?

end;
