option solver cplex;
reset;

# Parametry
param okresy; # Liczba okresów
param oszacowany_popyt{1..okresy}; # Oszacowany popyt w okresie o
param cena_sprzedazy{1..okresy}; # Cena sprzedaży w okresie o
param koszt_produkcji{1..okresy}; # Koszt produkcji w okresie o
param koszt_magazynowania{1..okresy}; # Koszt magazynowania w okresie o
param koszt_niezaspokojonego_popytu{1..okresy}; # Koszt sprzedanego popytu w okresie o
param minimalna_produkcja; # Dolne ograniczenie początkowej produkcji
param maksymalna_produkcja; # Górne ograniczenie początkowej produkcji
param maksymalna_zmiana_produkcji; # Maksymalna zmiana produkcji w kolejnych okresach (w procentach)

# Zmienne decyzyjne
# Produkcja w okresie o
var produkcja{1..okresy} >= minimalna_produkcja, <= maksymalna_produkcja;
# Magazyn w okresie o
var magazyn{1..okresy} >= 0;  
# Sprzedane w okresie o
var sprzedane{1..okresy} >= 0;

# Funkcja celu -  Maksymalizacja zysku (dochod ze sprzedazy - koszty produkcji - koszty magazynowania - koszty sprzedanego popytu)
maximize zysk: sum{o in 1..okresy} (cena_sprzedazy[o] * sprzedane[o] - koszt_produkcji[o] * produkcja[o] - koszt_magazynowania[o] * magazyn[o] - koszt_niezaspokojonego_popytu[o] * (oszacowany_popyt[o] - sprzedane[o]));

# Ograniczenia
# Gwarantuje, że ilość sprzedanych produktów w danym okresie nie przekroczy oszacowanego popytu. 
o_popytu{o in 1..okresy}: sprzedane[o] <= oszacowany_popyt[o]; 	
# Określa stan początkowy magazynu jako różnicę między produkcją a sprzedażą w pierwszym okresie. 													
o_magazynu: magazyn[1] = produkcja[1] - sprzedane[1];     							
# Zapewnia równowagę magazynową, gdzie stan magazynu w każdym okresie jest równy stanowi magazynu w poprzednim okresie plus produkcji minus sprzedaży.									
o_rownowagi{o in 2..okresy}: magazyn[o] = magazyn[o-1] + produkcja[o] - sprzedane[o]; 
# Ogranicza zmienność produkcji między okresami do wartości nie przekraczającej maksymalnej zmiany produkcji w procentach.
o_zmiany_produkcji1{o in 2..okresy}: produkcja[o] - produkcja[o-1] <= produkcja[o-1] * maksymalna_zmiana_produkcji;	
# Ogranicza zmienność produkcji między okresami do wartości nie przekraczającej maksymalnej zmiany produkcji w procentach.  	
o_zmiany_produkcji2{o in 2..okresy}: - maksymalna_zmiana_produkcji * produkcja[o-1] <= (produkcja[o] - produkcja[o-1]); 
																																																	
data;
param okresy := 10;
param minimalna_produkcja := 180;
param maksymalna_produkcja := 250;
param maksymalna_zmiana_produkcji := 0.15;
param koszt_niezaspokojonego_popytu := 1 4 2 3 3 3 4 2 5 2 6 3 7 2 8 3 9 2 10 3;
param oszacowany_popyt := 1 200 2 180 3 300 4 230 5 300 6 800 7 1100 8 900 9 400 10 300;
param cena_sprzedazy := 1 120 2 130 3 135 4 140 5 180 6 200 7 210 8 230 9 230 10 240;
param koszt_produkcji := 1 50 2 60 3 55 4 60 5 40 6 50 7 60 8 65 9 60 10 70;
param koszt_magazynowania  := 1 5 2 4 3 6 4 5 5 4 6 3 7 5 8 4 9 5 10 3;

solve;
display zysk, produkcja, magazyn, sprzedane;
end;