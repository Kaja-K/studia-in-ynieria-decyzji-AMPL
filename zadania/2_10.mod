option solver cplex;
reset;

# Parametry
param n;             						# Liczba okresów
param oszacowany_popyt{1..n}; 				# Oszacowany popyt w okresie t
param cena_sprzedazy{1..n};   			 	# Cena sprzedaży w okresie t
param koszt_produkcji{1..n};    			# Koszt produkcji w okresie t
param koszt_magazynowania{1..n};			# Koszt magazynowania w okresie t
param koszt_niezaspokojonego_popytu{1..n}; 	# Koszt sprzedanego popytu w okresie t
param dolne_ograniczenie_produkcji;      	# Dolne ograniczenie początkowej produkcji
param gorne_ograniczenie_produkcji;      	# Górne ograniczenie początkowej produkcji
param maksymalna_zmiana_produkcji;       	# Maksymalna zmiana produkcji w kolejnych okresach (w procentach)

# Zmienne decyzyjne
var produkcja{1..n} >= dolne_ograniczenie_produkcji, <= gorne_ograniczenie_produkcji;   # Produkcja w okresie t
var magazyn{1..n} >= 0;                 												# Magazyn w okresie t
var sprzedane{1..n} >= 0;               												# Sprzedane w okresie t

# Funkcja celu -  Maksymalizacja zysku (dochod ze sprzedazy - koszty produkcji - koszty magazynowania - koszty sprzedanego popytu)
maximize zysk: sum{t in 1..n} (cena_sprzedazy[t] * sprzedane[t] - 
								koszt_produkcji[t] * produkcja[t] - 
								koszt_magazynowania[t] * magazyn[t] - 
								koszt_niezaspokojonego_popytu[t] * 
								(oszacowany_popyt[t] - sprzedane[t]));
# Ograniczenia
o_popytu{t in 1..n}: sprzedane[t] <= oszacowany_popyt[t]; 															# Popyt
o_magazynu: magazyn[1] = produkcja[1] - sprzedane[1];     															# Stan początkowy magazynu
o_rownowagi{t in 2..n}: magazyn[t] = magazyn[t-1] + produkcja[t] - sprzedane[t];    								# Równowaga magazynowa
o_zmiany_produkcji1 {t in 2..n}: produkcja[t] - produkcja[t-1] <= produkcja[t-1] * maksymalna_zmiana_produkcji;	  	# Zmiana produkcji między miesiącami - dla wzrostu
o_zmiany_produkcji2 {t in 2..n}: -maksymalna_zmiana_produkcji * produkcja[t-1] <= (produkcja[t] - produkcja[t-1]); 	# Zmiana produkcji między miesiącami - dla spadku
																																																	
data;
param n := 10;
param oszacowany_popyt := 1 200 2 180 3 300 4 230 5 300 6 800 7 1100 8 900 9 400 10 300;
param cena_sprzedazy  := 1 120 2 130 3 135 4 140 5 180 6 200 7 210 8 230 9 230 10 240;
param koszt_produkcji  := 1 50 2 60 3 55 4 60 5 40 6 50 7 60 8 65 9 60 10 70;
param koszt_magazynowania  := 1 5 2 4 3 6 4 5 5 4 6 3 7 5 8 4 9 5 10 3;
param koszt_niezaspokojonego_popytu  := 1 4 2 3 3 3 4 2 5 2 6 3 7 2 8 3 9 2 10 3;
param dolne_ograniczenie_produkcji :=180;
param gorne_ograniczenie_produkcji :=250;
param maksymalna_zmiana_produkcji :=0.15;

solve;
display zysk, produkcja, magazyn, sprzedane;
# Wynik: zysk = 383850
# 		okres produkcja magazyn sprzedane
#			1      250      250         0
#			2      250      500         0
#			3      250      750         0
#			4      250     1000         0
#			5      250     1250         0
#			6      250     1500         0
#			7      250      850       900
#			8      250      200       900
#			9      250       50       400
#			10     250        0       300

end;