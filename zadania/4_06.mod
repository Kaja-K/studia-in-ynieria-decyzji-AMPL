option solver cplex;
reset;

# Parametry
param p;							# Liczba paczek
param z;							# Zasięg czujnika
set Paczki within 1..p cross 1..p;	# Paczki mają dwie współrzędne - wiersz i kolumnę

# Zmienna decyzyjna - binarna macierz reprezentująca obecność kamery na danej paczce
var kamery {1..p, 1..p} binary;

# Funkcja celu - Minimalizacja liczby kamer
minimize liczba_kamer: sum{i in 1..p, j in 1..p} kamery[i,j];

# Ograniczenia
o_p_to_nie_kamera{(i,j) in Paczki}: kamery[i,j] = 0;  # Na tych polach nie ma kamer
o_czy_p_obserwowana{(k,l) in Paczki}: 				  # Suma kamer w paczkach, czy każda paczka jest obserwowana przez co najmniej jedną kamerę
    sum{j in max(l-z,1)..min(l+z,p)} kamery[k,j] + 
    sum{j in max(k-z,1)..min(k+z,p)} kamery[j,l] >= 1; 		

data;
param p := 10;
param z := 4;
set Paczki := 2 4 1 6 4 7 2 7 1 3 4 4 2 9 8 3 9 5 5 1 8 10 7 7;

solve;
for{i in 1..p}{for{j in 1..p} printf "%s", if kamery[i,j]==1 then " c " else if (i,j) in Paczki then  " P " else " . "; printf "\n";}
# Wynik: 	.  .  P  c  .  P  .  .  .  . 
# 			.  .  .  P  .  c  P  .  P  . 
#  			.  .  .  .  .  .  .  .  .  . 
#  			.  .  .  P  .  .  P  .  .  . 
#  			P  .  .  .  c  .  .  .  .  . 
#  			.  .  .  .  .  .  .  .  .  . 
#  			.  .  .  .  .  .  P  .  .  . 
#  			.  .  P  .  .  .  c  .  .  P 
#  			.  .  .  .  P  .  .  .  .  . 
#  			.  .  .  .  .  .  .  .  .  .  

end;