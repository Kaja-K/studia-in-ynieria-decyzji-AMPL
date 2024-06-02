# Rozwiązanie matematyczne 
# https://politechnikawroclawska-my.sharepoint.com/:o:/g/personal/273947_student_pwr_edu_pl/EtFH9iO97GhMrp2z18EjIMoBd3SWVSkvO_hEF7c72bDUFA?e=W1H7p4


# 4.09 
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
	

# 4.10
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
	

# 4.11
	option solver cplex;
	reset;
	
	# Zmienne decyzyjne
	var x1 >=0 binary;
	var x2 >=0 binary;
	var x3 >=0 binary;
	var x4 >=0 binary;
	var x5 >=0 binary;
	
	# Funkcja celu
	maximize zysk: 8*x1 + 4*x2 + 5*x3 + 4*x4 + x5;
	
	# Ograniczenie
	o_1: 9*x1 + 6*x2 + 5*x3 + 2*x4 + x5<=13;
	
	solve;
	display zysk, x1,x2,x3,x4,x5;

end;