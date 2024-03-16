option solver cplex;
reset;

# Zdefiniowanie parametrów
param zadania>0, integer; # Liczba zadań
param zysk{1..zadania};   # Zysk z wykonania każdego zadania
param termin{1..zadania}; # Termin wykonania każdego zadania
param godziny{1..zadania};# Godziny potrzebne do wykonania każdego zadania
param limit_godz;  		  # Limit dostępnych godzin roboczych

# Definicja zmiennych decyzyjnych - Ilość godzin poświęconych na wykonanie każdego zadania
var ilość_godz{i in 1..zadania} >=0, <= termin[i]; 

# Funkcja celu do zmaksymalizowania zysku
maximize maks_zysk: sum{i in 1..zadania} zysk[i]*ilość_godz[i];  

# Ograniczenia - Dostępne godziny robocze
subject to o_godziny: sum{i in 1..zadania}  godziny[i]*ilość_godz[i] <= limit_godz;  

# Przypisanie wartości parametrów
data;
param zadania := 2;  					
param zysk := [1] 120 [2] 80; 
param termin := [1] 20 [2] 40;  	
param godziny := [1] 20 [2] 10;  		
param limit_godz := 500;  			

solve;

display ilość_godz, maks_zysk; 
# Wynik: 1 = 5, 2 = 40, maks_zysk = 3800

end;
