option solver cplex;
reset;

# Parametry
set Z;								# Zbiór zadań
set Poprzedniki within Z cross Z;	# Zbiór poprzedników zadań
param czas_wykonania{Z};        	# Czas trwania każdego zadania
param minimalny_czas{Z};        	# Minimalny czas wykonania każdego zadania
param koszt_skrocenia{Z};       	# Koszt skrócenia każdego zadania
param maksymalny_czas;               # Maksymalny czas trwania projektu

# Zmienne decyzyjne
var termin_zakonczenia{Z} >= 0;    # Termin zakończenia każdego zadania
var zapas_czasu{Z} >= 0;           # Zapas czasu dla każdego zadania

# Funkcja celu - Minimalizacja całkowitego kosztu skrócenia projektu
minimize koszt_skrocenia_projektu: sum{i in Z} koszt_skrocenia[i] * zapas_czasu[i];

# Ograniczenia 
o_poprzednika{(i,j) in Poprzedniki}: termin_zakonczenia[j] >= termin_zakonczenia[i] + czas_wykonania[i] - zapas_czasu[i]; # Czas dla poprzedników
o_maksymalny_termin{i in Z}: termin_zakonczenia[i] + czas_wykonania[i] - zapas_czasu[i] <= maksymalny_czas; 			  # Maksymalny termin zakończenia projektu
o_minimalny_czas_wykonania{i in Z}: czas_wykonania[i] - zapas_czasu[i] >= minimalny_czas[i];							  # Minimalny czas trwania każdego zadania

data;
set Z := 'A' 'B' 'C' 'D' 'E' 'F' 'G';
set Poprzedniki := ('B', 'D') ('C', 'D') ('A', 'E') ('E', 'F') ('D', 'F') ('C', 'G');
param: Z: czas_wykonania, koszt_skrocenia, minimalny_czas :='A' 2 1 1 'B' 4 2 2 'C' 5 1 3 'D' 6 2 1 'E' 3 5 1 'F' 4 4 2 'G' 4 1 3;
param maksymalny_czas := 7;

solve;
display koszt_skrocenia_projektu, zapas_czasu, termin_zakonczenia;
# Wynik:koszt_skrocenia_projektu = 19
# 	zapas_czasu termin_zakonczenia 
# A       1              0
# B       1              0
# C       2              0
# D       5              3
# E       0              1
# F       1              4
# G       0              3

end;