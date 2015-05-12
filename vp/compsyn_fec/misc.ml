open List

let starttime=ref (Unix.gettimeofday ());;
let oldtime=ref (Unix.gettimeofday ());;

let set_current_time = begin
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
and isGF defname = begin
	if(
	defname="gfadd_mod" ||
	defname="gfdiv_mod" ||
	defname="gfmult_flat_mod" ||
	defname="gfmult_mod" ||
	defname="tower2flat" ||
	defname="flat2tower"
	) then 
		true
	else false
end
