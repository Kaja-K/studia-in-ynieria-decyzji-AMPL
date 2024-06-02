option solver cplex;
reset;

# Parametry
set samoloty;  								# Zbiór typów samolotów
set trasy;  								# Zbiór tras lotniczych
param pojemnosc_samolotow{samoloty};	  	# Pojemność pasażerska dla każdego typu samolotu
param dostepne_samoloty{samoloty};  		# Dostępna liczba samolotów dla każdego typu
param liczba_lotow{samoloty, trasy}; 		# Liczba lotów dla każdego typu samolotu na danej trasie
param liczba_pasazerow{trasy};  			# Liczba pasażerów oczekujących na każdej trasie
param koszt_lotu{samoloty, trasy};  		# Koszt przelotu dla każdego typu samolotu na danej trasie
param koszt_utraconych_pasazerow{trasy}; 	# Koszt utraconych pasażerów dla każdej trasy

# Zmienne decyzyjne
var samoloty_na_trasie{samoloty, trasy} >= 0, integer; 	# Liczba samolotów typu i na trasie j
var nadwyzka_pasazerow{trasy} >= 0, integer; 			# Nadwyżka pasażerów
var niedobor_pasazerow{trasy} >= 0, integer; 			# Niedobór pasażerów

# Funkcja celu - Minimalizacja kosztów na które składa się: Suma kosztów przelotu na wszystkich trasach, uwzględniająca liczbę lotów każdego typu samolotu i ich koszty + Koszt utraconych pasażerów na wszystkich trasach, uwzględniający nadwyżkę pasażerów nad dostępną pojemnością samolotów.
minimize koszt: sum{i in samoloty, j in trasy} (koszt_lotu[i,j] * liczba_lotow[i,j] * samoloty_na_trasie[i,j]) + 
				sum{j in trasy} (koszt_utraconych_pasazerow[j] * nadwyzka_pasazerow[j]); 

# Ograniczenia
o_dostepnej_liczby{i in samoloty}:sum{j in trasy} samoloty_na_trasie[i,j] <= dostepne_samoloty[i]; 																						  # Liczba samolotów na każdej trasie nie może przekroczyć dostępnej liczby samolotów dla danego typu.
o_pojemnosci{j in trasy}:sum{i in samoloty} (liczba_lotow[i,j] * pojemnosc_samolotow[i] * samoloty_na_trasie[i,j]) = liczba_pasazerow[j] - nadwyzka_pasazerow[j] + niedobor_pasazerow[j]; # Suma pojemności wszystkich samolotów na danej trasie musi być równa liczbie pasażerów, uwzględniając nadwyżkę lub niedobór pasażerów.

data;
param:samoloty: dostepne_samoloty, pojemnosc_samolotow :=
										        "S1" 5 50
										        "S2" 8 30
										        "S3" 10 20;
param: trasy: liczba_pasazerow, koszt_utraconych_pasazerow :=
										        "TR1" 1000 40
										        "TR2" 2000 50
										        "TR3" 900 45
										        "TR4" 1200 70;
param koszt_lotu: "TR1" "TR2" "TR3" "TR4" :=	"S1" 1000 1100 1200 1500
										        "S2" 800 900 1000 1000
										        "S3" 600 800 800 900;
param liczba_lotow:"TR1" "TR2" "TR3" "TR4" :=	"S1" 3 2 2 1
										        "S2" 4 3 3 2
										        "S3" 5 5 4 2;
solve;
display koszt, samoloty_na_trasie, niedobor_pasazerow, nadwyzka_pasazerow;
end;