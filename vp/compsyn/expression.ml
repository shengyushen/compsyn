open Typedef

let rec exp2int_simple exp = begin
	match exp with
	T_primary(prim) -> prim2int_simple prim
	| T_add1(prim) -> prim2int_simple prim
	| T_sub1(prim) -> -1*(prim2int_simple prim)
	| T_add2(expl,expr) -> (exp2int_simple expl)+(exp2int_simple expr)
	| T_sub2(expl,expr) -> (exp2int_simple expl)-(exp2int_simple expr)
	| T_mul2(expl,expr) -> (exp2int_simple expl)*(exp2int_simple expr)
	| _ -> begin
		Printf.printf "fatal error : exp2int_simple not proper\n";
		exit 1
	end
end
and prim2int_simple prim = begin
	match prim with
	T_primary_num(num) -> num2int_simple num
	| T_primary_minmaxexp(T_mintypmax_expression_1(exp)) -> exp2int_simple exp
	| _ -> begin
		Printf.printf "fatal error : prim2int_simple not proper\n";
		exit 1
	end
end
and num2int_simple num = begin
	match num with
	T_number_unsign(i) -> i
	| _ -> begin
		Printf.printf "fatal error : num2int_simple not proper\n";
		exit 1
	end
end
