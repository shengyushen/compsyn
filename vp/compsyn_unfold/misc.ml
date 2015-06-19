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
;;
let rec  intstr2lst01 str = begin
	let len = String.length str 
	in begin
		if(len >0) then begin
			let hd= String.sub str 0 1
			in 
			let hdv = begin
				if(hd= "0" ) then 0
				else if(hd = "1") then 1
				else assert false
			end
			in
			let remainlst = intstr2lst01 (String.sub str 1 ((String.length str)-1))
			in
			hdv::remainlst
		end
		else []
	end
end
