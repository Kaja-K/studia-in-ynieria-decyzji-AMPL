option solver cplex;
reset;

# Zmienne decyzyjne
var x1 >= 0, <=50;   # Ilość indyków typu 1
var x2 >= 0, <=30;   # Ilość indyków typu 2
var y1 >= 0;   		 # Ilość kotletów typu I
var y2 >= 0;   		 # Ilość kotletów typu II

# Funkcja celu do zmaxymalizowania
maximize Profit: (8*x1 + 6*x2) - (10*y1 + 8*y2);

# Ograniczenia
subject to
O_w: 3*y1 + 1.5*y2 >= 0.7*x1 + 0.5*x2;
O_d: 2*y1 + 4*y2 >= 0.3*x1 + 0.5*x2;

solve;

display x1, x2, y1, y2, Profit;
# Wynik: x1 = 50, x2 = 30, y1 = 16.6667, y2 = 0, Profit = 413.333


end;

