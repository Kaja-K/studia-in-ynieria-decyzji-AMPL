option solver cplex;
reset;

# Zmienne decyzyjne
var indyk_1 >= 0, integer;   		 # Ilość indyków typu 1 (ograniczenie na ilość)
var indyk_2 >= 0, integer;   		 # Ilość indyków typu 2 (ograniczenie na ilość)
var kotlet_1 >= 0, <= 50, integer;   # Ilość kilogramów kotletów typu I
var kotlet_2 >= 0, <= 30, integer;   # Ilość kilogramów kotletów typu II

# Funkcja celu do zmaksymalizowania zysku (koszt produkcji - przychód z sprzedaży)
maximize zysk: (8*kotlet_1 + 6*kotlet_2) - (10*indyk_1 + 8*indyk_2); 

# Ograniczenia
subject to
o_white: 3*indyk_1 + 1.5*indyk_2 >= 0.7*kotlet_1 + 0.5*kotlet_2;  	# Zawartość mięsa białego
o_dark: 2*indyk_1 + 4*indyk_2 >= 0.3*kotlet_1 + 0.5*kotlet_2;    	# Zawartość mięsa ciemnego

solve;
display indyk_1, indyk_2, kotlet_1, kotlet_2, zysk;
# WYnik: indyk_1 = 17 ,indyk_2 = 0 ,kotlet_1 = 50 ,kotlet_2 = 30 ,zysk = 410

end;
