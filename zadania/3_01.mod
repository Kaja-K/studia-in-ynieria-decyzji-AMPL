option solver cplex;
reset;

# Parametry
set Wyroby;  								# Zbiór wyrobów W = {W1, W2, W3}
set Komponenty;  							# Zbiór komponentów C = {C1, C2, C3}
param liczba_jednostek{Wyroby, Komponenty}; # Liczba jednostek komponentu potrzebna do wyrobu
param cena_jednostkowa{Wyroby}; 			# Cena jednostkowa wyrobu
param dostepnosc{Komponenty}; 				# Dostępna liczba jednostek komponentu

# Zmienna decyzyjna
var liczba_wyrobow{Wyroby} >= 0; 

# Funkcja celu: maksymalizacja zysku poprzez sumowanie zysków z każdego wyrobu
maximize zysk: sum{w in Wyroby} cena_jednostkowa[w] * liczba_wyrobow[w];

# Ograniczenia: zapotrzebowanie na komponenty nie może przekroczyć dostępnej liczby
DostepnoscKomponentow{c in Komponenty}: sum{w in Wyroby} liczba_jednostek[w,c] * liczba_wyrobow[w] <= dostepnosc[c];

# Dane 
data;
param: Wyroby: cena_jednostkowa := "W1" 20 "W2" 30 "W3" 25;
param: Komponenty: dostepnosc := "C1" 300 "C2" 150 "C3" 200;
param liczba_jednostek: "C1" "C2" "C3" := "W1" 2 1 0 "W2" 1 2 3 "W3" 3 1 1;

solve;

# Wyświetlanie wyników
display liczba_wyrobow, liczba_wyrobow.down, liczba_wyrobow.up;
display DostepnoscKomponentow, DostepnoscKomponentow.current, DostepnoscKomponentow.down, DostepnoscKomponentow.up, DostepnoscKomponentow.slack;
# Wynik: 
#		liczba_wyrobow liczba_wyrobow.down liczba_wyrobow.up 
# W1         0           -1e+20                 21
# W2        30               25                 50
# W3        90               23.3333            90
# $2 = DostepnoscKomponentow.current
# $3 = DostepnoscKomponentow.down
# $5 = DostepnoscKomponentow.slack
#		DostepnoscKomponentow   $2    $3  DostepnoscKomponentow.up   $5 
# C1            4            300   200            450              0
# C2           13            150   100            162.5            0
# C3            0            200   180          1e+20             20

end;
