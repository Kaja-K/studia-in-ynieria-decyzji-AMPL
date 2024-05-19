option solver cplex;
reset;

# Parametry
set Telewizory;						   # Zestaw telewizorów
param max_sprzedaz {Telewizory};       # Maksymalna sprzedaż każdego rodzaju telewizora
param roboczogodziny {Telewizory};     # Liczba roboczogodzin potrzebna do wyprodukowania jednego telewizora
param zysk {Telewizory};               # Zysk z jednego telewizora
param dostepne_godziny;                # Dostępna liczba roboczogodzin w miesiącu

# Zmienna decyzyjna -  Liczba wyprodukowanych telewizorów każdego rodzaju
var produkcja {t in Telewizory} >= 0, <= max_sprzedaz[t];  

# Funkcja celu - zmaksymalizowanie zysku
maximize zysk_całkowity: sum {t in Telewizory} zysk[t] * produkcja[t];

# Ograniczenie - Dostępne godziny robocze
o_godziny: sum {t in Telewizory} roboczogodziny[t] * produkcja[t] <= dostepne_godziny;

data;
set Telewizory := TV27 TV20;
param: max_sprzedaz roboczogodziny zysk :=TV27 20 20 120 TV20 40 10 80;
param dostepne_godziny := 500;

solve;
display zysk_całkowity, produkcja;
# Wynik:zysk_całkowity = 3800
# produkcja
# TV20  40
# TV27   5

end;