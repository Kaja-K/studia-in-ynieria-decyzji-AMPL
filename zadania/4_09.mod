# Rozwiązanie matematyczne 
# https://politechnikawroclawska-my.sharepoint.com/:o:/g/personal/273947_student_pwr_edu_pl/EtFH9iO97GhMrp2z18EjIMoBd3SWVSkvO_hEF7c72bDUFA?e=W1H7p4

option solver cplex;
reset;

# Zmienne decyzyjne
var x1 >=0 integer;
var x2 >=0 integer;

# Funkcja celu
maximize zysk: 5*x1 + 4*x2;

# Ograniczenia
o_1:x1 + x2 <= 5;
o_2:10*x1 + 6*x2 <=45;

solve;
display zysk, x1,x2;
# Wynik:zysk = 23
# x1 = 3
# x2 = 2

end;