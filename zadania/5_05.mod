option solver cplex;
reset;

# Parametry
set Osoby;
set Grupy;
param Przyjaźń {Osoby, Osoby} binary;  				# Macierz określająca, czy pary osób są zaprzyjaźnione (1) czy nie (0)
param PrzynależnośćDoGrupy {Osoby, Grupy} binary;   # Macierz określająca przynależność osób do poszczególnych grup

# Minimalizacja liczby grup
minimize LiczbaGrup: sum {g in Grupy} PrzynależnośćDoGrupy[g, g];

# Ograniczenia
o_BrakPrzyjaciółWGrupie {g in Grupy}: sum {p in Osoby: PrzynależnośćDoGrupy[p, g]} <= 1; 	# W każdej grupie może być maksymalnie jedna osoba mająca znajomych w tej grupie
o_maks_klika {j in Osoby}: sum {i in Osoby: Przyjaźń[i, j]} >= 1; 							# Każda osoba w grupie musi znać przynajmniej jedną inną osobę w tej grupie


data;
set Osoby := 1 2 3 4 5 6 7 8;
param Przyjaźń: 1 2 3 4 5 6 7 8 := 
				1 0 1 0 1 0 0 0
				2 1 0 1 0 0 0 0
				3 0 1 0 1 1 0 0
				4 1 0 1 0 0 0 0
				5 0 0 1 0 0 1 1
				6 0 0 0 0 1 0 0
				7 0 0 0 0 1 0 0
				8 0 0 0 0 1 0 0;

solve;
display o_maks_klika, PrzynależnośćDoGrupy,LiczbaGrup;

end;