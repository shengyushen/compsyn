open Printf
open Unix

let get_time_string = begin
	let cur_tm = localtime (time ())
	in 
	sprintf "%d %d %d %d %d %d" (cur_tm.tm_year+1900) (cur_tm.tm_mon+1) cur_tm.tm_mday cur_tm.tm_hour cur_tm.tm_min cur_tm.tm_sec
end
and list_iter_with_sep lst itrfun sepfun = begin
	let rec list_iter_with_sep_internal lst itrfun sepfun = begin
		match lst with
		[hd] -> begin
			itrfun hd
		end
		| hd::tl -> begin
			itrfun hd;
			sepfun () ;
			list_iter_with_sep_internal tl itrfun sepfun
		end
		| _ -> assert false 
	end
	in 
	list_iter_with_sep_internal lst itrfun sepfun
end
and list_iter_with_comma lst itrfun fc = begin
	let rec list_iter_with_sep_internal lst itrfun  = begin
		match lst with
		[hd] -> begin
			itrfun hd
		end
		| hd::tl -> begin
			itrfun hd;
			fprintf fc " , " ;
			list_iter_with_sep_internal tl itrfun 
		end
		| _ -> assert false 
	end
	in 
	list_iter_with_sep_internal lst itrfun 
end
and isempty lst = begin
	match lst with
	hd::tl -> false
	| _ -> true
end
and isnotempty lst = begin
	match lst with
	hd::tl -> true
	| _ -> false
end
