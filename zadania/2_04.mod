option solver cplex;
reset;

# Parametry
param miesiace > 0, integer;	 # Liczba miesięcy
param popyt{1..miesiace}; # Popyt na kukurydzę w każdym miesiącu
param gotowka_poczatkowa; # Początkowa ilość gotówki
param kukurydza_poczatkowa; # Początkowa ilość kukurydzy w magazynie
param cena_kupna{1..miesiace}; # Cena kupna kukurydzy w każdym miesiącu
param koszt_kupna{1..miesiace}; # Koszt zakupu kukurydzy w każdym miesiącu
param pojemnosc_magazynu; # Pojemność magazynu

# Zmienne decyzyjne
# Ilość gotówki na koniec każdego miesiąca
var gotowka{1..miesiace} >= 0;      
# Ilość kupionej kukurydzy w każdym miesiącu 			
var kupiona_kukurydza{1..miesiace} >= 0;
# Ilość sprzedanej kukurydzy w każdym miesiącu   		
var sprzedana_kukurydza{1..miesiace} >= 0; 		
# Ilość kukurydzy w magazynie na koniec każdego miesiąca
var ilosc_kukurydzy_magazyn{1..miesiace} >= 0; 	

# Funkcja celu - Maksymalizacja gotówki na koniec miesiaca 
maximize zysk: gotowka[miesiace];

# Ograniczenia 
# Określa stan konta na początku jako różnicę między początkową ilością gotówki a kosztem zakupionej kukurydzy oraz przychodem ze sprzedanej kukurydzy.
o_gotowka_poczatkowa: gotowka[1] = gotowka_poczatkowa - kupiona_kukurydza[1]*koszt_kupna[1] + sprzedana_kukurydza[1]*cena_kupna[1];  	
# Zapewnia, że stan konta w każdym kolejnym miesiącu jest równy stanowi konta w poprzednim miesiącu pomniejszonemu o koszty zakupionej kukurydzy i zwiększonemu o przychód ze sprzedanej kukurydzy.		
o_gotowka{m in 2..miesiace}: gotowka[m] = gotowka[m-1] - kupiona_kukurydza[m]*koszt_kupna[m] + sprzedana_kukurydza[m]*cena_kupna[m]; 
# Ustala stan magazynu na początku jako różnicę między początkową ilością kukurydzy a ilością sprzedanej i zakupionej kukurydzy.			
o_kukurydza_poczatkowa: ilosc_kukurydzy_magazyn[1] = kukurydza_poczatkowa + kupiona_kukurydza[1] - sprzedana_kukurydza[1];
# Zapewnia, że stan magazynu w każdym miesiącu jest równy stanowi magazynu w poprzednim miesiącu, zwiększonemu o zakupioną kukurydzę i zmniejszonemu o sprzedaną kukurydzę.
o_kukurydza_magazyn{m in 2..miesiace}: ilosc_kukurydzy_magazyn[m] = ilosc_kukurydzy_magazyn[m-1] + kupiona_kukurydza[m] - sprzedana_kukurydza[m];
# Ogranicza ilość kukurydzy w magazynie na początku do pojemności magazynu.
o_pojemnosc_magazynu: kukurydza_poczatkowa + kupiona_kukurydza[1] - sprzedana_kukurydza[1] <= pojemnosc_magazynu;
# Zapewnia, że ilość kukurydzy w magazynie w każdym miesiącu nie przekracza pojemności magazynu.
o_pojemnosc_magazynu_mies{m in 2..miesiace}: ilosc_kukurydzy_magazyn[m-1] + kupiona_kukurydza[m] - sprzedana_kukurydza[m] <= pojemnosc_magazynu;
# Ogranicza ilość sprzedanej kukurydzy w każdym miesiącu do popytu na kukurydzę w danym miesiącu.
o_sprzedaz_kukurydzy{m in 1..miesiace}: sprzedana_kukurydza[m] <= popyt[m];  

data;
param miesiace:=4;
param pojemnosc_magazynu:= 200;
param gotowka_poczatkowa:= 2000;
param kukurydza_poczatkowa:= 100;
param popyt:= 1 50 2 75 3 100 4 80;
param koszt_kupna:= 1 200 2 100 3 200 4 300; 
param cena_kupna:= 1 320 2 300 3 250 4 400;

solve;
display zysk, gotowka, kupiona_kukurydza, sprzedana_kukurydza, ilosc_kukurydzy_magazyn;
end;
