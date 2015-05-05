let starttime=ref (Unix.gettimeofday ());;
let oldtime=ref (Unix.gettimeofday ());;

let string_equ str1 str2 =
	if (String.compare str1 str2) ==0 then true
	else false

let rec uniqlst lst =begin
	match lst with
	[] -> []
	| hd::tl -> begin
		if (List.mem hd tl) then uniqlst tl else hd::(uniqlst tl)
	end
end
and lst_lastn lst n = begin
	match lst with
	[] -> begin
		if n==0 then []
		else begin
			Printf.printf "fatal error : improper length\n";
			exit 1
		end
	end
	| hd::tl -> begin
		if (List.length lst) == n then lst
		else lst_lastn tl n
	end
end
and string2charlist str = begin
	let ll = String.length str
	in begin
		if ll!= 0 then begin
(String.get str 0)::(string2charlist (String.sub str 1 (ll-1)))
		end
		else []
	end
end
and isEmptyList lst = begin
	match lst with
	[] -> true
	| _ -> false
end
and isSingularList lst = begin
	match lst with
	[z] -> true
	| _ -> false
end
and listPartition iselim lst = begin
	let rec listPartition_internal currentlist = begin
		match currentlist with
		hd::tl -> begin
			let (remainCurrentList,remainList)=listPartition_internal tl
			in begin
				if(iselim hd) then ([],remainCurrentList::remainList)
				else (hd::remainCurrentList,remainList)
			end
		end
		| _ -> ([],[])
	end
	in
	listPartition_internal lst
end
and set_current_time = begin
	starttime := Unix.gettimeofday ();
	oldtime := Unix.gettimeofday ()
end
and	dbg_print str = begin
	let current_time=Unix.gettimeofday () in begin
		Printf.printf "dbg_print : %s\t\t\ttime %5f delta %5f\n" str (current_time -. (!starttime)) (current_time -. (!oldtime)) ;
		flush stdout;
		oldtime := current_time
	end
end
and errorMessageQuit msg = begin
	Printf.printf "Error : %s\n" msg;
	exit 0
end
