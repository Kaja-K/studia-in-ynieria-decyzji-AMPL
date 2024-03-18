option solver cplex;
reset;

# Zmienne decyzyjne
var x_82{1..3}>=0;     	# Ilość 82 w danym typie benzyny
var x_98{1..3}>=0;		# Ilość 98 w danym typie benzyny

# Funkcja celu - maksymalizacja całkowitego zysku, porzychody ze sprzedaży poszczególnych benzyn
maximize zysk: 6.7 * (x_82[1]+x_98[1]) + 9.2 * (x_82[2]+x_98[2]) + 8.1 * (x_82[3]+x_98[3]);

# Ograniczenia
subject to 
o_popyt87: x_82[1] + x_98[1]<= 50000; 											# Popyt na benzynę 82 i 98 w typie normalna
o_popyt89: x_82[2] + x_98[2]<= 30000; 											# Popyt na benzynę 82 i 98 w typie premium
o_popyt92: x_82[3] + x_98[3]<= 40000; 											# Popyt na benzynę 82 i 98 w typie super
o_min87: (82* x_82[1] + 98 * x_98[1]) >= 87 * (x_82[1] + x_98[1]); 				# Minimalna ilość benzyny 82 i 98 w typie normalna
o_min89: (82* x_82[2] + 98 * x_98[2]) >= 89 * (x_82[2] + x_98[2]); 				# Minimalna ilość benzyny 82 i 98 w typie premium
o_min92: (82* x_82[3] + 98 * x_98[3]) >= 92 * (x_82[3] + x_98[3]); 				# Minimalna ilość benzyny 82 i 98 w typie super
o_dz: 5* (x_82[1]+x_82[2]+x_82[3]) +10 * (x_98[1]+ x_98[2] + x_98[3]) <=1500000;# Całkowity dzienny popyt na benzynę
o_przetwarzania: 2 * (x_98[1]+ x_98[2] + x_98[3]) <= 200000; 					# Przetwarzanie benzyny 98

solve;
display x_82, x_98, zysk;
# Wynik: 	 x_82    x_98    
# normalna  34375   15625
# premium   16875   13125
# super   	15000   25000
# zysk = 93500000

end;
