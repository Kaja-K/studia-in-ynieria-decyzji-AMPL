option solver cplex;
reset;

# Parametry:
set Zboze; # Zbiór zbóż
param ceny{Zboze}; # Ceny za tonę zbóż
param ilosc_sprzedanych{Zboze} >= 0; # Ilość sprzedanego zbóż
param ilosc_zbiorow{Zboze} >= 0; # Ilość ton zbóż z jednego hektara
param czas_pracy{Zboze} >= 0; # Czas pracy potrzebny do obsiania jednego hektara
param dostepny_czas_pracy >= 0; # Dostępny czas pracy

# Zmienne decyzyjne - Ilość obsianych hektarów dla każdego zboża
var ilosc_hektarow{Zboze} >= 0;

# Funkcja celu - maksymalizacja całkowitego zysku
maximize zysk: sum{z in Zboze} ceny[z] * (ilosc_hektarow[z] * ilosc_zbiorow[z]);

# Ograniczenia:
o_pracy: sum{z in Zboze} czas_pracy[z] * ilosc_hektarow[z] <= dostepny_czas_pracy; # Ograniczenie czasu pracy
o_sprzedazy{z in Zboze}: ilosc_hektarow[z] * ilosc_zbiorow[z] <= ilosc_sprzedanych[z]; # Ograniczenie ilości sprzedanego zbóż

# Dane:
data;

set Zboze := zyto pszenica kukurydza;
param ceny := zyto 300 pszenica 500 kukurydza 400;
param ilosc_sprzedanych := zyto 560 pszenica 480 kukurydza 500;
param ilosc_zbiorow := zyto 10 pszenica 8 kukurydza 5;
param czas_pracy := zyto 12 pszenica 20 kukurydza 7;
param dostepny_czas_pracy := 1400;

solve;

display zysk, ilosc_hektarow;

end;

