option solver cplex;
reset;

# Parametry
set przedmioty;
set godziny;
set dni;
set grupy within przedmioty cross dni cross godziny cross 1..10;
param maksymalna_liczba_godzin;

# Zmienna decyzyjna 
var wybrane{grupy} binary;

# Funkcja celu
maximize atrakcyjnosc_planu: sum{(i,j,k,l)in grupy} wybrane [i,j,k,l]*1;

# Ograniczenia
o_czy_zapisany {i in przedmioty}: sum{(i,j,k,l)in grupy} wybrane[i,j,k,l] = 1;
o_czy_nie_za_duzo_godzin {j in dni}:sum{(i,j,k,l) in grupy} wybrane[i,j,k,l] <= maksymalna_liczba_godzin;

# Dane
data;
set przedmioty:= "Matematyka" "Fizyka" "Ekonomia" "Angielski" "Badania operacyjne" "Logika" ;
set godziny:="7-9" "9-11" "11-13" "13-15" "15-17";
set dni:="PN" "WT" "SR" "CZ" "PT";
set grupy:= "Matematyka" "PN"  "7-9" 1,
			"Matematyka" "PN"	"11-13" 2,
			"Matematyka" "WT"	"13-15" 7,
			"Fizyka"  "SR"	"11-13" 3,
			"Angielski" "PN" "7-9" 1,
			"Angielski" "SR" "9-11" 2,
			"Fizyka" "SR" "15-17" 8,
			"Ekonomia" "WT" "9-11" 2,
			"Logika" "PT" "7-9" 1,
			"Logika" "CZ" "15-17" 1,
			"Badania operacyjne" "SR" "11-13" 4,
			"Badania operacyjne" "CZ" "9-11" 5,
			"Badania operacyjne" "CZ" "11-13" 6,
			"Ekonomia" "PT" "15-17" 8,
			"Ekonomia" "PN" "9-11" 2,
			"Logika" "SR" "15-17" 10,
			"Angielski" "SR" "15-17" 10
			"Fizyka" "PT" "13-15" 8,
			"Fizyka" "CZ" "9-11" 1,
			"Matematyka" "SR" "7-9" 2,
			"Ekonomia" "CZ" "15-17" 6,
			"Badania operacyjne" "PT" "11-13" 5,
			"Fizyka" "WT" "9-11" 10,
			"Logika" "SR" "15-17" 3;
param maksymalna_liczba_godzin = 6;

solve;
display wybrane, atrakcyjnosc_planu;
# Wynik: atrakcyjnosc_planu = 6

end;
