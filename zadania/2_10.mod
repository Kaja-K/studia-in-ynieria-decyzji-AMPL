option solver cplex;
reset;

# Parametry
param T; 	   # Liczba okresów
param d{1..T}; # Oszacowany popyt w okresie t
param q{1..T}; # Cena sprzedaży w okresie t
param c{1..T}; # Koszt produkcji w okresie t
param m{1..T}; # Koszt magazynowania w okresie t
param b{1..T}; # Koszt niesprzedanego popytu w okresie t
param LB;      # Dolne ograniczenie początkowej produkcji
param UB;      # Górne ograniczenie początkowej produkcji
param p;       # Maksymalna zmiana produkcji w kolejnych okresach (w procentach)

# Zmienne decyzyjne
var produkcja{1..T} >= LB, <= UB; 	 # Produkcja w okresie t
var magazyn{1..T} >= 0;            	 # Magazyn w okresie t
var niesprzedane{1..T} >= 0;         # Niesprzedany popyt w okresie t

# Funkcja celu: maksymalizacja zysku  (dochod ze sprzedazy - koszty produkcji - koszty magazynowania - koszty niesprzedanego popytu)
maximize zysk: sum{t in 1..T} (q[t] * (d[t] - niesprzedane[t]) - c[t] * produkcja[t] - m[t] * magazyn[t] - b[t] * niesprzedane[t]);

# Ograniczenia
subject to 
o_popyt{t in 1..T}: niesprzedane[t] <= d[t];						# Ograniczenie popytu - (niesprzedane[t]) nie przekracza oszacowanego popytu (d[t]) w każdym z okresów (t)
o_magazyn{t in 1..T}: magazyn[t] = if(t=1) then 0 					# Równowaga magazynowa - (magazyn[t]) jest równy stanowi magazynu z poprzedniego okresu (magazyn[t-1]), 
	else magazyn[t-1] + produkcja[t] - d[t] + niesprzedane[t-1];	#z dodaną produkcją, pomniejszoną o oszacowany popyt oraz z dodanym niesprzedanym popytem z poprzedniego okresu	

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
display produkcja, magazyn, niesprzedane, zysk;
# Wynik:  okres produkcja magazyn niesprzedane
#			1      180        0       200
#			2      250      270       180
#			3      250      400       300
#			4      250      720       230
#			5      250      900       300
#			6      250      650       800
#			7      250      600       250
#			8      250      200         0
#			9      250       50         0
#			10     250        0         0
# zysk = 387620

