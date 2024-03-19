option solver cplex;
reset;

# Deklaracja parametrów
param n>0, integer;
param kotlety_limit{1..n}; 	# Limit kotletów
param cena{1..n};			# Cena sprzedaży kotletów
param koszt{1..n};			# Koszt kupna indyków
param proc_b{1..n};			# Zawartość procentowa mięsa białego
param biale{1..n};			# Mięso białe
param ciemne{1..n};			# Mięso ciemne

# Zmienne decyzyjne
var kotlety{i in 1..n} >= 0, <= kotlety_limit[i], integer;
var indyki{i in 1..n} >= 0, integer;

# Funkcja celu do zmaksymalizowania zysku (koszt produkcji - przychód z sprzedaży)
maximize zysk: sum{i in 1..n}kotlety[i]*cena[i] - sum{i in 1..n}indyki[i]*koszt[i]; 

# Ograniczenia
subject to
o_bialy:sum{i in 1..n} indyki[i]*biale[i] >= sum{i in 1..n}kotlety[i]*proc_b[i]; 			# Zawartość mięsa białego
o_ciemny:sum{i in 1..n} indyki[i]*ciemne[i] >= sum{i in 1..n}kotlety[i]*(1-proc_b[i]);  	# Zawartość mięsa ciemnego

# Dane
data;
param n:=2;
param kotlety_limit := 1 50 2 30;
param cena := 1 8 2 6;
param koszt := 1 10 2 8;
param proc_b := 1 0.7 2 0.5;
param biale := 1 3 2 1.5;
param ciemne := 1 2 2 4;

solve;
display kotlety, indyki, zysk;
# Wynik: 
#		kotlety indyki   
#	1    50      17
#	2    30       0
#zysk = 410

end;
