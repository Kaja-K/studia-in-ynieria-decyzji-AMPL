option solver cplex;
reset;

# Parametry
param liczba_paczek;	# Liczba paczek
param zasieg;			# Zasięg czujnika

# Paczki mają dwie współrzędne - wiersz i kolumnę
set Paczki within 1..liczba_paczek cross 1..liczba_paczek;	

# Zmienna decyzyjna 
var kamery {1..liczba_paczek, 1..liczba_paczek} binary;

# Funkcja celu
minimize liczba_kamer: sum{i in 1..liczba_paczek, j in 1..liczba_paczek} kamery[i,j];

# Ograniczenia
o_paczka_to_nie_kamera{(i,j) in Paczki}: kamery[i,j] = 0; 																																	# Na tych polach nie ma kamer
o_czy_paczka_obserwowana{(k,l) in Paczki}: sum{j in max(l-zasieg,1)..min(l+zasieg,liczba_paczek)} kamery[k,j] + sum{j in max(k-zasieg,1)..min(k+zasieg,liczba_paczek)} kamery[j,l] >= 1; 	# Suma kamer w paczkach, czy każda paczka jest obserwowana przez co najmniej jedną kamerę

# Dane
data;
param liczba_paczek := 10;
param zasieg := 4;
set Paczki := 
    2 4 1 6 4 7 2 7 1 3 
    4 4 2 9 8 3 9 5 5 1 
    8 10 7 7;

solve;
for{i in 1..liczba_paczek}{for{j in 1..liczba_paczek} printf "%s", if kamery[i,j]==1 then " c " else if (i,j) in Paczki then  " P " else " . "; printf "\n";}
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
