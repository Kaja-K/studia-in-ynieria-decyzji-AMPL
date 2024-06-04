option solver cplex;
reset;

# Parametry
param uprawy > 0 integer; # Liczba dostępnych upraw - numer uprawy
param cena{1..uprawy}; # Cena za tonę każdej uprawy
param wydajność{1..uprawy}; # Wydajność (tony z hektara) każdej uprawy
param praca{1..uprawy}; # Liczba godzin pracy potrzebnych do obsiania jednego hektara każdej uprawy
param popyt{1..uprawy}; # Maksymalny popyt na każdą uprawę (w tonach)
param pole_limit; # Limit powierzchni pola (hektary)
param godz_limit; # Limit dostępnych godzin pracy
param koszt_godziny; # Koszt godziny pracy (USD)

# Zmienna decyzyjna - Ilość hektarów przeznaczonych na produkcję każdej z upraw
var hektary{u in 1..uprawy} >= 0, <= popyt[u] / wydajność[u];  

# Funkcja celu - Zmaksymalizowanie zysku z uwzględnieniem kosztów produkcji i pracy.
maximize zysk: sum{u in 1..uprawy} (cena[u] * wydajność[u] * hektary[u]) - sum{u in 1..uprawy} (praca[u] * koszt_godziny * hektary[u]);  

# Ograniczenia
# Suma ilości hektarów przeznaczonych na każdą uprawę nie może przekroczyć limitu powierzchni pola.
o_pole: sum{u in 1..uprawy} hektary[u] <= pole_limit;
# Suma godzin pracy potrzebnych do obsiania każdego hektara każdej uprawy nie może przekroczyć dostępnych godzin pracy.
o_godz: sum{u in 1..uprawy} praca[u] * hektary[u] <= godz_limit;

data;
param uprawy := 3;
param pole_limit := 100;  
param godz_limit := 1400;
param koszt_godziny := 10;
param: cena wydajność praca popyt := 
		1 30 10 12 560 
		2 50 8 20 480 
		3 40 5 7 500;

solve;
display zysk, hektary;
end;