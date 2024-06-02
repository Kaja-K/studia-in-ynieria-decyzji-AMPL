option solver cplex;
reset;

# Parametry
set telewizory;                       # Zbiór typów telewizorów, które mogą być produkowane.
param max_sprzedaz {telewizory};      # Maksymalna liczba telewizorów, które można sprzedać dla każdego typu telewizora.
param roboczogodziny {telewizory};    # Liczba roboczogodzin potrzebna do wyprodukowania jednego telewizora dla każdego typu.
param zysk {telewizory};              # Zysk z jednego telewizora dla każdego typu.
param dostepne_godziny;               # Całkowita dostępna liczba roboczogodzin w danym okresie.

# Zmienna decyzyjna - Każda zmienna decyzyjna określa, ile telewizorów danego typu ma zostać wyprodukowanych, przy czym nie może przekroczyć maksymalnej sprzedaży.
var produkcja {t in telewizory} >= 0, <= max_sprzedaz[t];  

# Funkcja celu - Całkowity zysk jest sumą zysków ze sprzedaży każdego typu telewizora, przy czym zysk z jednego telewizora jest mnożony przez liczbę wyprodukowanych telewizorów tego typu.
maximize zysk_calkowity: sum {t in telewizory} zysk[t] * produkcja[t];

# Ograniczenie - Dostępne godziny robocze, całkowita liczba godzin roboczych potrzebnych do wyprodukowania wszystkich telewizorów nie przekroczy dostępnych godzin.
o_godziny: sum {t in telewizory} roboczogodziny[t] * produkcja[t] <= dostepne_godziny;

data;
set telewizory := TV27 TV20;
param dostepne_godziny := 500;
param: max_sprzedaz roboczogodziny zysk := TV27 20 20 120 
										   TV20 40 10 80;
solve;
display zysk_calkowity, produkcja;
end;