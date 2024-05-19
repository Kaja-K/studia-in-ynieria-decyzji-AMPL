# Rozwiązanie matematyczne 
# https://politechnikawroclawska-my.sharepoint.com/:o:/g/personal/273947_student_pwr_edu_pl/EtFH9iO97GhMrp2z18EjIMoBd3SWVSkvO_hEF7c72bDUFA?e=W1H7p4

option solver cplex;
reset;

# Zmienne decyzyjne
var x1 >=0 integer;
var x2 >=0 integer;
var x3 >=0 integer;

# Funkcja celu
maximize zysk: 18*x1 + 14*x2 + 8*x3;

# Ograniczenie
o_1: 15*x1 + 12*x2 + 7*x3<=43;

solve;
display zysk, x1,x2,x3;
# Wynik:zysk = 50
# x1 = 1
# x2 = 0
# x3 = 4

end;