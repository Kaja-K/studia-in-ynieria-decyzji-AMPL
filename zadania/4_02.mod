option solver cplex;
reset;

# Parametry
set Samoloty;  							# Zbiór typów samolotów
set Trasy;  							# Zbiór tras lotniczych
param koszt_przelotu{Samoloty, Trasy};  # Koszt przelotu dla każdego typu samolotu na danej trasie
param koszt_utraconego_pasazera{Trasy}; # Koszt utraconego pasażera dla każdej trasy
param liczba_samolotow{Samoloty};  		# Dostępna liczba samolotów dla każdego typu
param pojemnosc_samolotow{Samoloty};  	# Pojemność pasażerska dla każdego typu samolotu
param limit_lotow{Samoloty, Trasy};  	# Limit lotów dla każdego typu samolotu na danej trasie
param liczba_pasazerow{Trasy};  		# Liczba pasażerów oczekujących na każdej trasie

# Zmienne decyzyjne - Liczba lotów danym samolotem na danej trasie
var x{Samoloty, Trasy} >= 0, integer;

# Funkcja celu - Koszt przelotu + Koszt utraconych pasażerów
minimize Koszt:
    sum{i in Samoloty, j in Trasy} (x[i,j] * koszt_przelotu[i,j])
  + sum{j in Trasy} (liczba_pasazerow[j] - sum{i in Samoloty} x[i,j] * pojemnosc_samolotow[i]) * koszt_utraconego_pasazera[j]; 

# Ograniczenia
o_Limit_lotow{i in Samoloty, j in Trasy}:x[i,j] <= limit_lotow[i,j];		   # Limit lotów dla każdego typu samolotu na danej trasie
o_Limit_samolotow{i in Samoloty}:sum{j in Trasy} x[i,j] <= liczba_samolotow[i];# Limit dostępnych samolotów dla każdego typu

# Dane
data;
param: Samoloty: liczba_samolotow, pojemnosc_samolotow:='Typ-1' 5 50 'Typ-2' 8 30 'Typ-3' 10 20;
param: Trasy: koszt_utraconego_pasazera, liczba_pasazerow:= 'Trasa-1' 40 1000 'Trasa-2' 50 2000 'Trasa-3' 45 900 'Trasa-4' 70 1200;
param koszt_przelotu: 'Trasa-1' 'Trasa-2' 'Trasa-3' 'Trasa-4' := 'Typ-1' 1000 1100 1200 1500 'Typ-2' 800 900 1000 1000 'Typ-3' 600 800 800 900;
param limit_lotow: 'Trasa-1' 'Trasa-2' 'Trasa-3' 'Trasa-4' := 'Typ-1' 3 2 2 1 'Typ-2' 4 3 3 2 'Typ-3' 5 5 4 2;

solve;  
display x, Koszt;  
# Wynik: Koszt = 249800
# Typ-1 Trasa-1   0
# Typ-1 Trasa-2   2
# Typ-1 Trasa-3   2
# Typ-1 Trasa-4   1
# Typ-2 Trasa-1   3
# Typ-2 Trasa-2   3
# Typ-2 Trasa-3   0
# Typ-2 Trasa-4   2
# Typ-3 Trasa-1   5
# Typ-3 Trasa-2   3
# Typ-3 Trasa-3   0
# Typ-3 Trasa-4   2

end;
