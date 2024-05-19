option solver cplex;
reset;

# Zmienne decyzyjne
var telewizory_27 >= 0, <= 20;  # Liczba wyprodukowanych telewizorów 27 calowych, ograniczona do maksimum 20 sztuk
var telewizory_20 >= 0, <= 40;  # Liczba wyprodukowanych telewizorów 20 calowych, ograniczona do maksimum 40 sztuk

# Funkcja celu - Maksymalizacja całkowitego zysku
maximize zysk: 120*telewizory_27 + 80*telewizory_20;  

# Ograniczenie - Dostępne godziny robocze
o_godziny: 20*telewizory_27 + 10*telewizory_20 <= 500;  

solve;
display zysk, telewizory_27, telewizory_20; 
# Wynik: zysk = 3800
# TV27 = 5 
# TV20 = 40 

end;