option solver cplex;
reset;

# Parametry
param okres;             						# Liczba okresów
param oszacowany_popyt{1..okres}; 				# Oszacowany popyt w okresie t
param cena_sprzedazy{1..okres};   			 	# Cena sprzedaży w okresie t
param koszt_produkcji{1..okres};    			# Koszt produkcji w okresie t
param koszt_magazynowania{1..okres};			# Koszt magazynowania w okresie t
param koszt_niezaspokojonego_popytu{1..okres}; 	# Koszt sprzedanego popytu w okresie t
param minimalna_produkcja;      				# Dolne ograniczenie początkowej produkcji
param maksymalna_produkcja;      				# Górne ograniczenie początkowej produkcji
param maksymalna_zmiana_produkcji;       		# Maksymalna zmiana produkcji w kolejnych okresach (w procentach)

# Zmienne decyzyjne
# Produkcja w okresie t
var produkcja{1..okres} >= minimalna_produkcja, <= maksymalna_produkcja;
# Magazyn w okresie t
var magazyn{1..okres} >= 0;  
# Sprzedane w okresie t
var sprzedane{1..okres} >= 0;

# Funkcja celu -  Maksymalizacja zysku (dochod ze sprzedazy - koszty produkcji - koszty magazynowania - koszty sprzedanego popytu)
maximize zysk: sum{t in 1..okres} (cena_sprzedazy[t] * sprzedane[t] - koszt_produkcji[t] * produkcja[t] - koszt_magazynowania[t] * magazyn[t] - koszt_niezaspokojonego_popytu[t] * (oszacowany_popyt[t] - sprzedane[t]));

# Ograniczenia
# Gwarantuje, że ilość sprzedanych produktów w danym okresie nie przekroczy oszacowanego popytu. 
o_popytu{t in 1..okres}: sprzedane[t] <= oszacowany_popyt[t]; 	
# Określa stan początkowy magazynu jako różnicę między produkcją a sprzedażą w pierwszym okresie. 													
o_magazynu: magazyn[1] = produkcja[1] - sprzedane[1];     							
# Zapewnia równowagę magazynową, gdzie stan magazynu w każdym okresie jest równy stanowi magazynu w poprzednim okresie plus produkcji minus sprzedaży.									
o_rownowagi{t in 2..okres}: magazyn[t] = magazyn[t-1] + produkcja[t] - sprzedane[t]; 
# Ogranicza zmienność produkcji między okresami do wartości nie przekraczającej maksymalnej zmiany produkcji w procentach.
o_zmiany_produkcji1{t in 2..okres}: produkcja[t] - produkcja[t-1] <= produkcja[t-1] * maksymalna_zmiana_produkcji;	
# Ogranicza zmienność produkcji między okresami do wartości nie przekraczającej maksymalnej zmiany produkcji w procentach.  	
o_zmiany_produkcji2{t in 2..okres}: - maksymalna_zmiana_produkcji * produkcja[t-1] <= (produkcja[t] - produkcja[t-1]); 
																																																	
data;
param okres := 10;
param minimalna_produkcja := 180;
param maksymalna_produkcja := 250;
param maksymalna_zmiana_produkcji := 0.15;
param koszt_niezaspokojonego_popytu := 1 4 2 3 3 3 4 2 5 2 6 3 7 2 8 3 9 2 10 3;
param oszacowany_popyt := 1 200 2 180 3 300 4 230 5 300 6 800 7 1100 8 900 9 400 10 300;
param cena_sprzedazy := 1 120 2 130 3 135 4 140 5 180 6 200 7 210 8 230 9 230 10 240;
param koszt_produkcji := 1 50 2 60 3 55 4 60 5 40 6 50 7  60 8  65 9 60 10 70;
param koszt_magazynowania  := 1 5 2 4 3 6 4 5 5 4 6 3 7 5 8 4 9 5 10 3;

solve;
display zysk, produkcja, magazyn, sprzedane;
end;