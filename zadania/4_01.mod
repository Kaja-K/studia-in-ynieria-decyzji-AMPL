option solver cplex;
reset;

# Parametry
param dzien > 0, integer;     # Liczba dni w tygodniu
param wolne >= 0, integer;    # Liczba dni wolnych w tygodniu
param zatrudnienie{1..dzien}; # Wymagana liczba zatrudnionych pracowników w każdym dniu

# Zmienna decyzyjna - Liczba zatrudnionych w danym dniu
var zatrudnieni{1..dzien} >= 0, integer;

# Funckcja celu - Minimalizacja sumy liczby zatrudnionych pracowników w danym dniu tygodnia.
minimize liczba_zatrudnionych: sum{i in 1..dzien} zatrudnieni[i];

# Ograniczenie - Liczba zatrudnionych pracowników w każdym dniu tygodnia jest co najmniej równa wymaganej liczbie pracowników w danym dniu oraz w dniach, które są wymagane do obsługi wszystkich dni zatrudnienia z poprzednich dni wolnych.
o_zatrudnienia{i in 1..dzien}: zatrudnienie[i] <= sum{j in (i + wolne + 1)..(i + dzien)} if j > dzien then zatrudnieni[j - dzien] else zatrudnieni[j];

data;
param dzien := 7;
param wolne := 2;
param zatrudnienie:=[1] 17 [2] 13 [3] 15 [4] 19 [5] 14 [6] 16 [7] 11;

solve;
display liczba_zatrudnionych, zatrudnieni;
end;