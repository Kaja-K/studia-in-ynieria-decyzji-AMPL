option solver cplex;
reset;

# Deklaracja parametrów
set Benzyny; 							# Zbior benzyn
set podprodukty; 						# Zbior poproduktow
param oktany_podproduktow{podprodukty};	# Liczba oktanowa dla poszczególnych poproduktów
param cena_normalna; 					# Cena benzyny normalna
param cena_premium; 					# Cena benzyny premium
param cena_super; 						# Cena benzyny super
param popyt_normalna;					# Popyt na benzynę normalna
param popyt_premium;					# Popyt na benzynę premium
param popyt_super;						# Popyt na benzynę super
param liczba_oktanowa_normalna; 		# Liczba oktanowa benzyny normalna
param liczba_oktanowa_premium; 			# Liczba oktanowa benzyny premium
param liczba_oktanowa_super; 			# Liczba oktanowa benzyny super
param podaz_benzyny;					# Podaż benzyny
param limit_krakowania;					# Limit krakowania

# Zmienna decyzyjna - Ilość poproduktów j-tego w benzynie i-tej
var ilosc_podproduktow_normalna{podprodukty} >=0;
var ilosc_podproduktow_premium{podprodukty} >=0;
var ilosc_podproduktow_super{podprodukty} >=0;

# Funkcja celu - maksymalizacja całkowitego zysku
maximize zysk: cena_normalna * sum{j in podprodukty} ilosc_podproduktow_normalna[j] + 
                cena_premium * sum{j in podprodukty} ilosc_podproduktow_premium[j] + 
                cena_super * sum{j in podprodukty} ilosc_podproduktow_super[j];

# Ograniczenia

# Ograniczenie sprzedaży benzyny
o_sprzedaz_normalna: sum{j in podprodukty} ilosc_podproduktow_normalna[j] <= popyt_normalna;
o_sprzedaz_premium: sum{j in podprodukty} ilosc_podproduktow_premium[j] <= popyt_premium;
o_sprzedaz_super: sum{j in podprodukty} ilosc_podproduktow_super[j] <= popyt_super;

# Ograniczenie technologiczne
o_technologia_normalna: sum{j in podprodukty} oktany_podproduktow[j]*ilosc_podproduktow_normalna[j] >= 
                        liczba_oktanowa_normalna * sum{j in podprodukty} ilosc_podproduktow_normalna[j];
o_technologia_premium: sum{j in podprodukty} oktany_podproduktow[j]*ilosc_podproduktow_premium[j] >= 
                        liczba_oktanowa_premium * sum{j in podprodukty} ilosc_podproduktow_premium[j];
o_technologia_super: sum{j in podprodukty} oktany_podproduktow[j]*ilosc_podproduktow_super[j] >= 
                        liczba_oktanowa_super * sum{j in podprodukty} ilosc_podproduktow_super[j];

# Ograniczenie krakowania
o_krakowania: 2 * (sum{j in podprodukty} ilosc_podproduktow_normalna[j] + 
                   sum{j in podprodukty} ilosc_podproduktow_premium[j] + 
                   sum{j in podprodukty} ilosc_podproduktow_super[j]) <= limit_krakowania;

# Ograniczenie destylacji
o_destylacja: 5 * (sum{j in podprodukty} ilosc_podproduktow_normalna[j] + 
                   sum{j in podprodukty} ilosc_podproduktow_premium[j] + 
                   sum{j in podprodukty} ilosc_podproduktow_super[j]) <= podaz_benzyny;

data;
set podprodukty:= ON82 ON98;
param oktany_podproduktow:= ON82 82 ON98 98;
param cena_normalna := 6.7; 
param cena_premium := 7.2;
param cena_super := 8.1; 
param popyt_normalna := 50000;
param popyt_premium := 30000; 				
param popyt_super := 40000; 	
param liczba_oktanowa_normalna := 87; 	
param liczba_oktanowa_premium := 89; 	
param liczba_oktanowa_super := 92; 	
param podaz_benzyny := 1500000; 
param limit_krakowania := 200000; 	

solve;

display zysk, ilosc_podproduktow_normalna, ilosc_podproduktow_premium, ilosc_podproduktow_super;

end;
