option solver cplex;
reset;

# Parametry
param n > 0, integer;  		# Liczba miesięcy
param popyt{1..n};        	# Popyt na kukurydzę w każdym miesiącu
param gotowka_poczatkowa;	# Początkowa ilość gotówki
param kukurydza_poczatkowa; # Początkowa ilość kukurydzy w magazynie
param cena_kupna{1..n};   	# Cena kupna kukurydzy w każdym miesiącu
param koszt_kupna{1..n};  	# Koszt zakupu kukurydzy w każdym miesiącu
param pojemnosc_magazynu;   # Pojemność magazynu

# Zmienne decyzyjne
var gotowka{1..n} >= 0;       			# Ilość gotówki na koniec każdego miesiąca
var kupiona_kukurydza{1..n} >= 0;   	# Ilość kupionej kukurydzy w każdym miesiącu
var sprzedana_kukurydza{1..n} >= 0; 	# Ilość sprzedanej kukurydzy w każdym miesiącu
var ilosc_kukurydzy_magazyn{1..n} >= 0; # Ilość kukurydzy w magazynie na koniec każdego miesiąca

# Funkcja celu - Maksymalizacja gotówki na koniec okresu
maximize zysk: gotowka[n];

# Ograniczenia 
o_gotowka_poczatkowa: gotowka[1] = gotowka_poczatkowa - kupiona_kukurydza[1]*koszt_kupna[1] + sprzedana_kukurydza[1]*cena_kupna[1];  		# Stan konta na początku
o_gotowka{i in 2..n}: gotowka[i] = gotowka[i-1] - kupiona_kukurydza[i]*koszt_kupna[i] + sprzedana_kukurydza[i]*cena_kupna[i]; 				# Stan konta w każdym miesiącu
o_kukurydza_poczatkowa: ilosc_kukurydzy_magazyn[1] = kukurydza_poczatkowa + kupiona_kukurydza[1] - sprzedana_kukurydza[1];  				# Stan magazynu na początku
o_kukurydza_magazyn{i in 2..n}: ilosc_kukurydzy_magazyn[i] = ilosc_kukurydzy_magazyn[i-1] + kupiona_kukurydza[i] - sprzedana_kukurydza[i];	# Stan magazynu w każdym miesiącu
o_pojemnosc_magazynu: kukurydza_poczatkowa + kupiona_kukurydza[1] - sprzedana_kukurydza[1] <= pojemnosc_magazynu;  							# Pojemność magazynu na początku
o_pojemnosc_magazynu_mies{i in 2..n}: ilosc_kukurydzy_magazyn[i-1] + kupiona_kukurydza[i] - sprzedana_kukurydza[i] <= pojemnosc_magazynu;  	# Pojemność magazynu w każdym miesiącu
o_sprzedaz_kukurydzy{i in 1..n}: sprzedana_kukurydza[i] <= popyt[i];  																		# Sprzedaż do popytu

data;
param n:=4;
param popyt:= 1 50 2 75 3 100 4 80;
param gotowka_poczatkowa:= 2000;
param kukurydza_poczatkowa:= 100;
param koszt_kupna:= 1 200 2 100 3 200 4 300; 
param cena_kupna:= 1 320 2 300 3 250 4 400;
param pojemnosc_magazynu:= 200;

solve;
display zysk, gotowka, kupiona_kukurydza, sprzedana_kukurydza, ilosc_kukurydzy_magazyn;
# Wynik:zysk = 77000
# gotowka kupiona_kukurydza sprzedana_kukurydza ilosc_kukurydzy_magazyn
# 1   18000           0                 50                    50
# 2   20000         205                 75                   180
# 3   45000           0                100                    80
# 4   77000           0                 80                     0

end;