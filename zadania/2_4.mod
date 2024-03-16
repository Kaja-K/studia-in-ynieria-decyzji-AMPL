option solver cplex;
reset;

# Deklaracja parametrów
param n > 0, integer;  	# Liczba miesięcy
param popyt{1..n};     	# Popyt na kukurydzę w każdym miesiącu
param gotowka_start; 	# Początkowa ilość gotówki
param k_start;  		# Początkowa ilość kukurydzy w magazynie
param cena{1..n};      	# Cena kukurydzy w każdym miesiącu
param koszt{1..n};     	# Koszt zakupu kukurydzy w każdym miesiącu
param magazyn;         	# Pojemność magazynu

# Zmienne decyzyjne
var gotowka{i in 1..n} >= 0;     # Ilość gotówki na koniec każdego miesiąca
var k_kupiona{i in 1..n} >= 0;   # Ilość kupionej kukurydzy w każdym miesiącu
var k_sprzedana{i in 1..n} >= 0; # Ilość sprzedanej kukurydzy w każdym miesiącu
var k_magazyn{i in 1..n} >= 0;   # Ilość kukurydzy w magazynie na koniec każdego miesiąca

# Funkcja celu - maksymalizacja zysku na koniec okresu
maximize zysk: gotowka[n];

# Ograniczenia 
subject to
o_start: gotowka[1] = gotowka_start - k_kupiona[1]*koszt[1] + k_sprzedana[1]*cena[1];  				# Stan konta na początku
o_miesiac{i in 2..n}: gotowka[i] = gotowka[i-1] - k_kupiona[i]*koszt[i] + k_sprzedana[i]*cena[i];  	# Stan konta w każdym miesiącu
o_magazyn: k_magazyn[1] = k_start + k_kupiona[1] - k_sprzedana[1];  								# Stan magazynu na początku
o_magazyn_mies{i in 2..n}: k_magazyn[i] = k_magazyn[i-1] + k_kupiona[i] - k_sprzedana[i];			# Stan magazynu w każdym miesiącu
o_pojemność: k_start + k_kupiona[1] - k_sprzedana[1] <= magazyn;  									# Pojemność magazynu na początku
o_pojemność_mies{i in 2..n}: k_magazyn[i-1] + k_kupiona[i] - k_sprzedana[i] <= magazyn;  			# Pojemność magazynu w każdym miesiącu
o_sprzedaż{i in 1..n}: k_sprzedana[i] <= popyt[i];  												# Sprzedaż do popytu

# Dane
data;
param n:=4;
param popyt:= [1] 50 [2] 75 [3] 100 [4] 80;
param gotowka_start:= 2000;
param k_start:= 100;
param koszt:= [1] 200 [2] 100 [3] 200 [4] 300; 
param cena:= [1] 320 [2] 300 [3] 250 [4] 400;
param magazyn:= 200;

solve;
display gotowka, k_kupiona, k_sprzedana, k_magazyn, zysk;

#Wynik: gotowka k_kupiona k_sprzedana k_magazyn
#	1   18000       0         50         50
#	2   20000     205         75        180
#	3   45000       0        100         80
#	4   77000       0         80          0
# Zysk = 77000

end;
