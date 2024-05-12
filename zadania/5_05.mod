option solver cplex;
reset;

# Parametry
set Osoby;											# Zbiór osób 
set Grupy;											# Zbiór grup
param Przyjaźń {Osoby, Osoby} binary;  				# Macierz określająca, czy pary osób są zaprzyjaźnione (1) czy nie (0)
param PrzynależnośćDoGrupy {Osoby, Grupy} binary;   # Macierz określająca przynależność osób do poszczególnych grup

# Funkcja celu - Minimalizacja liczby grup
minimize LiczbaGrup: sum {g in Grupy} PrzynależnośćDoGrupy[g, g];

# Ograniczenia
o_BrakPrzyjaciółWGrupie {g in Grupy}: sum {p in Osoby: PrzynależnośćDoGrupy[p, g]} <= 1; # W każdej grupie może być maksymalnie jedna osoba mająca znajomych w tej grupie
o_maks_klika {j in Osoby}: sum {i in Osoby: Przyjaźń[i, j]} >= 1; 						 # Każda osoba w grupie musi znać przynajmniej jedną inną osobę w tej grupie

# Dane 
data;

solve;
display o_maks_klika, PrzynależnośćDoGrupy,LiczbaGrup;

end;