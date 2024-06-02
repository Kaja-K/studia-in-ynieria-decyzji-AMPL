option solver cplex;
reset;

# Parametry
set wyroby;									# Zbiór wyrobów
set komponenty;								# Zbiór komponentów
param liczba_jednostek{wyroby, komponenty};	# Liczba jednostek komponentu potrzebna do wyrobu
param cena_jednostkowa{wyroby};				# Cena jednostkowa wyrobu
param dostepnosc{komponenty};				# Dostępna liczba jednostek komponentu

# Zmienna decyzyjna - Liczba wyrobów, które zostaną wyprodukowane dla każdego wyrobu.
var liczba_wyrobow{wyroby} >= 0; 

# Funkcja celu - Maksymalizacja zysku poprzez sumowanie zysków z każdego wyrobu
maximize zysk: sum{w in wyroby} cena_jednostkowa[w] * liczba_wyrobow[w];

# Ograniczenie - Określa, że zapotrzebowanie na każdy komponent nie może przekroczyć dostępnej liczby tych komponentów. 
# Suma iloczynów liczby jednostek komponentów potrzebnych do wytworzenia każdego wyrobu i liczby wyrobów nie może przekraczać dostępności danego komponentu.
o_komponentow{k in komponenty}: sum{w in wyroby} liczba_jednostek[w,k] * liczba_wyrobow[w] <= dostepnosc[k];

data;
param: wyroby: cena_jednostkowa := "W1" 20 "W2" 30 "W3" 25;
param: komponenty: dostepnosc := "C1" 300 "C2" 150 "C3" 200;
param liczba_jednostek: "C1" "C2" "C3" := "W1" 2 1 0 "W2" 1 2 3 "W3" 3 1 1;

solve;
display zysk, liczba_wyrobow;
display liczba_wyrobow.down, liczba_wyrobow.up ogr_dostepnosc_komponentow, ogr_dostepnosc_komponentow.current, ogr_dostepnosc_komponentow.down, ogr_dostepnosc_komponentow.up, ogr_dostepnosc_komponentow.slack;
end;