option solver cplex;
reset;

# Parametry
param n > 0 integer;  	# Liczba dostępnych upraw - numer uprawy
param cena{1..n};  		# Cena za tonę każdej uprawy
param wydajność{1..n};  # Wydajność (tony z hektara) każdej uprawy
param praca{1..n};  	# Liczba godzin pracy potrzebnych do obsiania jednego hektara każdej uprawy
param popyt{1..n};  	# Maksymalny popyt na każdą uprawę (w tonach)
param pole_limit;  		# Limit powierzchni pola (hektary)
param godz_limit;  		# Limit dostępnych godzin pracy
param koszt_godziny;  	# Koszt godziny pracy (USD)

# Zmienna decyzyjna - Ilość hektarów przeznaczonych na produkcję każdej z upraw
var hektary{i in 1..n} >= 0, <= popyt[i] / wydajność[i];  

# Funkcja celu - zmaksymalizowanie zysku z uwzględnieniem kosztów i godzin pracy
maximize zysk: sum{i in 1..n} (cena[i] * wydajność[i] * hektary[i])  - sum{i in 1..n} (praca[i] * koszt_godziny * hektary[i]);  

# Ograniczenia
o_pole: sum{i in 1..n} hektary[i] <= pole_limit;  			# Powierzchnia pola
o_godz: sum{i in 1..n} praca[i] * hektary[i] <= godz_limit; # Dostępne godziny pracy

data;
param n := 3;
param pole_limit := 100;  
param godz_limit := 1400;
param koszt_godziny := 10;
param: cena wydajność praca popyt := 
	1 	30 		10 	   12 	560 
	2 	50 		8 	   20 	480 
	3 	40 		5 	   7 	500;
	
solve;
display zysk, hektary;
# Wynik: zysk = 18061.5
# hektary
# 1  56
# 2  32.3077
# 3  11.6923

end;