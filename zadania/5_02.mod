option solver cplex;
reset;

# Parametry
set Wierzcholki;                                    # Zbiór wierzchołków w grafie
set Krawedzie within Wierzcholki cross Wierzcholki; # Zbiór krawędzi w grafie
param odleglosc{Krawedzie};                         # odleglosc każdej krawędzi
param RóżnicaStrumieni{Wierzcholki};                # Parametr różnica strumieni dla każdego wierzchołka

# Zmienna decyzyjna - czy dana krawędź jest wykorzystywana w ścieżce
var uzyta{(i,j) in Krawedzie} binary;

# Funkcja celu - Minimalizacja całkowitej odległości
minimize calkowita_odleglosc: sum{(i,j) in Krawedzie} odleglosc[i,j] * uzyta[i,j];

# Ograniczenie - Różnica strumieni dla każdego wierzchołka
o_strumieni{i in Wierzcholki}: sum{(i,j) in Krawedzie} uzyta[i,j] - sum{(j,i) in Krawedzie} uzyta[j,i] = RóżnicaStrumieni[i];

data;
set Wierzcholki := A B C D E;
param RóżnicaStrumieni:= A 1 B 0 C 0 D 0 E -1;
param: Krawedzie: odleglosc :=  A B 6 A C 9 B C 1 B D 4 C D 1 C E 5 D C 4 D E 2;
 
solve;
display calkowita_odleglosc, uzyta;
# Wynik: calkowita_odleglosc = 10
# uzyta 
# A B   1
# B C   1
# C D   1
# D E   1

end;
