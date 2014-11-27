
let string_equ str1 str2 =
	if (String.compare str1 str2) ==0 then true
	else false

let uniquenamereg = ref 0;;

let unique_name_generator () =
  uniquenamereg :=  !uniquenamereg + 1 ;
  String.concat "" ["uniq_";    (string_of_int !uniquenamereg )];;

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
