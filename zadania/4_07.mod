option solver cplex;
reset;

# Parametry
set przedmioty; # Zbiór przedmiotów
set godziny; # Zbiór godzin
set dni; # Zbiór dni
set grupy within przedmioty cross dni cross godziny cross 1..10; # Zbiór grup, każda związana z przedmiotem, dniem, godziną i numerem
param maksymalna_godzin; # Maksymalna liczba godzin

# Zmienna decyzyjna - Binarna zmienna określająca, czy dana grupa jest wybrana
var wybrane{grupy} binary;

# Funkcja celu - Maksymalizacja atrakcyjności planu poprzez zwiększenie liczby wybranych grup zajęciowych.
maximize atrakcyjnosc_planu: sum{(p,d,g,a) in grupy} wybrane[p,d,g,a]*1;

# Ograniczenia
# Każdy przedmiot musi być zapisany raz.
o_czy_zapisany {p in przedmioty}: sum{(p,d,g,a) in grupy} wybrane[p,d,g,a] = 1;
# Nie więcej niż maksymalna liczba godzin dziennie dla każdego dnia.
o_czy_nie_za_duzo_godzin {d in dni}: sum{(p,d,g,a) in grupy} wybrane[p,d,g,a] <= maksymalna_godzin;	

data;
set przedmioty := "Matematyka" "Fizyka" "Ekonomia" "Angielski" "Badania_operacyjne" "Logika";
set godziny := "7-9" "9-11" "11-13" "13-15" "15-17";
set dni := "PN" "WT" "SR" "CZ" "PT";
param maksymalna_godzin := 6;
set grupy :="Matematyka" "PN" "7-9" 1, "Matematyka" "PN" "11-13" 2,"Matematyka" "WT" "13-15" 7,"Fizyka" "SR" "11-13" 3, "Angielski" "PN" "7-9" 1,"Angielski" "SR" "9-11" 2,"Fizyka" "SR" "15-17" 8, "Ekonomia" "WT" "9-11" 2, 
"Logika" "PT" "7-9" 1, "Logika" "CZ" "15-17" 1, "Badania_operacyjne" "SR" "11-13" 4,"Badania_operacyjne" "CZ" "9-11" 5, "Badania_operacyjne" "CZ" "11-13" 6, "Ekonomia" "PT" "15-17" 8, "Ekonomia" "PN" "9-11" 2, "Logika" "SR" "15-17" 10,
"Angielski" "SR" "15-17" 10, "Fizyka" "PT" "13-15" 8, "Fizyka" "CZ" "9-11" 1, "Matematyka" "SR" "7-9" 2, "Ekonomia" "CZ" "15-17" 6, "Badania_operacyjne" "PT" "11-13" 5, "Fizyka" "WT" "9-11" 10, "Logika" "SR" "15-17" 3;	

solve;
display  atrakcyjnosc_planu,wybrane;
end;