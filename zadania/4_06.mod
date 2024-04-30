option solver cplex;
reset;

# Parametry
param n; # Paczki
param r; # Czujniki
set PACZKI within 1..n cross 1..n; # Paczki mają dwie współrzędne - wiersz i kolumne

# Zmienna decyzyjna 
var kamery {1..n,1..n} binary;

# Funkcja celu
minimize liczba_kamer: sum{i in 1..n, j in 1..n} kamery[i,j];

# Ograniczenia
o_paczka_to_nie_kamera{(i,j)in PACZKI}: kamery [i,j] = 0; 																					# Na tych polach nie ma kamer
o_czy_paczka_obserwowana{(k,l) in PACZKI}: sum{j in max(l-r,1)..min(l+r,n)} kamery[k,j] + sum{j in max(k-r,1)..min(k+r,n)}kamery[j,l] >= 1; # Suma kamer w  paczek, czy każda paczka jest obserwowana przez conajmniej jedna kamere 

# Dane
data;
param n:=10;
param r:=4;
set PACZKI:= 2 4 1 6 4 7 2 7 1 3 4 4 2 9 8 3 9 5 5 1 8 10 7 7;

solve;
for{i in 1..n}{for{j in 1..n} 
		printf "%s", if kamery[i,j]==1 then " c " else if (i,j) in PACZKI then  " P " else " . ";
		printf "\n";}

# Wynik:
# .  .  P  c  .  P  .  .  .  . 
# .  .  .  P  .  c  P  .  P  . 
# .  .  .  .  .  .  .  .  .  . 
# .  .  .  P  .  .  P  .  .  . 
# P  .  .  .  c  .  .  .  .  . 
# .  .  .  .  .  .  .  .  .  . 
# .  .  .  .  .  .  P  .  .  . 
# .  .  P  .  .  .  c  .  .  P 
# .  .  .  .  P  .  .  .  .  . 
# .  .  .  .  .  .  .  .  .  .  

end;
