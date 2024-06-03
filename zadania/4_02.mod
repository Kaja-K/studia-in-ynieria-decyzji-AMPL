option solver cplex;
reset;

# Parametry
set samoloty; # Zbiór typów samolotów
set trasy; # Zbiór tras lotniczych
param pojemnosc_samolotow{samoloty}; # Pojemność pasażerska dla każdego typu samolotu
param dostepne_samoloty{samoloty}; # Dostępna liczba samolotów dla każdego typu
param liczba_lotow{samoloty, trasy}; # Liczba lotów dla każdego typu samolotu na danej trasie
param liczba_pasazerow{trasy}; # Liczba pasażerów oczekujących na każdej trasie
param koszt_lotu{samoloty, trasy}; # Koszt przelotu dla każdego typu samolotu na danej trasie
param koszt_utraconych_pasazerow{trasy}; # Koszt utraconych pasażerów dla każdej trasy

# Zmienne decyzyjne
# Liczba samolotów typu s na trasie t
var samoloty_na_trasie{samoloty, trasy} >= 0, integer; 	
var nadwyzka_pasazerow{trasy} >= 0, integer; 
var niedobor_pasazerow{trasy} >= 0, integer; 

# Funkcja celu - Minimalizacja kosztów na które składa się: Suma kosztów przelotu na wszystkich trasach, uwzględniająca liczbę lotów każdego typu samolotu i ich koszty + 
														  # Koszt utraconych pasażerów na wszystkich trasach, uwzględniający nadwyżkę pasażerów nad dostępną pojemnością samolotów.
minimize koszt: sum{s in samoloty, t in trasy} (koszt_lotu[s,t] * liczba_lotow[s,t] * samoloty_na_trasie[s,t]) +  
				sum{t in trasy} (koszt_utraconych_pasazerow[t] * nadwyzka_pasazerow[t]); 

# Ograniczenia
# Liczba samolotów na każdej trasie nie może przekroczyć dostępnej liczby samolotów dla danego typu.
o_dostepnej_liczby{s in samoloty}:sum{t in trasy} samoloty_na_trasie[s,t] <= dostepne_samoloty[s];
# Suma pojemności wszystkich samolotów na danej trasie musi być równa liczbie pasażerów, uwzględniając nadwyżkę lub niedobór pasażerów.
o_pojemnosci{t in trasy}:sum{s in samoloty} (liczba_lotow[s,t] * pojemnosc_samolotow[s] * samoloty_na_trasie[s,t]) = liczba_pasazerow[t] - nadwyzka_pasazerow[t] + niedobor_pasazerow[t]; 

data;
param:samoloty: dostepne_samoloty, pojemnosc_samolotow :="S1" 5 50 "S2" 8 30 "S3" 10 20;
param: trasy: liczba_pasazerow, koszt_utraconych_pasazerow := "TR1" 1000 40 "TR2" 2000 50 "TR3" 900 45 "TR4" 1200 70;
param koszt_lotu: "TR1" "TR2" "TR3" "TR4" := "S1" 1000 1100 1200 1500 "S2" 800 900 1000 1000 "S3" 600 800 800 900;
param liczba_lotow:"TR1" "TR2" "TR3" "TR4" :="S1" 3 2 2 1 "S2" 4 3 3 2 "S3" 5 5 4 2;

solve;
display koszt, samoloty_na_trasie, niedobor_pasazerow, nadwyzka_pasazerow;
end;