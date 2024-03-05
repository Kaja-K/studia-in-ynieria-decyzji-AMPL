# Czyszczenie pamięci AMPL
reset;

# Parametry - oddzielne dane
param C_I := 0.28;
param C_II := 0.14;
param C_III := 0.10;

param Si_I := 0.10;
param Si_II := 0.12;
param Si_III := 0.06;

param Mn_I := 0.30;
param Mn_II := 0.20;
param Mn_III := 0.30;

param P_I := 0.10;
param P_II := 0.10;
param P_III := 0.15;

param Koszt_I := 200;
param Koszt_II := 150;
param Koszt_III := 400;

param Maks_C := 0.14;
param Maks_Si := 0.08;
param Min_Mn := 0.25;
param Min_P := 0.12;

param Ilosc_Mieszanki := 5000;

# Zmienna decyzyjna
var ilosc_mieszanek >= 0;

# Funkcja celu - minimalizacja kosztów
minimize Koszt_Razem:
  Koszt_I * ilosc_mieszanek * C_I +
  Koszt_II * ilosc_mieszanek * C_II +
  Koszt_III * ilosc_mieszanek * C_III;

# Ograniczenia zawartości pierwiastków w mieszance
subject to 
O_C: C_I * ilosc_mieszanek + C_II * ilosc_mieszanek + C_III * ilosc_mieszanek >= Maks_C * Ilosc_Mieszanki;
O_Si: Si_I * ilosc_mieszanek + Si_II * ilosc_mieszanek + Si_III * ilosc_mieszanek >= Maks_Si * Ilosc_Mieszanki;
O_Mn: Mn_I * ilosc_mieszanek + Mn_II * ilosc_mieszanek + Mn_III * ilosc_mieszanek <= Min_Mn * Ilosc_Mieszanki;
O_P: P_I * ilosc_mieszanek + P_II * ilosc_mieszanek + P_III * ilosc_mieszanek <= Min_P * Ilosc_Mieszanki;

# Rozwiązanie problemu optymalizacyjnego
solve;

# Wyświetlenie wyniku
display ilosc_mieszanek;

end;

# Wynik:  ilosc_mieszanek = 1428.57