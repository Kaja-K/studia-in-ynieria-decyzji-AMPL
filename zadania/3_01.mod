option solver cplex;
reset;

# Parametry
set Wyroby;  								# Zbiór wyrobów
set Komponenty;  							# Zbiór komponentów
param liczba_jednostek{Wyroby, Komponenty}; # Liczba jednostek komponentu potrzebna do wyrobu
param cena_jednostkowa{Wyroby}; 			# Cena jednostkowa wyrobu
param dostepnosc{Komponenty}; 				# Dostępna liczba jednostek komponentu

# Zmienna decyzyjna
var liczba_wyrobow{Wyroby} >= 0; 

# Funkcja celu - Maksymalizacja zysku poprzez sumowanie zysków z każdego wyrobu
maximize zysk: sum{w in Wyroby} cena_jednostkowa[w] * liczba_wyrobow[w];

# Ograniczenie - Zapotrzebowanie na komponenty nie może przekroczyć dostępnej liczby
o_dostepnosc_komponentow{k in Komponenty}: sum{w in Wyroby} liczba_jednostek[w,k] * liczba_wyrobow[w] <= dostepnosc[k];

data;
param: Wyroby: cena_jednostkowa := "W1" 20 "W2" 30 "W3" 25;
param: Komponenty: dostepnosc := "C1" 300 "C2" 150 "C3" 200;
param liczba_jednostek: "C1" "C2" "C3" := "W1" 2 1 0 "W2" 1 2 3 "W3" 3 1 1;

solve;
display zysk, liczba_wyrobow;
display liczba_wyrobow.down, liczba_wyrobow.up ogr_dostepnosc_komponentow, ogr_dostepnosc_komponentow.current, ogr_dostepnosc_komponentow.down, ogr_dostepnosc_komponentow.up, ogr_dostepnosc_komponentow.slack;
# Wynik: zysk = 3150
# liczba_wyrobow 
# W1   0
# W2  30
# W3  90

end;