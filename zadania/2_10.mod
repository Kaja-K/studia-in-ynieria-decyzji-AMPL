option solver cplex;
reset;

# Parametry
param T; 	   # Liczba okresów
param d{1..T}; # Oszacowany popyt w okresie t
param q{1..T}; # Cena sprzedaży w okresie t
param c{1..T}; # Koszt produkcji w okresie t
param m{1..T}; # Koszt magazynowania w okresie t
param b{1..T}; # Koszt sprzedanego popytu w okresie t
param LB;      # Dolne ograniczenie początkowej produkcji
param UB;      # Górne ograniczenie początkowej produkcji
param p;       # Maksymalna zmiana produkcji w kolejnych okresach (w procentach)

# Zmienne decyzyjne
var produkcja{1..T} >= LB, <= UB; 	 # Produkcja w okresie t
var magazyn{1..T} >= 0;            	 # Magazyn w okresie t
var sprzedane{1..T} >= 0;         	 # Sprzedane w okresie t

# Funkcja celu: maksymalizacja zysku  (dochod ze sprzedazy - koszty produkcji - koszty magazynowania - koszty sprzedanego popytu)
maximize zysk: sum{t in 1..T} (q[t] * sprzedane[t] - c[t] * produkcja[t] - m[t] * magazyn[t] - b[t] * (d[t] - sprzedane[t]));

# Ograniczenia
subject to 
o_popyt{t in 1..T}: sprzedane[t] <= d[t];											# Popyt (sprzedane <= oszacowany popyt) 
o_magazyn: magazyn[1] = produkcja[1] - sprzedane[1];								# Stan początkowy magazynu
o_rórownowaga{t in 2..T}:	magazyn[t] = magazyn[t-1] + produkcja[t] - sprzedane[t];# Równowaga magazynowa
o_produkcja1 {t in 2..T}: produkcja[t] - produkcja[t-1] <= produkcja[t-1];			# Zmiana produkcji między miesiącami - dla wzrostu
o_produkcja2 {t in 2..T}: -p * produkcja[t-1] <= (produkcja[t] - produkcja[t-1]);	# Zmiana produkcji między miesiącami - dla spadku

# Dane																																																				
data;
param T := 10;
param d := 1 200 2 180 3 300 4 230 5 300 6 800 7 1100 8 900 9 400 10 300;
param q := 1 120 2 130 3 135 4 140 5 180 6 200 7 210 8 230 9 230 10 240;
param c := 1 50 2 60 3 55 4 60 5 40 6 50 7 60 8 65 9 60 10 70;
param m := 1 5 2 4 3 6 4 5 5 4 6 3 7 5 8 4 9 5 10 3;
param b := 1 4 2 3 3 3 4 2 5 2 6 3 7 2 8 3 9 2 10 3;
param LB:=180;
param UB:=250;
param p:=0.15;

solve;
display produkcja, magazyn, sprzedane, zysk;
# Wynik:  okres produkcja magazyn sprzedane
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
# zysk = 387620

end;