option solver cplex;
reset;

# Parametry
param powierzchnia > 0, integer; # Wielkość powierzchni magazynu
param zasieg > 0, integer; # Zasięg czujnika
set pola := 1..powierzchnia cross 1..powierzchnia; # Zbiór pól
set paczki within 1..powierzchnia cross 1..powierzchnia; # Zbiór paczek

# Zmienna decyzyjna - Obecność czujnika na danym polu
var czujnik{1..powierzchnia, 1..powierzchnia} >= 0, binary;

# Funkcja celu - Minimalizacja liczby czujników
minimize liczba_czujnikow: sum{wiersz in 1..powierzchnia, kolumna in 1..powierzchnia} czujnik[wiersz,kolumna];

# Ograniczenia
# Czujnik nie może nachodzić na pole z paczką
o_nachodzenia {(wiersz,kolumna) in paczki}: czujnik[wiersz,kolumna] = 0;

# Każda paczka musi być obserwowana przez co najmniej jeden czujnik
# Dla każdej paczki (wiersz, kolumna) w zbiorze paczek, suma obserwacji poziomych i pionowych wokół tej paczki musi wynosić co najmniej 1.
# Suma ta jest obliczana jako suma czujników w obszarze poziomym i pionowym wokół paczki, gdzie obszar ten jest określony przez zasięg czujnika.
o_obserwowania {(wiersz,kolumna) in paczki}: 
    sum{(k,kolumna) in pola: k >= wiersz - zasieg and k <= wiersz + zasieg} (if k >= 1 and k <= powierzchnia then czujnik[k,kolumna]) +
    sum{(wiersz,k) in pola: k >= kolumna - zasieg and k <= kolumna + zasieg} (if k >= 1 and k <= powierzchnia then czujnik[wiersz,k]) >= 1;

data;
param powierzchnia := 10;
param zasieg := 4;
set paczki := 2 4 1 6 4 7 2 7 1 3 4 4 2 9 8 3 9 5 5 1 8 10 7 7;

solve;
#for {wiersz in 1..powierzchnia} {for {kolumna in 1..powierzchnia} {printf "%s", if czujnik[wiersz,kolumna] == 1 then " c " else if (wiersz,kolumna) in paczki then " P " else " . ";}printf "\n";}
display  liczba_czujnikow, czujnik;
end;