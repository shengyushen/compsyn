open List

let starttime=ref (Unix.gettimeofday ());;
let oldtime=ref (Unix.gettimeofday ());;

let set_current_time = begin
	starttime := Unix.gettimeofday ();
	oldtime := Unix.gettimeofday ()
end
and	dbg_print str = begin
	let current_time=Unix.gettimeofday () in begin
		Printf.printf "dbg_print : %s  time %5f delta %5f\n" str (current_time -. (!starttime)) (current_time -. (!oldtime)) ;
		flush stdout;
		oldtime := current_time
	end
end
and getLines filename = begin
	let file_c = open_in filename
	in
	let rec getLines_internal  i = begin
		let (newln,tf)= begin
			try 
				let ln=input_line file_c
				in
				(ln,true)
			with End_of_file ->
				("",false)
		end
		in begin
			if(tf) then 
				newln::(getLines_internal i)
			else []
		end
	end
	in
	let lines=getLines_internal 0
	in 
	begin
		close_in file_c;
		lines
	end
end
and int2bool i = begin
	match i with
	0 -> false
	|1 -> true
	|_ -> assert false
end
let string_equ str1 str2 = begin
  if (String.compare str1 str2) ==0 then true
	else false
end

let rec string2charlist str = begin
	let ll = String.length str
	in begin
		if ll!= 0 then begin
(String.get str 0)::(string2charlist (String.sub str 1 (ll-1)))
		end
		else []
	end
end
