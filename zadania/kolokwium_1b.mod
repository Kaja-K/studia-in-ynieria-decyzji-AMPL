option solver cplex;
reset;

# Parametry
param powierzchnia > 0, integer; # Wielkość powierzchni magazynu
param zasieg > 0, integer; # Zasięg czujnika
set pola := 1..powierzchnia cross 1..powierzchnia; # Zbiór pól
set paczki within 1..powierzchnia cross 1..powierzchnia; # Zbiór paczek

# Zmienna decyzyjna - Obecność czujnika na danym polu
var czujnik{1..powierzchnia, 1..powierzchnia} >= 0, binary;

# Funkcja celu - Minimalizacja liczby czujników poprzez zsumowanie wartości kwadratów magazynu
minimize liczba_czujnikow: sum{wiersz in 1..powierzchnia, kolumna in 1..powierzchnia} czujnik[wiersz,kolumna];

# Ograniczenie
# Każda paczka musi być obserwowana przez co najmniej jeden czujnik
# Czujnik obserwuje paczki tylko na górze i na prawo
o_obserwowania {(wiersz, kolumna) in paczki}:
    sum{(k, kolumna) in pola: k >= wiersz+1 and k <= wiersz + zasieg} (if k >= 1 and k <= powierzchnia then czujnik[k,kolumna]) +
    sum{(wiersz, k) in pola: k >= kolumna - zasieg and k <= kolumna - 1} (if k >= 1 and k <= powierzchnia then czujnik[wiersz,k]) >= 1;
    
data;
param powierzchnia := 9;
param zasieg := 3;
set paczki := 3 4 3 5 3 6 4 3 4 7 5 3 5 7 6 3 6 7 7 4 7 5 7 6 7 3;

solve;
# Wyświetlenie miejsc paczek 
for {wiersz in 1..powierzchnia} {for {kolumna in 1..powierzchnia} {printf "%s",  if (wiersz,kolumna) in paczki then " P " else " . ";}printf "\n";}
# Wyświetlenie miejsc czujników
for {wiersz in 1..powierzchnia} {for {kolumna in 1..powierzchnia} {printf "%s", if czujnik[wiersz,kolumna] == 1 then " c " else " . ";}printf "\n";}
# Wyświetlenie miejsc paczek i czujników
for {wiersz in 1..powierzchnia} {for {kolumna in 1..powierzchnia} {printf "%s", if czujnik[wiersz,kolumna] == 1 then " c " else if (wiersz,kolumna) in paczki then " P " else " . ";}printf "\n";}
display liczba_czujnikow;
end;