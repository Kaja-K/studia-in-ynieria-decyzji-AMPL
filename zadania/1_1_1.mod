option solver cplex;
reset;

# Definicja zmiennych decyzyjnych
var TV27 >= 0, <= 20;  # Telewizory 27 calowe
var TV20 >= 0, <= 40;  # Telewizory 20 calowe

# Funkcja celu do zmaksymalizowania zysku
maximize Profit: 120*TV27 + 80*TV20; 

# Ograniczenia - Dostępne godziny robocze
subject to Labor_Hours: 20*TV27 + 10*TV20 <= 500;

solve;

display TV27, TV20, Profit; 
# Wynik: TV27 = 5, TV20 = 40, Profit = 3800

end;