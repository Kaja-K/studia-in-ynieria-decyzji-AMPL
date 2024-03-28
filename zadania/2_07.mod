option solver cplex; 
reset;   

# Deklaracja parametrów:
param liczba_projektow;             						# Liczba dostępnych projektów
set zdarzenia;                      						# Zbiór możliwych zdarzeń
param wartosci_projektow{zdarzenia, 1..liczba_projektow};  	# Wartości projektów w różnych zdarzeniach
param dostepny_kapital;             						# Dostępny kapitał przeznaczony na inwestycje

# Zmienne decyzyjne:
var inwestycja_projektu{1..liczba_projektow} >= 0;   # Kwota inwestycji w poszczególne projekty
var calkowity_zysk;        							 # Całkowity oczekiwany zysk

# Funkcja celu - maksymalizacja całkowitego oczekiwanego zysku
maximize oczekiwany_zysk: calkowity_zysk;  

# Ograniczenia:
subject to
o_zdarzen{i in zdarzenia}: calkowity_zysk <= sum{j in 1..liczba_projektow} wartosci_projektow[i,j] * inwestycja_projektu[j];  # Ograniczenie związane z oczekiwanym zyskiem
o_kapitalu: sum{j in 1..liczba_projektow} inwestycja_projektu[j]  = dostepny_kapital;                            # Ograniczenie dotyczące dostępnej kwoty kapitału

# Dane:
data;
param liczba_projektow := 4;  # Liczba dostępnych projektów
set zdarzenia := "Zdarzenie 1", "Zdarzenie 2", "Zdarzenie 3";  # Lista zdarzeń
param wartosci_projektow: 1 2 3 4 := "Zdarzenie 1" -3 4 -7 15 "Zdarzenie 2"  5 -3 9 4 "Zdarzenie 3"  3 2 10 -8;
param dostepny_kapital := 500000;  # Dostępny kapitał

solve;

display inwestycja_projektu, calkowity_zysk;  
# Wynik: inwestycja_projektu [*] :=
# 	1       0
# 	2  222359
# 	3  170762
# 	4  106880
# calkowity_zysk = 1297300
end; 
