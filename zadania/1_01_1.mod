option solver cplex;
reset;

# Definicja zmiennych decyzyjnych
var telewizory_27 >= 0, <= 20;  # Liczba telewizorów 27 calowych 
var telewizory_20 >= 0, <= 40;  # Liczba telewizorów 20 calowych

# Funkcja celu do zmaksymalizowania zysku
maximize zysk: 120*telewizory_27 + 80*telewizory_20;  

# Ograniczenia - Dostępne godziny robocze
subject to o_godziny: 20*telewizory_27 + 10*telewizory_20 <= 500;  

solve;

display telewizory_27, telewizory_20, zysk; 
# Wynik: TV27 = 5, TV20 = 40, zysk = 3800

end;