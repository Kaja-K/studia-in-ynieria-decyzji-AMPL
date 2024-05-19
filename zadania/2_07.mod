option solver cplex; 
reset;   

# Parametry
set zdarzenia;                      		# Zbiór możliwych zdarzeń
param n;             						# Liczba dostępnych projektów
param wartosci_projektow{zdarzenia, 1..n};  # Wartości projektów w różnych zdarzeniach
param dostepny_kapital;             		# Dostępny kapitał przeznaczony na inwestycje

# Zmienne decyzyjne
var kwota_inwestycji_projektu{1..n} >= 0;   # Kwota inwestycji w poszczególne projekty
var oczekiwany_zysk;        				# Całkowity oczekiwany zysk

# Funkcja celu - Maksymalizacja całkowitego oczekiwanego zysku
maximize calkowity_zysk: oczekiwany_zysk;  

# Ograniczenia
o_zysk_zdarzenia{i in zdarzenia}: oczekiwany_zysk <= sum{j in 1..n} wartosci_projektow[i,j] * kwota_inwestycji_projektu[j];  # Oczekiwany zysk
o_dostepny_kapital: sum{j in 1..n} kwota_inwestycji_projektu[j]  = dostepny_kapital;                            			 # Dostępna kwota kapitału

data;
set zdarzenia := "Zdarzenie 1", "Zdarzenie 2", "Zdarzenie 3";
param n := 4; 
param dostepny_kapital := 500000; 
param wartosci_projektow: 1 2 3 4 := 
    	   "Zdarzenie 1" -3 4 -7 15 
    	   "Zdarzenie 2" 5 -3 9 4 
     	   "Zdarzenie 3" 3 2 10 -8;
     	   
solve;
display oczekiwany_zysk, kwota_inwestycji_projektu;  
# Wynik: oczekiwany_zysk = 1297300
# kwota_inwestycji_projektu
# 1       0
# 2  222359
# 3  170762
# 4  106880

end;