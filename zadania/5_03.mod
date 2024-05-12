option solver cplex;
reset;

# Parametry
set Zadania;									# Zbiór zadań
set Poprzedniki within Zadania cross Zadania;	# Zbiór poprzedników zadań
param CzasWykonania{Zadania};        			# Czas trwania każdego zadania
param MinimalnyCzas{Zadania};        			# Minimalny czas wykonania każdego zadania
param KosztSkrócenia{Zadania};       			# Koszt skrócenia każdego zadania
param MaksymalnyCzas;                			# Maksymalny czas trwania projektu

# Zmienne decyzyjne
var TerminZakonczenia{Zadania} >= 0;    # Termin zakończenia każdego zadania
var ZapasCzasu{Zadania} >= 0;           # Zapas czasu dla każdego zadania

# Funkcja celu - Minimalizacja całkowitego kosztu skrócenia projektu
minimize KosztSkróceniaProjektu: sum{i in Zadania} KosztSkrócenia[i] * ZapasCzasu[i];

# Ograniczenia 
o_Poprzednika{(i,j) in Poprzedniki}: TerminZakonczenia[j] >= TerminZakonczenia[i] + CzasWykonania[i] - ZapasCzasu[i];  	# Ograniczenie czasowe dla poprzedników
o_MaksymalnyTermin{i in Zadania}: TerminZakonczenia[i] + CzasWykonania[i] - ZapasCzasu[i] <= MaksymalnyCzas; 			# Maksymalny termin zakończenia projektu
o_MinimalnyCzasWykonania{i in Zadania}: CzasWykonania[i] - ZapasCzasu[i] >= MinimalnyCzas[i];							# Minimalny czas trwania każdego zadania

# Dane
data;
set Zadania := 'A' 'B' 'C' 'D' 'E' 'F' 'G';
set Poprzedniki := ('B', 'D') ('C', 'D') ('E', 'A') ('E', 'F') ('D', 'F') ('C', 'G');
param: Zadania: CzasWykonania, KosztSkrócenia, MinimalnyCzas :='A' 2 1 1 'B' 4 2 2 'C' 5 1 3 'D' 6 2 1 'E' 3 5 1 'F' 4 4 2 'G' 4 1 3;
param MaksymalnyCzas := 7;

solve;
display KosztSkróceniaProjektu, ZapasCzasu;
# Wynik:KosztSkróceniaProjektu = 18
# ZapasCzasu 
# A  0
# B  1
# C  2
# D  5
# E  0
# F  1
# G  0

end;