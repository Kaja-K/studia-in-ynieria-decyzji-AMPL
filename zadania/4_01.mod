option solver cplex;
reset;

# Parametry
param dni > 0, integer; # Liczba dni w tygodniu
param wolne >= 0, integer; # Liczba dni wolnych w tygodniu
param zatrudnienie{1..dni}; # Wymagana liczba zatrudnionych pracowników w każdym dniu

# Zmienna decyzyjna - Liczba zatrudnionych w danym dniu
var zatrudnieni{1..dni} >= 0, integer;

# Funckcja celu - Minimalizacja sumy liczby zatrudnionych pracowników w danym dniu tygodnia.
minimize liczba_zatrudnionych: sum{d in 1..dni} zatrudnieni[d];

# Ograniczenie - Liczba zatrudnionych pracowników w każdym dniu tygodnia jest co najmniej równa wymaganej liczbie pracowników w danym dniu oraz w dniach, które są wymagane do obsługi wszystkich dni zatrudnienia z poprzednich dni wolnych.
o_zatrudnienia{d in 1..dni}: zatrudnienie[d] <= sum{w in (d + wolne + 1)..(d + dni)} if w > dni then zatrudnieni[w - dni] else zatrudnieni[w];

data;
param dni := 7;
param wolne := 2;
param zatrudnienie:=1 17 2 13 3 15 4 19 5 14 6 16 7 11;

solve;
display liczba_zatrudnionych, zatrudnieni;
end;