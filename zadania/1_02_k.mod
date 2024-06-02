option solver cplex;
reset;

# Parametry
param uprawa > 0 integer;  	# Liczba dostępnych upraw - numer uprawy
param cena{1..uprawa};  	# Cena za tonę każdej uprawy
param wydajność{1..uprawa}; # Wydajność (tony z hektara) każdej uprawy
param praca{1..uprawa};  	# Liczba godzin pracy potrzebnych do obsiania jednego hektara każdej uprawy
param popyt{1..uprawa};  	# Maksymalny popyt na każdą uprawę (w tonach)
param pole_limit;  			# Limit powierzchni pola (hektary)
param godz_limit;  			# Limit dostępnych godzin pracy
param koszt_godziny;  		# Koszt godziny pracy (USD)

# Zmienna decyzyjna - Ilość hektarów przeznaczonych na produkcję każdej z upraw
var hektary{i in 1..uprawa} >= 0, <= popyt[i] / wydajność[i];  

# Funkcja celu - Zmaksymalizowanie zysku z uwzględnieniem kosztów produkcji i pracy.
maximize zysk: sum{i in 1..uprawa} (cena[i] * wydajność[i] * hektary[i])  - sum{i in 1..uprawa} (praca[i] * koszt_godziny * hektary[i]);  

# Ograniczenia
o_pole: sum{i in 1..uprawa} hektary[i] <= pole_limit;  			 # Suma ilości hektarów przeznaczonych na każdą uprawę nie może przekroczyć limitu powierzchni pola.
o_godz: sum{i in 1..uprawa} praca[i] * hektary[i] <= godz_limit; # Suma godzin pracy potrzebnych do obsiania każdego hektara każdej uprawy nie może przekroczyć dostępnych godzin pracy.

data;
param uprawa := 3;
param pole_limit := 100;  
param godz_limit := 1400;
param koszt_godziny := 10;
param: cena wydajność praca popyt :=  	1 	30 		10 	   12 	560 
										2 	50 		8 	   20 	480 
										3 	40 		5 	   7 	500;
solve;
display zysk, hektary;
end;