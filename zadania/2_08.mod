option solver cplex;
reset;

# Definicja zestawu danych
param popyt{benzyna in {"normal", "premium", "super"}};  		# Popyt na poszczególne rodzaje benzyny
param zyski{benzyna in {"normal", "premium", "super"}};  		# Zysk jednostkowy z produkcji poszczególnych rodzajów benzyny
param minimalna_ON{benzyna in {"normal", "premium", "super"}};	# Minimalna liczba oktanowa dla poszczególnych rodzajów benzyny
param ropa;  													# Ilość ropy potrzebnej do produkcji jednostki benzyny
param max_ropa;  												# Maksymalna ilość dostępnej ropy
param max_krakowanie;  											# Maksymalna ilość paliwa ON=98 wytwarzana w module krakowania

# Zmienne decyzyjne
var x1{benzyna in {"normal", "premium", "super"}} >= 0; # Ilość benzyny "normalnej" produkowanej dziennie
var x2{benzyna in {"normal", "premium", "super"}} >= 0; # Ilość benzyny "premium" produkowanej dziennie
var x3{benzyna in {"normal", "premium", "super"}} >= 0; # Ilość benzyny "super" produkowanej dziennie
var y >= 0;            									# Ilość paliwa ON=98 wytwarzanego dziennie w module krakowania

# Funkcja celu - maksymalizacja całkowitego zysku
maximize zysk: sum{b in {"normal", "premium", "super"}} zyski[b] * (x1[b] + x2[b] + x3[b]);

# Ograniczenia
subject to 
o_ropa: sum{b in {"normal", "premium", "super"}} (x1[b] + x2[b] + x3[b]) * ropa <= max_ropa;# Ilość zużywanej ropy
o_krakowanie: y <= max_krakowanie;                                                          # Ilość paliwa ON=98 w module krakowania
o_ON1: (x1["normal"] * 82 + y * 98) / (x1["normal"] + y) >= minimalna_ON["normal"];         # Minimalna liczba oktanowa dla benzyny "normalnej"
o_ON2: (x2["premium"] * 82 + y * 98) / (x2["premium"] + y) >= minimalna_ON["premium"];      # Minimalna liczba oktanowa dla benzyny "premium"
o_ON3: (x3["super"] * 82 + y * 98) / (x3["super"] + y) >= minimalna_ON["super"];            # Minimalna liczba oktanowa dla benzyny "super"

# Dane
data;
param ropa := 5;
param max_ropa := 1500000;
param max_krakowanie := 200000;
param popyt := "normal" 50000, "premium" 30000, "super" 40000;
param zyski :=  "normal" 6.7, "premium" 7.2, "super" 8.1;
param minimalna_ON :=  "normal" 87, "premium" 89, "super" 92;

solve;
display x1, x2, x3, zysk;
# Wynik: :        x1  x2  x3    
#		normal    0   0   0
#		premium   0   0   0
#		super     0   0   0
#zysk = 0 - ?

end;
